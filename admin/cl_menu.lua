
local function setFacMenu(ply, menu)
menu:SetVisible(false)
--
local cmenu = vgui.Create("pig_Frame")
cmenu:SetSize(ScrW()*.4, ScrH()*.4)
cmenu:Center()
cmenu:MakePopup()
cmenu:ShowClose(true)
  cmenu.Paint = function(self)
    surface.SetDrawColor( Schema.GameColor )
    surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
    draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,245) )
    draw.Blur( self, 4, 5, 255 )
  end

local close = cmenu.CloseButton
  close.DoClick = function()
    menu:SetVisible(true)
    cmenu:Remove()
  end

local pw = cmenu:GetWide()*.8
local ph = cmenu:GetTall()*.5

local tbl = vgui.Create("pig_PanelList", cmenu)
tbl:SetSize(pw, ph)
tbl:Center()

local tab = {}
tab["Wastelander"] = 1
tab["New California Republic"] = 2
tab["Caesars Legion"] = 3
tab["Brotherhood Of Steel"] = 4

  for k,v in SortedPairs(tab) do
    local but = pig.CreateButton(nil, k, "PigFont")
	but:SetSize(tbl:GetWide(), tbl:GetTall()/4)
	but.DoClick = function()
	  net.Start("FSetFac")
	  net.WriteString(ply:Name())
	  net.WriteFloat(v)
	  net.SendToServer()
	  menu:SetVisible(true)
	  cmenu:Remove()
	end
	tbl:AddItem(but)
  end  
end

local function openClothingMenu(menu)
menu:SetVisible(false)
--
  if !LocalPlayer():IsSuperAdmin() then
    local Window = Derma_Query("You must be a Super-Admin in order to use this menu", "",
	"Ok", function() surface.PlaySound("ui/ok.mp3") end)
	Window.OldPaint = Window.Paint
	Window.Paint = function(me, w, h)
	  Derma_DrawBackgroundBlur(me, me.Time)
	  me:OldPaint(w, h)
	end
  end
--
local cmenu = vgui.Create("pig_Frame")
cmenu:SetSize(ScrW()*.4, ScrH()*.4)
cmenu:Center()
cmenu:MakePopup()
cmenu:ShowClose(true)
  cmenu.Paint = function(self)
    surface.SetDrawColor( Schema.GameColor )
    surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
    draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,245) )
    draw.Blur( self, 4, 5, 255 )
  end

local close = cmenu.CloseButton
  close.DoClick = function()
    menu:SetVisible(true)
    cmenu:Remove()
  end

local offset = cmenu:GetWide()*.015
local pw = cmenu:GetWide()/2 - (offset*2)
local ph = cmenu:GetTall()*.6

local headtxt = vgui.Create("DLabel", cmenu)
headtxt:SetFont("PigFont")
headtxt:SetText("Head Gear")
headtxt:SizeToContents()
headtxt:SetTextColor(Schema.GameColor)
headtxt:SetPos((offset*2) + (pw/2) - (headtxt:GetWide()/2), offset*3)

local txt = vgui.Create("DLabel", cmenu)
txt:SetFont("PigFont")
txt:SetText("Clothing")
txt:SizeToContents()
txt:SetTextColor(Schema.GameColor)
txt:SetPos((cmenu:GetWide() - pw - offset) + (offset*2) + (pw/2) - (headtxt:GetWide()/2), offset*3)

local headgear = vgui.Create("pig_PanelList", cmenu)
headgear:SetSize(pw, ph)
headgear:SetPos(offset, 0)
headgear:CenterVertical()
  for k,v in SortedPairs(Fallout_Outfits) do
    if !v.helmet then continue end
    local but = pig.CreateButton(nil, k, "PigFont")
	but:SetSize(headgear:GetWide(), headgear:GetTall()/7)
	but.DoClick = function()
	  if !LocalPlayer():IsSuperAdmin() then return end
	  RunConsoleCommand("say", "/spawnapp "..k)
	end
	headgear:AddItem(but)
  end
  
