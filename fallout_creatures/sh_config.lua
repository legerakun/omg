-----------------
--Deathclaw
local deathclaw_body = {}
deathclaw_body["enclaveaddon"] = 1
local deathclaw_footstep = {}
deathclaw_footstep.left = {"foot/deathclaw_0_1.mp3","foot/deathclaw_0_2.mp3"}
deathclaw_footstep.right = {"foot/deathclaw_1_1.mp3","foot/deathclaw_1_2.mp3"}
local deathclaw_speed = {}
deathclaw_speed.walk = 90
deathclaw_speed.run = 350

AddCreature("Deathclaw","models/fallout/deathclaw.mdl",{},deathclaw_body,deathclaw_footstep,deathclaw_speed,"Deathclaw",10)

local deathclawa_speed = {}
deathclawa_speed.walk = 130
deathclawa_speed.run = 420
AddCreature("Deathclaw Alpha-male","models/fallout/deathclaw_alphamale.mdl",{},deathclaw_body,deathclaw_footstep,deathclawa_speed,"Deathclaw",20)
--Super Mutant
local sm_body = {}
local sm_footstep = {}
sm_footstep.left = {"foot/supermutant_foot_1.mp3","foot/supermutant_foot_2.mp3","foot/supermutant_foot_3.mp3"}
sm_footstep.right = {"foot/supermutant_foot_4.mp3","foot/supermutant_foot_5.mp3","foot/supermutant_foot_6.mp3"}
local sm_speed = {}
sm_speed.walk = 70
sm_speed.run = 290
local master_body = {}
master_body["gear"] = 1
local cap_body = {}
cap_body["gear"] = 3

AddCreature("Nightkin","models/pw_newvegas/creatures/supermutant_nightkin.mdl",{},sm_body, sm_footstep, sm_speed,"Super Mutant",7)
AddCreature("Super Mutant","models/pw_newvegas/creatures/supermutant_medium.mdl",{}, sm_body, sm_footstep, sm_speed,"Super Mutant",8)
AddCreature("Super Mutant Master","models/pw_newvegas/creatures/supermutant_heavy.mdl",{}, master_body, sm_footstep, sm_speed,"Super Mutant",10)
AddCreature("Super Mutant Captain","models/pw_newvegas/creatures/supermutant_heavy.mdl",{}, cap_body, sm_footstep, sm_speed,"Super Mutant",14)
--Human
local enc_body = {}
enc_body["headgear"] = 0
enc_body["heads"] = 0
enc_body["weapons"] = 0
local enc_footstep = {}
enc_footstep.right = {"foot/foot_0_1.mp3","foot/foot_0_2.mp3","foot/foot_0_3.mp3"}
enc_footstep.left = {"foot/foot_1_1.mp3","foot/foot_1_2.mp3","foot/foot_1_3.mp3"}
local human_speed = {}
human_speed.walk = 60
human_speed.run = 270
local human_view = {
Back = 40,
Up = -20,
Right = -15
}
local metro_view = {
Back = 40,
Up = -30,
Right = -25
}
--
AddCreature("Remnants","models/fallout/player/default.mdl",{}, enc_body, enc_footstep,human_speed,"Human",10, human_view)
AddCreature("MetroPolice","models/dpfilms/metropolice/hdpolice.mdl",{}, enc_body, enc_footstep,human_speed,"MetroPolice",10, metro_view)
--Robot
local sent_body = {}
local sent_footstep = {}
sent_footstep.right = {"foot/sentry_foot.mp3"}
sent_footstep.left = {"foot/sentry_foot.mp3"}
local sent_speed = {}
sent_speed.walk = 100
sent_speed.run = 250
local gutsy_footstep = {}
gutsy_footstep.right = {"foot/gutsy_foot.mp3"}
gutsy_footstep.left = {"foot/gutsy_foot.mp3"}

AddCreature("Yes Man","models/TheSpire/Fallout/Robots/securitron.mdl",{}, sent_body, sent_footstep, sent_speed, "Robot", 9)
AddCreature("Sentry Bot","models/fallout/sentrybot.mdl",{}, sent_body, sent_footstep, sent_speed, "Robot", 15)
AddCreature("Mr Gutsy","models/fallout/mistergutsy.mdl",{}, sent_body, gutsy_footstep, sent_speed, "Robot", 5)
AddCreature("Eye Bot","models/fallout/eyebot.mdl",{}, sent_body, gutsy_footstep, sent_speed, "Robot", 3)
AddCreature("Drone","models/fallout/drone_support.mdl",{}, sent_body, gutsy_footstep, sent_speed, "Robot", 7)
--Mutants
local brahmin_footstep = {}
brahmin_footstep.left = {"foot/brah_left_1.mp3","foot/brah_left_2.mp3"}
brahmin_footstep.right = {"foot/brah_right_1.mp3","foot/brah_right_2.mp3"}
local brahmin_speed = {}
brahmin_speed.walk = 60
brahmin_speed.run = 240
local brahmin_view = {
  Up = -25,
  Right = -15,
}
local dog_view = {
  Back = 10,
  Up = -45,
  Right = -18
}
local fly_footstep = {}
fly_footstep.left = {"foot/cazadore_foot_1.mp3","foot/cazadore_foot_2.mp3"}
fly_footstep.right = {"foot/cazadore_foot_3.mp3","foot/cazadore_foot_4.mp3"}
local fly_speed = {}
fly_speed.walk = 100
fly_speed.run = 300

AddCreature("Cazadore","models/fallout/cazadore.mdl",{}, sent_body, fly_footstep, fly_speed, "Creature", 6)
AddCreature("Brahmin","models/fallout/brahmin.mdl",{}, sent_body, brahmin_footstep, brahmin_speed, "Creature", 0, brahmin_view)
AddCreature("Pack Brahmin","models/fallout/brahminpack.mdl",{}, sent_body, brahmin_footstep, brahmin_speed, "Creature", 0, brahmin_view)
AddCreature("Big Horner","models/fallout/bighorner.mdl",{}, sent_body, brahmin_footstep, brahmin_speed, "Creature", 1, brahmin_view)
AddCreature("Dog","models/fallout/dogmeat.mdl",{}, sent_body, brahmin_footstep, brahmin_speed, "Creature", 5, dog_view)
AddCreature("Robot Dog","models/thespireroleplay/Fallout/Dogs/rex.mdl",{}, sent_body, brahmin_footstep, brahmin_speed, "Creature", 5, dog_view)
AddCreature("Centaur","models/fallout/centaur.mdl",{},sent_body, brahmin_footstep, brahmin_speed,"Creature",4)
AddCreature("Spore Carrier","models/fallout/sporecarrier.mdl",{},sent_body, brahmin_footstep, brahmin_speed,"Creature",4, dog_view)
--Test cs go
AddCreature("L4D","models/player/p_roje.mdl",{}, enc_body, enc_footstep,human_speed,"L4D",10, human_view)
-------------------------------

pig.RegisterFlag("cd","Makes the selected user a 'Deathclaw'",{
OnGive = function(ply)
  ply:MakeCreature("Deathclaw")
end,
OnTake = function(ply)
  ply:MakeCreature()
end,
OnCharSelect = function(ply)
  ply:MakeCreature("Deathclaw")
end
})