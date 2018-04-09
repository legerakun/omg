SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1hpequipb"
SWEP.HolsterAnim = "1hpunequipb"
SWEP.EnergyWep = true
SWEP.WeaponModel = "models/fallout/weapons/w_alienblaster.mdl"
SWEP.WepPos = Vector(4.4,-1.75,1.1)
SWEP.WepAng = Angle(-75,-90,0)

SWEP.ViewModelFOV = 64
SWEP.OriginPos = Vector(0.5,0,-0.75)

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

SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"1hpattack7"}
SWEP.ReloadAnims = {"1hpreloadj"}
SWEP.ShootSound = {"wep/alienblaster/alienblaster_fire_2d.wav"}
SWEP.MaximumShots = 100
-------------------------------------------------
SWEP.TracerType = "effect_fo3_blasterbeam"
SWEP.AimHoldType = "duel"
SWEP.CriticalColor = Color(50,179,255,255)
SWEP.CriticalChance = 120
SWEP.Primary.Recoil = 0.85
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 0
-------------------------------------------------
SWEP.HoldType = "pistol"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Alien Blaster"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 68
//----------------------------------------------
SWEP.Primary.ClipSize = 10
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.InvAmmo = "fo3_ammo_apcell"
SWEP.Primary.Damage = 36
SWEP.ReloadTime = 2.4
SWEP.ReloadSound = "wep/alienblaster/alienblaster_reload.wav"
-------------------------------------------------
--------------------------------------------------------------------------------