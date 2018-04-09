local PANEL = {}
PANEL.Buts = {}
PANEL.Buts[1] = {
Name = "DELETE CHAR",
Func = function(self)
self:DeleteChar(self.Player)
end
}
PANEL.Buts[2] = {
Name = "CHANGE NAME",
Mod = true,
Func = function(self)
self:ChangeName(self.Player)
end
}
PANEL.Buts[3] = {
Name = "CHANGE DESC",
Mod = true,
Func = function(self)
self:ChangeDesc(self.Player)
end
}
PANEL.Buts[4] = {
Name = "KICK",
Mod = true,
Func = function(self)
local player = self.Player
if !IsValid(player) then return end
LocalPlayer():ConCommand('say !kick "'..player:Name()..'" "No reason provided (Admin Menu)"')
end
}

---------------------------
function PANEL:Init()
self.Sizes = ScrW() / 2,ScrH() *.6
self.SizeW = ScrW() / 2
self.SizeH = ScrH() *.6
self:ShowCloseButton(false)
local w,h = self:GetSize()
if w < 1 and h < 1 then
local w = self.SizeW
local h = self.SizeH
self:SetSize(w,h)
end
self:SetTitle("")
self:ShowClose(true)
  if !LocalPlayer():IsSuperAdmin() then 
    self.NonSuper = true
  end
  if !LocalPlayer():IsModerator() then
    self.NonStaff = true
  return end
-----------------------------------------------------
if self.NonStaff then return end
if IsValid(self.list) then self.list:Remove() end
self.list = vgui.Create("pig_PanelList",self)
local list = self.list
local w = self.SizeW
local h = self.SizeH
list:SetSize(w *.45,h *.825,w *.05,h*.05)
list:SetPos(w *.05,h *.1)
for k,v in pairs(player.GetAll()) do

local base = pig.CreateButton(nil,v:Name(),"PigFont")
base:SetSize(list:GetWide(),h *.1)
base.DoClick = function()
self.Player = v
end
list:AddItem(base)

end
------------------
local box = vgui.Create("DPanel",self)
self.Box = box
box:SetSize(list:GetWide(), list:GetTall()*.4)
local lx,ly = list:GetPos()
if IsValid(self.hlist) then self.hlist:Remove() end
self.hlist = vgui.Create("pig_PanelList", self)
local hlist = self.hlist
hlist:SetSize(box:GetWide(), list:GetTall()*.4)
hlist:SetPos(lx + list:GetWide(), ly)
box:SetPos(lx + list:GetWide(),ly + hlist:GetTall()*1.05)
hlist:EnableHorizontal(true)
hlist:EnableVerticalScrollbar(true)
for k,v in ipairs(self.Buts) do
local delete = pig.CreateButton(nil,v.Name,"PigFontSmall")
delete:SetSize(hlist:GetWide()/2, hlist:GetTall()/4)
delete:CenterHorizontal()
delete.DoClick = function()
if !LocalPlayer():IsSuperAdmin() then return end
v.Func(self)
end
hlist:AddItem(delete)
end
box.Paint = function(me)
if !LocalPlayer():IsSuperAdmin() then return end
draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,20))
surface.SetDrawColor(Schema.GameColor)
surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
if self.Player == nil then return end
local x = me:GetWide() *.025
local y = x
--
local ply = self.Player
  if !IsValid(ply) then
    return
  end
