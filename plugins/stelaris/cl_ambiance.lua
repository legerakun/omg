local Plugin = {}
STELARIS = STELARIS or {}
STELARIS.Tracks = STELARIS.Tracks or {}
--
STELARIS.TimerName = "STELARIS Ambiance"
----------------------------------------------------
function Plugin:Think()
STELARIS.RadiusThink()
if !LocalPlayer():GetCharID() or LocalPlayer():InEditor() then return end
local disabled = false
  if disabled then
    STELARIS.StopTrack()
  return end
local health = LocalPlayer():Health()
  if STELARIS.LastHP and STELARIS.LastHP > health then
    if !STELARIS.Combat then
	  STELARIS.Combat = true
      STELARIS.StopTrack()
	end
	STELARIS.LastCombat = CurTime()
  elseif STELARIS.Combat and STELARIS.LastCombat + STELARIS.CombatTime < CurTime() or STELARIS.Combat and health < 1 then
	STELARIS.StopTrack()
    STELARIS.Combat = false
  end
STELARIS.LastHP = health
--------------
  if STELARIS.CurrentTrack == nil then
    STELARIS.SetNextTrack()
  elseif !timer.Exists(STELARIS.TimerName) then
    STELARIS.PlayTrack()
  end
end

--------------------------------
--STELARIS
function STELARIS.SetVolume(vol)
STELARIS.TrackVol = vol
local track = STELARIS.Sound
  if track != nil then
    track:ChangeVolume(vol/100)
  end
end

function STELARIS.GetRadius()
return STELARIS.Radius
end

function STELARIS.SetRadius(rad)
STELARIS.Radius = rad
  if rad == nil then 
    STELARIS.SetNextTrack()
	STELARIS.PlayTrack()
    return 
  end
STELARIS.SelectRadTrack(true)
end

function STELARIS.GetRadTracks(rad, ignore)
local tracks = STELARIS.Tracks
local selected = {}
--
  for k,v in pairs(tracks) do
    if STELARIS.CurrentTrack == k then continue end
    if v.RadiusName == rad or !ignore and v.IgnoreRad and table.HasValue(v.IgnoreRad, rad) then
	  table.insert(selected, k)
	end
  end
--
return selected
end

function STELARIS.SelectRadTrack(ignore)
local rad = STELARIS.GetRadius()
local selected = STELARIS.GetRadTracks(rad, ignore)
--
local index = table.Random(selected)
STELARIS.CurrentTrack = index
print("[STELARIS]: Set track to RADIUS "..index)
end

function STELARIS.RegisterTrack(name,dir,length,combat,volume,ignore_rad,radname)
if !name or name == "" then return end
--MsgC(Color(0,204,0)."[STELARIS]: Registered Track '"..name.."'")
STELARIS.Tracks[name] = {
  Dir = dir,
  Length = length,
  Combat = combat,
  Volume = volume,
  IgnoreRad = ignore_rad,
  RadiusName = radname
}
end

function STELARIS.CacheTracks()
STELARIS.CachedCombat = STELARIS.CachedCombat or {}
STELARIS.Cached = STELARIS.Cached or {}
  for k,v in pairs(STELARIS.Tracks) do
    if v.RadiusName then continue end
    if v.Combat then
	  table.insert(STELARIS.CachedCombat,k)
	end
  end
  for k,v in pairs(STELARIS.Tracks) do
    if v.RadiusName then continue end
    if !v.Combat then
      table.insert(STELARIS.Cached,k)
	end
  end
end

function STELARIS.SetNextTrack()
local rad = STELARIS.GetRadius()
  if rad and !STELARIS.Combat then
    STELARIS.SelectRadTrack()
	return
  end
--
local selected = nil
  if STELARIS.Combat then
    if !STELARIS.CachedCombat then
	  STELARIS.CacheTracks()
	end
	selected = STELARIS.CachedCombat
  else
    if !STELARIS.Cached then
	  STELARIS.CacheTracks()
	end
	selected = STELARIS.Cached
  end
local index = table.Random(selected)
  if STELARIS.CurrentTrack and STELARIS.CurrentTrack == index then
    STELARIS.SetNextTrack()
  return end
MsgC(Color(204,204,204),"[STELARIS]: Playing Ambiant track: "..index.."\n")
STELARIS.CurrentTrack = index
end

function STELARIS.StopTrack()
timer.Destroy(STELARIS.TimerName)
  if STELARIS.CurrentTrack != nil then
    STELARIS.Sound:Stop()
    STELARIS.CurrentTrack = nil
  end
end

function STELARIS.PlayTrack()
local track = STELARIS.CurrentTrack
if track == nil then return end
--
  if timer.Exists(STELARIS.TimerName) then
    timer.Destroy(STELARIS.TimerName)
  end
  if STELARIS.Sound != nil then
    STELARIS.Sound:Stop()
  end
--
local tbl = STELARIS.Tracks[STELARIS.CurrentTrack]
local volume = STELARIS.TrackVol or tbl.Volume or 75
STELARIS.Sound = CreateSound(LocalPlayer(),tbl.Dir)
STELARIS.Sound:Play()
STELARIS.Sound:ChangeVolume(volume/100)
  timer.Create(STELARIS.TimerName,tbl.Length,1,function()
    STELARIS.CurrentTrack = nil
    STELARIS.Sound:Stop()
  end)
end
--------------------------------
--
concommand.Add("STELARIS_SetTrack",function(ply,cmd,args)
local track = args[1]
if !STELARIS.Tracks[track] then return end
print("[STELARIS]: Setting track to: "..track)
  if STELARIS.Sound then
    STELARIS.Sound:Stop()
  end
STELARIS.CurrentTrack = track
STELARIS.PlayTrack()
end)

concommand.Add("STELARIS_ReCacheSounds",function()
STELARIS.CacheTracks()
end)

return Plugin