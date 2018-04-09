Schema.AnimationSet = {}
--
local function cowboyRepeaterBolt(ply, wclip)
    local timername = "FAnimBolt:"..ply:SteamID64()
	local clip = 7
	local bolts = clip - wclip
	--
	local startgest = "2hrreloadz"
	ply:AnimNetworkedSeq( GESTURE_SLOT_ATTACK_AND_RELOAD, ply:LookupSequence(startgest), 0, true )
	--
	if bolts <= 1 then return end
	timer.Create(timername, .5, bolts-1, function()
	  if !IsValid(ply) or !IsValid(wep) then timer.Destroy(timername) return end
	  local reloadgest = "2hrreloadz"
	  ply:AnimNetworkedSeq( GESTURE_SLOT_ATTACK_AND_RELOAD, ply:LookupSequence(reloadgest), 0, true )
	end)
end

--
Schema.AnimationSet["Human"] = {
idle_normal = "mtidle",
crouch_idle_normal = "sneakmtidle",
crouch_walk_normal = "sneakmtwalk",
walk_normal = ACT_WALK,
run_normal = ACT_RUN,
swim_normal = "swimm",
swim_idle_normal = "swimmtidle",
jump_normal = "mtjumploop",
walk_normal_left = "1mdturnleft",
jump_land_normal = "mtjumpland",
--
crouch_idle_fist = "h2haim_sneak",
crouch_walk_fist = "sneakh2haim",
--
fist = {attack = {"h2hattack3_a","h2hattackleft_a","h2hattackleft_b","h2hattackright_a"}},
idle_melee = "1hmaim",
walk_melee = "1hmwalk",
run_melee = "1hmaim_run",
idle_passive = "2haaim",
walk_passive = "2haaim_walk",
jump_land_passive = "2hraim_jumpland",
run_passive = "2haaim_run",
idle_crossbow = "2hhaim",
walk_crossbow = "2hhaim_walk",
run_crossbow = "2hhaim_run",
idle_pistol = "1hpaim",
walk_pistol = "1hpaim_walk",
run_pistol = "1hpaim_run",
crouch_idle_pistol = "sneak1hpaim",
crouch_walk_pistol = "1hpaim_sneak",
crouch_idle_passive = "2haaim_sneak",
crouch_walk_passive = "2haaim_sneakfast",
crouch_walk_ar2 = "2haaim_sneak",
crouch_idle_ar2 = "sneak2haaim",
crouch_walk_melee = "1hmaim_sneak",
crouch_idle_melee = "sneak1hmaim",
crouch_idle_rpg = "sneak2hlaim",
crouch_walk_rpg = "2hlaim_sneak", 
idle_ar2 = "2haaim",
walk_ar2 = "2haaim_walk",
run_ar2 = "2haaim_run",
idle_fist = "h2haim",
walk_fist = "h2haim_walk",
run_fist = "h2haim_run",
idle_melee2 = "2hmaim",
walk_melee2 = "2hmaim_walk",
run_melee2 = "2hmaim_run",
crouch_idle_melee2 = "sneak2hmaim",
crouch_walk_melee2 = "2hmaim_sneak",
idle_grenade = "1gtaim",
walk_grenade = "1gtaim_walk",
run_grenade = "1gtaim_run",
idle_shotgun = "2hraim",
walk_shotgun = "2hraim_walk",
run_shotgun = "2hrrun",
crouch_idle_shotgun = "sneak2hraim",
crouch_walk_shotgun = "2hraim_sneak",
idle_rpg = "2hlaim",
walk_rpg = "2hlaim_walk",
run_rpg = "2hlaim_run",
idle_duel = "1hpaimis",
crouch_idle_duel = "sneak1hpaimis",
crouch_walk_duel = "1hpaimis_sneak",
walk_duel = "1hpaimis_walk",
run_duel = "1hpaimis_run",
idle_smg = "2haaimis",  
walk_smg = "2haaimis_walk",
run_smg = "2haaimis_run",
crouch_walk_smg = "2haaimis_sneak",
crouch_idle_smg = "sneak2haaimis",
idle_physgun = "2hraimis",
walk_physgun = "2hraimis_walk",
run_physgun = "2hraimis_run",
crouch_idle_physgun = "sneak2hraimis",
crouch_walk_physgun = "2hraimis_sneak",
idle_camera = "2hraim",
walk_camera = "2hraim_walk",
run_camera = "2hrrun",
crouch_idle_camera = "sneak2hraim",
crouch_walk_camera = "2hraim_sneak",
idle_magic = "2hraimis",  --[[]]
walk_magic = "2hraimis_walk",
run_magic = "2hraimis_run",
crouch_idle_magic = "sneak2hraimis",
crouch_walk_magic = "2hraimis_sneak",
idle_revolver = "2hraim",
walk_revolver = "2hraim_walk",
run_revolver = "2hrrun",
crouch_idle_revolver = "sneak2hraim",
crouch_walk_revolver = "2hraim_sneak",
idle_knife = "2hraimis",
walk_knife = "2hraimis_walk",
run_knife = "2hraimis_run",
crouch_idle_knife = "sneak2hraimis",
crouch_walk_knife = "2hraimis_sneak",
--
pistol = {attack = ACT_GESTURE_RANGE_ATTACK_PISTOL_LOW, reload = {
  ["fo3_revolver"] = "1hpreloade",
  ["fo3_10mm"] = "1hpreloada",
  ["fo3_10mm_sub"] = "1hpreloadg",  
  ["fo3_10mm_sil"] = "1hpreloada",  
  ["fo3_10mm_carbine"] = "1hpreloadg",
  ["fo3_9mm"] = "1hpreloada",
  ["fo3_9mm_sub"] = "1hpreloadg",
  ["fo3_blaster"] = "1hpreloadj",
  ["fo3_laserpistol"] = "1hpreloadp",
  ["fo3_mauser"] = "1hpreloadc",
  ["fo3_plasmapistol"] = "1hpreloadc",
  ["fo3_sawnoff"] = "1hpreloadk",
}},
--
ar2 ={attack = "2haattack4", reload = {
  ["fo3_ak112"] = "2hareloadi",
  ["fo3_service"] = "2hareloadi",  
  ["fo3_chinesear"] = "2hareloade",
  ["fo3_laserrifle"] = "2hrreloadb",
  ["fo3_multiplas"] = "2hrreloadb",
  ["fo3_plasmarifle"] = "2hrreloadb",
  ["fo3_plasmaturbo"] = "2hrreloadb",  
}},
--
shotgun = {attack = "2hrattack4", reload = {
  ["fo3_combatsg"] = "2hrreloadd",
  ["fo3_doublebar"] = "2hrreloadg",
  ["fo3_sniper"] = "2hrreloadm",
  ["fo3_crepeater"] = function(ply, event, data)
    if !SERVER then return end
	local wep = ply:GetActiveWeapon()
	if !IsValid(wep) then return end
	local wclip = wep:Clip1()
    cowboyRepeaterBolt(ply, wclip)
  end,
}},
--
rpg = {attack = "2hlattackleft", reload = {
  ["fo3_fatman"] = "2hlreloada",
  ["fo3_teslacannon"] = "2hlreloadb",
}},
--
crossbow = {attack = "2hhattackleft", reload = {
  ["fo3_gattling"] = "2hhreloadd",
}},
--
duel = {attack = "1hpattackrightis", reload = {
  ["fo3_revolver"] = "1hpreloade",
  ["fo3_10mm"] = "1hpreloada",
  ["fo3_10mm_sub"] = "1hpreloadg",  
  ["fo3_10mm_sil"] = "1hpreloada",  
  ["fo3_10mm_carbine"] = "1hpreloadg",
  ["fo3_9mm"] = "1hpreloada",
  ["fo3_9mm_sub"] = "1hpreloadg",
  ["fo3_blaster"] = "1hpreloadj",
  ["fo3_laserpistol"] = "1hpreloadp",
  ["fo3_mauser"] = "1hpreloadc",
  ["fo3_plasmapistol"] = "1hpreloadc",
  ["fo3_sawnoff"] = "1hpreloadk",
}},
--
physgun ={attack = "2hrattackleftis", reload = {
  ["fo3_combatsg"] = "2hrreloadd",
  ["fo3_doublebar"] = "2hrreloadg",
  ["fo3_sniper"] = "2hrreloadm",
  ["fo3_service"] = "2hareloadi",  
  ["fo3_crepeater"] = function(ply, event, data)
    if !SERVER then return end
	local wep = ply:GetActiveWeapon()
	if !IsValid(wep) then return end
	local wclip = wep:Clip1()
    cowboyRepeaterBolt(ply, wclip)
  end,
}},
--
smg ={attack = "2haattack4is", reload = {
  ["fo3_ak112"] = "2hareloadi",
  ["fo3_chinesear"] = "2hareloade",
  ["fo3_laserrifle"] = "2hrreloadb",
  ["fo3_multiplas"] = "2hrreloadb",
  ["fo3_plasmarifle"] = "2hrreloadb",
  ["fo3_plasmaturbo"] = "2hrreloadb",  
}},
--
magic ={attack = "2hrattack3is", reload = "2hrreloada"},
--
knife ={attack = "2hrattackrightis", reload = ACT_GESTURE_RANGE_ATTACK_AR2},
--
camera ={attack = "2hrattack3", reload = "2hrreloada"},
--
revolver ={attack = "2hrattackright", reload = "2hrreloadd"},
--
melee = {attack = {418,419}},
knife ={attack = "2hrattackrightis", reload = ACT_GESTURE_RANGE_ATTACK_AR2},
melee2 = {attack = {264,1965}},
grenade = {attack = "1gtattackthrow"}
}

