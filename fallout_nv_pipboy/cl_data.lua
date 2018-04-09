PipBoy3000 = PipBoy3000 or {}
local tab = {}
local posconfig = {}
--
posconfig.TopRightPoint = Vector(-14852.251953, 14621.647461, 0.000000)
posconfig.BotLeftPoint = Vector(15856.548828, -15178.134766, 0.000004)
posconfig.MapMat = Material("pw_fallout/caliente_map.png", "noclamp smooth")
posconfig.PlayerBlimp = Material("pw_fallout/player.png")
posconfig.FadeBot = Material("pw_fallout/fade_bottom.png")
posconfig.FadeTop = Material("pw_fallout/fade_top.png")
posconfig.FadeRight = Material("pw_fallout/fade_right.png")
posconfig.FadeLeft = Material("pw_fallout/fade_left.png")
posconfig.WayPoint = Material("pw_fallout/waypoint.png")
posconfig.SeePoint = Material("pw_fallout/waypoint_custom.png")
--
posconfig.Icons = {}
posconfig.Icons["Scrap-Ville"] = {Vec = Vector(8657.306641, 13755.832031, 0), Icon = Material("pw_fallout/icons/map/settle.png")}
posconfig.Icons["Caliente"] = {Vec = Vector(-7673.357422, 10231.792969, 0), Icon = Material("pw_fallout/icons/map/city.png")}
posconfig.Icons["Dead-Ridge Town"] = {Vec = Vector(-9062.435547, -12751.403320, 0), Icon = Material("pw_fallout/icons/map/camp.png")}
posconfig.Icons["Gas Station"] = {Vec = Vector(508.706604, -1249.218018, 0), Icon = Material("pw_fallout/icons/map/sewer.png")}
posconfig.Icons["Metal Ore Mine"] = {Vec = Vector(-5747.402344, -4647.186523, 0), Icon = Material("pw_fallout/icons/map/cave.png")}
posconfig.Icons["Share-Crop Town"] = {Vec = Vector(5190.939453, -9102.954102, 2.031250), Icon = Material("pw_fallout/icons/map/settle.png")}
posconfig.Icons["La-Familia Casino"] = {Vec = Vector(4416.868652, -11432.049805, 2.031250), Icon = Material("pw_fallout/icons/map/factory.png")}
posconfig.Icons["Vault 7"] = {Vec = Vector(13128.141602, -5514.325195, 22.660782), Icon = Material("pw_fallout/icons/map/vault.png")}
posconfig.Icons["Camp Oliver"] = {Vec = Vector(8837.113281, 3411.529297, 546.852844), Icon = Material("pw_fallout/icons/map/settle.png")}
posconfig.Icons["Electricity Plant"] = {Vec = Vector(4083.082031, 8083.743164, 6.950317), Icon = Material("pw_fallout/icons/map/factory.png")}
posconfig.Icons["Town Ruins"] = {Vec = Vector(3056.867188, 10167.692383, 0.299500), Icon = Material("pw_fallout/icons/map/ruins.png")}
--
-----------------------
local function getWorldPos(mx, my, zoom, mapw, maph, w, h, offx, offy)
local maxWorld = posconfig.TopRightPoint / zoom
local minWorld = posconfig.BotLeftPoint / zoom
--
local topleftX = maxWorld.x
local topleftY = maxWorld.y
local botrightX = minWorld.x
local botrightY = minWorld.y
--mpx, mpy, zoom, mapw, maph, w, h, offx, offy)
local vx = (((mx - w/2 + offx)*(botrightX-topleftX)/mapw) + topleftX)*zoom
local vy = (((my - h/2 + offy)*(botrightY-topleftY)/maph) + topleftY)*zoom
--
return vx, vy
end
--
local function getMapPos(pos, zoom, mapw, maph, w, h, offx, offy)
local ppos = pos / zoom
local maxWorld = posconfig.TopRightPoint / zoom
local minWorld = posconfig.BotLeftPoint / zoom
--
local topleftX = maxWorld.x
local topleftY = maxWorld.y
local botrightX = minWorld.x
local botrightY = minWorld.y
local playerx = ppos.x 
local playery = ppos.y
--
local perc_y = (playery-topleftY)/(botrightY-topleftY)
local perc_x = (playerx-topleftX)/(botrightX-topleftX)

local mx = (w/2) - (offx) + (mapw*perc_x)
local my =  (h/2) - (offy) + (maph*perc_y)
--
return mx, my
end

