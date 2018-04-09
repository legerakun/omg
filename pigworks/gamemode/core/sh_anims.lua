local char = FindMetaTable("Player")

if SERVER then
util.AddNetworkString("PW_RSO")
util.AddNetworkString("PW_WA")
util.AddNetworkString("PW_ANG")
util.AddNetworkString("PW_ANS")

net.Receive("PW_RSO",function(_,ply)
local seq = net.ReadString()
if !Schema.AnimationList[seq] or ply:GetVelocity():Length2D() > 0 then return end
ply.LastSetSeq = ply.LastSetSeq or CurTime()-1
if ply.LastSetSeq > CurTime() then return end
ply.LastSetSeq = CurTime()+2
ply:SetSeqOverride(seq)
end)

hook.Add( "KeyPress", "PW_StopAnim", function( ply, key )
local seq = ply:GetOverride()
  if seq then
    ply:SetSeqOverride(nil)
  end
end )

function char:AnimNetworkedGesture(slot, act, loop)
  self:AnimRestartGesture(slot, act, loop)
  net.Start("PW_ANG")
  net.WriteEntity(self)
  net.WriteFloat(slot)
  net.WriteFloat(act)
  net.WriteBool(loop or false)
  net.Broadcast()
end

function char:AnimNetworkedSeq(slot, seq, cycle, kill)
  local sequence = seq
  if type(sequence) == "string" then
    sequence = self:LookupSequence(seq)
  end
  --
  self:AddVCDSequenceToGestureSlot( slot, sequence, cycle, kill )
  net.Start("PW_ANS")
  net.WriteEntity(self)
  net.WriteFloat(slot)
  net.WriteFloat(sequence)
  net.WriteFloat(cycle)
  net.WriteBool(kill)
  net.Broadcast()
end

function char:SetAnimSet(set)
  if set == nil then
    self:SetNWString("AnimSet","")
  return end
self:SetNWString("AnimSet",set)
end

function char:SetSeqOverride(index)
local tbl = {IN_FORWARD,IN_BACK,IN_RIGHT,IN_LEFT,IN_ATTACK,IN_ATTACK2,IN_DUCK,IN_JUMP}
local keydown = nil
--
  for k,v in pairs(tbl) do
    if self:KeyDown(v) then
	  keydown = true
	  break
	end
  end
--
  if index == nil or keydown then
    self:SetNWString("AnimationIndex","")
    self:SetNWString("AnimationOverride","")    
    return 
  end
local str = Schema.AnimationList[index].Seq
self:SetNWString("AnimationIndex",index)
self:SetNWString("AnimationOverride",str)
end

  concommand.Add("PW_SetMaterial",function(ply,cmd,args)
    if !ply:IsSuperAdmin() then return end
	if !args or !args[1] or !args[2] then return end
	local thePly = pig.FindPlayerByName(args[1])
	if !IsValid(thePly) then return end
    thePly:SetMaterial(args[2])
  end)

  concommand.Add("PW_SetPlayerModel",function(ply,cmd,args)
    if !ply:IsSuperAdmin() then return end
	if !args or !args[1] or !args[2] then return end
	local thePly = pig.FindPlayerByName(args[1])
	if !IsValid(thePly) then return end
    thePly:SetModel(args[2])
  end)

  concommand.Add("PW_NPCSetModel",function(ply,cmd,args)
    if !ply:IsSuperAdmin() then return end
	local ent = ply:GetEyeTrace().Entity
	if !IsValid(ent) then return end
	ent:SetModel(args[1])
  end)
  
  concommand.Add("PW_SetAnimSet",function(ply,cmd,args)
    if !ply:IsSuperAdmin() then return end
	if !args[1] then return end
	local thePly = pig.FindPlayerByName(args[1])
	thePly:SetAnimSet(args[2])
  end)
end

function char:GetOverride()
local override = self:GetNWString("AnimationOverride","")
local index = self:GetNWString("AnimationIndex","")
if override == "" or index == "" then return end
--
local new_override,duration = self:LookupSequence(override)
if new_override == -1 then return end
  if Schema.AnimationList[index].Loop then
    duration = "loop"
  end
return new_override,duration,index
end

function char:GetAnimSet()
local set = self:GetNWString("AnimSet","")
if set == "" or !Schema.AnimationSet[set] then return end
return set
end

