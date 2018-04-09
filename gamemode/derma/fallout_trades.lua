local PANEL = {}

function PANEL:Init()
--
FalloutTutorial("Trading")
--
self.OldPaint = self.Paint
self:MakePopup()
self:SetSize(ScrW()*.4,ScrH()*.6)
self:Center()
self:ShowClose(true)
self.DownWidth = self:GetTall()*.08
self.Off = self:GetWide()*.05
--
self:SetTitle1("TRADE OFFERS")
--
local list = vgui.Create("pig_PanelList",self)
list:SetSize(self:GetWide()-(self.Off*2),self:GetTall()*.74)
list:SetPos(0,self:GetTall()*.085)
list:CenterHorizontal()
self.List = list

  for k,v in SortedPairs(LocalPlayer().TradeOffers or {}) do
    local title = k.."'s Trade Offer"
    local but = pig.CreateButton(nil,title,"FO3Font")
	but.Index = k
	but:SetSize(list:GetWide(),list:GetTall()/7)
	but.DoClick = function(me)
	  surface.PlaySound("ui/ok.mp3")
	  self:SetVisible(false)
	  Fallout_PreviewTrade(v.Receive,v.Take,nil,self,k)
	end
	--
	list:AddItem(but)
  end
  
  self.Paint = function(me)
    Derma_DrawBackgroundBlur(me,SysTime()-0.6)
    me.OldPaint(me)
  end
end

vgui.Register("Fallout_Trades", PANEL, "Fallout_Frame")