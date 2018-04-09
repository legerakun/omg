
--Chat Commands----------------
Schema.ChatCommands["Me"] = {
cmd = "me",--The Chat Command to type
col = Color(255,191,128),--Color of the chat
range = 500,--The range of people so that they can see it
global = false,--Set true so everyone can see regardless of position 
non_text_callback = false,--Set to true to activate the commands function Server-side. Set to false to activate Client-side.
sign = "",--The sign used
tag = "**",--The tag used
speech = false,--Should there be speech marks?
tag_col = Color(255,191,128),
func = function(ply,text)--The function callback. Used to easily return the new text. func( player that typed , player text )
end
}
Schema.ChatCommands["OOC"] = {
cmd = "ooc",
col = Color(255,255,255),
global = true,
tag = "[OOC]",
sign = ":",
namecol = Color(0,153,51),
tag_col = Color(225,225,225),
}
Schema.ChatCommands["LOOC"] = {
cmd = "looc",
col = Color(255,255,255),
range = 450,
global = false,
tag = "[LOOC]",
UseCharName = true,
sign = ":",
namecol = Color(255, 227, 130),
tag_col = Color(193, 44, 44),
}
Schema.ChatCommands["Yell"] = {
cmd = "y",
global = false,
range = 1150,
speech = true,
sign_col = Color(252, 162, 162),
tag = "",
sign = " yells"
}
Schema.ChatCommands["Whisper"] = {
cmd = "w",
global = false,
range = 55,
speech = true,
sign_col = Color(161, 206, 251),
tag = "",
sign = " whispers"
}
--


--Con Commands
Schema.ChatCommands["changedesc"] = {
cmd = "changedesc",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  ply.NextDesc = ply.NextDesc or CurTime()-1
  if ply.NextDesc > CurTime() then 
    PW_Notify(ply, Schema.RedColor, "You cannot do this for another "..math.Round(ply.NextDesc - CurTime()).." seconds")
  return end
  --
  local command = "changedesc  "
  text = text:sub(command:len(),text:len())
  --
  pig.utility.CheckDescription(text, function()
    ply:SetDesc(text)
	PW_Notify(ply, nil, "You successfully changed your description. You are unable to do this for another 2 minutes.")
	ply.NextDesc = CurTime()+120
  end,
  function()
	PW_Notify(ply, Schema.RedColor, "This description is invalid! Please try again")  
  end)
end
}

Schema.ChatCommands["deletechar"] = {
cmd = "deletechar",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  if !ply:IsAdmin() then return end
  local command = "deletechar "
  local thePly = text:sub(command:len()+1,text:len())
  thePly = pig.FindPlayerByName(thePly)
  --
  if !IsValid(thePly) then
    PW_Notify(ply,Schema.RedColor,"Could not find the selected player!")
    return
  end
  --
  local str = "Steam name: '"..ply:GetName().."' deleted the character '"..thePly:Name().."' belonging to "..thePly:GetName().."'" 
  --
  DeletePlayerCharacter(ply)
  pig.ChatPrintAll(str, Color(255,255,255))
end
}

Schema.ChatCommands["spawnapp"] = {
cmd = "spawnapp",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  if !ply:IsSuperAdmin() then return end
  local command = "spawnapp  "
  local app = text:sub(command:len(),text:len())
  --
  if !Fallout_Outfits[app] then
    PW_Notify(ply,Schema.RedColor,"'"..app.."' is an unrecognised clothing item!")
    return
  end
  --
  local str = "Steam name: '"..ply:GetName().."' spawned the apparel item; "..app.."" 
  pig.AdminNotify(str)
  local pos = ply:GetPos()
  local ang = ply:GetAngles()
  local clothing = SpawnOutfit(app, pos + ang:Up()*10 + ang:Forward()*25, ang)
end
}

Schema.ChatCommands["giveflag"] = {
cmd = "giveflag",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  if !ply:IsAdmin() then return end
  local command = "giveflag  "
  text = text:sub(command:len(),text:len())
  local texts = string.Explode(" ", text)
  local flag = texts[1]
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
  if !pig.Flags[flag] then
    PW_Notify(ply,Schema.RedColor,"'"..flag.."' is not a valid Flag!")
    return
  end
  --
  actualply:GiveFlag(flag,ply)
  local msg = "Steam name '"..ply:GetName().."' granted Flag '"..flag.."' onto "..actualply:Name()..""
  for k,v in pairs(player.GetAll()) do
    pig.ChatPrint(v,nil,msg)
  end
end
}

