--local Plugin = Plugin or {}
PipBoy3000 = PipBoy3000 or {}
PipBoy3000.Mat = Material("pipboy/mains.png")
PipBoy3000.Pimp = Material("pipboy/pimp.png")
PipBoy3000.ScrMat = Material("pipboy/screen2.png")
PipBoy3000.ScrMat2 = Material("pipboy/screen.png")
PipBoy3000.ScrBack = Material("pipboy/screenglare.png")
PipBoy3000.Scanlines = Material("gui/gradient_up")
PipBoy3000.Terminal = Material("pipboy/terminal.png", "smooth noclamp")
PipBoy3000.CursorMat = Material("ui/facursor.png")
PipBoy3000.ButtonMat = Material("pipboy/pip_but.png", "smooth noclamp")
--------------------------
--CONFIGS
PipBoy3000.Key = KEY_F
PipBoy3000.KeyR = KEY_E
PipBoy3000.KeyL = KEY_Q
PipBoy3000.ScanTime = 4.4
--------------------------
function PipBoy3000.Think()
PipBoy3000.NextOpen = PipBoy3000.NextOpen or CurTime() - 1
  if PipBoy3000.NextOpen <= CurTime() and pig.IsKeyPressed(PipBoy3000.Key) then
    PipBoy3000.NextOpen = CurTime()+0.35
    local focus = vgui.GetKeyboardFocus()
    if IsValid( focus ) then return end
    local ply = LocalPlayer()
	if ply:HasInvItem("PipBoy 3000") then
	  UseItem("PipBoy 3000")
	else
	  UseItem("PipBoy 2500")
	end
  end
end

concommand.Add("PipBoy3000_Remove",function()
local pip = PipBoy3000.Base
pip:Remove()
end)
	
------------------
--CORE
------------------
function PipBoy3000.IsBuilt()
if IsValid(PipBoy3000.Base) then
return true
end
end

function PipBoy3000.ScreenColor()
local col = Schema.GameColor
return Color(col.r,col.g,col.b,40)
end

---
function PipBoy3000.SortFonts(dimension)
local reg_size = 22
local small_size = 18
local info_size = 20
--
local pip = LocalPlayer():GetActiveWeapon()
  if dimension != "2d" and IsValid(pip) and pip:GetClass() == "fo3_pipboy3000" then
    reg_size = 24
    small_size = 20
    info_size = 21
  end
--
  if dimension == "2d" then
    reg_size = ScreenScale(8)
	small_size = ScreenScale(6)
	info_size = ScreenScale(7.85)
  end

surface.CreateFont( "FO3FontPip",
{
		font      = "monofonto",
		size      = reg_size,
		weight    = 10,
		underline = 0,
		additive  = true,
		outline = false,
		antialias = true,
		blursize = 0
	})	
surface.CreateFont( "FO3FontPipSmall",
{
		font      = "monofonto",
		size      = small_size,
		weight    = 10,
		underline = 0,
		additive  = true,
		outline = false,
		antialias = true,
		blursize = 0
	})
surface.CreateFont( "FO3FontPipInfo",
{
		font      = "monofonto",
		size      = info_size,
		weight    = 10,
		underline = 0,
		additive  = true,
		outline = false,
		antialias = true,
		blursize = 0
	})	
end

function PipBoy3000.Build(time,width,height,dimension)
dimension = dimension or "2d"
if IsValid(PipBoy3000.Base) then PipBoy3000.Base:Remove() end
if LocalPlayer().PipOpenSound != nil then LocalPlayer().PipOpenSound:Stop() end
LocalPlayer().PipOpenSound = CreateSound(LocalPlayer(),"ui/ui_pipboy_access_up.mp3")
local sound = LocalPlayer().PipOpenSound
sound:Play()
sound:ChangeVolume(0.8)
--
PipBoy3000.SortFonts(dimension)
--
PipBoy3000.Base = vgui.Create("DFrame")
local pip = PipBoy3000.Base
local col = Schema.GameColor
pip:SetTitle("")
pip:MakePopup()
pip:SetSize(ScrW(),ScrH())
pip.Paint = function() return end
pip:ShowCloseButton(false)
  pip.Think = function(me)
    if PipBoy3000.NextOpen > CurTime() then return end
    if input.IsKeyDown(PipBoy3000.Key) and !me.Startup then
      if LocalPlayer().PipHum != nil then LocalPlayer().PipHum:Stop() end
      PipBoy3000.Close()
      PipBoy3000.NextOpen = CurTime() + 0.35
    elseif input.IsKeyDown(PipBoy3000.KeyR) and !me.Startup then
      PipBoy3000.Open3DMode("right")
    elseif input.IsKeyDown(PipBoy3000.KeyL) and !me.Startup then
      PipBoy3000.Open3DMode("left")
    return end
    me.NextHum = me.NextHum or CurTime() - 1
    if me.NextHum > CurTime() or me.Startup then return end
    me.NextHum = CurTime() + 2
    if LocalPlayer().PipHum != nil then LocalPlayer().PipHum:Stop() end
    LocalPlayer().PipHum = CreateSound(LocalPlayer(),"ui/ui_pipboy_hum.mp3")
    LocalPlayer().PipHum:Play()
    LocalPlayer().PipHum:ChangeVolume(0.76)
  end
