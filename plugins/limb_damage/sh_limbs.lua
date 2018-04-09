local Plugin = {}
local char = FindMetaTable("Player")

function char:GetLimb(limb)
local limbs = self:GetCharVar("Limbs")
  if limbs then
    return limbs[limb]
  end
end

function char:LegsCrippled()
  if self:GetNWBool("Crippled",false) == true then
    return true
  end
end

function char:LimbCrippled(limb)
if !self.CharVars then return end
local health = self:GetLimb(limb)
  if health and health <= 0 then
    return true
  end
end
--
function GetAllLimbs()
local limbs = {"Head","Upper Body","Abdominal","Left Arm","Right Arm","Left Leg","Right Leg"}
  for k,v in pairs(limbs) do
	if table.HasValue(Schema.LimbBlacklisted,v) then
	  limbs[k] = nil
	end
  end
return limbs
end

function ConvertLimb(limb)
local tab = {}
tab["Abdominal"] = "Upper Body"
tab["Upper Body"] = "Abdominal"
return tab[limb]
end

function LimbShortenName(limb)
local limbs = {}
limbs["Head"] = 1
limbs["Upper Body"] = 2
limbs["Abdominal"] = 3
limbs["Left Arm"] = 4
limbs["Right Arm"] = 5
limbs["Left Leg"] = 6
limbs["Right Leg"] = 7
local var = limbs[limb]
return var
end

function LimbNumToLimb(num)
local limbs = GetAllLimbs()
return limbs[num]
end
--

net.Receive("PW_SendLimb",function()
local num = net.ReadFloat()
num = LimbNumToLimb(num)
local oldhealth = LocalPlayer():GetLimb(num)
local health = net.ReadFloat()

LocalPlayer().CharVars["Limbs"][num] = health
hook.Call("OnLimbChange",GAMEMODE,LocalPlayer(),num,health,oldhealth)
  if health <= 0 then
    hook.Call("OnLimbCrippled",GAMEMODE,LocalPlayer(),num)
  end
end)

return Plugin