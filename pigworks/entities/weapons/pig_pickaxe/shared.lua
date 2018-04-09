
if ( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "weapon_base"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true
SWEP.Category           = "PigWorks"
SWEP.PrintName          = "PickAxe"
SWEP.DrawCrosshair      = false
SWEP.ViewModelFOV = 46
SWEP.Instructions  = "Left Click = Mine\nRight Click = Place Block"
SWEP.Author = "extra.game"
SWEP.ViewModelFlip = false
SWEP.Weight					= 1			 
SWEP.AutoSwitchTo			= true		 
SWEP.AutoSwitchFrom			= false	
SWEP.CSMuzzleFlashes		= false	  	 		 	 						 			  
SWEP.Primary.ClipSize		= -1				  
SWEP.Primary.DefaultClip	= 1		 
SWEP.Primary.Automatic		= true
SWEP.Primary.Delay          = 0.5 
SWEP.Primary.Ammo			= "none"	 
SWEP.Secondary.ClipSize		= -1			
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Damage		= 0		 
SWEP.Secondary.Automatic	= false		 
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()

	self:SetWeaponHoldType( "fist" )
	if CLIENT then
	self:CreatePreview()
	end
end

SWEP.MissSound 				= Sound("weapons/knife/knife_slash1.wav")
SWEP.WallSound 				= Sound("weapons/melee/crowbar/crowbar_hit-1.wav")
SWEP.WorldModel             = ""
SWEP.ViewModel              = "models/weapons/v_swipe.mdl"

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/

function SWEP:PrimaryAttack()

self.Owner:GetViewModel():SendViewModelMatchingSequence( self.Owner:GetViewModel():LookupSequence( "Attack_Quick_1" ) )

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 110 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then
			
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 0
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( self.WallSound )		
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
			
	else
		self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
	
	timer.Simple( 0.05, function()
	if !IsValid(self.Owner) then return end
			self.Owner:ViewPunch( Angle( 0, 30, 0 ) )
	end )

	timer.Simple( 0.05, function()
	if !IsValid(self.Owner) then return end
			self.Owner:ViewPunch( Angle( -20, -16, 0 ) )
	end )
end

function SWEP:SecondaryAttack()
local tr = util.GetPlayerTrace( self.Owner )
local trace = util.TraceLine( tr )
if (!trace.Hit) then 
return end
if SERVER then
local ply = self.Owner
if trace.HitPos:Distance(ply:GetPos()) > Schema.PlaceRange then return end
if self.LastPlaced != nil then
if CurTime() < self.LastPlaced then return end
end
self.LastPlaced = CurTime() + 0.5
ply.Blocks = ply.Blocks or {}
if #ply.Blocks > Schema.MaxBlocks then
PW_Notify(ply,Color(204,0,0),"Max Blocks placed!")
return end
local block = ents.Create("pig_build_block")
block.Model = "models/hunter/blocks/cube05x05x05.mdl"
block:SetPos(trace.HitPos + ply:GetAngles():Up() * 23)
block:SetAngles(Angle(90,ply:GetAngles().y,120))
block:Spawn()
block:DropToFloor()
ply.Blocks[#ply.Blocks + 1] = block
end
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()
if SERVER then
if self.LastRemove != nil then
if CurTime() < self.LastRemove then return end
end
self.LastRemove = CurTime() + 1
for k,v in pairs(self.Owner.Blocks or {}) do
if v != nil and IsValid(v) then
v:Remove()
end
end
self.Owner.Blocks = {}
PW_Notify(self.Owner,Color(255,255,255),"All Blocks removed and added to inventory")
end
end

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function SWEP:OnRemove()

return true
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Holster()
if CLIENT then
if self.cm != nil then
self.cm:Remove()
end
self.cm = nil
end
	return true
end

function SWEP:Deploy()
if CLIENT then
self:CreatePreview()
end
end

if CLIENT then

function SWEP:Think()
self:CreatePreview()
end

function SWEP:CreatePreview()
local ply = self.Owner
if self.cm == nil then
self.cm = ents.CreateClientProp()
self.cm:SetPos( ply:GetPos() + ply:GetAngles():Forward() * 35 + ply:GetAngles():Up() *40 )
self.cm:SetModel( "models/hunter/blocks/cube05x05x05.mdl" )
self.cm:SetMaterial("models/wireframe")
self.cm:Spawn()
end
local tr = util.GetPlayerTrace( self.Owner )
local trace = util.TraceLine( tr )
if (!trace.Hit) then return end
self.cm:SetPos( trace.HitPos + ply:GetAngles():Up() *23 )
local ang = ply:GetAngles()
self.cm:SetAngles(Angle(90,ang.y,120))
end

end
