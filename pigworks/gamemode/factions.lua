local char = FindMetaTable("Player")
faction = {}

function char:GetFactionName()
if !self:Team() or self:Team() == nil then return end
if !faction[self:Team()] then return end
return faction[self:Team()].Name
end

if SERVER then

function char:SortLoadout()
if self:IsBot() then return end
local weps = self:GetInventoryWeapons()
local wep_tbl = {}
  for k,v in pairs(weps) do
    local wep_class = v.Saved_Vars[v.Amount]
	if wep_class then
	  wep_class = wep_class["WepClass"]
	end
	if !wep_class then
	  print("[PigWorks]: "..k.." Index is nil, removing item..")
	  self.Inventory[k] = nil
      continue
	end
	wep_tbl[wep_class] = true
  end
  --
  for k,v in pairs(factionDefaultWeps) do
    if !wep_tbl[v] then
      self:Give(v)
	  local wep = self:GetActiveWeapon()
	  if IsValid(wep) then
	    self:StoreWeapon(wep)
	  end
    end  
  end
  --
  local can = hook.Call("pig_PreSortLoadout",GAMEMODE,self, wep_tbl)
  if can == false then return false end
  if faction[self:Team()] then
    for k,v in pairs(faction[self:Team()].weapons) do
      if !wep_tbl[v] then
        self:Give(v)
      end
    end
  end
  hook.Call("pig_PostSortLoadout",GAMEMODE,self)
end

function char:SetFaction( n, DontStrip )  
	if not faction[n] then
	  error("No Valid Faction entered!")
	return end
	local can = hook.Call("pig_CanChangeFaction",GAMEMODE,self,self:Team(),n)
	if can then
	if can == false then return end
	end
	local hooks = hook.Call("pig_NewFaction",GAMEMODE,self,self:Team(),n)
	if hooks then
	  n = hooks
	end
	if #self:GetWeapons() > 0 and !DontStrip and !Schema.NoStrip then
      self:StripWeapons()
    end	
	self:SetTeam( n )
	local col = faction[n].color
	self:SetPlayerColor( Vector(col.r / 255,col.g / 255,col.b / 255,col.a / 255) )
	self:SortLoadout()
	if faction[n].Model then
	self:SetModel(faction[n].Model)
	end
	self:SetRunSpeed(faction[n].RunSpeed)
	self:SetWalkSpeed(faction[n].WalkSpeed)
	self:SetCrouchedWalkSpeed(faction[n].CrouchSpeed)
	self:SetJumpPower(faction[n].JumpPower)
	
	PW_Notify(self,Color(255,255,255),"You have been made a "..faction[n].Name)
	if !self:IsBot() then
	  self.CharVars["Faction"] = n
	end
	return true
end

end