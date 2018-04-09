DeriveGamemode("pigworks");
pig.InitSchema()
include("shared.lua")
include("cl_falloutskin.lua")

--
sound.URLChannels = sound.URLChannels or {}
pig.OldSoundURL = pig.OldSoundURL or sound.PlayURL

function sound.PlayURL(url, flags, callback)
  pig.OldSoundURL(url, flags, function(channel, errorID, errorName)
    callback(channel, errorID, errorName)
	table.insert(sound.URLChannels, channel)
  end)
end

function sound.RemoveURLSounds()
  for k,v in pairs(sound.URLChannels) do
    if v != nil then
	  v:Stop()
	end
	sound.URLChannels[k] = nil
  end
end

RunConsoleCommand("cl_jiggle_bone_framerate_cutoff", "0")