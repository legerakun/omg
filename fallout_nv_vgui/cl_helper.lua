
function Fallout_Line(x,y,dir,length,solid,color,ac_width)
local tab = {}
local line_width = ac_width or 3
local direction = nil
tab["right"] = "fade_to_right.vtf"
tab["left"] = "fade_to_left.vtf"
tab["up"] = "fade_to_top.vtf"
tab["down"] = "fade_to_bottom.vtf"
if !tab[dir] then
error("No direction given for line!!")
end
direction = "hud/"..tab[dir]
-------------------------

surface.SetDrawColor(color or Schema.GameColor)
if !solid then
surface.SetMaterial(Material(direction))
end
if dir == "right" or dir == "left" then
if solid then
surface.DrawRect(x,y,length,line_width)
else
surface.DrawTexturedRect(x,y,length,line_width)
end
elseif dir == "up" or dir == "down" then
if solid then
surface.DrawRect(x,y,line_width,length)
else
surface.DrawTexturedRect(x,y,line_width,length)
end
end

end

function Fallout_HalfBox(x,y,w,h,dw)
dw = dw or h*.25
w = w-(x*2)
h = h-(y*2)
Fallout_Line(x-(3/2),y,"down",dw)
Fallout_Line(x,y,"right",w,true)
Fallout_Line((x+w)-(3/2),y,"down",dw)
Fallout_Line(x-(3/2),(y+h)-dw,"up",dw)
Fallout_Line(x,(y+h-3),"right",w,true)
Fallout_Line((x+w)-(3/2),(y+h)-dw,"up",dw)
end

function Fallout_FullBox(x,y,w,h)
Fallout_Line(x,y,"down",h,true)
Fallout_Line(x,y,"right",w,true)
Fallout_Line((x+w)-(3),y,"down",h,true)
Fallout_Line(x,(y+h-3),"right",w,true)
end

function Fallout_QuarterBox(x,y,w,dw,u_dir)
dw = dw or h*.25

  if u_dir == "up" then
  Fallout_Line((x+w)-(3/2),y-dw+3,u_dir,dw)  
  Fallout_Line(x-(3/2),y-dw+3,u_dir,dw)  
  else
  Fallout_Line((x+w)-(3/2),y,u_dir,dw)  
  Fallout_Line(x-(3/2),y,u_dir,dw)
  end
Fallout_Line(x,y,"right",w,true)
end

