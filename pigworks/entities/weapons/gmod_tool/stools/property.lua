TOOL.Category = "PigWorks"
TOOL.Name = "ENT ID Finder"
TOOL.Command = nil
TOOL.ConfigName	= nil

if (CLIENT) then
	language.Add("tool.property.name", "ENT ID Finder")
	language.Add("tool.property.desc", "Assists with getting ENT ID")
end

function TOOL:LeftClick(trace)
  if SERVER then
    if IsValid(trace.Entity) then
	  MsgC(Color(204,204,0),"[ENT ID] ["..trace.Entity:GetClass().."]: "..trace.Entity:MapCreationID().."\nVector("..tostring(trace.Entity:GetPos())..")  Angle("..tostring(trace.Entity:GetAngles())..")\n")
	elseif trace.HitWorld then
	  MsgC(Color(204,204,0),"[ENT ID]: nil\nVector("..tostring(trace.HitPos)..")  Player Angle("..tostring(self:GetOwner():GetAngles())..")\n")
	end
  else
    chat.AddText(Color(204,204,0),"Added ID to Console")
  end
return true
end

function TOOL:RightClick(trace)
  if SERVER then
    if IsValid(trace.Entity) then
	  PrintTable(trace.Entity:GetKeyValues())
	end
  else
    chat.AddText(Color(204,204,0),"Added ENT Key Values to Console")
  end
return true
end

function TOOL:Allowed()
	return self:GetOwner():IsSuperAdmin()
end