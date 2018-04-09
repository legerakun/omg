Fallout_PerkTbl = Fallout_PerkTbl or {}
local char = FindMetaTable("Player")

function Fallout_RegisterPerk(name,flag_name,desc,icon,flag_tbl)
flag_tbl.SuperAdmin = true
Fallout_PerkTbl[name] = {Icon = icon, Flag = flag_name}
pig.RegisterFlag(flag_name,desc,flag_tbl)
end

function Fallout_GetPerks()
return Fallout_PerkTbl
end

function Fallout_PerkIcon(name)
return Fallout_PerkTbl[name].Icon
end

function Fallout_PerkDescription(name)
local fname = Fallout_PerkFlagName(name)
return pig.GetFlag(fname).Description
end

function Fallout_PerkFlagName(name)
return Fallout_PerkTbl[name].Flag
end

function Fallout_PerkToFlag(name)
local index = Fallout_PerkFlagName(name)
return pig.GetFlag(index)
end
