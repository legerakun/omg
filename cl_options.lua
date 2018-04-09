-----------------------------
--Options
-----------
local op = pig.OptionTbl
op[1] = {
  OpName = "Toggle Third Person",
  LoadFunc = function()
    local val = pig.GetOption("ThirdPerson")
	LocalPlayer().ThirdPersonActive = val
  end,
  OpFunc = function()
	local val = LocalPlayer().ThirdPersonActive
    if !val then
      LocalPlayer().ThirdPersonActive = true
	  FalloutTutorial("Third Person")
      pig.Notify(Schema.GameColor,"ThirdPerson is now: Enabled",2,"PigFont")
    else
      LocalPlayer().ThirdPersonActive = false
      pig.Notify(Schema.GameColor,"ThirdPerson is now: Disabled",2,"PigFont")
    end
	pig.SetOption("ThirdPerson", LocalPlayer().ThirdPersonActive)
end
}

op[2] = {
  OpName = "Ambiance Volume",
  Slider = true,
  Max = 100,
  LoadFunc = function()
    local val = pig.GetOption("Ambiance") or 1
	STELARIS.SetVolume(val)
  end,
  SetFunc = function()
    local option = pig.GetOption("Ambiance")
	if !option then
	  return 75
	else
	  return option
	end
  end,
  OpFunc = function(val)
    pig.SetOption("Ambiance", math.Round(val))
	STELARIS.SetVolume(val)
  end
}

op[3] = {
  OpName = "Hotbar Alpha",
  Slider = true,
  Max = 255,
  SetFunc = function()
    local option = pig.GetOption("HotbarAlpha")
	if !option then
	  return 100
	else
	  return option
	end
  end,
  OpFunc = function(val)
    pig.SetOption("HotbarAlpha", math.Round(val))
  end
}

op[4] = {
  OpName = "Amber UI Colour",
  LoadFunc = function()
    local col = pig.GetOption("GameColor")
	if col and Schema.GameColor != col then
	  Schema.GameColor = col
	end
  end,
  OpFunc = function()
    local col = Color(246,178,68)
	Schema.GameColor = col
	pig.SetOption("GameColor", col)
  end
}

op[5] = {
  OpName = "Blue UI Colour",
  LoadFunc = function()
    local col = pig.GetOption("GameColor") or Schema.GameColor
	if col and Schema.GameColor != col then
	  Schema.GameColor = col
	end
  end,
  OpFunc = function()
    local col = Color(87, 184, 216)
	Schema.GameColor = col
	pig.SetOption("GameColor", col)
  end
}

op[6] = {
  OpName = "Green UI Colour",
  LoadFunc = function()
    local col = pig.GetOption("GameColor") or Schema.GameColor
	if col and Schema.GameColor != col then
	  Schema.GameColor = col
	end
  end,
  OpFunc = function()
    local col = Color(45, 230, 132)
	Schema.GameColor = col
	pig.SetOption("GameColor", col)
  end
}

op[7] = {
  OpName = "White UI Colour",
  LoadFunc = function()
    local col = pig.GetOption("GameColor") or Schema.GameColor
	if col and Schema.GameColor != col then
	  Schema.GameColor = col
	end
  end,
  OpFunc = function()
    local col = Color(240, 240, 240)
	Schema.GameColor = col
	pig.SetOption("GameColor", col)
  end
}

op[8] = {
  OpName = "Chat Time-Stamps",
  OpFunc = function()
    local op = pig.GetOption("TimeStamp") or true
	if op then
	  pig.Notify(Schema.GameColor, "Chat Time-Stamps now disabled", 0.8)
	  pig.SetOption("TimeStamp", false)
	else
	  pig.Notify(Schema.GameColor, "Chat Time-Stamps now enabled", 0.8)	
	  pig.SetOption("TimeStamp", true)
	end
  end
}

op[9] = {
  OpName = "Mojave Radio",
  OpFunc = function()
    pig.Notify(Schema.GameColor, "Radio now set to Mojave Radio!", 2)
	pig.SetOption("RadioURL", "MR")
	--
	for k,v in pairs(ents.FindByClass("fallout_radio")) do
	  v.SoundValid = false
	end
  end
}

op[10] = {
  OpName = "Galaxy News Radio",
  OpFunc = function()
    pig.Notify(Schema.GameColor, "Radio now set to Galaxy News Radio!", 2)
	pig.SetOption("RadioURL", "GN")
	--
	for k,v in pairs(ents.FindByClass("fallout_radio")) do
	  v.SoundValid = false
	end
  end
}

op[11] = {
  OpName = "Liberty Radio",
  OpFunc = function()
    pig.Notify(Schema.GameColor, "Radio now set to Galaxy News Radio!", 2)
	pig.SetOption("RadioURL", "LR")
	--
	for k,v in pairs(ents.FindByClass("fallout_radio")) do
	  v.SoundValid = false
	end
  end
}

op[12] = {
  OpName = "Toggle HUD",
  OpFunc = function()
    if !LocalPlayer():IsModerator() then
	  pig.Notify(Schema.GameColor, "This feature will be available in the next update", 2)
	  return
	end
    local bool = pig.GetOption("NoHUD") or false
	if bool then
      pig.SetOption("NoHUD", false)
	  pig.Notify(Schema.GameColor, "The HUD is now enabled", 2)
	else
	  pig.SetOption("NoHUD", true)
	  pig.Notify(Schema.GameColor, "The HUD is now disabled", 2)
	end
  end
}