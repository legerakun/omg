include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

net.Receive("Shop_PMenu", function()
  if IsValid(pig.vgui.PickupMenu) then
    pig.vgui.PickupMenu:Remove()
  end
pig.vgui.PickupMenu = vgui.Create("Fallout_LootMenu")
local menu = pig.vgui.PickupMenu
menu:SetTitles("DELIVERED","ORDERS")
menu:Center()
menu.Caps = 0
menu.Buy = {}

local my_inv = menu.Table1
local l_inv = menu.Table2
--
local orders = LocalPlayer().ShopInventory or {}
local items = {}
  for k,v in pairs(orders) do
    if !v.Delivered then continue end
	items[k] = v
  end
--
local arrow = vgui.Create("DPanel", menu)
local aw = menu:GetWide()*.08
local ah = aw*1.5
arrow:SetSize(aw, ah)
arrow:SetPos(0, menu:GetTall()*.3 - (aw/2))
arrow:CenterHorizontal()
  arrow.Paint = function(me)
	local caps = menu.Caps
	if caps == 0 then return end
	surface.SetDrawColor(Schema.GameColor)
	surface.SetMaterial(Material("pw_fallout/arrow_r.png"))
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
	draw.SimpleText(caps, "FO3FontHUD", me:GetWide()/2, me:GetTall()*.315, Schema.GameColor, TEXT_ALIGN_CENTER)
 	draw.SimpleText("Caps", "FO3FontSmall", me:GetWide()/2, me:GetTall()*.5, Schema.GameColor, TEXT_ALIGN_CENTER)
  end
------
  for k,v in pairs(items) do
    local tab = Shop.CreateOrderBut(k, items[k], l_inv, my_inv, menu, true)
	tab.DoClick = function(me)
	  if v.Qty >= 10 then
	    Fallout_AmountBox("How many?", 1, v.Qty, function(val)
		  Shop.PickupItem(k, val)
	      v.Qty = v.Qty-val
	      if v.Qty <= 0 then
	        me:Remove()
	      end
		end)
	  else
	    Shop.PickupItem(k)
	    v.Qty = v.Qty-1
	    if v.Qty <= 0 then
	      me:Remove()
	    end
	  end
	end
	my_inv:AddItem(tab)
  end
--
  for k,v in pairs(orders) do
    if v.Delivered then continue end
    local tab = Shop.CreateOrderBut(k, orders[k], l_inv, my_inv, menu, true, true)
	tab.Item = k
	tab.DoClick = function() 
	  Shop.StartDelivery(k)
	end
	l_inv:AddItem(tab)
  end
--
local close = menu.CloseButton
end)
