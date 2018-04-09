local Plugin = Plugin or {}
Fallout_ApparelTable = Fallout_ApparelTable or {}
Fallout_RagAppTable = Fallout_RagAppTable or {}

function Plugin:Think()
  for k,v in pairs(player.GetAll()) do
  if v:InEditor() then continue end
    if v:CreatureName() then
	  Fallout_RemoveModel(v,true,true)
	  continue 
	elseif IsValid(v:GetNWEntity("Ragdoll")) then
	  local rag = v:GetNWEntity("Ragdoll")
	  Fallout_SortRagdoll(v,rag)
	  continue
	end
    if pig.utility.PlayerCanSee( LocalPlayer(), v) or v == LocalPlayer() and LocalPlayer().ThirdPersonActive then
	  Fallout_SortPlayerModels(v)
	else
	  Fallout_RemoveModel(v,true,true,true)
	end
  end
  --
  for k,v in pairs(Fallout_ApparelTable or {}) do
    local owner = v.Owner
	if !IsValid(owner) then v:Remove() Fallout_ApparelTable[k] = nil continue end
    local nodraw = owner:GetNoDraw()
	if v.Owner:Health() <= 0 then
	  nodraw = true
	end
	local vdraw = v:GetNoDraw()
	if nodraw and !vdraw then
	  v:SetNoDraw(true)
	elseif nodraw and vdraw then
	  continue
	elseif vdraw then
	  v:SetNoDraw(true)
	end
    --
    if IsValid(v.Owner) and v.Orientation then continue end
    if !IsValid(v.Owner) then
	  v:Remove()
	  v = nil
	  Fallout_ApparelTable[k] = nil
	elseif IsValid(v.Owner) and !IsValid(v:GetParent()) then
	  local head = v.Owner:LookupAttachment("headgear")
	  v:SetPos(v.Owner:GetPos())
	  v:SetAngles(v.Owner:GetAngles())
	  v:SetParent(v.Owner,head)
	elseif IsValid(v:GetParent()) and IsValid(v.Owner:GetNWEntity("Ragdoll")) then
	  local rag = v.Owner:GetNWEntity("Ragdoll")
	    if v:GetParent() == rag and v.Owner:Health() >= 1 then
		  local head = v.Owner:LookupAttachment("headgear")
		  v:SetPos(v.Owner:GetPos())
		  v:SetAngles(v.Owner:GetAngles())
		  v:SetParent(v.Owner,head)
		end
	  elseif v.NoDraw and IsValid(v.Owner) and v.Owner:IsPlayer() then
	    v:SetNoDraw(false)
		v.NoDraw = false
	end
  end
  --
  for k,v in pairs(Fallout_RagAppTable or {}) do
    if !IsValid(v.Owner) then 
	  v:Remove()
	  Fallout_RagAppTable[k] = nil
	  MsgC(Color(204,204,0), "[Fallout]: Removing Ragdoll models..\n")
	end
  end
end

function Plugin:PlayerRenderOverride(ply)
  for k,v in pairs(Fallout_ApparelTable) do
    local owner = v.Owner
    if owner != ply then continue end
    Fallout_SortClModel(v)
  end
end

function Fallout_SortClModel(v)
    local owner = v.Owner
	if owner:GetNoDraw() or owner:Health() <= 0 then
	  return
	end
	if owner.Helmet == v and !v.Attachment and !v.Orientation then return end
	if !v.Orientation then
      local attachment = owner:LookupAttachment("headgear")
	  local att = owner:GetAttachment(attachment)
	  
	  if !att then
	    v:Remove()
	    Fallout_ApparelTable[k] = nil
		return
	  end
	else
	  local vars = Fallout_GetAppVars(owner:GetOutfit(true))--v.Vars
	  if vars then
	    Fallout_SortHelmet(owner,v,vars.Pos or Vector(0,0,0), vars.Ang or Angle(0,0,0))
	  end
	end
	local col = v.Col
	
	v:SetupBones()
	if !col then render.SetColorModulation(  1, 1, 1 ) v:DrawModel() return end
	render.SetColorModulation( col.r / 255, col.g / 255, col.b / 255 )
	v:DrawModel()
	render.SetColorModulation( 1, 1, 1 )
end

function Plugin:PostDrawTranslucentRenderables()
  for k,v in pairs(Fallout_RagAppTable or {}) do
    local col = v.Col
	v:SetupBones()
	if !col then render.SetColorModulation(  1, 1, 1 ) v:DrawModel() return end
	render.SetColorModulation( col.r / 255, col.g / 255, col.b / 255 )
	v:DrawModel()
	render.SetColorModulation( 1, 1, 1 )
  end
