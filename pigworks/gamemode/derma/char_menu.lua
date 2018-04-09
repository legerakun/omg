local PANEL = {}

function PANEL:Init()
self:SetSize(ScrW() / 2,ScrH() *.6)
self:ShowCloseButton(false)
self:MakePopup()
self:SetTitle("")

self.CloseButton = pig.CreateButton(self,"Close","PigFontTiny")
self.CloseButton:SetSize(self:GetWide() *.065,self:GetTall()*.045)
self.CloseButton:SetPos(self:GetWide() *.91,self:GetTall() *.02)
self.CloseButton.DoClick = function(self)
if IsValid(pig.vgui.CharMenuBlur) then
pig.vgui.CharMenuBlur:Remove()
end
self:GetParent():Remove()
end

self.Rotate = vgui.Create("DNumSlider",self)
local Rotate = self.Rotate
Rotate:SetPos(self:GetWide()*.05,self:GetTall() *.075)
Rotate:SetMin(0)
Rotate:SetWide(self:GetWide() *.35)
Rotate:SetMax(100)
Rotate:SetValue(15)
Rotate:SetText("Rotation Speed")
Rotate:SetDecimals(0)

self.Model = vgui.Create("DModelPanel",self)
local Model = self.Model
Model:SetSize(self:GetWide() *.25,self:GetTall() *.75)
Model:SetPos(self:GetWide() *.065,0)
Model:CenterVertical()
Model:SetModel(LocalPlayer():GetModel())
Model:SetCamPos(Vector(35,14,44))
local col = nil
if LocalPlayer():GetKarma() == 0 then
col = Color(255,255,255)
elseif LocalPlayer():GetKarma() > 0 then
col = Color(0,204,0)
else
col = Color(204,0,0)
end
Model:SetAmbientLight( col )
Model:SetDirectionalLight( BOX_TOP, Schema.GameColor )
function Model:LayoutEntity( ent )
if Rotate == nil then return end
	ent:SetAngles( Angle( 0, self.LastPaint*Rotate:GetValue(),	0 ) )
end

self.XP = vgui.Create("pig_XPBar",self)
local xp = self.XP
local mx,my = Model:GetPos()
local mw,mh = Model:GetSize()
xp:SetPos(mx + mw,self:GetTall() *.625)
xp:CenterHorizontal()
local xpos,ypos = xp.Pointer:GetPos()
local percent = (xp.XP / xp.Max) *.9
xp.Pointer:SetPos(xp:GetWide()*percent,ypos)
local text = xp.XPText
text:SetText(LocalPlayer():GetXP().."/"..LocalPlayer():GetRequiredXP() + LocalPlayer():GetXP().." XP")
text:SetFont("FOFont")
text:SetTextColor(Schema.GameColor)
text:SizeToContents()

self.InfoList = vgui.Create("pig_PanelList",self)
local info = self.InfoList
info:SetSize(self:GetWide() *.425,self:GetTall() *.45)
info:SetPos(mx + mw + (self:GetWide() *.05),self:GetTall() *.125)
info:EnableVerticalScrollbar(true)
info:EnableHorizontal(true)
hook.Call("pig_CharFrame_Open",GAMEMODE,self)
end

function PANEL:Paint()
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,150) )
draw.DrawText( "Overall : "..LocalPlayer():Armor(), "PigFontSmall", self:GetWide()*.655, self:GetTall()*.05, Schema.GameColor, TEXT_ALIGN_LEFT )
end 
vgui.Register("pig_CharFrame", PANEL, "DFrame")