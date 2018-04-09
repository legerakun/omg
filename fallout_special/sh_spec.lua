local char = FindMetaTable("Player")
local special = {"Strength","Perception","Endurance","Charisma","Intelligence","Agility","Luck"}

function Schema.Hooks:pig_AddToAttribute(ply,name,amount)
  if Fallout_IsSpecial(name) then
    if ply:GetSpecialPoints() < amount then return false end
	ply:TakeSpecialPoints(amount)
	local amt = ply:GetAttributeValue(name)
	hook.Call("Fallout_AddedSpecial",GAMEMODE,ply,name,amount)
	  if SERVER then
	    ply:SetAttribute(name,amt + amount,true)
	  else
	    ply.Attributes[name].Point = amt + amount
	  end
	return false
  end
end

function Fallout_GetSpecial()
return special
end

function Fallout_IsSpecial(name)
  if table.HasValue(special,name) then
    return true
  end	
end

function char:TakeSpecialPoints(amt)
local sp = self:GetSpecialPoints()
sp = math.Clamp(sp-amt,0,sp)
self.CharVars["SpecialPoints"] = sp
end

function char:GetSpecialPoints()
local sp = self:GetCharVar("SpecialPoints") or 0
return sp
end