function Schema.Hooks:pig_SetNewAnim(ply,cur_anim,act,strname)
  if ply:LegsCrippled() then
    if strname:find("normal") and !strname:find("crouch") then
	else
	  return
	end
	--
	local seq = nil
	if strname:find("idle") then
	  seq = "hurt_mtidle"
	elseif strname:find("walk") or strname:find("run") then
	  seq = "hurt_mtforward"
	end
	--
	if seq then
	  seq = ply:LookupSequence(seq)
	  return seq
	end
  end
end

if SERVER then

function Schema.Hooks:LimbNewHitgroup(ply,hitgroup,dmginfo)
local attacker = dmginfo:GetAttacker()
if !ply:Alive() or attacker:IsWorld() or !attacker:IsPlayer() and !attacker:IsNPC() and !attacker:GetClass():find("npc") then return end
--

local trace = nil
  if attacker:IsPlayer() then
    trace = attacker:GetEyeTrace()
  else
    local pos = attacker:GetShootPos()
    local ang = attacker:GetAimVector()
    local tracedata = {}
    tracedata.start = pos
    tracedata.endpos = pos+(ang*4096)
    tracedata.filter = attacker
	trace = util.TraceLine(tracedata)
  end
--
local physbone = trace.PhysicsBone
local bone = ply:TranslatePhysBoneToBone(physbone)
local bonename = ply:GetBoneName(bone)
--
  if bonename:find("L Finger") or bonename:find("L Thumb") then
    return HITGROUP_LEFTARM
  elseif bonename:find("R Finger") or bonename:find("R Thumb")  then
    return HITGROUP_RIGHTARM
  end
