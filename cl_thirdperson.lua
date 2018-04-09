F_TP = F_TP or {}
F_TP.Dist = F_TP.Dist or 0
F_TP.Rot = false

function Schema.Hooks:pig_ThirdPerson(ply,pos,ang,fov)
  if F_TP.Rot then
    if !F_TP.OldAng then
      F_TP.OldAng = ang
    end
    ang = F_TP.CamAng
	pos = pos - ang:Forward()*(50 + F_TP.Dist)
	return pos, ang
  end
--
local storedpos = pos
  if F_TP.OldAng then
    ang = F_TP.OldAng
	F_TP.OldAng = nil
  end
--
  if !ply:CreatureName() then
    pos = (pos - ang:Forward()* 52 + ang:Up() * 1)
    pos = pos+ang:Right() * 22
  else
    pos = pos+ang:Right() * 50+ang:Up()*35-ang:Forward()*40
	local view = GetCreature(ply:CreatureName()).View
	local back = nil
	local up = nil
	local right = nil
	if view then
	  back = view.Back
	  up = view.Up
	  right = view.Right
	end
	if back then
	  pos = pos+ang:Forward()*back
	end
	if up then
	  pos = pos+ang:Up()*up
	end	
	if right then
	  pos = pos+ang:Right()*right
	end
  end
--
return pos,ang
end

function Schema.Hooks:InputMouseApply( )
  if F_TP.Rot then
    return true
  end
end

function Schema.Hooks:CreateMove( cmd )
if !LocalPlayer().ThirdPersonActive then return end
local focus = vgui.GetKeyboardFocus()
if IsValid( focus ) or gui.IsGameUIVisible() or gui.IsConsoleVisible() then return end
--
  if input.IsKeyDown(KEY_G) then
      if !F_TP.Rot then
        F_TP.Rot = true
		local p_ang = LocalPlayer():GetAngles()
		F_TP.CamAng = Angle(0,p_ang.y,0)
	  end
	--
		local dMx = cmd:GetMouseX( ) / 25;
		local dMy = cmd:GetMouseY( ) / 22;

		local cameraAngles = F_TP.CamAng
		local cameraDistance = F_TP.Dist;

		cameraAngles.y = math.NormalizeAngle( cameraAngles.y - dMx );
		cameraAngles.p = math.NormalizeAngle( cameraAngles.p + dMy );		
		cameraAngles.r = 0;

		F_TP.CamAng = cameraAngles
		local dist = cameraDistance;
		F_TP.Dist = math.Clamp( dist - cmd:GetMouseWheel( ) * 5, 0, 50 )
	return true;
	--
	elseif F_TP.Rot then
	  F_TP.Rot = false
	end
end
