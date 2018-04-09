local char = FindMetaTable("Player")

if SERVER then
util.AddNetworkString("PW_ClQuest_Fetch_Names")
util.AddNetworkString("PW_ClQuest_Send_Names")
util.AddNetworkString("PW_ClQuest_Fetch_Quest")
util.AddNetworkString("PW_ClQuest_Send_Quest")
---------------------------------------------------------
util.AddNetworkString("PW_SendHook_QuestGiven")
util.AddNetworkString("PW_SendHook_QuestDone")
util.AddNetworkString("PW_SendHook_QuestProg")
function GM:SetupQuests(ply)
ply.Quests = {}
timer.Simple(1,function()
hook.Call("UpdateClientQuests",GAMEMODE,ply)
end)
end

function GM:UpdateClientQuests()

end

function char:GiveQuest(name)
if self:InEditor() then return end
if self.Quests[name] then
self.Quests[name] = nil
end
if !pig.Quests[name] then
error("Quest does not exist!")
return end
local tbl = pig.Quests[name]
PW_Notify(self,Schema.GameColor,"Quest: '"..name.."' started!")
self.Quests[name] = {
Stage = 1,
QuestVars = {}
}
hook.Call("UpdateClientQuests",GAMEMODE,self)
hook.Call("pig_QuestGiven",GAMEMODE,self,name)
end

function char:ProgressQuestStage(index)
local quest = self:GetQuest(index)
if quest and pig.Quests[index].Objectives[self.Quests[index].Stage + 1] then
self.Quests[index].Stage = self.Quests[index].Stage + 1
hook.Call("pig_QuestProgressed",GAMEMODE,self,self.Quests[index].Stage - 1,self.Quests[index].Stage,index)
else
self:CompleteQuest(index)
end
hook.Call("UpdateClientQuests",GAMEMODE,self)
end

function char:CompleteQuest(index)
if !self.Quests[index] then
error("Uknown Quest!")
return end
if self:IsQuestComplete(index) then
Msg("Quest already Complete!")
return end
local xp = pig.Quests[index].XP
hook.Call("pig_QuestCompleted",GAMEMODE,self,index)
self.Quests[index].Completed = true
local total = 0
for k,v in pairs(pig.Quests[index].Objectives) do
total = total + 1
end
self.Quests[index].Stage = total
self:AddXP(xp)
hook.Call("UpdateClientQuests",GAMEMODE,self)
end

function char:SetQuestVar(index,varname,var)
if self.Quests[index] then
self.Quests[index].QuestVars[varname] = var
end
hook.Call("UpdateClientQuests",GAMEMODE,self)
end

function char:SetObjectiveText(index,stage,text)
if self.Quests[index] then
self.Quests[index].Objectives[stage] = text
end
hook.Call("UpdateClientQuests",GAMEMODE,self)
end

function GM:pig_QuestProgressed(ply,prev_stage,new_stage,index)
net.Start("PW_SendHook_QuestProg")
net.WriteFloat(prev_stage)
net.WriteFloat(new_stage)
net.WriteString(index)
net.Send(ply)
end

function GM:pig_QuestGiven(ply,name)
net.Start("PW_SendHook_QuestGiven")
net.WriteString(name)
net.Send(ply)
end

function GM:pig_QuestCompleted(ply,index)
net.Start("PW_SendHook_QuestDone")
net.WriteString(index)
net.Send(ply)
end

