pig.Flags = pig.Flags or {}
local char = FindMetaTable("Player")

function pig.GetFlag(name)
return pig.Flags[name]
end

function pig.RegisterFlag(name,desc,tbl)
  if !tbl then
    pig.Flags[name] = {
	Description = desc
	}
  end
  pig.Flags[name] = {
  Description = desc,
  CanGive = tbl.CanGive,
  SuperAdmin = tbl.SuperAdmin,
  OnCharSelect = tbl.OnCharSelect,
  Loadout = tbl.Loadout,
  OnGive = tbl.OnGive,
  OnTake = tbl.OnTake
  }
end

function char:GetFlags()
  return self.Flags
end

function char:HasFlag(flag)
  if !pig.GetFlag(flag) then MsgC(Color(204,0,0),"[PigWorks FLAG]: Attempt to get non-existant flag!") end
  if self.Flags and self.Flags[flag] then
    return true
  end
end

if CLIENT then

concommand.Add("PW_GetFlags",function(ply,cmd,args)
if !ply:IsAdmin() then return end
MsgC(Color(204,204,204),"-----------[PigWorks FLAG]: Printing all flags-----------\n")
  for k,v in pairs(pig.Flags) do
    MsgC(Color(204,204,204),"[FLAG]: '"..k.."' "..v.Description.."\n")
  end
MsgC(Color(204,204,204),"---------------------------------------------------------\n")
end)

net.Receive("PW_RemoveAllF",function()
local ply = net.ReadEntity()
ply.Flags = {}
end)

net.Receive("PW_RemoveFlag",function()
local ply = net.ReadEntity()
local flag = net.ReadString()
  if ply.Flags and ply.Flags[flag] then
    ply.Flags[flag] = nil
  end
end)

net.Receive("PW_SendFlag",function()
local ply = net.ReadEntity()
local flag = net.ReadString()
ply.Flags = ply.Flags or {}
ply.Flags[flag] = true
end)

net.Receive("PW_SendAllF",function()
local ply = net.ReadEntity()
local flags = net.ReadTable()
ply.Flags = flags
end)

end