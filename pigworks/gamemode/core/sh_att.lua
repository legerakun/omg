print("Attributes + Levels loaded!")
local char = FindMetaTable("Player")

-------------------------------------
--Attributes
------------
pig.Attributes = pig.Attributes or {}
if SERVER then
util.AddNetworkString("PW_ReturnAtt")

function char:SetAttribute(name,amt,dontsend)
  if tonumber(amt) == nil then
    error("No valid integer provided!")
  return end
  if !self.Attributes[name] then
    error("No valid Attribute provided!")
  return end  
amt = tonumber(amt)
amt = math.Round(amt)  
amt = math.Clamp(amt,0,100)
self.Attributes[name].Point = amt
self:LockPoints()
  if !dontsend then
    hook.Call("UpdateAttributes",GAMEMODE,self)
  end
end

function GM:SetupAttributes(player)
player.Attributes = {}
  for k,v in pairs(pig.Attributes) do
      player.Attributes[v.Name] = {
      Point = 0,
      Lock = 0
      }
  end
  timer.Simple(1,function()
    if !IsValid(player) then return end
    hook.Call("UpdateAttributes",GAMEMODE,player)
  end)
end

function GM:UpdateAttributes(player)
  MsgC(Color(204,204,0),"[PigWorks]: Upadting "..player:Name().."'s Attributes")
  net.Start("PW_ReturnAtt")
  net.WriteTable(player.Attributes)
  net.Send(player)
end

concommand.Add("PW_SetAttribute",function(ply,cmd,args)
if !ply:IsSuperAdmin() then return end
if !args[1] or !args[2] then return end
if !pig.Attributes[args[2]] then Msg"[PigWorks]: Invalid Attribute!" return end
local theEnt = pig.FindPlayerByName( args[1] )
if theEnt == nil then Msg("[PigWorks]: Invalid Player!") return end
args[3] = tonumber(args[3]) or ( theEnt:GetAttributeValue(args[2]) )
theEnt:SetAttribute(args[2],args[3])
pig.AdminNotify(ply:GetName().." set "..theEnt:Name().."'s "..args[2].." attribute to "..args[3])
end)

end

function char:AddToAttribute(name,amt)
  if tonumber(amt) == nil then
    error("No valid integer provided!")
  return end
  if !self.Attributes[name] then
    error("No valid Attribute provided!")
  return end
local can = hook.Call("pig_AddToAttribute",GAMEMODE,self,name,amt)
if can == false then return false end
amt = tonumber(amt)
amt = math.Round(amt)
amt = math.Clamp(amt,0,100)
self.Attributes[name].Point = self.Attributes[name].Point + amt
hook.Call("pig_AddedToAttribute",GAMEMODE,self,name,amt)
end

function char:ActivateAttribute(name,args)
if !args then
error("Attribute Function arguments are either invalid or insufficient!")
return end
if !pig.Attributes[name] then
error("Attribute name is invalid!")
return end
pig.Attributes[name].Function(args)
end

function char:GetAttribute(name)
if !self.Attributes or !self.Attributes[name] then
return nil
else
return self.Attributes[name]
end
end

function char:GetAttributeValue(name)
  if !self.Attributes or !self.Attributes[name] then
    return nil
  else
    local point = self.Attributes[name].Point
	local new_point = hook.Call("pig_GetAttributeValue",GAMEMODE,self,name,point)
	point = new_point or point
    return point
  end
end

function GM:SetupAttributesTable()
local should,strength_pic,stamina_pic = hook.Call("pig_SetupAttributesTable",GAMEMODE)
if should == false then
return 
end
/*
pig.RegisterAttribute("Strength","How much damage your fists deal",strength_pic or "strength_icon.png",function(ply)
if SERVER then
PW_Notify(ply,Color(255,255,255),"You upgraded strength!")
end
end)
pig.RegisterAttribute("Stamina","How long you run for",stamina_pic or "stamina_icon.png",function(ply)
if SERVER then
PW_Notify(ply,Color(255,255,255),"You upgraded stamina!")
end
end)
*/
end

function pig.RegisterAttribute(name,desc,img,func)
pig.Attributes[name] = {
Name = name,
Description = desc,
Image = img,
Function = func
}
end

