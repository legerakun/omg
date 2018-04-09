
function Schema.Hooks:PlayerFootstep( ply, pos, foot, sound, volume, rf )
	ply:EmitSound( sound,75,100,volume )
	if ply:WearingPowerArmor() then
      local selected = math.random(1,3)
	  if ply == LocalPlayer() then
	    volume = math.Clamp(volume,0,0.4)
	  else
	    volume = volume*1.125
	  end
	  ply:EmitSound( "foot/foot_"..foot.."_"..selected..".mp3",85,100,volume )
	elseif ply:GetOutfit() and ply:GetOutfit():find("Metal") or ply:GetOutfit() and ply:GetOutfit():find("Legate") then
	  local selected = math.random(1,3)
	  ply:EmitSound( "foot/metal_"..foot.."_"..selected..".mp3",85,100,volume )	  
	elseif ply:CreatureName() then
	  local name = ply:CreatureName()
	  local footstep = GetCreature(name).Footsteps
	  local selected = math.random(1,#footstep)
	  --
	    if foot == 0 then
		  footstep = footstep.left[selected]
	    else
		  footstep = footstep.right[selected]
		end
	  ply:EmitSound( footstep,75,100,volume )
    end
return true
end
