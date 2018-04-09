----------------
-----SHARED.LUA
function f_print(str)
MsgC(Color(204,150,90),"["..("New Vegas").."]: "..str)
end
-------
f_print("Initialized shared.lua!")

pig.utility.IncludeDirectory("schema/fallout_nv_vgui")
pig.utility.IncludeDirectory("schema/fallout_nv_hud")
pig.utility.IncludeDirectory("schema/fallout_nv_pipboy")
pig.utility.IncludeDirectory("schema/fallout_creatures")
pig.utility.IncludeDirectory("schema/fallout_nv_loot")
pig.utility.IncludeDirectory("schema/unique_chars")
pig.utility.IncludeDirectory("schema/chat_talk")
pig.utility.IncludeDirectory("schema/fallout_weapon")
pig.utility.IncludeDirectory("schema/fallout_special")
pig.utility.IncludeDirectory("schema/fallout_nv_terminal")
pig.utility.IncludeDirectory("schema/fallout_decapitation")
pig.utility.IncludeDirectory("schema/fallout_nv_perks")
pig.utility.IncludeDirectory("schema/fallout_odds")
pig.utility.IncludeDirectory("schema/fallout_nv_trading")
pig.utility.IncludeDirectory("schema/fallout_nv_lock")
pig.utility.IncludeDirectory("schema/gambling")
pig.utility.IncludeDirectory("schema/fallout_shops")
pig.utility.IncludeDirectory("schema/fallout_editor")
pig.utility.IncludeDirectory("schema/fallout_nv_crafting")
pig.utility.IncludeDirectory("schema/admin")
pig.utility.IncludeDirectory("schema/fallout_radio")
--pig.utility.IncludeDirectory("schema/fallout_nv_vats")

local function LoadDerma()
print("["..Schema.Name.."]: Loading Derma..")
local files = file.Find(Schema.folderName.."/gamemode/derma/*", "LUA")
  for _, f in SortedPairs(files, true) do
    if CLIENT then
      include("derma/"..f)
	  print("["..Schema.Name.." CLIENT]: Loaded "..f)
	elseif SERVER then
	  AddCSLuaFile("derma/"..f)
	end
  end
end
LoadDerma()