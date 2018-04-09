SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1hpequipb"
SWEP.HolsterAnim = "1hpunequip"
SWEP.EnergyWep = true
SWEP.WeaponModel = "models/fallout/weapons/w_laserpistol.mdl"
SWEP.OriginPos = Vector(2,-2.5,-2.25)
SWEP.OriginAng = Angle(0,2,-3)
SWEP.WepPos = Vector(10.5,-1.35,2)
SWEP.WepAng = Angle(1,-57,90)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"1hpattack7"}
SWEP.ReloadAnims = {"1hpreloadq"}
SWEP.ReloadPostAnim = "1hphandgrip6_OneHanded"
SWEP.ShootSound = {"wep/laserpistol/pistollaser_fire_2d.wav"}
SWEP.ShootVolume = 0.75
SWEP.MaximumShots = 1200

SWEP.HolsterBone = "Bip01 R Thigh"
SWEP.HolsterPos = Vector(2,0,5)
SWEP.HolsterAng = Angle(-90,0,0)
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
SWEP.HolsterAnimAct = ACT_GESTURE_MELEE_ATTACK2
SWEP.UnHolsterAnimAct = ACT_VM_DEPLOYED_IN
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
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Laser Pistol"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 70
//----------------------------------------------
SWEP.Primary.Delay = 0.25
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.InvAmmo = "fo3_ammo_ecell"
SWEP.Primary.Damage = 4.5
SWEP.ReloadTime = 2.75
SWEP.ReloadSound = "wep/laserpistol/pistollaser_reload.wav"
-------------------------------------------------
--------------------------------------------------------------------------------