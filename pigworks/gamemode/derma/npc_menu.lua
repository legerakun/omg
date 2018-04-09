local PANEL = {}

function PANEL:Init()
local mainframe = self
mainframe:MakePopup()
mainframe:ShowCloseButton(false)
mainframe:SetSize(ScrW()*.65,ScrH() *.25)
mainframe:SetPos(0,ScrH() *.675)
mainframe:CenterHorizontal()
mainframe:SetDraggable(false)
mainframe:SetTitle("")
mainframe:ShowClose(false)

self.choiceList = vgui.Create("pig_PanelList",mainframe)
choiceList = self.choiceList
choiceList:SetSize(mainframe:GetWide() *.875,mainframe:GetTall()*.775)
choiceList:SetPos(0,mainframe:GetTall() *.165)
choiceList:CenterHorizontal()
choiceList:SetSpacing(2)

hook.Call("pig_NPC_Menu_Open",GAMEMODE,self)
end

function PANEL:ReOpen()
pig.vgui.NPC_Menu = vgui.Create("NPC_Menu")
local pan = pig.vgui.NPC_Menu
local posx,posy = self:GetPos()
local w,h = self:GetSize()
pan:SetSize(w,h)
pan:SetPos(posx,posy)
if IsValid(self.CloseButton) then
pan:ShowClose(true)
else
pan:ShowClose(false)
end
pan:SetChoiceTable(self.Table)
self:Remove()
end

function PANEL:SetChoiceTable(table)
self.Table = table
for k,v in pairs(self.choiceList:GetItems()) do
v:Remove()
end
for k,v in SortedPairs(table[LocalPlayer().SelConvo].Choices,false) do
local base = vgui.Create("DButton")
base:SetSize(choiceList:GetWide(),choiceList:GetTall() *.2)
base.Col = Color(0,0,0,105)
base.Paint = function(self)
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), self.Col )
end
base.DoClick = function()
local func = v.Function
func()
end
base:SetText(v.Ask)
base:SetFont("PigFontSmall")
base:SetTextColor(Schema.GameColor)
base.OnCursorEntered = function(self)
self:SetTextColor(Color(255,255,255))
self.Col = Color(Schema.GameColor.r,Schema.GameColor.g,Schema.GameColor.b,70)
end
base.OnCursorExited = function(self)
self:SetTextColor(Schema.GameColor)
self.Col = Color(0,0,0,105)
end
self.choiceList:AddItem(base)
end
hook.Call("pig_NPC_ChoiceTable_Open",GAMEMODE,self)
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
self.CloseButton:SetSize(self:GetWide() *.065,self:GetTall()*.045)
self.CloseButton:SetPos(self:GetWide() *.91,self:GetTall() *.02)
self.CloseButton.Think = function(self)
if self.StopThink then return end
self:SetPos(self:GetParent():GetWide() *.91,self:GetParent():GetTall() *.02)
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

vgui.Register("NPC_Menu", PANEL, "DFrame")