function char:GetAnimHoldtype()
local wep = {}
wep["weapon_pistol"] = "pistol"
wep["weapon_357"] = "revolver"
wep["weapon_ar2"] = "ar2"
wep["weapon_bugbait"] = "normal"
wep["weapon_crossbow"] = "crossbow"
wep["weapon_crowbar"] = "melee"
wep["weapon_frag"] = "grenade"
wep["weapon_physcannon"] = "physgun"
wep["weapon_rpg"] = "rpg"
wep["weapon_shotgun"] = "shotgun"
wep["weapon_slam"] = "slam"
wep["weapon_smg1"] = "smg"
wep["weapon_stunstick"] = "melee"
wep["weapon_fists"] = "fist"
wep["weapon_physgun"] = "physgun"
wep["gmod_camera"] = "camera"
wep["weapon_medkit"] = "slam"
--
local actwep = self:GetActiveWeapon()
local holdtype = "normal"
  if IsValid(actwep) then
    if wep[actwep:GetClass()] then
	  holdtype = wep[actwep:GetClass()]
	elseif pig.utility.IsFunction(actwep.GetPigHoldType) then
	  holdtype = actwep:GetPigHoldType()
	elseif actwep.HoldType then
	  holdtype = actwep.HoldType
	end

	if pig.utility.IsFunction(actwep.IsHolstered) then
	  if actwep:IsHolstered() then
	    holdtype = "passive"
		  if pig.utility.IsFunction(actwep.AnimHoltserHoldType) then
		    holdtype = actwep.AnimHoltserHoldType(actwep)
		  end
	  end
	end
  end
return holdtype
end

function char:GetCurrentAnim(act)
local tbl = Schema.AnimationSet[self:GetAnimSet()]
--
local tab = {}
tab[ACT_MP_STAND_IDLE] = "idle"
tab[ACT_MP_SWIM] = "swim"
tab[ACT_MP_SWIM_IDLE] = "swim_idle"
tab[ACT_MP_WALK] = "walk"
tab[ACT_MP_RUN] = "run"
tab[ACT_MP_JUMP] = "jump"
tab[ACT_MP_CROUCHWALK] = "crouch_walk"
tab[ACT_MP_CROUCH_IDLE] = "crouch_idle"
if !tab[act] then return end
--
local holdtype = self:GetAnimHoldtype()
--
local str = tab[act].."_"..holdtype
  if !tbl[str] then
    str = tab[act].."_normal"
  end
if !tbl[str] then return end
--
local anim = tbl[str]
local act = false
  if tonumber(anim) != nil then
    act = true
    anim = tonumber(anim)
  else
    anim = self:LookupSequence(anim)
  end
return anim,act,str
end

function IsValidPigSequence(seq)
  for k,v in pairs(Schema.AnimationList) do
    if v.Seq == seq then return true end
  end
end

function GM:CalcMainActivity(ply,velocity)
local set = ply:GetAnimSet()
pig.OldCalcActivity(self,ply,velocity)
--
local override,duration = ply:GetOverride()
--
  if override then
    ply.CalcSeqOverride = override
	if !ply.DestroySeq and duration != "loop" then
	  ply.DestroySeq = CurTime() + duration
	elseif ply.DestroySeq and duration == "loop" then
	  ply.DestroySeq = nil
	end
	if ply.DestroySeq and ply.DestroySeq <= CurTime() then
	  if SERVER then
	    ply:SetSeqOverride(nil)
	  end
	  ply.DestroySeq = nil
	  ply.CalcSeqOverride = nil
	end
  end
--
--WALK/RUN ANIM OVERRIDE
local str = nil
  if set and !override then
    local current_anim,act,strname = ply:GetCurrentAnim(ply.CalcIdeal)
	str = strname
	if current_anim and act then
	  ply.CalcIdeal = current_anim
	elseif current_anim and !act then
	  ply.CalcSeqOverride = current_anim
	end
	local tab = Schema.AnimationSet[set]
	local newanim,act = hook.Call("pig_SetNewAnim",GAMEMODE,ply,current_anim,act,strname)
	if newanim then
	  if act then
	    ply.CalcIdeal = newanim
	  else
	    ply.CalcSeqOverride = newanim
		ply.CalcIdeal = -1
	  end
	end
	local eyeAngles = ply:EyeAngles()
    local yaw = velocity:Angle().yaw
    local normalized = math.NormalizeAngle(yaw - eyeAngles.y)
    ply:SetPoseParameter("move_yaw", normalized)
	if tab.PoseFunc then
	  tab.PoseFunc(ply,velocity)
	end
  end
--
return ply.CalcIdeal, ply.CalcSeqOverride
end

--------------------------------------

if CLIENT then

function char:RequestSeqOverride(str)
if self != LocalPlayer() then return end
local override,dur,index = self:GetOverride()
  if index and index == str then
    return
  end
net.Start("PW_RSO")
net.WriteString(str)
net.SendToServer()
end