end

function Fallout_RemoveModel(ply,hair,fachair,helmet)
local collect = false
  if hair and IsValid(ply.Hair) then
    table.RemoveByValue(Fallout_ApparelTable,ply.Hair)
	if IsValid(ply.Hair) then
      ply.Hair:Remove()
	end
	ply.Hair = nil
	collect = true
  end
  if helmet and IsValid(ply.Helmet) then
    table.RemoveByValue(Fallout_ApparelTable,ply.Helmet)
	if IsValid(ply.Helmet) then
      ply.Helmet:Remove()
	end
	ply.Helmet = nil
	collect = true
  end  
  if fachair and IsValid(ply.FacialHair) then
    table.RemoveByValue(Fallout_ApparelTable,ply.FacialHair)
	if IsValid(ply.FacialHair) then
      ply.FacialHair:Remove()
	end
	ply.FacialHair = nil
	collect = true
  end  
  /*
  if collect then
    local garbagecount = collectgarbage("count")
    LocalPlayer().NextCollectCG = LocalPlayer().NextCollectCG or CurTime() - 1
	if LocalPlayer().NextCollectCG > CurTime() then return end
	LocalPlayer().NextCollectCG = CurTime() + 60
	if (garbagecount > 30000) then
	  RunConsoleCommand("say", "// I am about to crash")
	  timer.Simple(1, function()
	    local col = collectgarbage("step",5)
	  end)
	end
  end*/
end

function Fallout_RagdollHelmet(ply,ragdoll)
    local bone = ragdoll:LookupBone("Bip01 Head")
    local m = ragdoll:GetBoneMatrix(bone)
    local pos,ang = nil
    if (m) then
	  pos, ang = m:GetTranslation(), m:GetAngles()
    end
	local c_pos,c_ang = Fallout_GetHelmetOrientation(ply:GetOutfit(true))
	if !pos or !ang then return end
	pos = pos + ang:Forward() * c_pos.x + ang:Right() * c_pos.y + ang:Up() * c_pos.z
	ang:RotateAroundAxis(ang:Up(), c_ang.p)
	ang:RotateAroundAxis(ang:Right(), c_ang.y)
	ang:RotateAroundAxis(ang:Forward(), c_ang.r)
	ply.Helmet:SetPos(pos)
    ply.Helmet:SetAngles(ang)
	ply.Helmet:SetupBones()
	ply.Helmet:DrawModel()
end

function Fallout_SortHelmet(ply,ent,c_pos,c_ang)
    local bone = ply:LookupBone("Bip01 Head")
    local m = ply:GetBoneMatrix(bone)
    local pos,ang = nil
    if (m) then
	  pos, ang = m:GetTranslation(), m:GetAngles()
    end
	if !pos or !ang then return end
	pos = pos + ang:Forward() * c_pos.x + ang:Right() * c_pos.y + ang:Up() * c_pos.z
	ang:RotateAroundAxis(ang:Up(), c_ang.p)
	ang:RotateAroundAxis(ang:Right(), c_ang.y)
	ang:RotateAroundAxis(ang:Forward(), c_ang.r)
	ent:SetPos(pos)
    ent:SetAngles(ang)
	ent:SetupBones()
	ent:DrawModel()
end

function Fallout_SortRagdoll(ply, ragdoll, quick)
local hair = ply:GetHair()
local fachair = ply:GetFacialHair()
local ghoul = ply:IsGhoul()
local sorted = false
--
local skin = ply:GetNWString("ArmorSkin","")
  if skin and skin != "" then
	if !ragdoll.ArmorSkin or ragdoll.ArmorSkin != skin then
	  ragdoll.ArmorSkin = skin
	  skin = FIGetSkin(skin)
	  local outfit = ply:GetOutfit()
	  local sub = FIGetMatIndex(outfit, ply:GetGender())
	  ragdoll:SetSubMaterial(sub,skin)
	end
  end