function Fallout_AddInfo(x,y,length,height,name,val,font)
local h = height
local col = Schema.GameColor
----------------------------------------------------------------
draw.SimpleText(name,font,x,y + (h *.2),Color(col.r,col.g,col.b),TEXT_ALIGN_LEFT,0)
draw.SimpleText(val,(font),x + (length*.95),y+height/2,Color(col.r,col.g,col.b),TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
--
Fallout_Line(x,y,"left",length,true,col)
Fallout_Line(x + length - 3,y,"down",h,false,col)
--draw.SimpleText( text, font,x, y, col,allign,0 )
end

function Fallout_QuarterBoxTitle(x,y,w,spacing,dw,title)
dw = dw or h*.25

  local tx1,tx2 = title:GetPos()
  local w1 = tx1+0
  w1 = w1-x-spacing
  Fallout_Line(x,y,"right",w1,true)
  --
  local w2 = x + w - (tx1+title:GetWide()+spacing)
  Fallout_Line(tx1+title:GetWide() + spacing,y,"right",w2,true)
  Fallout_Line(x+w-3,y,"down",dw)
  Fallout_Line(x,y,"down",dw)  
end

function FalloutBlur(panel,thickness,xpos,ypos,width,height)
local x,y = nil
local w,h = nil
local xe,ye = nil
  if IsValid(panel) then
    x,y = panel:GetPos()
	w,h = panel:GetSize()
	xe,ye = panel:ScreenToLocal(x,y)
  else
    x,y = 0,0
	w,h = width,height
	xe,ye = xpos,ypos
  end
local col = Color(0,18,10)
  for i = 0,thickness do
    draw.RoundedBox( 8, xe + (i * 2), ye + (i * 2), w - (i * 4), h - (i * 4), Color(col.r,col.g,col.b,25 + (i * 4)) )
  end
  draw.RoundedBox(8,xe+(thickness*2), ye+(thickness*2), w - (thickness*4), h - (thickness*4), Color(col.r,col.g,col.b,25 + (thickness*4)) )
end

function Fallout_DLabel(parent,x,y,text,font,color)
local font2 = Fallout_GetBlurFont(font)
local text2 = vgui.Create("DLabel",parent)
text2:SetPos(x,y)
text2:SetText(text)
text2:SetFont(font2)
text2:SetTextColor(Color(color.r *.6,color.g *.6,color.b *.6))
text2:SetAutoStretchVertical( true )
text2:SizeToContents()
text2:SetWrap(true)

local text1 = vgui.Create("DLabel",parent)
text1:SetPos(x,y)
text1:SetText(text)
text1:SetFont(font)
text1:SetTextColor(color)
text1:SetAutoStretchVertical( true )
text1:SizeToContents()
text1:SetWrap(true)
--
text2.OldThink = text2.Think
text2.Think = function(me)
  if !IsValid(text1) then
    me:Remove()
  end
  me.OldThink(me)
end
/*
surface.SetFont(text1:GetFont())
text1:SetText(pig.NewLines(text1:GetText(),parent))
text1:SizeToContents()
*/
return text1,text2
end

function Fallout_DrawText(x,y,text,font,col,allign_x,allign_y)
local noblur = false
local blur_font = Fallout_GetBlurFont(font)
if blur_font == nil then
noblur = true
end
if !noblur then
for i=0,1 do
	draw.SimpleText( text, blur_font,x, y,Color(col.r *.6,col.g *.6,col.b *.6),allign_x, allign_y)
end
end
draw.SimpleText( text, font,x, y, col, allign_x, allign_y )
end

function Fallout_AmountBox(text, min, max, func)
local box = vgui.Create("Fallout_Frame")
box:SetSize(ScrW()*.275, ScrH()*.2)
box:ShowClose(true)
box:Center()
box:MakePopup()

local slider = vgui.Create("FalloutNumSlider", box)
slider:SetDecimals(0)
slider:SetMin(min or 0)
slider:SetValue(0)
slider:SetText(text or "<Insert Text>")
slider:SetMax(max or 100)
slider:SetSize(box:GetWide()*.7, box:GetTall()*.25)
slider:Center()
slider:InitSlider()
  slider.OnValueChanged = function(me)
    me.NextPlay = me.NextPlay or CurTime()-1
	  if me.NextPlay <= CurTime() then
	    surface.PlaySound("ui/ui_menu_prevnext.wav")
        me.NextPlay = CurTime()+0.1
	  end
  end

local label = slider.Label
label:SetParent(box)
label:SizeToContents()
label:SetPos(0, box:GetTall()*.2)
label:CenterHorizontal()

local slid = slider.Slider
slid:SetSize(slider:GetWide(), slider:GetTall()*.4)
local sx, sy = slid:GetPos()
slid:SetPos(0, sy)

local textarea = slider.TextArea
textarea:Dock(NODOCK)
textarea:SetParent(box)
local sx, sy = slider:GetPos()
textarea:SetFont("FO3Font")
textarea:SizeToContents()
textarea:SetWide(textarea:GetWide()*1.5)
textarea:SetPos(0, sy + slider:GetTall()*1.1)
textarea:CenterHorizontal()

local bw = box:GetTall()*.075
local right = vgui.Create("DButton", box)
right:SetSize(bw, bw)
right:SetText("")
right:SetPos(sx + slider:GetWide()*1.025, sy + (slider:GetTall()*.82) - slid:GetTall())
  right.DoClick = function(me)
    slider:SetValue(math.Clamp(slider:GetValue() + 1, min or 0, max or 100))
  end
  right.Paint = function(me,w,h)
    surface.SetDrawColor(Schema.GameColor)
	surface.SetMaterial(Material("ui/right.png"))
	surface.DrawTexturedRect(0,0,w,h)
  end
  
local left = vgui.Create("DButton", box)
left:SetSize(bw, bw)
left:SetText("")
left:SetPos(sx - (bw*1.5), sy + (slider:GetTall()*.82) - slid:GetTall())
  left.DoClick = function(me)
    slider:SetValue(math.Clamp(slider:GetValue() - 1, min or 0, max or 100))
  end
  left.Paint = function(me,w,h)
    surface.SetDrawColor(Schema.GameColor)
	surface.SetMaterial(Material("ui/left.png"))
	surface.DrawTexturedRect(0,0,w,h)
  end  

local close = box.CloseButton
close:SetText("Cancel C)")
close:SetFont("FO3FontSmall")
close:SizeToContents()
close:SetPos(box:GetWide()*.975 - close:GetWide(), box:GetTall()*.85 - close:GetTall())

local accept = pig.CreateButton(box, "Accept A)", "FO3FontSmall")
accept:SizeToContents()
local cx, cy = close:GetPos()
accept:SetPos(box:GetWide()*.975 - close:GetWide(), cy - close:GetTall())
  accept.DoClick = function(me)
    if func then
	  func(math.Round(slider:GetValue()))
	end
    close:DoClick()
  end

return box
end

function Fallout_DrawFullText(x,y,text,font,col,blur_col,allign_x,allign_y)
local noblur = false
local blur_font = Fallout_GetBlurFont(font)
if blur_font == nil then
noblur = true
end
if !noblur then
for i=0,1 do
	draw.DrawText( text, blur_font,x, y,blur_col or Color(col.r *.6,col.g *.6,col.b *.6), allign_x, allign_y)
end
end
draw.DrawText( text, font,x, y, col, allign_x, allign_y )
end

function Fallout_DTextEntry()
  local TextEntry = vgui.Create( "DTextEntry" )
  TextEntry:SetText( "" )
  TextEntry:SetFont("FO3FontSmall")
  TextEntry:SetTextColor(Schema.GameColor)
  TextEntry:SetDrawBorder( false )
  TextEntry:SetDrawBackground( false )
  TextEntry:SetCursorColor(color_white)
  TextEntry.Paint = function(me)
	Fallout_Line(0,0,"right",me:GetWide(),true)
	Fallout_Line(0,me:GetTall() - 3,"right",me:GetWide(),true)
	Fallout_Line(0,0,"down",me:GetTall(),true)
	Fallout_Line(me:GetWide() - 3,0,"down",me:GetTall(),true)
	derma.SkinHook( "Paint", "TextEntry", me, me:GetWide(), me:GetTall() )
  end
return TextEntry
end

function Fallout_GetBlurFont(font)
local tab = {}
local blur_font = font.."_Blur"
return blur_font
end
