Fallout_Items = Fallout_Items or {}
local char = FindMetaTable("Player")

function RegisterTierItem(class, isWep, isOutfit, craft_mats, skills, cat)
local index = GetItemIndex(class)
local theClass = class..""
  if isWep then
    theClass = "pig_ent_wep"
  elseif isOutfit then
    theClass = "fallout_c_base"
  end
  --
  Fallout_Items[index] = {
    Class = theClass,
    Materials = craft_mats,
    Skills = skills,
	Cat = cat
  }
  --
  if isWep then
    Fallout_Items[index].Wep = class
  elseif isOutfit then
    Fallout_Items[index].Outfit = class
  end
end

function GetItemIsWep(index)
return Fallout_Items[index].Wep
end

function GetItemIsOutfit(index)
return Fallout_Items[index].Outfit
end

function GetItemMaterials(index)
return Fallout_Items[index].Materials
end

function GetItemIndex(class)
local index = Schema.InvNameTbl[class] or class
return index
end

---------------------
--Player
function char:CanCraftItem(class)
  if !self:HasItemMaterials(class) or !self:MeetsSkillReq(class) then return end
  return true
end

function char:HasItemMaterials(class)
local mats = GetItemMaterials(class)
  for k,v in pairs(mats) do
    local name = Schema.InvNameTbl[k] or k
    if !self:HasInvItem(name) or self:GetInvAmount(name) < v then
	  return
	end
  end
return true
end

function char:MeetsSkillReq(class)
local skills = Fallout_Items[class].Skills
  for k,v in pairs(skills) do
    if self:GetAttributeValue(k) < v then
	  return
	end
  end
return true
end

function char:RemoveItemMaterials(class)
local mats = GetItemMaterials(class)
  for k,v in SortedPairs(mats) do
    local name = Schema.InvNameTbl[k] or k
    if self:HasInvItem(name) then
	  if SERVER then
	    self:InvRemove(name,v)
	  else
	    TakeInvVars(name,v)
	  end
	end
  end
end

if CLIENT then

function char:CraftClientItem(class)
  if !Fallout_Items[class] then return end
  if !self:MeetsSkillReq(class) then 
    pig.Notify(Schema.RedColor,"You do not meet the skill requirements to craft this",6,nil,"pw_fallout/v_sad.png")
    return
  elseif !self:HasItemMaterials(class) then
    pig.Notify(Schema.RedColor,"You do not have the required materials to craft this",6,nil,"pw_fallout/v_sad.png")
    return
  end
  self:RemoveItemMaterials(class)
return true
end

end
