local Plugin = {}
local delay = 2.5
STELARIS = STELARIS or {}
STELARIS.RadiusVecs = STELARIS.RadiusVecs or {}
--------------------------
------

function STELARIS.RadiusThink()
STELARIS.NextRadius = STELARIS.NextRadius or CurTime() + (delay*2)
if STELARIS.NextRadius > CurTime() or STELARIS.Combat then return end
STELARIS.NextRadius = CurTime() + delay
--
local ply = LocalPlayer()
local pos = ply:GetPos()
local tbl = STELARIS.RadiusVecs
if !tbl then return end
  for k,v in pairs(tbl) do
    if STELARIS.Entered and STELARIS.Entered != k then continue end
    local dist = pos:Distance(v.Vec)
    local radius = v.Rad
    if dist > radius then
      if STELARIS.Entered then
	    STELARIS.SetRadius(nil)
	    STELARIS.Entered = nil
		print("[STELARIS]: Resetting Radius..")
	  end
      continue
    end
	-- -- --
	local diff = (pos.z - v.Vec.z)
	if diff < -500 or diff > 0 and diff > 500 then
	  if STELARIS.Entered then
	    STELARIS.SetRadius(nil)
	    STELARIS.Entered = nil
		print("[STELARIS]: Resetting Radius..")
	  end
	  continue
	end

    local myrad = k
    local rad = STELARIS.GetRadius()
    if rad != myrad and !STELARIS.Entered then
      STELARIS.SetRadius(myrad)
	  STELARIS.PlayTrack()
	  STELARIS.Entered = k
    end
  end
end

return Plugin