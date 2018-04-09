pig = pig or {}
pig.utility = pig.utility or {}

--Easy way to include add files
function pig.utility.AddFile(name, type)
if type == "sh" or string.find(name, "sh_") then
if SERVER then
AddCSLuaFile(name)
include(name)
else
include(name)
end
print("[PigWorks]: Added "..name)
elseif type == "sv" or SERVER and string.find(name, "sv_") then
include(name)
print("[PigWorks]: Added "..name)
elseif type == "cl" or string.find(name, "cl_") then
if SERVER then
 AddCSLuaFile(name)
 print("[PigWorks]: Added "..name)
else
 include(name)
 print("[PigWorks]: Added "..name)
end
else
if SERVER then
AddCSLuaFile(name)
include(name)
else
include(name)
end
print("[PigWorks]: Added "..name)
end
end

local function IncludeFileDir(dir,original_dir,time)
    time = time or 1
	  if original_dir == nil then
	    original_dir = dir.."/"
	  end
	if time < 1 then time = 1 end
	local matFiles, matFolders = file.Find(dir.."/*", "LUA")
	local mat_dir = ""
	local mat = nil
	for a,b in SortedPairs(matFiles,true) do
	  pig.utility.AddFile(dir.."/"..b)
	  if time > 1 then
	    mat_dir = string.gsub(dir,original_dir,"")
		MsgC(Color(0,204,0),"[PigWorks]: Added Directory file: '"..mat_dir.."/"..b.."'\n")
	  else
	    MsgC(Color(0,204,0),"[PigWorks]: Added Directory file: '"..b.."'\n")
	  end
	end
	for a,b in SortedPairs(matFolders,true) do
	  if dir:find("entities") then
	    pig.IncludeENT(dir.."/"..b,b)
	  else
	    IncludeFileDir(dir.."/"..b,original_dir,time+1)
	  end
	end
end

function pig.utility.IncludeDirectory(folder)
local dir = ""..Schema.folderName.."/"..folder
IncludeFileDir(dir)
end

function pig.utility.PlayerQuickTrace(ply,dist)
  if !dist then
    dist = 4096
  end
local trace = util.TraceLine ({
		start = ply:GetShootPos(),
		endpos = ply:GetShootPos() + ply:GetAimVector() * dist,
		filter = ply,
		mask = MASK_SHOT
  })
return trace
end

function pig.utility.IsFunction(func)
  if type(func) == "function" then
    return true
  end
end

function pig.utility.IsTable(tbl)
  if type(tbl) == "table" then
    return true
  end
end

function pig.utility.IsJSON(json)
if type(json) != "string" then return end
--
  if tonumber(json) != nil or json == true or json == false then
    return
  end
  if json == "true" or json == "false" then
    return
  end
--
local debugs = util.JSONToTable(json)
  if debugs and debugs != nil then
    if pig.utility.IsTable(debugs) then
      return true
    end
  end
end

function pig.utility.PlayerCanSee( self, ent, close )
local max = 4500
local dist = self:GetPos():Distance(ent:GetPos())
	if close then
		if not self:HasLOS( ent ) then 
			return false 
		end
	elseif dist > max then
	  return false
	elseif dist <= 60 then
	  return true
	end

	local fov = self:GetFOV()
	local disp = ent:GetPos() - self:GetPos()
	local dist = disp:Length()
	local size = ent:BoundingRadius() * 0.5
	if CLIENT then
	  if LocalPlayer().ThirdPersonActive then
	    fov = fov + 60
	  end
	end
	
	local MaxCos = math.abs( math.cos( math.acos( dist / math.sqrt( dist * dist + size * size ) ) + fov * ( math.pi / 180 ) ) )
	disp:Normalize()

	if disp:Dot( self:EyeAngles():Forward() ) > MaxCos and ent:GetPos():Distance( self:GetPos() ) < max then
		return true
	end
	
	return false
end

