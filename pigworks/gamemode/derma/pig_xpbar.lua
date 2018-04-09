local PANEL = {}

function PANEL:Init()
self:ShowCloseButton(false)
self:SetSize(ScrW() *.2,ScrH() *.2)
self:SetPos(ScrW() *.725,ScrH() *.75)
self:SetTitle("")
self.Max = LocalPlayer():GetRequiredXP() + LocalPlayer():GetXP()
self.XP = LocalPlayer():GetXP()
self.Level = LocalPlayer():GetLevel()
self.Pointer = vgui.Create("DPanel",self)
local pointer = self.Pointer
--pointer:SetMaterial(Material("pointer.vtf"))
pointer:SetSize(self:GetWide() *.125, self:GetTall() *.2)
pointer:SetPos(0,self:GetTall() *.35)
pointer.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.SetMaterial( Material("pointer.vtf") )
surface.DrawTexturedRect( 0, 0, me:GetWide(), me:GetTall() )
end
self.XPText = vgui.Create("DLabel",self)
-- / = divide * = multiply - = minus + = plus
hook.Call("pig_XPBar_Open",GAMEMODE,self)
end

function PANEL:AddBarXP(from,toAdd)
self.Added = toAdd
self.XP = from + toAdd
  local text = self.XPText
  if IsValid(text) then
    text:SetText("+"..toAdd.." XP")
    text:SetFont("PigFont")
    text:SetPos(self:GetWide() *.535,self:GetTall() *.625)
    text:SetTextColor(Schema.GameColor)
    text:SizeToContents()
  end
local xpos,ypos = self.Pointer:GetPos()
local percent_from = (from / self.Max) *.9
local start_pos = hook.Call("pig_XPBar_PointerStartPos",GAMEMODE,self,percent_from)
self.Pointer:SetPos(start_pos or (self:GetWide() *percent_from),ypos)
local percent = (self.XP / self.Max) *.9
local pos = hook.Call("pig_XPBar_PointerPos",GAMEMODE,self,percent)
self.Pointer:MoveTo( pos or (self:GetWide()*percent), ypos, 2, 0,0.24, function()
  timer.Simple(3,function()
    if !IsValid(self) then return end
    self:Remove()
  end)
  if self.XP > LocalPlayer():GetXP() then
    self.Pointer:SetPos(0,ypos)
  end
end)
--------
end

function PANEL:Paint()
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,105) )
--
surface.SetDrawColor( Schema.GameColor )
surface.DrawLine( 0, self:GetTall() / 2, self:GetWide(), self:GetTall() / 2 )
--
draw.SimpleText(self.Level, "PigFont", self:GetWide() *.0125, self:GetTall() *.425, Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
draw.SimpleText(self.Level + 1, "PigFont", self:GetWide() *.91, self:GetTall() *.425, Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("pig_XPBar", PANEL, "DFrame")