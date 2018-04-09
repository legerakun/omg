local PANEL = {}

function PANEL:Init()
self.Logo = Material("pigworks/piglogo.png")
self.StringMat = Material("pigworks/light_string.png")
self.Bulb = Material("pigworks/light_bulb.png")
self.Shadow = Material("pigworks/pigshadow.png")
self.Dark = Material("gui/center_gradient")
self:SetTitle("")
self:SetDraggable(false)
self:ShowCloseButton(false)
self:SetSize(ScrW(), ScrH())
end

function PANEL:SetCosmetic(bool)
self.Cosmetic = bool
end

function PANEL:SetTime(time,func)
self:SetForce(true)
  timer.Create("PW_WaitRemove",time,1,function()
    if !IsValid(self) then return end
	  if func and pig.utility.IsFunction(func) then
	    func()
	  end
	self:SetForce(false)
  end)
end

function PANEL:SetForce(bool)
self.Force = bool
end

function PANEL:Think()
  if !pig.FinishedLoading then
    return
  end
  if self.Force == true then return end
  --
  if self.Cosmetic then
    self:Remove()
	return
  end
  --
  if !IsValid(pig.vgui.LoadScreen) and !self.Opened then
    pig.OpenLoadScreen()
	self.Opened = true
  end
  if pig.utility.IsFunction(LocalPlayer().GetCharID) and LocalPlayer():GetCharID() and LocalPlayer().CharVars and LocalPlayer().Inventory then
	self:Remove()
  end
end

function PANEL:Paint()
local repaint = hook.Call("pig_WaitScreenOpen",GAMEMODE,self)
if repaint == true then return end
--
draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(40,40,40,255))
surface.SetDrawColor(0,0,0)
surface.SetMaterial(self.Dark)
surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
--
surface.SetDrawColor(255,255,255)
surface.SetMaterial(self.Logo)
local mw = self:GetWide()*.225
surface.DrawTexturedRect(self:GetWide()/2 - (mw/2), self:GetTall()*.6 - (mw/2), mw, mw)
--
surface.SetDrawColor(255,255,255)
surface.SetMaterial(self.StringMat)
local bw = mw*.75
surface.DrawTexturedRect(self:GetWide()/2 - (bw/2), self:GetTall()*.57 - (mw), bw, bw)
--
self.Alpha = self.Alpha or 0
local speed = 0
speed = 1
self.Speed = self.Speed or speed
  if self.Alpha >= 255 or self.Alpha <= 0 then
    self.Speed = -self.Speed
  end
self.Alpha = math.Clamp(self.Alpha + self.Speed,0, 255)
--
local alpha = self.Alpha
surface.SetDrawColor(alpha,alpha,alpha)
surface.SetMaterial(self.Bulb)
surface.DrawTexturedRect(self:GetWide()/2 - (bw/2), self:GetTall()*.57 - (mw), bw, bw)

surface.SetDrawColor(255,255,255,255 - (alpha-20))
surface.SetMaterial(self.Shadow)
surface.DrawTexturedRect(self:GetWide()/2 - (mw/2), self:GetTall()*.6 - (mw/2), mw, mw)
--
self.Dots = self.Dots or ""
self.NextDot = self.NextDot or CurTime()
  if self.NextDot <= CurTime() then
    if self.Dots:len() >= 3 then
	  self.Dots = ""
	else
      self.Dots = self.Dots.."."	
	end
	self.NextDot = CurTime() + 0.2
  end
draw.Blur(self,2,2,255)
draw.SimpleText("LOADING"..self.Dots,"PigFontTitle",self:GetWide()/2,self:GetTall()*.85,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_BOTTOM)
end

vgui.Register("pig_WaitScreen", PANEL, "DFrame")