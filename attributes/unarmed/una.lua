local Attribute = Attribute or {}
Attribute.Name = "Unarmed"
Attribute.Author = "extra.game"
Attribute.Description = "Unarmed affects how well you use unarmed weapons and the damage you deal, including but now limited to Fists and Deathclaw Gauntlets. Unarmed weapons include fists, gauntlets and power fists. This does not include Melee Weapons."
Attribute.Icon = "pw_fallout/icons/weapons/fists.png"

Attribute.BuyFunc = function(ply)
  if SERVER then
    PW_Notify(ply,Schema.GameColor,"You upgraded Inventory!")
  end
end
 
return Attribute