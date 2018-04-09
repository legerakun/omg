SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1hpequipb"
SWEP.HolsterAnim = "1hpunequipb"
SWEP.WeaponModel = "models/fallout/weapons/w_sawedoffshotgun.mdl"
SWEP.WepPos = Vector(4.75,-1.65,1.25)
SWEP.WepAng = Angle(-80,-90,0)

SWEP.IronVec = Vector(-2.8, 3, 0.37)
SWEP.IronAng = Angle(0,0,0)
SWEP.IronSightTime = 0.3

SWEP.HolsterBone = "Bip01 R Thigh"
SWEP.HolsterPos = Vector(2,0,5)
SWEP.HolsterAng = Angle(-90,0,0)
SWEP.HolsterAnimAct = ACT_GESTURE_MELEE_ATTACK2
SWEP.UnHolsterAnimAct = ACT_VM_DEPLOYED_IN

SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"1hpattack7"}
SWEP.ReloadAnims = {"1hpreloadk"}
SWEP.ShootSound = {"wep/sawed/wpn_sawedoffshotgun_fire_2d_01.mp3","wep/sawed/wpn_sawedoffshotgun_fire_2d_02.mp3"}
SWEP.MaximumShots = 500
-------------------------------------------------
--SWEP.TracerType = "effect_fo3_blasterbeam"
SWEP.CriticalColor = Color(255,255,255)
SWEP.CriticalChance = 32
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 0.6
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 0

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
SWEP.ShootVolume = 1
-------------------------------------------------
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Sawed Off Shotgun"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 70
//----------------------------------------------
SWEP.Primary.ClipSize = 2
SWEP.Primary.Bullets = 4
SWEP.Primary.Cone = 0.09
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 8.8
SWEP.Primary.InvAmmo = "fo3_ammo_12g"
SWEP.ReloadTime = 2.35
SWEP.ReloadSound = "wep/sawed/reloading.mp3"
-------------------------------------------------
--------------------------------------------------------------------------------