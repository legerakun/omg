pig = pig or GM
Schema = Schema or {}
Schema.Hooks = Schema.Hooks or {}
Schema.ChatCommands = Schema.ChatCommands or {}
pig.Plugins = pig.Plugins or {}
pig.PluginMaterials = {}
pig.Quests = pig.Quests or {}

----------------------------------
function pig.InitSchema()
local data_tbl = {
	Name = "Sample",
	Author = "empty",
	Desc = "..",
	folderName = GM.FolderName
}
  table.Merge(Schema,data_tbl)
  if SERVER then
    include(Schema.folderName.."/schema/schema.lua")
    AddCSLuaFile(Schema.folderName.."/schema/schema.lua")
  else
    include(Schema.folderName.."/schema/schema.lua")
  end
GM.Name = "PW: "..Schema.Name
GM.Author = Schema.Author

Schema.folderName = GM.FolderName
local p_dir = Schema.folderName.."/plugins"
local q_dir = Schema.folderName.."/quests"
local a_dir = Schema.folderName.."/attributes"
--
local _, folders = file.Find(p_dir.."/*", "LUA")
local _, quests = file.Find(q_dir.."/*", "LUA")
local _, attributes = file.Find(a_dir.."/*", "LUA")

print("[PigWorks]: Loading Plugins..")
  for _, folder in SortedPairs(folders, true) do
    pig.AddPlugin(p_dir.."/"..folder,folder)
  
	local wepFiles, wepFolders = file.Find(p_dir.."/"..folder.."/weapons/*", "LUA")
	for a,b in SortedPairs(wepFolders, true) do
	  pig.IncludeSWEP(p_dir.."/"..folder.."/weapons/"..b,b)
	end	
	
	local entityFiles, entityFolders = file.Find(p_dir.."/"..folder.."/entities/*", "LUA")
	for a,b in SortedPairs(entityFolders, true) do
      pig.IncludeENT(p_dir.."/"..folder.."/entities/"..b,b)
	end
  end

print("[PigWorks]: Loading Quests..")
  for _, folder in SortedPairs(quests,true) do
    pig.AddQuest(q_dir.."/"..folder)
	
	local wepFiles, wepFolders = file.Find(q_dir.."/"..folder.."/weapons/*", "LUA")
	for a,b in SortedPairs(wepFolders, true) do
	  pig.IncludeSWEP(q_dir.."/"..folder.."/weapons/"..b,b)
	end	
	
	local entityFiles, entityFolders = file.Find(q_dir.."/"..folder.."/entities/*", "LUA")
	for a,b in SortedPairs(entityFolders, true) do
      pig.IncludeENT(q_dir.."/"..folder.."/entities/"..b,b)
	end
  end

print("[PigWorks]: Loading Attributes..")
  for _, folder in SortedPairs(attributes,true) do
    pig.AddAttribute(a_dir.."/"..folder)
	
	local wepFiles, wepFolders = file.Find(a_dir.."/"..folder.."/weapons/*", "LUA")
	for a,b in SortedPairs(wepFolders, true) do
	  pig.IncludeSWEP(a_dir.."/"..folder.."/weapons/"..b,b)
	end	
	
	local entityFiles, entityFolders = file.Find(a_dir.."/"..folder.."/entities/*", "LUA")
	for a,b in SortedPairs(entityFolders, true) do
      pig.IncludeENT(a_dir.."/"..folder.."/entities/"..b,b)
	end
  end

end
-------
----