----
------------
tab[1] = {Name = "World Map",Func = function(me,x)
local tb = {}
--
FalloutTutorial("World Map")
--
local off = x*.9
local map = vgui.Create("DPanel", me)
tb[1] = map
local vm_x = x
local vm_y = x + (off*.7)
map:SetCursor("blank")
map:SetSize(me:GetWide() - (x*2) - 6, me:GetTall() - (x*2) - (off*1.8))
map:SetPos(vm_x, vm_y)
  map.OnCursorEntered = function(self)
    me:GetParent().MouseNoDraw = true
  end
  map.OnCursorExited = function(self)
    me:GetParent().MouseNoDraw = false
  end  
  map.Pos = LocalPlayer():GetPos()
  map.Zoom = 105
  --
  map.OnMousePressed = function(self)
    if self.TempPos then return end
  	local mx = gui.MouseX() - vm_x
    local my = gui.MouseY() - vm_y
	self.TempMX = mx
	self.TempMY = my
	self.TempPos = self.Pos + Vector(0,0,0)
  end
  map.OnMouseReleased = function(self)
    self.TempPos = nil
	self.TempMX = nil
	self.TempMY = nil
  end
  map.DoClick = map.OnMouseReleased
  map.Think = function(self)
    if input.IsShiftDown() and input.IsMouseDown(MOUSE_RIGHT) then
	  if !self.DragY then
	    self.DragY = gui.MouseY()
	  else
	    local delta = 0.1
	    local new_zoom = (gui.MouseY() - self.DragY)*delta
		self.Zoom = math.Clamp(self.Zoom - new_zoom, 1, 120)
	  end
	  return
	elseif self.DragY then
	  self.DragY = nil
	  self.Popup = false
	elseif input.IsMouseDown(MOUSE_RIGHT) and !self.Popup then
	  self.Popup = true
	  surface.PlaySound("ui/notify.mp3")
	  local Window = Derma_Query("Do you want to place a waypoint here?", "",
	  "Place it", function() 
	    surface.PlaySound("ui/ok.mp3")
		vgui.ForceDrawCursor = false
		if !IsValid(self) or !self.OffsetX or !self.OffsetY or !self.TrackerX or !self.TrackerY then return end
	    self.Popup = false 
		--
		local mx = self.TrackerX
        local my = self.TrackerY

		local zoom = self.Zoom
		local w, h = self:GetSize()
		local mapw = w + (w*(zoom/100))
        local maph = h + (h*(zoom/100))
        --
		local offx = self.OffsetX
		local offy = self.OffsetY
		local center_vec = self.Pos
		local mpx, mpy = getMapPos(center_vec, zoom, mapw, maph, w, h, offx, offy)
		local x2d = (mpx + (mx - mpx))
		local y2d = (mpy + (my - mpy))
		--
		local vx, vy = getWorldPos(x2d, y2d, zoom, mapw, maph, w, h, offx, offy)
		local vec = Vector(vx, vy, 0)
		--
		PipBoy3000.WayPoint = vec
	  end,
	  "Remove it", function()
	    surface.PlaySound("ui/ok.mp3")
		vgui.ForceDrawCursor = false
		PipBoy3000.WayPoint = nil
		if !IsValid(self) then return end
	    self.Popup = false 
	  end,
	  "Cancel", function() 
	    surface.PlaySound("ui/ok.mp3") 
		vgui.ForceDrawCursor = false
		if !IsValid(self) then return end
	    self.Popup = false 
	  end)
	  vgui.ForceDrawCursor = true
	end
    --
    if self.TempPos and input.IsMouseDown(MOUSE_LEFT) then
	  local sx = self.TempMX
	  local sy = self.TempMY
	  local mx = gui.MouseX() - vm_x
      local my = gui.MouseY() - vm_y
	  --
	  local zoom = self.Zoom
	  local delta = 13
	  delta = delta + (delta - (delta*(zoom/100)))
	  local x = (mx - sx)*delta
	  local y = (my - sy)*delta
	  --
	  local tx = self.TempPos.x
	  local ty = self.TempPos.y
	  self.Pos = Vector(tx - x, ty + y, 0)
	elseif self.TempPos then
	  self:OnMouseReleased()
	end
  end
  --
  map.Paint = function(self, w, h)
  draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
  --
  local ply = LocalPlayer()
  local zoom = self.Zoom
  local c_ang = (ply:GetAngles()[2])
  c_ang = c_ang - 90
  
  local ppos = self.Pos / zoom
  local maxWorld = posconfig.TopRightPoint / zoom
  local minWorld = posconfig.BotLeftPoint / zoom
  --
  local topleftX = maxWorld.x
  local botrightX = minWorld.x
  local topleftY = maxWorld.y
  local botrightY = minWorld.y
  local playerx = ppos.x 
  local playery = ppos.y
  --
  local pw = w*.02
  pw = pw + ((pw/2) * (zoom/100))
  local dw = pw*.45
  --
  --draw.RoundedBox(8,x,y,w,h,Color(0,0,0,110))
  --
  local omapw = w*1
  local omaph = h*1
  local mapw = omapw + omapw*(zoom/100)
  local maph = omaph + omaph*(zoom/100)
  --
  local offsetx = mapw *((playerx-topleftX)/(botrightX-topleftX))
  local offsety = maph *((playery-topleftY)/(botrightY-topleftY))
  self.OffsetX = offsetx
  self.OffsetY = offsety
  --
  local rotx = -mapw/2 + (offsetx)
  local roty = maph/2 - (offsety)
  
  pig.utility.Render(0, 0,function()
    draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
  end,function()
    surface.SetDrawColor(Schema.GameColor)
    surface.SetMaterial(posconfig.MapMat)
    surface.DrawTexturedRectRotatedPoint( w/2, h/2, mapw, maph, 0, rotx, roty )
  end)
  --FADES
  local fw = w*.06
  surface.SetDrawColor(255,255,255, 245)
  surface.SetMaterial(posconfig.FadeBot)
  surface.DrawTexturedRect(0,0,w, fw)  
  
  surface.SetDrawColor(255,255,255, 255)
  surface.SetMaterial(posconfig.FadeRight)
  surface.DrawTexturedRect(0,0,fw,h)
  
  surface.SetMaterial(posconfig.FadeLeft)
  surface.DrawTexturedRect(w - fw + 1,0,fw,h)  
  
  surface.SetMaterial(posconfig.FadeTop)
  surface.DrawTexturedRect(0,h - fw + 1,w, fw)
  --PLAYER + ICONS
  -----------------------
  --FLASH
  local alpha = posconfig.Alpha or 255
  local startTime = posconfig.StartTime or CurTime()
  local lifeTime = 1.225
  local startVal = posconfig.StartVal or alpha
  local endVal = posconfig.EndVal or 0
  local value = startVal
  
  local fraction = ( CurTime( ) - startTime ) / lifeTime;
  fraction = math.Clamp( fraction, 0, 1 );
  value = Lerp( fraction, startVal, endVal );
  alpha = value
  posconfig.Alpha = alpha
    if alpha >= 255 then
	  posconfig.StartTime = CurTime()
	  posconfig.StartVal = alpha
	  posconfig.EndVal = 0
	elseif alpha <= 0 then
	  posconfig.StartTime = CurTime()
	  posconfig.StartVal = alpha
	  posconfig.EndVal = 255
	end
	local col = Schema.GameColor
	local flash_col = Color(col.r, col.g, col.b, alpha)
  ----
  local iw = pw*1.7
  local mx = gui.MouseX() - vm_x
  local my = gui.MouseY() - vm_y
  local entered = false
    for k,v in pairs(posconfig.Icons) do
	  local ix, iy = getMapPos(v.Vec, zoom, mapw, maph, w, h, offsetx, offsety)
	  if ix < 0 or (ix+iw) > w or iy < 0 or (iy+iw) > h then continue end
      surface.SetDrawColor(Schema.GameColor)
      surface.SetMaterial(v.Icon)
	  if mx >= (ix - (iw/2)) and (mx+dw) <= (ix+iw) and my >= (iy - (iw/2)) and (my+dw) <= (iy+iw) then
	     surface.DrawTexturedRectRotated(ix, iy, iw*1.5, iw*1.5, 0)
		 entered = true
		 if self.HoveredIcon != k then
		   self.HoveredIcon = k
		   surface.PlaySound("ui/ui_pipboy_highlight2.mp3")
		 end
	  else
        surface.DrawTexturedRectRotated(ix, iy, iw, iw, 0)
      end		
	end
	-- --
	if self.HoveredIcon and !entered then
	  self.HoveredIcon = nil
	end
	-- -- --
	
    for k,v in pairs(ents.FindByClass("pickup_point")) do
      local ix, iy = getMapPos(v:GetPos(), zoom, mapw, maph, w, h, offsetx, offsety)
	  if ix < 0 or (ix+dw) > w or iy < 0 or (iy+dw) > h then continue end
      surface.SetDrawColor(flash_col)
      surface.SetMaterial(posconfig.WayPoint)
      surface.DrawTexturedRectRotated(ix, iy, dw, dw, 0)	  
	end	
  
  local waypoint = PipBoy3000.WayPoint
  if waypoint then
    local wx, wy = getMapPos(waypoint, zoom, mapw, maph, w, h, offsetx, offsety)
	if wx < 0 or (wx+pw) > w or wy < 0 or (wy+pw*1.55) > h then
	  --do nothing
	else
      surface.SetDrawColor(flash_col)
      surface.SetMaterial(posconfig.SeePoint)--(w/2) - (offx) + (mapw*perc_x)
      surface.DrawTexturedRectRotated(wx, wy, pw, pw*1.55, 0)	
	end
  end
  
  local player_pos = ply:GetPos()
  local ppx, ppy = getMapPos(player_pos, zoom, mapw, maph, w, h, offsetx, offsety)
  if ppx < 0 or (ppx+pw) > w or ppy < 0 or (ppy+pw) > h then
  --do nothing
  else
    surface.SetDrawColor(flash_col)
    surface.SetMaterial(posconfig.PlayerBlimp)
    surface.DrawTexturedRectRotated(ppx, ppy, pw, pw, c_ang)    
  end
  --
  --PLACER
  if self.Popup then return end
  self.TrackerX = mx
  self.TrackerY = my
  if mx < 0 or mx > self:GetWide() or my < 0 or my > self:GetTall() then
    return
  end
  --
  local len = h*.11
  local space = len*.35
  local sx = mx - len - space
  local sy = my - (len) - space
  --
  surface.SetDrawColor(Schema.GameColor)
  surface.SetMaterial(posconfig.WayPoint)
  surface.DrawTexturedRect(mx - (dw/2), my - (dw/2), dw, dw)
  --
  Fallout_Line(sx, sy, "right", len)
  Fallout_Line(sx, sy, "down", len)
	
  Fallout_Line(sx, my + space, "up", len)
  Fallout_Line(sx, my + len + space, "right", len)
	
  Fallout_Line(mx + space, sy, "left", len)
  Fallout_Line(mx + len + space, sy, "down", len)
	
  Fallout_Line(mx + len + space - 3, my + space, "up", len)
  Fallout_Line(mx + space, my + len + space, "left", len)
  --
  local hovered = self.HoveredIcon
    if hovered then
      draw.SimpleText(hovered, "FO3FontPip", mx, my + len + (space*2.55), col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	end
  end
--
return tb
end}

tab[2] = {Name = "Radio",Func = function(me,x)
local tb = {}
--
local list = vgui.Create("pig_PanelList",me)
tb[1] = list
list:SetSize(me:GetWide() *.375,me:GetTall() *.615)
list:SetPos(x - 3,me:GetTall() *.166)
list:SetSpacing(1)

local ply = LocalPlayer()
local name = ply.PipRName
local stations = {}
stations["Galaxy News Radio"] = {Wave = 1, URL = "http://46.101.243.245:8000/falloutfm2.ogg", Vol = 0.75}
--stations["Mojave Radio"] = {Wave = 1, URL = "https://www.atlas-5.site/radio_001/", Vol = 0.77}
stations["Radio New Vegas"] = {Wave = 2, URL = "http://46.101.243.245:8000/falloutfm3.ogg", Vol = 1}
--stations["Liberty Radio"] = {Wave = 3, URL = "https://www.atlas-5.site/radio_002/", Vol = 0.77}

  for k,v in pairs(stations) do
    local base = vgui.Create("DButton")
	base:SetText("")
    base:SetSize(list:GetWide(),me:GetTall() *.075)
	base.DoClick = function(me)
	  surface.PlaySound("ui/ui_menu_prevnext.wav")
	  if ply.PipRadio != nil then
	    ply.PipRadio:Stop()
	  end
	  if ply.PipRName == k then 
	    ply.PipRName = nil
	    tb[2].SelMat = nil
		return 
	  else
	    sound.RemoveURLSounds()
	  end
	  --
	  sound.PlayURL(v.URL, "", function(station)
	    if !tb or !IsValid(tb[2]) then return end
	    local vol = v.Vol
		ply.PipRadio = station
		ply.PipRName = k
	    station:SetVolume(vol)
		station:Play()
		tb[2].SelMat = v.Wave
	  end)
	end
	base.OnCursorEntered = function(self)
      self.ins = true
      surface.PlaySound("ui/focus.mp3")
    end
    base.Paint = function(self)
	  local col = Schema.GameColor
      local name = k
      if !self.ins then 
        draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        return 
      end
      surface.SetDrawColor(col)
      surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
      draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(col.r,col.g,col.b,5))
      draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
	end
    base.OnCursorExited = function(self)
      self.ins = false
    end
	list:AddItem(base)
  end
--
local rmat = {}
rmat[1] = Material("pipboy/radio/forward.png")
rmat[2] = Material("pipboy/radio/backward.png")
rmat[3] = Material("pipboy/radio/left.png")


local radio = vgui.Create("DPanel", me)
tb[2] = radio
  if name then
    radio.SelMat = stations[name].Wave
  end
radio:SetSize(me:GetWide()*.32, me:GetWide()*.32)
radio:SetPos(me:GetWide()*.99 - radio:GetWide() - x, me:GetTall() *.24)
  radio.Paint = function(me)
    local len = me:GetWide()*.1
    surface.SetDrawColor(Schema.GameColor)
	--
	surface.SetMaterial(Material("pw_fallout/horiz.png"))
	surface.DrawTexturedRect(0, me:GetTall() - len, me:GetWide(), len)

	surface.SetMaterial(Material("pw_fallout/vert.png"))
	surface.DrawTexturedRect(me:GetWide() - len, 0, len, me:GetTall())
	--
	local selected = me.SelMat
	if !selected then return end
	local x1 = me.X1 or 0
	local x2 = me.X2 or me:GetWide()
	--
	local speed = FrameTime()*305
	x1 = x1 - speed
	x2 = x2 - speed
	
	if (x1 + me:GetWide()) < 0 then
	  x1 = me:GetWide()
	end
	if (x2 + me:GetWide()) < 0 then
	  x2 = me:GetWide()
	end
	--
	me.X1 = x1
	me.X2 = x2
	--
	pig.utility.Render(0,0,function()
	  draw.RoundedBox(0,0,0,me:GetWide(), me:GetTall(), Color(0,0,0))
	end, function()
	  surface.SetDrawColor(Schema.GameColor)
	  surface.SetMaterial(rmat[selected])
	  surface.DrawTexturedRect(x1, 0, me:GetWide(), me:GetTall())
	  surface.DrawTexturedRect(x2, 0, me:GetWide(), me:GetTall())	  
	end)
  end

--
return tb
end}