function pig.utility.CheckName( str, accept, deny )
  local bad = false
  local notallowed = {"%","!","£","$","^","*","/","?","{","}"}
    for _,letter in SortedPairs(string.ToTable(str)) do
	  if table.HasValue(notallowed,letter) or tonumber(letter) != nil then
	    bad = true
		break
	  end
	end
  --
  if SERVER then
    local name_sql = sql.Query("SELECT * FROM pw_charvars WHERE varname='Name' AND var="..sql.SQLStr(str))
	if name_sql then
	  bad = true
	end
  end
  --
  if bad or str:len() < Schema.MinimumChar or str:len() > Schema.MaxNameLength or string.sub(str,1,1) == " " then
    if pig.utility.IsFunction(deny) then
	  deny()
	end
	return
  else
    if pig.utility.IsFunction(accept) then
	  accept()
	end
	return true
  end
end

function pig.utility.CheckDescription(str, accept, deny)
  if str:len() < 14 or str:len() > Schema.MaxDescLength or string.sub(str,1,1) == " " then
    if pig.utility.IsFunction(deny) then
	  deny()
	end
  else
    if pig.utility.IsFunction(accept) then
	  accept()
	end
  end
end

function pig.utility.IsFloat(num)
  if math.Round(num) != num then
    return true
  end
end

if CLIENT then

function pig.utility.Render(x,y,drawOver,draw_func)
	render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask( 1 )
    render.SetStencilTestMask( 1 )
    render.SetStencilFailOperation( STENCIL_REPLACE )
    render.SetStencilPassOperation( STENCIL_ZERO )
    render.SetStencilZFailOperation( STENCIL_ZERO )
    render.SetStencilCompareFunction( STENCIL_NEVER )
    render.SetStencilReferenceValue( 1 )
	drawOver()
    render.SetStencilFailOperation( STENCIL_ZERO )
    render.SetStencilPassOperation( STENCIL_REPLACE )
    render.SetStencilZFailOperation( STENCIL_ZERO )
    render.SetStencilCompareFunction( STENCIL_EQUAL ) -- STENCILCOMPARISONFUNCTION_EQUAL will only draw what you draw as the mask.
    render.SetStencilReferenceValue( 1 )
	---------------
	if draw_func then
      draw_func()
	end
	---------------
    render.SetStencilEnable(false)
    render.ClearStencil()
end

function pig.utility.RenderCircle(x,y,rad,draw_func)
	render.ClearStencil()
    render.SetStencilEnable(true)
    render.SetStencilWriteMask( 1 )
    render.SetStencilTestMask( 1 )
    render.SetStencilFailOperation( STENCIL_REPLACE )
    render.SetStencilPassOperation( STENCIL_ZERO )
    render.SetStencilZFailOperation( STENCIL_ZERO )
    render.SetStencilCompareFunction( STENCIL_NEVER )
    render.SetStencilReferenceValue( 1 )
	pig.DrawCircle( x, y, rad, 32, Color(255,255,255) )
    render.SetStencilFailOperation( STENCIL_ZERO )
    render.SetStencilPassOperation( STENCIL_REPLACE )
    render.SetStencilZFailOperation( STENCIL_ZERO )
    render.SetStencilCompareFunction( STENCIL_EQUAL ) -- STENCILCOMPARISONFUNCTION_EQUAL will only draw what you draw as the mask.
    render.SetStencilReferenceValue( 1 )
	---------------
	if draw_func then
      draw_func()
	end
	---------------
    render.SetStencilEnable(false)
    render.ClearStencil()
end

function pig.utility.ShowLoadScreen(time,func)
time = time or 2
  if IsValid(pig.vgui.WaitingScreen) then
    pig.vgui.WaitingScreen:Remove()
  end
pig.vgui.WaitingScreen = vgui.Create("pig_WaitScreen")
local wait = pig.vgui.WaitingScreen
wait:SetCosmetic(true)
wait:SetTime(time,func)
return wait
end

end

if SERVER then

/*
function pig.utility.NetSend( tbl )
  for k,v in pairs(tbl) do
    local pl = v
    net.Send(pl)
  end
end
*/

end
