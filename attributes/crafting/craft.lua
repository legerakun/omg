local Attribute = Attribute or {}
Attribute.Name = "Crafting"
Attribute.Author = "extra.game"
Attribute.Description = "Crafting is used in making, modding and maintaining weapons. The higher this skill, the more efficent repairing becomes, along with more weapon crafting options."
Attribute.Icon = "pw_fallout/skills/skills_craft.png"

Attribute.BuyFunc = function(ply)
  if SERVER then
    PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
  end
end

 
return Attribute