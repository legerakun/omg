print("Initializing Third Person")


function GM:CalcView(ply, pos, angles, fov)
local view = {}
view.origin = pos
view.angles = angles
view.fov = fov

  local Weapon = ply:GetActiveWeapon()
	if ( IsValid( Weapon ) ) then
		local func = Weapon.CalcView
		if ( func ) then
			view.origin, view.angles, view.fov = func( Weapon, ply, pos * 1, angles * 1, fov )
		end
	end

	if ply.ThirdPersonActive then
      view = self:CalcThirdPerson(view, pos, angles, fov)
    end
return view
end

function GM:CalcThirdPerson(view,pos,angles,fov)
local ply = LocalPlayer()
if ply:Health() <= 0 then return view end
local n_pos,n_ang,n_fov = hook.Call("pig_ThirdPerson",GAMEMODE,ply,view.origin,view.angles,view.fov)	
local ang = n_ang or angles

		local tr = util.TraceLine( {
			start = pos,
			endpos = n_pos or (pos-(ang:Forward()*70)),
			filter = ply
		} )
  view.origin = tr.HitPos
  if ply:Crouching() then
    view.origin = view.origin + ang:Up()*15
  end
view.angles = n_ang or view.angles
view.fov = n_fov or view.fov
return view
end

hook.Add( "ShouldDrawLocalPlayer", "PW_DrawLocalPlayer", function( ply )
local seq = LocalPlayer():GetOverride()
  if seq then
    LocalPlayer().ThirdPersonActive = true
  end
if !LocalPlayer().ThirdPersonActive or !LocalPlayer():Alive() then return end
	return true
end)