pip.Tabs = {}
  pip.PaintOver = function(me)
    local mat = PipBoy3000.Mat
    surface.SetDrawColor(255,255,255)
    surface.SetMaterial(mat)
    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
  end
pip:SetDraggable(false)
  if time and time > 0 or !time then
    timer.Simple(time or PipBoy3000.StartTime,function()
      PipBoy3000.MakeScreen(pip,width,height)
    end)
  else
    PipBoy3000.MakeScreen(pip,width,height,nil, nil, dimension)
  end
return PipBoy3000.Base
end

function PipBoy3000.Build3D(width,height)
local pip = PipBoy3000.Build(0,width,height,"3d")
pip.Draw3D = true
pip.Paint = function()
draw.RoundedBox(0,0,0,width,height,Color(0,0,0))
end
pip.PaintOver = function(me)
  if me.MouseNoDraw then return end 
  surface.SetDrawColor(255,255,255)
  surface.SetMaterial(Material("ui/facursor.png"))
  local xm = gui.MouseX()
  local ym = gui.MouseY()
  surface.DrawTexturedRect(xm,ym,width*.032,width*.032)
end
pip.OnRemove = function(me)
  surface.DrawOutlinedRect = PipBoy3000.DrawOutlinedRect
end
--
pip:SetPos(0,0)
pip:SetSize(width,height)
pip.Screen:SetPos(0,0)
pip.Screen.Think = function(me)
  if !IsValid(me:GetParent()) then me:Remove() end
  if input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT) then
	for pnl in pairs( InputWindowsTbl() ) do
		if ( IsValid( pnl ) ) then
			origin = pnl.Origin
			scale = pnl.Scale
			angle = pnl.Angle
			normal = pnl.Normal

			local key = input.IsKeyDown(KEY_LSHIFT) and MOUSE_RIGHT or MOUSE_LEFT
				
			WindowPostPanelEvent( pnl, "OnMousePressed", key )
		end
	end
  end
end
---------
local legacy = surface.DrawOutlinedRect
PipBoy3000.DrawOutlinedRect = legacy
--
  function surface.DrawOutlinedRect(x,y,w,h)
    legacy(x,y,w,h)
	local thick = 0
	if thick == 0 then return end
	for i=1,thick do
	  legacy(x + i, y + i, w - (i*2), h - (i*2))
	end
  end
---------
return pip
end

function PipBoy3000.Close()
local pip = PipBoy3000.Base
if LocalPlayer().PipOpenSound != nil then LocalPlayer().PipOpenSound:Stop() end
LocalPlayer().PipOpenSound = CreateSound(LocalPlayer(),"ui/ui_pipboy_access_down.mp3")
local sound = LocalPlayer().PipOpenSound
sound:Play()
sound:ChangeVolume(1)
--
pip.Screen:Remove()
--
pip.Startup = true
--
  if IsValid(pip) then
    pip:Remove()
	FalloutHUDHide = false
  end
RunConsoleCommand("+attack2")
  timer.Simple(0.1,function()
    RunConsoleCommand("-attack2")
  end)
--
end

function PipBoy3000.MakeScreen(pip,width,height,xp,yp,dimension)
if !IsValid(pip) then return end
pip.Startup = false
-----------------------------
--Screen
pip.Screen = vgui.Create("DFrame",pip)
local screen = pip.Screen
screen:SetSize(width or pip:GetWide() *.41,height or pip:GetTall() *.54)
screen:SetPos(xp or pip:GetWide() *.275,yp or pip:GetTall() *.072)
screen:SetDraggable(false)
screen:ShowCloseButton(false)
screen:SetTitle("")
  if pip.Draw3D then
    screen:SetCursor("blank")
  end
