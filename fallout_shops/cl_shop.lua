Shop = Shop or {}
Shop.Categories = Shop.Categories or {}
Shop.Items = Shop.Items or {}

-----------
--FUNCS
-----------
local function CreateCat(parent,title,w,h,button)
local rankmake = vgui.Create("Fallout_Frame", parent)
rankmake.OnKeyCodeReleased = nil
rankmake:SetSize(w,h)
  if title then
    rankmake:SetTitle1(title)
  end
  rankmake.Paint = function(self)
    local title = self.Title
	--FalloutBlur(nil,12,0,0,self:GetWide(),self:GetTall())
    local dw = self.DownWidth or self:GetTall()*.15
    local off_x = self:GetWide()*.03
    local off_y = self:GetTall()*.04
      if IsValid(title) then 
        Fallout_QuarterBoxTitle(off_x,off_y,self:GetWide()-(off_x*2),self:GetWide()*.015,dw,title)
      else
        Fallout_QuarterBox(off_x,off_y,self:GetWide()-(off_x*2),dw,"down")
      end
    Fallout_QuarterBox(off_x,self:GetTall()-(off_y*1.35),self:GetWide()-(off_x*2),dw,"up")
  end
--
local list = vgui.Create("pig_PanelList",rankmake)
  if button then
    list:SetSize(rankmake:GetWide()*.9,rankmake:GetTall()*.745)
  else
    list:SetSize(rankmake:GetWide()*.9,rankmake:GetTall()*.855)  
  end
list:SetPos(0,rankmake:GetTall()*.08)
list:CenterHorizontal()
  list.Paint = function(self)
    draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,100))
  end
rankmake.List = list
--
return rankmake
end

