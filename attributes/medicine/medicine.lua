local Attribute = Attribute or {}
Attribute.Name = "Medicine"
Attribute.Author = "extra.game"
Attribute.Description = "How effective Stimpacks and Doctor Bags are on you. This affects how much health you gain from Stimpacks and can make Doctor Bags more effective at healing limbs."
Attribute.Icon = "pw_fallout/skills/skills_medicine.png"

Attribute.BuyFunc = function(ply)
if SERVER then
PW_Notify(ply,Schema.GameColor,"You upgraded Medicine!")
end
end
 
-----------
function Attribute:CalcStimHealth(ply,heal,limb_heal)
local med = ply:GetAttributeValue(Attribute.Name)
heal = ((30 + 0.6 * med) * 1.2) / 2
heal = math.Round(heal)
--
return heal
end
 
return Attribute