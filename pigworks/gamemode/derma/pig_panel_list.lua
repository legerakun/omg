local PANEL = {}

function PANEL:DefaultPaint()
  self.VBar.Paint = function(self)
    draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color( 70, 70, 70, 100 ) )
  end
  local col = self.DrawColor or Schema.GameColor
  self.VBar.btnUp.Paint = function(self)
    draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color(col.r,col.g,col.b,100) )--0,154,255 
  end
  self.VBar.btnDown.Paint = function(self)
    draw.RoundedBox( 0, 0, 0, self:GetWide(), self:GetTall(), Color(col.r,col.g,col.b,100) )
  end
  self.VBar.btnGrip.Paint = function(me)
    local half = self.HalfPaint
    if half then
	  local w = me:GetWide()*.3
      draw.RoundedBox( 0, me:GetWide()/2 - (w/2), 0, w, me:GetTall(), col )	
	return end
    draw.RoundedBox( 0, 0, 0, me:GetWide(), me:GetTall(), col )
  end
end

function PANEL:Init()
self:EnableVerticalScrollbar(true)
self:DefaultPaint()
hook.Call("pig_PanelList_Open",GAMEMODE,self)
end

vgui.Register("pig_PanelList", PANEL, "DPanelList")