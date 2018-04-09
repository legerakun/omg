SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.AimHoldType = "rpg"
SWEP.EquipAnim = "2hlequip"
SWEP.HolsterAct = "rpg"
SWEP.HolsterAnim = "2hlunequip"
SWEP.EnergyWep = true
SWEP.WeaponModel = "models/fallout/weapons/w_teslacannonproto.mdl"
SWEP.WepPos = Vector(5,-1,1)
SWEP.WepAng = Angle(0,-95,90)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"2hlattack3"}
SWEP.ReloadAnims = {"2hlreloadb"}
SWEP.ShootSound = {"wep/teslacannon/teslacannon_fire_2d01.wav","wep/teslacannon/teslacannon_fire_2d02.wav"}
SWEP.ShootVolume = 0.75
SWEP.MaximumShots = 1000

-------------------------------------------------
SWEP.TracerType = "effect_fo3_tesla"
SWEP.CriticalMat = "effects/alienblast"
SWEP.CriticalColor = Color(234,10,15)
SWEP.CriticalChance = 45
SWEP.Primary.Recoil = 1
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 4

SWEP.UseCustomMuzzleFlash               = false
SWEP.MuzzleEffect                       = "fo3_muzzle_plasmarifle"
SWEP.MuzzleAttachment                   = "1"
SWEP.EnergyEffect = "effect_fo3_teslahit"
-------------------------------------------------
SWEP.HoldType = "rpg"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Tesla Cannon Prototype"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 60
//----------------------------------------------
SWEP.Primary.ClipSize = 24
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = .65
SWEP.Primary.Ammo = "none"
SWEP.Primary.AmmoTake = 6
SWEP.Primary.Damage = 20
SWEP.Primary.InvAmmo = "fo3_ammo_ecpack"
SWEP.Primary.Cone = 0.02
SWEP.ReloadTime = 2.65
SWEP.ReloadSound = "wep/teslacannon/reload.mp3"
-------------------------------------------------
--------------------------------------------------------------------------------