local gear = vgui.Create("pig_PanelList", cmenu)
gear:SetSize(pw, ph)
gear:SetPos(cmenu:GetWide() - gear:GetWide() - offset, 0)
gear:CenterVertical()
  for k,v in SortedPairs(Fallout_Outfits) do
    if v.helmet or k == "Naked" then continue end
    local but = pig.CreateButton(nil, k, "PigFont")
	but:SetSize(headgear:GetWide(), headgear:GetTall()/7)
	but.DoClick = function()
	  RunConsoleCommand("say", "/spawnapp "..k)
	end
	gear:AddItem(but)
  end  
end

local function openAttMenu(ply, menu)
menu:SetVisible(false)
--
  if !LocalPlayer():IsSuperAdmin() then
    local Window = Derma_Query("You must be a Super-Admin in order to use this menu", "",
	"Ok", function() surface.PlaySound("ui/ok.mp3") end)
	Window.OldPaint = Window.Paint
	Window.Paint = function(me, w, h)
	  Derma_DrawBackgroundBlur(me, me.Time)
	  me:OldPaint(w, h)
	end
  end
--
local cmenu = vgui.Create("pig_Frame")
cmenu:SetSize(ScrW()*.4, ScrH()*.4)
cmenu:Center()
cmenu:MakePopup()
cmenu:ShowClose(true)
  cmenu.Paint = function(self)
    surface.SetDrawColor( Schema.GameColor )
    surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
    draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,245) )
    draw.Blur( self, 4, 5, 255 )
  end

local close = cmenu.CloseButton
  close.DoClick = function()
    menu:SetVisible(true)
    cmenu:Remove()
  end
  
local offset = cmenu:GetWide()*.015
local pw = cmenu:GetWide()/2 - (offset*2)
local ph = cmenu:GetTall()*.6
local vx = cmenu:GetWide()*.55
local vy = cmenu:GetTall()*.295

local txt = vgui.Create("DLabel", cmenu)
txt:SetFont("PigFontSmall")
txt:SetText("2) Enter Attributes new value")
txt:SetTextColor(Schema.GameColor)
txt:SizeToContents()
txt:SetPos(vx + (pw*.375) - (txt:GetWide()/2), cmenu:GetTall()*.195)

local txt2 = vgui.Create("DLabel", cmenu)
txt2:SetFont("PigFontSmall")
txt2:SetText("1) Select an Attribute")
txt2:SetTextColor(Schema.GameColor)
txt2:SizeToContents()
txt2:SetPos(offset + (pw/2) - (txt2:GetWide()/2), cmenu:GetTall()*.095)

local name = ply:Name() or "<unknown>"
local txt3 = vgui.Create("DLabel", cmenu)
txt3:SetFont("PigFont")
txt3:SetText("Set "..name.."'s Attribute")
txt3:SetTextColor(Schema.GameColor)
txt3:SizeToContents()
txt3:SetPos(vx + (pw*.375) - (txt3:GetWide()/2), cmenu:GetTall()*.55)

local done = pig.CreateButton(cmenu, "Done!", "PigFontBig")
done:SizeToContents()
done:SetPos(vx + (pw*.375) - (done:GetWide()/2), cmenu:GetTall()*.755 - done:GetTall())
  done.DoClick = function()
    local att = menu.Att
	local aval = menu.AttVal
	if !att or !aval or !LocalPlayer():IsSuperAdmin() then return end
	surface.PlaySound("ui/ok.mp3")
	net.Start("FA_Att")
	net.WriteString(att)
	net.WriteString(name)
	net.WriteFloat(aval)
	net.SendToServer()
  end

local val = vgui.Create("DTextEntry", cmenu)
val:SetPos(vx, vy)
val:SetSize(pw*.75, ph*.18)
val:SetFont("PigFont")
  val.OnTextChanged = function(me)
    local val = me:GetText()
    menu.AttVal = tonumber(val)
  end

