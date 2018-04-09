include("shared.lua")
ENT.SAdd = 9.525
ENT.MaxLoops = 7
ENT.Roulette = Material("pw_fallout/gambling/roulette.png", "noclamp smooth")
ENT.Arrow = Material("pw_fallout/gambling/arrow.png", "noclamp smooth")
--

function ENT:Draw()
	self:DrawModel()
end

function ENT:Create2DTbl()
local tab = self:GetActualTbl()
local count = table.Count(tab)
local tbl = {}
local add = self.SAdd
local rot = -add
  for k,v in SortedPairs(tab) do
    rot = rot + add
    tbl[v.Num] = rot
  end
self.Tbl2D = tbl
self:OpenMenu()
end

function ENT:Use()
return
end

function ENT:CreateDEntry(parent)
local hud_color = Schema.GameColor
local entry = vgui.Create("DTextEntry", parent)
entry:SetDrawBorder( false )
entry:SetDrawBackground( false )
entry:SetFont("FO3FontSmall")
entry:SetTextColor(hud_color)
entry:SetUpdateOnType(true)
entry:SetCursorColor(hud_color)
  entry.Paint = function(me)
    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,20))
    Fallout_HalfBox(0,0,me:GetWide(),me:GetTall(),me:GetTall()*.375)
	derma.SkinHook( "Paint", "TextEntry", me, me:GetWide(), me:GetTall() )
  end
return entry
end

function ENT:OpenMenu(players)
-----------------
FalloutTutorial("Gambling")
--
local ang = self:GetAngles()
local pos = self:GetPos() + ang:Up() * 72 + ang:Forward() * 60 - ang:Right() * 65
ang = Angle(28.820, ang.y-140, 0.000)
  if IsValid(pig.vgui.SpinBackground) then
    pig.vgui.SpinBackground:Remove()
  end
pig.vgui.SpinBackground = vgui.Create("DPanel")
local background = pig.vgui.SpinBackground
background:SetSize(ScrW(),ScrH())
  background.Paint = function(me)
    local w,h = me:GetSize()
    render.RenderView( {
		origin = pos,
		angles = ang,
		x = 0,
		y = 0,
		w = w,
		h = h,
		drawviewmodel = false,
	 } )
  end
--
FalloutHUDHide = true
--
  if IsValid(pig.vgui.Spin) then
    pig.vgui.Spin:Remove()
  end
pig.vgui.Spin = vgui.Create("Fallout_Frame")
local frame = pig.vgui.Spin
frame:SetSize(ScrW()*.475,ScrH()*.875)
frame:SetPos(ScrW()*.5,0)
frame:CenterVertical()
frame:MakePopup()
frame.DownWidth = frame:GetTall()*.08
frame:ShowClose(true)
frame:SetTitle1("SPINJOY")
--
  background.Think = function(me)
    if !IsValid(frame) then me:Remove() end
  end
--
surface.SetFont("FO3FontHUD")
local _, th = surface.GetTextSize(" 20 Seconds ")
local tw,_ = surface.GetTextSize(" Until Next Roll ")

local chips = vgui.Create("DPanel", frame)
chips:SetSize(frame:GetWide()*.275, th)
chips:SetPos(frame:GetWide()*.95 - chips:GetWide(), frame:GetTall()*.075)
  chips.Paint = function(me, w, h)
    draw.SimpleText(LocalPlayer():GetChips().." Chips", "FO3FontHUD", w, 0, Schema.GameColor, TEXT_ALIGN_RIGHT)
  end
  
