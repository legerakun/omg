FISkins = FISkins or {}
print("[Editor]: Loaded!")

function FIAddSkin(armor, name, dir, col, price, nondon)
  FISkins[name] = {
    Armor = armor,
	Dir = dir,
	Col = col,
	Price = price,
	NonDonator = nondon
  }
end

function FICanApplySkin(outfit, name)
local armor = FISkins[name].Armor
  if armor == outfit then
    return true
  end
end

function FIModelToArmor(model)
local tbl = {}
tbl["models/fallout/player/t51bpowerarmor.mdl"] = "T-51b Power Armor"
tbl["models/fallout/player/female/t51bpowerarmor.mdl"] = "T-51b Power Armor"
tbl["models/fallout/player/t-45dpowerarmor.mdl"] = "T-45d Power Armor"
tbl["models/fallout/player/female/t-45dpowerarmor.mdl"] = "T-45d Power Armor"
tbl["models/fallout/player/combatranger.mdl"] = "Combat Ranger Armor"
tbl["models/fallout/player/female/combatranger.mdl"] = "Combat Ranger Armor"
tbl["models/fallout/player/patrolranger.mdl"] = "Patrol Ranger Armor"
tbl["models/fallout/player/female/patrolranger.mdl"] = "Patrol Ranger Armor"
tbl["models/fallout/player/ncrtrooper.mdl"] = "NCR Trooper Outfit"
tbl["models/fallout/player/female/ncrtrooper.mdl"] = "NCR Trooper Outfit"
tbl["models/pw_newvegas/pilot/powdergang01.mdl"] = "Powder Ganger Uniform"
tbl["models/pw_newvegas/pilot/powdergangf01.mdl"] = "Powder Ganger Uniform"
--
tbl["models/fallout/headgear/combatrangerhelmet.mdl"] = "Combat Ranger Helmet"
tbl["models/fallout/apparel/trooperhelm.mdl"] = "Trooper Helmet"
--
return tbl[model]
end

function FIGetMatIndex(outfit,gender)
if !outfit or !gender then return end
local tbl = {}
tbl["T-51b Power Armor"] = {Male = 0, Female = 0}
tbl["T-45d Power Armor"] = {Male = 1, Female = 0}
tbl["Combat Ranger Armor"] = {Male = 1, Female = 0}
tbl["Patrol Ranger Armor"] = {Male = 0, Female = 1}
tbl["NCR Trooper Outfit"] = {Male = 1, Female = 1}
tbl["Powder Ganger Uniform"] = {Male = 0, Female = 2}
tbl["Liberty Party Uniform"] = {Male = 0, Female = 2}
--
tbl["Combat Ranger Helmet"] = {Male = 0, Female = 0}
tbl["Trooper Helmet"] = {Male = 0, Female = 0}
--
if !tbl[outfit] then return end
return tbl[outfit][gender]
end

function FIValidArmor(outfit)
local tbl = {}
tbl["T-45d Power Armor"] = true;
tbl["T-51b Power Armor"] = true;
tbl["Combat Ranger Armor"] = true;
tbl["Combat Ranger Helmet"] = true;
tbl["Patrol Ranger Armor"] = true;
tbl["NCR Trooper Outfit"] = true;
tbl["Trooper Helmet"] = true;
tbl["Powder Ganger Uniform"] = true;
tbl["Liberty Party Uniform"] = true;
--
  if tbl[outfit] then
    return true
  end
end

function FIGetCol(name)
  if !FISkins[name] then return end
  return FISkins[name].Col
end

function FIGetNewModel(index)
local tbl = {}
tbl["Combat Ranger Helmet"] = "models/fallout/apparel/combatrangerhelmet.mdl"
return tbl[index]
end

function FIGetSkin(name)
  if !FISkins[name] then return end
  return FISkins[name].Dir
end

function FIDonatorSkin(name)
  if !FISkins[name].NonDonator then
    return true
  end
end

if !pig.utility.IsFunction(FISortConfig) then
  timer.Simple(1,function()
    FISortConfig()
  end)
else
  FISortConfig()
end