SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2hrequip"
SWEP.HolsterAnim = "2hrunequip"
SWEP.Attachment = 0
SWEP.AimHoldType = "magic"
SWEP.WeaponModel = "models/fallout/weapons/c_huntingrifle.mdl"
SWEP.OriginPos = Vector(0,0, -.5)
SWEP.OriginAng = Angle(2,0,0)
SWEP.WepPos = Vector(-2.25, 0.5, 10)
SWEP.WepAng = Angle(-95, 0,-62)
SWEP.WeaponBone = "Bip01 L Hand"
SWEP.AttackAnims = {"2hrattack8"}
SWEP.ReloadAnims = {"2hrreloada"}
SWEP.ReloadPostAnim = "2hraim"
SWEP.ShootSound = {"wep/huntingrifle/fire1.mp3","wep/huntingrifle/fire2.mp3","wep/huntingrifle/fire3.mp3"}
SWEP.ShootVolume = 1
SWEP.MaximumShots = 1200

SWEP.IronVec = Vector(-4, 0.15, 3.3)
SWEP.IronAng = Angle(-1.75, -0.5, -1.5)

SWEP.HolsterBone = "Bip01 Spine2"
SWEP.HolsterPos = Vector(-8, 7, 2)
SWEP.HolsterAng = Angle(0,-115,90)

SWEP.HolsterAnimAct = ACT_DOD_PRONE_AIM_C96
SWEP.UnHolsterAnimAct = ACT_GESTURE_RANGE_ATTACK_HMG1
-------------------------------------------------
SWEP.CriticalChance = 45
SWEP.Primary.Recoil = 12
SWEP.Primary.RecoilTime = 0.25
SWEP.Primary.RecoilDown = true
SWEP.Primary.Delay = 1.25
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 4

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
-------------------------------------------------
SWEP.HoldType = "camera"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Hunting Rifle"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 65
//----------------------------------------------
SWEP.Primary.ClipSize = 5
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 12
SWEP.Primary.InvAmmo = "fo3_ammo_308"
SWEP.Primary.WepFireSeq = "2hrattack3"
SWEP.Primary.WepRSeq = "2hrreloada"
SWEP.ReloadTime = 2.2
SWEP.ReloadSound = "wep/huntingrifle/reload.mp3"
-------------------------------------------------
--------------------------------------------------------------------------------
