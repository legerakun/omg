AddCSLuaFile()
ENT.Base 			= "base_nextbot"
ENT.Spawnable		= false
ENT.PrintName       = "base_npc"
ENT.Category = "PigWorks"
if SERVER then
util.AddNetworkString("PW_NPC_Talk")
util.AddNetworkString("PW_SortChoices")

function ENT:Initialize()
self:NPCInit()
end

function ENT:AcceptInput( Name, Activator, Caller )
if Activator.cantUse then return end
Activator.cantUse = true
		timer.Simple(1.5, function()
			Activator.cantUse = false
		end)
local can = self:Used(Activator)
if can == false then return end
net.Start("PW_NPC_Talk")
net.WriteEntity(self)
net.Send(Activator)
end

end

hook.Add("NPC_SetupChoices","NPC_SetupChoices_Base",function(self)
local talk = {".."}
AddAChoice(self,"Greet","... <Leave>",function()
NPCSay({TextTable = talk,SoundTable = {"bye"}},pig.vgui.NPC_Menu:Remove())
end)
end)

if CLIENT then
net.Receive("PW_NPC_Talk",function()
local ent = net.ReadEntity()
if LocalPlayer().SelConvo == nil or !ent.TheChoiceTable[LocalPlayer().SelConvo] then
LocalPlayer().SelConvo = "Greet"
end
pig.vgui.NPC_Menu = vgui.Create("NPC_Menu")
pig.vgui.NPC_Menu:SetChoiceTable(ent.TheChoiceTable)
end)

end
