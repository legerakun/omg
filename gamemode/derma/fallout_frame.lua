local PANEL = {}

function PANEL:Init()
self:SetTitle("")
self:ShowCloseButton(false)
self:SetDraggable(false)
	self.OnKeyCodeReleased = function(me, key)
      if key == KEY_E or key == KEY_ESCAPE then
	    if me.CloseButton then
		  me.CloseButton:DoClick()
		end
	  end
    end
end

function PANEL:ShowClose(bool)
  if bool then
    local back = pig.CreateButton(self,"Exit E)","FO3Font")
    back:SizeToContents()
	local off = self:GetWide()*.05
    back:SetPos(self:GetWide() - (off*.3) - back:GetWide(),self:GetTall()*.825)
    back.DoClick = function()
      surface.PlaySound("ui/ok.mp3")
      self:Remove()
    end
	self.CloseButton = back
  else
    if IsValid(self.CloseButton) then
	  self.CloseButton:Remove()
	end
  end
end

function PANEL:SetTitle1(t1)
if IsValid(self.Title) then self.Title:Remove() end
if IsValid(self.TitleBlur) then self.TitleBlur:Remove() end
self.Title, self.TitleBlur = Fallout_DLabel(self,self:GetWide()*.075,0,t1,"FO3FontBig",Schema.GameColor)
end

function PANEL:Paint()
local title = self.Title
FalloutBlur(self,10)
local dw = self.DownWidth or self:GetTall()*.15
local off_x = self:GetWide()*.03
local off_y = self:GetTall()*.04
  if IsValid(title) then 
    Fallout_QuarterBoxTitle(off_x,off_y,self:GetWide()-(off_x*2),self:GetWide()*.015,dw,title)
  else
    Fallout_QuarterBox(off_x,off_y,self:GetWide()-(off_x*2),dw,"down")
  end
Fallout_QuarterBox(off_x,self:GetTall()-(off_y*1.35),self:GetWide()-(off_x*2),dw,"up")
------
  if pig.utility.IsFunction(self.SecondaryPaint) then
    self:SecondaryPaint(self)
  end
------
end

vgui.Register("Fallout_Frame", PANEL, "DFrame")