--
local distance = ply:GetPos():Distance(LocalPlayer():GetPos())
  if !quick and distance <= 2000 then
  local haircol = ply:GetHairCol()
  
  if fachair and !IsValid(ragdoll.FacHair) then
    sorted = true
    local model = ClientsideModel(fachair, RENDERGROUP_BOTH)
	local head = ragdoll:LookupAttachment("headgear")
	model:SetPos(ragdoll:GetPos())
	model:SetColor(haircol)
	--model:SetNoDraw(true)
	model:SetAngles(ragdoll:GetAngles())
    model:SetParent(ragdoll,head)
	model.Col = haircol
	model.Owner = ragdoll
	ragdoll.FacHair = model
	table.insert(Fallout_RagAppTable, model)
  end
  if hair and !IsValid(ragdoll.Hair) then
    sorted = true
    local model = ClientsideModel(hair, RENDERGROUP_BOTH)
	local head = ragdoll:LookupAttachment("headgear")
	model:SetPos(ragdoll:GetPos())
	--model:SetNoDraw(true)
	model:SetColor(haircol)
	model:SetAngles(ragdoll:GetAngles())
    model:SetParent(ragdoll,head)
	model.Col = haircol
	model.Owner = ragdoll
	ragdoll.Hair = model
	table.insert(Fallout_RagAppTable, model)
  end

end
--  
  if ghoul then
    local heads = ragdoll:FindBodygroupByName("heads")
    ragdoll:SetBodygroup(heads,1)
    ragdoll:SetSkin(1)
  end
  if !ragdoll.Faced and !ply:IsBot() then
    local fmap = ply:GetFaceMap()
    Fallout_SortFaceMap(ragdoll, fmap, ply:GetGender(), ply:IsGhoul(), ply:GetOutfit())
	ragdoll.Faced = true
  end
  if sorted then
    print("["..GAMEMODE.Name.."]: Rendering Corpse..")
  end
end

