local PANEL = {}

function PANEL:Init()
	self.OnKeyCodeReleased = function(me, key)
      if key == KEY_E or key == KEY_ESCAPE then
	    if me.CloseButton then
		  me.CloseButton:DoClick()
		end
	  end
    end
--
local base = self
base:SetDraggable(false)
base:SetTitle("")
base:SetSize(ScrW()*.725,ScrH()*.825)
base:Center()
base:ShowCloseButton(false)
base:MakePopup()
base.Off = base:GetWide()*.03
base.LootW = base:GetWide()*.415
local off = base.Off
local loot_w = base.LootW

base.Table1 = vgui.Create("pig_PanelList",base)
local my_inv = base.Table1
my_inv:SetSize(loot_w,base:GetTall()*.45)
local offset = base:GetWide()*.035
my_inv:SetPos(offset,base:GetTall()*.1)

base.Table2 = vgui.Create("pig_PanelList",base)
local l_inv = base.Table2
l_inv:SetSize(loot_w,base:GetTall()*.45)
l_inv:SetPos((base:GetWide()-l_inv:GetWide())-offset,base:GetTall()*.1)

local info = vgui.Create("DPanel",base)
info:SetSize(base:GetWide()*.6,base:GetTall()*.125)
info:SetPos(base:GetWide()*.2,base:GetTall()*.7)
info.Paint = function(me)
  local spacing = me:GetWide()*.015
  local length = me:GetWide()/3 - (spacing*3)
  local col = Schema.GameColor
  ---------
  --TOP
  if base.first and base.firstval then
    Fallout_AddInfo(0, 0, length, me:GetTall()*.45, base.first, base.firstval, "FO3Font")
  end
  local num = 1
  Fallout_AddInfo((length+spacing) *num,0,length,me:GetTall()*.45,"WG",base.wg or "--","FO3Font")
  num = num + 1
  Fallout_AddInfo((length+spacing) *num,0,length,me:GetTall()*.45,"VAL",base.val or 0,"FO3Font")
  --BOTTOM
  num = 0
  Fallout_AddInfo((length+spacing) *num,me:GetTall()/2,length,me:GetTall()*.45,"CND","","FO3Font")
  draw.RoundedBox(0,((length+spacing) *num)+(length*.5),me:GetTall()*.625,length*.4, me:GetTall()*.225,Color(col.r*.35,col.g*.35,col.b*.35))
  if base.cnd and base.cnd > 0 then
    draw.RoundedBox(0,((length+spacing) *num)+(length*.5),me:GetTall()*.625,(length*.4) *(base.cnd/100), me:GetTall()*.225,col)
  end
  num = num + 1
  local effects = nil
    if base.eff and pig.utility.IsFunction(base.eff) then
	  effects = base.eff()
	else
	  effects = base.eff
	end
  Fallout_AddInfo((length+spacing) *num,me:GetTall()/2,length*2+(spacing),me:GetTall()*.45, base.effname or "EFFECTS", effects or "--","FO3Font")  
end

local pic = vgui.Create("DPanel",base)
pic:SetSize(base:GetWide()*.19,base:GetTall()*.325)
pic:SetPos(base:GetWide()*.05,base:GetTall()*.6)
pic.Paint = function(me)
  if !base.pic then return end
  surface.SetDrawColor(Schema.GameColor)
  surface.SetMaterial(Material(base.pic))
  surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
end

local back = pig.CreateButton(base,"Exit E)","FO3Font")
base.CloseButton = back
back:SetSize(base:GetWide()*.075,back:GetTall()*1.5)
back:SetPos(base:GetWide() - off - back:GetWide(),base:GetTall()*.825)
back.DoClick = function()
  surface.PlaySound("ui/close_loot.wav")
  base:Remove()
end

end

function PANEL:SetTitles(t1,t2)
self.Title1 = Fallout_DLabel(self,self:GetWide()*.075,0,t1,"FO3FontBig",Schema.GameColor)
self.Title2 = Fallout_DLabel(self,self:GetWide()*.6,0,t2,"FO3FontBig",Schema.GameColor)
end

function PANEL:SetDrawWG(bool)
  if bool then
    self.DrawWG = true
  else
    self.DrawWG = false
  end
end

function PANEL:Paint()
  local me = self
  local title1 = me.Title1
  local title2 = me.Title2
  if !IsValid(title1) or !IsValid(title2) then return end
  local off = me.Off
  local loot_w = me.LootW
  Derma_DrawBackgroundBlur(me,SysTime()-0.6)
  FalloutBlur(me,10)
  local spacing = me:GetWide()*.01
  Fallout_QuarterBox(off,me:GetTall()*.94,me:GetWide()-(off*2),me:GetTall()*.05,"up")  
  ------------------
  --My_Inv
  local h1 = me:GetTall()*.615
  local w1 = me:GetWide()*.415
  if self.DrawWG then
    local mxwg = LocalPlayer():GetMaxWeight()
    mxwg = math.Round(mxwg,2)
    local wg = LocalPlayer().WG
    wg = math.Round(wg,1)
    draw.SimpleText("Wg "..wg.."/"..mxwg,"FO3FontHUD",(off*.5)+w1,me:GetTall()*.03,Schema.GameColor,TEXT_ALIGN_RIGHT)
  end
  Fallout_QuarterBox(off,h1,w1,h1*.075,"up")
  Fallout_QuarterBoxTitle(off,me:GetTall()*.025,w1,spacing,h1*.075,title1)
  -------------------
 --L_Inv
  local h2 = me:GetTall()*.615
  local w2 = me:GetWide()*.415
  Fallout_QuarterBox(me:GetWide() - (loot_w+off),h2,w2,h2*.075,"up")
  Fallout_QuarterBoxTitle(me:GetWide() - (loot_w+off),me:GetTall()*.025,w2,spacing,h2*.075,title2)
end

vgui.Register("Fallout_LootMenu", PANEL, "DFrame")