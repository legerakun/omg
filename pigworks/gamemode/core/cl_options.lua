print("[Pigworks OPTIONS]: Initialised Client file")
pig.Options = pig.Options or {}
pig.OptionTbl = {}
local op = pig.OptionTbl
op[1] = {
  OpName = "Toggle ThirdPerson",
  LoadFunc = function()
    local val = pig.GetOption("ThirdPerson")
	LocalPlayer().ThirdPersonActive = val
  end,
  OpFunc = function()
	local val = LocalPlayer().ThirdPersonActive
    if !val then
      LocalPlayer().ThirdPersonActive = true
      pig.Notify(Schema.GameColor,"ThirdPerson is now: Enabled",2,"PigFont")
    else
      LocalPlayer().ThirdPersonActive = false
      pig.Notify(Schema.GameColor,"ThirdPerson is now: Disabled",2,"PigFont")
    end
	pig.SetOption("ThirdPerson", LocalPlayer().ThirdPersonActive)
end
}
--
-----------------

function pig.LoadOptions()
local gm = GAMEMODE or GM or pig
local name = string.gsub(gm.Name:lower(), ":", "")
local dir = "pigworks/"..name.."/options.txt"
local options = file.Find(dir, "DATA")

local tbl = nil
  if options[1] then
    --options = file.Open(dir, "r", "DATA")
	options = file.Read(dir, "DATA")
	if options then
	  tbl = util.JSONToTable(options)
	else
	  print("[Pigworks OPTIONS]: Couldn't convert '"..dir.."'! Creating a fresh options file")    
	  return
	end
	print("[Pigworks OPTIONS]: Loaded "..name.." options file")
  else
	print("[Pigworks OPTIONS]: Unable to locate '"..dir.."'! Creating a fresh options file")    
  end
  
  if tbl then
    pig.Options = tbl
	for k,v in pairs(pig.OptionTbl) do
	  if !v.LoadFunc then continue end
	  v.LoadFunc()
	end
  end
end
concommand.Add("PW_LoadOptions", pig.LoadOptions)

function pig.SaveOptions()
local gm = GAMEMODE or GM or pig
local name = string.gsub(gm.Name:lower(), ":", "")
local dir = "pigworks/"..name.."/options.txt"
local options = file.Find(dir, "DATA")

  if !options[1] then
    file.CreateDir("pigworks/"..name)
  end
  
local tbl = util.TableToJSON(pig.Options)
file.Write(dir, tbl)
print("[Pigworks OPTIONS]: Saved options for client")
end
concommand.Add("PW_SaveOptions", pig.SaveOptions)

function pig.SetOption(name, val)
pig.Options[name] = val
end

function pig.GetOption(name)
return pig.Options[name]
end

--
hook.Add("InitPostEntity", "PigOptionsLoad", pig.LoadOptions)