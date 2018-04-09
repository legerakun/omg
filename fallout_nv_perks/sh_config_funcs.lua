
if SERVER then
  
  function CalcLimbHeal(ply,limb_heal)
    if !ply:HasFlag("p_la") then return limb_heal end
	--
	limb_heal = limb_heal+8
	return limb_heal
  end
  
  Fallout_PerkFunction("pig_XPAdded","Educated",function(ply,xp,new_xp,added)
    if !ply:HasFlag("p_ed") then return end
	--
	added = added + math.Round(added*.05)
    return added
  end)
  
end

  Fallout_PerkFunction("pig_GetMaxWeight","Strong Back",function(ply,weight)
    if !ply:HasFlag("p_sb") then return end
	--
	weight = weight+50
    return weight
  end)  
