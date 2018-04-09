DeriveGamemode("sandbox")
include("shared.lua")
include("sh_util.lua")
pig = pig or {}
pig.utility.AddFile("factions.lua","sh") 
pig.utility.AddFile("core/cl_ambiance.lua")
pig.utility.AddFile("core/cl_talktospeech.lua")
pig.utility.AddFile("core/sh_chatcommands.lua")
pig.utility.AddFile("core/cl_pigmenu.lua")
pig.utility.AddFile("core/cl_thirdperson.lua")
pig.utility.AddFile("core/cl_char.lua")
pig.utility.AddFile("core/sh_inventory.lua")
pig.utility.AddFile("core/cl_inventory.lua")
pig.utility.AddFile("core/sh_att.lua")
pig.utility.AddFile("quest/sh_quest.lua")
pig.utility.AddFile("core/sh_currency.lua")
pig.utility.AddFile("core/sh_char.lua")
pig.utility.AddFile("cl_chatbox.lua")
pig.utility.AddFile("core/sh_admin.lua")
pig.utility.AddFile("core/sh_recognition.lua")
pig.utility.AddFile("core/sh_flag.lua")
pig.utility.AddFile("core/sh_anims.lua")
pig.utility.AddFile("core/cl_hotbar.lua")
pig.utility.AddFile("core/cl_options.lua")
pig.utility.AddFile("core/cl_urlmat.lua")

local function LoadDerma()
print("[PigWorks]: Loading Derma..")
local files = file.Find("pigworks/gamemode/derma/*", "LUA")
  for _, f in SortedPairs(files, true) do
    include("derma/"..f)
    print("[PigWorks CLIENT]: Loaded "..f)
  end
end
LoadDerma()
local matBlurScreen = Material( "pp/blury" )
local eye = Material("eye.png")
resource.AddSingleFile( "eye.png" )
pig.vgui = pig.vgui or {}--To help with glitchy VGUI
concommand.Add("pw_ClearVGUI",function()
if !LocalPlayer():IsSuperAdmin() then return end
  for k,v in pairs(pig.vgui) do
    if type(v) == "function" then continue end
	v:Remove()
  end
end)
pig.Font = "Calibri"
surface.CreateFont( "PigFontTitle", {                   
	font = pig.Font,
	weight = 400,
	bold = true,
	size = ScreenScale(19)
} )
surface.CreateFont( "PigFontBig", {                   
	font = pig.Font,
	weight = 400,
	bold = true,
	size = ScreenScale(12)
} )
surface.CreateFont( "PigFont", {                   
	font = pig.Font,
	weight = 400,
	bold = true,
	size = ScreenScale(8)
} )
surface.CreateFont( "PigFontSmall", {          
	font = pig.Font,
	weight = 400,
	bold = true,
	size = ScreenScale(7.5)
} )
surface.CreateFont( "PigFontTiny", {--Tiny, like ur dick mate
	font = pig.Font,
	weight = 400,
	bold = true,
	size = ScreenScale(7)
} )

function pig.LoadClient()
print("LOADING PIGWORKS CLIENT")
  timer.Create("PigWorksLoad",8,1,function()
    print("FINISHED LOADING CLIENT")
    pig.FinishedLoading = true
  end)
end

local function OpenWaitScreen(force)
if !force and pig.utility.IsFunction(LocalPlayer().GetCharID) and LocalPlayer():GetCharID() then return end
  if !pig.FinishedLoading and !timer.Exists("PigWorksLoad") then
    pig.LoadClient()
  end
  if IsValid(pig.vgui.WaitingScreen) then
    return
  end
pig.vgui.WaitingScreen = vgui.Create("pig_WaitScreen")
pig.vgui.WaitingScreen:SetForce(force)
end
OpenWaitScreen()
concommand.Add("PW_ShowWait",function()
OpenWaitScreen(true)
end)
concommand.Add("PW_RemoveWait",function()
  if IsValid(pig.vgui.WaitingScreen) then
    pig.vgui.WaitingScreen:Remove()
  end
end)