if CLIENT then
net.Receive("PW_ReturnAtt",function()
local tbl = net.ReadTable()
LocalPlayer().Attributes = tbl
end)
end
-----------------------------------
----
-----------------------------------




-----------------------------------
--Level System + Skill Points
--------------
if SERVER then
util.AddNetworkString("PW_SetAtt")
util.AddNetworkString("PW_LockPoints")
util.AddNetworkString("PW_LevelUp")
util.AddNetworkString("PW_SendHook_XPAdded")

concommand.Add("PW_AddXP",function(ply,cmd,args)
if !ply:IsSuperAdmin() then return end
if !args[2] or tonumber(args[2]) == nil then
Msg("[PW]: Invalid Amount!")
return end
local theEnt = args[1]
if !theEnt then 
Msg("[PW]: Player Name not provided!")
return end
theEnt = pig.FindPlayerByName(theEnt)
if theEnt == nil then
Msg("[PW]: Invalid Player!")
return end
theEnt:AddXP(tonumber(args[2]))
end)

concommand.Add("PW_SetLevel",function(ply,cmd,args)
if !ply:IsSuperAdmin() then return end
if tonumber(args[2]) == nil then args[2] = ply:GetLevel() + 1 end
local theEnt = pig.FindPlayerByName( args[1] )
if theEnt == nil then Msg("[PW]: Invalid Player!") return end
theEnt:SetLevel(tonumber(args[2]),true)
theEnt:AddSkillPoints(-theEnt:GetSkillPoints() + Schema.LevelPoints)
end)

concommand.Add("PW_ResetLevel",function(ply,cmd,args)
if !ply:IsSuperAdmin() then return end
local theEnt = args[1]
if theEnt == nil then Msg("[PW]: No Player Name provided!") return end
theEnt = pig.FindPlayerByName(theEnt)
if theEnt == nil then
Msg("[PW]: Invalid Player!")
return end
theEnt:SetLevel(1,true)
theEnt:SetXP(0)
theEnt:AddSkillPoints(-theEnt:GetSkillPoints() + Schema.LevelPoints)
end)

function char:AddSkillPoints(amt)
if tonumber(amt) == nil then
error("No valid integer provided!")
return end
amt = math.Round(amt)
self:SetCharVar("SkillPoints",self:GetSkillPoints() + amt,true)
end

function char:LockPoints()
if self:InEditor() then return end
  for k,v in pairs(self.Attributes) do
    v.Lock = v.Point
  end
end

function char:SetLevel(lvl,forced)
if tonumber(lvl) == nil then
error("No valid integer provided!")
return end
lvl = math.Round(lvl)
if lvl > Schema.MaxLevel then lvl = Schema.MaxLevel end
local ex_level = self:GetLevel()
if self:GetLevel() >= Schema.MaxLevel and !forced then 
if self:GetRequiredXP() <= 0 then self:SetXP(self:GetRequiredXP() + self:GetXP() ) end
return end
local new_lvl = hook.Call("pig_SetLevel",GAMEMODE,self,self:GetLevel(),lvl)
if new_lvl != nil then
lvl = new_lvl
end
self:SetCharVar("Level",lvl,true)
self:SetNWFloat("Level",lvl)
if self:GetRequiredXP() <= 0 and lvl > ex_level then
self:SetLevel(lvl + 1)
self:AddSkillPoints(Schema.LevelPoints)
elseif self:GetRequiredXP() <= 0 and lvl < ex_level then
local diff = ex_level - lvl
diff = Schema.LevelPoints * diff
self:SetXP(0)
if self:GetSkillPoints() - diff < 0 then
self:AddSkillPoints(-self:GetSkillPoints())
else
self:AddSkillPoints(self:GetSkillPoints() - diff)
end
end
end

