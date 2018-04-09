include("shared.lua")

function ENT:Draw()
if self:GetNWBool("GlobalVis") == true then
self:DrawModel()
return end
if self:GetNWEntity("Owner") != LocalPlayer() or LocalPlayer().ThirdPersonActive then
	self:DrawModel()
end
end

function ENT:DrawTranslucent()
	self:Draw()
end