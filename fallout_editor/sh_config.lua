local baseDir45 = "pw_fallout/skins/t45/"
local baseDir51 = "pw_fallout/skins/t51/"
local baseDirCom = "pw_fallout/skins/ranger/"
local baseDirPat = "pw_fallout/skins/patrol/"
local baseDirTroop = "pw_fallout/skins/trooper/"
local baseDirPow = "pw_fallout/skins/powderganger/"

function FISortConfig()
--FIAddSkin(armor, name, dir, col)
/*
Color(97,120,236) Blue
Color(132,87,255) Purple 
Color(192,40,40) Red
*/
-----------
--Combat Ranger Armor
FIAddSkin("Combat Ranger Armor", "Elite Riot", baseDirCom.."eliteriot", Color(192,40,40), 1000)
FIAddSkin("Combat Ranger Helmet", "Elite Riot Helmet", baseDirCom.."eliteriothelm", Color(192,40,40), 500)

FIAddSkin("Combat Ranger Armor", "Desert Ranger", baseDirCom.."desertranger", Color(192,40,40), 1000)
FIAddSkin("Combat Ranger Helmet", "Desert Ranger Helmet", baseDirCom.."desertranger_helm", Color(192,40,40), 500)
------------
--Powder Ganger Uniform
FIAddSkin("Powder Ganger Uniform", "Liberty Party", baseDirPow.."libertyparty01", Color(192,40,40), 100)
FIAddSkin("Liberty Party Uniform", "Liberty Party", baseDirPow.."libertyparty01", Color(192,40,40), 100)
------------
--Trooper
FIAddSkin("NCR Trooper Outfit", "Desert Tiger", baseDirTroop.."tiger", Color(97,120,236), 600)
FIAddSkin("NCR Trooper Outfit", "NCR Medic", baseDirTroop.."medic", Color(97,120,236), 600)

FIAddSkin("Trooper Helmet", "Ace Helmet", baseDirTroop.."aceh", Color(97,120,236), 200)
FIAddSkin("Trooper Helmet", "Anti Commie", baseDirTroop.."antic", Color(97,120,236), 200)
FIAddSkin("Trooper Helmet", "Born To Tax", baseDirTroop.."bornh", Color(97,120,236), 250)
------------
--Patrol Ranger Armor
FIAddSkin("Patrol Ranger Armor", "Arctic", baseDirPat.."arctic", Color(97,120,236), 450)
FIAddSkin("Patrol Ranger Armor", "Desert Patrol", baseDirPat.."desert", Color(97,120,236), 750)
FIAddSkin("Patrol Ranger Armor", "Great Khan", baseDirPat.."khan", Color(132,87,255), 750)
FIAddSkin("Patrol Ranger Armor", "The Dingo", baseDirPat.."dingo", Color(132,87,255), 750)
FIAddSkin("Patrol Ranger Armor", "Elite Patrol", baseDirPat.."elite", Color(132,87,255), 750)
FIAddSkin("Patrol Ranger Armor", "Covert Patrol", baseDirPat.."covert", Color(192,40,40), 1750)
------------
--T51B Skins
--Blue
FIAddSkin("T-51b Power Armor", "The Desert Ranger", baseDir51.."desert", Color(97,120,236), 750)
FIAddSkin("T-51b Power Armor", "Patriot", baseDir51.."patriot", Color(97,120,236), 750)
FIAddSkin("T-51b Power Armor", "Uncle Sam", baseDir51.."winpatriot", Color(97,120,236), 850)
--Purple
FIAddSkin("T-51b Power Armor", "Brotherhood of Steel", baseDir51.."bos", Color(132,87,255), 1000)
FIAddSkin("T-51b Power Armor", "Urban Warrior", baseDir51.."urban", Color(132,87,255), 1100)
FIAddSkin("T-51b Power Armor", "Chinese", baseDir51.."chinese", Color(132,87,255), 1150)
FIAddSkin("T-51b Power Armor", "Army Service", baseDir51.."army", Color(132,87,255), 1200)
FIAddSkin("T-51b Power Armor", "Winterised", baseDir51.."winter", Color(132,87,255), 1200)
FIAddSkin("T-51b Power Armor", "Red Devil", baseDir51.."reddevil", Color(132,87,255), 1300)
--Red
FIAddSkin("T-51b Power Armor", "Dark Paladin", baseDir51.."darkpal", Color(192,40,40), 3200)
FIAddSkin("T-51b Power Armor", "Atomic", baseDir51.."atomic", Color(192,40,40), 3200)
FIAddSkin("T-51b Power Armor", "Old World Blues", baseDir51.."oldworld", Color(192,40,40), 3400)
FIAddSkin("T-51b Power Armor", "Vault-Tec", baseDir51.."vaulttec", Color(192,40,40), 4000)
------------

------------
--T-45D Skins
--Blue
FIAddSkin("T-45d Power Armor", "Desert Camo", baseDir45.."desert", Color(97,120,236), 400)
--Purple
FIAddSkin("T-45d Power Armor", "Kitty", baseDir45.."kitty", Color(132,87,255), 800)
FIAddSkin("T-45d Power Armor", "Tiger Stripe", baseDir45.."tigerstripe", Color(132,87,255), 800)
FIAddSkin("T-45d Power Armor", "Woodlands", baseDir45.."woodland", Color(132,87,255), 800)
--Red
FIAddSkin("T-45d Power Armor", "Outcast", baseDir45.."outcast", Color(192,40,40), 1200)
FIAddSkin("T-45d Power Armor", "Covert", baseDir45.."covert", Color(192,40,40), 3500)
FIAddSkin("T-45d Power Armor", "Golden Luxury", baseDir45.."gold", Color(192,40,40), 10000)
FIAddSkin("T-45d Power Armor", "Sleepin Is Cheatin", baseDir45.."sic", Color(192,40,40), 50000)
end
