SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2hrequip"
SWEP.HolsterAnim = "2hrunequip"
SWEP.Attachment = 0
SWEP.AimHoldType = "physgun"
SWEP.WeaponModel = "models/fallout/weapons/w_sniperrifle.mdl"
SWEP.OriginPos = Vector(0,0,-1.5)
SWEP.OriginAng = Angle(2,0,0)
SWEP.WepPos = Vector(7.8, -2, 3)
SWEP.WepAng = Angle(0,-60,90)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"d_2hrattack8"}
SWEP.ReloadAnims = {"2hrreloadm"}
SWEP.ShootSound = {"wep/sniperrifle/wpn_riflesniper_fire_2d.mp3"}
SWEP.ShootVolume = 1
SWEP.MaximumShots = 1200
SWEP.ZoomFOV = 35

SWEP.IronVec = Vector(-2.6,0, -5)
SWEP.IronAng = Angle(-10,-2.5,0)
SWEP.IronSightTime = 0.4

SWEP.HolsterBone = "Bip01 Spine2"
SWEP.HolsterPos = Vector(-7, 7, -1)
SWEP.HolsterAng = Angle(0,-115,90)

SWEP.HolsterAnimAct = ACT_DOD_PRONE_AIM_C96
SWEP.UnHolsterAnimAct = ACT_GESTURE_RANGE_ATTACK_HMG1
-------------------------------------------------
SWEP.CriticalChance = 45
SWEP.Primary.Recoil = 15
SWEP.Primary.RecoilTime = 0.37
SWEP.Primary.RecoilDown = true
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 4

SWEP.UseCustomMuzzleFlash               = true
SWEP.MuzzleEffect                       = "effect_fo3_gunsmoke"
SWEP.MuzzleAttachment                   = "1"
-------------------------------------------------
SWEP.HoldType = "shotgun"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Sniper Rifle"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 63
//----------------------------------------------
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 24
SWEP.Primary.InvAmmo = "fo3_ammo_308"
SWEP.Primary.Cone = 0.02
SWEP.Primary.Delay = 1.3
SWEP.ReloadTime = 1.7
SWEP.ReloadSound = "wep/sniperrifle/reloading.mp3"
-------------------------------------------------
--------------------------------------------------------------------------------

function SWEP:SetNewCone(cone, iron)
  if !iron or self.IronCurTime+0.5 > CurTime() then
    return 0.15
  end
end

if CLIENT then

function SWEP:OnSightToggled(iron)
  if iron then
    if self.Owner.ThirdPersonActive then
	  self.Owner.ThirdPersonActive = false
	  self.TP_Old = true
	end
  end
--
  if !iron then
    if self.TP_Old then
	  self.Owner.ThirdPersonActive = true
	  self.TP_Old = false
	end
  end
end

function SWEP:ShouldDrawWep()
local iron = self:GetIronSights()
if iron then return false end
end

function SWEP:DrawHUD()
local iron = self:GetIronSights()
  if !iron then
    if FalloutHUDHide then
	  FalloutHUDHide = false
	end
    return 
  end
  if !FalloutHUDHide then
    FalloutHUDHide = true
  end
local scope = Material("pw_fallout/scope.png")
local sw = ScrH()
local so = ScrW()/2 - (sw/2)
--
draw.RoundedBox(0,0,0,so,ScrH(),Color(0,0,0))
draw.RoundedBox(0,ScrW() - so,0,so,ScrH(),Color(0,0,0))
surface.SetDrawColor(255,255,255)
surface.SetMaterial(scope)
surface.DrawTexturedRect(ScrW()/2 - (sw/2), ScrH()/2 - (sw/2), sw, sw)
--
surface.SetDrawColor(0,0,0)
surface.DrawLine(ScrW()/2, 0, ScrW()/2, ScrH())
surface.DrawLine(0, ScrH()/2, ScrW(), ScrH()/2)
end

end