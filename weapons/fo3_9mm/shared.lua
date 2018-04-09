SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1hpequip"
SWEP.HolsterAnim = "1hpunequip"
SWEP.Attachment = 0
SWEP.WepScale = 1.25
SWEP.WeaponModel = "models/fallout/weapons/c_berettam9.mdl"
SWEP.WepPos = Vector(6,-2, 0.5)
SWEP.WepAng = Angle(-78, -90,1)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"1hpattack4"}
SWEP.ReloadAnims = {"1hpreloadl"}
SWEP.ReloadPostAnim = "1hpaim"
SWEP.ShootSound = {"wep/9mmsmg/9mm_fire_2d01.mp3","wep/9mmsmg/9mm_fire_2d02.mp3","wep/9mmsmg/9mm_fire_2d03.mp3","wep/9mmsmg/9mm_fire_2d04.mp3"}
SWEP.ShootVolume = 0.7
SWEP.MaximumShots = 350
SWEP.ReloadSound = "wep/9mm/wpn_9mm_reload.wav"

SWEP.IronVec = Vector(-2.6, 3, 1.7)
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

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
-------------------------------------------------
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "9mm Pistol"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 62
//----------------------------------------------
SWEP.Primary.ClipSize = 13
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 4.5
SWEP.Primary.InvAmmo = "fo3_ammo_9mm"
SWEP.Primary.WepFireSeq = "1hpattackright"
SWEP.Primary.WepRSeq = "1hpreloadl"
SWEP.ReloadTime = 2.4
-------------------------------------------------
--------------------------------------------------------------------------------