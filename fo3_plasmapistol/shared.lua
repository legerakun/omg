SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1hpequipb"
SWEP.HolsterAnim = "1hpunequipb"
SWEP.EnergyWep = true
SWEP.WeaponModel = "models/fallout/weapons/w_plasmapistol.mdl"
SWEP.WepPos = Vector(4.4,-1.75,1.1)
SWEP.WepAng = Angle(-75,-90,0)

SWEP.IronVec = Vector(-2.2, 5, -2.1)
SWEP.IronAng = Angle(5, 2.75, 0)
SWEP.IronSightTime = 0.35

SWEP.ViewModelFOV = 64
SWEP.OriginPos = Vector(0.5,0,-0.75)

SWEP.HolsterBone = "Bip01 R Thigh"
SWEP.HolsterPos = Vector(2,0,5)
SWEP.HolsterAng = Angle(-90,0,0)
SWEP.HolsterAnimAct = ACT_GESTURE_MELEE_ATTACK2
SWEP.UnHolsterAnimAct = ACT_VM_DEPLOYED_IN

SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"1hpattack7"}
SWEP.ReloadAnims = {"1hpreloadc"}
SWEP.ReloadPostAnim = "1hphandgrip6_OneHanded"
SWEP.ShootSound = {"wep/plasmapistol/pistolplasma_fire_2d.wav"}
SWEP.MaximumShots = 600
-------------------------------------------------
SWEP.TracerType = "effect_fo3_plasma"
SWEP.AimHoldType = "duel"
SWEP.CriticalColor = Color(0,179,60,255)
SWEP.CriticalChance = 10
SWEP.Primary.Recoil = 0.85
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 0

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "fo3_muzzle_plasmarifle"
SWEP.MuzzleAttachment                   = "1"
SWEP.EnergyEffect = ""
-------------------------------------------------
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Plasma Pistol"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
//----------------------------------------------
SWEP.Primary.ClipSize = 32
SWEP.Primary.DefaultClip = 0
SWEP.Primary.InvAmmo = "fo3_ammo_ecell"
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 8
SWEP.Primary.Delay = 0.4
SWEP.ReloadTime = 2.64
SWEP.ReloadSound = "wep/plasmapistol/pistolplasma_reload.wav"
-------------------------------------------------
--------------------------------------------------------------------------------