function GM:HUDPaint()
  if !eye:IsError() then
    surface.SetDrawColor(Color(255, 255, 255, 255))
    surface.SetMaterial(eye)
    surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
  end
pig.DrawDescriptions()
pig.DrawTyping()
  if !LocalPlayer():InEditor() then 
	hook.Call("pig_HUDPaintOnTop",GAMEMODE)
  end
--
if pig.DarkTime == nil then return end
  if pig.DarkTime != nil then
    local alpha = pig.DarkAlpha or 1
	  if pig.DarkNext == nil or pig.DarkNext <= CurTime() then
	    alpha = alpha + pig.DarkTime
	    pig.DarkAlpha = alpha
	  end
    draw.RoundedBox(0,0,0,ScrW(),ScrH(),Color(0,0,0,alpha))
	  if alpha >= 255 and pig.DarkTime >= 0 then
	    pig.DarkTime = -pig.DarkTime
		  if pig.DarkBlack then
		    pig.DarkNext = pig.DarkBlack
		  end
		  if pig.DarkFunc then
		    pig.DarkFunc()
		  end
	  elseif alpha <= 0 then
	    pig.DarkTime = nil
		pig.DarkAlpha = nil
		pig.DarkBlack = nil
		pig.DarkNext = nil
	  end
  end
--
end

function GM:ContextMenuOpen(menu)
local should = hook.Call("pig_ContextMenu",GAMEMODE,menu)
  if should != nil then
    return should
  end
  if LocalPlayer():IsAdmin() then
    return true
  end
return false
end

function GM:ScoreboardShow()
  if pig.utility.IsFunction(pig.vgui.ScoreboardShow) then
    pig.vgui.ScoreboardShow()
  end
end

function GM:ScoreboardHide()
if pig.utility.IsFunction(pig.vgui.ScoreboardHide) then
pig.vgui.ScoreboardHide()
end
end

net.Receive("PW_Notify",function()
local col = net.ReadTable()
local txt = net.ReadString()
local karma = net.ReadString()
local time = net.ReadFloat()
if !col.r or !col.g or !col.b then col = Schema.GameColor end
pig.Notify(col,txt,time,nil,karma)
end)

function pig.Notify(color,text,time,font,karma,nohook)
MsgC(color, "["..Schema.Name.."]:"..text.."\n")
local should = false
if !nohook then
should = hook.Call("pig_Cl_Notify",GAMEMODE,color,text,time,karma)
end
if should == true then return end
if IsValid(pig.vgui.NotifyBox) then
local pigbox = pig.vgui.NotifyBox
pig.vgui.NotifyBox:SizeTo( 0, 0, 0.4, 0, 0.26, function()
pigbox:Remove()
end)
end
pig.vgui.NotifyBox = vgui.Create("DPanel")
pig.vgui.NotifyBox:SetWide(ScrW() / 2)
pig.vgui.NotifyBox:CenterHorizontal()
pig.vgui.NotifyBox:SetDrawOnTop(true)
pig.vgui.NotifyBox.Paint = function(self)
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,105) )
end
pig.vgui.NotifyBox:SizeTo( ScrW() / 2, pig.vgui.NotifyBox:GetTall(), 1, 0, 0.26, function()
local toRemove = pig.vgui.NotifyBox
if !IsValid(toRemove) then return end
pig.vgui.NotifyBox:CenterHorizontal()
local textbox = vgui.Create("DLabel",pig.vgui.NotifyBox)
textbox:SetPos(pig.vgui.NotifyBox:GetWide()/2 - textbox:GetWide()/2, 0)
textbox:SetText("[ ! ] "..text.." [ ! ]")
textbox:SetTextColor(color)
if font then
textbox:SetFont(font)
else
textbox:SetFont("PigFont")
end
surface.SetFont(textbox:GetFont())
textbox:SetText(pig.NewLines(textbox:GetText(),pig.vgui.NotifyBox))
textbox:SizeToContents()
pig.vgui.NotifyBox:SetSize(pig.vgui.NotifyBox:GetWide(),textbox:GetTall() *1.5)
textbox:SetPos(pig.vgui.NotifyBox:GetWide()/2 - textbox:GetWide()/2, 0)
timer.Simple(time or 5,function()
if !IsValid(toRemove) then return end
toRemove:SizeTo( 0, 0, 0.4, 0, 0.26, function()
toRemove:Remove()
end)
end)
end)
pig.vgui.NotifyBox:SetSize(0,0)
end

