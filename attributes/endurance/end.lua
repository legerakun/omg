local Attribute = Attribute or {}
Attribute.Name = "Endurance"
Attribute.Author = "extra.game"
Attribute.Description = "Endurance affects your Damage Resistance (DR). The higher this is, the more resistant you become to damage. Cetain perks also require this skill."
Attribute.Icon = "pipboy/icons/special/special_endurance.vtf"

Attribute.BuyFunc = function(ply)
if SERVER then
PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
end
end

function Attribute:Fallout_BaseDamageRes(ply)
local res = math.Round(ply:GetAttributeValue(Attribute.Name)/2,2)
res = math.Clamp(res,0,6)
return res
end
 
return Attribute