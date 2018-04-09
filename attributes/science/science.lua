local Attribute = Attribute or {}
Attribute.Name = "Science"
Attribute.Author = "extra.game"
Attribute.Description = "Allows you to hack players terminals to view their stored information, logs or sometimes possibly codes to other terminals. It is also required in Perks and certain Crafting recipes."
Attribute.Icon = "pw_fallout/skills/skills_science.png"

Attribute.BuyFunc = function(ply)
if SERVER then
PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
end
end

 
return Attribute