function char:SetXP(xp,added)
if self:IsMaxLevelXP() then return end
if tonumber(xp) == nil then
error("No valid integer provided!")
return end
if xp > self:GetMaxLevelXP() then 
xp = self:GetMaxLevelXP()
end
if added != nil and added > self:GetMaxLevelXP() then
added = self:GetMaxLevelXP()
added = math.Round(added)
end
xp = math.Round(xp)
hook.Call("pig_XPSet",GAMEMODE,self,self:GetXP(),xp)
local req = self:GetRequiredXP()
self:SetCharVar("XP",xp,true)
  if self:GetRequiredXP() <= 0 then
    if self:GetLevel() >= Schema.MaxLevel then return end
    hook.Call("pig_LevelUp",GAMEMODE,self,self:GetLevel(),self:GetLevel() + 1)
      if !Schema.CarryOverXP then
        local toAdd = nil
          if added != nil then
            toAdd = added - req
         else
           toAdd = 0
        end
      self:SetCharVar("XP",toAdd,true)
      end
  self:SetLevel(self:GetLevel() + 1)
  end
end

function GM:pig_LevelUp(ply,pre_level,new_level)
ply:AddSkillPoints(Schema.LevelPoints)
if Schema.LevelPoints <= 0 then return end
net.Start("PW_LevelUp")
net.WriteFloat(pre_level)
net.WriteFloat(new_level)
net.Send(ply)
end

function GM:pig_HookXPAdded(ply,before,after,added)
net.Start("PW_SendHook_XPAdded")
net.WriteFloat(before)
net.WriteFloat(after)
net.WriteFloat(added)
net.Send(ply)
end

function char:AddXP(amt)
if self:IsMaxLevelXP() then return end
if !Schema.AddMaxLevelXP and self:GetLevel() >= Schema.MaxLevel then
return
end
if tonumber(amt) == nil then
error("No valid integer provided!")
return end
amt = math.Round(amt)
local new_amt = hook.Call("pig_XPAdded",GAMEMODE,self,self:GetXP(),self:GetXP() + amt,amt)
if new_amt != nil then
amt = new_amt
end
hook.Call("pig_HookXPAdded",GAMEMODE,self,self:GetXP(),self:GetXP() + amt,amt)
self:SetXP(self:GetXP() + amt,amt)
end

net.Receive("PW_SetAtt",function(_,ply)
local tbl = net.ReadTable()
local total = 0
  for k,v in pairs(tbl) do
    if !ply:GetAttribute(k) then return end
	total = total + v
  end
local points = ply:GetSkillPoints()
if total > points then return end
  for k,v in pairs(tbl) do
    local added = ply:AddToAttribute(k,v)
	if added == false then continue end
    ply:AddSkillPoints(-v)
  end
ply:LockPoints()
ply:SaveAllStats()
end)

net.Receive("PW_LockPoints",function(_,ply)
ply:LockPoints()
end)

end

function char:GetRequiredXP()
local upper = self:GetLevel() + 1
if upper > Schema.MaxLevel then upper = Schema.MaxLevel end
local fXP = 25*(3*upper+2)*(upper-1)
fXP = math.Round(fXP / 2)
return (fXP - self:GetXP())
end

function char:GetMaxLevelXP()
local upper = Schema.MaxLevel
local fXP = 25*(3*upper+2)*(upper-1)
fXP = math.Round(fXP / 2)
return (fXP)
end

function char:IsMaxLevelXP()
if self:GetRequiredXP() <= 0 and self:GetLevel() >= Schema.MaxLevel then
return true
end
end

function char:GetXP()
return tonumber(self:GetCharVar("XP"))
end

function char:GetLevel()
  if CLIENT then
    if self != LocalPlayer() then
	  return self:GetNWFloat("Level",0)
	end
  end
return tonumber(self:GetCharVar("Level"))
end

function char:GetSkillPoints()
return tonumber(self:GetCharVar("SkillPoints"))
end

if CLIENT then

net.Receive("PW_SendHook_XPAdded",function()
local before = net.ReadFloat()
local after = net.ReadFloat()
local added = net.ReadFloat()
hook.Call("pig_Cl_XPAdded",GAMEMODE,before,after,added)
end)

function GM:pig_Cl_XPAdded(before,after,added)
  if IsValid(pig.vgui.XPBar) then
    pig.vgui.XPBar:Remove()
  end
pig.vgui.XPBar = vgui.Create("pig_XPBar")
local bar = pig.vgui.XPBar
bar:AddBarXP(before,added)
end

net.Receive("PW_LevelUp",function()
local pre_level = net.ReadFloat()
local new_level = net.ReadFloat()
hook.Call("pig_Cl_LevelUp",GAMEMODE,pre_level,new_level)
end)

end