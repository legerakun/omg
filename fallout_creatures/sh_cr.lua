FalloutCreatures = FalloutCreatures or {}
local char = FindMetaTable("Player")

function AddCreature(name,mdl,swep_tbl,body,footstep,speeds,animset,dt,view)
  FalloutCreatures[name] = {
  Model = mdl,
  SWEPS = swep_tbl,
  Bodygroups = body,
  Footsteps = footstep,
  Speeds = speeds,
  AnimSet = animset,
  DamageThresh = dt,
  View = view
  }
end

function GetCreature(name)
return FalloutCreatures[name]
end
-----------------
--CHAR
function char:CreatureName()
local name = self:GetNWString("CreatureName")
if !name or name == "" then return end
return name
end
