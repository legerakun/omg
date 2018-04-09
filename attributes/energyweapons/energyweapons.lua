local Attribute = Attribute or {}
Attribute.Name = "Energy Weapons"
Attribute.Author = "extra.game"
Attribute.Description = "Reduces spread on all Energy Weapons (Laser Rifles, Plasma Pistols, etc.). This does not apply to Non-Energy Weapons. This skill also allows you to craft energy weapon ammo such as Microfusion Cells, E-Cells, etc.."
Attribute.Icon = "pw_fallout/skills/energy.png"

Attribute.BuyFunc = function(ply)
if SERVER then
PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
end
end

 
return Attribute