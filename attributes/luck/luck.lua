local Attribute = Attribute or {}
Attribute.Name = "Luck"
Attribute.Author = "extra.game"
Attribute.Description = "Luck helps improve your accuracy in V.A.T.S. Increasing this increases chances of hitting your target. [WARNING]: <This skill is currently Obsolete as V.A.T.S is disabled>"
Attribute.Icon = "pipboy/icons/special/special_luck.vtf"

Attribute.BuyFunc = function(ply)
if SERVER then
PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
end
end

 
return Attribute