function Shop.CreateOrderBut(itemname, tb, l_inv, my_inv, menu, my_stock, dtime)
  local tab = pig.CreateButton(nil,"","FO3FontHUD")
  tab:SetSize(my_inv:GetWide(),my_inv:GetTall()/7)
    tab.DoClick = function(me)
	  if menu.Buy[itemname] > 10 then
	    Fallout_AmountBox("How many?", 1, menu.Buy[itemname], function(val)
		  surface.PlaySound("ui/loot_take"..math.random(1,4)..".wav")
	      if tb.Stock == menu.Buy[itemname] then
	        local but = Shop.CreateShopBut(itemname, tb, l_inv, my_inv, menu)
		    l_inv:AddItem(but)
	      end
		  menu.Buy[itemname] = menu.Buy[itemname]-val
	      menu.Caps = menu.Caps - (tb.Price*val)
	      local amt = menu.Buy[itemname]
	      if amt < 1 then
	        menu.Buy[itemname] = nil
	        me:Remove()
	      end
		end)
	  else
	    surface.PlaySound("ui/loot_take"..math.random(1,4)..".wav")
	    if tb.Stock == menu.Buy[itemname] then
	      local but = Shop.CreateShopBut(itemname, tb, l_inv, my_inv, menu)
		  l_inv:AddItem(but)
	    end
	  	menu.Buy[itemname] = menu.Buy[itemname]-1
	    menu.Caps = menu.Caps - tb.Price
	    local amt = menu.Buy[itemname]
	    if amt < 1 then
	      menu.Buy[itemname] = nil
	      me:Remove()
	    end
	  end
	end
	tab.OnCursorEntered = function(me)
	  me.ins = true
	  menu.wg = Schema.InvMassTbl[itemname] or 0
	  menu.val = tb.Price
	  menu.cnd = 100
	  menu.first = "TIME"
	  menu.firstval = (tb.OrderTime or 0).."m"
	  local name = Schema.InvNameTbl[itemname]
	  menu.pic = Schema.Icons[name] or Schema.Icons[itemname] or "pw_fallout/icons/misc/junk.png"
	  menu.effname = "DELIVERY IN"
	  menu.eff = function()
	    local tleft = nil
		if dtime then
		  tleft = Shop.DeliveryTime(LocalPlayer(), itemname)
		end
	    return tleft or (tb.OrderTime..":00")
	  end
	end
	tab.Paint = function(me)
	  local col = me.Color or Schema.GameColor
	  local name = Schema.InvNameTbl[itemname] or itemname
	  local stock = menu.Buy[itemname] or 0
	  local price = tb.Price
	  if my_stock or tb.Qty then
	    stock = tb.Qty
	  end
	  
	  if stock > 1 then
	    draw.SimpleText(name.." ("..stock..")","FO3FontUI",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  elseif stock < 0 then
	    draw.SimpleText(name.." (∞)","FO3FontUI",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  else
	    draw.SimpleText(name.."","FO3FontUI",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  end
	  if price then
	    draw.SimpleText(price,"FO3FontUI",me:GetWide()*.95,me:GetTall()/2,col,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	  end
	  if !me.ins then return end
	  surface.SetDrawColor(col)
	  surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
	end
  return tab
end

function Shop.CreateShopBut(k, v, l_inv, my_inv, menu)
  local tab = pig.CreateButton(nil,"","FO3FontHUD")
  tab:SetSize(my_inv:GetWide(),my_inv:GetTall()/7)
    tab.Think = function(me)
	  if !me:GetDisabled() and v.Stock <= 0 then
        tab:SetDisabled(true)
	  elseif me:GetDisabled() and v.Stock > 0 then
	    tab:SetDisabled(false)
      end
	end
    tab.DoClick = function(me)
	  local max = (v.Stock - (menu.Buy[k] or 0))
	  if max > 10 then
	    Fallout_AmountBox("How many?", 1, max, function(val)
		  surface.PlaySound("ui/loot_take"..math.random(1,4)..".wav")
	      if !menu.Buy[k] then
	        menu.Buy[k] = 0
	        local but = Shop.CreateOrderBut(k, v, l_inv, my_inv, menu)
	        my_inv:AddItem(but)
	      end
	      menu.Buy[k] = menu.Buy[k]+val
	      menu.Caps = menu.Caps + (v.Price*val)
	      local amt = v.Stock - menu.Buy[k]
	      if amt < 1 then
	        me:Remove()
	      end
		end)
	  else
	    surface.PlaySound("ui/loot_take"..math.random(1,4)..".wav")
	    if !menu.Buy[k] then
	      menu.Buy[k] = 0
	      local but = Shop.CreateOrderBut(k, v, l_inv, my_inv, menu)
	      my_inv:AddItem(but)
	    end
	    menu.Buy[k] = menu.Buy[k]+1
	    menu.Caps = menu.Caps + v.Price
	    local amt = v.Stock - menu.Buy[k]
	    if amt < 1 then
	      me:Remove()
	    end
	  end
	end
	tab.OnCursorEntered = function(me)
	  me.ins = true
	  menu.wg = Schema.InvMassTbl[k] or 0
	  menu.val = v.Price
	  menu.cnd = 100
	  menu.first = "TIME"
	  menu.firstval = (v.OrderTime or 0).."m"
	  menu.effname = "RESTOCK"
	  menu.eff = function()
	    return Shop.TimeLeft(v.ReStock)
	  end
	  local name = Schema.InvNameTbl[k]
	  menu.pic = Schema.Icons[name] or Schema.Icons[k] or "pw_fallout/icons/misc/junk.png"
	end
	tab.Paint = function(me)
	  local col = me.Color or Schema.GameColor
	  if me:GetDisabled() then
	    col = Schema.RedColor
	  end
	  local name = Schema.InvNameTbl[k] or k
	  local stock = v.Stock
	  if menu.Buy[k] then
	  stock = stock - menu.Buy[k]
	  end
	  if stock > 1 then
	    draw.SimpleText(name.." ("..stock..")","FO3FontUI",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  elseif stock < 0 then
	    draw.SimpleText(name.." (∞)","FO3FontUI",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  elseif stock == 0 then
	    draw.SimpleText(name.." (Out of Stock)","FO3FontUI",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  else
	    draw.SimpleText(name,"FO3FontUI",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  end
	  draw.SimpleText(v.Price,"FO3FontUI",me:GetWide()*.95,me:GetTall()/2,col,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	  if !me.ins then return end
	  surface.SetDrawColor(col)
	  surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
	end

  return tab
end
-- -- --
function Shop.ShowMenu()
  if IsValid(pig.vgui.ShopList) then
    pig.vgui.ShopList:Remove()
  end
pig.vgui.ShopList = vgui.Create("Fallout_Frame")
local frame = pig.vgui.ShopList
frame:SetSize(ScrW()*.25, ScrH()*.6)
frame:Center()
frame:ShowClose(true)
frame:SetTitle1("SELECT SHOP")
frame:MakePopup()
frame.DownWidth = frame:GetTall()*.05

local list = vgui.Create("pig_PanelList", frame)
list:SetSize(frame:GetWide()*.97, frame:GetTall()*.74)
list:SetPos(0, frame:GetTall()*.08)
list:CenterHorizontal()
  for k,v in pairs(Shop.Categories) do
    local but = pig.CreateButton(nil, "", "FO3Font")
	but:SetSize(list:GetWide(), list:GetTall()/6)
	but.OldPaint = but.Paint
	but.Paint = function(me)
	  me.OldPaint(me)
	  draw.SimpleText(k, "FO3Font", me:GetWide()*.03, me:GetTall()*.075, Schema.GameColor)
	  draw.SimpleText("(Requires flag ...)", "FO3FontSmall", me:GetWide()*.03, me:GetTall()*.51, Schema.GameColor)	  
	end
	but.DoClick = function()
	  surface.PlaySound("ui/ok.mp3")
	  frame:Remove()
	  Shop.ShopMenu(k)
	end
	list:AddItem(but)
  end

return frame
end

function Shop.PurchaseItem(tbl)
local ply = LocalPlayer()
  for k,v in pairs(tbl) do
    local item = Shop.Items[k]
	local item_qty = item.Stock
	local price = item.Price
	local qty = v
	--
	if ply.ShopInventory and ply.ShopInventory[k] then
	  local name = Schema.InvNameTbl[k] or k
	  pig.Notify(Schema.RedColor, "You already have an order of "..name.."! You must collect it before ordering another shipment", 8)
	  return
	end
	--
	if qty > item_qty then
	  pig.Notify(Schema.RedColor, "You are trying to purchase more than is allowed!", 4)
	  return
	end
	if (price*qty) > ply:GetMoney() then
	  pig.Notify(Schema.RedColor, "You cannot afford this order!", 4)
	  return
	end	
  end
--
net.Start("Shop_Buy")
net.WriteTable(tbl)
net.SendToServer()
end

function Shop.StartDelivery(itemname)
local tname = Shop.TimerName(LocalPlayer(), itemname)
local tb = LocalPlayer().ShopInventory[itemname]
  if !tb or timer.Exists(tname) or tb.Delivered then
    return
  end
--
local name = Schema.InvNameTbl[itemname] or itemname
pig.Notify(Schema.GameColor, "You have requested the Order for "..tb.Qty.."x "..name..". It is now being delivered.")
--
net.Start("Shop_RDel")
net.WriteString(itemname)
net.SendToServer()
end

function Shop.PickupItem(itemname, qty)
local tb = LocalPlayer().ShopInventory[itemname]
  if !tb or !tb.Delivered then
    return
  end
--
net.Start("Shop_Pick")
net.WriteString(itemname)
net.WriteFloat(qty or 1)
net.SendToServer()
end

function Shop.ShopMenu(cat)
--
FalloutTutorial("Shop")
--
  if IsValid(pig.vgui.ShopMenu) then
    pig.vgui.ShopMenu:Remove()
  end
pig.vgui.ShopMenu = vgui.Create("Fallout_LootMenu")
local menu = pig.vgui.ShopMenu
menu:SetTitles("ORDERS","SUPPLIER")
menu:Center()
menu.Caps = 0
menu.Buy = {}

local my_inv = menu.Table1
local l_inv = menu.Table2
--
local orders = LocalPlayer().ShopInventory or {}
local items = {}
  for k,v in pairs(Shop.Items) do
    if v.Category != cat then continue end
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
  for k,v in pairs(orders) do
    local tab = Shop.CreateOrderBut(k, orders[k], l_inv, my_inv, menu, true, true)
	tab.DoClick = function() 
	  Shop.StartDelivery(k)
	end
	my_inv:AddItem(tab)
  end
--
  for k,v in pairs(items) do
    local tab = Shop.CreateShopBut(k, v, l_inv, my_inv, menu)
	l_inv:AddItem(tab)
  end
--
local close = menu.CloseButton
  close.DoClick = function(me)
    local Window = Derma_Query("What would you like to do?", "",
	"Close Menu", function() menu:Remove() end,
	"Accept Order", function()
	  if table.Count(menu.Buy) < 1 then return end
	  Shop.PurchaseItem(menu.Buy)
	  menu:Remove()
	  Shop.ShowMenu()
	end,
	"Cancel", function() end)
  end
end

function Shop.RegisterCat(name, flags)
  if flags then
    for k,v in pairs(flags) do
	  if v == "" then flags[k] = nil continue end
	  v = v:gsub(" ","")
	  flags[k] = v
	end
  end

net.Start("Shop_RegCat")
net.WriteString(name)
net.WriteTable(flags or {})
net.SendToServer()
end

function Shop.RegisterItem(itemname, cat, type, r_days, r_mins, stock, price, ordertime)
  net.Start("Shop_Reg")
  net.WriteString(itemname)
  net.WriteString(cat)
  net.WriteString(type)
  net.WriteFloat(r_days)
  net.WriteFloat(r_mins)
  net.WriteFloat(stock)
  net.WriteFloat(price)
  net.WriteFloat(ordertime)  
  net.SendToServer()
end

function Shop.DeleteCat(catname)
net.Start("Shop_DelCat")
net.WriteString(catname)
net.SendToServer()
end

function Shop.DeleteItem(catname, item)
net.Start("Shop_DelIt")
net.WriteString(catname)
net.WriteString(item)
net.SendToServer()
end
-----------------------
--ADMIN SHIT
-----------------------
local function AdminPreviewItems(list, cat, catlist)
  for k,v in pairs(list:GetItems()) do
    v:Remove()
  end
  --
  surface.SetFont("FO3FontSmall")
  local tw,th = surface.GetTextSize("|")
  for k,v in pairs(Shop.Items) do
    if v.Category != cat then continue end
	local but = pig.CreateButton(nil, "", "FO3Font")
	but:SetSize(list:GetWide(), list:GetTall()/5)
	but.OldPaint = but.Paint
	but.DoClick = function(me)
	  local tbl = catlist.Elements
	  if !tbl["Item Class"] then return end
	  tbl["Item Class"]:SetText(k)
	  tbl["Category"]:SetText(v.Category)
	  --
	  local type = "Entity"
	  if v.isWep then
	    type = "Weapon"
	  elseif v.isOutfit then
	    type = "Outfit"
	  end
	  tbl["Type (Weapon, Outfit or Entity)"]:SetText(type)
	  --
	  local diff = v.ReStock - os.time()
	  local days = math.Round(diff/86400)
	  local mins = math.Round(diff - ((86400)*days))
	  tbl["Restock Days"]:SetText(days)
	  tbl["Restock Minutes"]:SetText(days)
	  --
	  tbl["Stock"]:SetText(v.Stock)
	  tbl["Price"]:SetText(v.Price)
	  tbl["Order Time"]:SetText(v.OrderTime)
	  --
	  for k,v in pairs(tbl) do
	    v:OnTextChanged()
	  end
	end
	but.Paint = function(me)
	  me.OldPaint(me)
	  local space = me:GetTall()*.01 + th
	  draw.SimpleText(k, "FO3FontSmall", me:GetWide()*.03, me:GetTall()*.075, Schema.GameColor)
	  --
	  local timeleft = Shop.TimeLeft(v.ReStock)
	  draw.SimpleText("Re-Stock: "..timeleft, "FO3FontSmall", me:GetWide()*.03, me:GetTall()*.075 + (space*1), Schema.GameColor)	  
	  draw.SimpleText("Current Stock: "..v.Stock, "FO3FontSmall", me:GetWide()*.03, me:GetTall()*.075 + (space*2), Schema.GameColor)	  
	  draw.SimpleText("Price: "..v.Price.." Caps", "FO3FontSmall", me:GetWide()*.03, me:GetTall()*.075 + (space*3), Schema.GameColor)	  
	end
	list:AddItem(but)
  end
end

local function AdminDelIt(frame, categories, preview, options)
categories.Category = {}
categories:SetTitle1("DELETE ITEM")
local tbl = {}
tbl[1] = {
  Txt = "Category Name",
  Func = function(text)
    categories.Category.Name = text
  end
}
tbl[2] = {
  Txt = "Item Name",
  Func = function(text)
    categories.Category.Item = text
  end
}
--
local close = categories.CloseButton
  close.DoClick = function(me)
    local catname = categories.Category.Name
	local item = categories.Category.Item
	if catname == nil or item == nil then return end
    Shop.DeleteItem(catname, item)
  end
--
  preview.List.Update = function(me)
    for k,v in pairs(me:GetItems()) do v:Remove() end
	--
    for k,v in pairs(Shop.Categories) do
      local but = pig.CreateButton(nil, "", "FO3Font")
	  but.OldPaint = but.Paint
	  local str = ""
	  local max = table.Count(v)
	  for i=1,max do
	    if i == max then
		  str = str..""..v[i]..""
		else
	      str = str..""..v[i]..", "
		end
	  end
	  but.str = "Req Flags ("..str..")"
	  but.Paint = function(me)
	    me.OldPaint(me)
	    draw.SimpleText(k, "FO3Font", me:GetWide()*.03, me:GetTall()*.075, Schema.GameColor)
	    draw.SimpleText(me.str, "FO3FontSmall", me:GetWide()*.03, me:GetTall()*.51, Schema.GameColor)	  
	  end
	  but:SetSize(me:GetWide(), me:GetTall()/5)
	  me:AddItem(but)
	end
  end
preview.List.Update(preview.List)
--
  for k,v in SortedPairs(tbl) do
    local base = vgui.Create("DPanel")
	local parent = categories.List
	base:SetSize(parent:GetWide(), parent:GetTall() / 3)
	base.Paint = function(me)
	  Fallout_HalfBox(3,3,me:GetWide(),me:GetTall(),me:GetTall()*.25)
	end
	local text,blur = Fallout_DLabel(base,0,0, v.Txt, "FO3FontHUD",Schema.GameColor)
	text:SetPos(base:GetWide()/2 - (text:GetWide()/2),base:GetTall()*.2)
	local tx,ty = text:GetPos()
	blur:SetPos(tx,ty)
	--
	local textentry = Fallout_DTextEntry()
	textentry.OnTextChanged = function(me)
	  v.Func(me:GetText())
	end
	textentry:SetParent(base)
	textentry:SetSize(base:GetWide()*.75,base:GetTall()*.26)
	textentry:SetPos(0,(base:GetTall()*.8) - textentry:GetTall())
	textentry:CenterHorizontal()
	parent:AddItem(base)
  end
end

local function AdminDelCat(frame, categories, preview, options)
categories.Category = {}
categories:SetTitle1("DELETE CATEGORY")
local tbl = {}
tbl[1] = {
  Txt = "Category Name",
  Func = function(text)
    categories.Category.Name = text
  end
}
--
local close = categories.CloseButton
  close.DoClick = function(me)
    local catname = categories.Category.Name
	if catname == nil then return end
    Shop.DeleteCat(catname)
  end
--
  preview.List.Update = function(me)
    for k,v in pairs(me:GetItems()) do v:Remove() end
	--
    for k,v in pairs(Shop.Categories) do
      local but = pig.CreateButton(nil, "", "FO3Font")
	  but.OldPaint = but.Paint
	  local str = ""
	  local max = table.Count(v)
	  for i=1,max do
	    if i == max then
		  str = str..""..v[i]..""
		else
	      str = str..""..v[i]..", "
		end
	  end
	  but.str = "Req Flags ("..str..")"
	  but.Paint = function(me)
	    me.OldPaint(me)
	    draw.SimpleText(k, "FO3Font", me:GetWide()*.03, me:GetTall()*.075, Schema.GameColor)
	    draw.SimpleText(me.str, "FO3FontSmall", me:GetWide()*.03, me:GetTall()*.51, Schema.GameColor)	  
	  end
	  but:SetSize(me:GetWide(), me:GetTall()/5)
	  me:AddItem(but)
	end
  end
preview.List.Update(preview.List)
--
  for k,v in SortedPairs(tbl) do
    local base = vgui.Create("DPanel")
	local parent = categories.List
	base:SetSize(parent:GetWide(), parent:GetTall() / 3)
	base.Paint = function(me)
	  Fallout_HalfBox(3,3,me:GetWide(),me:GetTall(),me:GetTall()*.25)
	end
	local text,blur = Fallout_DLabel(base,0,0, v.Txt, "FO3FontHUD",Schema.GameColor)
	text:SetPos(base:GetWide()/2 - (text:GetWide()/2),base:GetTall()*.2)
	local tx,ty = text:GetPos()
	blur:SetPos(tx,ty)
	--
	local textentry = Fallout_DTextEntry()
	textentry.OnTextChanged = function(me)
	  v.Func(me:GetText())
	end
	textentry:SetParent(base)
	textentry:SetSize(base:GetWide()*.75,base:GetTall()*.26)
	textentry:SetPos(0,(base:GetTall()*.8) - textentry:GetTall())
	textentry:CenterHorizontal()
	parent:AddItem(base)
  end
end

local function AdminItem(frame, categories, preview, options)
categories.Item = {}
categories:SetTitle1("ADD ITEM")
local tbl = {}
tbl[1] = {
  Txt = "Item Class",
  Func = function(text)
    categories.Item.Class = text
  end
}
tbl[2] = {
  Txt = "Category",
  Func = function(text)
    categories.Item.Category = text
  end
}
tbl[3] = {
  Txt = "Type (Weapon, Outfit or Entity)",
  Func = function(text)
    categories.Item.Type = text
  end
}
tbl[4] = {
  Txt = "Restock Days",
  Func = function(text)
    local num = tonumber(text)
	if num == nil then
	  categories.Item.Days = 0
	return end
    categories.Item.Days = num
  end
}
tbl[5] = {
  Txt = "Restock Minutes",
  Func = function(text)
    local num = tonumber(text)
	if num == nil then
	  categories.Item.Min = 0
	return end
    categories.Item.Min = num
  end
}
tbl[6] = {
  Txt = "Stock",
  Func = function(text)
    local num = tonumber(text)
	if num == nil then
	  categories.Item.Stock = -1
	return end
    categories.Item.Stock = num
  end
}
tbl[7] = {
  Txt = "Price",
  Func = function(text)
    local num = tonumber(text)
	if num == nil then
	  categories.Item.Price = 0
	return end
    categories.Item.Price = num
  end
}
tbl[8] = {
  Txt = "Order Time",
  Func = function(text)
    local num = tonumber(text)
	if num == nil then
	  categories.Item.OrderTime = 0
	return end
    categories.Item.OrderTime = num
  end
}
--
local close = categories.CloseButton
  close.DoClick = function(me)
    local itemname = categories.Item.Class
	local cat = categories.Item.Category
	local type = categories.Item.Type or ""
	local r_days = categories.Item.Days or 0
	local r_mins = categories.Item.Min or 0
	local stock = categories.Item.Stock or -1
	local price = categories.Item.Price or 0
	local ordertime = categories.Item.OrderTime
	if itemname == nil or cat == nil then return end
    Shop.RegisterItem(itemname, cat, type, r_days, r_mins, stock, price, ordertime)
  end
--
  preview.List.Update = function(me)
    for k,v in pairs(me:GetItems()) do v:Remove() end
	--
    for k,v in pairs(Shop.Categories) do
      local but = pig.CreateButton(nil, "", "FO3Font")
	  but.OldPaint = but.Paint
	  local str = ""
	  local max = table.Count(v)
	  for i=1,max do
	    if i == max then
		  str = str..""..v[i]..""
		else
	      str = str..""..v[i]..", "
		end
	  end
	  but.str = "Req Flags ("..str..")"
	  but.Paint = function(me)
	    me.OldPaint(me)
	    draw.SimpleText(k, "FO3Font", me:GetWide()*.03, me:GetTall()*.075, Schema.GameColor)
	    draw.SimpleText(me.str, "FO3FontSmall", me:GetWide()*.03, me:GetTall()*.51, Schema.GameColor)	  
	  end
	  but.DoClick = function()
	    surface.PlaySound("ui/ok.mp3")
	    AdminPreviewItems(me,k,categories.List)
	  end
	  but:SetSize(me:GetWide(), me:GetTall()/5)
	  me:AddItem(but)
	end
  end
preview.List.Update(preview.List)
--
local parent = categories.List
parent.Elements = {}
--
  for k,v in SortedPairs(tbl) do
    local base = vgui.Create("DPanel")
	base:SetSize(parent:GetWide(), parent:GetTall() / 3)
	base.Paint = function(me)
	  Fallout_HalfBox(3,3,me:GetWide(),me:GetTall(),me:GetTall()*.25)
	end
	local text,blur = Fallout_DLabel(base,0,0, v.Txt, "FO3FontHUD",Schema.GameColor)
	local min = base:GetWide()*.025
	text:SetPos(base:GetWide()/2 - (text:GetWide()/2) - min,base:GetTall()*.2)
	local tx,ty = text:GetPos()
	blur:SetPos(tx,ty)
	--
	local textentry = Fallout_DTextEntry()
	parent.Elements[v.Txt] = textentry
	textentry.OnTextChanged = function(me)
	  v.Func(me:GetText())
	end
	textentry:SetParent(base)
	textentry:SetSize(base:GetWide()*.75,base:GetTall()*.26)
	textentry:SetPos(0,(base:GetTall()*.8) - textentry:GetTall())
	textentry:CenterHorizontal()
	local txt_x, txt_y = textentry:GetPos()
	textentry:SetPos(txt_x - min, txt_y)
	parent:AddItem(base)
  end
end

local function AdminCategory(frame, categories, preview, options)
categories.Category = {}
categories:SetTitle1("ADD CATEGORY")
local tbl = {}
tbl[1] = {
  Txt = "Category Name",
  Func = function(text)
    categories.Category.Name = text
  end
}
tbl[2] = {
  Txt = "Flags (flag1, flag2, etc.)",
  Func = function(text)
    if text == "" then
	  categories.Category.Flags = nil
	return end
	local flags = string.Explode(", ", text)
	local len = table.Count(flags)
    categories.Category.Flags = {}
	  for i=1,len do
	    local flag = flags[i]
		if !flag or flag == "" then continue end
	    categories.Category.Flags[i] = flag
	  end
  end
}
--
local close = categories.CloseButton
  close.DoClick = function(me)
    local catname = categories.Category.Name
	local flagtbl = categories.Category.Flags
	if catname == nil then return end
    Shop.RegisterCat(catname, flagtbl)
  end
--
  preview.List.Update = function(me)
    for k,v in pairs(me:GetItems()) do v:Remove() end
	--
    for k,v in pairs(Shop.Categories) do
      local but = pig.CreateButton(nil, "", "FO3Font")
	  but.OldPaint = but.Paint
	  local str = ""
	  local max = table.Count(v)
	  for i=1,max do
	    if i == max then
		  str = str..""..v[i]..""
		else
	      str = str..""..v[i]..", "
		end
	  end
	  but.str = "Req Flags ("..str..")"
	  but.Paint = function(me)
	    me.OldPaint(me)
	    draw.SimpleText(k, "FO3Font", me:GetWide()*.03, me:GetTall()*.075, Schema.GameColor)
	    draw.SimpleText(me.str, "FO3FontSmall", me:GetWide()*.03, me:GetTall()*.51, Schema.GameColor)	  
	  end
	  but:SetSize(me:GetWide(), me:GetTall()/5)
	  me:AddItem(but)
	end
  end
preview.List.Update(preview.List)
--
  for k,v in SortedPairs(tbl) do
    local base = vgui.Create("DPanel")
	local parent = categories.List
	base:SetSize(parent:GetWide(), parent:GetTall() / 3)
	base.Paint = function(me)
	  Fallout_HalfBox(3,3,me:GetWide(),me:GetTall(),me:GetTall()*.25)
	end
	local text,blur = Fallout_DLabel(base,0,0, v.Txt, "FO3FontHUD",Schema.GameColor)
	text:SetPos(base:GetWide()/2 - (text:GetWide()/2),base:GetTall()*.2)
	local tx,ty = text:GetPos()
	blur:SetPos(tx,ty)
	--
	local textentry = Fallout_DTextEntry()
	textentry.OnTextChanged = function(me)
	  v.Func(me:GetText())
	end
	textentry:SetParent(base)
	textentry:SetSize(base:GetWide()*.75,base:GetTall()*.26)
	textentry:SetPos(0,(base:GetTall()*.8) - textentry:GetTall())
	textentry:CenterHorizontal()
	parent:AddItem(base)
  end
end

function Shop.AdminMenu()
  if !LocalPlayer():IsSuperAdmin() then
    pig.Notify(Schema.RedColor, "You must be a Super-Admin to do this!", 4)
    return
  end
  if IsValid(pig.vgui.AdminMenu) then
    pig.vgui.AdminMenu:Remove()
  end
pig.vgui.AdminMenu = vgui.Create("Fallout_Frame")
local frame = pig.vgui.AdminMenu
frame.OnKeyCodeReleased = nil
frame:SetSize(ScrW()*.7, ScrH()*.8)
frame:Center()
frame:ShowClose(true)
frame:SetTitle1("SHOP CONFIG")
frame:MakePopup()
frame.DownWidth = frame:GetTall()*.1

local base = vgui.Create("DPanel", frame)
base:SetSize(frame:GetWide()*.91, frame:GetTall() *.75)
base:SetPos(0, frame:GetTall()*.065)
base:CenterHorizontal()
  base.Paint = function(me)
    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,120))
    local length = me:GetWide()*.04
	local len2 = me:GetWide()*.175
	--
    Fallout_Line(0, 0, "right", length)
	Fallout_Line(0, 0, "down", length)
	
    Fallout_Line(me:GetWide() - length - (3/2), 0, "left", length)
	Fallout_Line(me:GetWide() - 3, 0, "down", length)
	
	Fallout_Line(me:GetWide()/2 - (len2) + (3/2), 0, "left", len2)	
	Fallout_Line(me:GetWide()/2, 0, "right", len2)
	-------
	Fallout_Line(0, me:GetTall() - 3, "right", length)
	Fallout_Line(0, me:GetTall() - length, "up", length)	
	
    Fallout_Line(me:GetWide() - length, me:GetTall() - 3, "left", length)
	Fallout_Line(me:GetWide() - 3, me:GetTall() - length, "up", length)	
	
	Fallout_Line(me:GetWide()/2 - (len2) + (3/2), me:GetTall() - 3, "left", len2)	
	Fallout_Line(me:GetWide()/2, me:GetTall() - 3, "right", len2)	
	--
  end
------------
local off = base:GetWide()*.001
local off2 = base:GetWide()*.035
local switch = vgui.Create("pig_PanelList", base)
switch:SetSize(base:GetWide()*.14, base:GetTall()*.87)
switch:SetPos(base:GetWide() - switch:GetWide() - off2, base:GetTall()*.06)
--
local buts = {
  [1] = {Text = "Add Category", Func = AdminCategory},
  [2] = {Text = "Add/Edit Item", Func = AdminItem},
  [3] = {Text = "Delete Category", Func = AdminDelCat},
  [4] = {Text = "Delete Item", Func = AdminDelIt}
}
--
  for k,v in SortedPairs(buts) do
    local but = pig.CreateButton(nil, v.Text, "FO3FontSmall")
	but:SetSize(switch:GetWide(), switch:GetTall()*.1)
	but.DoClick = function()
	  for k,v in pairs(frame.Categories.List:GetItems()) do v:Remove() end
	  v.Func(frame, frame.Categories, frame.Preview, frame.Options)
	end
	switch:AddItem(but)
  end
--------------------
local categories = CreateCat(base, "ADD CATEGORY", base:GetWide()*.35, base:GetTall()*.95, true)
categories:SetPos(off,0)
categories:CenterVertical()
categories:ShowClose(true)
local close = categories.CloseButton
close:SetText("Done E)")
frame.Categories = categories

local preview = CreateCat(base, "PREVIEW", base:GetWide()*.325, base:GetTall()*.95)
preview:Center()
frame.Preview = preview

local options = vgui.Create("pig_PanelList", base)
frame.Options = options
options:SetSize(base:GetWide()*.14, base:GetTall()*.87)
local px,py = preview:GetPos()
options:SetPos(px + preview:GetWide() + (off/2), base:GetTall()*.06)
  options.Paint = function(self)
    draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(0,0,0,100))
	local dw = self.DownWidth or self:GetTall()*.15
    Fallout_QuarterBox(3,(3/2),self:GetWide()-5,dw,"down")
    Fallout_QuarterBox(3,self:GetTall()-3,self:GetWide()-5,dw,"up")
  end
--
  for k,v in pairs(pig.Flags) do
    local but = pig.CreateButton(nil, k, "FO3FontSmall")
	but:SetSize(options:GetWide(), options:GetTall()/7)
	but.DoClick = function(me)
	  
	end
	options:AddItem(but)
  end
--
AdminCategory(frame, categories, preview, options)
end
concommand.Add("ShopAdminMenu", Shop.AdminMenu)
---------
--NET
--------
net.Receive("Shop_DelCl", function()
local cat = net.ReadString()
local itemname = net.ReadString()
--
  for k,v in pairs(Shop.Items) do
    if k != itemname or v.Category != cat then continue end
	Shop.Items[k] = nil
	break
  end
end)

net.Receive("Shop_DClCat", function()
local cat = net.ReadString()
--
  for k,v in pairs(Shop.Items) do
    if v.Category == cat then
	  Shop.Items[k] = nil
	end
  end
  Shop.Categories[cat] = nil
--
end)

net.Receive("Shop_PDel", function()
local ply = LocalPlayer()
ply.ShopInventory = ply.ShopInventory or {}
--
local itemname = net.ReadString()

  if ply.ShopInventory[itemname] then
    ply.ShopInventory[itemname].Delivered = true
  end
end)

net.Receive("Shop_PSpawn", function()
local ply = LocalPlayer()
ply.ShopInventory = ply.ShopInventory or {}
--
local itemname = net.ReadString()
local new_qty = net.ReadFloat()

  if ply.ShopInventory[itemname] then
	if new_qty <= 0 then
	  ply.ShopInventory[itemname] = nil
	else
	  ply.ShopInventory[itemname].Qty = new_qty
	end
  end
--
end)

net.Receive("Shop_POTime", function()
local itemname = net.ReadString()
local time = net.ReadFloat()
local timername = Shop.TimerName(LocalPlayer(), itemname)

  timer.Create(timername, time, 1, function()
    if IsValid(pig.vgui.PickupMenu) then
	  local menu = pig.vgui.PickupMenu
	  local my_inv = menu.Table1
	  local l_inv = menu.Table2
	  local items = LocalPlayer().ShopInventory
	  
	  for k,v in pairs(items) do
	    if k != itemname then continue end
        local tab = Shop.CreateOrderBut(k, items[k], l_inv, my_inv, menu, v.Qty)
	    tab.DoClick = function() 
		  Shop.PickupItem(k)
		end
	    my_inv:AddItem(tab)
      end
	  
	  for k,v in pairs(l_inv:GetItems()) do
	    if v.Item == itemname then
		  v:Remove()
		end
	  end
	end
  end)
end)

net.Receive("Shop_Inv", function()
local ply = LocalPlayer()
ply.ShopInventory = ply.ShopInventory or {}
--
local itemname = net.ReadString()
local ordertime = net.ReadFloat()
local isWep = net.ReadBool()
local isOutfit = net.ReadBool()
local qty = net.ReadFloat()
--
ply.ShopInventory[itemname] = {
  OrderTime = ordertime,
  isWep = isWep,
  isOutfit = isOutfit,
  Qty = qty
}
end)

net.Receive("Shop_Send",function()
local itemname = net.ReadString()
local shoptbl = net.ReadTable()
  if Shop.Items[itemname] then
    table.Merge(Shop.Items[itemname], shoptbl)
  else
    Shop.Items[itemname] = shoptbl
  end
local adminmenu = pig.vgui.AdminMenu
  if IsValid(adminmenu) then
    local preview = adminmenu.Preview.List
	preview.Update(preview)
  end
end)

net.Receive("Shop_SendCat",function()
local cat = net.ReadString()
local flags = net.ReadTable()
--
Shop.Categories[cat] = flags
--
local adminmenu = pig.vgui.AdminMenu
  if IsValid(adminmenu) then
    local preview = adminmenu.Preview.List
	preview.Update(preview)
  end
end)

--
concommand.Add("test_CheckDate",function(ply,cmd,args)
local date = os.date("%H:%M - %d/%m/%Y", time)
local compare = "22:15 - 21/07/2017"

local tbl = string.Explode(" - ", date)
local tbl2 = string.Explode(" - ", compare)
-----------
--Date
local os_tbl_date = string.Explode("/", tbl[2])
local os_day = tonumber(os_tbl_date[1])
local os_month = tonumber(os_tbl_date[2])
local os_year = tonumber(os_tbl_date[3])

local c_tbl_date = string.Explode("/", tbl2[2])
local c_day = tonumber(c_tbl_date[1])
local c_month = tonumber(c_tbl_date[2])
local c_year = tonumber(c_tbl_date[3])

  if c_year > os_year or c_year == os_year and c_month > os_month or c_month == os_month and c_day > os_day then
    print("Wrong date")
    return false
  end
-----------
--Time
local os_tbl_time = string.Explode(":", tbl[1])
local os_hour = tonumber(os_tbl_time[1])
local os_minute = tonumber(os_tbl_time[2])

local c_tbl_time = string.Explode(":", tbl2[1])
local c_hour = tonumber(c_tbl_time[1])
local c_minute = tonumber(c_tbl_time[2])

  if c_hour > os_hour or c_hour == os_hour and c_minute > os_minute then
    print("Wrong time")
    return false
  end
--
print("Success")
end)

concommand.Add("test_ostime",function()
local mins = 60*(2)
local days = 86400*(365)
local time = os.time() + mins + days
local date = os.date("%H:%M - %d/%m/%Y", time)
print(date.."  Unix: "..time)
end)
