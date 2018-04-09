AddCSLuaFile()
ENT.Base 			= "base_nextbot"
ENT.Spawnable		= false
ENT.Category = "PigWorks"

function ENT:Initialize()
self:SetHealth(self.MaxHealth)
self:NPCInit()
end

function ENT:Think()
if self.LastFoot == nil then
self.LastFoot = CurTime() - 1
end
if self.LastFoot < CurTime() and self:GetActivity() == ACT_WALK or self.LastFoot < CurTime() and self:GetActivity() == ACT_RUN then
self:FootNoise()
if self:GetActivity() == ACT_WALK then
self.LastFoot = CurTime() + 1
else
self.LastFoot = CurTime() + 0.4
end
end
self.MinRadius = self.MinRadius or self.Radius
for k,v in pairs(ents.FindInSphere(self:GetPos(),self.Radius)) do
if v:IsPlayer() then
if self:GetPos():Distance(v:GetPos()) < self.MinRadius then
self.MinRadius = self:Distance(v:GetPos())
self:SetTarg(v)
end
end
end
end

function ENT:Chase( options, enemy, provoked )
	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, enemy:GetPos() )		-- Compute the path towards the enemies position
	if ( !path:IsValid() ) then return "failed" end
	while ( path:IsValid() ) do
	if self:GetActivity() != ACT_RUN and !self.Flinching then
	self:StartActivity( ACT_RUN )
	end
    self.loco:SetDesiredSpeed( self.Speed )	
	if !provoked then
	if !IsValid(enemy) or enemy:Distance(self:GetPos()) > self.Radius then
	self.Target = nil
	self.MinRadius = self.Radius
	return "failed"
	end
	else
	if !IsValid(enemy) or enemy:Distance(self:GetPos()) > self.Radius * 3 then
	self.Provoker = nil
	self.MinRadius = self.Radius
	return "failed"
	end
	end
	if self.Provoker != nil and enemy != self.Provoker then 
	return "failed" end
	if ( path:GetAge() > 0.1 ) then
	path:Compute( self, enemy:GetPos() )
	end
		path:Update( self )
		if ( options.draw ) then path:Draw() end
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end
		coroutine.yield()
	end
	return "ok"
end

function ENT:SetTarg(ent)
self.Target = ent
end

function ENT:HasTarget()
if self.Target != nil and IsValid(self.Target) then
return true
end
end

function ENT:OnInjured( dmginfo )
local attacker = dmginfo:GetAttacker()
if attacker:IsPlayer() then
self.Provoker = attacker
end
if self.LastFlinch == nil then
self.LastFlinch = CurTime() - 1
end
if self.LastFlinch > CurTime() then return end
self:StartActivity(table.Random(self.FlinchBox))
self.LastFlinch = CurTime() + math.random(1,15)
self.Flinching = true
timer.Simple(0.75,function()
if !IsValid(self) then return end
self.Flinching = false
end)
end

function ENT:IsProvoked()
if self.Provoker != nil and IsValid(self.Provoker) then
return true
end
end

function ENT:OnOtherKilled( victim, dmginfo )
if !victim:IsPlayer() then return end
if self.Provoker != nil and self.Provoker == victim then
self.Provoker = nil
end
if self.Target != nil and self.Target == victim then
self.Target = nil
end
end

function ENT:RunBehaviour()
while (true) do
if self:IsProvoked() then
self:StartActivity( ACT_RUN )
self.loco:SetDesiredSpeed( self.Speed )	
self:Chase(nil,self.Provoker,true)
elseif self:HasTarget() then
self:StartActivity( ACT_RUN )
self.loco:SetDesiredSpeed( self.Speed )	
self:Chase(nil,self.Target)
else
self:StartActivity( ACT_WALK )
self.loco:SetDesiredSpeed( self.WalkSpeed )
self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 140 ) -- Walk to a random place within about 400 units ( yielding )
self:StartActivity( ACT_IDLE )
coroutine.wait( 1.4 )
end
end
end

function ENT:FootNoise()
if self.FootStep != nil then self.FootStep:Stop() end
self.FootStep = CreateSound(self,"deathclaw_foot_run_l0"..math.random(1,4)..".mp3")
self.FootStep:Play()
self.FootStep:ChangeVolume(1)
if self:GetActivity() == ACT_WALK then
self.FootStep:SetSoundLevel( 255 )
else
self.FootStep:SetSoundLevel( 511 )
end
end