function pig.CreateAnimationMenu(f2,space)
local animations = vgui.Create("DPanel")
animations:SetSize(f2:GetWide(),f2:GetTall()*3)
local fx,fy = f2:GetPos()
animations:SetPos((fx + f2:GetWide()) + (space),0)
animations:CenterVertical()
  animations.Paint = function(me)
    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,100))
    surface.SetDrawColor(Schema.GameColor)
	surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
  end
  animations.Think = function(me)
    if !IsValid(f2) then
	  me:Remove()
	  return
	end
  end
local animlist = vgui.Create("pig_PanelList",animations)
animlist:SetSize(animations:GetWide()*.8,animations:GetTall()*.9)
animlist:Center()
  for k,v in SortedPairs(Schema.AnimationList or {}) do
    local base = pig.CreateButton(nil,k,"PigFont")
	base:SetSize(animlist:GetWide(),animlist:GetTall()/11)
	base.DoClick = function(me)
	  LocalPlayer():RequestSeqOverride(k)
	  f2:Remove()
	end
	animlist:AddItem(base)
  end
end

net.Receive("PW_ANS", function()
local ply = net.ReadEntity()
local slot = net.ReadFloat()
local seq = net.ReadFloat()
local cycle = net.ReadFloat()
local kill = net.ReadBool()

ply:AddVCDSequenceToGestureSlot( slot, seq, cycle, kill )
end)

net.Receive("PW_ANG", function()
local ply = net.ReadEntity()
local slot = net.ReadFloat()
local act = net.ReadFloat()
local loop = net.ReadBool()
if !ply.AnimRestartGesture then return end
ply:AnimRestartGesture(slot, act, loop)
end)

concommand.Add("PW_PoseParamList",function(ply)
if !ply:IsAdmin() then return end
local ent = ply
  for i=0, ent:GetNumPoseParameters() - 1 do
	local min, max = ent:GetPoseParameterRange( i )
	print( ent:GetPoseParameterName( i ) .. ' ' .. min .. " / " .. max )
  end
end)

concommand.Add("PW_MdlSeqList",function(ply)
if !ply:IsAdmin() then return end
local sequences = ply:GetSequenceList()
PrintTable(sequences)
end)

concommand.Add("PW_MdlActList",function(ply)
if !ply:IsAdmin() then return end
local sequences = ply:GetSequenceList()
  for k,v in pairs(sequences) do
    local act = ply:LookupSequence(v)
	local actname = ply:GetSequenceActivityName( act )
	act = ply:GetSequenceActivity(act)
    v = {Seq = v, ActName = actname, Act = act}
	sequences[k] = v
  end
PrintTable(sequences)
end)

end

--------------------------------------
function pig:OldCalcActivity(ply,velocity)
	ply.CalcIdeal = ACT_MP_STAND_IDLE
	ply.CalcSeqOverride = -1

	self:HandlePlayerLanding( ply, velocity, ply.m_bWasOnGround )

	if ( self:HandlePlayerNoClipping( ply, velocity ) ||
		self:HandlePlayerDriving( ply ) ||
		self:HandlePlayerVaulting( ply, velocity ) ||
		self:HandlePlayerJumping( ply, velocity ) ||
		self:HandlePlayerSwimming( ply, velocity ) ||
		self:HandlePlayerDucking( ply, velocity ) ) then

	else

		local len2d = velocity:Length2D()
		if ( len2d > 150 ) then ply.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.5 ) then ply.CalcIdeal = ACT_MP_WALK end

	end

	ply.m_bWasOnGround = ply:IsOnGround()
	ply.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )

	return ply.CalcIdeal, ply.CalcSeqOverride
end

function GM:HandlePlayerLanding( ply, velocity, WasOnGround )

	if ( ply:GetMoveType() == MOVETYPE_NOCLIP ) then return end

	if ( ply:IsOnGround() && !WasOnGround ) then
	    local act = ACT_LAND
		local set = Schema.AnimationSet
		  if set then
		    set = set[ply:GetAnimSet()]
		  end
		local holdtype = ply:GetAnimHoldtype()
		  if set and !set["jump_land_"..holdtype] then
		    holdtype = "normal"
		  end
		  if set and set["jump_land_"..holdtype] then
		    act = set["jump_land_"..holdtype]
			if type(act) == "string" then
			  act = ply:GetSequenceActivity( ply:LookupSequence(act) )
			end
		  end
		ply:AnimRestartGesture( GESTURE_SLOT_JUMP, act, true )
	end

end

function GM:DoAnimationEvent( ply, event, data )
local animset = ply:GetAnimSet()
  if !animset then
    pig.OldDoAnimEvent(self,ply,event,data)
	return
  end