net.Receive("PW_ClQuest_Fetch_Names",function(_,ply)
local tbl = {}
for k,v in pairs(ply.Quests) do
tbl[#tbl + 1] = k
end
net.Start("PW_ClQuest_Send_Names")
net.WriteTable(tbl)
net.Send(ply)
end)

net.Receive("PW_ClQuest_Fetch_Quest",function(_,ply)
local index = net.ReadString()
if !ply.Quests[index] then return end
local stage = ply.Quests[index].Stage
net.Start("PW_ClQuest_Send_Quest")
net.WriteFloat(stage)
net.WriteString(index)
local bool = false
if ply:IsQuestComplete(index) then
bool = true
end
net.WriteBool(bool)
net.Send(ply)
end)

end

function char:GetQuestVar(index,var)
if self.Quests[index] then
if self.Quests[index].QuestVars[var] then
return self.Quests[index].QuestVars[var]
end
end
end

function char:IsQuestComplete(index)
if !self.Quests[index] then return end
if self.Quests[index].Completed then return true end
end

function char:GetQuest(index)
if self.Quests[index] then
return self.Quests[index]
end
end

function char:GetQuestStage(index)
local quest = self:GetQuest(index)
if quest and quest.Stage != nil then
return quest.Stage
else
return 1
end
end

function char:GetQuestObjective(index)
local quest = self:GetQuest(index)
if quest then
return quest.Objectives[self:GetQuestStage()]
end
end

if CLIENT then

net.Receive("PW_SendHook_QuestProg",function()
local col = Schema.GameColor
local prev_stage = net.ReadFloat()
local new_stage = net.ReadFloat()
local index = net.ReadString()
hook.Call("pig_Cl_QuestProg",GAMEMODE,prev_stage,new_stage,index)
pig.vgui.PrevObjBase = vgui.Create("DPanel")
local prev_objBase = pig.vgui.PrevObjBase
prev_objBase:SetSize(ScrW() *.2,ScrH() *.25)
prev_objBase:SetPos(ScrW() *.025,ScrH()*.4)
prev_objBase.Text = vgui.Create("DLabel",prev_objBase)
prev_objBase.Paint = function(self)
draw.RoundedBox( 2, 0, 0, self:GetWide() *.05, ScrH() *.015, Color(col.r,col.g,col.b,100))
end
local text = prev_objBase.Text
text:SetPos(prev_objBase:GetWide() *.1,0)
text:SetFont("PigFontSmall")
hook.Call("pig_SetFont_ObjComplete",GAMEMODE,text)
surface.SetFont(text:GetFont())
text:SetText(pig.NewLines("COMPLETED: "..pig.Quests[index].Objectives[prev_stage],prev_objBase,.115))
text:SizeToContents()
text:SetTextColor(Schema.GameColor)
prev_objBase:SetTall(text:GetTall() *1.25)
timer.Simple(3,function()
if !IsValid(prev_objBase) then return end
prev_objBase:Remove()
end)
end)

net.Receive("PW_SendHook_QuestGiven",function()
local name = net.ReadString()
hook.Call("pig_Cl_QuestGiven",GAMEMODE,name)
end)

net.Receive("PW_SendHook_QuestDone",function()
local index = net.ReadString()
hook.Call("pig_Cl_QuestCompleted",GAMEMODE,index)
end)

function pig.QuestNotify(text1,text2)
if IsValid(pig.vgui.QuestNotify) then
pig.vgui.QuestNotify:Remove()
end
pig.vgui.QuestNotify = vgui.Create("DPanel")
local notify = pig.vgui.QuestNotify
notify.Paint = function(me)
return
end
notify.Text = vgui.Create("DLabel",notify)
notify.Text:SetText(text1)
notify.Text:SetTextColor(Schema.GameColor)
notify.Text:SetFont("PigFontTiny")
notify.Text:SizeToContents()
notify.Text2 = vgui.Create("DLabel",notify)
notify.Text2:SetText(text2)
notify.Text2:SetTextColor(Schema.GameColor)
notify.Text2:SetFont("PigFont")
notify.Text2:SizeToContents()
notify:SetSize(notify.Text2:GetWide() *1.2,notify.Text2:GetTall() + notify.Text:GetTall())
notify.Text:SetPos(0,0)
notify.Text2:SetPos(0,notify.Text:GetTall())
timer.Simple((Schema.QuestNotifyTime or 6),function()
if !IsValid(notify) then return end
notify:Remove()
end)
hook.Call("pig_QuestNotify",GAMEMODE,notify)
local longest = nil
if notify.Text2:GetWide() > notify.Text:GetWide() then
longest = notify.Text2
else
longest = notify.Text
end
notify:SetSize(longest:GetWide() *1.2,notify.Text2:GetTall() + notify.Text:GetTall())
notify:SetPos(ScrW() - notify:GetWide() *1.1,ScrH() *.35)
notify.Text:SizeToContents()
notify.Text2:SizeToContents()
notify.Text:SetPos(0,0)
notify.Text2:SetPos(0,notify.Text:GetTall())
hook.Call("pig_QuestNotify_Pos",GAMEMODE,notify)
end

function GM:pig_Cl_QuestGiven(name)
pig.QuestNotify("Quest Added",name)
if !LocalPlayer().Quests or LocalPlayer().Quests == nil then
return
end
LocalPlayer().Quests[name] = {}
end

function GM:pig_Cl_QuestCompleted(name)
pig.QuestNotify("Quest Completed",name)
if !LocalPlayer().Quests or LocalPlayer().Quests == nil then return end
LocalPlayer().Quests[name].Completed = true
end

function GM:pig_Cl_QuestProg(prev_stage,new_stage,index)
if !LocalPlayer().Quests or LocalPlayer().Quests == nil then 
return
end
LocalPlayer().Quests[index].Stage = new_stage
end

net.Receive("PW_ClQuest_Send_Names",function()
local tbl = net.ReadTable()
LocalPlayer().Quests = {}
for k,v in pairs(tbl) do
if !LocalPlayer().Quests[v] then
LocalPlayer().Quests[v] = {}
end
end
end)

net.Receive("PW_ClQuest_Send_Quest",function()
local stage = net.ReadFloat()
local name = net.ReadString()
local completed = net.ReadBool()
if !LocalPlayer().Quests or LocalPlayer().Quests == nil then 
return
end
LocalPlayer().Quests[name].Objectives = pig.Quests[name].Objectives
LocalPlayer().Quests[name].Stage = stage
LocalPlayer().Quests[name].Completed = completed
end)

end