function pig.DrawTyping()
local lpos = LocalPlayer():GetPos()
  for k,v in pairs(player.GetAll()) do
    if !v:IsTypingChat() then continue end
    local pos = v:GetPos()
	if pos:Distance(lpos) <= 500 then
      local ang = v:GetAngles()
      local font = hook.Call("pig_DescFont",GAMEMODE)
      --
      pos = pos+ang:Up() * 75
	  local can = hook.Call("pig_DrawTyping",GAMEMODE,v,pos,ang)
	  if can == false then continue end
      local type_pos = pos:ToScreen()
      draw.DrawText("Typing..", font or "PigFont",type_pos.x, type_pos.y,Schema.GameColor,TEXT_ALIGN_CENTER)
	end
  end
end

function pig.DrawDescriptions()
  local trace = pig.utility.PlayerQuickTrace(LocalPlayer())
  local ent = trace.Entity
  if !IsValid(ent) then return end
  if !ent:IsPlayer() then return end
  local max = 30
    if ent:GetPos():Distance(LocalPlayer():GetPos()) <= (Schema.DescDist or 500) then
	  local pos = ent:GetPos()
	  local ang = ent:GetAngles()
	  local font = hook.Call("pig_DescFont",GAMEMODE)
	  --
	  pos = pos+ang:Up() * 78
	  --
	  pos = pos:ToScreen()
	  local desc = ent:GetDesc()
	  surface.SetFont(font or "PigFont")
	  desc = pig.NewLines(desc,nil,.8)
	  local tw,th = surface.GetTextSize(desc)
	  local can = hook.Call("pig_DrawDesc",GAMEMODE,desc,pos,tw,th,ent)
	  if can == false then return end
	  draw.DrawText(desc,font or "PigFont",pos.x,pos.y-th,Schema.GameColor,TEXT_ALIGN_CENTER)
	end
end

function pig.IsKeyPressed(key)
local ply = LocalPlayer()
  if !ply:InEditor() and !gui.IsConsoleVisible() and !gui.IsGameUIVisible() and !pig.ChatBox.IsOpen() then
    if input.IsKeyDown(key) then
      return true
	end
  end
end

function GM:PostDrawViewModel( vm, ply, weapon )

if ( weapon.UseHands || !weapon:IsScripted() ) then
local hands = LocalPlayer():GetHands()
if ( IsValid( hands ) ) then hands:DrawModel() end
end

end

function pig.DrawCircle( x, y, radius, seg, col )
	local cir = {}
	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end
	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	surface.SetDrawColor(col)
	draw.NoTexture()
	surface.DrawPoly( cir )
end

function pig.DrawLine(start_x,start_y,end_x,end_y,thickness,col,mat)
	  local ang = math.atan2(start_y-end_y, start_x-end_x)
	  ang = ang + math.pi/2
   local tbl = {
  {x = start_x-math.cos(ang)*(thickness/2),y=start_y-math.sin(ang)*(thickness/2)},
  {x = start_x+math.cos(ang)*(thickness/2), y = start_y+math.sin(ang)*(thickness/2)},
  {x = end_x+math.cos(ang)*(thickness/2), y = end_y+math.sin(ang)*(thickness/2)}, 
  {x = end_x-math.cos(ang)*(thickness/2), y = end_y-math.sin(ang)*(thickness/2)}
  }
  surface.SetDrawColor( col or Color(255,255,255) )
  if !mat then
    draw.NoTexture()
  else
    surface.SetMaterial(mat)
  end
	surface.DrawPoly( tbl )
