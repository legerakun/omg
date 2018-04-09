SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2hrequip"
SWEP.HolsterAnim = "2hrunequip"
SWEP.Attachment = 0
SWEP.AimHoldType = "physgun"--"knife"
SWEP.WeaponModel = "models/fallout/weapons/c_cowboyrepeater.mdl"
SWEP.OriginPos = Vector(0,0, -.5)
SWEP.OriginAng = Angle(2,0,0)
SWEP.WepPos = Vector(-2.25, 0.5, 10)
SWEP.WepAng = Angle(-95, 0,-62)
SWEP.WeaponBone = "Bip01 L Hand"
SWEP.AttackAnims = {"d_2hrattack5"}
SWEP.ReloadAnims = {"2hrreloadz"}
--Bolt
SWEP.BoltAnimTime = 0.46
SWEP.BoltEndAnim = nil
SWEP.BoltStartAnim = "2hrreloadzstart"
SWEP.ReloadTimePBolt = 0.65
---
SWEP.ReloadRate = 1.18
SWEP.ShootSound = {"wep/cowboy/wpn_cowrepeat_fire_2d_01.mp3","wep/cowboy/wpn_cowrepeat_fire_2d_02.mp3","wep/cowboy/wpn_cowrepeat_fire_2d_03.mp3","wep/cowboy/wpn_cowrepeat_fire_2d_04.mp3"}
SWEP.ShootVolume = 1
SWEP.MaximumShots = 1200

SWEP.IronVec = Vector(-4.525,-5,4.45)
SWEP.IronAng = Angle(-3.25,-3.2,0)

SWEP.HolsterBone = "Bip01 Spine2"
SWEP.HolsterPos = Vector(-8, 7, 2)
SWEP.HolsterAng = Angle(0,-115,90)

SWEP.HolsterAnimAct = ACT_DOD_PRONE_AIM_C96
SWEP.UnHolsterAnimAct = ACT_GESTURE_RANGE_ATTACK_HMG1
-------------------------------------------------
SWEP.CriticalChance = 45
SWEP.Primary.Recoil = 12
SWEP.Primary.RecoilTime = 0.28
SWEP.Primary.RecoilDown = true
SWEP.Primary.Delay = 0.65
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 4

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
-------------------------------------------------
SWEP.HoldType = "shotgun"--"revolver"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Cowboy Repeater"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 65
//----------------------------------------------
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 12
SWEP.Primary.InvAmmo = "fo3_ammo_308"
SWEP.Primary.WepFireSeq = "2hrattack5"
-------------------------------------------------
--------------------------------------------------------------------------------

function SWEP:ReloadSound(bolts, time_bolt)
time_bolt = time_bolt*.775
local timername = "FWepBolt:"..self.Owner:SteamID64()
  timer.Create(timername, time_bolt, bolts, function()
  	local soundname = "wep/cowboy/wpn_cowboyreload_0"..math.random(1,6)..".mp3"
    self.Owner:EmitSound(soundname)
  end)
  timer.Simple(time_bolt * (bolts+0.6), function()
    if !IsValid(self) or !self.Weapon then return end
	local endbolt = "wep/cowboy/wpn_cowboyreload_end.mp3"
	self.Owner:EmitSound(endbolt)
  end)
end