------------------------

function PipBoy3000.OpenData(dont)
  if PipBoy3000.SavedMode != "DATA" then
    PipBoy3000.SavedTab = nil
  end
vgui.ForceDrawCursor = false
PipBoy3000.SavedMode = "DATA"
-----------------------
local screen = PipBoy3000.Base.Screen
local col = Schema.GameColor
local tbl = PipBoy3000.Base.Tabs
  for k,v in ipairs(tab) do
    PipBoy3000.MakeTab(v.Name,v.Func,k)
  end
PipBoy3000.Base.Title = "DATA"
PipBoy3000.SortTabs()
--
  if PipBoy3000.SavedTab then
    local tab = PipBoy3000.SavedTab
    local but = PipBoy3000.Base.Tabs[tab]
	if IsValid(but) then
      but.DoClick(but)
	end
  else
    local but1 = PipBoy3000.Base.Tabs[1]
    but1.DoClick(but1,dont)
  end
------------------------------------------
screen.PaintFunc = function(me,text_x,line_y)
local x = text_x + (me:GetWide() *.015)
local spacing = me:GetWide() *.015
local w = me:GetWide() - (x+me:GetWide()*.075) - (spacing*3)
w = w/4
--
local date = os.date( "%d.%m.82, %H:%M" , os.time() )
--
Fallout_Line(x ,line_y,"right",w + spacing + 3,true,col)
PipBoy3000.AddInfo(x + spacing + (w*1),line_y,w*2 + spacing,"", "Mojave Outskirts, Caliente","FO3FontPip")
PipBoy3000.AddInfo(x + (spacing * 3) + (w*3),line_y,w,"", date,"FO3FontPipSmall")
end
--
end
