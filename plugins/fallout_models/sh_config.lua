local Plugin = {}
FalloutDefaultSkins = {}

--In order: "Name of Outfit","Model of clothing","Body model","Entity Model (when dropped)",damage resistance, true or false (is a helmet?)
--Fallout_RegisterOutfit(name,mdl,ent_mdl,dt,helmet)
local PHelmetVars = {
Orientation = true,
HideHead = true,
Pos = Vector(-2,0,0),
Ang = Angle(90,180,90)
}
local HazmatVars = {
Orientation = true,
HideHead = true,
Pos = Vector(-4,0,0),
Ang = Angle(90,180,90)
}
local EHelmetVars = {
Orientation = true,
HideHead = true,
Pos = Vector(2.5,0,0),
Ang = Angle(90,180,90)
}
local HatVars = {
Orientation = true,
FacHair = true,
KeepHair = true,
Pos = Vector(0,0,0),
Ang = Angle(90,180,90)
}
local KeepFac = {
FacHair = true,
KeepHair = true,
}
local KeepFull = {
FullHair = true,
}
local FullHair = {
FullHair = true,
FacHair = true
}
---
local LibParty = {
  ArmorSkin = "Liberty Party"
}
---
local NCRFWrap = {
  Bodygroups = {
    ["neck"] = 1,
  }
}
local NCRBand = {
  Bodygroups = {
    ["addon"] = 1,
  }
}
local NCRMant = {
  Bodygroups = {
    ["addon"] = 2,
  }
}
--------

