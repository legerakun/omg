local char = FindMetaTable("Player")

function char:GetCharID()
return self:GetNWString("CharacterID")
end

function pig.DeleteCharacter(id)
if !id then return end
  for k,v in pairs(ClientCharacterTable) do
    if v.char_id == id then
	  ClientCharacterTable[k] = nil
	end
  end
  for k,v in pairs(ClientCharVar) do
    if v.char_id == id then
	  ClientCharVar[k] = nil
	end
  end  
net.Start("PW_PDeleteChar")
net.WriteString(id)
net.SendToServer()
end

function pig.SelectCharacter(id)
local can = hook.Call("pig_CanClientSelChar",GAMEMODE,id)
if can == false then return end
net.Start("PW_SelectChar")
net.WriteString(id)
net.SendToServer()
end

function pig.CreateClientChar(char_vars)
net.Start("PW_CreateChar")
net.WriteTable(char_vars)
net.SendToServer()
end

function pig.OpenLoadScreen()
  if !IsValid(pig.vgui.WaitingScreen) then
    pig.vgui.WaitingScreen = vgui.Create("pig_WaitScreen")
  end
  if IsValid(pig.vgui.LoadScreen) then
    pig.vgui.LoadScreen:Remove()
  end
pig.vgui.LoadScreen = vgui.Create("pig_LoadScreen")
hook.Call("pig_InLoadScreen",GAMEMODE)
local loadscreen = pig.vgui.LoadScreen
end

net.Receive("PW_Sh_RCharVar",function()
local name = net.ReadString()
  if LocalPlayer().CharVars and LocalPlayer().CharVars[name] then
    LocalPlayer().CharVars[name] = nil
  end
end)

net.Receive("PW_SendClCharVars",function()
local char_vars = net.ReadTable()
LocalPlayer().CharVars = char_vars
end)

net.Receive("PW_ResetCl",function()
local id = net.ReadString()
  for k,v in pairs(ClientCharacterTable) do
    if v.char_id == id then
	  ClientCharacterTable[k] = nil
	end
  end
  for k,v in pairs(ClientCharVar) do
    if v.char_id == id then
	  ClientCharVar[k] = nil
	end
  end  
LocalPlayer().CharVars = nil
LocalPlayer().Inventory = nil
LocalPlayer().Attribues = nil
end)

net.Receive("PW_FirstCon",function()
hook.Call("pig_FirstTimeConnected",GAMEMODE,LocalPlayer())
end)

net.Receive("PW_OpenLoadScreen",function()
pig.OpenLoadScreen()
end)

net.Receive("PW_UpdateCharTable",function()
local char_tbl = net.ReadTable()
local charvar_tbl = net.ReadTable()
  if !ClientCharacterTable then
    ClientCharacterTable = char_tbl
    ClientCharVar = charvar_tbl
  else
    local ct_count = table.Count(ClientCharacterTable)
	local cv_count = table.Count(ClientCharVar)
    for k,v in pairs(char_tbl) do
	  ClientCharacterTable[ct_count+k] = v
	end
    for k,v in pairs(charvar_tbl) do
	  ClientCharVar[cv_count+k] = v
	end	
  end
end)

net.Receive("PW_Sh_CharVar",function()
local ply = LocalPlayer()
if !ply.CharVars then ply.CharVars = {} end
local val_type = net.ReadString()
local name = net.ReadString()
local val = nil
  if val_type == "table" then
    val = net.ReadTable()
  elseif val_type == "float" then
    val = net.ReadFloat()
  elseif val_type == "int" then
    val = net.ReadFloat()
  else
    val = net.ReadString()
  end
local prev_val = ply.CharVars[name]
hook.Call("pig_CharVarChanged",GAMEMODE,ply,name,prev_val,val,true)
ply.CharVars[name] = val
end)

net.Receive("PW_SendHook_SelChar",function()
local inv = net.ReadTable()
local id = net.ReadFloat()
local wg = net.ReadFloat()
LocalPlayer().Inventory = inv
LocalPlayer().WG = wg
hook.Call("pig_Cl_SelectedChar",GAMEMODE,id)
end)

net.Receive("PW_ResetClCharVars",function()
LocalPlayer().CharVars = {}
end)

function GM:pig_Cl_SelectedChar(id)
LocalPlayer().Quests = nil
net.Start("PW_ClQuest_Fetch_Names")
net.SendToServer()
end