-----------------------------------------
--PAINT FUNCS
local tbl = pip.Tabs
local x = nil
local y = nil
local w = nil
local h = nil
local length = nil
local next = nil
local next_x = nil
local next_y = nil
local e_y = nil
--
screen.Paint = function(me)
local col = Schema.GameColor
surface.SetDrawColor(255,255,255,255)
surface.SetMaterial(PipBoy3000.ScrBack)
surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
-------------------------
for k,v in pairs(tbl) do
next = tbl[k + 1]
if !next or !IsValid(v) then break end
x,y = v:GetPos()
if !x or !y then continue end
w,h = v:GetSize()
next_x,next_y = next:GetPos()
--
x = x + w
y = y + (h / 2) - 3
length = next_x - x
Fallout_Line(x ,y,"right",length,true,col)
end
-------------------------------
--BOTTOM LINES
--------
--LEFT
length = me:GetWide() *(PipBoy3000.StartPos.x *.45)
x = (me:GetWide() * PipBoy3000.StartPos.x) - length
y = y or (me:GetTall() - 3)
e_y = y
Fallout_Line(x ,y,"right",length,true,col)
length = me:GetTall() *.075
y = y - length
Fallout_Line(x,y + 3,"up",length,false,col)
----------
--RIGHT
x = me:GetWide() - (me:GetWide() *PipBoy3000.StartPos.x)
length = me:GetWide() *(PipBoy3000.StartPos.x *.45)
Fallout_Line(x - 3,e_y,"right",length,true,col)
Fallout_Line(x - 6 + length,y + 3,"up",me:GetTall() *.075,false,col)
--------------------------------
--TOP LINES-------------
---------
--LEFT
length = me:GetWide() *(PipBoy3000.StartPos.x *.45)
x = (me:GetWide() * PipBoy3000.StartPos.x) - length
y = (me:GetTall() *.0875)
Fallout_Line(x,y,"right",length,true,col)
Fallout_Line(x,y,"down",me:GetTall() *.075,false,col)
--
local title = pip.Title or ""
surface.SetFont("FO3FontBig")
local text_w,text_h = surface.GetTextSize(title)
draw.DrawText(title,"FO3FontBig",x + (length *1.25),y-(text_h / 2),col,TEXT_ALIGN_LEFT)
--------
--RIGHT
local func = me.PaintFunc
if pig.utility.IsFunction(func) then
func(me,x + (length *1.25) + text_w,y)
end
--
end
screen.PaintOver = function(me)
local col = Schema.GameColor
local h = me:GetTall()*1.1
local w = me:GetWide()*1.1
--------------------------
PipBoy3000.Scan(me)
------------------------------
surface.SetDrawColor(Color(col.r*.425,col.g*.425,col.b*.425,95))
surface.SetMaterial(PipBoy3000.Terminal)
surface.DrawTexturedRect(me:GetWide()/2-(w/2),me:GetTall()/2-(h/2),w,h)
/*
--
surface.SetDrawColor(Color(col.r,col.g,col.b,100))
surface.SetMaterial(PipBoy3000.ScrMat2)
surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
--
surface.SetDrawColor(PipBoy3000.ScreenColor())
surface.SetMaterial(PipBoy3000.ScrMat)
surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
*/
end
---------------------------------------
---------------------------------------
PipBoy3000.BuildModes(dimension)
  if PipBoy3000.SavedMode then
    local mode = PipBoy3000.SavedMode
    local tbl = {}
	tbl["STATS"] = PipBoy3000.OpenStats
	tbl["ITEMS"] = PipBoy3000.OpenItems
	tbl["DATA"] = PipBoy3000.OpenData
	--
	tbl[mode]()
  else
    PipBoy3000.OpenStats()
  end
