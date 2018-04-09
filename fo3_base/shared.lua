----------------
--INCLUDES
if SERVER then
  include("sh_recoil.lua")  
  AddCSLuaFile("sh_recoil.lua")
elseif CLIENT then
  include("sh_recoil.lua")  
end
//----------------------------------------------
//Author Info
//----------------------------------------------
SWEP.Author             = "extra.game"
SWEP.Contact            = "extra.game on Steam"
SWEP.Purpose            = "Self Defence"
SWEP.HoldType = "normal"
SWEP.Instructions       = ""
SWEP.HolsterAct = "normal"
SWEP.AimHoldType = "duel"
SWEP.FalloutWep = true
SWEP.IronVec = Vector(-1,-1,1)
SWEP.IronAng = Angle(0,0,0)
SWEP.IronSightTime = 0.35
SWEP.ViewModelFlip = false	--the default viewmodel won't be flipped
SWEP.ViewModelFlip1 = false	--the second viewmodel will
SWEP.ViewModel = "models/fallout/player/1stperson.mdl"
SWEP.ViewModel2 = "models/fallout/player/1stperson.mdl"
SWEP.Primary.Cone = 0.035
SWEP.Secondary.Damage = 0
SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.BobScale = 0.8
SWEP.SwayScale = 1
SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "CSSMuzzleFlashX"
SWEP.MuzzleAttachment                   = 2
SWEP.ShakingTime = 1
SWEP.ShakePos = Vector(0.7,0.2,0.1)
SWEP.ShakeAng = Angle(0,0,0)
-------------------------------
-------------------
function SWEP:FireAnimationEvent(pos, ang, event, options)
  if( event == 6001 ) and self.EnergyWep then return true; end
end

function SWEP:HasWepAmmo()
local ammotype = self.Primary.InvAmmo
  if ammotype then
    local name = Schema.InvNameTbl[ammotype] or ammotype
	if !self.Owner.Inventory[name] then
      return
    end	  
  end
return true
end

function SWEP:TakeAmmo()
if !SERVER then return end
local clip = self.Weapon:Clip1()
self.Weapon:SetClip1(clip - (self.Primary.AmmoTake or 1))
end

function SWEP:Initialize()
self:SortHoldType()
if CLIENT then
  local vm = self.Owner:GetViewModel()
  if IsValid(vm) and !self.NoInvis then
    vm:SetColor(Color(255,255,255,1))
    vm:SetMaterial("vgui/zoom")
  end
end
-----------
  if CLIENT then
    self:CreateHands()
    self:CreateWeapon(self.WeaponModel)
  end
-----------
self:SetNWString("WHoldtype",self.HoldType)
self:SortHoldType()
end

function SWEP:Deploy()
self.Owner:SetFOV(0, 0.1)
if CLIENT then
  local vm = self.Owner:GetViewModel()
  if IsValid(vm) then
    vm:SetColor(Color(255,255,255,1))
    vm:SetMaterial("vgui/zoom")
  end
end
-----------
  self.Holstering = false
  self:SetNWBool("Holstering",false)

  self:SortHoldType()
  if CLIENT then
    self:CreateHands()
    self:CreateWeapon(self.WeaponModel)
  end
  --
  if pig.utility.IsFunction(self.OnDeploy) then
	local ret = self:OnDeploy(viewmodel1)
	if ret == true then return true end
  end
  self:HolsterWeapon()  
-----------
return true
end

function SWEP:SortHand(vm)
if !CLIENT or self.Owner:CreatureName() then return end
  if !IsValid(vm.Sleeves) then
    local sleeves = ClientsideModel(self.Owner:GetModel())
	if !IsValid(sleeves) or !IsValid(vm) then return end
	sleeves:SetPos(vm:GetPos())
	sleeves:SetNoDraw(true)
	sleeves:SetAngles(vm:GetAngles())
	local tbl = {"Bip01 Neck1", "Bip01 Neck", "Bip01 Head", "Bip01 Spine", "Bip01 Spine1", "Bip01 Spine2"}
	  for k,v in pairs(tbl) do
	    local bone = sleeves:LookupBone(v)
		if !bone then print("BONE: "..v.." Does not exist!") continue end
	    sleeves:ManipulateBoneScale(bone, Vector(0,0,0))
	  end
	if self.PipOn then
	  local pipon = sleeves:FindBodygroupByName("pipboyon")
	  sleeves:SetBodygroup(pipon, 1)
	end
	if SERVER then
      Fallout_SortRagdoll(self.Owner, sleeves, true)
	else
	  local wrongoutfit = self.Owner:GetOutfit()
	  local times = 0
	  timer.Create("HandSortF", 0.025, 0, function()
	    if !self or !IsValid(self.Weapon) or !IsValid(self.Owner) then
		  timer.Destroy("HandSortF")
		return end
	    if self.Owner:GetOutfit() != wrongoutfit or times >= 20 then
		  if !IsValid(sleeves) then return end
		  Fallout_SortRagdoll(self.Owner, sleeves, true)
		  timer.Destroy("HandSortF")
		else
		  times = times + 1
		end
	  end)
	end
	sleeves:SetParent(vm)
	sleeves:AddEffects(EF_BONEMERGE)
	vm.Sleeves = sleeves
  end