surface.SetFont("PigFontSmall")
local tw,th = surface.GetTextSize("Default")
draw.DrawText("Selected Player: "..ply:Name(),"PigFontSmall",x,y,Schema.GameColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
draw.DrawText("Steam Name: "..ply:GetName(),"PigFontSmall",x,y + th,Schema.GameColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)

local desc = ply:GetDesc():sub(1,35)
draw.DrawText("Desc: "..desc,"PigFontSmall",x,y + (th *2),Schema.GameColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)

local fac = faction[ply:Team()]
if fac and fac.Name then
fac = fac.Name
else
fac = "None"
end
draw.DrawText("Faction: "..fac,"PigFontSmall",x,y + (th *3),Schema.GameColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)

draw.DrawText("Faction Num: "..ply:Team(),"PigFontSmall",x,y + (th *4),Schema.GameColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)

  if ply:IsBot() or !ply:GetGender() then
    draw.DrawText("Gender: (Unspecified)","PigFontSmall",x,y + (th *5),Schema.GameColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
  else
    draw.DrawText("Gender: "..ply:GetGender(),"PigFontSmall",x,y + (th *5),Schema.GameColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
  end
 
 if ply:GetCharID() then
    draw.DrawText("Char ID: "..ply:GetCharID(),"PigFontSmall",x,y + (th *6),Schema.GameColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
  else
    draw.DrawText("Char ID: (NONE)","PigFontSmall",x,y + (th *6),Schema.GameColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)  
  end
  
  if ply:IsBot() or ply:InEditor() then return end
  draw.DrawText(Schema.Currency..": "..ply:GetMoney(), "PigFontSmall", x, y + (th *7),Schema.GameColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_LEFT)
end
----
end

function PANEL:RefreshAdminButs()
local hlist = self.hlist
if !IsValid(hlist) then return end
  for k,v in pairs(hlist:GetItems()) do
    v:Remove()
  end
  for k,v in ipairs(self.Buts) do
    local delete = pig.CreateButton(nil,v.Name,"PigFontSmall")
    delete:SetSize(hlist:GetWide()/2, hlist:GetTall()/4)
    delete:CenterHorizontal()
    delete.DoClick = function()
	  local stop = false
      if !v.Admin and !v.Mod and !LocalPlayer():IsSuperAdmin() then stop = true
      elseif v.Admin and !LocalPlayer():IsAdmin() then stop = true
	  elseif v.Mod and !LocalPlayer():IsModerator() then stop = true end
	  --
	  if stop then
	    pig.Notify(Schema.RedColor, "You do not have the required permissions to do this!", 4)
	    return
	  end
	  --
      v.Func(self)
    end
    hlist:AddItem(delete)
  end
end

function PANEL:DeleteChar(ply)
if ply == nil or !ply then
return
end
local name = ply:Name()
Derma_Query("Are you sure you want to delete the character '"..name.."' This CANNOT be undone.", "Delete character?",
			"Yes", function() 
			net.Start("PW_DeleteChar")
			net.WriteString(name)
			net.SendToServer()
			 end,
			"No", function() return end)
end

function PANEL:ChangeName(ply)
if ply == nil or !ply then
return
end
local name = ply:Name()
Derma_StringRequest("Change name", "Enter new name for player: '"..name.."'", name, function(text) 
net.Start("PW_ChangeName")
net.WriteString(name)
net.WriteString(text)
net.SendToServer()
end, nil, nil, nil, true)
end

function PANEL:ChangeDesc(ply)
if ply == nil or !ply then
return
end
local name = ply:Name()
local desc = ply:GetDesc()
Derma_StringRequest("Change description", "Enter new description for player: '"..name.."'", desc, function(text) 
net.Start("PW_ChangeDesc")
net.WriteString(name)
net.WriteString(text)
net.SendToServer()
end, nil, nil, nil, true)
end

function PANEL:Paint()
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,235) )
draw.Blur( self, 4, 5, 255 )
  if self.NonStaff then
    draw.DrawText("INSUFFICIENT PERMISSIONS!","PigFontBig",self:GetWide() / 2,self:GetTall() *.45,Schema.GameColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
  end
end

function PANEL:ShowClose(bool)
if bool then
if !IsValid(self.CloseButton) then 
self.CloseButton = pig.CreateButton(self,"Close","PigFontTiny")
self.CloseButton:SetSize(self.Sizes *.065,self.Sizes*.045)
self.CloseButton:SetPos(self:GetWide() *.91,self:GetTall() *.02)
self.CloseButton.Think = function(self)
if self.StopThink then return end
self:SetPos(self:GetParent():GetWide() *.91,self:GetParent():GetTall() *.02)
end
self.CloseButton.DoClick = function(self)
self:GetParent():Remove()
end
end
else
if IsValid(self.CloseButton) then
self.CloseButton:Remove()
end
end
end

vgui.Register("pig_AdminMenu", PANEL, "DFrame")