--
local tbl = {}
tbl[HITGROUP_LEFTARM] = {"Bip01 L ForeArm","Bip01 L UpperArm","Bip01 L Hand","Bip01 L ForeTwist","Bip01 L Clavicle"}
tbl[HITGROUP_LEFTARM] = {"Bip01 R ForeArm","Bip01 R UpperArm","Bip01 R Hand","Bip01 R ForeTwist","Bip01 R Clavicle"}
tbl[HITGROUP_HEAD] = {"Bip01 Neck","Bip01 Head","Bip01 Neck1"}
tbl[HITGROUP_CHEST] = {"Bip01 Spine1", "Bip01 Spine2"}
tbl[HITGROUP_STOMACH] = {"Bip01 Spine", "Bip01 Pelvis","Bip01"}
tbl[HITGROUP_LEFTLEG] = {"Bip01 L Thigh","Bip01 L Calf","Bip01 L Foot","Bip01 L Toe0"}
tbl[HITGROUP_RIGHTLEG] = {"Bip01 R Thigh","Bip01 R Calf","Bip01 R Foot","Bip01 R Toe0"}
print(bonename)
  for k,v in pairs(tbl) do
    if table.HasValue(v,bonename) then
	  print("Returning "..k.."")
	  return k
	end
  end
end

