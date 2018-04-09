local Attribute = Attribute or {}
Attribute.Name = "Melee Weapons"
Attribute.Author = "extra.game"
Attribute.Description = "Melee Weapons is required when crafting certain home-made melee weapons such as Baseball Bats, 9-Irons, Pick-Axes, etc."
Attribute.Icon = "pw_fallout/skills/skills_melee_weapons.png"

Attribute.BuyFunc = function(ply)
if SERVER then
PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
end
end

 
return Attribute