end
-------------------
--MODE
function PipBoy3000.BuildModes(dimension)
local pip = PipBoy3000.Base
--
local x = pip:GetWide() *.4725
local y = pip:GetTall() *.84
local spacing = pip:GetWide() *.074
local w = pip:GetWide() *.06
local h = pip:GetTall() *.09
local showtime = CurTime()+0.4
--
local but1 = vgui.Create("DButton",pip)
but1:SetSize(w,h)
but1:SetPos(x - (w / 2),y)
--but1:SetDrawOnTop(true)
but1:SetText("")
but1:SetDrawOnTop(true)
but1.Paint = function(me)
if pip.Title != "STATS" or pip.Startup or showtime > CurTime() then return end
surface.SetDrawColor(255,255,255,10)
surface.SetMaterial(PipBoy3000.ButtonMat)
surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
end
but1.DoClick = function(me)
for k,v in pairs(PipBoy3000.Base.Tabs) do v:Remove()
pip.Tabs[k] = nil
end
PipBoy3000.ModeSound()
PipBoy3000.OpenStats(true)
end
--
local but2 = vgui.Create("DButton",pip)
but2:SetSize(w,h)
but2:SetPos(x - (w / 2) + (spacing),y)
but2:SetDrawOnTop(true)
but2:SetText("")
but2.Paint = function(me)
if pip.Title != "ITEMS" or pip.Startup or showtime > CurTime() then return end
surface.SetDrawColor(255,255,255,10)
surface.SetMaterial(PipBoy3000.ButtonMat)
surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
end
but2.DoClick = function(me)
for k,v in pairs(PipBoy3000.Base.Tabs) do v:Remove()
pip.Tabs[k] = nil
end
PipBoy3000.ModeSound()
PipBoy3000.OpenItems(true)
end
--
local but3 = vgui.Create("DButton",pip)
but3:SetSize(w,h)
but3:SetPos(x - (w / 2) + (spacing * 2),y)
but3:SetDrawOnTop(true)
but3:SetText("")
but3.Paint = function(me)
if pip.Title != "DATA" or pip.Startup or showtime > CurTime() then return end
surface.SetDrawColor(255,255,255,10)
surface.SetMaterial(PipBoy3000.ButtonMat)
surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
end
but3.DoClick = function(me)
for k,v in pairs(PipBoy3000.Base.Tabs) do v:Remove()
pip.Tabs[k] = nil
end
PipBoy3000.ModeSound()
PipBoy3000.OpenData(true)
end

pip.TabButtons = {}
pip.TabButtons[1] = but1
pip.TabButtons[2] = but2
pip.TabButtons[3] = but3
--
  if dimension == "3d" then
	but1:SetParent(nil)
	but1.Think = function(me)
	  if !IsValid(pip) then me:Remove() print("removing") end
	end
	but2:SetParent(nil)
	but2.Think = but1.Think
	but3:SetParent(nil)
	but3.Think = but1.Think
	--POS
	local wep = LocalPlayer():GetActiveWeapon()
	if wep:GetClass() == "fo3_pda" then
	  but1:SetPos(ScrW()*.13, ScrH()*.725 - but1:GetTall()/2)
	  but1:SetSize(w/2, h/2)
	  but2:SetPos(ScrW()*.129, ScrH()*.775 - but1:GetTall()/2)
	  but2:SetSize(w/2, h/2)
	  but3:SetPos(ScrW()*.129, ScrH()*.845 - but1:GetTall()/2)	
	  but3:SetSize(w/2, h/2)
	else
	  but1:SetPos(ScrW()*.435, ScrH()*.885 - but1:GetTall())
	  but2:SetPos(ScrW()*.435 + but1:GetWide() + (spacing*.125), ScrH()*.885 - but1:GetTall())
	  but3:SetPos(ScrW()*.4275 + but1:GetWide()*2 + (spacing*.125)*2, ScrH()*.885 - but1:GetTall())
	end
  end
end
--------------------

--------------------
--SOUND
function PipBoy3000.ModeSound()
if LocalPlayer().ModeSound != nil then LocalPlayer().ModeSound:Stop() end
LocalPlayer().ModeSound = CreateSound(LocalPlayer(),"ui/ui_pip_mode.mp3")
local sound = LocalPlayer().ModeSound
sound:ChangeVolume(1)
sound:Play()
end
--------------------

-------------------
--SCAN LINES-
-------------------
function PipBoy3000.Scan(screen,color)
if !IsValid(screen) then return end
--
local h = screen:GetTall() *.135
--
local max = screen:GetTall()
local start = 0 - h
local speed = 450
local col = color or Schema.GameColor
screen.NextScan = screen.NextScan or CurTime() + PipBoy3000.ScanTime
--
screen.scan_y = screen.scan_y or start
screen.scan_y = screen.scan_y + (speed * FrameTime())
---------------------------------------------------------
  if screen.scan_y >= max then 
    if screen.NextScan <= CurTime() then
      screen.NextScan = CurTime() + PipBoy3000.ScanTime
      screen.scan_y = start
    end
    return
  end
  --
    local cutoff = max - 0
    if (screen.scan_y + h) >= cutoff then
	  local total = screen.scan_y + h
	  local over = total - cutoff
	  h = h - over
	end
--
surface.SetDrawColor(Color(col.r,col.g,col.b,4))
surface.SetMaterial(PipBoy3000.Scanlines)
surface.DrawTexturedRect(0,screen.scan_y,screen:GetWide(),h)
end
-------------------

concommand.Add("PipBoy3000_ResetMode", function()
PipBoy3000.SavedMode = nil
end)
--return Plugin