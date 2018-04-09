SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1hpequipb"
SWEP.HolsterAnim = "1hpunequipb"
SWEP.WeaponModel = "models/fallout/weapons/w_10mmpistolsilenced.mdl"
SWEP.WepPos = Vector(4.75,-1.65,1.25)
SWEP.WepAng = Angle(-80,-90,0)
SWEP.AttackAnims = {"1hpattack7"}
SWEP.ReloadAnims = {"1hpreloada"}
SWEP.ReloadPostAnim = "1hphandgrip6_OneHanded"
SWEP.ShootSound = {"wep/10mmpistol_silenced/pistol_10mm_silenced_2d.wav"}
SWEP.MaximumShots = 250
SWEP.WeaponBone = "Bip01 R Hand"

SWEP.IronVec = Vector(-2.8, 3, 0.37)
SWEP.IronAng = Angle(0,0,0)
SWEP.IronSightTime = 0.3

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
--SWEP.TracerType = "effect_fo3_blasterbeam"
SWEP.CriticalColor = Color(255,255,255)
SWEP.CriticalChance = 5
SWEP.Primary.Recoil = 3
SWEP.Primary.RecoilDown = true
SWEP.Primary.Delay = 0.2
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 3
SWEP.ShootVolume = 0.9

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
-------------------------------------------------
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Silenced 10mm Pistol"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/fallout/player/1stperson.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 62
//----------------------------------------------
SWEP.Primary.ClipSize = 12
SWEP.Primary.DefaultClip = 0
SWEP.Primary.InvAmmo = "fo3_ammo_10mm"
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 5.5
SWEP.ReloadTime = 2.45
SWEP.ReloadSound = "wep/10mm/wpn_pistol10mm_reload.wav"
-------------------------------------------------
--------------------------------------------------------------------------------