local atts = vgui.Create("pig_PanelList", cmenu)
atts:SetSize(pw, ph)
atts:SetPos(offset, 0)
atts:CenterVertical()
  for k,v in SortedPairs(pig.Attributes) do
    local but = pig.CreateButton(nil, k, "PigFont")
	but:SetSize(atts:GetWide(), atts:GetTall()/7)
	but.DoClick = function(me)
	  surface.PlaySound("ui/ok.mp3")
	  menu.Att = k
	end
	but.Paint = function(me,w,h)
	  if menu.Att == k then
	    local col = Color(255,255,255,20)
	    draw.RoundedBox(8,0,0,w,h,col)
	  elseif me.ins then
	    local col = Schema.GameColor
		col = Color(col.r,col.g,col.b,10)
	    draw.RoundedBox(8,0,0,w,h,col)	  
	  end
	end
	atts:AddItem(but)
  end
end

--FUNCS
function AdminNoClip()
local ply = LocalPlayer()
if !ply:IsModerator() then return end
--
local movetype = ply:GetMoveType()
  if movetype != MOVETYPE_NOCLIP then
    return
  end
--
  for k,v in pairs(player.GetAll()) do
    local pos = v:GetPos()
	local ang = v:GetAngles()
	pos = pos + ang:Up()*20
    local hitpos = pos:ToScreen()
	local text = v:GetName()
    Fallout_DrawText(hitpos.x, hitpos.y, text, "FO3FontHUD", Color(0,204,0), TEXT_ALIGN_CENTER)
  end
end

function FAdminMenu()
  if IsValid(pig.vgui.FAdminMenu) then
    pig.vgui.FAdminMenu:Remove()
  end
pig.vgui.FAdminMenu = vgui.Create("pig_AdminMenu")
local menu = pig.vgui.FAdminMenu
menu:SetSize(ScrW() / 2,ScrH() *.75)
menu:Center()
menu:MakePopup()
--
menu.Buts[5] = {
  Name = "GIVE FLAG",
  Admin = true,
  Func = function(self)
    local player = self.Player
	if !IsValid(player) then return end
    Derma_StringRequest("Enter flag name", "Enter flag name to grant "..player:Name().."", "", function(text)
	  LocalPlayer():ConCommand("say /giveflag "..text.." "..player:Name())
	end, nil, nil, nil, true)
  end
}

menu.Buts[6] = {
  Name = "TAKE FLAG",
  Admin = true,
  Func = function(self)
    local player = self.Player
	if !IsValid(player) then return end
    Derma_StringRequest("Enter flag name", "Enter flag name to revoke from "..player:Name().."", "", function(text)
	  LocalPlayer():ConCommand("say /takeflag "..text.." "..player:Name())
	end, nil, nil, nil, true)
  end
}

menu.Buts[7] = {
  Name = "SPECTATE",
  Admin = true,
  Func = function(self)
    local player = self.Player
	if !IsValid(player) then return end
    LocalPlayer():ConCommand('say !spectate "'..player:Name()..'"' )
  end
}

menu.Buts[8] = {
  Name = "UN-SPECTATE",
  Admin = true,
  Func = function(self)
    LocalPlayer():ConCommand('say !respawn "'..LocalPlayer():Name()..'"' )
  end
}

menu.Buts[9] = {
  Name = "VIEW INVENTORY",
  Mod = true,
  Func = function(self)
    local player = self.Player
	if !IsValid(player) then return end
    LocalPlayer():ConCommand('say /viewinv '..player:Name()..'' )
	self:Remove()
  end
}

menu.Buts[10] = {
  Name = "SET MONEY",
  Func = function(self)
    local player = self.Player
	if !IsValid(player) then return end
	if !LocalPlayer():IsSuperAdmin() then
	  pig.Notify(Schema.RedColor, "You must be Super-Admin in order to do this!", 4, nil, "pw_fallout/v_sad.png")
	return end
    Derma_StringRequest("Enter caps", "Enter amount to set "..player:Name().."'s money to", player:GetMoney() or 0, function(text)
	  LocalPlayer():ConCommand("say /setmoney "..text.." "..player:Name())
	end, nil, nil, nil, true)
  end
}

menu.Buts[11] = {
  Name = "HEAL FULLY",
  Mod = true,
  Func = function(self)
    local player = self.Player
	if !IsValid(player) then return end
	LocalPlayer():ConCommand("say /healplayer "..player:Name().."")
  end
}

