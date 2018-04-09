SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2hrequip"
SWEP.HolsterAnim = "2hrunequip"
SWEP.AimHoldType = "smg"
SWEP.EnergyWep = true
SWEP.WeaponModel = "models/fallout/weapons/w_laserrifle.mdl"
SWEP.OriginPos = Vector(0,-2.5,-1)
SWEP.OriginAng = Angle(0,0,0)
SWEP.WepPos = Vector(10.5,-1.35,2)
SWEP.WepAng = Angle(1,-57,90)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"d_2hrattack4"}
SWEP.ReloadAnims = {"2hrreloadb"}
SWEP.ShootSound = {"wep/laserrifle/laserrifle_fire_2d01.wav","wep/laserrifle/laserrifle_fire_2d02.wav"}
SWEP.ShootVolume = 0.8
SWEP.MaximumShots = 1200

SWEP.HolsterBone = "Bip01 Spine2"
SWEP.HolsterPos = Vector(-3, 7, -1)
SWEP.HolsterAng = Angle(0,-115,90)
SWEP.HolsterAnimAct = ACT_DOD_PRONE_AIM_C96
SWEP.UnHolsterAnimAct = ACT_GESTURE_RANGE_ATTACK_HMG1
-------------------------------------------------
SWEP.TracerType = "effect_fo3_lasers"
SWEP.CriticalMat = "effects/laserblast"
SWEP.CriticalColor = Color(234,10,15)
SWEP.CriticalChance = 45
SWEP.Primary.Recoil = 1
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 4

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "fo3_muzzle_laserrifle"
SWEP.MuzzleAttachment                   = "1"
SWEP.EnergyEffect = "effect_fo3_laserhit"
-------------------------------------------------
SWEP.HoldType = "ar2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Laser Rifle"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 70
//----------------------------------------------
SWEP.Primary.Delay = 0.205
SWEP.Primary.ClipSize = 24
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 8.25
SWEP.Primary.InvAmmo = "fo3_ammo_mfcell"
SWEP.ReloadTime = 2
SWEP.ReloadSound = "wep/laserrifle/reload.mp3"
-------------------------------------------------
--------------------------------------------------------------------------------