end

function SWEP:Holster()
self.Owner:SetFOV(0, 0.1)
  if CLIENT then
    self:RemoveWeapon()
  end
  if CLIENT then
    self:RemoveHands()
	--
    local vm = self.Owner:GetViewModel()
    if !IsValid(vm) then return true end
    vm:SetColor(Color(255,255,255,255))
    vm:SetMaterial("")
  end
return true
end
-------------------------------
function SWEP:HolsterWeapon()
  if CLIENT then
    if !IsFirstTimePredicted() then return end
  end
self.NextHolster = self.NextHolster or CurTime() - 1
if self.NextHolster > CurTime() then return end
self:SetNextPrimaryFire(CurTime() + 0.8)
self:SetNextSecondaryFire(CurTime() + 0.8)
  local viewmodel1 = self.Owner.VMHands
  if !self:IsHolstered() then
    self.Holstering = true
	self:SetNWBool("Holstering",true)
	if CLIENT then
	  self:PlayViewModelAnim(self.HolsterAnim)
	  if pig.utility.IsFunction(self.OnHolster) then
	    self:OnHolster(viewmodel1)
	  end
	end
	if SERVER then
	  if self.HolsterAnimAct and !self:GetPassive() then
	    self.Owner:AnimNetworkedGesture(GESTURE_SLOT_CUSTOM, self.HolsterAnimAct, true)
	  end
	end
  else
    self:SetNWBool("Passive",false)
    self:SetNWBool("Holstering",false)
    self.Holstering = false
	if CLIENT then
	  self:PlayViewModelAnim(self.EquipAnim)
	  if pig.utility.IsFunction(self.OnUnHolster) then
	    self:OnUnHolster(viewmodel1)
	  end
	end
	if SERVER then
	  if self.UnHolsterAnimAct and !self:GetPassive() then
	    self.Owner:AnimNetworkedGesture(GESTURE_SLOT_CUSTOM, self.UnHolsterAnimAct, true)
	  end
	end
  end
self:SortHoldType()
self.NextHolster = CurTime() + 0.5
end

local function AshPile(ply,ragdoll,color)
local ash = ents.Create("goopile")
ash:SetPos(ragdoll:GetPos())
ash:SetAngles(ragdoll:GetAngles())
ragdoll:Remove()
ply.Ragdoll = ash
ash:Spawn()
ash:SetColor(color or Color(255,255,255))
ash:DropToFloor()
ply:SpectateEntity(ash)
end

local function Disintegrate(ply,ragdoll,mat,color)
if ragdoll and ragdoll.Disintegrated then return end
ragdoll:SetColor(color)
ragdoll:SetMaterial(mat)
ragdoll.Disintegrated = true
ragdoll:EmitSound("wep/fx_disintegration01.wav")
  timer.Simple(Schema.RespawnTime/2,function()
    if !IsValid(ragdoll) then return end
	if !IsValid(ply) then ragdoll:Remove() return end
	AshPile(ply,ragdoll,color)
  end)
end

local Critical = function(attacker,trace,dmginfo)
if CLIENT and !IsFirstTimePredicted() then return end
local ent = trace.Entity
local wep = attacker:GetActiveWeapon()
  if wep.EnergyEffect != nil then
    local effect = wep.EnergyEffect
	local laserhit = EffectData()
	laserhit:SetOrigin(trace.HitPos)
	laserhit:SetNormal(trace.HitNormal)
	laserhit:SetScale(15)
	util.Effect(effect, laserhit)
  end
if !IsValid(ent) then return false end
if !ent:IsPlayer() and !ent:IsNPC() and !string.find(ent:GetClass(),"npc") and !string.find(ent:GetClass(),"ragdoll") then return end
-----------------
  if CLIENT then
    hook.Call("Fallout_OnAttack",GAMEMODE,attacker,ent,trace,dmginfo)
  end
  if SERVER and wep.EnergyWep and ent:IsPlayer() then
    if dmginfo:GetDamage() >= ent:Health() then
	  timer.Simple(0.1,function()
	    local ragdoll = ent.Ragdoll
	    if IsValid(ragdoll) then
		  local defaultdmat = "pw_fallout/sprites/gooificationparticle01"
		  Disintegrate(ent,ragdoll,defaultdmat,wep.CriticalColor or Color(255,255,255))
		end
	  end)
	end
  end
