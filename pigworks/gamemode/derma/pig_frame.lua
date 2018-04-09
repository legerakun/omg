local PANEL = {}

function PANEL:Init()
self.Sizes = ScrW() / 2,ScrH() *.6
self:ShowCloseButton(false)
local w,h = self:GetSize()
if w < 1 and h < 1 then
self:SetSize(ScrW() / 2,ScrH() *.6)
end
self:SetTitle("")
self:ShowClose(true)
end

function PANEL:Paint()
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,105) )
end

function PANEL:ShowClose(bool)
if bool then
if !IsValid(self.CloseButton) then 
self.CloseButton = pig.CreateButton(self,"Close","PigFontTiny")
self.CloseButton:SetSize(50, 25)
self.CloseButton:SetPos(self:GetWide() *.98 - self.CloseButton:GetWide(), self:GetTall() *.02)
self.CloseButton.Think = function(self)
if self.StopThink then return end
self:SetPos(self:GetParent():GetWide() *.98 - self:GetWide(),self:GetParent():GetTall() *.02)
end
self.CloseButton.DoClick = function(self)
self:GetParent():Remove()
end
end
else
if IsValid(self.CloseButton) then
self.CloseButton:Remove()
end
end
end

vgui.Register("pig_Frame", PANEL, "DFrame")