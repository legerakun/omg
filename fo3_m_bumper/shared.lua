SWEP.Base = "fo3_m_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "2hmequip"
SWEP.HolsterAnim = "2hmunequip"

SWEP.ShellEffect = "none"
SWEP.ShellEjectAttachment	= "2"
SWEP.AttackAnims = {"2hmattackleft_a","2hmattackright_a"}
SWEP.WeaponModel = "models/fallout/weapons/c_bumpersword.mdl"
SWEP.WepPos = Vector(4.15,-1.35,0)
SWEP.WepAng = Angle(0,-105,0)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.ShootVolume = 1

SWEP.HolsterBone = "Bip01 Spine2"
SWEP.HolsterPos = Vector(18, 7, -6)
SWEP.HolsterAng = Angle(0,-25,90)

SWEP.ShootSound = {"wep/melee/swing/fx_swing_large01.wav", "wep/melee/swing/fx_swing_large02.wav"}

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
SWEP.PrintName = "Bumper Sword"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 72
//----------------------------------------------
SWEP.Primary.Damage = 12
SWEP.Primary.Delay = 1

SWEP.Primary.PowerTime = 0.5
SWEP.Primary.PowerAttack = "2hmattackpower"
SWEP.PowerSeq = "2hmattackpower"
-------------------------------------------------
--------------------------------------------------------------------------------

function SWEP:SecondaryAttack()
if self:IsHolstered() then return end
self:ChargeAttack()
self:SetNextSecondaryFire(CurTime()+3)
end

function SWEP:ChargeAttack()
if self:GetNextPrimaryFire() > CurTime() then return end
if CLIENT and !IsFirstTimePredicted() then return end
if self:IsCharging() then return end
--
local degrade = 0
  if self.MaximumShots then
    degrade = math.Round( 100/self.MaximumShots, 2 )
  end
--
  if SERVER then
    if self.Weapon:GetNWString("PowerAttack","") == "" then
      self.Weapon:SetNWString("PowerAttack", self.Primary.PowerAttack)
    end
  end
local velocity = self.Owner:GetVelocity():Length()
if velocity <= 20 then return end
self.Charge = true
self:SetNWBool("IsCharging",true)
self:LegacyAttack(true)
local delay = self.Primary.PowerTime--0.6
  timer.Simple(delay*.95,function()
    if !self or !self.Primary then return end
    self.Charge = false
	self:SetNWBool("IsCharging",false)
	self:MeleeAttack(self.Primary.Damage*1.75)
  end)
end

function SWEP:LegacyAttack(power)
  if self.Holstering then
    self:HolsterWeapon()
  return end
local degrade = 0
  if self.MaximumShots then
    degrade = math.Round( 100/self.MaximumShots, 2 )
  end
----------
  local tr = {}
  tr.start = self.Owner:GetShootPos()
  tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 90 )
  tr.filter = self.Owner
  tr.mask = MASK_SHOT
  local trace = util.TraceLine( tr )
----------
local viewmodel1 = self.Owner:GetViewModel(1)
local tbl = self.AttackAnims or self.DefaultAnims
  if CLIENT then
    if power then
      local seq = self.PowerSeq or tbl[math.random(1,#tbl)]
      self:PlayViewModelAnim(seq)
	else
      local seq = tbl[math.random(1,#tbl)]
      self:PlayViewModelAnim(seq)	
	end
  end
self.Owner:SetAnimation( PLAYER_ATTACK1 )               // 3rd Person Animation
--
self.Weapon:SetNextPrimaryFire(CurTime()+(self.Primary.Delay))
-------
  if IsValid(trace.Entity) then
    if trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass():find("npc") then
	  self.FleshSound.BaseClass = nil
	  local flesh = table.Random(self.FleshSound)
      self:EmitSound(flesh,90,100,1)
	else
	  self.ShootSound.BaseClass = nil
	  local sound = table.Random(self.ShootSound)
      self:EmitSound(sound,90,100,self.ShootVolume or 1)
	end
  else
    self.ShootSound.BaseClass = nil
    local sound = table.Random(self.ShootSound)
    self:EmitSound(sound,90,100,self.ShootVolume or 1)
  end
end

function SWEP:MeleeAttack(dmg)
  local trace = {}
  local ply = nil
  for k,v in pairs(ents.FindInSphere(self.Owner:GetPos(), 50)) do
    if !v:IsNPC() and !v:GetClass():find("npc") and !v:IsPlayer() or v == self.Owner then continue end
	ply = v
	break
  end
  
  if IsValid(ply) then
    trace.Hit = true
	trace.Entity = ply
  else
    local tr = {}
    tr.start = self.Owner:GetShootPos()
    tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 90 )
    tr.filter = self.Owner
    tr.mask = MASK_SHOT
    trace = util.TraceLine( tr )
  end
----------
  if trace.Hit then
    if trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass():find("npc") then
	  if SERVER then
        local damageinfo = DamageInfo()
	    damageinfo:SetAttacker( self.Owner )
	    damageinfo:SetInflictor( self )
        damageinfo:SetDamageType( DMG_CLUB )
	    damageinfo:SetDamageForce(self.Owner:GetForward() *(dmg*5))
	    damageinfo:SetDamage( dmg )
	    trace.Entity:TakeDamageInfo( damageinfo )
	  end
	elseif trace.Entity:IsWorld() then
	  if SERVER then
	    util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
	  end
	end
  end
  if IsValid(trace.Entity) then
    if trace.Entity:IsPlayer() or trace.Entity:IsNPC() or trace.Entity:GetClass():find("npc") then
	  self.FleshSound.BaseClass = nil
	  local flesh = table.Random(self.FleshSound)
      self:EmitSound(flesh,90,100,1)
	else
	  self.ShootSound.BaseClass = nil
	  local sound = table.Random(self.ShootSound)
      self:EmitSound(sound,90,100,self.ShootVolume or 1)
	end
  else
    self.ShootSound.BaseClass = nil
    local sound = table.Random(self.ShootSound)
    self:EmitSound(sound,90,100,self.ShootVolume or 1)
  end
end

function SWEP:IsCharging()
  if self.Charge or self:GetNWBool("IsCharging",false) then
    return true
  end
end

-------------
--HOOKS
-------------

hook.Add("pig_SetNewAttack", "FChargeSWEP", function(ply, holdtype, event, data)
local wep = ply:GetActiveWeapon()
if !IsValid(wep) then return end
local class = wep:GetClass()
local powerattack = nil
--
    if !class:find("_m_") then return end
    if wep.Primary and wep.Primary.PowerAttack then
	  powerattack = wep.Primary.PowerAttack
    elseif wep:GetNWString("PowerAttack","") != "" then
	  powerattack = wep:GetNWString("PowerAttack")
    end
--
  if !powerattack then return end
  if event == PLAYERANIMEVENT_ATTACK_PRIMARY and wep:IsCharging() then
    return powerattack
  end
end)

hook.Add("Move", "FChargeSWEP", function(ply, mv)
local vel = mv:GetVelocity()
local ang = mv:GetAngles()
local wep = ply:GetActiveWeapon()

  if IsValid(wep) and pig.utility.IsFunction(wep.IsCharging) and wep:IsCharging() then
    if ply:OnGround() then
      local speed = 450
      vel = ang:Forward()*speed
    end
  end
  
mv:SetVelocity(vel)
end)