--
return true
end

function SWEP:CSShootBullet( dmg, recoil, numbul, cone, viewm )
  if CLIENT and !IsFirstTimePredicted() then return end
  --
  self:TakeAmmo()
  --
        numbul  = numbul        or 1
        cone    = cone          or 0.01
		local iron = self:GetIronSights()
		if pig.utility.IsFunction(self.SetNewCone) then
		  local new_cone = self:SetNewCone(cone, iron)
		  if new_cone then
		    cone = new_cone
		  end
		end
		
		/*
		local skill = ""
		  if self.EnergyWep then
		    skill = "Energy Weapons"
		  else
		    skill = "Guns"
		  end
		local val = self.Owner:GetAttributeValue(skill)
		----------------------------------------
		local skill = (50 + val * 0.5)/100
		local cond = (.54 + (self.Condition*0.01) * (1-.54) )
		-----------------------------------------
		dmg = dmg * skill * cond * 1 
		dmg = dmg *1.125
		*/
		--------
		if self.Owner:LimbCrippled("Left Arm") then
		  cone = cone + 0.025
		end
		if self.Owner:LimbCrippled("Right Arm") then
		  cone = cone + 0.025
		end
		if iron then
		  cone = math.Clamp(cone - 0.02, 0, cone)
		end
		-------
		--Notify
		if CLIENT then
		self.LastShakeNotify = self.LastShakeNotify or CurTime() - 1
		  if self.Owner:LimbCrippled("Left Arm") or self.Owner:LimbCrippled("Right Arm") then
            if self.LastShakeNotify <= CurTime() then
			  self.LastShakeNotify = CurTime()+20
			  pig.Notify(Schema.GameColor,"Crippled arms reduces your weapon accuracy",6,"FO3FontSmall","pw_fallout/v_sad.png")
			end
          end		  
		end
		---------------
		
		local PlayerPos = self.Owner:GetShootPos()
        local PlayerAim = self.Owner:GetAimVector()
		
		local vm = self.Owner:GetViewModel()
		local viewmodel1 = viewm
        local bullet = {}
        bullet.Num              = numbul
		bullet.Src = PlayerPos
		bullet.Dir              = PlayerAim
        bullet.Spread   = Vector( cone, cone, 0 )               // Aim Cone
        bullet.Tracer   = self.TracerFreq
		bullet.Attacker = self.Owner
        bullet.TracerName       = self.TracerType or "effect_fo3_bullet"
        bullet.Force    = self.Primary.Force or (5*dmg)              // Amount of force to give to phys objects
        bullet.Damage   = dmg
		bullet.Callback = Critical

-- Muzzle Flash from Teta_Bonita's 'Realistic' SWEP Base :/
		local att = self.Owner:GetAttachment(1)
		local aimPos = att.Pos
        local fx = EffectData()
		fx:SetEntity(self.Weapon)
		fx:SetOrigin(aimPos)
        fx:SetNormal(PlayerAim)
        fx:SetAttachment(1)
        if (self.UseCustomMuzzleFlash == true) then
                util.Effect(self.MuzzleEffect,fx)
        else
                self.Owner:MuzzleFlash()
        end
        self.Owner:FireBullets( bullet )
        --self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )      // View model animation
		if CLIENT and IsFirstTimePredicted() then
		  local rseq = table.Random(self.AttackAnims)
		  self:PlayViewModelAnim(rseq)
		end
        self.Owner:SetAnimation( PLAYER_ATTACK1 )               // 3rd Person Animation
        if ( self.Owner:IsNPC() ) then return end
		--if CLIENT then
		  self:SWEPRecoil()
		--end
		/*
        // CUSTOM RECOIL !
        if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
                local eyeang = self.Owner:EyeAngles()
                eyeang.pitch = eyeang.pitch - recoil
                self.Owner:SetEyeAngles( eyeang )
        end
		*/
end
---------------------------------
function SWEP:PrimaryAttack()
  if self:IsHolstered() then
    self:HolsterWeapon()
  return end
  if self.Primary.InvAmmo and self.Weapon:Clip1() <= ((self.Primary.AmmoTake or 1) - 1) then
    self:Reload()
	return
  end
  --
local degrade = 0
  if self.MaximumShots then
    degrade = math.Round( 100/self.MaximumShots, 2 )
  end
  if self.Primary.WepFireSeq then
    self:SetFireSequence(self.Primary.WepFireSeq)
  end
