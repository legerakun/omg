SWEP.Base = "fo3_base"
----------------------------------------------------------------------------
--CONFIGS
----
SWEP.AimHoldType = "rpg"
SWEP.EquipAnim = "2hlequip"
SWEP.HolsterAct = "rpg"
SWEP.HolsterAnim = "2hlunequip"
SWEP.EnergyWep = true
SWEP.WeaponModel = "models/fallout/weapons/w_fatman.mdl"
SWEP.WepPos = Vector(5,-1,1)
SWEP.WepAng = Angle(0,-95,90)
SWEP.WeaponBone = "Bip01 R Hand"
SWEP.AttackAnims = {"2hlattack3"}
SWEP.ReloadAnims = {"2hlreloada"}
SWEP.ShootSound = {"wep/fatman/fatman_fire.wav"}
SWEP.ShootVolume = 0.45
SWEP.MaximumShots = 1000

-------------------------------------------------
SWEP.TracerType = "effect_fo3_blasterbeam"
SWEP.CriticalMat = "effects/laserblast"
SWEP.CriticalColor = Color(234,10,15)
SWEP.CriticalChance = 45
SWEP.Primary.Recoil = 1
SWEP.CriticalMulti = 2
SWEP.CriticalCoolDown = 4

SWEP.UseCustomMuzzleFlash               = false
SWEP.MuzzleEffect                       = "fo3_muzzle_plasmarifle"
SWEP.MuzzleAttachment                   = "1"
SWEP.EnergyEffect = ""
-------------------------------------------------
SWEP.HoldType = "rpg"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.PrintName = "Fatman"
SWEP.Category = "Fallout 3"
SWEP.ViewModel = "models/weapons/v_IRifle.mdl"
SWEP.WorldModel = "models/weapons/w_IRifle.mdl"
SWEP.ViewModelFOV = 60
//----------------------------------------------
SWEP.Primary.ClipSize = 1
SWEP.Primary.InvAmmo = "fo3_ammo_nuke"
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 1.5
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 15
SWEP.Primary.Cone = 0.02
SWEP.ReloadTime = 4
SWEP.ReloadSound = "wep/fatman/fatman_reload.wav"
-------------------------------------------------
--------------------------------------------------------------------------------

function SWEP:CSShootBullet( dmg, recoil, numbul, cone, viewm )
        --
	    self:TakeAmmo()
	    --
        numbul  = numbul        or 1
        cone    = cone          or 0.01
		--------
		if self.Owner:LimbCrippled("Left Arm") then
		  cone = cone + 0.025
		end
		if self.Owner:LimbCrippled("Right Arm") then
		  cone = cone + 0.025
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
		local PlayerPos = self.Owner:GetShootPos()
        local PlayerAim = self.Owner:GetAimVector()
		local vm = self.Owner:GetViewModel()
		local viewmodel1 = viewm
		
		if SERVER then     
		  local ang = self.Owner:GetAngles()
		  local pos = self.Owner:GetPos()
		  pos = pos + ang:Up()*65 + ang:Forward()*10 + ang:Right()*10
		  local entPlasma = ents.Create("pw_mininuke")
		  entPlasma:SetDamage(self.Primary.Damage)
		  entPlasma:SetPos(pos)
		  entPlasma:SetAngles(ang + Angle(-40,0,0))
		  entPlasma:SetEntityOwner(self.Owner)
		  entPlasma:Spawn()
		  entPlasma:Activate()
		
		  local phys = entPlasma:GetPhysicsObject()
		  if(phys:IsValid()) then
			phys:ApplyForceCenter(ang:Forward() *3500 + ang:Up()*3500)
		  end
		end
		
-- Muzzle Flash from Teta_Bonita's 'Realistic' SWEP Base :/
        local fx = EffectData()
		fx:SetEntity(self.Weapon)
		fx:SetOrigin(PlayerPos)
        fx:SetNormal(PlayerAim)
        fx:SetAttachment(self.MuzzleAttachment)
        if (self.UseCustomMuzzleFlash == true) then
                util.Effect(self.MuzzleEffect,fx)
        else
                self.Owner:MuzzleFlash()
        end
        
        --self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )      // View model animation
		if CLIENT then
		  local rseq = table.Random(self.AttackAnims)
		  self:PlayViewModelAnim(rseq)
		end
        self.Owner:SetAnimation( PLAYER_ATTACK1 )               // 3rd Person Animation
        if ( self.Owner:IsNPC() ) then return end
        // CUSTOM RECOIL !
        if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
                local eyeang = self.Owner:EyeAngles()
                eyeang.pitch = eyeang.pitch - recoil
                self.Owner:SetEyeAngles( eyeang )
        end
end
