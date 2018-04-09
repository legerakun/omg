SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2hrequip"
SWEP.HolsterAnim = "2hrunequip"
SWEP.HolsterAct = "ar2"
SWEP.WeaponModel = "models/fallout/weapons/w_combatshotgun.mdl"
SWEP.WepPos = Vector(7,-2.05,2)
SWEP.WepAng = Angle(-1,-56,90)

SWEP.AimHoldType = "physgun"
SWEP.HolsterBone = "Bip01 Spine2"
SWEP.HolsterPos = Vector(-3, 7, -1)
SWEP.HolsterAng = Angle(0,-115,90)

SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"d_2hrattack6"}
SWEP.ReloadAnims = {"2hrreloadd"}
SWEP.ShootSound = {"wep/combatsg/shotguncombat_fire_2d.wav"}
SWEP.MaximumShots = 500

SWEP.HolsterAnimAct = ACT_DOD_PRONE_AIM_C96
SWEP.UnHolsterAnimAct = ACT_GESTURE_RANGE_ATTACK_HMG1
-------------------------------------------------
--SWEP.TracerType = "effect_fo3_blasterbeam"
SWEP.CriticalColor = Color(255,255,255)
SWEP.CriticalChance = 32
SWEP.Primary.Recoil = 11
SWEP.Primary.RecoilDelay = 1
SWEP.Primary.RecoilDown = true
SWEP.Primary.RecoilTime = 0.25
SWEP.Primary.Delay = 0.6
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 0

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
SWEP.ShootVolume = 1
-------------------------------------------------
SWEP.HoldType = "shotgun"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Combat Shotgun"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 64
//----------------------------------------------
SWEP.Primary.ClipSize = 12
SWEP.Primary.Bullets = 5
SWEP.Primary.Cone = 0.09
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.InvAmmo = "fo3_ammo_12g"
SWEP.Primary.Damage = 6
SWEP.Primary.Force = 100
SWEP.ReloadTime = 2.5
SWEP.ReloadSound = "wep/combatsg/shotguncombat_reload.wav"
-------------------------------------------------
--------------------------------------------------------------------------------