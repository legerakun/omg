TOOL.Category = "PigWorks"
TOOL.Name = "Material Finder"
TOOL.Command = nil
TOOL.ConfigName	= nil

if (CLIENT) then
	language.Add("tool.material_finder.name", "Material Finder")
	language.Add("tool.material_finder.desc", "Assists with getting entities materials")
end

function TOOL:LeftClick(trace)
if CLIENT then
    if IsValid(trace.Entity) then
	local str = ""
	  for k,v in pairs(trace.Entity:GetMaterials()) do
	    str = str..""..k.." = "..v..", "
	  end
	  chat.AddText(Schema.GameColor,str)
	else
	  chat.AddText(Schema.GameColor,trace.HitTexture)
	end
  return true
 end
end

function TOOL:RightClick(trace)

end

function TOOL:Allowed()
	return self:GetOwner():IsSuperAdmin()
end