end

function pig.NewLines(text, frame, minus, set_w)
	local totalw = 0
	local newstring = ""
	for pos, letter in pairs(string.ToTable(text)) do
		local w, h = surface.GetTextSize(letter)           
		totalw = totalw + w

local target = nil
if frame and minus then
target = frame:GetWide() - frame:GetWide() *minus
elseif frame then
target = frame:GetWide() - frame:GetWide() *.045
elseif minus then
target = ScrW() - (ScrW() *minus)
else
target = ScrW() - (ScrW() *.045)
end
  if set_w then
    target = set_w
  end
		if totalw >= target then
			local str = (#newstring > 0) and newstring or text                
			local first = string.sub(str, 1, pos-1) 
			local last = string.sub(str, pos)
			newstring = first .. "\n-" .. last
			totalw = 0 
		end
		if newstring == "" then  
		newstring = text           
		end
		
	end
	return newstring
end

function pig.CreateBar(time,col,text)
    if timer.Exists("PW_CreateBar") then return end
	pig.IsCreatingBar = true
    local w = ScrW()
	local h = ScrH()
	local x,y,width,height = w/2-w/10, h/2-60, w/5, h/15
	local endtime = CurTime() + time
	hook.Add("HUDPaint","pig_DrawBar",function()
	if !pig.IsCreatingBar then
	hook.Remove("pig_DrawBar")
	return end
	local curtime = CurTime() - endtime
	curtime = string.gsub(tostring(curtime),"-","")
	curtime = tonumber(curtime)
	local status = math.Clamp(curtime/time, 0, 1)
	local BarWidth = status * (width - 16)
	draw.RoundedBox(2, x, y, width, height, Color(10,10,10,120))
	draw.RoundedBox(2, x+8, y+8, BarWidth, height-16, col)
	draw.SimpleText(text, "PigFontSmall", w/2, y + height/2, Color(255,255,255,255), 1, 1)
    end)
	timer.Create("PW_DestroyBar",time,1,function()
	pig.RemoveBar()
	end)
end

function pig.RemoveBar()
hook.Remove("pig_DrawBar")
pig.IsCreatingBar = false
end

net.Receive("PW_CreateBar",function()
local time = net.ReadFloat()
local col = net.ReadTable()
local text = net.ReadString()
pig.CreateBar(time,col,text)
end)

net.Receive("PW_RemoveBar",function()
pig.RemoveBar()
end)

function pig.CreateButton(mainframe,text,font)
local Button = vgui.Create("DButton",mainframe)
if mainframe != nil then
Button:SetParent(mainframe)
end
Button:SetFont(font)
Button:SetText(text)
Button:SetTextColor(Schema.GameColor)
Button.OnCursorEntered = function(self)
self:SetTextColor(Color(255,255,255))
end
Button.OnCursorExited = function(self)
self:SetTextColor(Schema.GameColor)
end
Button.Paint = function(self)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
end
hook.Call("pig_CreatedButton",GAMEMODE,Button)
return Button
end

function pig.DarkenScreen(time,black_time,func)
  time = (time * 100) * FrameTime()
  pig.DarkTime = time
    if black_time then
	  pig.DarkBlack = CurTime() + black_time
	end
	if func then
	  pig.DarkFunc = func
	end
end

function surface.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )

	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s

	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
end

function pig.AddBlur()
local Blur = vgui.Create("DPanel")
Blur:SetSize(ScrW(),ScrH())
Blur.startTime = SysTime()
Blur.Paint = function(self)
if !IsValid(self) then return end
Derma_DrawBackgroundBlur( self, self.startTime )
end
return Blur
end 

local blur = Material( "pp/blurscreen" )
function draw.ScreenBlur(x, y, w, h, layers, density, alpha)
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRectUV( x, y, w, h, x/ScrW(), y/ScrH(), (x+w)/ScrW(), (y+h)/ScrH() )
	end
end

function draw.Blur( panel, layers, density, alpha )
	-- Its a scientifically proven fact that blur improves a script
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

