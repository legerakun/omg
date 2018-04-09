SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1gtaim"
SWEP.HolsterAnim = "1gtunequip"
SWEP.WeaponModel = "models/fallout/weapons/w_grenadefrag.mdl"
SWEP.MineModel = "models/fallout/weapons/w_minefrag.mdl"
SWEP.WepPos = Vector(7,0,1.5)
SWEP.WepAng = Angle(180,-56,90)

SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {}
SWEP.ShootSound = {"wep/throw_gren_2.mp3"}
SWEP.MaximumShots = 500

SWEP.HolsterBone = "Bip01 R Thigh"
SWEP.HolsterPos = Vector(2,0,5)
SWEP.HolsterAng = Angle(-90,0,0)
-------------------------------------------------
--SWEP.TracerType = "effect_fo3_blasterbeam"
SWEP.CriticalColor = Color(255,255,255)
SWEP.CriticalChance = 32
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 2
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 0

SWEP.UseCustomMuzzleFlash               = false
SWEP.ShootVolume = 1
-------------------------------------------------
SWEP.HoldType = "grenade"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Frag Grenade"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 70
//----------------------------------------------
SWEP.GrenadeIndex = "Frag Grenade"
SWEP.Primary.PinTime = 0.62

SWEP.Primary.ClipSize = 0
SWEP.Primary.Bullets = 0
SWEP.Primary.Cone = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 0
-------------------------------------------------
--------------------------------------------------------------------------------
function SWEP:Holster()
  if CLIENT then
    self:RemoveWeapon()
  end
  if CLIENT then
    self:RemoveHands()
	--
    local vm = self.Owner:GetViewModel()
    if !IsValid(vm) then return true end
    vm:SetColor(Color(255,255,255,255))
    vm:SetMaterial("")
  end
return true
end

function SWEP:Reload()
return false
end

function SWEP:CSShootBullet( dmg, recoil, numbul, cone )
  if CLIENT then
    self:PlayViewModelAnim("1gtattackthrow")
  end
self.Owner:SetAnimation( PLAYER_ATTACK1 )
--
  timer.Simple(self.Primary.PinTime, function()
    if !self or !self.ThrowGrenade then return end
	self:ThrowGrenade()
  end)
end

function SWEP:ThrowGrenade()

  if SERVER then
    local grenade = ents.Create("fo_grenade")
	grenade:Spawn()
    grenade.Placer = self.Owner
    grenade:SetModel(self.WeaponModel)
    local pos = self.Owner:GetPos()
    local ang = self.Owner:EyeAngles()
    grenade:SetPos(pos+ang:Forward()*20+ang:Up()*40)
    grenade:SetAngles(ang)
		  local phys = grenade:GetPhysicsObject()
		  if(phys:IsValid()) then
			phys:ApplyForceCenter(self.Owner:GetAimVector() * 600 + ang:Up()*300)
		  end
	--
	timer.Simple(0.7, function()
	if !self or !IsValid(self.Weapon) then return end
	local owner = self.Owner
	local gindex = self.GrenadeIndex
	timer.Simple(0.1, function()
	  if IsValid(owner) then
	    if owner.Inventory[gindex] then
	      owner:UseItem(gindex)
		elseif owner.Inventory["Fists"] then
		  owner:UseItem("Fists")
		end
	  end
	end)
	owner:StripWeapon(self.Weapon:GetClass())
	end)
  end
  
end
