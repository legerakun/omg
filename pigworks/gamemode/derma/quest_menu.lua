local PANEL = {}

function PANEL:ReOpen(times)
if self.Times >= 2 then
error("ReOpened panel 2 times with no quests!!")
return end
pig.vgui.QuestMenu = vgui.Create("quest_menu")
local pan = pig.vgui.QuestMenu
local posx,posy = self:GetPos()
local w,h = self:GetSize()
if IsValid(self:GetParent()) then
pan:SetParent(self:GetParent())
end
pan:SetSize(w,h)
if times then
  pan.Times = self.Times + 1
end
pan:SetPos(posx,posy)
if IsValid(self.CloseButton) then
pan:ShowClose(true)
else
pan:ShowClose(false)
end
self:Remove()
end

function PANEL:Init()
self.Times = self.Times or 0
if !LocalPlayer().Quests or LocalPlayer().Quests == nil then
net.Start("PW_ClQuest_Fetch_Names")
net.SendToServer()
self:ReOpen(true)
end
local col = Schema.GameColor
self:ShowCloseButton(false)
self:SetSize(ScrW() / 2,ScrH() *.6)
self:SetTitle("")
self:ShowClose(true)

if !IsValid(self.QuestList) then
self.QuestList = vgui.Create("pig_PanelList",self)
end
local questList = self.QuestList
questList:SetSize(self:GetWide() *.43,self:GetTall() *.85)
questList:SetPos(self:GetWide() *.045,0)
questList:CenterVertical()
questList:EnableVerticalScrollbar(true)
questList:EnableHorizontal(true)
questList.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
end
for k,v in pairs(questList:GetItems()) do v:Remove() end
for k,v in pairs(LocalPlayer().Quests or {}) do
local base = vgui.Create("DButton")
base:SetSize(questList:GetWide(),self:GetTall() *.125)
base:SetText(k)
base.Quest = k
base:SetFont("PigFont")
base.DoClick = function()
if !LocalPlayer().Quests[k].Objectives then
net.Start("PW_ClQuest_Fetch_Quest")
net.WriteString(k)
net.SendToServer()
timer.Simple(0.1,function()
if !IsValid(self) then return end
self:ReOpen()
end)
end
LocalPlayer().SelectedQuest = k
self:ReOpen()
end
if LocalPlayer():IsQuestComplete(k) then
base:SetTextColor(Color(col.r,col.g,col.b,71))
else
base:SetTextColor(col)
end
base.Paint = function(me)
draw.RoundedBox( 2, 0,0, me:GetWide(), me:GetTall(), Color(0,0,0,110))
if LocalPlayer():IsQuestComplete(k) then
surface.SetDrawColor( Color(col.r,col.g,col.b,111) )
else
surface.SetDrawColor(col)
end
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
end
questList:AddItem(base)
end

local px,py = questList:GetPos()
if !IsValid(self.ObjList) then
self.ObjList = vgui.Create("pig_PanelList",self)
end
local objList = self.ObjList
for k,v in pairs(objList:GetItems()) do v:Remove() end
objList:SetSize(self:GetWide() *.43,self:GetTall() *.85)
objList:SetPos(questList:GetWide() *1.1 + px,0)
objList:CenterVertical()
objList:EnableVerticalScrollbar(true)
objList:EnableHorizontal(true)
objList:SetSpacing(objList:GetTall() *.05)
objList.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
end

if !LocalPlayer().Quests or !LocalPlayer().Quests[LocalPlayer().SelectedQuest] then
LocalPlayer().SelectedQuest = nil
end

if LocalPlayer().SelectedQuest != nil and LocalPlayer().Quests[LocalPlayer().SelectedQuest].Objectives then
for k,v in SortedPairs(LocalPlayer().Quests[LocalPlayer().SelectedQuest].Objectives,true) do
if LocalPlayer().Quests[LocalPlayer().SelectedQuest].Stage >= k then
local base = vgui.Create("DPanel")
base:SetSize(objList:GetWide(),self:GetTall() *.5)
base.Paint = function(me)
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,100))
end

base.Complete = vgui.Create("DPanel",base)
local comp = base.Complete
comp:SetSize(objList:GetWide() *.04,base:GetTall() *.04)
comp:SetPos(base:GetWide() *.025,base:GetTall() *.025)
comp.Paint = function(me)
if LocalPlayer():IsQuestComplete(LocalPlayer().SelectedQuest) or LocalPlayer().Quests[LocalPlayer().SelectedQuest].Stage > k then
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(col.r,col.g,col.b,100))
else
surface.SetDrawColor( col )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
end
end

base.Text = vgui.Create("DLabel",base)
local text = base.Text
text:SetText(v)
text:SetFont("PigFontSmall")
text:SizeToContents()
text:SetPos(base:GetWide() *.1,base:GetTall() *.025)
surface.SetFont(text:GetFont())
text:SetText(pig.NewLines(text:GetText(),base,.115))
text:SizeToContents()
if LocalPlayer():IsQuestComplete(LocalPlayer().SelectedQuest) or LocalPlayer().Quests[LocalPlayer().SelectedQuest].Stage > k then
text:SetTextColor(Color(col.r,col.g,col.b,71))
else
text:SetTextColor(col)
end
base:SetTall(text:GetTall() *1.1)
text:CenterVertical()
objList:AddItem(base)
end
end
end

hook.Call("pig_QuestMenu_Open",GAMEMODE,self)
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

function PANEL:Paint()
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,135) )
end

vgui.Register("quest_menu", PANEL, "DFrame")