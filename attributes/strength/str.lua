local Attribute = Attribute or {}
Attribute.Name = "Strength"
Attribute.Author = "extra.game"
Attribute.Description = "Strength determines how strong you are and affects many things including carry weight (WG).\n\nCertain weapons also have strength requirements."
Attribute.Icon = "pipboy/icons/special/special_strength.vtf"

Attribute.BuyFunc = function(ply)
  if SERVER then
    PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
  end
end

function Attribute:pig_GetMaxWeight(ply, weight)
local val = ply:GetAttributeValue( Attribute.Name )
local add = math.Round( 60*(val/100), 2)
return weight+add
end
 
return Attribute