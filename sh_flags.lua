
-------------------------
--FLAGS
/*
USAGE
  SuperAdmin = true / false, <---Is it for super admins only?
  OnCharSelect = function, <---Occurs when character is selected
  Loadout = tbl.Loadout, <---Occurs when loadout is selected
  OnGive = tbl.OnGive, <---Occurs when flag is given
  OnTake = tbl.OnTake <---Occurs when flag is taken away
*/

--Phys gun
pig.RegisterFlag("p","Gives access to the physics gun",{
OnGive = function(ply)
  if !ply:HasWeapon("weapon_physgun") and !ply:InvHasWeapon("weapon_physgun") then
    ply:Give("weapon_physgun")
  end
end,
OnTake = function(ply)
  if ply:HasWeapon("weapon_physgun") then
    ply:StripWeapon("weapon_physgun")
  else
    ply:InvHasWeapon("weapon_physgun", function(ply, k, v)
	  ply.Inventory[k] = nil
	  local index = "weapon_physgun"
	  ply:SendInv(index)
	end)
  end
end,
Loadout = function(ply, wep_tbl)
  if !wep_tbl["weapon_physgun"] then
    ply:Give("weapon_physgun")
  end
end
})

pig.RegisterFlag("t1_g","Gives Tier 1 Guns",{
OnGive = function(ply)

end,
OnTake = function(ply)

end,
Loadout = function(ply, wep_tbl)

end
})
