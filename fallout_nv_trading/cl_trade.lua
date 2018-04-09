
function Schema.Hooks:pig_ChatBoxSendText( ply, text )
  if text == "/trade" then
    if ply.LastTrade and ply.LastTrade > CurTime() then
	  Fallout_TradeNotify()
	end
  end
end

function Fallout_TradeNotify()
local ply = LocalPlayer()
if !ply.LastTrade then return end
local time = math.Round(ply.LastTrade-CurTime())
pig.Notify(Schema.RedColor,"You must wait "..time.." seconds until you can next trade")
end

local function createbut(trade,k,v,my_inv,l_inv,give,glow)
local tbl = nil
local othertbl = nil
  if give then
    tbl = trade.Give
	othertbl = trade.Take
	  for a,b in pairs(my_inv:GetItems()) do
	    if b.Key == k then
		  b.Tbl.Amount = b.Tbl.Amount + 1
		  return
		end
	  end
  else
    tbl = trade.Take
	othertbl = trade.Give
	  for a,b in pairs(l_inv:GetItems()) do
	    if b.Key == k then
		  b.Tbl.Amount = b.Tbl.Amount + 1
		  return
		end
	  end
  end
    local tab = pig.CreateButton(nil,"","FO3FontSmall")
    tab:SetSize(my_inv:GetWide(),my_inv:GetTall()/7)
	tab.OldEnter = tab.OnCursorEntered
	tab.OnCursorEntered = function(me)
	  me.OldEnter(me)
	  trade.wg = v.Weight
	  local info = nil
	    if info then
	      trade.val = info.Val
		  trade.dam = info.Dam or (Fallout_OutfitDT(me.name).." DT" or "--")
		else
		  trade.val = 0
		  trade.dam = "--"
		end
		local class = v.Class
		if class == "pig_ent_wep" then
		  class = v.Saved_Vars[v.Amount].WepClass
		end
		local name = Schema.InvNameTbl[k] or class
		local icon = Schema.Icons[name]
		if icon then trade.pic = icon end
		if trade.wg then
		  trade.wg = math.Round(trade.wg,2)
		end
	end
	tab.DoClick = function(me)
	  surface.PlaySound(Fallout_PickupSound(me.name))
      v.Amount = v.Amount - 1
	  if othertbl[k] then
	    othertbl[k].Amt = othertbl[k].Amt - 1
		if othertbl[k].Amt < 1 then
		  othertbl[k] = nil
		end
	  else
	    if tbl[k] then
	      tbl[k].Amt = tbl[k].Amt + 1
	    else
	      tbl[k] = {Amt = 1, Name = me.name}
	    end	    
	  end  
      if v.Amount < 1 then
	    me:Remove()
	  end
	  if give then
	    local copy = table.Copy(v)
		copy.Amount = 1
	    createbut(trade,k,copy,my_inv,l_inv,false,true)
	  else
	    local copy = table.Copy(v)
		copy.Amount = 1
	    createbut(trade,k,copy,my_inv,l_inv,true,true) 
	  end
	end
	local name = k
	tab.name = name
	tab.Key = key
	tab.Tbl = v
	tab.Paint = function(me)
	  local col = Schema.GameColor
	  local amt = v.Amount or v.Amt
	  if amt < 2 then
	    draw.SimpleText(me.name,"FO3FontHUD",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  else
	    draw.SimpleText(me.name.." ("..amt..")","FO3FontHUD",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  end
	  col = me.Color or col
	  surface.SetDrawColor(col)
	  if me.ins then
	    surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
	  end
	  if me.ins or othertbl and othertbl[k] and give then
	    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
	  elseif othertbl and othertbl[k] and !give then
	    local ocol = Schema.RedColor
	    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(ocol.r,ocol.g,ocol.b,15))
	  end
	end
	if give then
	  my_inv:AddItem(tab)
	else
	  l_inv:AddItem(tab)
	end
return tab
end

function Fallout_SendTrade(give,take,player)
local ply = LocalPlayer()
ply.LastTrade = ply.LastTrade or CurTime() - 1
  if ply.LastTrade > CurTime() then 
    Fallout_TradeNotify()
  return end
ply.LastTrade = CurTime()+Schema.TradeSentCool
--
local window = Derma_Query("You have sent your trade offer to "..player:Name(), "",
   "OK", function() surface.PlaySound("ui/ok.mp3") end)
window.OldPaint = window.Paint
  window.Paint = function(me)
	Derma_DrawBackgroundBlur(me,SysTime()-0.35)
	me.OldPaint(me)
  end
--
net.Start("F_SendTrade")
net.WriteTable(give)
net.WriteTable(take)
net.WriteEntity(player)
net.SendToServer()
end

function Fallout_DeclineTrade(index)
  if !LocalPlayer().TradeOffers or !LocalPlayer().TradeOffers[index] then
    return
  end
LocalPlayer().TradeOffers[index] = nil
net.Start("F_RTrade")
net.WriteString(index)
net.SendToServer()
pig.Notify(Schema.GameColor,"You rejected "..index.."'s Trade Offer")
end

function Fallout_AcceptTrade(index)
  if !LocalPlayer().TradeOffers or !LocalPlayer().TradeOffers[index] then
    return
  end
LocalPlayer().TradeOffers[index] = nil
net.Start("F_ATrade")
net.WriteString(index)
net.SendToServer()
pig.Notify(Schema.GameColor,"You accepted "..index.."'s Trade Offer")
end

function Fallout_PreviewTrade(give,take,offer_ply,panel,index,nt1,nt2)
  if IsValid(pig.vgui.TradeOffers) then
    pig.vgui.TradeOffers:Remove()
  end
pig.vgui.TradeOffers = vgui.Create("Fallout_LootMenu")
local trade = pig.vgui.TradeOffers
local my_inv = trade.Table1
local l_inv = trade.Table2
trade:Center()
local t1 = ""
local t2 = ""
  if offer_ply == LocalPlayer() then
    t1 = "YOUR OFFER"
	t2 = "THEIR ITEMS"
  else
    t1 = "THEY OFFER"
	t2 = "YOUR ITEMS"
	local close = trade.CloseButton
	close:SetText("Respond E)")
	close:SizeToContents()
	local cx,cy = close:GetPos()
	close:SetPos(trade:GetWide()-close:GetWide()-trade.Off,cy)
	close.OldClose = close.DoClick
	close.DoClick = function(me)
	  surface.PlaySound("ui/ok.mp3")
	  local window = Derma_Query("Respond to Trade Offer?","",
	    "Accept",function()		  if index then
		    Fallout_AcceptTrade(index)
		  end
		  surface.PlaySound("ui/ok.mp3")
		  if IsValid(panel) then 
		    panel:SetVisible(true)
			for a,b in pairs(panel.List:GetItems()) do
			  if b.Index == index then
			    b:Remove()
			  end
			end
		  end
		  trade:Remove()
		  end,
		"Reject",function()
		  if index then
		     Fallout_DeclineTrade(index)
		  end
		  surface.PlaySound("ui/ok.mp3")
		  if IsValid(panel) then 
		    panel:SetVisible(true)
			for a,b in pairs(panel.List:GetItems()) do
			  if b.Index == index then
			    b:Remove()
			  end
			end
		  end
		  trade:Remove()
		 end,
		"Back to Offers",function() 
		  surface.PlaySound("ui/ok.mp3")
		   trade:Remove() 
		   if IsValid(panel) then panel:SetVisible(true) end
		 end,
		"Cancel",function() surface.PlaySound("ui/ok.mp3") end)
		window.OldPaint = window.Paint
		window.Paint = function(me)
		  Derma_DrawBackgroundBlur(me,SysTime()-0.35)
		  me.OldPaint(me)
		end
	end
  end
--
t1 = nt1 or t1
t2 = nt2 or t2
trade:SetTitles(t1,t2)
------------------
--MY
  for k,v in SortedPairs(give) do
    local but = createbut(trade,k,v,my_inv,l_inv,true)
	but.DoClick = function() return end
  end
--------------------------------
-------

--------------------------------
--LOOT
  for k,v in SortedPairs(take) do
    local but = createbut(trade,k,v,my_inv,l_inv)
	but.DoClick = function() return end
  end
--
return trade
end

function Fallout_TradeMenu(p_inv,player)
  if IsValid(pig.vgui.Trade) then
    pig.vgui.Trade:Remove()
  end
pig.vgui.Trade = vgui.Create("Fallout_LootMenu")
local trade = pig.vgui.Trade
trade.Give = {}
trade.Take = {}
local my_inv = trade.Table1
local l_inv = trade.Table2
trade:Center()
trade:SetTitles("INVENTORY","TRADE ITEMS")
------------------
--MY
local ply = LocalPlayer()
local copy = table.Copy(ply.Inventory)
  for k,v in SortedPairs(copy) do
    createbut(trade,k,v,my_inv,l_inv,true)
  end
--------------------------------
-------

--------------------------------
--LOOT
  for k,v in SortedPairs(p_inv) do
    createbut(trade,k,v,my_inv,l_inv)
  end
--------
local close = trade.CloseButton
close.OldClose = close.DoClick
close.DoClick = function(me)
  LocalPlayer().LastTrade = CurTime()+Schema.TradeTraceCool
  me.OldClose(me)
end
--
local cx,cy = close:GetPos()
local done = pig.CreateButton(trade,"Accept A)","FO3Font")
done:SizeToContents()
done:SetPos(trade:GetWide() - done:GetWide() - trade.Off,cy-(done:GetTall()*1.2))
  done.DoClick = function(me)
    local window = Derma_Query("Do you wish to trade these items?", "",
	"Accept", function() 
	  surface.PlaySound("ui/ok.mp3")
	  Fallout_SendTrade(trade.Give,trade.Take,player)
	  Fallout_PreviewTrade(trade.Give,trade.Take,LocalPlayer())
	  trade:Remove()
    end,
	"Decline", function() surface.PlaySound("ui/ok.mp3") end)
	  window.OldPaint = window.Paint
	  window.Paint = function(self)
	    Derma_DrawBackgroundBlur(self,SysTime()-0.35)
	    self:OldPaint(self)
	  end
  end

end

net.Receive("F_Trade",function()
local player = net.ReadEntity()
local p_inv = net.ReadTable()
--
Fallout_TradeMenu(p_inv,player)
end)

net.Receive("F_OfferTrade",function()
local index = net.ReadString()
local tbl = net.ReadTable()
--
LocalPlayer().TradeOffers = LocalPlayer().TradeOffers or {}
LocalPlayer().TradeOffers[index] = tbl
pig.Notify(Schema.GameColor,"You received a new Trade Offer from: '"..index.."'")
end)