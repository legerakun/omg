local Attribute = Attribute or {}
Attribute.Name = "Explosives"
Attribute.Author = "extra.game"
Attribute.Description = "Allows you to craft explove items such as Bottlecap mines. When at 30 or above, you can disarm Frag/Bottlecap Mines aswell as pick them up and use them against your enemies."
Attribute.Icon = "pw_fallout/skills/skills_explosive.png"

Attribute.BuyFunc = function(ply)
if SERVER then
PW_Notify(ply,Schema.GameColor,"You upgraded "..Attribute.Name.."!")
end
end

 
return Attribute