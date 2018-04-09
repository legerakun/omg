local char = FindMetaTable("Player")

function char:GetChips()
local index = Schema.InvNameTbl["gamb_chip"] or "gamb_chip"
local amt = self:GetInvAmount(index)
  if !amt then
    amt = 0
  end
return amt
end

-------------------------
--CHAT COMMANDS
-------------------------

Schema.ChatCommands["givechips"] = {
cmd = "givechips",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  if !ply:IsSuperAdmin() then return end
  local command = "givechips  "
  text = text:sub(command:len(),text:len())
  local texts = string.Explode(" ", text)
  local amt = tonumber(texts[1])
  if amt == nil then
    PW_Notify(ply,Schema.RedColor,"Enter a valid amount of chips!")
    return 
  end
  local thePly = ""
  local max = table.Count(texts)
    for i=2,max do
	  if i != max then
	    thePly = thePly..""..texts[i].." "
	  else
	    thePly = thePly..""..texts[i]..""	  
	  end
	end
  local actualply = pig.FindPlayerByName(thePly)
  --
  if !IsValid(actualply) then
    PW_Notify(ply,Schema.RedColor,"'"..thePly.."' was not a valid name of a player!")
    return
  end
  --
  actualply:GiveChips(amt)
  local msg = "Steam name '"..ply:GetName().."' gave "..actualply:Name().." "..amt.."  Chips"
   pig.AdminNotify(msg)
end
}

Schema.ChatCommands["takechips"] = {
cmd = "takechips",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  if !ply:IsSuperAdmin() then return end
  local command = "takechips  "
  text = text:sub(command:len(),text:len())
  local texts = string.Explode(" ", text)
  local amt = tonumber(texts[1])
  if amt == nil then
    PW_Notify(ply,Schema.RedColor,"Enter a valid amount of chips!")
    return 
  end
  local thePly = ""
  local max = table.Count(texts)
    for i=2,max do
	  if i != max then
	    thePly = thePly..""..texts[i].." "
	  else
	    thePly = thePly..""..texts[i]..""	  
	  end
	end
  local actualply = pig.FindPlayerByName(thePly)
  --
  if !IsValid(actualply) then
    PW_Notify(ply,Schema.RedColor,"'"..thePly.."' was not a valid name of a player!")
    return
  end
  --
  amt = math.Clamp(amt, 1, actualply:GetChips())
  actualply:TakeChips(amt)
  local msg = "Steam name '"..ply:GetName().."' took "..amt.."  chips off "..actualply:Name()
   pig.AdminNotify(msg)
end
}
