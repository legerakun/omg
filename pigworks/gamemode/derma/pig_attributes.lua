local PANEL = {}

function PANEL:ReOpen()
pig.vgui.Attributes = vgui.Create("pig_Attributes")
local pan = pig.vgui.Attributes
local posx,posy = self:GetPos()
local w,h = self:GetSize()
if IsValid(self:GetParent()) then
pan:SetParent(self:GetParent())
end
pan:SetSize(w,h)
pan:SetPos(posx,posy)
  if IsValid(self.CloseButton) then
    pan:ShowClose(true)
  else
    pan:ShowClose(false)
  end
end

function PANEL:Init()
self.Sizes = ScrW() / 2,ScrH() *.6
self:ShowCloseButton(false)
self.SkillPoints = LocalPlayer():GetSkillPoints()
self:SetSize(ScrW() / 2,ScrH() *.6)
self:SetTitle("")
self:ShowClose(true)
if !IsValid(self.AttributeTable) then
self.AttributeTable = vgui.Create("pig_PanelList",self)
end
local list = self.AttributeTable
list:SetSize(self:GetWide() *.435,self:GetTall() *.925)
list:SetPos(self:GetWide() *.05,0)
list:EnableVerticalScrollbar(true)
list:EnableHorizontal(true)
list:SetSpacing(5)
list:CenterVertical()
for k,v in pairs(self.AttributeTable:GetItems()) do v:Remove() end
local copy_tab = table.Copy(LocalPlayer().Attributes)
for k,v in pairs(copy_tab) do
local base = vgui.Create("DButton")
base:SetSize(list:GetWide(),list:GetTall() *.275)
base:SetFont("PigFont")
base:SetText("")
base.Orig = (v.Point+0)
base.Val = (v.Point+0)
base.OnCursorEntered = function(me)
self.SelectedImage = Material(pig.Attributes[k].Image)
surface.SetFont(self.DescPanel.Text:GetFont())
self.DescPanel.Text:SetText(pig.NewLines(pig.Attributes[k].Description,self.DescPanel))
self.DescPanel.Text:SizeToContents()
end
base:SetTextColor(Schema.GameColor)
base.Attribute = k
base.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
draw.RoundedBox( 2, 0, 0, me:GetWide(), me:GetTall(), Color(0,0,0,105) )
draw.SimpleText(k, "PigFont", me:GetWide() *.5, me:GetTall() *.15, Schema.GameColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
draw.SimpleText(v.Point, "PigFont", me:GetWide() *.5, me:GetTall() *.65, Schema.GameColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
end

base.plus = vgui.Create("DButton",base)
base.plus:SetText("+")
base.plus:SetSize(base:GetWide() *.125,base:GetTall() *.225)
base.plus:SetPos(base:GetWide() *.825,0)
base.plus:CenterVertical()
base.plus:SetFont("PigFont")
base.plus:SetTextColor(Schema.GameColor)
base.plus.OnCursorEntered = function(me)
me:SetTextColor(Color(255,255,255))
self.SelectedImage = Material(pig.Attributes[k].Image)
self.DescPanel.Text:SetText(pig.NewLines(pig.Attributes[k].Description,self.DescPanel))
self.DescPanel.Text:SizeToContents()
end
base.plus.OnCursorExited = function(me)
me:SetTextColor(Schema.GameColor)
end
base.plus.DoClick = function(me)
if self.SkillPoints <= 0 or me:GetParent().Orig >= 100 then return end
self.SkillPoints = self.SkillPoints - 1
v.Point = v.Point+1
me:GetParent().Val = v.Point
end
base.plus.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
draw.RoundedBox( 2, 0, 0, me:GetWide(), me:GetTall(), Color(0,0,0,105) )
end

base.minus = vgui.Create("DButton",base)
base.minus:SetText("-")
base.minus:SetSize(base:GetWide() *.125,base:GetTall() *.225)
base.minus:SetPos(base:GetWide() *.05,0)
base.minus:CenterVertical()
base.minus:SetFont("PigFont")
base.minus:SetTextColor(Schema.GameColor)
base.minus.OnCursorEntered = function(me)
me:SetTextColor(Color(255,255,255))
self.SelectedImage = Material(pig.Attributes[k].Image)
self.DescPanel.Text:SetText(pig.NewLines(pig.Attributes[k].Description,self.DescPanel))
self.DescPanel.Text:SizeToContents()
end
base.minus.OnCursorExited = function(me)
me:SetTextColor(Schema.GameColor)
end
base.minus.DoClick = function(me)
if v.Point <= me:GetParent().Orig then return end
v.Point = v.Point - 1
self.SkillPoints = self.SkillPoints + 1
me:GetParent().Val = v.Point
end
base.minus.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
draw.RoundedBox( 2, 0, 0, me:GetWide(), me:GetTall(), Color(0,0,0,105) )
end

list:AddItem(base)
end

if !IsValid(self.PrevPic) then
self.PrevPic = vgui.Create("DPanel",self)
end
self.PrevPic:SetSize(self:GetWide() *.2,self:GetTall() *.245)
self.PrevPic:SetPos(self:GetWide() *.625,self:GetTall() *.165)
self.PrevPic.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
surface.SetMaterial( self.SelectedImage or Material("default_skill.png") )
surface.DrawTexturedRect( 0, 0, me:GetWide(), me:GetTall() )
end

if !IsValid(self.DescPanel) then
self.DescPanel = vgui.Create("DPanel",self)
end
local descPanel = self.DescPanel
descPanel:SetSize(self:GetWide() *.375,self:GetTall() *.45)
descPanel:SetPos(self:GetWide() *.55,self:GetTall() *.465)
descPanel.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
draw.RoundedBox( 2, 0, 0, me:GetWide(), me:GetTall(), Color(0,0,0,105) )
end
if !IsValid(descPanel.Text) then
descPanel.Text = vgui.Create("DLabel",descPanel)
end
local desc = descPanel.Text
desc:SetPos(descPanel:GetWide() *.025,descPanel:GetTall() *.05)
desc:SetText(self.SelectedDesc or "....")
desc:SetFont("PigFontSmall")
desc:SetTextColor(Schema.GameColor)
desc:SizeToContents()
surface.SetFont(desc:GetFont())
desc:SetText(pig.NewLines(desc:GetText(),descPanel))
desc:SizeToContents()

hook.Call("pig_Attributes_Open",GAMEMODE,self)
end

function PANEL:Paint()
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,105) )
draw.SimpleText("Points: "..self.SkillPoints or LocalPlayer():GetSkillPoints(), "PigFontSmall", self:GetWide() *.665, self:GetTall() *.05, Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
end

function PANEL:ShowClose(bool)
  if bool then
  if IsValid(self.CloseButton) then self.CloseButton:Remove() end
  self.CloseButton = pig.CreateButton(self,"Close","PigFontTiny")
  self.CloseButton:SetSize(self:GetWide() *.065,self:GetTall()*.045)
  self.CloseButton:SetPos(self:GetWide() *.91,self:GetTall() *.02)
  self.CloseButton.Think = function(self)
    if self.StopThink then return end
    self:SetPos(self:GetParent():GetWide() *.91,self:GetParent():GetTall() *.02)
  end
  self.CloseButton.DoClick = function(self)
  --
  local atts = {}
  local total = 0
    for k,v in pairs(self:GetParent().AttributeTable:GetItems()) do
      local point = v.Val - v.Orig
      total = total + point
  	  atts[v.Attribute] = point
	  LocalPlayer():AddToAttribute(v.Attribute,point)
	  --LocalPlayer().Attributes[v.Attribute] = {Point = v.Orig + point,Lock = v.Orig + point}
    end
    --
    if total > 0 then
      net.Start("PW_SetAtt")
      net.WriteTable(atts)
      net.SendToServer()
    end
    self:GetParent():Remove()
    end
  else
    if IsValid(self.CloseButton) then
      self.CloseButton:Remove()
    end
  end
end

vgui.Register("pig_Attributes", PANEL, "DFrame")