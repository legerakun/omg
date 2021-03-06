SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2hrequip"
SWEP.HolsterAnim = "2hrunequip"
SWEP.EnergyWep = true
SWEP.WeaponModel = "models/fallout/weapons/c_turbo_plasmarifle.mdl"
SWEP.OriginPos = Vector(0,-2.5,-1)
SWEP.OriginAng = Angle(0,0,0)
SWEP.WepPos = Vector(10,-1,4)
SWEP.WepAng = Angle(1,-57,90)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"d_2hrattack4"}
SWEP.ReloadAnims = {"2hrreloade"}
SWEP.ShootSound = {"wep/plasmarifle/wpn_plasmarifle_fire_2d_01.mp3","wep/plasmarifle/wpn_plasmarifle_fire_2d_02.mp3"}
SWEP.ShootVolume = 0.45
SWEP.MaximumShots = 1000

SWEP.HolsterAct = "normal"
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
-------------------------------------------------
SWEP.TracerType = "effect_fo3_plasma"
SWEP.CriticalColor = Color(0,179,60,255)
SWEP.CriticalChance = 45
SWEP.Primary.Recoil = 1
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 4
SWEP.AimHoldType = "smg"

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "fo3_muzzle_plasmarifle"
SWEP.MuzzleAttachment                   = "1"
SWEP.EnergyEffect = ""
-------------------------------------------------
SWEP.HoldType = "ar2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Turbo Plasma Rifle"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 70
//----------------------------------------------
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.335
SWEP.Primary.Ammo = "none"
SWEP.Primary.InvAmmo = "fo3_ammo_mfcell"
SWEP.Primary.Damage = 13
SWEP.Primary.Cone = 0.02
SWEP.ReloadTime = 2.7
SWEP.ReloadSound = "wep/plasmarifle/plasmarifle_reload.wav"
-------------------------------------------------
--------------------------------------------------------------------------------