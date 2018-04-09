local Attribute = Attribute or {}
Attribute.Name = "Intelligence"
Attribute.Author = "extra.game"
Attribute.Description = "Intelligence affects your Science, Medicine and Crafting skills. It is also a base requirement for certain perks."
Attribute.Icon = "pipboy/icons/special/special_intelligence.vtf"
Attribute.Skills = {"Medicine","Crafting","Science"}

Attribute.BuyFunc = function(ply)
if SERVER then
PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
end
end

function Attribute:Fallout_AddedSpecial(ply,name,amt)
  if name == Attribute.Name then
    for k,v in pairs(Attribute.Skills) do
      ply:AddToAttribute(v,2*amt)
	end
  end
end
 
return Attribute