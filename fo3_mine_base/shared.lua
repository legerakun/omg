SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "1mdaim"
SWEP.HolsterAnim = "1mdunequip"
SWEP.WeaponModel = "models/fallout/weapons/c_minefrag.mdl"
SWEP.MineModel = "models/fallout/weapons/w_minefrag.mdl"
SWEP.OriginPos = Vector(-2,0,-2)
SWEP.OriginAng = Angle(0,3,0)
SWEP.WepPos = Vector(7,0,1.5)
SWEP.WepAng = Angle(180,-56,90)

SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"1mdplacemine"}
SWEP.ShootSound = {"wep/explode/fx_explosion_grenade01.wav"}
SWEP.MaximumShots = 500
-------------------------------------------------
--SWEP.TracerType = "effect_fo3_blasterbeam"
SWEP.CriticalColor = Color(255,255,255)
SWEP.CriticalChance = 32
SWEP.Primary.Recoil = 2
SWEP.Primary.Delay = 2
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 0

SWEP.UseCustomMuzzleFlash               = false
SWEP.ShootVolume = 0
-------------------------------------------------
SWEP.HoldType = "slam"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Frag Mine"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 70
//----------------------------------------------
SWEP.Primary.ClipSize = 0
SWEP.Primary.Bullets = 0
SWEP.Primary.Cone = 0
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 0
SWEP.MineIndex = "Frag Mine"
-------------------------------------------------
--------------------------------------------------------------------------------

function SWEP:Reload()
return false
end

function SWEP:CSShootBullet( dmg, recoil, numbul, cone )
  if CLIENT then
    self:PlayViewModelAnim(table.Random(self.AttackAnims))
  end
self.Owner:SetAnimation( PLAYER_ATTACK1 )
--
  if SERVER then
  local mine = ents.Create("fo_mine")
  mine.Placer = self.Owner
  if self.MineDamage then
    mine:SetDmg(self.MineDamage)
  end
  local pos = self.Owner:GetPos()
  local ang = self.Owner:GetAngles()
  mine:SetPos(pos+ang:Forward()*20+ang:Up()*40)
  mine:SetAngles(ang)
  mine:Spawn()
  mine:SetModel(self.MineModel)
  mine:SetVelocity(ang:Forward()*110)
  
  --TAKE MINE
	local owner = self.Owner
	local gindex = self.MineIndex
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
  --
  end
end