function Fallout_SortPlayerModels(ply)
  if ply:InEditor() then return false end
  local helmet = ply:GetHelmet()
  local fachairmodel = ply:GetFacialHair()
  local hairmodel = ply:GetHair()
  local stealth = ply:GetNWBool("Stealthing",false)
  local outfit = ply:GetOutfit()
  --
  if ply.FLastOutfit and ply.FLastOutfit != outfit then
    Fallout_RemoveModel(ply, true, true, true)
  end
  ply.FLastOutfit = outfit
  --
  if hairmodel and !IsValid(ply.Hair) then
    local cont = false
	if helmet then
	  local name = ply:GetOutfit(true)
	  local vars = Fallout_GetAppVars(name) or {}
	  if vars.FullHair then
	    cont = true
	  end
	else
	  cont = true
	end
	--
	if cont then
	
    if IsValid(ply.TempHair) then ply.TempHair:Remove() end
    local haircol = ply:GetHairCol()
    local hair = ClientsideModel(hairmodel, RENDERGROUP_BOTH)
	hair:SetIK(false)
	hair:SetNoDraw(true)
	hair:SetColor(haircol)
	hair.Col = haircol
	hair:SetPos(ply:GetPos())
	hair:SetAngles(ply:GetAngles())
	local attachment = ply:LookupAttachment("headgear")
    hair:SetParent(ply,attachment)
	hair.Owner = ply
	ply.Hair = hair
	table.insert(Fallout_ApparelTable,hair)

	end
  elseif IsValid(ply.Hair) and hairmodel and hairmodel != ply.Hair:GetModel() or !hairmodel and IsValid(ply.Hair) then
    Fallout_RemoveModel(ply,true)
  elseif IsValid(ply.Hair) and stealth == true then
    local stealthmat = "pw_fallout/skins/stealthf"
    ply.Hair:SetMaterial(stealthmat)
	ply.Hair.Stealthing = true
  elseif IsValid(ply.Hair) and stealth != true and ply.Hair.Stealthing then
    ply.Hair.Stealthing = false
	ply.Hair:SetMaterial()
  elseif !hairmodel and IsValid(ply.TempHair) then
    ply.TempHair:Remove()
  end
  --
  if fachairmodel and !IsValid(ply.FacialHair) then
    local helm = ply:GetOutfit(true)
    local appvars = Fallout_GetAppVars(helm)
    if !helm or helm and appvars and appvars.FacHair then
      local haircol = ply:GetHairCol()
      local hair = ClientsideModel(fachairmodel, RENDERGROUP_BOTH)
	  hair:SetIK(false)
	  hair:SetNoDraw(true)
	  hair:SetColor(haircol)
	  hair.Col = haircol
	  hair:SetPos(ply:GetPos())
	  hair:SetAngles(ply:GetAngles())
	  local attachment = ply:LookupAttachment("headgear")
      hair:SetParent(ply,attachment)
	  hair.Owner = ply
	  ply.FacialHair = hair
	  table.insert(Fallout_ApparelTable,hair)
	end
  elseif IsValid(ply.FacialHair) and fachairmodel and fachairmodel != ply.FacialHair:GetModel() or !fachairmodel and IsValid(ply.FacialHair) then
    Fallout_RemoveModel(ply,false,true)
  elseif IsValid(ply.FacialHair) and stealth == true then
    local stealthmat = "pw_fallout/skins/stealthf"
    ply.FacialHair:SetMaterial(stealthmat)
	ply.FacialHair.Stealthing = true
  elseif IsValid(ply.FacialHair) and stealth != true and ply.FacialHair.Stealthing then
    ply.FacialHair:SetMaterial()
    ply.FacialHair.Stealthing = false
  end
  --
  if helmet and !IsValid(ply.Helmet) then
    local hair = ClientsideModel(helmet)
	hair:SetPos(ply:GetPos())
	hair:SetAngles(ply:GetAngles())
    hair:SetParent(ply)
	local skin = ply:GetNWString("ArmorSkinH","")
	if skin != "" and skin then
	  local sub = FIGetMatIndex(ply:GetOutfit(true), ply:GetGender())
	  skin = FIGetSkin(skin)
	  hair:SetSubMaterial(sub, skin)
	end
	local name = ply:GetOutfit(true)
	local vars = Fallout_GetAppVars(name) or {}
	if !vars.Attachment and !vars.Orientation then
	  hair:AddEffects(EF_BONEMERGE)
	elseif !vars.Orientation then
	  hair:SetNoDraw(true)
	  local attachment = ply:LookupAttachment("headgear")
      hair:SetParent(ply,attachment)
	  hair.Attachment = true
	else
	  hair:SetNoDraw(true)
	  hair.Orientation = true
	  hair.Vars = vars
	end
	hair.Owner = ply
	ply.Helmet = hair
	table.insert(Fallout_ApparelTable,hair)
	if !vars.FullHair then
	  Fallout_RemoveModel(ply,true,true)
	end
	--
	if vars.KeepHair and hairmodel then
	  if IsValid(ply.TempHair) then ply.TempHair:Remove() end
	  local haircol = ply:GetHairCol()
	  local hmodel = "models/fallout/player/hair/hairbase.mdl"
      local hair = ClientsideModel(hmodel, RENDERGROUP_BOTH)
	  hair:SetIK(false)
	  hair:SetNoDraw(true)
	  hair:SetColor(haircol)
	  hair.Col = haircol
	  hair:SetPos(ply:GetPos())
	  hair:SetAngles(ply:GetAngles())
	  local attachment = ply:LookupAttachment("headgear")
      hair:SetParent(ply,attachment)
	  hair.Owner = ply
	  ply.TempHair = hair
	  table.insert(Fallout_ApparelTable,hair)
	elseif IsValid(ply.TempHair) then 
	  ply.TempHair:Remove()
	end
	--
  elseif helmet and helmet != ply.Helmet:GetModel() or !helmet and IsValid(ply.Helmet) then
    Fallout_RemoveModel(ply,false,false,true)
  elseif IsValid(ply.Helmet) and stealth == true then
    local stealthmat = "pw_fallout/skins/stealthf"
    ply.Helmet:SetMaterial(stealthmat)
	ply.Helmet.Stealthing = true
	if IsValid(ply.TempHair) then
	  ply.TempHair:SetMaterial(stealthmat)
	  ply.TempHair.Stealthing = true
	end
  elseif IsValid(ply.Helmet) and stealth != true and ply.Helmet.Stealthing then
    ply.Helmet.Stealthing = false
    ply.Helmet:SetMaterial()
	if IsValid(ply.TempHair) then
	  ply.TempHair:SetMaterial()
	  ply.TempHair.Stealthing = false
	end
  end
end

net.Receive("Fallout_RemoveModel",function()
local ply = net.ReadEntity()
Fallout_RemoveModel(ply,true,true)
end)

--------------------
--HOOK SHIT
function Plugin:PostPlayerDraw(ply)
  ply.LastDraw = CurTime() + FrameTime()
  if not ply.RenderOverride then
    function ply:RenderOverride()
      self:SetupBones()
      self:DrawModel()
      hook.Run("PlayerRenderOverride", self)
    end
  end
  /*
  for k,v in pairs(Fallout_ApparelTable) do
    local owner = v.Owner
	if !IsValid(owner) then continue end
    if owner != ply then continue end
    Fallout_SortClModel(v)
  end*/
end
--------------------

return Plugin