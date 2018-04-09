SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.EquipAnim = "h2hequip"
SWEP.HolsterAnim = "h2hunequip"

SWEP.Primary.ShellType = "none"
SWEP.DefaultAnims = {"h2hattackleft_a","h2hattackright_a","h2hattackleft_b"}
SWEP.FleshSound = {"wep/hit/blunt_flesh/wpn_hand_hit_flesh_01.mp3","wep/hit/blunt_flesh/wpn_hand_hit_flesh_02.mp3","wep/hit/blunt_flesh/wpn_hand_hit_flesh_03.mp3","wep/hit/blunt_flesh/wpn_hand_hit_flesh_04.mp3","wep/hit/blunt_flesh/wpn_hand_hit_flesh_05.mp3"}
SWEP.ShootSound = {"wep/fist/wpn_hand_swing01.wav","wep/fist/wpn_hand_swing02.wav","wep/fist/wpn_hand_swing03.wav"}
SWEP.ShootVolume = 0.35

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
SWEP.HolsterAnimAct = nil
SWEP.UnHolsterAnimAct = ACT_DOD_PRIMARYATTACK_PISTOL
-------------------------------------------------
SWEP.TracerType = ""
SWEP.CriticalColor = Color(255,255,255)
SWEP.CriticalChance = 5
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Delay = 0.6
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 3
-------------------------------------------------
SWEP.HoldType = "fist"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Melee Base"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.ViewModelFOV = 57
//----------------------------------------------
SWEP.Primary.ClipSize = -1
SWEP.UseHands = false
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 1
SWEP.Secondary.Damage = 0
SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
-------------------------------------------------
--------------------------------------------------------------------------------

function SWEP:FireAnimationEvent()
  return true
end

function SWEP:PrimaryAttack()
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
    self.SeqKey = self.SeqKey or 1
    local seq = tbl[self.SeqKey]
	if !seq then
	  self.SeqKey = 1
	  seq = tbl[self.SeqKey]
	end
    self:PlayViewModelAnim(seq)
	
	self.SeqKey = self.SeqKey+1
	local max = table.Count(tbl)
	if self.SeqKey > max then
	  self.SeqKey = 1
	end
  end
self.Owner:SetAnimation( PLAYER_ATTACK1 )               // 3rd Person Animation
--
self.Weapon:SetNextPrimaryFire(CurTime()+(self.Primary.Delay))
-------
  if trace.Hit then
    self:CSShootBullet(self.Primary.Damage,self.Primary.Recoil,self.Primary.Bullets or 1,self.Primary.Cone)
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

function SWEP:CSShootBullet( dmg, recoil, numbul, cone )
      
        numbul  = numbul        or 1
        cone    = cone          or 0.01
		
		--------
		if self.Owner:LimbCrippled("Left Arm") then
		  cone = cone + 0.02
		end
		if self.Owner:LimbCrippled("Right Arm") then
		  cone = cone + 0.02
		end
		-------
		--Notify
		if CLIENT then
		self.LastShakeNotify = self.LastShakeNotify or CurTime() - 1
		  if self.Owner:LimbCrippled("Left Arm") or self.Owner:LimbCrippled("Right Arm") then
            if self.LastShakeNotify <= CurTime() then
			  self.LastShakeNotify = CurTime()+20
			  pig.Notify(Schema.GameColor,"Crippled arms reduces your weapon accuracy",6,"FO3FontSmall","pw_fallout/v_sad.png")
			end
          end		  
		end
		---------------
		
		local vm = self.Owner:GetViewModel()
		local viewmodel1 = self.Owner:GetViewModel(1)
        local bullet = {}
        bullet.Num              = numbul
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir              = self.Owner:GetAimVector()
        bullet.Spread   = Vector( cone, cone, 0 )               // Aim Cone
        bullet.Tracer   = 0
        bullet.Force    = 5*dmg              // Amount of force to give to phys objects
        bullet.Damage   = dmg
		bullet.Callback = Critical
		bullet.AmmoType = "none"
		
        local PlayerPos = self.Owner:GetShootPos()
        local PlayerAim = self.Owner:GetAimVector()
        self.Owner:FireBullets( bullet )
end

function SWEP:IronSight()
  return
end

function SWEP:SecondaryAttack()
  return
end