self.Weapon:SetNextPrimaryFire( CurTime() + (self.Primary.Delay or 0.25) )
local viewm = self.Owner.VMHands
self:CSShootBullet(self.Primary.Damage,self.Primary.Recoil,self.Primary.Bullets or 1,self.Primary.Cone, viewm)
local tsound = table.Random(self.ShootSound)
self:EmitSound(tsound,90,100,self.ShootVolume or 1)
/*
  if SERVER then
    sound.Play( tsound, self.Weapon:GetPos(), 90, 100, self.ShootVolume or 1 )
  end
*/
end

function SWEP:SetFireSequence(anim)
  if CLIENT then
    local vm = self.Owner.VMHands
	if !IsValid(vm) then return end
	
    local wep = vm.VMWeapon
	local seq = wep:LookupSequence(anim)

	wep:SetCycle(0)
	wep:SetSequence(seq)
  end
end

function SWEP:SetWorldModelSequence(seq)
local wep = self.Owner.FalloutWep
  if IsValid(wep) then
	local seq = wep:LookupSequence ( seq )
    wep:SetCycle(0)
    wep:SetSequence(seq)
  end
end

function SWEP:IronSight()
if self.Owner:KeyDown(IN_USE) then return end
if self:IsHolstered() or !self:GetIronSights() and self.NextIronSight and self.NextIronSight > CurTime() then return end
  if self.Owner:KeyDown(IN_ATTACK2) then
    local holdtype = self:GetHoldWepType()
	if self.AimHoldType != self.HoldType and holdtype != self.AimHoldType or !self:GetIronSights() then
	  self:SetNWString("WHoldtype", self.AimHoldType)
	  self:SetNWBool("IronSight",true)
	  self.IronCurTime = CurTime()
	  if pig.utility.IsFunction(self.OnSightToggled) then
	    self:OnSightToggled(true)
	  end
	  self.Owner:SetFOV(self.ZoomFOV or 70, 1)
	  local team = self.Owner:Team()
	  local runspeed = faction[team].RunSpeed
	  --
	  local amt = 0
	  if self.Owner:LimbCrippled("Left Leg") then
	    amt = amt + 1
	  end
      if self.Owner:LimbCrippled("Right Leg") then
	    amt = amt + 1
	  end
	  if amt == 1 then
	    runspeed = Schema.LegCrip1_RunSpeed
	  elseif amt == 2 then
	    runspeed = Schema.LegCrip2_RunSpeed
	  end
	  --
	  self.Owner.EFRunSpeed = runspeed
	  self.Owner:SetRunSpeed(runspeed*.4)
	end
  end
  --
  if self.Owner:KeyReleased(IN_ATTACK2) or self.NextIronSight and self.NextIronSight > CurTime() and self:GetIronSights() then
    if !self.NextIronSight or self.NextIronSight < CurTime() then
      self.NextIronSight = CurTime() + 0.5
	end
    local holdtype = self:GetHoldWepType()
	if self.AimHoldType != self.HoldType and holdtype != self.AimHoldType or self:GetIronSights() then
	  self:SetNWString("WHoldtype",self.HoldType)
	  self:SetNWBool("IronSight",false)
	  if pig.utility.IsFunction(self.OnSightToggled) then
	    self:OnSightToggled(false)
	  end
	  self.Owner:SetFOV(0, 1)
	  self.Owner:SetRunSpeed(self.Owner.EFRunSpeed)
	end
  end
end

function SWEP:GetIronSights()
local iron = self:GetNWBool("IronSight",false)
  if iron == true then
    return true
  else
    return false
  end
end

function SWEP:GetPassive()
  if self:GetNWBool("Passive",false) == true then
    return true
  end
end

