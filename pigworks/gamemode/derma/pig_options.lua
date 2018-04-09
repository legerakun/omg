local PANEL = {}

function PANEL:Init()
self.Sizes = ScrW() / 2,ScrH() *.6
local op = pig.OptionTbl
self:ShowCloseButton(false)
self:SetSize(ScrW() / 2,ScrH() *.6)
self:SetTitle("")
  if !IsValid(self.CloseButton) then
    self.CloseButton = pig.CreateButton(self,"Close","PigFontTiny")
  end
self.CloseButton:SetSize(self:GetWide() *.065,self:GetTall()*.045)
self.CloseButton:SetPos(self:GetWide() *.91,self:GetTall() *.02)
  self.CloseButton.DoClick = function()
    self:Remove()
  end
  if !IsValid(self.OpsList) then
    self.OpsList = vgui.Create("pig_PanelList",self)
  end
for k,v in pairs(self.OpsList:GetItems()) do v:Remove() end
local OpList = self.OpsList
OpList:SetSize(self:GetWide() *.875,self:GetTall() *.825)
OpList:SetPos(0,self:GetTall() *.1)
OpList:SetSpacing(self:GetWide() *.035)
OpList:CenterHorizontal()
OpList:EnableVerticalScrollbar(true)
OpList:EnableHorizontal(true)
  for k,v in pairs(op) do
    if v.Slider then
      local sa = vgui.Create("DNumSlider")
	  sa.IsSlider = true
      sa:SetSize(OpList:GetWide()*.475,OpList:GetTall() *.15)
      sa:SetMin(v.Min or 0)
      if v.Think != nil then
        sa.Think = function(self)
          v.Think(self)
        end
      end
	  sa.Label:SetTextColor(Schema.GameColor)
	  sa.TextArea:SetTextColor(Schema.GameColor)
      sa:SetMax(v.Max or 10)
      sa:SetDecimals(0)
	  if v.SetFunc then
	    local val = v.SetFunc()
		if val then
		  sa:SetValue(val)
		end
	  end
      sa:SetText(v.OpName)
      sa.OnValueChanged = function(self)
        v.OpFunc(self:GetValue())
      end
      OpList:AddItem(sa)
    else
      local but = pig.CreateButton(nil,v.OpName,"PigFont")
      but:SetSize(OpList:GetWide() *.475,OpList:GetTall() *.15)
      but.DoClick = v.OpFunc
      OpList:AddItem(but)
    end
  end
hook.Call("pig_Options_Open",GAMEMODE,self)
end

function PANEL:Paint()
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,105) )
end

function PANEL:OnRemove()
pig.SaveOptions()
end

vgui.Register("pig_Options", PANEL, "DFrame")