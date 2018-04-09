local Attribute = Attribute or {}
Attribute.Name = "Perception"
Attribute.Author = "extra.game"
Attribute.Description = "Perception affects your Energy Weapons, Crafting and Explosives skills.\nThe higher this is, the bigger the buff you gain to these skills."
Attribute.Icon = "pipboy/icons/special/special_perception.vtf"
Attribute.Skills = {"Energy Weapons","Crafting","Explosives"}

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