
hook.Add("Think","PlayAmbience",function()
if LocalPlayer().AmbDisabled then return end
if !Schema or !pig then return end
if Schema.AmbVol == nil then return end
if !pig.AmbienceTrack or Schema.AmbienceOff then return end
if AmbientTrack == nil or LastPlayedAmbient != nil and LastPlayedAmbient + Schema.AmbTime < CurTime() then
if AmbientTrack != nil then
AmbientTrack:Stop()
end
local track = table.Random(pig.AmbienceTrack) 
pig.Notify(Color(204,204,0),"Now Playing "..track.Name,3)
AmbientTrack = CreateSound(LocalPlayer(),track.Sound)
LastPlayedAmbient = CurTime()
AmbientTrack:Play()
AmbientTrack:ChangeVolume(Schema.AmbVol)
end
end)
