SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2haequip"
SWEP.HolsterAnim = "2haunequip"
SWEP.WeaponModel = "models/fallout/weapons/c_ak-112.mdl"
SWEP.WepPos = Vector(7,-2.05,1)
SWEP.WepAng = Angle(-1,-56,90)

SWEP.IronVec = Vector(-3.175, 3, 2.55)
SWEP.IronAng = Angle(-1, 2.55, 0)
SWEP.IronSightTime = 0.35

SWEP.HolsterAct = "normal"
SWEP.AimHoldType = "smg"
SWEP.HolsterBone = "Bip01 Spine2"
SWEP.HolsterPos = Vector(-3, 7, -1)
SWEP.HolsterAng = Angle(0,-115,90)
/*
--HolsterAnim
ACT_SMG2_TOBURST (2 handed melee)
ACT_GESTURE_RANGE_ATTACK2_LOW (1 handed melee)
ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE (grenade)

--UnHolsterAnim
ACT_SLAM_STICKWALL_TO_THROW (2 handed melee)
ACT_GESTURE_RANGE_ATTACK1_LOW (1 handed melee)
ACT_GESTURE_RANGE_ATTACK_HMG1 (2 handed rifle)
ACT_HL2MP_GESTURE_RELOAD_GRENADE (grenade)
ACT_DOD_PRIMARYATTACK_PISTOL (hand to hand)
*/
SWEP.HolsterAnimAct = ACT_DOD_PRONE_AIM_C96
SWEP.UnHolsterAnimAct = ACT_GESTURE_RANGE_ATTACK_HMG1

SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"2haattack3"}
SWEP.ReloadAnims = {"2hareloadf"}
SWEP.ShootSound = {"wep/ak112/wpn_ak47_fire_2d.wav"}
SWEP.MaximumShots = 500
-------------------------------------------------
--SWEP.TracerType = "effect_fo3_blasterbeam"
SWEP.CriticalColor = Color(255,255,255)
SWEP.CriticalChance = 5
SWEP.Primary.Recoil = 3.45
SWEP.Primary.RecoilDown = false
SWEP.Primary.Delay = 0.17
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 0

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.ShootVolume = 1
-------------------------------------------------
SWEP.HoldType = "ar2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "AK-112"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 70
//----------------------------------------------
SWEP.Primary.ClipSize = 24
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.InvAmmo = "fo3_ammo_5mm"
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 5.8
SWEP.Primary.WepFireSeq = "fire"
SWEP.Primary.WepRSeq = "2hareloadf"
SWEP.ReloadTime = 2.52
SWEP.ReloadSound = "wep/assaultrifle/reloading_2.mp3"
-------------------------------------------------
--------------------------------------------------------------------------------