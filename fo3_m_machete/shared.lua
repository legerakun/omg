SWEP.Base = "fo3_m_bumper"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1hmequip"
SWEP.HolsterAnim = "1hmunequip"

SWEP.ShellEffect = "none"
SWEP.ShellEjectAttachment	= "2"
SWEP.AttackAnims = {"1hmattackleft_a","1hmattackright_a"}
SWEP.WeaponModel = "models/fallout/weapons/c_wakizashi.mdl"
SWEP.WepPos = Vector(4.15,-1.35,0)
SWEP.WepAng = Angle(0,-105,0)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.ShootVolume = 0.8

SWEP.FleshSound = {"wep/knife/fx_melee_knife_flesh01.wav", "wep/knife/fx_melee_knife_flesh02.wav", "wep/knife/fx_melee_knife_flesh03.wav"}
SWEP.ShootSound = {"wep/melee/swing/fx_swing_small01.wav", "wep/melee/swing/fx_swing_small02.wav", "wep/melee/swing/fx_swing_small03.wav"}

SWEP.HolsterBone = "Bip01 L Thigh"
SWEP.HolsterPos = Vector(2,0,-4.35)
SWEP.HolsterAng = Angle(180,0,0)

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
SWEP.HolsterAnimAct = ACT_GESTURE_RANGE_ATTACK2_LOW
SWEP.UnHolsterAnimAct = ACT_GESTURE_RANGE_ATTACK1_LOW
-------------------------------------------------
-------------------------------------------------
SWEP.HoldType = "melee"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Machete"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 72
//----------------------------------------------
SWEP.MaximumShots = 120
SWEP.Primary.Damage = 8
SWEP.Primary.Delay = 0.44

SWEP.Primary.PowerAttack = "1hmattackforwardpower"
SWEP.PowerSeq = "1hmattackpower"
-------------------------------------------------
--------------------------------------------------------------------------------