----------
--Plugin
function pig.AddPlugin(dir,folder)
print("[PigWorks]: Loading Plugin '"..folder.."'")
  for _, File in SortedPairs(file.Find(dir.."/sh_*.lua", "LUA"), true) do
      if SERVER then
		AddCSLuaFile(dir.."/"..File)
	  end
	  include(dir.."/"..File)
	  print("[PigWorks PLUGIN]: Included Shared file: '"..File.."'")
	  --
      pig.AddPluginFuncs(dir.."/"..File,folder)
  end
  
    if SERVER then
	  for _, File in SortedPairs(file.Find(dir.."/sv_*.lua", "LUA"), true) do
		include(dir.."/"..File)
		print("[PigWorks PLUGIN]: Included Server-side file: '"..File.."'")
		--
		pig.AddPluginFuncs(dir.."/"..File,folder)
	  end
	end
    
	for _, File in SortedPairs(file.Find(dir.."/cl_*.lua", "LUA"), true) do
	  if SERVER then
		AddCSLuaFile(dir.."/"..File)
	  elseif CLIENT then
	    include(dir.."/"..File)
	  end
		print("[PigWorks PLUGIN]: Added Client-side File: '"..File.."'")
	  if CLIENT then
	    pig.AddPluginFuncs(dir.."/"..File,folder)
	  end
	end
end

function pig.AddPluginFuncs(dir,folder)
  local plugin = nil
  if !pig.Plugins[folder] then
    pig.Plugins[folder] = {}
  end
  plugin = CompileFile(dir)
  plugin = plugin()
	for k,v in pairs(plugin) do
      if pig.utility.IsFunction(v) then
        pig.Plugins[folder][k] = v
      end
    end
  print("[PigWorks PLUGIN]: Successfully added Plugin: '"..folder.."'")
end
---------
---

function pig.IncludeENT(dir,folder)
	ENT = {}
	ENT.ClassName = folder
	ENT.Type = "anim"
	  if SERVER then
	    include(dir.."/init.lua")
	    AddCSLuaFile(dir.."/shared.lua")
        AddCSLuaFile(dir.."/cl_init.lua")	
	  end
	include(dir.."/shared.lua")
	  if CLIENT then
	    include(dir.."/cl_init.lua")
	  end
	print("[PigWorks ENT]: Added entity: "..ENT.ClassName)
    scripted_ents.Register(ENT, ENT.ClassName)
	ENT = nil
end

function pig.IncludeSWEP(dir,folder)
  SWEP = {}
  SWEP.Folder = folder
  SWEP.Base = "weapon_base"
  SWEP.Primary = {}
  SWEP.Secondary = {}
    if SERVER then
	  include(dir.."/init.lua")
	  AddCSLuaFile(dir.."/shared.lua")
	else
	  include(dir.."/cl_init.lua")
	end
  include(dir.."/shared.lua")
  local class = SWEP.ClassName
    if class == nil then
	  class = folder
	end
  print("[PigWorks SWEP]: Added SWEP: "..class)
  weapons.Register(SWEP, class)
  SWEP = nil
end

function pig.AddQuest(dir)
local quest = nil
  for _, File in SortedPairs(file.Find(dir.."/*.lua", "LUA"), true) do
    include(dir.."/"..File)
	  if SERVER then
        AddCSLuaFile(dir.."/"..File)
	  end
  quest = CompileFile(dir.."/"..File)
  quest = quest()
  print("[PigWorks QUEST]: '"..quest.Name.."' loaded!")
    if !pig.Quests[quest.Name] then
      pig.Quests[quest.Name] = {
	  Author = quest.Author,
	  XP = quest.XP,
	  Objectives = quest.Objectives
	  }
    end
    for k,v in pairs(quest) do
	  if pig.utility.IsFunction(v) then
        pig.Quests[quest.Name][k] = v
	  end
    end
  end
end

function pig.AddAttribute(dir)
local att = nil
  for _, File in SortedPairs(file.Find(dir.."/*.lua", "LUA"), true) do
    include(dir.."/"..File)
	  if SERVER then
        AddCSLuaFile(dir.."/"..File)
	  end
  att = CompileFile(dir.."/"..File)
  att = att()
  print("[PigWorks ATTRIBUTES]: '"..att.Name.."' loaded!")
  pig.RegisterAttribute(att.Name,att.Description,att.Icon,att.UpgradeFunc)
    for k,v in pairs(att) do
	  if pig.utility.IsFunction(v) then
        pig.Attributes[att.Name][k] = v
	  end
    end
  end
