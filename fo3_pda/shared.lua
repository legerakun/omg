SWEP.Base = "fo3_base"
----------------------------------
SWEP.Author             = "extra.game"
SWEP.Contact            = "extra.game on Steam"
SWEP.Purpose            = "Self Defence"
SWEP.Instructions       = "Left Click: Shoot\nRight Click: Watchsights"
//----------------------------------------------
--CONFIGS--
if SERVER then
  util.AddNetworkString("F_PSync")
  util.AddNetworkString("PipOpen")  
end

SWEP.WeaponModel = "models/fallout/interface/pipboy2500.mdl"
SWEP.WepPos = Vector(0,3.3,-0.45)
SWEP.WepAng = Angle(5,-45,3.5)

SWEP.LookAnim = "menu_pda_in"
SWEP.DownAnim = "menu_pda_out"
SWEP.Scale = 0.0049
SWEP.Wide = 970
SWEP.Tall = 710
--
SWEP.OriginPos = Vector(-0.65,-4,2)
SWEP.OriginAng = Angle(-4,-1,0)
SWEP.NonShake = true
SWEP.NonAttachment = true
SWEP.BoneName = "Bip01 L Hand"
SWEP.BonePos = Vector(-9, 3.5, 0.65)
SWEP.BoneAng = Angle(-75,-80,-3)

SWEP.Primary.ClipSize = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Damage = 0
SWEP.Primary.Ammo = "none"
SWEP.PrintName = "PDA"
SWEP.ViewModelFOV = 90
SWEP.ViewModelFlip = false
SWEP.IronSightTime = 0.25
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "Fallout 3"
SWEP.BobScale = 0.5
SWEP.SwayScale = 0
SWEP.HoldType = "normal"
SWEP.Secondary.Ammo = "none"
----------------------------------

function SWEP:OnDeploy()
  if SERVER then
    self.Owner:SetFOV(0, 0.1)
    if self:GetDown() then return end
	local owner = self.Owner
	timer.Simple(0.125, function()
	  if !IsValid(owner) or !self or !self.Weapon then return end
      net.Start("PipOpen")
	  net.Send(owner)
	  self:WatchUp()
	end)
  end
end

function SWEP:WatchUp()
if self.UnableUse then return end
  if CLIENT then
    --CLIENT FOV
	local fov = LocalPlayer():GetFOV()
    self.ViewModelFOV = fov
    -------------------------
    self.WasTP = LocalPlayer().ThirdPersonActive
	LocalPlayer().ThirdPersonActive = false
    FalloutHUDHide = true
	local vm = self.Owner.VMHands.Sleeves
	if self.PipOn then
	  local pipon = vm:FindBodygroupByName("pipboyon")
	  vm:SetBodygroup(pipon, 1)
	end
	if self:Get2D() then
	  local width = ScrW()*.54
	  local height = ScrH()*.75
	  PipBoy3000.Build(0,width,height)
	else
	  PipBoy3000.Build3D(self.Wide,self.Tall)
	end
  end
  if SERVER then
    self:SetNWBool("IsDown",true)
  end
  if CLIENT and !self:Get2D() then
    self:PlayViewModelAnim(self.LookAnim)
  end
end

function SWEP:WatchDown()
  if CLIENT then
    FalloutHUDHide = false
	  if IsValid(PipBoy3000.Base) then
	    PipBoy3000.Base:Remove()
	  end
	  local vm = self.Owner.VMHands.Sleeves
	  if self.PipOn then
	    local pipon = vm:FindBodygroupByName("pipboyon")
	    vm:SetBodygroup(pipon, 1)
	  end
  end
  self.UnableUse = true
  	timer.Simple(0.1,function()
	    if IsValid(self) then
		  self.UnableUse = false
		end
	  if CLIENT then
	    if !IsValid(self) or LocalPlayer():GetActiveWeapon() != self then return end
		  if self.WepIndex then
	        UseItem(self.WepIndex)
		  else
		    UseItem("Fists")
		  end
	  end
	end)
--
  if SERVER then
    self:SetNWBool("IsDown",false)
  end
  if CLIENT and !self:Get2D() then
    self:PlayViewModelAnim(self.DownAnim, function(vm, seq)
	  if !self.WasTP then return end
	  local time = vm:SequenceDuration(seq)
	  local wastp = self.WasTP
	  timer.Simple(time/2, function()
	    if !self or self.GetDown and self:GetDown() then return end
		LocalPlayer().ThirdPersonActive = wastp
	  end)
	end)
  end
end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()
self.Weapon:SetNextPrimaryFire(CurTime()+1)
self.Weapon:SetNextSecondaryFire(CurTime()+1)
self:WatchUp()
end

function SWEP:GetDown()
return self:GetNWBool("IsDown",false)
end

function SWEP:SecondaryAttack()
  self:WatchDown()
end

if CLIENT then

function SWEP:Get2D()
  return false
end

function SWEP:DrawWorldModel() return end

local function pipMenu(wep,self,tpos,tang)
  local target_pos = nil
  local fix_angles = nil
  if IsValid(wep) then
    target_pos = tpos or wep:GetPos()
    fix_angles = tang or wep:GetAngles()
	--
	target_pos = target_pos + fix_angles:Right()*-11 + fix_angles:Forward()*.55 + fix_angles:Up()*-0.1
	--
    local fix_rotation = Vector(-8.5,91.85,180)
    fix_angles:RotateAroundAxis(fix_angles:Right(), fix_rotation.x)
    fix_angles:RotateAroundAxis(fix_angles:Up(), fix_rotation.y)
    fix_angles:RotateAroundAxis(fix_angles:Forward(), fix_rotation.z)-- 2.2
    target_pos = target_pos-fix_angles:Right() * 2.38+fix_angles:Up()*2.215+fix_angles:Forward()*4.7
  end
  --
  local width = self.Wide
  local height = self.Tall
  vgui.Start3D2D( target_pos, fix_angles, self.Scale )
	  if !IsValid(PipBoy3000.Base) then
        vgui.End3D2D()
	  return end
	local frame = PipBoy3000.Base
	frame:Paint3D2D()
	--DrawBloom( number Darken, number Multiply, number SizeX, number SizeY, number Passes, number ColorMultiply, number Red, number Green, number Blue )
  vgui.End3D2D()
end

function SWEP:WepDrawn(wep, pos, ang, attachment)
  if !IsValid(PipBoy3000.Base) or self:Get2D() then return end
  pipMenu(wep,self)
end

net.Receive("PipOpen", function()
local wep = LocalPlayer():GetActiveWeapon()
print("here")--or !wep.Wide
if !IsValid(wep) or !wep.WatchUp then return end
wep:WatchUp()
end)

hook.Add("RenderScreenspaceEffects", "FPipBoyGlow", function()
if !IsValid(PipBoy3000.Base) then return end
DrawBloom( 0.45, 1.5, 11, 10, 3, 1, 1, 1, 1 )
end)

end
