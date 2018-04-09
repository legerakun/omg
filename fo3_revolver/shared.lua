SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1hpequipb"
SWEP.HolsterAnim = "1hpunequip"
SWEP.WeaponModel = "models/fallout/weapons/w_44magnumrevolvernoscope.mdl"
SWEP.WepPos = Vector(4.75,-1.65,1.25)
SWEP.WepAng = Angle(-80,-90,0)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"1hpattack7"}
SWEP.ReloadAnims = {"1hpreloade"}
SWEP.ShootSound = {"wep/44magnum/pistol_44magnum_fire_2d.wav"}
SWEP.MaximumShots = 500
-------------------------------------------------
--SWEP.TracerType = "effect_fo3_blasterbeam"
SWEP.CriticalColor = Color(255,255,255)
SWEP.CriticalChance = 5
SWEP.Primary.Recoil = 11.5
SWEP.Primary.RecoilDown = true
SWEP.Primary.Delay = 0.45
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 3
SWEP.ShootVolume = 1

SWEP.HolsterBone = "Bip01 R Thigh"
SWEP.HolsterPos = Vector(2,0,5)
SWEP.HolsterAng = Angle(-90,0,0)
SWEP.HolsterAnimAct = ACT_GESTURE_MELEE_ATTACK2
SWEP.UnHolsterAnimAct = ACT_VM_DEPLOYED_IN

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
-------------------------------------------------
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = ".44 Magnum Revolver"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 62
//----------------------------------------------
SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 9.8
SWEP.Primary.InvAmmo = "fo3_ammo_44"
SWEP.ReloadTime = 2.95
SWEP.ReloadSound = "wep/44magnum/pistol44magnum_reload.wav"
-------------------------------------------------
--------------------------------------------------------------------------------