end

Schema.AnimationSet["MetroPolice"] = {
--IMPORTANT (Normal Holdtype Anims)
  idle_normal = "busyidle2",
  crouch_idle_normal = "Crouch_idle_pistol",
  crouch_walk_normal = "Crouch_all",
  walk_normal = ACT_WALK,
  run_normal = ACT_RUN,
  jump_normal = ACT_JUMP,
-------------------------------------------------
--ATTACK ANIMS
  idle_pistol = "pistolangryidle2",
  walk_pistol = "walk_aiming_pistol_all",
  run_pistol = "run_aiming_pistol_all",
  pistol = {attack = ACT_GESTURE_RANGE_ATTACK_PISTOL, reload = ACT_GESTURE_RELOAD_PISTOL},
  --
  idle_melee = "batonangryidle1",
  walk_melee = "walk_hold_baton_angry",
  melee = {attack = ACT_MELEE_ATTACK_SWING_GESTURE},
  --
  idle_smg = "smg1angryidle1",
  walk_smg = "walk_aiming_SMG1_all",
  run_smg = "run_aiming_smg1_all",
  smg = {attack = ACT_GESTURE_RANGE_ATTACK_SMG1, reload = ACT_GESTURE_RELOAD_SMG1},
  --
  idle_passive = "smg1idle1",
  walk_passive = "walk_hold_smg1",
  run_passive = "run_hold_smg1",
  idle_ar2 = "smg1angryidle1",
  walk_ar2 = "walk_aiming_SMG1_all",
  run_ar2 = "run_aiming_smg1_all",
  ar2 = {attack = ACT_GESTURE_RANGE_ATTACK_SMG1, reload = ACT_GESTURE_RELOAD_SMG1},
  --
  idle_physgun = "smg1angryidle1",
  walk_physgun = "walk_aiming_smg1_all",
  run_physgun = "run_aiming_smg1_all",
  --
  idle_shotgun = "smg1angryidle1",
  walk_shotgun = "walk_aiming_SMG1_all",
  run_shotgun = "run_aiming_smg1_all",
  shotgun = {attack = ACT_GESTURE_RANGE_ATTACK_SMG1, reload = ACT_GESTURE_RELOAD_SMG1},
  --
  idle_fist = "Idle_Baton",
  fist = {attack = ACT_MELEE_ATTACK_SWING},
  knife = {attack = ACT_MELEE_ATTACK_SWING}
-----------------------
}

Schema.AnimationSet["Deathclaw"] = {
idle_normal = ACT_IDLE,
walk_normal = ACT_WALK,
run_normal = ACT_RUN,
jump_normal = ACT_RUN,
crouch_idle_normal = "cageidle",
--
melee = {attack = ACT_MELEE_ATTACK1},
fist = {attack = ACT_MELEE_ATTACK1},
}

Schema.AnimationSet["Robot"] = {
idle_normal = ACT_IDLE,
walk_normal = ACT_WALK,
run_normal = ACT_RUN,
jump_normal = ACT_RUN,
crouch_idle_normal = ACT_CROUCH,
--

}

Schema.AnimationSet["Creature"] = {
idle_normal = ACT_IDLE,
walk_normal = ACT_WALK,
run_normal = ACT_RUN,
jump_normal = ACT_RUN,
crouch_idle_normal = ACT_CROUCH,
--
fist = {attack = ACT_MELEE_ATTACK1},
}

