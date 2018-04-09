SWEP.Base = "fo3_m_bumper"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2hmequip"
SWEP.HolsterAnim = "2hmunequip"

SWEP.ShellEffect = "none"
SWEP.ShellEjectAttachment	= "2"
SWEP.AttackAnims = {"2hmattackleft_a","2hmattackright_a"}
SWEP.WeaponModel = "models/fallout/weapons/w_supersledge.mdl"
SWEP.WepPos = Vector(4.15,-1.35,0)
SWEP.WepAng = Angle(0,-105,0)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.ShootVolume = 0.35

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
SWEP.HolsterAnimAct = ACT_SLAM_STICKWALL_TO_THROW_ND
SWEP.UnHolsterAnimAct = ACT_SLAM_STICKWALL_TO_THROW
-------------------------------------------------
-------------------------------------------------
SWEP.HoldType = "melee2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Super Sledgehammer"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 72
//----------------------------------------------
SWEP.Primary.Damage = 9
SWEP.Primary.Delay = 1
-------------------------------------------------
--------------------------------------------------------------------------------