------------
--Low tier
Fallout_RegisterOutfit("Naked",{Male = "models/pw_newvegas/player/default.mdl", Female = "models/fallout/player/female/default.mdl"},nil,0,false)
Fallout_RegisterOutfit("Leather Armor",{Male = "models/fallout/player/leatherarmor.mdl", Female = "models/fallout/player/female/leatherarmor.mdl"},"models/fallout/apparel/leatherarmor.mdl", 2, false)
Fallout_RegisterOutfit("Vault Security Uniform",{Male = "models/fallout/player/vaultsecurity.mdl", Female = "models/fallout/player/female/vaultsecurity.mdl"},"models/fallout/apparel/vaultsecurity.mdl", 3, false)
Fallout_RegisterOutfit("Vault Security Helmet","models/fallout/headgear/vaultsecurityhelmet.mdl","models/fallout/apparel/vaultsecurityhelmet.mdl", 2, true, KeepFac)
Fallout_RegisterOutfit("Dead Horse Tribal",{Male = "models/fallout/player/deadhorsetribal.mdl", Female = "models/fallout/player/female/deadhorsetribal.mdl"},"models/fallout/apparel/raiderarmor02.mdl", 2, false)
Fallout_RegisterOutfit("Hazmat Helmet","models/fallout/apparel/hazmat_cowl.mdl","models/fallout/apparel/hazmat_cowl.mdl", 1, true, HazmatVars)
Fallout_RegisterOutfit("Engineer Jumpsuit",{Male = "models/fallout/player/jumpsuitengineer.mdl", Female = "models/fallout/player/female/jumpsuitengineer.mdl"}, "models/fallout/apparel/labcoat.mdl", 0)
Fallout_RegisterOutfit("Lab Coat",{Male = "models/fallout/player/labcoat.mdl", Female = "models/fallout/player/female/labcoat.mdl"}, "models/fallout/apparel/labcoat.mdl", 0)
Fallout_RegisterOutfit("Miner Armor",{Male = "models/fallout/player/minerarmor.mdl", Female = "models/fallout/player/female/minerarmor.mdl"}, "models/fallout/apparel/minerarmorgo.mdl", 1)
Fallout_RegisterOutfit("Miner Helmet","models/fallout/headgear/minerhelmet.mdl", "models/fallout/apparel/minerhelmetgo.mdl", 1, true, KeepFac)
Fallout_RegisterOutfit("Party Hat","models/fallout/headgear/partyhat.mdl", "models/fallout/apparel/partyhat.mdl", 0, true, KeepFac)
Fallout_RegisterOutfit("Bandana","models/fallout/headgear/bandana.mdl", "models/fallout/apparel/bandana.mdl", 0, true, KeepFac)
Fallout_RegisterOutfit("Radiation Suit",{Male = "models/fallout/player/radsuit.mdl", Female = "models/fallout/player/female/radsuit.mdl"}, "models/fallout/apparel/radsuit.mdl", 1)
Fallout_RegisterOutfit("Vault Suit",{Male = "models/fallout/player/vaultsuit.mdl", Female = "models/fallout/player/female/vaultsuit.mdl"}, "models/fallout/apparel/vaultsuit.mdl", 1)
Fallout_RegisterOutfit("Merc Charmer Outfit",{Male = "models/fallout/player/wastelandclothing01.mdl", Female = "models/fallout/player/female/wastelandclothing01.mdl"}, "models/fallout/apparel/wastelandclothing01.mdl", 1.5)
Fallout_RegisterOutfit("Merc Troublemaker Outfit",{Male = "models/fallout/player/wastelandclothing02.mdl", Female = "models/fallout/player/female/wastelandclothing02.mdl"}, "models/fallout/apparel/wastelandclothing02.mdl", 1.5)
Fallout_RegisterOutfit("Merc Adventurer Outfit",{Male = "models/fallout/player/wastelandclothing03.mdl", Female = "models/fallout/player/female/wastelandclothing03.mdl"}, "models/fallout/apparel/wastelandclothing03.mdl", 1.5)
Fallout_RegisterOutfit("Merc Veteren Outfit",{Male = "models/fallout/player/wastelandclothing04.mdl", Female = "models/fallout/player/female/wastelandclothing04.mdl"}, "models/fallout/apparel/wastelandclothing04.mdl", 2)
Fallout_RegisterOutfit("Wasteland Doctor Outfit",{Male = "models/fallout/player/wastelanddoctor.mdl", Female = "models/fallout/player/female/wastelanddoctor.mdl"}, "models/fallout/apparel/labcoat.mdl", 0)
Fallout_RegisterOutfit("Merchant Outfit",{Male = "models/fallout/player/wastelandmerchant.mdl", Female = "models/fallout/player/female/wastelandmerchant.mdl"}, "models/fallout/apparel/wastelandmerchant01.mdl", 0)
Fallout_RegisterOutfit("Brahmin-skin Outfit",{Male = "models/fallout/player/wastelandsettler01.mdl", Female = "models/fallout/player/female/wastelandsettler01.mdl"}, "models/fallout/apparel/wastelandmerchant01.mdl", 0)
Fallout_RegisterOutfit("Wasteland Wanderer Outfit",{Male = "models/fallout/player/wastelandsettler02.mdl", Female = "models/fallout/player/female/wastelandsettler02.mdl"}, "models/fallout/apparel/wastelandmerchant01.mdl", 0)
Fallout_RegisterOutfit("Wasteland Settler Outfit",{Male = "models/fallout/player/wastelandsettler03.mdl", Female = "models/fallout/player/female/wastelandsettler03.mdl"}, "models/fallout/apparel/wastelandmerchant01.mdl", 0)

