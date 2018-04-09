SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2hrequip"
SWEP.HolsterAnim = "2hrunequip"
SWEP.Attachment = 0
SWEP.AimHoldType = "physgun"
SWEP.WeaponModel = "models/fallout/weapons/c_battlerifle.mdl"
SWEP.OriginPos = Vector(0,0,-1.5)
SWEP.OriginAng = Angle(2,0,0)
SWEP.WepPos = Vector(7.8, -2, 3)
SWEP.WepAng = Angle(0,-60,90)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"d_2hrattack6"}
SWEP.ReloadAnims = {"2hareloadf"}
SWEP.ReloadPostAnim = "d_2hraim"
SWEP.ShootSound = {"wep/service/fire1.mp3","wep/service/fire2.mp3"}
SWEP.ShootVolume = 1
SWEP.MaximumShots = 1200

SWEP.IronVec = Vector(-4.6,-4.15,4.1)
SWEP.IronAng = Angle(-2.1,-3,1.5)

SWEP.HolsterBone = "Bip01 Spine2"
SWEP.HolsterPos = Vector(-3, 7, -1)
SWEP.HolsterAng = Angle(0,-115,90)

SWEP.HolsterAnimAct = ACT_DOD_PRONE_AIM_C96
SWEP.UnHolsterAnimAct = ACT_GESTURE_RANGE_ATTACK_HMG1
-------------------------------------------------
SWEP.CriticalChance = 45
SWEP.Primary.Recoil = 1
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 4

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
-------------------------------------------------
SWEP.HoldType = "ar2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Service Rifle"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 65
//----------------------------------------------
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 7
SWEP.Primary.InvAmmo = "fo3_ammo_556mm"
SWEP.Primary.WepRSeq = "2hareloadf"
SWEP.ReloadTime = 2.52
SWEP.ReloadSound = "wep/assaultrifle/reloading_2.mp3"
-------------------------------------------------
--------------------------------------------------------------------------------
