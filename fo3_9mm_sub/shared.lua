SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1hpequip"
SWEP.HolsterAnim = "1hpunequip"
SWEP.WeaponModel = "models/fallout/weapons/c_9mm_smg.mdl"
SWEP.WepPos = Vector(4.75,-1.65,1.25)
SWEP.WepAng = Angle(-80,-90,0)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"1hpattack4"}
SWEP.ReloadAnims = {"1hpreloadf"}
SWEP.ReloadPostAnim = "1hpaim"
SWEP.ShootSound = {"wep/9mmsmg/9mm_fire_2d01.mp3","wep/9mmsmg/9mm_fire_2d02.mp3","wep/9mmsmg/9mm_fire_2d03.mp3","wep/9mmsmg/9mm_fire_2d04.mp3"}
SWEP.MaximumShots = 850

SWEP.IronVec = Vector(-2.55, -0.1, 0.25)
SWEP.IronAng = Angle(0,0,0)
SWEP.IronSightTime = 0.35

SWEP.HolsterBone = "Bip01 R Thigh"
SWEP.HolsterPos = Vector(2,0,5)
SWEP.HolsterAng = Angle(-90,0,0)

SWEP.HolsterAnimAct = ACT_GESTURE_MELEE_ATTACK2
SWEP.UnHolsterAnimAct = ACT_VM_DEPLOYED_IN
-------------------------------------------------
--SWEP.TracerType = "effect_fo3_blasterbeam"
SWEP.CriticalColor = Color(255,255,255)
SWEP.CriticalChance = 5
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Delay = 0.157
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 3
SWEP.ShootVolume = 0.7

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
-------------------------------------------------
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "9mm Sub-Machine Gun"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 62
//----------------------------------------------
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 4.75
SWEP.Primary.InvAmmo = "fo3_ammo_9mm"
SWEP.Primary.Cone = 0.055
SWEP.Primary.WepRSeq = "1hpreloadn"
SWEP.ReloadTime = 2.8
SWEP.ReloadSound = "wep/10mmsmg/riflesmg_reload.wav"
-------------------------------------------------
--------------------------------------------------------------------------------