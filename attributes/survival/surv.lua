local Attribute = Attribute or {}
Attribute.Name = "Survival"
Attribute.Author = "extra.game"
Attribute.Description = "Survival defines your skill at cooking and combining foods when at Workbench's. It also allows you to make better use of your food and heal more from Food items."
Attribute.Icon = "pw_fallout/skills/skills_survival.png"

Attribute.BuyFunc = function(ply)
if SERVER then
PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
end
end

 
return Attribute