local PANEL = {}

function PANEL:Init()
pig.PigMenuButtons = pig.PigMenuButtons or {
[0] = {Name = "Character Screen", panel = "pig_LoadScreen"},
[1] = {Name = "Attributes", panel = "pig_Attributes"},
[2] = {Name = "Inventory", panel = "pig_InvMenu"},
[3] = {Name = "Options", panel = "pig_Options"},
[4] = {Name = "Quests", panel = "quest_menu"}
}
local can = hook.Call("pig_AddMenuButtons",GAMEMODE,pig)
if can == false then self:Remove() return end
self.startTime = SysTime()
self:SetSize(ScrW()*.225,ScrH())
self:ShowCloseButton(false)
self:SetDraggable(false)
self:MakePopup()
self:SetTitle("")
self:SetBackgroundBlur( true )

self.ButtonList = vgui.Create("pig_PanelList",self)
self.ButtonList:SetSize(self:GetWide() *.725,self:GetTall() *.8)
self.ButtonList:SetPos(0,self:GetTall() *.1)
self.ButtonList:CenterHorizontal()
self.ButtonList:SetSpacing(5)
self.ButtonList:EnableVerticalScrollbar(true)
  for k,v in SortedPairs(pig.PigMenuButtons,false) do
    local but = pig.CreateButton(nil,v.Name,"PigFontSmall")
    but:SetSize(self.ButtonList:GetWide(),self.ButtonList:GetTall() *.125)
    but.Pan = v.panel
    but.DoClick = function(me)
	  if pig.utility.IsFunction(v.panel) then
	    pig.vgui.PigMenuPan = v.panel(self)
	  else
	    pig.vgui.PigMenuPan = vgui.Create(v.panel)
	  end
	  local pan = pig.vgui.PigMenuPan
	  if !pan.NonModify then
        pan:Center()
	  end
      pan:MakePopup()
      self.ButtonList:GetParent():Remove()
    end
    self.ButtonList:AddItem(but)
  end
hook.Call("pig_F4Menu_Open",GAMEMODE,self)
end  

function PANEL:Paint()
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,105) )
end

vgui.Register("pig_PigMenu", PANEL, "DFrame")