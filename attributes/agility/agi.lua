local Attribute = Attribute or {}
Attribute.Name = "Agility"
Attribute.Author = "extra.game"
Attribute.Description = "Agility affects how many AP points are lost in various actions such as running. Increasing this upgrades max AP points."
Attribute.Icon = "pipboy/icons/special/special_agility.vtf"
--
local char = FindMetaTable("Player")
local function getRunSpeed(ply)
local team = ply:Team()
local tbl = faction[team]
  if !tbl or !tbl.RunSpeed then
    tbl = faction[1]
  end
local runspeed = tbl.RunSpeed
local wep = ply:GetActiveWeapon()
--
  if IsValid(wep) and wep:GetNWBool("IronSight",false) == true  then
    runspeed = runspeed*.4
  end
--
local amt = 0
  if ply.CharVars then
    if ply:LimbCrippled("Left Leg") then
      amt = amt + 1
    end
    if ply:LimbCrippled("Right Leg") then
      amt = amt + 1
    end
  end
  if amt == 1 then
    runspeed = Schema.LegCrip1_RunSpeed
  elseif amt == 2 then
    runspeed = Schema.LegCrip2_RunSpeed
  end
--
return runspeed
end
local function getWalkSpeed(ply)
local team = ply:Team()
local tbl = faction[team]
  if !tbl or !tbl.WalkSpeed then
    tbl = faction[1]
  end
local wspeed = tbl.WalkSpeed
--
local amt = 0
  if ply.CharVars then
    if ply:LimbCrippled("Left Leg") then
      amt = amt + 1
    end
    if ply:LimbCrippled("Right Leg") then
      amt = amt + 1
    end
  end
  if amt == 1 then
    wspeed = Schema.LegCrip1_WalkSpeed
  elseif amt == 2 then
    wspeed = Schema.LegCrip2_WalkSpeed
  end
--
return wspeed
end
--
function AgilityRunSpeed(ply)
return getRunSpeed(ply)
end
function AgilityWalkSpeed(ply)
return getWalkSpeed(ply)
end
-----------
--CHAR
if SERVER then

function Attribute:PlayerSpawn(ply)
if !ply:GetCharID() or !ply:Team() or ply:Team() < 1 then return end
ply:SetAP( ply:GetMaxAP() or 100 )
local wspeed = getWalkSpeed(ply)
local runspeed = getRunSpeed(ply)
ply:SetWalkSpeed(wspeed)
ply:SetRunSpeed(runspeed)
end

function char:AddAP(amt)
self:SetAP( self:GetAP() + amt )
end

function char:SetAP(amt)
local max = self:GetMaxAP()
amt = math.Clamp(amt, 0, max)
self:SetNWInt("ActionPoints", amt)
end

end

function char:GetMaxAP()
local max = 100
local att = self:GetAttributeValue(Attribute.Name)
local plus = math.Round(100*(att/100))
max = max + plus
--
return max
end

function char:GetAP()
local ap = self:GetNWInt("ActionPoints", self:GetMaxAP())
return ap
end
-----------
--FUNCS
if SERVER then

function Attribute:KeyPress(ply, key)
if ply:InEditor() then return end
if key != IN_SPEED and !ply:KeyDown(IN_SPEED) then return end
local movetype = ply:GetMoveType()
if movetype == MOVETYPE_NOCLIP or movetype == MOVETYPE_NONE then return end
--
local cid = ply:GetCharID()
local regname = "APReg:"..cid
  if timer.Exists(regname) then
    timer.Destroy(regname)
  end
local take = 1
ply:AddAP(-take)
local ap = ply:GetAP()
  if ap <= 0 then
    local wspeed = getWalkSpeed(ply)
    local runspeed = getRunSpeed(ply)
	--
	ply:SetWalkSpeed(math.Round(wspeed*.625))
	ply:SetRunSpeed(math.Round(runspeed*.625))
	--
	return
  end
--
local timername = "APDrain:"..ply:GetCharID()
if timer.Exists(timername) then return end
local time = 1
--
  timer.Create(timername, time, 0, function()
    if !IsValid(ply) or ply:GetCharID() != cid then timer.Destroy(timername) return end
	--
	ply:AddAP(-take)
	--
	local ap = ply:GetAP()
	if ap <= 0 then
	  local wspeed = getWalkSpeed(ply)
      local runspeed = getRunSpeed(ply)
	  --
	  ply:SetWalkSpeed(math.Round(wspeed*.625))
	  ply:SetRunSpeed(math.Round(runspeed*.625))
	  --
	  timer.Destroy(timername)
	  return
	end
  end)
end

function Attribute:KeyRelease(ply, key)
if ply:InEditor() then return end
if key != IN_SPEED and ply:KeyDown(IN_SPEED) then return end
--
local cid = ply:GetCharID()
local timername = "APDrain:"..cid
local regname = "APReg:"..cid
  if timer.Exists(timername) then
    timer.Destroy(timername)
  end
local settime = CurTime() + 4
local set = false
--
local att = ply:GetAttributeValue(Attribute.Name)
local time = 1 - (0.5 *(att/100))
  timer.Create(regname, time, 0, function()
    if !IsValid(ply) or ply:GetCharID() != cid then timer.Destroy(regname) return end
	--
    local plus = 1
	ply:AddAP(plus)
	--
	if settime <= CurTime() and !set then
	  local wspeed = getWalkSpeed(ply)
	  local runspeed = getRunSpeed(ply)
	  ply:SetWalkSpeed(wspeed)
	  ply:SetRunSpeed(runspeed)
	  set = true
	end
	--
	local ap = ply:GetAP()
	if ap >= ply:GetMaxAP() then
	  timer.Destroy(regname)
	end
  end)
--
end

end
--

Attribute.BuyFunc = function(ply)
  if SERVER then
    PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
  end
end
 
return Attribute