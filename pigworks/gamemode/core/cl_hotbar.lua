pig.Hotbar = pig.Hotbar or {}
pig.Hotbar.CoolDown = 0.85
pig.HotbarImages = {}

function pig.AddToHotbar(slot,index)
slot = math.Clamp(slot,0,9)
pig.Hotbar[slot] = index
end

function pig.UseHotbar(slot)
local index = pig.Hotbar[slot]
if !index or !LocalPlayer():HasInvItem(index) or LocalPlayer():InVehicle() then return end
UseItem(index)
pig.Hotbar.LastSlot = slot
end

function pig.HotbarBind(ply,bind,pressed)
if !bind:find("slot") and bind != "invnext" and bind != "invprev" then return end
pig.Hotbar.NextUse = pig.Hotbar.NextUse or CurTime() - 1
if pig.Hotbar.NextUse > CurTime() then return true end
pig.Hotbar.NextUse = CurTime() + pig.Hotbar.CoolDown
--
  if bind == "invprev" then
    local cur = (pig.Hotbar.LastSlot or 9) + 0
	  for i=0,9 do
	    local item = pig.Hotbar[i]
	    if i > cur and item and LocalPlayer():HasInvItem(item) then
		  cur = i
		  break
		end
	  end
	if cur > 9 then cur = 0 end
	pig.UseHotbar(cur)
	return true
  elseif bind == "invnext" then
    local cur = (pig.Hotbar.LastSlot or 9) + 0
	  for i=0,9 do
        local item = pig.Hotbar[i]
	    if i < cur and item and LocalPlayer():HasInvItem(item) then
		  cur = i
		  break
		end
	  end
	if cur < 0 then cur = 0 end
	pig.UseHotbar(cur)
    return true
  end
---
local slot = string.gsub(bind,"slot","")
slot = tonumber(slot)
if slot == nil then return true end
pig.UseHotbar(slot)
return true
end
hook.Add("PlayerBindPress","PW_HotBar",pig.HotbarBind)

function pig.HotbarHUD()
local maxW = ScrW()*.4
local newMaxW = hook.Call("pig_SetHotbarWidth", GAMEMODE, maxW)
  if newMaxW then
    maxW = newMaxW
  end
local spacing = Schema.SlotSpacing or 3
local w = (maxW - (spacing*9))/10
local startX = ScrW()/2-(maxW/2)
local y = ScrH()*.98 - (w)
local iw = w*.75
local iw2 = w*.425
local top = hook.Call("pig_DrawHotbar", GAMEMODE, startX, y, maxW, w)
  --
  if top then
    y = 0
  end
  --
  for i=0,9 do
    local x = startX+(w+spacing)*i
	local drawit = hook.Call("pig_DrawHotbarSlot",GAMEMODE,x,y,w,i)
	if drawit == false then continue end
	local col = Color(0,0,0,100)
	if pig.Hotbar.LastSlot == i then
	  col = Color(255,255,255)
	end
    draw.RoundedBox(0, x, y, w, w, col)
	--
	local item = pig.Hotbar[i]
	if pig.Hotbar.LastSlot == i or item and LocalPlayer().Inventory[item] then
	  surface.SetDrawColor(255,255,255)
	else
	  surface.SetDrawColor(135,135,135)	
	end
	local mat = nil
	local selw = nil
	  if item then
	    if !pig.HotbarImages[item] then
		  pig.HotbarImages[item] = pig.GetInvIcon(item)
		end
	    mat = pig.HotbarImages[item]
		selw = iw
	  else
	    selw = iw2
	    if !pig.HotbarImages["key"..i] then
		  pig.HotbarImages["key"..i] = Material("pigworks/key"..i..".png")
		end		
	    mat = pig.HotbarImages["key"..i]
	  end
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(x + (w/2) - (selw/2), y + (w/2) - (selw/2), selw, selw)
  end
end
hook.Add("pig_HUDPaintOnTop","PW_HotBar",pig.HotbarHUD)