Schema.ChatCommands["takeflag"] = {
cmd = "takeflag",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  if !ply:IsAdmin() then return end
  local command = "giveflag  "
  text = text:sub(command:len(),text:len())
  local texts = string.Explode(" ", text)
  local flag = texts[1]
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
  if !pig.Flags[flag] then
    PW_Notify(ply,Schema.RedColor,"'"..flag.."' is not a valid Flag!")
    return
  end
  --
  actualply:RemoveFlag(flag,ply)
  local msg = "Steam name '"..ply:GetName().."' revoked Flag '"..flag.."' from "..actualply:Name()..""
  for k,v in pairs(player.GetAll()) do
    pig.ChatPrint(v,nil,msg)
  end
end
}

Schema.ChatCommands["viewinv"] = {
cmd = "viewinv",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  if !ply:IsModerator() then return end
  --
  local command = "viewinv "
  local thePly = text:sub(command:len()+1,text:len())
  thePly = pig.FindPlayerByName(thePly)
  --
  if !IsValid(thePly) then
    PW_Notify(ply,Schema.RedColor,"Could not find the selected player!")
    return
  end
  --
  local inventory = thePly.Inventory
  net.Start("Admin_ViewInv")
  net.WriteString(thePly:Name())
  net.WriteTable(inventory)
  net.Send(ply)
end
}

Schema.ChatCommands["setmoney"] = {
cmd = "setmoney",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  if !ply:IsSuperAdmin() then return end
  local command = "setmoney  "
  text = text:sub(command:len(),text:len())
  local texts = string.Explode(" ", text)
  local amt = tonumber(texts[1])
  if amt == nil then
    PW_Notify(ply,Schema.RedColor,"Enter a valid amount of money!")
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
  actualply:SetMoney(amt)
  local msg = "Steam name '"..ply:GetName().."' set "..actualply:Name().."'s money to "..amt
  for k,v in pairs(player.GetAll()) do
    pig.ChatPrint(v,nil,msg)
  end
end
}

Schema.ChatCommands["healplayer"] = {
cmd = "healplayer",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  if !ply:IsModerator() then return end
  local command = "healplayer  "
  local thePly = text:sub(command:len(),text:len())
  thePly = pig.FindPlayerByName(thePly)
  if !IsValid(thePly) then
    PW_Notify(ply, Schema.RedColor, "Invalid Player!")
	return
  end
  --
  thePly:SetHealth(100)
  local limbs = GetAllLimbs()
  for k,v in pairs(limbs) do
    thePly:SetLimb(v, 100)
  end
  --
  PW_Notify(thePly, nil, ply:Name().." fully healed you and all your limbs")
  local msg = ply:Name().." fully healed "..thePly:Name()
  for k,v in pairs(player.GetAll()) do
    pig.ChatPrint(v, nil, msg)
  end
end
}

Schema.ChatCommands["takewep"] = {
cmd = "takewep",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  if !ply:IsAdmin() then return end
  local command = "takewep  "
  local thePly = text:sub(command:len(),text:len())
  thePly = pig.FindPlayerByName(thePly)
  if !IsValid(thePly) then
    PW_Notify(ply, Schema.RedColor, "Invalid Player!")
	return
  end
  --
  local wep = pig_DropWeapon(thePly)
  if !IsValid(wep) then return end
  wep:InventoryUse(ply)
  --
  PW_Notify(thePly, nil, ply:Name().." took your equipped weapon", "pw_fallout/v_sad.png")
  local msg = ply:Name().." took "..thePly:Name().."'s equipped weapon"
  for k,v in pairs(player.GetAll()) do
    pig.ChatPrint(v, nil, msg)
  end
end
}

Schema.ChatCommands["createkey"] = {
cmd = "createkey",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)
  if !ply:IsModerator() then return end
  local ent = pig.utility.PlayerQuickTrace(ply,160).Entity
  if !IsValid(ent) or ent:GetClass() != "container" then return end
  --
  local command = "createkey  "
  local amt = text:sub(command:len(),text:len())
  if amt and amt != "" then
    amt = tonumber(amt)
  end
  --
  ent:MakeKey(amt)
  PW_Notify(ply, nil, "Successfully made a new key!")
end
}

Schema.ChatCommands["adminmenu"] = {
cmd = "adminmenu",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
ClientFunc = function(ply,text)
  if ply == LocalPlayer() then
    RunConsoleCommand("OpenAdminMenu")
  end
end
}

