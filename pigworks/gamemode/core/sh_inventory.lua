print("SH Inv")
local char = FindMetaTable("Player")
local ent = FindMetaTable("Entity")

function pig.GetInvWG(class, name)
local mass = 0
  if Schema.InvMassTbl and Schema.InvMassTbl[class] then
    mass = Schema.InvMassTbl[class]
  elseif Schema.InvMassTbl and name and Schema.InvMassTbl[name] then
    mass = Schema.InvMassTbl[name]
  end
return mass
end

function pig.GetInvName(class, savevars, invtbl)
local index = nil
  if Schema.InvNameTbl then
    index = Schema.InvNameTbl[class]
  end
index = index or class..""
local newindex = hook.Call("pig_GetInvName", GAMEMODE, class, savevars)
index = newindex or index

  if table.HasValue(Schema.InvNonStackables,index) then
    local c_amt = 1
	local temp_amt = 0
	  for k,v in pairs(invtbl) do
	    if string.sub(k,1,class:len()) == class then 
		  temp_amt = string.sub(k,class:len()+2,class:len() + 2)
		  temp_amt = tonumber(temp_amt)
		    if temp_amt > c_amt then
			  c_amt = temp_amt+0
			end
		end
	  end
    index = class.." "..c_amt+1
  end
return index
end

function pig.GetInvIcon(name,class)
  if Schema.Icons and Schema.Icons[name] then
    return Material(Schema.Icons[name])
  end
  if class and class == "pig_ent_wep" then
    return Material("pigworks/weapon.png")
  else
    return Material("pigworks/entity.png")
  end
end

function ent:HasPigOwner()
  if self:GetNWEntity("pig_Owner") and IsValid(self:GetNWEntity("pig_Owner")) then
    return true
  end
end

function ent:GetPigOwner()
  if self:HasPigOwner() then
    return self:GetNWEntity("pig_Owner")
  end
end

function char:GetInventoryItem(index)
local tb = {}
  for k,v in pairs(self.Inventory) do
    if k:lower() == index:lower() then
	  tb[k] = v
	end
  end
return tb
end

function char:InvHasWeapon(class, func)
local weapons = self:GetInventoryWeapons()
  for k,v in pairs(weapons) do
    local w_class = v.Saved_Vars[1].WepClass
	if w_class == class then
	  if func then
	    func(self, k, v)
	  end
	  return true
	end
  end
end

function char:InvCanDropWeapon(index)
local ply = self
local default_weps = factionDefaultWeps or {}
local fac_weps = faction[ply:Team()].weapons or {}
local class = ply.Inventory[index].Saved_Vars
  if class then
    class = class[1].WepClass
  end
  if class then
    if table.HasValue(default_weps, class) or table.HasValue(fac_weps, class) then
      return
    end
  end
--
return true
end

function char:GetInventoryByClass(class)
local tb = {}
  for k,v in pairs(self.Inventory) do
    if v.Class == class then
	  tb[k] = v
	end
  end
return tb
end

function char:FindInventoryByClass(class)
local tb = {}
  for k,v in pairs(self.Inventory) do
    if v.Class:find(class) then
	  tb[k] = v
	end
  end
return tb
end

function char:GetInventoryWeapons()
local tb = self:GetInventoryByClass("pig_ent_wep")
return tb
end

function char:HasInvItemByClass(class)
  for k,v in pairs(self.Inventory) do
    if v.Class == class then
      return true
    end
  end
end

function char:InvClassToIndex(class)
  for k,v in pairs(self.Inventory) do
    if v.Class == class then
	  return k
	end
  end
end

function char:HasInvItem(index)
  if self.Inventory[index] then
    return true
  end
end

function char:GetInvAmount(index)
  if self:HasInvItem(index) then
    return self.Inventory[index].Amount
  end
return 0
end

function char:GetInvTotalWG(index)
  if self:HasInvItem(index) then
    return self.Inventory[index].Weight
  end
end

function char:GetInvWG(index)
  if self:HasInvItem(index) then
    return self.Inventory[index].Weight
  end
end

function char:GetWeight()
return self.WG
end

function char:CanStore(mass)
  if self:GetWeight() + mass <= self:GetMaxWeight() then
    return true
  end
end

function char:GetMaxWeight()
local weight = nil
if SERVER then
weight = self.MaxWG
else
weight = Schema.InvMaxWG
end
local w = hook.Call("pig_GetMaxWeight",GAMEMODE,self,weight)
if w != nil then
weight = w
end
return weight
end
