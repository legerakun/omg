local Attribute = Attribute or {}
Attribute.Name = "Charisma"
Attribute.Author = "extra.game"
Attribute.Description = "Charisma affects peoples disposition towards you. Characters with specialised in this skill can talk their way out of RP situations."
Attribute.Icon = "pipboy/icons/special/special_charisma.vtf"

Attribute.BuyFunc = function(ply)
if SERVER then
PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
end
end
 
return Attribute