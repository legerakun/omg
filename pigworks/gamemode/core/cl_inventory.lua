print("CL Inv")

net.Receive("PW_EmptyInv",function()
local index = net.ReadString()
  if LocalPlayer().Inventory then
    LocalPlayer().Inventory[index] = nil
  end
end)

net.Receive("PW_ReturnInv",function()
local index = net.ReadString()
local tbl = net.ReadTable()
local wg = net.ReadFloat()
if !LocalPlayer().Inventory then LocalPlayer().Inventory = {} end
LocalPlayer().Inventory[index] = LocalPlayer().Inventory[index] or {}
----
LocalPlayer().Inventory[index] = tbl
----
if tbl.Amount < 1 then
  LocalPlayer().Inventory[index] = nil
end
LocalPlayer().WG = wg
--
hook.Call("pig_ClientInvUpdated", GAMEMODE, index)
end)

function TakeInvVars(index,take)
local amt = LocalPlayer().Inventory[index].Amount
take = math.Clamp(take,0,amt)
local weight = LocalPlayer().Inventory[index].Weight
local singlewg = LocalPlayer().Inventory[index].SingleWG
  if (amt-take) < 1 then
    LocalPlayer().Inventory[index] = nil
  else
    LocalPlayer().Inventory[index].Amount = amt - take
	LocalPlayer().Inventory[index].Weight = weight - (singlewg*take)
  end
local totake = (singlewg*take)
LocalPlayer().WG = LocalPlayer().WG - totake
print(totake)
end

function DropItem(index, amount)
if !LocalPlayer().Inventory[index] then return end
  if amount and amount <= 0 or amount and LocalPlayer().Inventory[index].Amount < amount then
    return
  end
--
local ply = LocalPlayer()
local default_weps = factionDefaultWeps or {}
local fac_weps = faction[ply:Team()].weapons or {}
local class = ply.Inventory[index].Saved_Vars
  if class then
    class = class[1].WepClass
  end
  if class then
    if table.HasValue(default_weps, class) or table.HasValue(fac_weps, class) then
      if !ply.InvDropNotif or ply.InvDropNotif <= CurTime() then
	    ply.InvFirstNotif = CurTime()+3
	    pig.Notify(Schema.GameColor, "You may not drop any faction or default weapons!", 3)
	  end
      return
    end
  end
--
TakeInvVars(index, amount or 1)
net.Start("PW_DropItem")
net.WriteString(index)
net.WriteFloat(amount or 1)
net.SendToServer()
end

function UseItem(index)
if !LocalPlayer().Inventory[index] or LocalPlayer():InVehicle() then return end
TakeInvVars(index,1)
net.Start("PW_UseItem")
net.WriteString(index)
net.SendToServer()
end