--Raider
Fallout_RegisterOutfit("Raider Painspike Armor",{Male = "models/fallout/player/raider01.mdl", Female = "models/fallout/player/female/raider01.mdl"}, "models/fallout/apparel/raiderarmor01.mdl", 2)
Fallout_RegisterOutfit("Raider Sadist Armor",{Male = "models/fallout/player/raider02.mdl", Female = "models/fallout/player/female/raider02.mdl"}, "models/fallout/apparel/raiderarmor02.mdl", 2)
Fallout_RegisterOutfit("Raider Badlands Armor",{Male = "models/fallout/player/raider03.mdl", Female = "models/fallout/player/female/raider03.mdl"}, "models/fallout/apparel/raiderarmor03.mdl", 2)
Fallout_RegisterOutfit("Raider Blastmaster Armor",{Male = "models/fallout/player/raider04.mdl", Female = "models/fallout/player/female/raider04.mdl"}, "models/fallout/apparel/raiderarmor04.mdl", 2)
Fallout_RegisterOutfit("Welding Mask","models/fallout/headgear/helmetraider02.mdl", "models/fallout/apparel/helmetraider02.mdl", 2, true, KeepFull)
Fallout_RegisterOutfit("Raider Badlands Mask","models/fallout/headgear/helmetraider03.mdl", "models/fallout/apparel/helmetraider03.mdl", 1, true, {HideHead = true})
Fallout_RegisterOutfit("Raider Sadist Mask","models/fallout/headgear/raiderarmor04_hat.mdl", "models/fallout/apparel/raiderarmor04_hat.mdl", 1, true)
Fallout_RegisterOutfit("Hockey Mask","models/fallout/headgear/hockeymask.mdl", "models/fallout/apparel/hockeymask.mdl", 1, true, KeepFull)

--Custom Factions
Fallout_RegisterOutfit("Chinese Commando Uniform",{Male = "models/fallout/player/chinesecommando.mdl", Female = "models/fallout/player/female/chinesecommando.mdl"},"models/fallout/apparel/minerarmorgo.mdl", 2, false)
Fallout_RegisterOutfit("Powder Ganger Uniform",{Male = "models/pw_newvegas/pilot/powdergang01.mdl", Female = "models/pw_newvegas/pilot/powdergangf01.mdl"},"models/pw_newvegas/pilot/powdergang_item.mdl", 2, false)
Fallout_RegisterOutfit("Liberty Party Uniform",{Male = "models/pw_newvegas/pilot/powdergang01.mdl", Female = "models/pw_newvegas/pilot/powdergangf01.mdl"},"models/pw_newvegas/pilot/powdergang_item.mdl", 2, false, LibParty)
Fallout_RegisterOutfit("Liberty Party Hat","models/fallout/headgear/libertyhat.mdl","models/fallout/headgear/libertyhat_go.mdl", 1, true, KeepFac)

--High Tier
Fallout_RegisterOutfit("Chinese Stealth Suit",{Male = "models/fallout/player/chinesestealth.mdl", Female = "models/fallout/player/female/chinesestealth.mdl"}, "models/fallout/apparel/chinesestealth.mdl", 3)
Fallout_RegisterOutfit("Chinese Stealth Helmet", "models/fallout/headgear/chinesestealthhelmf.mdl", "models/fallout/apparel/chinesestealthhelm.mdl", 1, true)

Fallout_RegisterOutfit("Combat Armor",{Male = "models/fallout/player/combatarmor.mdl", Female = "models/fallout/player/female/combatarmor.mdl"}, "models/fallout/apparel/combatarmor.mdl", 5)
Fallout_RegisterOutfit("Combat Helmet", "models/fallout/headgear/combatarmorhelmet.mdl", "models/fallout/apparel/combatarmorhelmet.mdl", 3, true, KeepFac)

Fallout_RegisterOutfit("Formal Suit",{Male = "models/fallout/player/formalsuit.mdl", Female = "models/fallout/pilot/player/outfitf.mdl"}, "models/fallout/apparel/formalsuit.mdl", 0)
Fallout_RegisterOutfit("Mysterious Suit",{Male = "models/fallout/player/mysteriousstranger.mdl", Female = "models/fallout/pilot/player/outfitf.mdl"}, "models/fallout/apparel/formalsuit.mdl", 2)

Fallout_RegisterOutfit("Mark I Combat Armor",{Male = "models/fallout/player/mark1combat.mdl", Female = "models/fallout/player/female/mark1combat.mdl"}, "models/fallout/apparel/mark1combat.mdl", 6)
Fallout_RegisterOutfit("Mark I Combat Helmet","models/fallout/headgear/mark1combathelm.mdl", "models/fallout/apparel/mark1combathelmet.mdl", 2.5, true, KeepFac)