local timeleft = vgui.Create("DPanel", frame)
timeleft:SetSize(tw, th*2)
timeleft:SetPos(frame:GetWide() - tw*1.25, frame:GetTall()*.095 + chips:GetTall())
  timeleft.Paint = function(me, w, h)
    local time = self.NextRoll
	if !time or time < CurTime() or (time-CurTime()) > 10 then return end
	draw.SimpleText(math.Round(time - CurTime()).." Seconds", "FO3FontHUD", w, 0, Schema.GameColor, TEXT_ALIGN_RIGHT)
	draw.SimpleText("Until Next Roll", "FO3FontHUD", w, h, Schema.GameColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
  end
--
local close = frame.CloseButton
close.OldClose = close.DoClick
  close.DoClick = function(me)
    local window = Derma_Query("Do you wish to exit this game?", "",
	  "Accept", function()
	    FalloutHUDHide = false
		net.Start("SJ_Exit")
		net.WriteEntity(self)
		net.SendToServer()
	    me.OldClose(me)	
	  end,
	  "Decline", function() surface.PlaySound("ui/ok.mp3") end)
	  window.OldPaint = window.Paint
	  window.Paint = function(self)
	    Derma_DrawBackgroundBlur(self,SysTime()-0.35)
	    self:OldPaint(self)
	  end
  end
----self
local roulette = vgui.Create("DPanel",frame)
self.Roulette2D = roulette
roulette.Loops = 0
roulette:SetSize(frame:GetWide()*.375,frame:GetWide()*.375)
roulette:SetPos(0,frame:GetTall()*.075)
roulette:CenterHorizontal()
---
  roulette.Think = function(me)
    if me.RotTo and me.Loops <= 2 then
	  me.Rot = me.Rot or 0
	  me.StartPos = me.StartPos or me.Rot
	  local max_speed = 160*FrameTime()
	  local lowest_speed = max_speed*.275
	  local target = me.StartPos - 359
	  --
	  local togo = -self.Tbl2D[me.RotTo]
	  local speed = max_speed+0
	    if me.Loops == 2 and target > togo then
	      speed = max_speed - (max_speed *(me.Rot/togo))
	      speed = math.Clamp(speed,lowest_speed,max_speed)
		end
	  ------
	  me.Rot = me.Rot - speed
	  ------
	  if me.Rot <= target then
	    me.Rot = me.StartPos
		me.Loops = me.Loops+1
	  end
	elseif me.RotTo then
	  me.Rot = me.Rot or 0
	  me.StartPos = me.StartPos or me.Rot
	  local togo = -self.Tbl2D[me.RotTo]
	  --
	  if me.StartPos < togo and me.Rot < togo then
	    togo = -360*2
	  end
	  if me.Rot <= -360 then
	    me.Rot = 0
	  end
	  ---------------------------------
	  local max_speed = 160*FrameTime()
	  local lowest_speed = max_speed*.15
	  --
	  local speed = max_speed+0
	  speed = max_speed - (max_speed *(me.Rot/togo))
	  speed = math.Clamp(speed,lowest_speed,max_speed)
	  ------
	  me.Rot = me.Rot - speed
	  if me.Rot <= togo then
	    me.RotTo = nil
		me.StartPos = me.Rot+0
		me.Loops = 0
	  end
	end
  end
--
  roulette.Paint = function(me)
    surface.SetDrawColor(255,255,255)
	surface.SetMaterial(self.Roulette)
	surface.DrawTexturedRectRotated(me:GetWide()*.5,me:GetTall()*.5,me:GetWide(),me:GetTall(),me.Rot or 0)
	--
    surface.SetDrawColor(255,255,255)
	surface.SetMaterial(self.Arrow)
	surface.DrawTexturedRectRotated(me:GetWide()*.5,me:GetTall()*.5,me:GetWide(),me:GetTall(),0)	
  end
--
--self:SetTargetRoll(4)
------------------------
--BET MENU
local hud_color = Schema.GameColor
local box = vgui.Create("DPanel", frame)
box:SetSize(frame:GetWide()*.235, frame:GetTall()*.35)
box:SetPos(frame:GetWide()*.05, frame:GetTall()*.075)
surface.SetFont("FO3FontSmall")
local _, spacing = surface.GetTextSize("|")
spacing = spacing*1.25
  box.Paint = function(me, w, h) 
    draw.SimpleText("Bet Amount", "FO3FontSmall", 0, 0, hud_color)
    draw.SimpleText("Select Colour", "FO3FontSmall", 0, h*.15 + spacing, hud_color)
    draw.SimpleText("OR", "FO3FontHUD", w/2, h*.625, hud_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText("7x Multiplier", "FO3FontSmall", w/2, h*.675 + spacing, hud_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)		
    draw.SimpleText("Enter Number (1 - 36)", "FO3FontSmall", 0, h*.9 - spacing, hud_color)	
  end

local entry = self:CreateDEntry(box)
entry:SetSize(box:GetWide(), box:GetTall()*.1)
entry:SetPos(0, spacing)
  entry.OnChange = function(me)
    local val = me:GetValue()
    frame.BetAmt = tonumber(val or 0)
  end
local ex, ey = entry:GetPos()

local bs = box:GetWide()*.025
local bw = box:GetWide()/3 - (bs*1.5)
local rbg = {}
rbg[1] = {ID = "red", Mult = "2x", Col = Color(174, 20, 20)}
rbg[2] = {ID = "black", Mult = "2x", Col = Color(20,20,20)}
rbg[3] = {ID = "green", Mult = "10x", Col = Color(20,144,20)}

  for i=1,3 do
    local but = vgui.Create("DButton", box)
	but:SetSize(bw, bw)
	but:SetPos( (bw*(i-1)) + (bs*i), ey + entry:GetTall() + (spacing*2) )
	but:SetText("")
	but.DoClick = function(me)
	  surface.PlaySound("ui/ok.mp3")
	  if frame.Value == rbg[i].ID then
	    frame.Value = nil
	  else
	    frame.Value = rbg[i].ID
	  end
	end
	but.OnCursorEntered = function(me)
	  me.ins = true
	end
	but.OnCursorExited = function(me)
	  me.ins = false
	end
	but.Col = rbg[i].ID
	local col = rbg[i].Col
	local mult = rbg[i].Mult
	but.Paint = function(me, w, h)
	  local offset = w*.15
	  local icol = hud_color
	  local tcol = nil
	  if me.ins then
	    icol = Color(40, 50, 200)
	  elseif frame.Value == rbg[i].ID then
	    icol = Color(255,255,255)
	  end
	  if frame.Value == rbg[i].ID then
	    tcol = Color(255,255,255)
	  end
	  draw.RoundedBox(0,0,0,w,h, icol)
	  draw.RoundedBox(0, offset*.6, offset*.6, w - offset, h - offset, col)
	  draw.SimpleText(mult, "FO3Font", w/2, h/2, tcol or hud_color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
  end

local numb = self:CreateDEntry(box)
numb:SetSize(box:GetWide(), box:GetTall()*.1)
numb:SetPos(0, box:GetTall() - numb:GetTall())
  numb.OnChange = function(me, val)
    local val = me:GetValue()
    frame.Value = tonumber(val or 0)
  end

local bet = pig.CreateButton(frame, "Confirm Bet", "FO3FontHUD")
bet:SizeToContents()
bet:SetPos(frame:GetWide()*.925 - bet:GetWide(), frame:GetTall()*.405)
  bet.DoClick = function(me)
    local bet = frame.BetAmt
	local value = frame.Value
	if !bet or !value then
	  pig.Notify(Schema.RedColor, "You must enter a bet and choose a colour or number!", 3)
	  return
	end
	if bet > LocalPlayer():GetChips() then
	  pig.Notify(Schema.RedColor, "You can not afford to bet on this!", 3)
	  return
	end
	if self:CantPlaceBet(LocalPlayer(), (self.NextRoll or 0) - CurTime()) then
	  pig.Notify(Schema.RedColor, "Wait until this spin is over before placing a bet", 1)	
	  return
	end
	net.Start("SJ_Bet")
	net.WriteFloat(bet)
	net.WriteString(value)
	net.WriteEntity(self)
	net.SendToServer()
  end
--
local pbox = vgui.Create("DPanel", frame)
local pw = frame:GetWide()*.8
local ph = frame:GetTall()*.35
local heading = ph*.15
pbox:SetSize(pw, ph)
local rx, ry = roulette:GetPos()
pbox:SetPos(0, ry + roulette:GetTall()*1.1)
pbox:CenterHorizontal()
  pbox.Paint = function(me, w, h)
    local mw = w/3
	draw.RoundedBox(0, 0, 0, mw, heading, rbg[1].Col)
	draw.RoundedBox(0, mw, 0, w/3, heading, rbg[2].Col)	
	draw.RoundedBox(0, mw*2, 0, w/3, heading, rbg[3].Col)
	--
	local rtotal = self.PTable[1].Total or 0
	local btotal = self.PTable[2].Total or 0
	local gtotal = self.PTable[3].Total or 0	
	
	draw.SimpleText("(Total Red) - "..rtotal, "FO3FontSmall", mw/2, heading/2, Schema.GameColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("(Total Black) - "..btotal, "FO3FontSmall", mw + (mw/2), heading/2, Schema.GameColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("(Total Green) - "..gtotal, "FO3FontSmall", mw*2 + (mw/2), heading/2, Schema.GameColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	--
    Fallout_Line(0, 0, "right", w, true)
    Fallout_Line(0, heading-3, "right", w, true)	
    Fallout_Line(0, 0, "down", h)
    Fallout_Line(w - 3, 0, "down", h)
    Fallout_Line(w/3 - 3, 0, "down", h)
    Fallout_Line(((w/3)*2) - (3.5), 0, "down", h)	
  end
 
  self.PTable = {}
  for i=1,3 do
    local box = vgui.Create("pig_PanelList", pbox)
	self.PTable[i] = box
	box:SetSize(pw/3, ph - heading)
	box:SetPos((pw/3) * (i-1), heading)
	box.IDCol = i
	box.IDStr = rbg[i].ID
	if i == 3 then box.nopaint = true end
	box.Paint = function(me, w, h)
	  if me.nopaint then return end
	  Fallout_Line(w - 3, 0, "down", h)
	end
	--
	box.Think = function(me)
	  if self.NextRoll and (self.NextRoll - CurTime()) <= 10 then
	    if !me.Cleared then
		  for k,v in pairs(me:GetItems()) do
			v:Remove()
		  end
		  me.Cleared = true
		  me.Total = 0
		end
	  elseif me.Cleared then
	    me.Cleared = false
	  end
	end
	--
	box.CreateBox = function(me, k, v)
	  me.Total = (me.Total or 0) + (v.bet or 0)
	  local base = vgui.Create("DPanel")
	  base:SetSize(me:GetWide(), heading*1.15)
	  base.Paint = function(self, w, h)
	    draw.RoundedBox(0,0,0,w,h,Color(0,0,0,100))
	    draw.SimpleText(v.ply:Name(), "FO3FontSmall", 6, h*.015, Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	    local bets = ""
		if type(v.value) != "string" then
		  bets = " - Land on "..v.value
		end
	    draw.SimpleText("(".. (v.bet or 0) .." Chips"..bets..")", "FO3FontSmall", 6, h*.8, Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)		  
	  end
	  me:AddItem(base)
	  return base
	end
	----
	box.SetPlayers = function(me, players)
	  for k,v in pairs(me:GetItems()) do
	    v:Remove()
	  end
	  local actual = self:GetActualTbl()
	  --
	  for k,v in SortedPairsByMemberValue(players or {}, "bet") do
	    if !v.value then continue 
		else
		  local color = self:NumToColor(v.value) or v.value
		  if color != me.IDStr then continue end
		end
        local base = me:CreateBox(k,v)
	  end
	end
	box:SetPlayers(players)
  end
end

function ENT:SetTargetRoll(num)
local tbl = self:GetConvertTbl()
local conv = tbl[num]
self.target = conv
  if IsValid(self.Roulette2D) then
    self.Roulette2D.RotTo = num
  end
self.loops = self.MaxLoops
end

function ENT:GetConvertTbl()
  if !self.ConvertTbl then
    local tbl = {}
    local actual = self:GetActualTbl()
    for k,v in pairs(actual) do
      tbl[v.Num] = k
    end
	self.ConvertTbl = tbl
  end
return self.ConvertTbl
end

function ENT:BallKeyToTbl(k)
local ball = self:GetBallTbl()
--
local tbl = self:GetActualTbl()
return tbl[k]
end

function ENT:GetActualTbl()
local tbl = {}
tbl[0] = {Num = 29, Col = "black"}
tbl[1] = {Num = 25, Col = "red"}
tbl[2] = {Num = 10,Col = "black"}
tbl[3] = {Num = 27,Col = "red"}
tbl[4] = {Num = "00",Col = "green"}
tbl[5] = {Num = 1,Col = "red"}
tbl[6] = {Num = 13,Col = "black"}
tbl[7] = {Num = 36,Col = "red"}
tbl[8] = {Num = 24,Col = "black"}
tbl[9] = {Num = 3,Col = "red"}
tbl[10] = {Num = 15,Col = "black"}
tbl[11] = {Num = 34,Col = "red"}
tbl[12] = {Num = 22,Col = "black"}
tbl[13] = {Num = 5,Col = "red"}
tbl[14] = {Num = 17,Col = "black"}
tbl[15] = {Num = 32,Col = "red"}
tbl[16] = {Num = 20,Col = "black"}
tbl[17] = {Num = 7, Col = "red"}
tbl[18] = {Num = 11, Col = "black"}
tbl[19] = {Num = 30, Col = "red"}
tbl[20] = {Num = 26, Col = "black"}
tbl[21] = {Num = 9,Col = "red"}
tbl[22] = {Num = 28,Col = "black"}
tbl[23] = {Num = 0, Col = "green"}
tbl[24] = {Num = 2, Col = "black"}
tbl[25] = {Num = 14, Col = "red"}
tbl[26] = {Num = 35, Col = "black"}
tbl[27] = {Num = 23, Col = "red"}
tbl[28] = {Num = 4,Col = "black"}
tbl[29] = {Num = 16,Col = "red"}
tbl[30] = {Num = 33,Col = "black"}
tbl[31] = {Num = 21,Col = "red"}
tbl[32] = {Num = 6,Col = "black"}
tbl[33] = {Num = 18,Col = "red"}
tbl[34] = {Num = 31,Col = "black"}
tbl[35] = {Num = 19,Col = "red"}
tbl[36] = {Num = 8, Col = "black"}
tbl[37] = {Num = 12, Col = "red"}

return tbl
end

function ENT:GetBallTbl()
local tbl = {}
tbl[0] = {x = 0, y = 0}
tbl[1] = {x = 1.1, y = -0.5}
tbl[2] = {x = 2.25, y= -0.6}
tbl[3] = {x= 3.5, y = -0.5}
tbl[4] = {x = 4.75, y = -0.3}
tbl[5] = {x = 5.85, y = 0.3}
tbl[6] = {x = 6.9, y = 1}
tbl[7] = {x = 7.8, y = 1.6}
tbl[8] = {x = 8.55, y = 2.4}
tbl[9] = {x = 9.2, y = 3.5}
tbl[10] = {x = 9.6, y = 4.5}
tbl[11] = {x = 10, y = 5.8}
tbl[12] = {x = 10.2, y = 6.9}
tbl[13] = {x = 10, y = 8.2}
tbl[14] = {x = 9.7, y = 9.4}
tbl[15] = {x = 9, y = 10.4}
tbl[16] = {x = 8.4, y = 11.4}
tbl[17] = {x = 7.5, y = 12.25}
tbl[18] = {x = 6.5, y = 13}
tbl[19] = {x = 5.4, y = 13.7}
tbl[20] = {x = 4.2, y = 14}
tbl[21] = {x = 3, y = 14.3}
tbl[22] = {x = 1.8, y = 14.2}
tbl[23] = {x = 0.5, y = 13.9}
tbl[24] = {x = -0.7, y = 13.4}
tbl[25] = {x = -1.7, y = 12.8}
tbl[26] = {x = -2.7, y = 12}
tbl[27] = {x = -3.3, y = 11.1}
tbl[28] = {x = -4, y = 10.1}
tbl[29] = {x = -4.5, y = 9}
tbl[30] = {x = -5, y = 7.8}
tbl[31] = {x = -5.2, y = 6.5}
tbl[32] = {x = -4.9, y = 5.2}
tbl[33] = {x = -4.4, y = 4.2}
tbl[34] = {x = -3.8, y = 3}
tbl[35] = {x = -3.3, y = 1.9}
tbl[36] = {x = -2.4, y = 1}
tbl[37] = {x = -1, y = 0.5}
return tbl
end

function ENT:RotateBall(ang)
local tbl = self:GetBallTbl()
----
local x = tbl[ang].x
local y = tbl[ang].y
local z = 0.4
--
local bone = self:LookupBone("Bone003")
self:ManipulateBonePosition(bone,Vector(x,y,z))
end

function ENT:RotatePin(ang)
local bone = self:LookupBone("Bone002")
local yaw = 0
  if ang < 0 then
    yaw = 11*(ang/-180)
  else
    yaw = 11*(ang/180)
  end
self:ManipulateBoneAngles(bone,Angle((yaw*.1),yaw,ang))
end

function ENT:Think()
if !self.target then return end
self.ang = self.ang or 0
self.pin = self.pin or 0
--
self.nextang = self.nextang or CurTime() - 1
  if self.nextang <= CurTime() then
    local topspeed = 0.04
    local speed = topspeed + 0
	
    self.ang = self.ang + 1
	  if self.ang > 37 then
	    self.ang = 0
		self.loops = self.loops - 1
	  end
    --------
	speed = speed - (speed * (math.Clamp(self.loops,0.8,self.MaxLoops)/self.MaxLoops) )
    --------
	  if self.loops <= 0 and self.ang == self.target then
		self.target = nil
	  end
	self:RotateBall(self.ang)
	self.nextang = CurTime()+speed
  end
--
self.nextspin = self.nextspin or CurTime() - 1  
  if self.nextspin <= CurTime() then
    self.pin = self.pin - 0.6
	self.nextspin = CurTime()+0.01
      if self.pin <= -180 then
	    self.pin = 180
	  end
	--self:RotatePin(self.pin)
  end
end
----------
--NET

net.Receive("SJ_SendNum", function()
local timeleft = net.ReadFloat()
local number = net.ReadFloat()
local ent = net.ReadEntity()
--
ent:SetTargetRoll(number)
ent.NextRoll = CurTime() + timeleft
--
/*
  if ent.PTable then
    if IsValid(ent.PTable[1]) then
	  for i=1,3 do
	    ent.PTable[i]:SetPlayers(players)
	  end
	end
  end
*/
end)

net.Receive("SJ_Begin", function()
local ent = net.ReadEntity()
local players = net.ReadTable()
-----------------
  if !ent.Tbl2D then
    local wait = pig.utility.ShowLoadScreen(0.5,function()
	  ent:Create2DTbl()
	end)
	wait:MakePopup()
	return
  end
----------------
ent:OpenMenu(players)
end)

net.Receive("SJ_NewBet", function()
local ply = net.ReadEntity()
local bet = net.ReadFloat()
local value = net.ReadString()
local ent = net.ReadEntity()
  if tonumber(value) then
    value = tonumber(value)
  end
local color = ent:NumToColor(value) or value
--
  for k,v in pairs(ent.PTable) do
    print(color)
	if v.IDStr == color then
	  v:CreateBox(ply:SteamID64(), {bet = bet, value = value, ply = ply})
	end	
  end
end)