function SWEP:Reload()
  if self.Owner:KeyDown(IN_USE) then
    if self:GetPassive() then
	  self:SetNWBool("Passive",false)
	end
    self:HolsterWeapon()
  return end
  if self:IsHolstered() then
    self:HolsterWeapon()
  return end
  self.NextReloadTime = self.NextReloadTime or CurTime()-1
  if self.NextReloadTime > CurTime() then return end
  --
    if CLIENT and !IsFirstTimePredicted() then return end
	--
	local ammotype = self.Primary.InvAmmo
	local name = Schema.InvNameTbl[ammotype] or ammotype
	local tbl = self.Owner.Inventory[name]
	if !tbl then return end
	local clip = math.Clamp(self.Primary.ClipSize - self.Weapon:Clip1(), 0, tbl.Amount)
	if clip <= 0 then return end
	local new_amt = tbl.Amount - clip
	if new_amt <= 0 then
	  self.Owner.Inventory[name] = nil
	else
	  self.Owner.Inventory[name].Amount = new_amt
	end
	--
    local bolttime = self.BoltAnimTime
    local bolts = nil
    if bolttime then
	  bolts = clip+0
	end
	--
	local itime = self.ReloadTime or 1
	if self.ReloadTimePBolt then
	  itime = self.ReloadTimePBolt*bolts
	end
	self.NextIronSight = CurTime() + itime
	self.Owner:SetAnimation(PLAYER_RELOAD)
	if SERVER then
	  self.Weapon:SetClip1(self.Weapon:Clip1() + clip)
	end
  --
  local time = CurTime() + (self.ReloadTime or 1)
  if self.ReloadTimePBolt then
    local addtime = self.ReloadTimePBolt
    time = CurTime() + (addtime + (addtime*bolts))
  end
  self.NextReloadTime = time
  self:SetNextPrimaryFire(time)
  if !self.ReloadAnims then return end
    if self.ReloadSound and SERVER then
	  if pig.utility.IsFunction(self.ReloadSound) then
	    self:ReloadSound(bolts, self.ReloadTimePBolt)
	  else
	    self.Owner:EmitSound(self.ReloadSound)
	  end
	end
--
  if CLIENT then
	local rseq = table.Random(self.ReloadAnims)
	local bolted = 0
	if bolttime then
	  local start = self.BoltStartAnim
	  self:PlayViewModelAnim(start)
	  timer.Create("FBoltClient", bolttime, bolts, function()
	    if bolted == bolts then
		  local bend = self.BoltEndAnim or rseq
	      self:PlayViewModelAnim(bend)		
		else
		  self:PlayViewModelAnim(rseq)
		end
		bolted = bolted + 1
	  end)
	else
	  self:PlayViewModelAnim(rseq)
	end
	  
	  if self.Primary.WepRSeq then
	    self:SetFireSequence(self.Primary.WepRSeq)
	  end
	
    local afterseq = self.ReloadPostAnim
    if afterseq then
	  local viewmodel1 = self.Owner.VMHands
	  if !IsValid(viewmodel1) then return end
      local time = viewmodel1:SequenceDuration(rseq)
      timer.Simple(time - 0.15,function()
	    if !IsValid(self) or !self.PlayViewModelAnim then return end
        self:PlayViewModelAnim(afterseq)--viewmodel1:SetSequence( viewmodel1:LookupSequence(afterseq) )
      end)
    end
  end
  --
end

function SWEP:SecondaryAttack()
  if self.Owner:KeyDown(IN_USE) then
    if self:GetPassive() then
      self:SetNWBool("Passive",false)	
	else
      self:SetNWBool("Passive",true)
	end
	self:HolsterWeapon()
  return end
--
end

function SWEP:AnimHoltserHoldType()
    if self:GetPassive() then
	  return(self.HolsterAct or "passive")
	else
	  return("normal")
	end
end

function SWEP:IsHolstered()
  if self.Holstering or self:GetNWBool("Holstering",false) == true then
    return true
  end
end

function SWEP:GetPigHoldType()
local holdtype = self:GetHoldWepType()
return holdtype
end

function SWEP:GetHoldWepType()
local holdtype = self:GetNWString("WHoldtype",self.HoldType)
  if holdtype == "" or holdtype:len() < 1 then
    holdtype = self.HoldType
  end
return holdtype
end

function SWEP:SortHoldType()
  if self:IsHolstered() then
    if self:GetPassive() then
	  self:SetWeaponHoldType(self.HolsterAct or "passive")
	else
	  self:SetWeaponHoldType("normal")
	end
  return end
self:SetWeaponHoldType(self:GetHoldWepType())
end
------------------------------
--
function SWEP:Think()
 self:IronSight()
 ---
 if CLIENT then
   --self:CalcViewPunch()
  local vm = self.Owner.VMHands
    if !IsValid(vm) then
	  self:CreateHands()
	end
    if !IsValid(vm.VMWeapon) then
	  self:CreateWeapon(self.WeaponModel)
	end
	if !IsValid(vm.Sleeves) or vm.Sleeves:GetModel() != self.Owner:GetModel() then
	  if IsValid(vm.Sleeves) then
	    vm.Sleeves:Remove()
	  end
	  self:SortHand(vm)
	end
	vm = self.Owner:GetViewModel()
	if !vm.Invisible then
      vm:SetMaterial("vgui/zoom")	  
	  vm:SetColor(Color(255,255,255,1))
	  vm.Invisible = true
	end
  end
