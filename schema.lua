-------------
--Includes
if SERVER then
  pig.utility.AddFile("sv_factionarmor.lua")
  pig.utility.AddFile("sv_hooks.lua")
  pig.utility.AddFile("sv_stealth.lua")
  pig.utility.AddFile("sv_spawns.lua")  
end
pig.utility.AddFile("cl_greeting.lua")
pig.utility.AddFile("cl_footstep.lua")
pig.utility.AddFile("sh_flags.lua")
pig.utility.AddFile("sh_faction.lua")
pig.utility.AddFile("cl_level.lua")
pig.utility.AddFile("sh_wg_config.lua")
pig.utility.AddFile("cl_ambiance.lua")
pig.utility.AddFile("cl_thirdperson.lua")
pig.utility.AddFile("cl_buts.lua")
pig.utility.AddFile("sh_animset.lua")
pig.utility.AddFile("sh_chatcommands.lua")
pig.utility.AddFile("cl_hooks.lua")
pig.utility.AddFile("cl_options.lua")
pig.utility.AddFile("cl_tutorial.lua")
--
Schema.Name = "New Vegas" 
Schema.Author = "extra.game"
Schema.Desc = ".."
Schema.folderName = GM.FolderName

--------------------
--TRADING SYSTEM
--(DONT TOUCH THESE)
Schema.TradeTraceCool = 30--(Seconds)
Schema.TradeSentCool = 60--(Seconds)
---------
--LIMB SYSTEM
--Limb names: Head, Upper Body, Abdominal, Right Arm, Left Arm, Right Leg, Left Leg
Schema.LimbBlacklisted = {"Abdominal"}--Names of limbs you don't plan to use. This removes them from the system
Schema.LegCrip1_WalkSpeed = 65--Walk Speed for 1 crippled leg
Schema.LegCrip1_RunSpeed = 140--Run Speed for 1 crippled leg
Schema.LegCrip1_JumpPower = 0.3--Jump power for 1 crippled leg

Schema.LegCrip2_WalkSpeed = 55--Walk Speed for 2 crippled legs
Schema.LegCrip2_RunSpeed = 100--Run Speed for 2 crippled legs
Schema.LegCrip2_JumpPower = 0.7--Jump power for 2 crippled legs
--------------------

Schema.AnimationList = {
["Sit Ups"] = {Seq = "pose_situps_loop", Loop = true},
["Push Ups"] = {Seq = "pose_pushups_loop", Loop = true},
["Jumping Jacks"] = {Seq = "pose_jumpingjacks", Loop = true},
["Disco"] = {Seq = "Disco01", Loop = true},
["Sleep"] = {Seq = "floorbedstirinsleepb", Loop = true},
["Kiss Male"] = {Seq = "KissM", Loop = false},
["Sing"] = {Seq = "pose_singing", Loop = true},
["Look Down"] = {Seq = "pipboy1", Loop = true},
["Rock n Roll"] = {Seq = "Rock", Loop = true},
}

Schema.MaxDropEnt = 10--Max amount of (singular - not stacked) entities a player is allowed to drop from inventory (to prevent dropping 1000 box's for example)
Schema.DeleteClutterTime = 5--Time in minutes that dropped entities from players inventories are deleted (refreshes on same item drop)
Schema.CurrencyDropIcon = "pw_fallout/v_bcap.png"
Schema.MoneyModel = "models/fallout/items/nukacolacap.mdl"
Schema.MoneyScale = 2
Schema.SlotSpacing = 0--Space on slots

Schema.GameColor = Schema.GameColor or Color(246,178,68)--Schema's colour. Includes colour on HUD, vgui, derma etc
Schema.InvPickupColor = nil
Schema.RedColor = Color(248,66,41)
Schema.InvFullColor = Schema.RedColor
Schema.FailStealColor = Schema.RedColor

Schema.GuyModels = {"models/lazarusroleplay/heads/male_african.mdl","models/lazarusroleplay/heads/male_asian.mdl","models/lazarusroleplay/heads/male_caucasian.mdl","models/lazarusroleplay/heads/male_hispanic.mdl"}--Models for the default team that will also be in the character customizer (MALE)
Schema.GirlModels = {"models/lazarusroleplay/heads/female_african.mdl","models/lazarusroleplay/heads/female_asian.mdl","models/lazarusroleplay/heads/female_caucasian.mdl","models/lazarusroleplay/heads/female_hispanic.mdl"}--Same as above but for female characters
Schema.RespawnTime = 15--Self explanatory

Schema.MaxBlocks = 10 --Max Blocks allowed by each person to be placed
Schema.PlaceRange = 200--Range in which blocks can be placed
Schema.TalkRadius = 500

Schema.InvCool = 0.5--How long must a person wait before picking up another item (Inventory pick up cool-down)
Schema.InvMaxWG = 200--Max WG(weight) on inventory. < 200 recommended >
Schema.InvBlackList = { --Enter class of entities that will not storable in inventory
"fallout_l_base",
"spinjoy",
"container",
"crucifix",
"goopile",
"minerock",
"pickup_point",
"fallout_radio",
"terminal",
"fallout_weaponbench",
"prop_physics",
"prop_physics_multiplayer",
"fo_mine",
"fo_grenade",
}
Schema.InvNonStackables = {
"fallout_c_base"
}
Schema.InvSendSavedVars = {"Outfit","Skin"}
Schema.NonStealable = {}
Schema.InvWhiteList = {}--The class's of the entites that can be stored no matter what. Useful for allowing certain NPC's to be storable.

Schema.ChatFadeTime = 12
Schema.ChatSound = "fo4_chat_2.mp3"
Schema.MaxNameLength = 25--Max length of characters allowed in RP names
Schema.MaxDescLength = 300--Max length of characters allowed in descriptions
Schema.MaxLevel = 30--The maximum level one can reach (The level cap)
Schema.Currency = "Caps"--Name of currency
Schema.MaxChar = 4--Maximum characters allowed for non donators
Schema.MaxCharVIP = 8--Maximum characters allowed for donators
Schema.StartingMoney = 100--Starting money
Schema.MoneyTime = 135--Time until money dissapears
Schema.StartingPoints = 45--Starting skill points
Schema.LevelPoints = 16
Schema.CarryOverXP = false--Does XP get carried over?
Schema.MinimumChar = 5--Minimum required characters in a RP Name
Schema.NoStrip = true--Do weapons get stripped when switching factions?
Schema.VIPGroups = {
"founder",
"donator",
"superadmin"
}

--Advanced Settings-------------
Schema.SentInfo = {"Skin Type","Hair Type","Facial Hair", "Faction"} --The character vars also sent to the client Load Screen
Schema.CustomCharData = {"Facial Hair","Hair","HairCol","Skin","Ghoul"}--Insert any character data names (E.G 'Facial Hair','Hair',etc) that is added to Character Creation Menu options
Schema.SharedCharData = {"Fac","FacRank"}--Any character data names that are also accessible client-side