Schema.ChatCommands["shopadmin"] = {
cmd = "shopadmin",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
ClientFunc = function(ply,text)
  if ply == LocalPlayer() then
    RunConsoleCommand("ShopAdminMenu")
  end
end
}

Schema.ChatCommands["giveammo"] = {
cmd = "giveammo",--This command now always prints SERVER in the players console. 
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)--As non_text_callback is on, meaning its activated serverside, anything within the function is called.
  if !ply:IsAdmin() then return end
  local command = "giveammo  "
  text = text:sub(command:len(),text:len())
  local texts = string.Explode(" ", text)
  local ammo = texts[1]
  local count = tonumber(texts[2])
  local thePly = ""
  local max = table.Count(texts)
    for i=3,max do
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
  if !count then
    PW_Notify(ply, Schema.RedColor, "There is no valid number provided!")
    return
  end  
  --
  local ammotbl = {}
  ammotbl["10mm"] = "fo3_ammo_10mm"
  ammotbl["9mm"] = "fo3_ammo_9mm"
  ammotbl[".308"] = "fo3_ammo_308"
  ammotbl[".44"] = "fo3_ammo_44"
  ammotbl["12g"] = "fo3_ammo_12g"
  ammotbl["5.56mm"] = "fo3_ammo_556mm"
  ammotbl["5mm"] = "fo3_ammo_5mm"
  ammotbl["APCell"] = "fo3_ammo_apcell"  
  ammotbl["EC-Pack"] = "fo3_ammo_ecpack"  
  ammotbl["E-Cell"] = "fo3_ammo_ecell"
  ammotbl["MFCell"] = "fo3_ammo_mfcell"  
  ammotbl["Mini-Nuke"] = "fo3_ammo_nuke"  
  
  local ammoname = tostring(ammo)..""
  ammo = ammotbl[ammo]
  if !ammo then
    PW_Notify(ply,Schema.RedColor,"'"..(ammo or "<Undefined>").."' is not a valid Ammo Type!")
    return
  end
  --
  local ent = ents.Create(ammo)
  ent:Spawn()
  actualply:InvStoreEnt(ent, true, false, count)
  PW_Notify(actualply, nil, "You were given x"..count.." "..ammoname)
  --
  local msg = "Steam name '"..ply:GetName().."' gave x"..count.." "..ammoname.." ammo to "..actualply:Name()
  pig.AdminNotify(msg)
end
}

Schema.ChatCommands["resetpass"] = {
cmd = "resetpass",
non_text_callback = true,
func = function(ply)
  if !ply:IsModerator() then return end
  local ent = pig.utility.PlayerQuickTrace(ply,150).Entity
  if !IsValid(ent) or ent:GetClass() != "terminal" then return end
  --
  ent:SetPassword()
  end
}

Schema.ChatCommands["viewstats"] = {
cmd = "viewstats",
non_text_callback = true,
func = function(ply)
  local delay = 60
  if ply.NextViewStats and ply.NextViewStats > CurTime() then
    if !ply.NextNotifyStats or ply.NextNotifyStats <= CurTime() then
	  ply.NextNotifyStats = CurTime() + 5
	  PW_Notify(ply, nil, "You must wait "..(ply.NextViewStats - CurTime()).." seconds before using this command")
	end
  return end
  --
  local ent = pig.utility.PlayerQuickTrace(ply,150).Entity
  if !IsValid(ent) or !ent:IsPlayer() then return end
  --
  ply.NextViewStats = CurTime() + delay
  Fallout_ViewAttributes(ent, ply)
  local name = "A Wastelander"
  if ent:Recognises(ply) then
    name = ply:Name()
  end
  PW_Notify(ent, nil, name.." is viewing your stats")
end
}
-----
------------------------------

