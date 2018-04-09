local PANEL = {}

function PANEL:Init()
self:ShowCloseButton(false)
local w,h = self:GetSize()
self:SetSize(ScrW(),ScrH())
self:SetDraggable(false)
self:SetTitle("")
self.CloseButton = pig.CreateButton(self,"Close","PigFontTiny")
self.CloseButton:SetSize(self:GetWide() *.065,self:GetTall()*.045)
self.CloseButton:SetPos(self:GetWide() *.91,self:GetTall() *.02)
  self.CloseButton.DoClick = function(me)
    me:GetParent():Remove()
  end

self.InventoryList = vgui.Create("pig_PanelList",self)
local list = self.InventoryList
list.DrawColor = Color(255,255,255)
list:DefaultPaint()
list.DisableOverride = true
list.HalfPaint = true
list:SetSize(self:GetWide() *.175,self:GetTall() *.75)
list:SetPos(self:GetWide()*.135,0)
list:CenterVertical()
list:SetSpacing(4)
list:EnableVerticalScrollbar(true)
local inv_copy = table.Copy(LocalPlayer().Inventory)
  for k,v in pairs(inv_copy) do
    local base = vgui.Create("DButton")
    base:SetText("")
    base:SetSize(list:GetWide()-1,list:GetTall()/11)
	base.icon = self:GetIcon(k,v.Class)
	base.OldCursorEnter = base.OnCursorEntered
	base.OldCursorExit = base.OnCursorExited
	base:Droppable("Slot")
	--
	base.DoClick = function(me)
	  UseItem(k)
	  if v.Class == "pig_ent_wep" then return end
	  v.Amount = v.Amount - 1
	  v.Weight = v.Weight - v.SingleWG
	  if v.Amount <= 0 then me:Remove() end
	end
	base.DoRightClick = function(me)
	  DropItem(k)
	  v.Amount = v.Amount - 1
	  v.Weight = v.Weight - v.SingleWG
	  if v.Amount <= 0 then me:Remove() end
	end
	--
	base.OnCursorEntered = function(me)
	  me.ins = true
	  me.OldCursorEnter(me)
	end
	base.OnCursorExited = function(me)
	  me.ins = false
	  me.OldCursorExit(me)
	end
    base.Paint = function(me)
	  local textcol = Color(255,255,255)
	  local drawcol = Color(255,255,255,10)
	  local drawcol2 = Color(255,255,255,10)	  
	  if me.ins then
	    textcol = Color(0,0,0)
		drawcol = Color(255,255,255,90)
		drawcol2 = Color(255,255,255,90)
	  end
      draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),drawcol)
	  local iw = me:GetTall()
	  --
	  draw.SimpleText(k, "PigFontSmall", iw+2, me:GetTall()*.35, textcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	  draw.SimpleText("("..v.Amount..")", "PigFontSmall", me:GetWide()*.98, me:GetTall()/2, textcol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)	  
	  draw.SimpleText(v.Weight.." WG", "PigFontSmall", iw+2, me:GetTall()*.75, textcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)	   
	  --
	  draw.RoundedBox(0,0,0,iw,me:GetTall(),drawcol2)
	  surface.SetDrawColor(255,255,255)
	  surface.SetMaterial(me.icon)
	  surface.DrawTexturedRect(0,0,iw,iw)
	  --
    end
	--
    base.inv_table = v
    base.index = k
    list:AddItem(base)
  end
----
local model = vgui.Create("DModelPanel",self)
self.Model = model
model:SetSize(self:GetWide()*.2, self:GetTall()*.75)
model:Center()
model:SetModel(self:GetPlayerModel())
model.OldPaint = model.Paint
model:SetCamPos(Vector(102,102,50))
  function model:LayoutEntity( Entity )
    if ( self.bAnimated ) then
      self:RunAnimation()
    end
    Entity:SetAngles(Angle(0,45,0))
  return end
  model.Paint = function(me)
    me.OldPaint(me)
  end
----
local slotlist = vgui.Create("pig_PanelList",self)
slotlist.DrawColor = Color(255,255,255)
slotlist:DefaultPaint()
slotlist.DisableOverride = true
slotlist.HalfPaint = true
slotlist:SetSize(self:GetWide() *.225,self:GetTall() *.75)
slotlist:SetPos(self:GetWide() - (slotlist:GetWide() + self:GetWide()*.135),0)
slotlist:CenterVertical()
slotlist:SetSpacing(4)
slotlist:EnableVerticalScrollbar(true)
  for i=0,9 do
    local base = vgui.Create("DPanel")
	base.Slot = i
	base:SetSize(slotlist:GetWide(),slotlist:GetTall()/4)
    base:Receiver("Slot",function(me,panels,isDropped)
	  if !isDropped then return end
	  local panel = panels[1]
	  local index = panel.index
	  pig.AddToHotbar(me.Slot, index)
	end)
	base.OnCursorEntered = function(me)
	  me.ins = true
	end
	base.OnCursorExited = function(me)
	  me.ins = false
	end
	--
	local text = vgui.Create("DLabel",base)
	text:SetFont("PigFontBig")
	text:SetText("SLOT")
	text:SizeToContents()
	text:SetPos(base:GetWide()*.02, base:GetTall()*.025)
	local tx,ty = text:GetPos()
	--
	base.Paint = function(me)
	  local col = Color(0,0,0,100)
	  if me.ins then
	    col = Color(155,155,155)
	  end
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),col)
	  --
	  surface.SetDrawColor(255,255,255)
	  surface.SetMaterial(Material("pigworks/key"..i..".png"))
	  local iw = me:GetWide()*.08
	  surface.DrawTexturedRect(tx+text:GetWide()+(tx), ty, iw, iw)
	  --
	  local item = pig.Hotbar[i]
	  if !item then return end
	  draw.SimpleText(item, "PigFontBig", me:GetWide()*.96, ty, Color(255,255,255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_LEFT)
	  --
	  local pic = pig.GetInvIcon(item)
	  if !pic then return end
	  --
	  local pw = me:GetTall() *.6
	  local ox = me:GetWide()*.75
	  local oy = me:GetTall()*.575
	  draw.RoundedBox(8,ox - (pw/2), oy - (pw/2), pw, pw,Color(0,0,0,40))
	  surface.SetDrawColor(255,255,255)
	  surface.SetMaterial(pic)
	  surface.DrawTexturedRect(ox - (pw/2), oy - (pw/2), pw, pw)	  
	end
	slotlist:AddItem(base)
  end
--
hook.Call("pig_Inv_Open",GAMEMODE,self)
end

function PANEL:GetPlayerModel()
local model = LocalPlayer():GetModel()
return model
end

function PANEL:GetIcon(name,class)
local icon = pig.GetInvIcon(name,class)
return icon
end

function PANEL:Paint()
draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,200))
draw.Blur( self, 20, 50, 255 )
end

vgui.Register("pig_InvMenu", PANEL, "DFrame")