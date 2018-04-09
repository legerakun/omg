SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2haequip"
SWEP.HolsterAnim = "2haunequip"
SWEP.WeaponModel = "models/fallout/weapons/c_10mm_carbine.mdl"
SWEP.WepPos = Vector(4.75,-1.65,1.25)
SWEP.WepAng = Angle(-80,-90,0)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"2haattack3"}
SWEP.ReloadAnims = {"2hareloadk"}
SWEP.ReloadPostAnim = "2haaim"
SWEP.ShootSound = {"wep/10mm/10mmfire_2d_02.mp3","wep/10mm/10mmfire_2d_03.mp3"}
SWEP.MaximumShots = 850

SWEP.IronVec = Vector(-3.175, 3, 1.95)
SWEP.IronAng = Angle(-1, 2.55, 0)
SWEP.HolsterAnimAct = ACT_GESTURE_MELEE_ATTACK2
SWEP.UnHolsterAnimAct = ACT_VM_DEPLOYED_IN

SWEP.IronSightTime = 0.35

SWEP.HolsterBone = "Bip01 R Thigh"
SWEP.HolsterPos = Vector(2,0,5)
SWEP.HolsterAng = Angle(-90,0,0)
-------------------------------------------------
--SWEP.TracerType = "effect_fo3_blasterbeam"
SWEP.CriticalColor = Color(255,255,255)
SWEP.CriticalChance = 5
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Delay = 0.15
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 3
SWEP.ShootVolume = 1

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
-------------------------------------------------
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "10mm Carbine"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_irifle.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 62
//----------------------------------------------
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.InvAmmo = "fo3_ammo_10mm"
SWEP.Primary.Damage = 6
SWEP.Primary.Cone = 0.045
SWEP.Primary.WepRSeq = "2hareloadk"
SWEP.ReloadTime = 2.45
SWEP.ReloadSound = "wep/assaultrifle/reloading.mp3"
-------------------------------------------------
--------------------------------------------------------------------------------