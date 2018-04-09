local PANEL = {}
PANEL.TickMat = Material("hud/ticks.png")

function PANEL:InitSlider()
local slider = self.Slider
slider:Dock(NODOCK)
slider:InvalidateParent(true)
slider:SetSize(self:GetWide()*.4, self:GetTall()*.35)
slider:SetPos(self:GetWide()*.85 - slider:GetWide())
slider:CenterVertical()
slider.Knob.Paint = function() return end
  slider.Paint = function(me)
    local tick = 6
	local spacing = 1
	local ticks = 0
	local val = self:GetValue()
	if val > 0 then
	  local sx,_ = me.Knob:GetPos()
	  ticks = (sx+me.Knob:GetWide())/(tick+spacing)
	end
	--local ticks = me:GetWide()/(tick+(spacing-1))
	--ticks = ticks - 1
	
	--local max = self:GetMax()
	--ticks = math.Round(ticks*(val/max), 0, ticks)
	--
	draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,150))
	surface.SetDrawColor(Schema.GameColor)
	surface.SetMaterial(self.TickMat)
	  for i=1,(ticks) do
	    local x = (spacing/2) + ((tick+spacing)*(i-1))
	    surface.DrawTexturedRect(x, 0, tick, me:GetTall())
	  end
  end

local scratch = self.Scratch
scratch.OnMousePressed = function() return end
scratch.OnMouseReleased = function() return end
scratch:Dock(NODOCK)
scratch:InvalidateParent(true)
scratch:SetParent(self)
scratch:SetSize(0,0)
scratch:SetPos(0,0)

local label = vgui.Create("DLabel", self)
label:SetFont("FO3FontSmall")
label:SetText(self.Label:GetText())
local lx, ly = self.Label:GetPos()
label:SetPos(lx, 0)
label:CenterVertical()
label:SetTextColor(Schema.GameColor)
self.Label:Remove()
self.Label = label

self.TextArea:SetFont("FO3FontSmall")
self.TextArea:SetTextColor(Schema.GameColor)
end

vgui.Register("FalloutNumSlider", PANEL, "DNumSlider")