end
--
if CLIENT then
-----------------------------------------
--
concommand.Add("test_Wep",function(ply)
local viewmodel1 = ply.VMHands
PrintTable(viewmodel1:GetSequenceList())
end)

concommand.Add("test_Wep2",function(ply)
local wep = ply.VMHands.VMWeapon
PrintTable(wep:GetSequenceList())
end)

concommand.Add("test_hand",function(ply)
local wep = ply:GetActiveWeapon()
wep:CreateHands()
end)

--
function SWEP:PlayViewModelAnim(seq_name, func)
  local vm = self.Owner.VMHands
  if !IsValid(vm) then return end
  
  local seq = vm:LookupSequence(seq_name)
  vm:SetCycle(0)
  vm:SetSequence(seq)
  --
  if pig.utility.IsFunction(func) then
    func(vm, seq)
  end
end

function SWEP:ShakeWep(pos,ang)
self.NextShake = self.NextShake or CurTime() + self.ShakingTime
  if self.NextShake <= CurTime() then
    self.NextShake = CurTime() + self.ShakingTime
    if !self.Shake then
      self.Shake = true
    else
      self.Shake = false
    end
  end
	local shake = self.Shake
	if ( shake != self.LastShake ) then
		self.LastShake = shake 
		self.ShakeTime = CurTime()
	end
	self.SwayScale = 0.3
	local ShakeTime = self.ShakeTime or 0
	if ( !shake && ShakeTime < CurTime() - self.ShakingTime ) and !self.Holstered then 
		return pos, ang 
	end
	local Mul = 1.0
	if ( ShakeTime > CurTime() - self.ShakingTime ) then
		Mul = math.Clamp( (CurTime() - ShakeTime) / self.ShakingTime, 0, 1 )
		if (!shake) and !self.Holstered then Mul = 1 - Mul end
	end
	local shakepos = self.ShakePos
	local Offset= self.Offset or shakepos
	local Offang = self.Offang or self.ShakeAng
	if ( Offang ) then
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		Offang.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		Offang.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	Offang.z * Mul )
	end
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul
return pos,ang
end

function SWEP:IronPos(pos,ang)
	local bIron = self:GetIronSights()
	if ( bIron != self.bLastIron ) then
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	end
	local fIronTime = self.fIronTime or 0
	if ( !bIron && fIronTime < CurTime() - self.IronSightTime ) and !self.Holstered then 
		return pos, ang 
	end
	local Mul = 1.0
	if ( fIronTime > CurTime() - self.IronSightTime ) then
		Mul = math.Clamp( (CurTime() - fIronTime) / self.IronSightTime, 0, 1 )
		if (!bIron) and !self.Holstered then Mul = 1 - Mul end
	end
	local Offset= self.Offset or self.IronVec
	local Offang = self.Offang or self.IronAng
	if ( Offang ) then
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		Offang.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		Offang.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	Offang.z * Mul )
	end
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul
	return pos, ang
end

function SWEP:NormalPos(pos, ang)
ang.p = 0 + math.Clamp(ang.p*.92, -79, 79)
--
return pos, ang
end

function SWEP:GetViewModelPosition(pos,ang)
  local Offang = self.OriginAng
  local Offset = self.OriginPos
	if ( Offang ) then
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		Offang.x )
		ang:RotateAroundAxis( ang:Up(), 		Offang.y )
		ang:RotateAroundAxis( ang:Forward(), 	Offang.z )
	end
	if ( Offset ) then
	  local Right 	= ang:Right()
	  local Up 		= ang:Up()
	  local Forward 	= ang:Forward()
	  pos = pos + Offset.x * Right
	  pos = pos + Offset.y * Forward
	  pos = pos + Offset.z * Up
	end
    -----------
	local iron = self:GetIronSights()
	if !iron and !self.NonShake then
      pos,ang = self:ShakeWep(pos, ang)
	  pos,ang = self:NormalPos(pos, ang)
	end
    pos,ang = self:IronPos(pos,ang)
  return pos,ang
end

function SWEP:CreateHands()
  if self.Owner:CreatureName() then return end
  if IsValid(self.Owner.VMHands) then
    self:RemoveHands()
  end
  --
  local vm = self.Owner:GetViewModel()
  self.Owner.VMHands = ClientsideModel(self.ViewModel2)
  local vmhands = self.Owner.VMHands
  vmhands:SetPos(EyePos())
  vmhands:SetNoDraw(true)
  --self:PlayViewModelAnim(self.EquipAnim)
  --vmhands:SetSequence( vmhands:LookupSequence(self.EquipAnim) )
  print("Created new hands")
end