Schema.AnimationSet["Super Mutant"] = {
idle_normal = "mtidle",
crouch_idle_normal = "mtidle",
crouch_walk_normal = ACT_WALK,
walk_normal = ACT_WALK,
run_normal = ACT_RUN,
jump_normal = ACT_RUN,
--
melee = {attack = {"2hmattackleft_a","2hmattackright_a","2hmattackright_b"}},
melee2 = {attack = {"2hmattackleft_a","2hmattackright_a","2hmattackright_b"}},
fist = {attack = ACT_GESTURE_MELEE_ATTACK1},
crossbow = {attack = "2hhattackloop", reload = "2hhreloadc"},
grenade = {attack = "1gtattackthrow"},
physgun = {attack = "2haattackloop", reload = "2hareloada"},
smg = {attack = "2haattackloop", reload = "2hareloada"},
ar2 = {attack = "2haattackloop", reload = "2hareloada"},
rpg = {attack = "2hlattackright", reload = "2hareloada"},
pistol = {attack = "2hrattack2", reload = "2hareloada"},
duel = {attack = "2hrattack2", reload = "2hareloada"},
shotgun = {attack = "2hrattack2", reload = "2hrreloada"},
magic = {attack = "2hrattack3", reload = "2hrreloada"},
camera = {attack = "2hrattack3", reload = "2hrreloada"},
--
crouch_idle_ar2 = "2haaim",
crouch_idle_smg = "2haaim",
crouch_idle_physgun = "2haaim",
crouch_walk_ar2 = "2haaim_walk",
crouch_walk_smg = "2haaim",
crouch_walk_physgun = "2haaim",
crouch_idle_grenade = "1gtaim",
crouch_walk_grenade = "1gtaim_walk",
idle_duel = "2hraim",
walk_duel = "2hraim_walk",
run_duel = "2hraim_run",
idle_pistol = "2hraim",
walk_pistol = "2hraim_walk",
run_pistol = "2hraim_run",
idle_smg = "2haaim",
walk_smg = "2haaim_walk",
run_smg = "2haaim_run",
idle_physgun = "2haaim",
walk_physgun = "2haaim_walk",
run_physgun = "2haaim_run",
idle_grenade = "1gtaim",
walk_grenade = "1gtaim_walk",
run_grenade = "1gtaim_run",
idle_ar2 = "2haaim",
walk_ar2 = "2haaim_walk",
run_ar2 = "2haaim_run",
idle_shotgun = "2haaim",
walk_shotgun = "2haaim_walk",
run_shotgun = "2haaim_run",
idle_fist = "h2haim",
walk_fist = "h2haim_walk",
run_fist = "h2haim_run",
idle_melee = "2hmaim",
walk_melee = "2hmaim_walk",
run_melee = "2hmaim_run",
idle_melee2 = "2hmaim",
walk_melee2 = "2hmaim_walk",
run_melee2 = "2hmaim_run",
idle_crossbow = "2hhaim",
walk_crossbow = "2hhaim_walk",
run_crossbow = "2hhaim_run",
idle_rpg = "2hlaim",
walk_rpg = "2hlaim_walk",
run_rpg = "2hlaim_run",
idle_magic = "2hraim",
crouch_idle_magic = "2hraim",
crouch_walk_magic = "2hraim_walk",
walk_magic = "2hraim_walk",
run_magic = "2hraim_run",
idle_camera = "2hraim",
crouch_idle_camera = "2hraim",
crouch_walk_camera = "2hraim_walk",
walk_camera = "2hraim_walk",
run_camera = "2hraim_run",
}

/*
Schema.AnimationSet["L4D"] = {
FlipLR = true,
idle_normal = "StandIdle_GREN_STICK",
crouch_idle_normal = "sneakmtidle",
crouch_walk_normal = "sneakmtwalk",
walk_normal = "w_WalkIdle_GREN_STICK",
run_normal = "r_RunIdle_GREN_STICK",
jump_normal = "mtjumploop",
walk_normal_left = "1mdturnleft",
--
idle_pistol = "StandAim_PISTOL",
walk_pistol = "w_WalkAim_PISTOL",
run_pistol = "r_RunAim_PISTOL",
--
PoseFunc = function(ply,velocity)
  local ang = ply:EyeAngles()
  local pitch = -ang.p
  local yaw = -ang.y
  
  ply:SetPoseParameter("body_pitch",pitch)

  --ply:SetPoseParameter("body_yaw",yaw)
end,
}
*/