Fallout_RegisterOutfit("Mark II Combat Armor",{Male = "models/fallout/player/mark2combat.mdl", Female = "models/fallout/player/female/mark2combat.mdl"}, "models/fallout/apparel/mark2combat.mdl", 7)
Fallout_RegisterOutfit("Mark II Combat Helmet","models/fallout/headgear/mark2combathelm.mdl", "models/fallout/apparel/mark2combathelmet.mdl", 3, true, KeepFac)

Fallout_RegisterOutfit("Mark II Leather Armor",{Male = "models/fallout/player/mark2leather.mdl", Female = "models/fallout/player/female/mark2leather.mdl"}, "models/fallout/apparel/mark2leather.mdl", 4)

Fallout_RegisterOutfit("Metal Armor",{Male = "models/fallout/player/metalarmor.mdl", Female = "models/fallout/player/female/metalarmor.mdl"}, "models/fallout/apparel/metalarmor.mdl", 5)
Fallout_RegisterOutfit("Metal Helmet","models/fallout/headgear/helmetmetalarmor.mdl", "models/fallout/apparel/helmetmetalarmor.mdl", 3, true)

--Legion
Fallout_RegisterOutfit("Slave Rags",{Male = "models/fallout/player/slaverags.mdl", Female = "models/fallout/player/female/slaverags.mdl"},"models/fallout/apparel/slaverags_go.mdl", 0, false)
Fallout_RegisterOutfit("Slave Collar","models/pw_newvegas/armor/headgear/slavecollar.mdl","models/fallout/apparel/legionfeatherhead01_go.mdl",0,true, FullHair)

Fallout_RegisterOutfit("Legion Veteren",{Male = "models/fallout/player/legionveteran.mdl", Female = "models/fallout/player/female/legionveteran.mdl"},"models/fallout/apparel/legiongo.mdl", 3, false)
Fallout_RegisterOutfit("Legion Veteren Bandana","models/fallout/headgear/legionfeatherhead01.mdl","models/fallout/apparel/legionfeatherhead01_go.mdl",1,true)

Fallout_RegisterOutfit("Legion Prime Bandana","models/fallout/headgear/legionfeatherhead02.mdl","models/fallout/apparel/legionfeatherhead02_go.mdl",1,true)
Fallout_RegisterOutfit("Legion Explorer Bandana","models/fallout/headgear/legionfeatherhead03.mdl","models/fallout/apparel/legionfeatherhead03_go.mdl",1,true)
Fallout_RegisterOutfit("Legion Recruit Helmet","models/fallout/headgear/legionwhitehelmetbase.mdl","models/fallout/apparel/legionwhitehelmetbase_go.mdl",1,true)
Fallout_RegisterOutfit("Legion Prime Helmet","models/fallout/headgear/legionhelmetbase.mdl","models/fallout/apparel/legionhelmetbase_go.mdl",2,true)
Fallout_RegisterOutfit("Legion Hood","models/fallout/headgear/legionhood.mdl","models/fallout/apparel/legionhood_go.mdl",1,true, KeepFac)
Fallout_RegisterOutfit("Legion Vexillarius Hood","models/fallout/headgear/legionwollfhead.mdl","models/fallout/apparel/legionwollfhead_go.mdl",1,true, KeepFac)

Fallout_RegisterOutfit("Caesars Outfit",{Male = "models/fallout/player/caesar.mdl", Female = "models/fallout/player/female/caesar.mdl"},"models/fallout/apparel/caesargo.mdl", 4, false)

