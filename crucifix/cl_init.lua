include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
local cont = self:GetNWBool("Crucify",false)
if cont != true and !IsValid(self.Ragdoll) then return end
local dist = self:GetPos():Distance(LocalPlayer():GetPos())
  if !cont and IsValid(self.Ragdoll) or dist > 1500 then
    if IsValid(self.Ragdoll) then
      self.Ragdoll:Remove()
	  self.Player = nil
	end
	return
  end
local name = self:GetNWString("CrucifyPly", "")
local ply = self.Player
  if !ply then
    self.Player = pig.FindPlayerByName(name)
  end
  
  if IsValid(self.Ragdoll) and self.Ragdoll.Name != name then
    self.Ragdoll:Remove()
	self.Player = nil
  elseif IsValid(self.Ragdoll) and IsValid(ply) then
    local ragdoll = self.Ragdoll
	local ang = self:GetAngles()
	local pos = self:GetPos()
	ragdoll:SetAngles(ang)
	ragdoll:SetPos(pos + ang:Up()*3 + ang:Forward()*1)
	Fallout_SortRagdoll(ply, ragdoll)
	--
	ragdoll.LastAdvace = ragdoll.LastAdvace or 0
    ragdoll:FrameAdvance( ( RealTime() - ragdoll.LastAdvace ) )
  end
if IsValid(self.Ragdoll) then return end
----------------
if !IsValid(ply) then return end
self.Ragdoll = ClientsideModel(ply:GetModel())
  if ply == LocalPlayer() then
    LocalPlayer().CrucifyRagdoll = self.Ragdoll
  end
local ragdoll = self.Ragdoll
Fallout_SortRagdoll(ply, ragdoll)
--
ragdoll.Name = name
--
local ang = self:GetAngles()
local pos = self:GetPos()
ragdoll:SetAngles(ang)
ragdoll:SetPos(pos + ang:Up()*5 + ang:Forward()*1)
local crucify = ragdoll:LookupSequence("dynamicidle_nvcrucifiedidle")
ragdoll:SetSequence(crucify)
end

function ENT:OnRemove()
  if IsValid(self.Ragdoll) then
    self.Ragdoll:Remove()
  end
end

hook.Add("CalcView", "CrucifyView", function(ply, pos, angles, fov)
local ragdoll = LocalPlayer().CrucifyRagdoll
if !IsValid(ragdoll) then return end
local head = ragdoll:LookupAttachment("headgear")
head = ragdoll:GetAttachment(head)
if !head then return end
local view = {}
local headang = angles
local headpos = head.Pos
local ang = headang
headpos = headpos + ang:Forward()*-120 + ang:Up()*2
--
view.origin = headpos
view.angles = headang
return view
end)