function SWEP:RemoveHands()
local vmhands = self.Owner.VMHands
  if IsValid(vmhands) then
    local wep = vmhands.VMWeapon
	if IsValid(wep) then
	  wep:Remove()
	  wep = nil
	end
    vmhands:Remove()
	vmhands = nil
  end
end

function SWEP:CreateWeapon(mdl)
if mdl == nil then return end
self.LastWep = self.LastWep or CurTime() - 1
if self.LastWep > CurTime() then return end
self.LastWep = CurTime() + 0.01
self:RemoveWeapon()
--------------------------
local vm = self.Owner.VMHands
if !IsValid(vm) then return end
  if IsValid(vm.VMWeapon) then
    self:RemoveWeapon()
  end
vm.VMWeapon = ClientsideModel(mdl,RENDER_GROUP_VIEW_MODEL_OPAQUE)
--------------------------
local wep = vm.VMWeapon
local attachment = vm:LookupAttachment("weapon")
wep:SetNoDraw(true)
wep:SetParent(vm)
wep:AddEffects(EF_BONEMERGE)
end

function SWEP:RemoveWeapon()
local vm = self.Owner.VMHands
if !IsValid(vm.VMWeapon) then return end
vm.VMWeapon:Remove()
vm.VMWeapon = nil
end
--
------------------------------
function SWEP:ViewModelDrawn()
local vm = self.Owner.VMHands
  if !IsValid(vm) then
    return
  end
  local wep = vm.VMWeapon
  local sleeves = vm.Sleeves
  local eyeang = EyeAngles()
  local eyepos = EyePos()
  --
  local viewmodel = self.Owner:GetViewModel()
  local ang = viewmodel:GetAngles()
  local pluspos = viewmodel:GetPos() - eyepos
  --
  vm:SetRenderOrigin(eyepos + pluspos)
  vm:SetRenderAngles(ang)
  vm:SetupBones()
  vm:SetParent(self.Owner:GetViewModel())
  --vm:DrawModel()
  ----------  

  if IsValid(wep) and !self.NonAttachment then
	local attachment = vm:LookupAttachment("weapon")
	local att = vm:GetAttachment(attachment)
	if att then
	  local pos = att.Pos
      local ang = att.Ang
	  wep:SetPos(pos)
	  wep:SetAngles(ang)
	  wep:SetupBones()
	  wep:DrawModel()
	  if pig.utility.IsFunction(self.WepDrawn) then
	    self:WepDrawn(wep, pos, ang, attachment)
	  end
	end
  elseif IsValid(wep) then
    local bonename = self.BoneName
    local bone = vm:LookupBone(bonename)
    local m = vm:GetBoneMatrix(bone)
	local fix_pos,fix_ang = nil
    if (m) then
    	fix_pos, fix_ang = m:GetTranslation(), m:GetAngles()
    end
    ----------------------
    local forward = self.BonePos
    local rotation = self.BoneAng
    ----------------------
    fix_pos = fix_pos + fix_ang:Forward()*forward.x + fix_ang:Right()*forward.y + fix_ang:Up() *forward.z
    fix_ang:RotateAroundAxis(fix_ang:Up(), rotation.p)
    fix_ang:RotateAroundAxis(fix_ang:Right(), rotation.y)
    fix_ang:RotateAroundAxis(fix_ang:Forward(), rotation.r)
    
    wep:SetAngles(fix_ang)
    wep:SetPos(fix_pos)
	wep:SetupBones()
	wep:DrawModel()
  end
  
  if IsValid(wep) then
  	local stealth = self.Owner:GetNWBool("Stealthing",false)
	if stealth and !wep.Stealthing then
	  wep:SetMaterial("pw_fallout/skins/stealthf")
	  wep.Stealthing = true
	elseif !stealth and wep.Stealthing then
	  wep:SetMaterial()
	end
	if pig.utility.IsFunction(self.WepDrawn) then
	  self:WepDrawn(wep, fix_pos, fix_ang)
	end
  end
	
  if IsValid(sleeves) then
    sleeves:SetPos(eyepos - eyeang:Forward()*20)
	local stealth = self.Owner:GetNWBool("Stealthing",false)
	if stealth and !sleeves.Stealthing then
	  sleeves:SetMaterial("pw_fallout/skins/stealthf")
	  sleeves.Stealthing = true
	elseif !stealth and sleeves.Stealthing then
	  sleeves.Stealthing = false
	  sleeves:SetMaterial()
	end
	sleeves:DrawModel()
  end
  --
  vm.LastDraw = vm.LastDraw or RealTime()
  vm:FrameAdvance( (RealTime()-vm.LastDraw) * 1 )
  vm.LastDraw = RealTime()
  local wep = vm.VMWeapon
	if IsValid(wep) then
      wep.LastDraw = wep.LastDraw or RealTime()
      wep:FrameAdvance( (RealTime()-wep.LastDraw) * 1 )
	  wep.LastDraw = RealTime()
  end
  --
