include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

hook.Add( "KeyPress", "pig_ent_keypress", function( ply, key )
	if ( key == IN_USE ) then
	  local ent = pig.utility.PlayerQuickTrace(ply,110).Entity
	    if IsValid(ent) and pig.utility.IsFunction(ent.Use) then
		  ent.pig_NextUse = ent.pig_NextUse or CurTime() - 1
		  if ent.pig_NextUse <= CurTime() then
		    ent:Use(ply,ply,USE_ON,0)
		    ent.pig_NextUse = CurTime() + 0.5
		  end
		end
	end
end )
