Shop = Shop or {}
Shop.Categories = Shop.Categories or {}
Shop.Items = Shop.Items or {}
------------------

function Shop.GetItemTraders(itemname)
local cat = Shop.Items[itemname].Category
local flagtbl = Shop.Categories[cat]
local members = {}
--
  for _,ply in pairs(player.GetAll()) do
    local add = true
	if !flagtbl then add = false break end
    for _,flag in pairs(flagtbl) do
      if !ply:HasFlag(flag) then add = false break end
    end
	if add or ply:IsSuperAdmin() then
	  table.insert(members, ply)
	end
  end
--
return members
end

function Shop.GetCatTraders(cat)
local flagtbl = Shop.Categories[cat]
local members = {}
--
  for _,ply in pairs(player.GetAll()) do
    local add = true
    for _,flag in pairs(flagtbl) do
      if !ply:HasFlag(flag) then add = false break end
    end
	if add then
	  table.insert(members, ply)
	end
  end
--
return members
end

function Shop.GetRestockDate(r_days, r_mins)
local mins = 60*(r_mins)
local days = 86400*(r_days)
--
local date = os.time() + mins + days
return date
end

function Shop.TimeLeft(date)
local time = os.time()
local count = date - time
local format = string.FormattedTime( count )--os.date("%H:%M - %d/%m/%Y", date - time)
--
local hours = format["h"]
local mins = format["m"]
local secs = format["s"]
local days = hours/24
--local olddays = math.Round(days,2)
  if pig.utility.IsFloat(days) then
    local rounded = math.Round(days)
	if rounded > days then
	  days = math.Round(days-1)
	elseif rounded < days then
	  days = rounded
	end
  end

hours = hours - (24*days)
--
local ret = nil
  if days > 0 then
    ret = days.."d "..hours.."h "..mins.."m "..secs.."s"
  elseif hours > 0 then
    ret = hours.."h "..mins.."m "..secs.."s"
  else
    ret = mins.."m "..secs.."s"    
  end
--
return ret
end

function Shop.TimerName(ply, itemname)
local tname = "ShopDel:"..ply:GetCharID().."_"..itemname
return tname
end

function Shop.DeliveryTime(ply, itemname)
local tname = Shop.TimerName(ply, itemname)
local time_left = timer.TimeLeft(tname)
return string.FormattedTime( time_left, "%02i:%02i:%02i" )
end