end

function SWEP:ShowHolster(wep,owner)
local fix_pos,fix_ang
fix_pos = Vector(0,0,0) fix_ang = Angle(0,0,0)
--
local holsterbone = self.HolsterBone
if !holsterbone then return end
local bone = owner:LookupBone(holsterbone)
if bone == nil then return end
local m = owner:GetBoneMatrix(bone)
  if (m) then
	fix_pos, fix_ang = m:GetTranslation(), m:GetAngles()
  end
----------------------
local forward = self.HolsterPos 
local rotation = self.HolsterAng
----------------------
fix_pos = fix_pos + fix_ang:Forward()*forward.x + fix_ang:Right()*forward.y + fix_ang:Up() *forward.z
fix_ang:RotateAroundAxis(fix_ang:Up(), rotation.p)
fix_ang:RotateAroundAxis(fix_ang:Right(), rotation.y)
fix_ang:RotateAroundAxis(fix_ang:Forward(), rotation.r)

wep:SetAngles(fix_ang)
wep:SetPos(fix_pos)
end

function SWEP:DrawWorldModel()
  if !IsValid(self.Owner.FalloutWep) and self.WeaponModel or self.WeaponModel and IsValid(self.Owner.FalloutWep) and self.Owner.FalloutWep:GetModel() != self.WeaponModel then
	if !IsValid(self.Owner.FalloutWep) then
	  self.Owner.FalloutWep = ClientsideModel(self.WeaponModel)
	  local wep = self.Owner.FalloutWep
	  if self.StartSeq then
	    self:SetWorldModelSequence(self.StartSeq)
	  end
	  FalloutWepTbl = FalloutWepTbl or {}
	  table.insert(FalloutWepTbl,wep)
	else
	  self.Owner.FalloutWep:SetModel(self.WeaponModel)
	  if self.StartSeq then
	    self:SetWorldModelSequence(self.StartSeq)
	  end
	end
	local wep = self.Owner.FalloutWep
	if !IsValid(wep) then return end
	wep:SetParent(self.Owner)
	wep.Owner = self.Owner
	wep.Weapon = self.Weapon
	wep:AddEffects(EF_BONEMERGE)
  elseif IsValid(self.Owner.FalloutWep) and !self.WeaponModel then
    self.Owner.FalloutWep:Remove()
  end
  local wep = self.Owner.FalloutWep
  if self:IsHolstered() and !self:GetPassive() and IsValid(wep) then
    if !wep.Unmerged then
      wep:RemoveEffects(EF_BONEMERGE)
	  wep.Unmerged = true
	end
    self:ShowHolster(wep,self.Owner)
  elseif IsValid(wep) and wep.Unmerged then
    wep:AddEffects(EF_BONEMERGE)
	wep.Unmerged = false
  end
self:SortHoldType()
end

hook.Add("Think","PW_SWEP_WM",function()
   for k,v in pairs(FalloutWepTbl or {}) do
   --
     if IsValid(v) then
	   v.LastDraw = v.LastDraw or RealTime()
       v:FrameAdvance( (RealTime()-v.LastDraw) * 1 )
	   v.LastDraw = RealTime()
	 end
   --
     if !IsValid(v) then
	   FalloutWepTbl[k] = nil
	   continue
	 elseif IsValid(v.Owner) and v:GetParent() != v.Owner then
	   v:SetParent(v.Owner)
	   v:AddEffects(EF_BONEMERGE)
	 end
   --
     if !IsValid(v.Owner) then
       v:Remove()
       FalloutWepTbl[k] = nil
	elseif IsValid(v.Owner) and v.Owner:GetActiveWeapon() != v.Weapon then
       v:Remove()
       FalloutWepTbl[k] = nil
	elseif IsValid(v.Owner) and v.Owner == LocalPlayer() and !LocalPlayer():ShouldDrawLocalPlayer() then
	  v:Remove()
	  FalloutWepTbl[k] = nil
	elseif IsValid(v.Owner) then
	  local stealth = v.Owner:GetNWBool("Stealthing",false)
	  if stealth == true and !v.Stealthing then
	    v.Stealthing = true
		v:SetMaterial("pw_fallout/skins/stealthf")
	  elseif stealth != true and v.Stealthing then
	    v:SetMaterial()
		v.Stealthing = false
	  end
    end
  end
end)

end