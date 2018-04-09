SWEP.Base = "fo3_pda"
----------------------------------
SWEP.Author             = "extra.game"
SWEP.Contact            = "extra.game on Steam"
SWEP.Purpose            = "Self Defence"
SWEP.Instructions       = "Left Click: Shoot\nRight Click: Watchsights"
//----------------------------------------------
--CONFIGS--
SWEP.PipOn = true
SWEP.PrintName = "PipBoy 3000"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "Fallout 3"
SWEP.ViewModelFOV = 90

SWEP.WeaponModel = "models/llama/pipboy3000.mdl"
SWEP.WepPos = Vector(0,3.3,-0.45)
SWEP.WepAng = Angle(5,-45,3.5)

SWEP.LookAnim = "menu_pipboy_in"
SWEP.DownAnim = "menu_pipboy_out"
SWEP.Scale = 0.00495
SWEP.Wide = 990
SWEP.Tall = 730
--
SWEP.OriginPos = Vector(-2, 1,-0.25)
SWEP.OriginAng = Angle(8,-9.45,2.9)
SWEP.NonShake = true
SWEP.NonAttachment = true
SWEP.BoneName = "Bip01 L Hand"
SWEP.BonePos = Vector(-12, 3.55, 0.65)
SWEP.BoneAng = Angle(-75.75,-52,-8.6)

if CLIENT then

local function pipMenu(wep,self,tpos,tang)
  local target_pos = nil
  local fix_angles = nil
  if IsValid(wep) then
    target_pos = tpos or wep:GetPos()
    fix_angles = tang or wep:GetAngles()
	--
	target_pos = target_pos + fix_angles:Right()*-1.6 + fix_angles:Forward()*-1.2 + fix_angles:Up()*1.35
	--
    local fix_rotation = Vector(-3,86.625,4)
    fix_angles:RotateAroundAxis(fix_angles:Right(), fix_rotation.x)
    fix_angles:RotateAroundAxis(fix_angles:Up(), fix_rotation.y)
    fix_angles:RotateAroundAxis(fix_angles:Forward(), fix_rotation.z)-- 2.2
    target_pos = target_pos-fix_angles:Right() * 2+fix_angles:Up()*2+fix_angles:Forward()*5
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

end