-----
  local holdtype = ply:GetAnimHoldtype()
  local gest = Schema.AnimationSet[animset][holdtype]
  local attackgest = nil
  local reloadgest = nil
  --
  local new_ag = hook.Call("pig_SetNewAttack", GAMEMODE, ply, holdtype, event, data)
  local new_re = hook.Call("pig_SetNewReload", GAMEMODE, ply, holdtype, event, data)
  if new_ag then
    attackgest = new_ag
  end
  if new_re then
    reloadgest = new_re
  end
  --
  if !attackgest and gest then
    attackgest = gest.attack
    if type(attackgest) == "table" then
	  ply.AnimEventGest = ply.AnimEventGest or 0
      ply.AnimEventGest = ply.AnimEventGest+1
	  local count = table.Count(attackgest)
	  if ply.AnimEventGest > count then
	    ply.AnimEventGest = 1
	  end
      attackgest = attackgest[ply.AnimEventGest]
    end
  end
  if !reloadgest and gest then
    reloadgest = gest.reload
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and type(reloadgest) == "table" then
      local class = wep:GetClass()	
	  if reloadgest[class] then
	    reloadgest = reloadgest[class]
	  else
	    reloadgest = table.Random(reloadgest)
	  end
	elseif type(reloadgest) == "table" then
      reloadgest = table.Random(reloadgest)
    end  
  end
  --
  if ( event == PLAYERANIMEVENT_RELOAD ) and pig.utility.IsFunction(reloadgest) then
    reloadgest(ply, event, data)
	reloadgest = nil
  end
  --
  /*
    if type(attackgest) == "string" then
	  local sid = ply:LookupSequence(attackgest)
      local act = ply:GetSequenceActivity( sid )
	  if CLIENT then
	    print("Gest: "..attackgest.."  ACT: "..tostring(act))
	  end
	  attackgest = act
	end

    if type(reloadgest) == "string" then
	  local sid = ply:LookupSequence(reloadgest)
      local act = ply:GetSequenceActivity( sid )
	  reloadgest = act
	end  
*/
	if ( event == PLAYERANIMEVENT_ATTACK_PRIMARY ) then
	  if attackgest then
	    if type(attackgest) == "string" then
		  ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, ply:LookupSequence(attackgest), 0, true )
		else
	      ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, attackgest, true )
		end
	  end
	return ACT_VM_PRIMARYATTACK
	
	elseif ( event == PLAYERANIMEVENT_ATTACK_SECONDARY ) then
	
		-- there is no gesture, so just fire off the VM event
		return ACT_VM_SECONDARYATTACK
		
	elseif ( event == PLAYERANIMEVENT_RELOAD ) then
	   if reloadgest then
		 if type(reloadgest) == "string" then
		  ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, ply:LookupSequence(reloadgest), 0, true )
		else
	      ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, reloadgest, true )
		end
	  end
		return ACT_INVALID
		
	elseif ( event == PLAYERANIMEVENT_JUMP ) then
	
		ply.m_bJumping = true
		ply.m_bFirstJumpFrame = true
		ply.m_flJumpStartTime = CurTime()
	
		ply:AnimRestartMainSequence()
	
		return ACT_INVALID
	
	elseif ( event == PLAYERANIMEVENT_CANCEL_RELOAD ) then
	
		ply:AnimResetGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD )
		
		return ACT_INVALID
	end

end

function pig:OldDoAnimEvent(ply,event,data)

	if ( event == PLAYERANIMEVENT_ATTACK_PRIMARY ) then
	
		if ply:Crouching() then
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_CROUCH_PRIMARYFIRE, true )
		else
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_STAND_PRIMARYFIRE, true )
		end
		
		return ACT_VM_PRIMARYATTACK
	
	elseif ( event == PLAYERANIMEVENT_ATTACK_SECONDARY ) then
	
		-- there is no gesture, so just fire off the VM event
		return ACT_VM_SECONDARYATTACK
		
	elseif ( event == PLAYERANIMEVENT_RELOAD ) then
	
		if ply:Crouching() then
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH, true )
		else
			ply:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND, true )
		end
		
		return ACT_INVALID
		
	elseif ( event == PLAYERANIMEVENT_JUMP ) then
	
		ply.m_bJumping = true
		ply.m_bFirstJumpFrame = true
		ply.m_flJumpStartTime = CurTime()
	
		ply:AnimRestartMainSequence()
	
		return ACT_INVALID
	
	elseif ( event == PLAYERANIMEVENT_CANCEL_RELOAD ) then
	
		ply:AnimResetGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD )
		
		return ACT_INVALID
	end

end