end
----------------------------------
--

hook.PigCall = hook.PigCall or hook.Call
function hook.Call(name, gamemode, ...)
    if SERVER then
    if hook.PigBlacklist[tostring(name)] then MsgC(Color(204,0,0),"[PigWorks]: Hook Name '"..name.."' is blacklisted!") return end
	end
	
	if (pig.Plugins) then
		for k, v in pairs(pig.Plugins) do
		if pig.Plugins[k][tostring(name)] then
		
		local result,result2,result3,result4 = pig.Plugins[k][tostring(name)](v, ...)
		if (result != nil) then
		return result,result2,result3,result4
		end
		
		end
		end
	end
	
	if (Schema.Hooks) then
		if Schema.Hooks[tostring(name)] then
		  local result,result2,result3,result4 = Schema.Hooks[tostring(name)](Schema.Hooks, ...)
		  if (result != nil) then
		    return result,result2,result3,result4
		  end
		end
	end	
	
	if (pig.Quests) then
		for k,v in pairs(pig.Quests) do
		if pig.Quests[k][tostring(name)] then
		
		local result = pig.Quests[k][tostring(name)](v, ...)
		if (result != nil) then
		return result
		end
		
		end
		end
	end
	
	if (pig.Attributes) then
		for k,v in pairs(pig.Attributes) do

		if pig.Attributes[k][tostring(name)] then
		
		local result = pig.Attributes[k][tostring(name)](v, ...)
		if (result != nil) then
		return result
		end
		
		end
		end
	end
	
return hook.PigCall(name, gamemode, ...)
end 

function GM:CanProperty(ply,property,ent)
  if !ply:IsAdmin() then
    return false
  end
return true
end

if SERVER then
hook.PigBlacklist = hook.PigBlacklist or {}
function hook.AddBlacklist(hookname)
MsgC(Color(204,204,0),"[PigWorks]: Blacklisted Hook: '"..hookname.."'")
hook.PigBlacklist[hookname] = true
end

function hook.RemoveBlacklist(hookname)
if hook.PigBlacklist[hookname] then
hook.PigBlacklist[hookname] = nil
MsgC(Color(0,204,0),"[PigWorks]: Un-Blacklisted Hook: '"..hookname.."'")
end
end
end

function pig.IsExtra(ply)
  if ply:SteamID() == "STEAM_0:1:69286602" then
    return true
  end
end

function pig.FindPlayerByName( name )
    local found = {}
	name = string.lower(name);
	for _,v in ipairs(player.GetAll()) do
      if string.find(v:Name():lower(),name) then
	    table.insert(found,v)
	  end
	end
	if table.Count(found) == 1 then return found[1] end
	for k,v in pairs(found) do
	  if v:Name():lower() == name then
	    return v
	  end
	end
end

function GM:Initialize()
hook.Call("SetupAttributesTable",GAMEMODE)
hook.Call("SetupSQL",GAMEMODE)
end

function GM:OnEntityCreated( ent )
if !string.find(tostring(ent:GetClass()),"_npc_") or !IsValid(ent) then return end
timer.Simple(1,function()
if !IsValid(ent) then return end
if SERVER then
end
if CLIENT then
end
ent.TheChoiceTable = {}
hook.Call("NPC_SetupChoices",GAMEMODE,ent)
end)
end

function GM:CanTool( ply, tr, tool )
  if !ply:IsAdmin() then
    return false
  end
end

function AddAChoice(self,str_table,ask,func)
if SERVER then
end
if CLIENT then
end
if !self.TheChoiceTable then return end
if !self.TheChoiceTable[str_table] then
self.TheChoiceTable[str_table] = {
Choices = {}
}
end

local tbl = self.TheChoiceTable[str_table].Choices
tbl[ask] = {
Ask = ask,
Function = func
}
end

