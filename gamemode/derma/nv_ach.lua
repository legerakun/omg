local PANEL = {}

function PANEL:Init()
self.OldPaint = self.Paint
self:MakePopup()
self:SetSize(ScrW()*.6,ScrH()*.7)
self:Center()
self:ShowClose(true)
self.DownWidth = self:GetTall()*.08
self.Off = self:GetWide()*.075
--
self:SetTitle1("F:NV STEAM ACHIEVEMENTS")
--
local list = vgui.Create("pig_PanelList",self)
local space = self:GetTall()*.025
list:SetSize(self:GetWide()-(self.Off*.65),self:GetTall()-((self.Off*1.25) + self.DownWidth) - space)
--list:SetPos(0,self:GetTall()*.085)
list:Center()
list:SetSpacing(3)
self.List = list
--
local close = self.CloseButton
close:SetPos(self:GetWide()-(close:GetWide()*1.25),self:GetTall()-(close:GetTall()*1.25)-(self.Off/2))
--
  for k,v in SortedPairs(LocalPlayer().NV_Achievements or {}) do
    local tbl = NV_APIToName(k)
	if !tbl then continue end
    local base = vgui.Create("DPanel")
	base:SetSize(list:GetWide(),list:GetTall()/4.5)
	base.Paint = function(me)
	  local iw = me:GetWide()*.125
	  local spacing = me:GetWide()*.01
	  --
	  draw.RoundedBox(0,iw+spacing,0,me:GetWide() - (iw+spacing),me:GetTall(),Color(10,10,10,120))
	  Fallout_DrawText(iw+spacing + (spacing*3),me:GetTall()*.275,tbl.Name,"FO3Font",Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  surface.SetFont("FO3Font")
	  local tw,th = surface.GetTextSize("|")
	  draw.SimpleText(tbl.Desc,"FO3FontSmall",iw+spacing + (spacing*3),me:GetTall()*.275+th,Color(255,255,255),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  draw.SimpleText("In Game Reward: "..tbl.Reward,"FO3FontSmall",iw+spacing + (spacing*3),me:GetTall()*.275+(th*1.65),Color(204,204,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	--
	  
	  if v != 1 then
	    draw.RoundedBox(0,0,0,iw,me:GetTall(),Color(125,125,125))
	    surface.SetDrawColor(100,100,100)	  
	  else
	    draw.RoundedBox(0,0,0,iw,me:GetTall(),Color(255,255,255))
	    surface.SetDrawColor(255,255,255)
      end
	  surface.SetMaterial(Material(tbl.Icon))
	  surface.DrawTexturedRect(0,0,iw,me:GetTall())
	    if v != 1 then
		  local mw = iw*.4
		  local mh = me:GetTall()*.7
	      surface.SetDrawColor(155,155,155)
		  surface.SetMaterial(Material("pw_fallout/v_lock.png"))
	      surface.DrawTexturedRect(iw/2 - (mw/2),me:GetTall()/2 - (mh/2),mw,mh)
	    end
	end
	--
	list:AddItem(base)
  end
  
  self.Paint = function(me)
    Derma_DrawBackgroundBlur(me,SysTime()-0.6)
    me.OldPaint(me)
  end
end

vgui.Register("NV_Achievements", PANEL, "Fallout_Frame")