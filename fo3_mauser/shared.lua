SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1hpequip"
SWEP.HolsterAnim = "1hpunequip"
SWEP.Attachment = 0
SWEP.WepScale = 1.25
SWEP.WeaponModel = "models/fallout/weapons/c_9mm_mauser.mdl"
SWEP.WepPos = Vector(6,-2, 0.5)
SWEP.WepAng = Angle(-78, -90,1)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"1hpattackright"}
SWEP.ReloadPostAnim = "1hpaim"
SWEP.ReloadAnims = {"1hpreloadc"}
SWEP.ShootSound = {"wep/mauserpistol/pistolmauser_fire_2d.wav"}
SWEP.ShootVolume = 1
SWEP.MaximumShots = 350

SWEP.IronVec = Vector(-2.6, 3, -.35)
SWEP.IronAng = Angle(2.5,0,0)
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

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
-------------------------------------------------
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Mauser Pistol"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 62
//----------------------------------------------
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.InvAmmo = "fo3_ammo_10mm"
SWEP.Primary.Damage = 4
SWEP.Primary.WepFireSeq = "1hpattackright"
SWEP.Primary.WepRSeq = "1hpreloadc"
SWEP.ReloadTime = 2.7
SWEP.ReloadSound = "wep/mauserpistol/pistolmauser_reload.wav"
-------------------------------------------------
--------------------------------------------------------------------------------