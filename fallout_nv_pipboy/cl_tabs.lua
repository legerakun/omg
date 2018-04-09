PipBoy3000 = PipBoy3000 or {}
PipBoy3000.StartPos = {x = .125,y = .825}

function PipBoy3000.MakeTab(name,func,k)
local pip = PipBoy3000.Base
local screen = pip.Screen
local but = pig.CreateButton(screen,name,"FO3FontPip")
but:SizeToContents()
local w,h = but:GetSize()
local space = screen:GetWide()*.04
but:SetSize(w + (space),h + (screen:GetTall() *.02))
but.DoClick = function(me,dont)
  pip.MouseNoDraw = false
  PipBoy3000.SavedTab = k
  pip.NextClick = pip.NextClick or CurTime() - 1
  if pip.NextClick > CurTime() then return end
  pip.NextClick = CurTime() + 0.25
  PipBoy3000.ButtonSound(dont)
  if pip.Elements then
    for k,v in pairs(pip.Elements) do
    v:Remove()
  end
  pip.Elements = nil
end
pip.Selected = name
local length = screen:GetWide() *(PipBoy3000.StartPos.x *.48)
local tb = func(screen,screen:GetWide() * PipBoy3000.StartPos.x - length)
  if tb then 
    pip.Elements = tb
	if pip.Draw3D then
	  for k,v in pairs(tb) do
	    v:SetCursor("blank")
	  end
	end
  end
end
but.Paint = function(me)
if !me.ins then return end
local col = Schema.GameColor
surface.SetDrawColor(Schema.GameColor)
surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
--
draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
end
pip.Tabs[#pip.Tabs + 1] = but
end

function PipBoy3000.SortTabs()
local pip = PipBoy3000.Base
local screen = pip.Screen
local tbl = pip.Tabs
--
local x,y = nil
local element = nil
----------------------------
local space = pip.Screen:GetWide() - (pip.Screen:GetWide() * (PipBoy3000.StartPos.x * 2))
local total_w = 0
for k,v in pairs(tbl) do
v:SetPos(pip.Screen:GetWide() * PipBoy3000.StartPos.x,pip.Screen:GetTall() *PipBoy3000.StartPos.y)
total_w = total_w + v:GetWide()
end
----------------------------
local spacing = (space-total_w)/(#tbl - 1)
----------------------------
  for k,v in pairs(tbl) do
    if k != 1 then
      element = tbl[k - 1]
      x,y = element:GetPos()
      v:SetPos(x + (element:GetWide()) + spacing,y)
    end
  end
-----------------------------
end

function PipBoy3000.Open3DMode(dir)
local pip = PipBoy3000.Base
pip.NextChange = pip.NextChange or CurTime() - 1
if pip.NextChange > CurTime() then return end
pip.NextChange = CurTime() + 0.5
pip.Tab3D = pip.Tab3D or 1
  if dir == "right" then
    pip.Tab3D = pip.Tab3D + 1
	if pip.Tab3D > 3 then
	  pip.Tab3D = 1
	end
  elseif dir == "left" then
    pip.Tab3D = pip.Tab3D - 1
	if pip.Tab3D < 1 then
	  pip.Tab3D = 3
	end
  end
-----------
  for k,v in pairs(PipBoy3000.Base.Tabs) do v:Remove()
    pip.Tabs[k] = nil
  end
-----------
  PipBoy3000.ModeSound()
  if pip.Tab3D == 1 then
    PipBoy3000.OpenStats(true)
  elseif pip.Tab3D == 2 then
    PipBoy3000.OpenItems(true)
  elseif pip.Tab3D == 3 then
    PipBoy3000.OpenData(true)    
  end
end

function PipBoy3000.AddInfo(x,y,length,name,val,font)
local h = PipBoy3000.Base.Screen:GetTall() *.075
local col = Schema.GameColor
----------------------------------------------------------------
draw.SimpleText(name,font or "FO3FontPip",x,y + (h *.2),Color(col.r,col.g,col.b),TEXT_ALIGN_LEFT,0)
surface.SetFont(font or "FO3FontPip")
local tw,th = surface.GetTextSize(val)
draw.SimpleText(val,(font or "FO3FontPip"),x + length - (PipBoy3000.Base.Screen:GetWide() *.015) - tw,y + (h *.2),Color(col.r,col.g,col.b),TEXT_ALIGN_LEFT,0)
--
Fallout_Line(x,y,"left",length,true,col)
Fallout_Line(x + length - 3,y,"down",h,false,col)
--draw.SimpleText( text, font,x, y, col,allign,0 )
end

function PipBoy3000.ButtonSound(dont)
if !dont then
if LocalPlayer().ButtonTab != nil then LocalPlayer().ButtonTab:Stop() end
LocalPlayer().ButtonTab = CreateSound(LocalPlayer(),"ui/ui_pipboy_tab.mp3")
local sound = LocalPlayer().ButtonTab
sound:ChangeVolume(1)
sound:Play()
end
--
LocalPlayer().ButtonBuzzNext = LocalPlayer().ButtonBuzzNext or CurTime() - 1
if LocalPlayer().ButtonBuzzNext > CurTime() then return end
LocalPlayer().ButtonBuzzNext = CurTime() + math.random(1,3)
if LocalPlayer().ButtonBuzz != nil then LocalPlayer().ButtonBuzz:Stop() end
local ran = math.random(1,5)
LocalPlayer().ButtonBuzz = CreateSound(LocalPlayer(),"ui/ui_static_"..ran..".mp3")
local sound = LocalPlayer().ButtonBuzz
sound:ChangeVolume(1)
sound:Play()
end