Fallout_RegisterOutfit("Legion Recruit",{Male = "models/fallout/player/legionrecruit.mdl", Female = "models/fallout/player/female/legionrecruit.mdl"},"models/fallout/apparel/legiongo.mdl", 2, false)
Fallout_RegisterOutfit("Legion Prime",{Male = "models/fallout/player/legionprime.mdl", Female = "models/fallout/player/female/legionprime.mdl"},"models/fallout/apparel/legiongo.mdl", 2, false)
Fallout_RegisterOutfit("Legion Explorer",{Male = "models/fallout/player/legionexplorer.mdl", Female = "models/fallout/player/female/legionexplorer.mdl"},"models/fallout/apparel/legiongo.mdl", 2, false)
Fallout_RegisterOutfit("Legion Vexillarius",{Male = "models/fallout/player/legionvexillarius.mdl", Female = "models/fallout/player/female/legionvexillarius.mdl"},"models/fallout/apparel/legiongo.mdl", 3, false)
Fallout_RegisterOutfit("Legion Pretorian",{Male = "models/fallout/player/legionpretorian.mdl", Female = "models/fallout/player/female/legionpretorian.mdl"},"models/fallout/apparel/legiongo.mdl", 3, false)

Fallout_RegisterOutfit("Legates Armor",{Male = "models/fallout/player/legatearmor.mdl", Female = "models/fallout/player/legatearmor.mdl"},"models/fallout/apparel/legatearmor_go.mdl", 20, false)
Fallout_RegisterOutfit("Legates Helmet","models/fallout/headgear/legatehelm.mdl","models/fallout/apparel/legatehelmgo.mdl",10,true)

Fallout_RegisterOutfit("Centurion Armor",{Male = "models/fallout/player/centurion.mdl", Female = "models/fallout/player/female/centurion.mdl"},"models/fallout/apparel/centuriongo.mdl", 7, false)
Fallout_RegisterOutfit("Centurion Helmet","models/fallout/headgear/centurionhelmet.mdl","models/fallout/apparel/centurionhelmet_go.mdl", 5,true, KeepFac)
--BoS
Fallout_RegisterOutfit("T-45d Power Armor",{Male = "models/fallout/player/t-45dpowerarmor.mdl", Female = "models/fallout/player/female/t-45dpowerarmor.mdl"},"models/fallout/apparel/power_armor.mdl",7)
Fallout_RegisterOutfit("T-45d Power Helmet", "models/fallout/apparel/power_armor_helmet.mdl", "models/fallout/apparel/power_armor_helmet.mdl", 3, true, PHelmetVars)

Fallout_RegisterOutfit("T-51b Power Helmet","models/fallout/headgear/t51bpowerhelmet.mdl","models/fallout/apparel/t51bpowerhelmet.mdl", 4, true)
Fallout_RegisterOutfit("T-51b Power Armor",{Male = "models/fallout/player/t51bpowerarmor.mdl", Female = "models/fallout/player/female/t51bpowerarmor.mdl"},"models/fallout/apparel/t51bpowerarmor.mdl",8)

Fallout_RegisterOutfit("Brotherhood Scribe Robes",{Male = "models/fallout/player/bosscribe.mdl", Female = "models/fallout/player/female/bosscribe.mdl"},"models/fallout/apparel/bosscribe.mdl",1)
Fallout_RegisterOutfit("Recon Armor",{Male = "models/fallout/player/bosunderarmor.mdl", Female = "models/fallout/player/female/bosunderarmor.mdl"},"models/fallout/apparel/bosunderarmor.mdl",3)

Fallout_RegisterOutfit("Midwest Power Armor",{Male = "models/fallout/player/amwpa.mdl", Female = "models/fallout/player/female/amwpa.mdl"},"models/fallout/apparel/amwpa.mdl",12)
Fallout_RegisterOutfit("Midwest Power Helmet","models/fallout/headgear/amwpahelmet.mdl","models/fallout/apparel/amwpahelmet.mdl",8,true)
--NCR
Fallout_RegisterOutfit("NCR Trooper Outfit",{Male = "models/fallout/player/ncrtrooper.mdl", Female = "models/fallout/player/female/ncrtrooper.mdl"},"models/fallout/apparel/trooper.mdl",2)
Fallout_RegisterOutfit("NCR Face Wrap Outfit",{Male = "models/fallout/player/ncrtrooper.mdl", Female = "models/fallout/player/female/ncrtrooper.mdl"},"models/fallout/apparel/trooper.mdl",2, false, NCRFWrap)
Fallout_RegisterOutfit("NCR Bandoleer Outfit",{Male = "models/fallout/player/ncrtrooper.mdl", Female = "models/fallout/player/female/ncrtrooper.mdl"},"models/fallout/apparel/trooper.mdl",2, false, NCRBand)
Fallout_RegisterOutfit("NCR Mantle Outfit",{Male = "models/fallout/player/ncrtrooper.mdl", Female = "models/fallout/player/female/ncrtrooper.mdl"},"models/fallout/apparel/trooper.mdl",2, false, NCRMant)