menu.Buts[12] = {
  Name = "TAKE EQUIPPED WEP",
  Admin = true,
  Func = function(self)
    local player = self.Player
	if !IsValid(player) then return end
	LocalPlayer():ConCommand("say /takewep "..player:Name().."")
  end
}

menu.Buts[13] = {
  Name = "SET ATTRIBUTES",
  Mod = true,
  Func = function(self)
    local player = self.Player
	if !IsValid(player) then return end
	openAttMenu(player, menu)
  end
}

menu.Buts[14] = {
  Name = "VIEW ATTRIBUTES",
  Mod = true,
  Func = function(self)
    local player = self.Player
	if !IsValid(player) then return end
	menu:Remove()
	net.Start("FA_SeeStat")
	net.WriteString(player:Name())
	net.SendToServer()
  end
}

menu.Buts[15] = {
  Name = "SET FACTION",
  Admin = true,
  Func = function(self)
    local player = self.Player
	if !IsValid(player) then return end
	setFacMenu(player, menu)
  end
}
--
menu:RefreshAdminButs()
--
local the_box = menu.Box
local box = vgui.Create("pig_PanelList", menu)
local space = menu:GetTall()*.025
local size_y = (menu:GetTall()*.9) - (the_box:GetTall() + menu.hlist:GetTall()) - (space*2)
box:SetSize(the_box:GetWide(), size_y)
local tx, ty = the_box:GetPos()
box:SetPos(tx, ty + the_box:GetTall() + space)
box:EnableHorizontal(true)
local h = box:GetTall()
-------------------------------------
local buts = {}
  buts[1] = {
    Name = "Spawn Clothing",
	Func = function(self, but)
	  openClothingMenu(menu)
	end,
  }
  buts[2] = {
    Name = "Shop Admin Menu",
	Func = function(self, but)
	  menu:Remove()
	  RunConsoleCommand("ShopAdminMenu")
	end,
  }
  
  
  for k,v in pairs(buts) do
    local base = pig.CreateButton(nil,v.Name,"PigFont")
    base:SetSize(box:GetWide()/2,h *.25)
	base.DoClick = function(me)
	  v.Func()
	end
    box:AddItem(base)
  end
end
concommand.Add("OpenAdminMenu", FAdminMenu)

--NET

net.Receive("F_ViewAtt", function()
local name = net.ReadString()
local att_tbl = net.ReadTable()
--
  if IsValid(pig.vgui.StatMenu) then
    pig.vgui.StatMenu:Remove()
  end
--
pig.vgui.StatMenu = vgui.Create("Fallout_Frame")
local menu = pig.vgui.StatMenu
menu:SetSize(ScrW()*.42, ScrH()*.5)
menu:Center()
menu:SetTitle1(name.."'S STATS")
menu:ShowClose(true)
menu:MakePopup()

local xoffset = menu:GetWide()*.017
local yoffset = menu:GetTall()*.16
local close = menu.CloseButton

local list = vgui.Create("pig_PanelList", menu)
list:SetSize(menu:GetWide() - (xoffset*2), menu:GetTall() - (yoffset*2) - (close:GetTall()))
list:SetPos(xoffset, yoffset)
  for k,v in SortedPairs(att_tbl) do
    local base = vgui.Create("DButton")
    base:SetSize(list:GetWide(),list:GetTall()/9)
    base:SetText("")
    base.OnCursorEntered = function(me)
      surface.PlaySound("ui/focus.mp3")
	  me.ins = true
    end
    base.OnCursorExited = function(me)
      me.ins = false
    end
    base:SetTextColor(Schema.GameColor)
    base.Paint = function(me)
      if me.ins then
	    local col = Schema.GameColor
	    surface.SetDrawColor(col)
	    surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
	    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
	  end
      draw.SimpleText(k, "FO3FontHUD", me:GetWide() *.075, me:GetTall()/2, Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
      draw.SimpleText(v.Point, "FO3FontHUD", me:GetWide() *.8, me:GetTall()/2, Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
	list:AddItem(base)
  end
end)