include("shared.lua")

function ENT:LootMenu()
local items = self.Contents or {}
surface.PlaySound("ui/open_loot.wav")
--
  if IsValid(pig.vgui.LootMenu) then
    pig.vgui.LootMenu:Remove()
  end
--
local order = {}
local menu = vgui.Create("Fallout_LootMenu")
pig.vgui.LootMenu = menu
menu:SetTitles("INVENTORY", "CONTENTS")
menu:SetDrawWG(true)

local my_inv = menu.Table1
local loot = menu.Table2
local inventory = table.Copy(LocalPlayer().Inventory)
items = table.Copy(items)
-----
  local take_click = function(me, k, amt)
    amt = amt or 1
    local v = inventory[k]
	TakeInvVars(k, amt)
	--
	if !items[k] then
	  items[k] = {
		Class = v.Class,
		WG = v.SingleWG,
		Amount = amt,
		SaveVars = v.Saved_Vars
	  }
	  local but = self:CreateButton(k, items, loot, menu)
	  local key = order[k] or 1
	  but.DoClick = function(me)
	    local max = 0
		if inventory[k] then
		  max = inventory[k].Amount
		end
		if max >= 10 then
	      Fallout_AmountBox("How many?", 1, max, function(val)
		    menu.Store(me, k, val)
		  end)
		else
		  menu.Store(me, k)
		end
	  end
	  local pan = nil
	  local count = table.Count(my_inv.Items)
	    for i=key-1,count do
		  pan = my_inv.Items[i]
		  if pan then break end
		end
	  if key == 1 then
	    loot:InsertAtTop(but)
	  elseif pan then
	    loot:InsertAfter(pan, but)
	  else
	    loot:AddItem(but)
	  end
	else
	  items[k].Amount = items[k].Amount + amt
	end
	--
	v.Amount = v.Amount - amt
	inventory[k].Amount = v.Amount
	surface.PlaySound("ui/ui_items_generic_down.mp3")
	if v.Amount < 1 then
	  me:Remove()
	  inventory[k] = nil
	end
	--
	net.Start("Loot_Store")
	net.WriteEntity(self)
	net.WriteString(k)
	net.WriteFloat(amt)
	net.SendToServer()
  end

  local store_click = function(me, k, amt)
    amt = amt or 1
    local v = items[k]
	--
	if !inventory[k] then
	  inventory[k] = {
		Class = v.Class,
		WG = v.WG,
		Amount = amt,
		SaveVars = v.SaveVars
	  }
	  local but = self:CreateButton(k, inventory, my_inv, menu)
	  local key = order[k] or 1
	  but.Key = me.Key
	  but.DoClick = function(me)
	    local max = 0
		if items[k] then
		  max = items[k].Amount
		end
		if max >= 10 then
	      Fallout_AmountBox("How many?", 1, max, function(val)
		    menu.Take(me, k, val)
		  end)
		else
		  menu.Take(me, k)
		end
	  end
	  local pan = nil
	  local count = table.Count(my_inv.Items)
	    for i=key-1,count do
		  pan = my_inv.Items[i]
		  if pan then break end
		end
	  if key == 1 then
	    my_inv:InsertAtTop(but)
	  elseif pan then
	    my_inv:InsertAfter(pan, but)
	  else
	    my_inv:AddItem(but)
	  end
	else
	  inventory[k].Amount = inventory[k].Amount + amt
	end
    --
	v.Amount = v.Amount - amt
	items[k].Amount = v.Amount
	surface.PlaySound("ui/ui_items_generic_up_01.mp3")
	if v.Amount < 1 then
	  me:Remove()
	  items[k] = nil
	end
	--
	net.Start("Loot_Take")
	net.WriteEntity(self)
	net.WriteString(k)
	net.WriteFloat(amt)
	net.SendToServer()
  end
--
menu.Store = store_click
menu.Take = take_click
-----
local count = 0
  for k,v in SortedPairs(inventory) do
    count = count + 1
	order[k] = count
    local but = self:CreateButton(k, inventory, my_inv, menu)
	but.DoClick = function(me)
	  local max = inventory[k].Amount
	  if max >= 10 then
	    Fallout_AmountBox("How many?", 1, max, function(val)
		  menu.Take(me, k, val)
		end)
	  else
		menu.Take(me, k)
	  end
	end
	my_inv:AddItem(but)
  end
  
  for k,v in SortedPairs(items) do
    local but = self:CreateButton(k, items, loot, menu)
	but.DoClick = function(me)
	  local max = items[k].Amount
	  if max >= 10 then
	    Fallout_AmountBox("How many?", 1, max, function(val)
		  menu.Store(me, k, val)
		end)
	  else
		menu.Store(me, k)
	  end
	end
	loot:AddItem(but)
  end  

end

function ENT:Draw()
	self:DrawModel()
end

function ENT:CreateButton(k, tab, my_inv, menu)
  local but = pig.CreateButton(nil, "", "FO3Font")
  but:SetSize(my_inv:GetWide(), my_inv:GetTall()/7)
  but.OnCursorEntered = function(me)
    surface.PlaySound("ui/focus.mp3")
	me.ins = true
	menu.wg = Schema.InvMassTbl[k] or 0
	--menu.val = v.Price
	menu.cnd = 100
	--menu.firstval = (v.OrderTime or 0).."m"
	--menu.eff = 
	menu.pic = Schema.Icons[k] or Schema.Icons[tab[k].Class] or "pw_fallout/icons/misc/junk.png"
  end
	but.Paint = function(me)
	  local col = Schema.GameColor
	  local name = Schema.InvNameTbl[k] or k
	  local amt = tab[k].Amount
	  if amt > 1 then
	    draw.SimpleText(name.." ("..amt..")","FO3FontUI",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  else
	    draw.SimpleText(name,"FO3FontUI",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  end
	  if !me.ins then return end
	  surface.SetDrawColor(col)
	  surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
	end
  return but
end

--NET
net.Receive("Loot_Menu", function()
local ent = net.ReadEntity()
ent:LootMenu()
end)

net.Receive("Loot_Add", function()
local ent = net.ReadEntity()
local index = net.ReadString()
local class = net.ReadString()
local wg = net.ReadFloat()
local amt = net.ReadFloat()
local save_vars = net.ReadTable()
--
ent.Contents = ent.Contents or {}
--
  ent.Contents[index] = {
    Class = class,
	WG = wg,
	Amount = amt,
	SaveVars = save_vars
  }
end)

net.Receive("Loot_Upd", function()
local ent = net.ReadEntity()
local index = net.ReadString()
local new_amt = net.ReadFloat()
--
ent.Contents[index].Amount = new_amt
end)

net.Receive("Loot_FullUpd", function()
local ent = net.ReadEntity()
local items = net.ReadTable()
--
ent.Contents = items
ent:LootMenu()
end)

net.Receive("Loot_Min", function()
local ent = net.ReadEntity()
local index = net.ReadString()
local amt = net.ReadFloat()
--
local tbl = ent.Contents[index]
local new_amt = tbl.Amount - amt
--
  if new_amt <= 0 then
    ent.Contents[index] = nil
  else
    ent.Contents[index].Amount = new_amt
  end
end)
