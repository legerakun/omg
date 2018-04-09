SWEP.Base = "fo3_m_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2hmequip"
SWEP.HolsterAnim = "2hmunequip"

SWEP.ShellEffect = "none"
SWEP.ShellEjectAttachment	= "2"
SWEP.AttackAnims = {"2hmattackleft_a","2hmattackright_a"}
SWEP.WeaponModel = "models/fallout/weapons/c_dresscane.mdl"
SWEP.WepPos = Vector(4.15,-1.35,0)
SWEP.WepAng = Angle(0,-105,0)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.ShootVolume = 0.35

SWEP.HolsterBone = "Bip01 Spine2"
SWEP.HolsterPos = Vector(18, 7, -6)
SWEP.HolsterAng = Angle(0,-25,90)

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
SWEP.PrintName = "Pickaxe"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 72
//----------------------------------------------
SWEP.MaximumShots = 100
SWEP.Primary.Damage = 2
SWEP.Primary.Delay = 0.85
-------------------------------------------------
--------------------------------------------------------------------------------