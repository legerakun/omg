print("[FO3 SWEP Base]: Initialised recoil")

function SWEP:SWEPRecoil()
	mul = mul or 1
	mod = self.Owner:Crouching() and 0.75 or 1
	local recoil = self.Primary.Recoil
	if self:GetIronSights() then
	  recoil = recoil*.72
	end
	--
	recoil = recoil/8
    local spread = recoil*.25
	local kick = recoil*2
	self.Owner:ViewPunch(Angle(-kick, kick * math.Rand(-0.2475, 0.2475), 0) * (1 + spread * (self.SpreadToRecoil and self.SpreadToRecoil or 1)) * mod * ( 1 ) * mul)
		
	if CLIENT then
		ang = self.Owner:EyeAngles()
		ang.p = ang.p - recoil * (1 + spread * (self.SpreadToRecoil and self.SpreadToRecoil or 1)) * mod * ( 1) * mul
		ang.y = ang.y - recoil * math.Rand(-0.375, 0.375) * (1 + spread * (self.SpreadToRecoil and self.SpreadToRecoil or 1)) * mod * ( 1) * mul
		self.Owner:SetEyeAngles(ang)
	end
end

/*
function SWEP:SWEPRecoil()
local ang = self.Owner:EyeAngles()
local recoil = self.Primary.Recoil
  if self:GetIronSights() then
    recoil = recoil*.75
  end
self.PunchExit = CurTime() + (self.Primary.RecoilDelay or 0.85)
self.StartTime = CurTime()
self.StartVal = ang.p
self.PunchTarg = recoil
end
*/
/*
function SWEP:CalcViewPunch()
local ang = self.Owner:EyeAngles()
local target = self.PunchTarg
  if target then
    if self.PunchRev then
	  target = ang.p + self.PunchTarg
	else
      target = ang.p - self.PunchTarg
	end
    if self.PunchExit <= CurTime() then
	  self.PunchTarg = nil
	  return
	end

  if self.StartTime then
    local startTime = self.StartTime;
    local lifeTime = self.Primary.RecoilTime or 0.255;
    local startVal = ang.p
    local endVal = target
    local value = ang.p
    local fraction = ( CurTime( ) - startTime ) / lifeTime;
    fraction = math.Clamp( fraction, 0, 1 );
    value = Lerp( fraction, startVal, endVal );
	ang.p = value
	local min = self.Primary.Recoil
	if self:GetIronSights() then
	  min = min*.75
	end
	self.PunchTarg = self.PunchTarg - (min*((CurTime() - startTime)/lifeTime))
	if value == endVal then
	  self.StartTime = nil
	end
  end

	local recoil = self.Primary.Recoil
	if self:GetIronSights() then
	  recoil = recoil*.75
	end
	local range = .75
	if target < ang.p and (ang.p - range) <= target then
	  if self.Primary.RecoilDown then
	    self.StartTime = CurTime()
	    self.PunchRev = true
	  else
	    self.PunchTarg = nil
		self.PunchRev = false
	  end
	elseif target > ang.p and (ang.p + range) >= target then
	  self.PunchTarg = nil
	  self.PunchRev = false
	end

	self.Owner:SetEyeAngles(Angle(ang.p, ang.y, ang.r))
  end
end
*/