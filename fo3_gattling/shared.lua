SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.AimHoldType = "crossbow"
SWEP.EquipAnim = "2hhequip"
SWEP.HolsterAnim = "2hhunequip"
SWEP.EnergyWep = true
SWEP.WeaponModel = "models/fallout/weapons/c_l30_gattlinglaser.mdl"
SWEP.OriginAng = Angle(0,-15,0)
SWEP.OriginPos = Vector(-2, 3, 0.5)
SWEP.WepPos = Vector(-8,3,-15)
SWEP.WepAng = Angle(-100,-170,-15.5)
SWEP.WeaponBone = "Bip01 L Hand"
SWEP.AttackAnims = {"2hhattackleft"}
SWEP.ReloadAnims = {"2hhreloadc"}
SWEP.ShootSound = {"wep/gatling/fire.wav"}
SWEP.ShootVolume = 1
SWEP.MaximumShots = 600

-------------------------------------------------
SWEP.TracerType = "effect_fo3_lasers"
SWEP.CriticalMat = "effects/laserblast"
SWEP.CriticalColor = Color(234,10,15)
SWEP.CriticalChance = 45
SWEP.Primary.Cone = 0.045
SWEP.Primary.Recoil = 1
SWEP.Primary.Delay = 0.1
SWEP.CriticalMulti = 3
SWEP.CriticalCoolDown = 8

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "fo3_muzzle_laserrifle"
SWEP.MuzzleAttachment                   = "1"
SWEP.EnergyEffect = "effect_fo3_laserhit"
-------------------------------------------------
SWEP.HoldType = "crossbow"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Gatling Laser"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_physcannon.mdl"
SWEP.WorldModel = "models/weapons/w_physcannon.mdl"
SWEP.ViewModelFOV = 60
//----------------------------------------------
SWEP.Primary.ClipSize = 240
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.InvAmmo = "fo3_ammo_ecpack"
SWEP.Primary.Damage = 5.75
SWEP.Primary.WepRSeq = "2hhreloade"
SWEP.ReloadSound = "wep/gatlinglaser/gatlinglaser_reload.wav"
SWEP.ReloadTime = 2.9
-------------------------------------------------
--------------------------------------------------------------------------------