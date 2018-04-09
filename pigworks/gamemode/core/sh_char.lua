local char = FindMetaTable("Player")

----------------------------------
----RP NAME Override-------
char.GetOldName = char.GetOldName or char.Nick
function char:GetRPName()
local name = "Butch DeLoria"
local rpname = self:GetNWString("RPName", "")
rpname = rpname or name
  if rpname and rpname:len() >= Schema.MinimumChar then
    name = rpname
  else
    local oldname = self:GetOldName()
	if oldname != "" then
      name = oldname
	end
  end
return name
end
function char:GetKnownName()

end
function char:Nick()
local name = self:GetRPName()
return name
end
function char:Name()
local name = self:GetRPName()
return name
end
---------------------------------
---------------------------------
function char:GetGender()
return tostring(self:GetNWString("Gender"))
end

function char:GetDesc()
if self:IsBot() then
return "Medium Height | Average Build | Plain Face | Simple Eyes"
end
return tostring(self:GetNWString("Description"))
end

function char:GetCharID()
  if SERVER then
    if self.CharID != nil then return self.CharID end
  end
  local id = self:GetNWString("CharacterID")
  if id == "" then return end
return id
end

function char:IsDonator()
  if table.HasValue(Schema.VIPGroups,self:GetUserGroup()) or self:IsSuperAdmin() then
    return true
 end
end

function char:GetCharVar(name)
if !self.CharVars then error("No character variables!!!") end
return self.CharVars[name]
end

function PlayerByCharID(id)
  for k,v in pairs(player.GetAll()) do
    if v:GetCharID() == id then
      return v
    end
  end
end

function char:InEditor()
  if SERVER then
    if self:GetNWBool("InEditor") == true or self:Team() == 0 or !self.CharVars then
      return true
    end
  else
    if self:GetNWBool("InEditor") == true or self:Team() == 0 or self == LocalPlayer() and !self.CharVars then
      return true
    end    
  end
end

if SERVER then
util.AddNetworkString("PW_DeleteChar")
util.AddNetworkString("PW_ChangeName")
util.AddNetworkString("PW_ChangeDesc")
util.AddNetworkString("PW_ResetCl")

net.Receive("PW_ChangeName",function(_,ply)
  if !ply:IsModerator() then 
    ply:Kick("Messing with Critical Net Messages (NOT ADMIN)")
  return end
local name = net.ReadString()
local new = net.ReadString()
local ply2 = pig.FindPlayerByName(name)
if !IsValid(ply2) or ply2:InEditor() then return end
  if new == "" or new:len() < Schema.MinimumChar or new == ply2:GetName() then
    MsgC(Color(204,0,0),"[PigWorks]: Unable to change name, invalid name provided!\n")
    return
  end
local str = "Steam Name: '"..ply:GetName().."' changed the name of: '"..ply2:Name().."' to '"..new.."'"
pig.ChatPrintAll(str, Color(255,255,255))
pig.AdminNotify(str)
ply2.CharVars["Name"] = new
ply2:SetNWString("RPName",new)
ply2:SaveAllStats()
end)

net.Receive("PW_ChangeDesc",function(_,ply)
  if !ply:IsModerator() then 
    ply:Kick("Messing with Critical Net Messages")
  return end
local name = net.ReadString()
local new = net.ReadString()
local ply2 = pig.FindPlayerByName(name)
if !IsValid(ply2) or ply2:InEditor() then return end
local str = "Steam Name: '"..ply:GetName().."' changed the description of: '"..ply2:Name().."'"
pig.ChatPrintAll(str, Color(255,255,255))
pig.AdminNotify(str)
ply2.CharVars["Description"] = new
ply2:SetNWString("Description",new)
ply2:SaveAllStats()
end)

net.Receive("PW_DeleteChar",function(_,ply)
  if !ply:IsSuperAdmin() then 
    ply:Kick("Messing with Critical Net Messages (NOT ADMIN)")
  return end
local name = net.ReadString()
local ply2 = pig.FindPlayerByName(name)
if !IsValid(ply2) or ply2:InEditor() then return end
local str = "Steam Name: '"..ply:GetName().."' Deleted the character: '"..ply2:Name().."', belonging to: '"..ply2:GetName().."'"
pig.ChatPrintAll(str, Color(255,255,255))
pig.AdminNotify(str)
DeletePlayerCharacter(ply2)
end)

function DeletePlayerCharacter(ply)
if !IsValid(ply) then return end
if ply:GetCharID() == "" or ply:GetCharID() == nil or ply:InEditor() then
Msg("[PigWorks]: Player has no character selected!\n")
return end
local id = ply:GetCharID()
pig.DeleteCharacter(id)
--
net.Start("PW_ResetCl")
net.WriteString(id)
net.Send(ply)
ply.pig_SentChars[id] = nil
---
ply:SetNWString("CharacterID","")
ply:Spectate(OBS_MODE_CHASE)
ply:SetNWBool("InEditor",true)
ply:StripWeapons()
ply.CharID = nil
ply.CharVars = {}
ply.Attributes = {}
ply:OpenLoadScreen()
Msg("[PigWorks]: Successfully deleted the character '"..ply:Name().."' from the database\n")
end

end
