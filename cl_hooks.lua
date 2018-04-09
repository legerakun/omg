
function Schema.Hooks:Think()
FCLThink()
PipBoy3000.Think()
--VATS_Think()
end

function Schema.Hooks:PostDrawOpaqueRenderables()
--VATS_Renderables()
end

function Schema.Hooks:PlayerBindPress(ply,bind,pressed)
--VATS_Bind(ply,bind,pressed)
end

function Schema.Hooks:pig_HUDPaintOnTop()
FalloutSavePaint()
AdminNoClip()
if pig.GetOption("NoHUD") then return end
FalloutHPPaint()
FalloutAPPaint()
--VATS_HUDPaint()
end

function Schema.Hooks:CalcView(ply,pos,ang,fov)
--local view = VATS_CalcView(ply,pos,ang,fov)
--
--return view
end

function Schema.Hooks:pig_Cl_SelectedChar(id)
LocalPlayer().TradeOffers = nil
Fallout_SPECIALCharSel(id)
--VATS_SelChar()
end

function Schema.Hooks:pig_ChatBoxOpen()
FalloutTutorial("Chatbox")
end

--------------------------
--CORE HOOKS
function Schema.Hooks:pig_ClientInvUpdated(index)
  if IsValid(PipBoy3000.Base) then
    local elements = PipBoy3000.Base.Elements
	for k,v in pairs(elements) do
	  if v.SortFList then
	    v:SortFList()
	  end
	end
  end
end

function Schema.Hooks:InitPostEntity()
local load_theme = CreateSound( LocalPlayer(), "nv_ambiant/end_slide.mp3")
--
  concommand.Add("PW_SkipCache", function()
    timer.Destroy("PigWorksLoad")
	load_theme:Stop()
	pig.FinishedLoading = true
  end)
-------------------------
-------------------------
-------------------------
--PLAY THEME
  load_theme:Play()
  load_theme:ChangeVolume(1)
-------------------------
  local model_cache = {}
  for k,v in pairs(Fallout_Outfits) do
    if type(v.Model) == "table" then
      for a,b in pairs(v.Model) do
        table.insert(model_cache, b)
	  end
	else
	  table.insert(model_cache, v.Model)
	end
    table.insert(model_cache, v.Ent_Model)	
  end
  
  for k,v in pairs(Fallout_HairStyles()) do
    table.insert(model_cache, v)
  end
  for k,v in pairs(Fallout_FacHairStyles()) do
    table.insert(model_cache, v)
  end
  local mdl_index = 1
  
  local weapons = file.Find("models/fallout/weapons/*", "GAME")
  for k,v in pairs(weapons) do
    table.insert(model_cache, "models/fallout/weapons/"..v)
  end
  --
  local sound_index = 1
  local sound_cache = {}
  local music = file.Find("sound/nv_ambiant/*", "GAME")
  local ui = file.Find("sound/ui/*", "GAME")
  for k,v in pairs(music) do
    table.insert(sound_cache, "sound/nv_ambiant/"..v)
  end
  for k,v in pairs(ui) do
    table.insert(sound_cache, "sound/ui/"..v)
  end  
  
  local _, wep_folders = file.Find("sound/wep/*", "GAME")
  for k,v in pairs(wep_folders) do
    local files = file.Find("sound/wep/"..v.."/*", "GAME")
	for a,b in pairs(files) do
	  table.insert(sound_cache, "sound/wep/"..v.."/"..b)
	end
  end
  ---------------------------
  local mdl_amt = table.Count(model_cache)
  local sound_count = table.Count(sound_cache)
  timer.Create("PigWorksLoad", 0.05, 0, function()
    if !LocalPlayer():InEditor() then 
	  timer.Destroy("PigWorksLoad")
	  pig.FinishedLoading = true
	  load_theme:Stop()
	  return
	end
    local model = model_cache[mdl_index]
	local sound = sound_cache[sound_index]
	local str =  "Please wait while "..GAMEMODE.Name.." is loading, it should be complete soon.\n"
	--
    if model then
	  util.PrecacheModel( model )
	  str = str.."PreCaching player models.. "..math.Round((mdl_index/mdl_amt)*100) .."%"
	  mdl_index = mdl_index + 1
	elseif sound then
      util.PrecacheSound( sound )
	  str = str.."PreCaching sound files.. "..math.Round((sound_index/sound_count)*100 ).."%"
	  sound_index = sound_index + 1
	end
	--
	if !sound and !model then
	  load_theme:Stop()
	  pig.FinishedLoading = true
	  timer.Destroy("PigWorksLoad")
	elseif str then
	  local wait = pig.vgui.WaitingScreen
	  if IsValid(wait) then
	    wait.LoadText = str
	  end
	end
  end)
end
