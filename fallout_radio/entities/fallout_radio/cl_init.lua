include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
local ply = LocalPlayer()
local dist = ply:GetPos():Distance(self:GetPos())
local maxdist = 600
local maxvol = 0.5
local index = pig.GetOption("RadioURL") or "GN"
--
if dist >= maxdist then return end
--
  if !self.SoundValid and !IsValid(self.RadioSound) then
    self.SoundValid = true
	chat.AddText(Schema.GameColor, "[Radio]: Creating new Stream..")
    local tbl = {}
	tbl["GN"] = "http://46.101.243.245:8000/falloutfm2.ogg"
	tbl["MR"] = "https://www.atlas-5.site/radio_001/"
	tbl["LR"] = "https://www.atlas-5.site/radio_002/"
	local url = tbl[index]
	--
	if IsValid(ply.RadioSound) then
	  ply.RadioSound:Stop()
	end
	--
    sound.PlayURL(url, "", function(sound, errorid, errorname)
	  if !IsValid(sound) then 
	    chat.AddText(Schema.GameColor, "[ERROR "..(errorid or "???").."]: "..(errorname or "Unknown Error").."! Unable to play radio!")
	  return end
	  ply.RadioSound = sound
	  sound:Play()
	  sound:SetVolume(maxvol)
	end)
  return end
-- -- -- --
local sound = ply.RadioSound
if !IsValid(sound) then return end
local volume = maxvol - (maxvol*(dist/maxdist))
sound:SetVolume(math.Clamp(volume,0,1))
end

function ENT:OnRemove()
local ply = LocalPlayer()
  if IsValid(ply.RadioSound) then
    ply.RadioSound:SetVolume(0)
  end
end