Fallout_RegisterOutfit("Trooper Helmet","models/fallout/apparel/trooperhelm.mdl","models/fallout/apparel/trooperhelm.mdl", 1, true, HatVars)

Fallout_RegisterOutfit("Green Beret","models/fallout/headgear/green_beret.mdl","models/fallout/apparel/green_beret.mdl", 1, true, KeepFac)
Fallout_RegisterOutfit("Red Beret","models/fallout/headgear/red_beret.mdl","models/fallout/apparel/red_beret.mdl", 1, true, KeepFac)

Fallout_RegisterOutfit("Cowboy Hat","models/fallout/headgear/cowboyhat2.mdl","models/fallout/apparel/cowboyhat2.mdl", 1, true, KeepFac)
Fallout_RegisterOutfit("Pre-War Business Hat","models/fallout/headgear/cowboyhat3.mdl","models/fallout/apparel/cowboyhat3.mdl", 1, true, KeepFac)
Fallout_RegisterOutfit("Dark Business Hat","models/fallout/headgear/cowboyhat5.mdl","models/fallout/apparel/cowboyhat5.mdl", 1, true, KeepFac)
Fallout_RegisterOutfit("Old Cowboy Hat","models/fallout/headgear/cowboyhat4.mdl","models/fallout/apparel/cowboyhat4.mdl", 1, true, KeepFac)

Fallout_RegisterOutfit("Combat Ranger Armor",{Male = "models/fallout/player/combatranger.mdl", Female = "models/fallout/player/female/combatranger.mdl"},"models/fallout/apparel/combatranger.mdl",6)
Fallout_RegisterOutfit("Combat Ranger Helmet","models/fallout/headgear/combatrangerhelmet.mdl","models/fallout/apparel/combatrangerhelmet.mdl",3,true)

Fallout_RegisterOutfit("Patrol Ranger Armor",{Male = "models/fallout/player/patrolranger.mdl", Female = "models/fallout/player/female/patrolranger.mdl"},"models/fallout/apparel/patrolranger.mdl",3)
--Remenants
Fallout_RegisterOutfit("Enclave Power Armor",{Male = "models/fallout/player/enclavepowerarmor.mdl", Female = "models/fallout/player/female/enclavepowerarmor.mdl"},"models/fallout/apparel/enclave_power_armor.mdl",8)
Fallout_RegisterOutfit("Enclave Power Helmet", "models/fallout/apparel/enclave_power_armor_helmet.mdl", "models/fallout/apparel/enclave_power_armor_helmet.mdl", 3, true, EHelmetVars)

Fallout_RegisterOutfit("Enclave Hellfire Armor",{Male = "models/fallout/player/hellfire.mdl", Female = "models/fallout/player/female/hellfire.mdl"},"models/fallout/apparel/hellfire.mdl",10)
Fallout_RegisterOutfit("Enclave Hellfire Helmet", "models/fallout/headgear/hellfirehelm.mdl", "models/fallout/apparel/hellfirehelm.mdl", 4, true, {HideHead = true})

Fallout_RegisterOutfit("Remenants Power Armor",{Male = "models/fallout/player/adpowerarmor.mdl", Female = "models/fallout/player/female/adpowerarmor.mdl"},"models/fallout/apparel/adpowerarmor.mdl",15)
Fallout_RegisterOutfit("Remenants Power Helmet", "models/fallout/headgear/tesleakhelm.mdl", "models/fallout/apparel/adpowerarmorhelmet.mdl", 6, true, {HideHead = true})

------------

return Plugin