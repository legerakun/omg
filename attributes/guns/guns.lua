local Attribute = Attribute or {}
Attribute.Name = "Guns"
Attribute.Author = "extra.game"
Attribute.Description = "Reduces spred on regular ballistic fire-arms such as Pistols, Assault Rifles, Shotguns, etc. This does not apply to energy weapons. You may also craft certain home-made guns such as 10mm Pistols from parts as well as ballistic fire-arms ammo and casings."
Attribute.Icon = "pw_fallout/skills/skills_small_guns.png"

Attribute.BuyFunc = function(ply)
if SERVER then
PW_Notify(ply,Schema.GameColor,"You upgraded Guns!")
end
end

 
return Attribute