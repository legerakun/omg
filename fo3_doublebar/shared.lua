SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.AimHoldType = "physgun"
SWEP.EquipAnim = "2hrequip"
SWEP.HolsterAnim = "2hrunequip"
SWEP.WeaponModel = "models/fallout/weapons/c_doublebarrel.mdl"
SWEP.WepPos = Vector(5,-1,1)
SWEP.WepAng = Angle(0,-95,90)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"d_2hrattack6"}
SWEP.ReloadAnims = {"d_2hrreloadg"}
SWEP.ShootSound = {"wep/doublebar/wpn_dblbarrelshotgun_fire_2d_01.mp3","wep/doublebar/wpn_dblbarrelshotgun_fire_2d_02.mp3"}
SWEP.MaximumShots = 1000
SWEP.Primary.WepRSeq = "2hrreloadg"

SWEP.HolsterBone = "Bip01 Spine2"
SWEP.HolsterPos = Vector(-3, 7, -1)
SWEP.HolsterAng = Angle(0,-115,90)
SWEP.HolsterAnimAct = ACT_DOD_PRONE_AIM_C96
SWEP.UnHolsterAnimAct = ACT_GESTURE_RANGE_ATTACK_HMG1

SWEP.IronVec = Vector(-4.9, 0.35, 3.3)
SWEP.IronAng = Angle(0, -3.25, -1)
-------------------------------------------------
SWEP.CriticalColor = Color(234,10,15)
SWEP.CriticalChance = 45
SWEP.Primary.Recoil = 16
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 4

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.ShootVolume = 1
SWEP.EnergyEffect = ""
-------------------------------------------------
SWEP.HoldType = "shotgun"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Double Barrel Shotgun"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 60
//----------------------------------------------
SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 0.55
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 8
SWEP.Primary.InvAmmo = "fo3_ammo_12g"
SWEP.Primary.Bullets = 4
SWEP.Primary.Cone = 0.1
SWEP.ReloadSound = "wep/sawed/reloading.mp3"
SWEP.ReloadTime = 2
-------------------------------------------------
--------------------------------------------------------------------------------