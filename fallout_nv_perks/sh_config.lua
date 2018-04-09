---------------
--ADDING PERKS

--Fallout_RegisterPerk(name,flag_name,desc,icon,flag_tbl)
Fallout_RegisterPerk("Educated","p_ed","Provides 10% more experience points whenever experience points are earnt","pw_fallout/perks/educated.png",{
  --OnCharSelect = tbl.OnCharSelect,
  --Loadout = tbl.Loadout,
  --OnGive = function(ply)
  --OnTake = tbl.OnTake
})

Fallout_RegisterPerk("Living Anatomy","p_la","You can now heal your limbs partially by the use of Stimpacks\n\nDoctors Bags are now also more efficient","pw_fallout/perks/living.png",{
})

Fallout_RegisterPerk("Intense Training","p_it","You will be awarded a single point to put into any one of your S.P.E.C.I.A.L. abilities","pw_fallout/perks/intense.png",{
OnGive = function(ply)
  ply:GrantSpecialPoints(1)
  ply:OpenSpecial()
end
})

Fallout_RegisterPerk("Strong Back","p_sb","You gain +50 lbs to the Maximum Weight (WG) of objects that you can carry","pw_fallout/perks/strongback.png",{
})

Fallout_RegisterPerk("Power Armor Training","p_pa","You gain the ability and training to wear Power Armor of any kind","pw_fallout/perks/power.png",{
})

Fallout_RegisterPerk("Trade Merchant","p_tr","You gain the ability to purchase from the global supplier, allowing you to make shop orders.\n\nThis allows you to then re-sell the gear for profit.","pw_fallout/perks/barter.png",{
})

Fallout_RegisterPerk("Intense Training (2)","p_it2","You will be awarded 2 points to put into any of your S.P.E.C.I.A.L. abilities!","pw_fallout/perks/intense.png",{
OnGive = function(ply)
  ply:GrantSpecialPoints(2)
  ply:OpenSpecial()
end
})
---------------------