--------------
--NET
if SERVER then
  util.AddNetworkString("Admin_ViewInv")
  util.AddNetworkString("Admin_TakeInv")
  
  net.Receive("Admin_TakeInv",function(_,ply)
    if !ply:IsAdmin() then return end
	local name = net.ReadString()
	local tab = net.ReadTable()
	local thePly = pig.FindPlayerByName(name)
	
	if !IsValid(thePly) then
	  PW_Notify(ply, Schema.RedColor, "Player '"..name.."' no longer valid!")
	  return
	elseif thePly:IsSuperAdmin() and !ply:IsSuperAdmin() then
	  pig.ChatPrintAll("Admin: '"..ply:Name().."' attempted to take Super-Admin: '"..thePly:Name().."'s' Inventory items, but was denied", Schema.RedColor)
	  return
	end
	
	for k,v in pairs(tab) do
	  for i=1,v do
	    local ent = thePly:DropItem(k)
		ply:InvStoreEnt(ent)
	  end
	end
	
	print("-----------------")
	print("--Taken Items")
	print("Admin: STEAM '"..ply:GetName().."'  STEAMID: "..ply:SteamID())
	print("Player: STEAM '"..thePly:GetName().."' STEAMID: "..thePly:SteamID())
	print("")
	PrintTable(tab)
	print("------------------")
	pig.AdminNotify("'"..ply:GetName().."' (STEAM "..ply:GetName()..") took inventory items from "..thePly:Name().." (Look in SERVER Console)")
  end)

end

if CLIENT then

local function createbutton(key, tbl, name, my_inv, other_inv, admin_take, trade)
local tab = pig.CreateButton(nil,"","FO3FontSmall")
tab:SetSize(my_inv:GetWide(),my_inv:GetTall()/7)
tab.Tbl = table.Copy(tbl)
tab.Key = key
tab.name = name
--
tab.Tbl.Amount = 1
--
  tab.DoClick = function(me)
    return
  end
  tab.OnCursorEntered = function(me)
    me.ins = true
    local v = me.Tbl
    local class = v.Class
    if class == "pig_ent_wep" then
	  class = v.Saved_Vars[v.Amount].WepClass
	else
	  class = name
	end
	local icon = Schema.Icons[class]
	if icon then trade.pic = icon end
  end
--
  tab.Paint = function(me)
    local col = Schema.GameColor
	local v = me.Tbl
	local amt = admin_take[name]
	if amt < 2 then
	  draw.SimpleText(me.name,"FO3FontHUD",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	else
	  draw.SimpleText(me.name.." ("..amt..")","FO3FontHUD",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	surface.SetDrawColor(col)
	if me.ins then
	  surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
	end
  end
  my_inv:AddItem(tab)
  return tab
end

net.Receive("Admin_ViewInv",function()
local name = net.ReadString()
local inv = net.ReadTable()
local trade = Fallout_PreviewTrade({}, inv, LocalPlayer(), nil, nil, "TAKE ITEMS", "THEIR INV")
pig.vgui.TradeOffers = nil
  if IsValid(pig.vgui.InvView) then
    pig.vgui.InvView:Remove()
  end
pig.vgui.InvView = trade
--
  if LocalPlayer():IsModerator() and !LocalPlayer():IsAdmin() then
    Derma_Query("As a Moderator you may view peoples Inventories but may not take items", "",
	"Got it", function() surface.PlaySound("ui/ok.mp3") end)
  end
--
local take = trade.Table1
local inv_tbl = trade.Table2
local admin_take = {}
--
  for k,v in pairs(inv_tbl:GetItems()) do
    v.DoClick = function(me, opp)
	  surface.PlaySound(Fallout_PickupSound(me.name))
	  local key = me.Key
	  local tab = me.Tbl
	  local name = me.name
	  --
	  tab.Amount = tab.Amount - 1
	  --
	  if !admin_take[name] then
	    local but = createbutton(key, tab, name, take, inv_tbl, admin_take, trade)
		admin_take[name] = 1
	  else
	    admin_take[name] = admin_take[name]+1
	  end
	  if tab.Amount <= 0 then
		me:Remove()
	  end
	end
  end
--
local close = trade.CloseButton
  close.DoClick = function(me)
    local count = table.Count(admin_take)
	if count <= 0 then
	  trade:Remove()
	else
	local derm = Derma_Query("Choose option", "Choose option",
	"Take items", function()
	    net.Start("Admin_TakeInv")
	    net.WriteString(name)
	    net.WriteTable(admin_take)
	    net.SendToServer()
	    trade:Remove()
		surface.PlaySound("ui/ok.mp3")
	  end,
	  "Close Menu", function() surface.PlaySound("ui/ok.mp3") trade:Remove() end,
	  "Cancel", function() surface.PlaySound("ui/ok.mp3") end)
	  derm.OldPaint = derm.Paint
	  derm.Paint = function(me)
	    Derma_DrawBackgroundBlur(me, me.Time)
	    me.OldPaint(me)
	  end
	end
  end

end)

end