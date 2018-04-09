local PANEL = {}

function PANEL:Init()
self.Elements = {}
self.OldPaint = self.Paint
  self.Paint = function(me)
    Derma_DrawBackgroundBlur(me,SysTime()-0.6)
    me.OldPaint(me)
	  if pig.utility.IsFunction(me.DrawFunc) then
	    me.DrawFunc(me)
	  end
  end
self:MakePopup()
self:SetSize(ScrW()*.45,ScrH()*.55)
self:Center()
self:ShowClose(true)
self.DownWidth = self:GetTall()*.08
self.Off = self:GetWide()*.05
--
self:SetTitle1("FACTION")
--
local ply = LocalPlayer()
  if !ply:InFaction() then
    self:NonParty()
  else
    self:Party()
  end
end

function PANEL:PartyInvites()
  for k,v in pairs(self.Elements) do
    v:Remove()
  end
self.DrawFunc = nil
local ply = LocalPlayer()
local list = vgui.Create("pig_PanelList",self)
self.Elements[1] = list
list:SetSize(self:GetWide()*.85,self:GetTall()*.7)
list:SetPos(0,self:GetTall()*.1)
list:CenterHorizontal()
  list.Paint = function(me)
    Fallout_HalfBox(3,0,me:GetWide(),me:GetTall(),me:GetTall()*.125)
  end
--
  for k,v in pairs(LocalPlayer().PartyInvites or {}) do
    local but = pig.CreateButton(nil,"Invite: "..k.." ("..v..")","FO3Font")
	but:SetSize(list:GetWide(),list:GetTall()/6)
	but.DoClick = function(me)
	  local window = Derma_Query("Select option for "..k.." Invite","",
	  "Accept",function()
	    LocalPlayer():AcceptFacInvite(k)
	    surface.PlaySound("ui/ok.mp3")
		self:Remove()
	  end,
	  "Decline",function()
	    LocalPlayer():DeclineFacInvite(k)
	    surface.PlaySound("ui/ok.mp3")
		me:Remove()
	  end,
	  "Cancel",function() surface.PlaySound("ui/ok.mp3") end)
	  window.OldPaint = window.Paint
	  window.Paint = function(me)
	    Derma_DrawBackgroundBlur(me,me.Time)
	    me.OldPaint(me)
	  end
	end
	list:AddItem(but)
  end
end

function PANEL:NonParty()
  for k,v in pairs(self.Elements) do
    v:Remove()
  end
self:SetVisible(false)
local window = Derma_Query("You are currently not in a faction, would you like to create one?","",
  "Yes",function() 
    surface.PlaySound("ui/ok.mp3")
	self:Remove()
	LocalPlayer():CreateClParty()
  end,
  "No",function()
    surface.PlaySound("ui/ok.mp3") 
	self:SetVisible(true)
	self:PartyInvites()
  end)
  window.OldPaint = window.Paint
  window.Paint = function(me)
    Derma_DrawBackgroundBlur(me,me.Time)
    me.OldPaint(me)
  end
end

function PANEL:RequestSlot(player,remove,text)
  if remove then
    local max = PartyMaxSlots()
	local ps = PartyGetSlots()
    for i=1,max do
	  if ps[i] == player then
	    PartyAddSlot(nil,i)
		break
	  end
	end
    return
  end
--
local window = Derma_StringRequest("",text or "Enter the slot for the player: (From 1-4)","1",
  function(text)
    surface.PlaySound("ui/ok.mp3")
    if tonumber(text) == nil then
	  self:RequestSlot(player,remove,"Invalid Number! Party Information Slots range from 1-4 max")
	  return
	end
	text = tonumber(text)
	if text < 1 or text > 4 then
	  self:RequestSlot(player,remove,"Number not in range! Party Information Slots range from 1-4 max")
      return	  
	end
	PartyAddSlot(player,text)
  end)
window.OldPaint = window.Paint
  window.Paint = function(me)
    Derma_DrawBackgroundBlur(me,me.Time)
	me.OldPaint(me)
  end
end

local function PanelNotify(msg)
  local window = Derma_Query("ERROR: "..msg,"","OK",function(text)
    surface.PlaySound("ui/ok.mp3")
  end)
  window.OldPaint = window.Paint
  window.Paint = function(me)
    Derma_DrawBackgroundBlur(me,me.Time)
    me.OldPaint(me)
  end
end

function PANEL:AddRank(name,errormsg,slot)
local fac = LocalPlayer():GetFac()
if !LocalPlayer():IsFactionLeader(fac) then return end
--
self:SetVisible(false)
if IsValid(self.RankMake) then self.RankMake:Remove() end
self.RankMake = vgui.Create("Fallout_Frame")
local rankmake = self.RankMake
rankmake:MakePopup()
rankmake:SetSize(self:GetWide()*.7,self:GetTall())
rankmake:Center()
rankmake:ShowClose(true)
rankmake:SetTitle1("ADD RANK")
rankmake.OldPaint = rankmake.Paint
rankmake.Time = SysTime()
rankmake.Paint = function(me)
  Derma_DrawBackgroundBlur(me,me.Time)
  me.OldPaint(me)
end
rankmake.Think = function(me)
  if !IsValid(self) then
    me:Remove()
	return
  end
end
local list = vgui.Create("pig_PanelList",rankmake)
list:SetSize(rankmake:GetWide()*.9,rankmake:GetTall()*.725)
list:SetPos(0,rankmake:GetTall()*.1)
list:CenterHorizontal()
----
local close = rankmake.CloseButton
close:SetText("E Next)")
close.DoClick = function(me)
surface.PlaySound("ui/ok.mp3")
  local window = Derma_Query("What do you wish to do?","",
  "Go Back",function() 
    surface.PlaySound("ui/ok.mp3")
    rankmake:Remove()
	self:SetVisible(true) 
  end,
  "Finish Rank",function()
    surface.PlaySound("ui/ok.mp3")
	local name = rankmake.RankName
    local valid,emsg = RankNameValid(name)
	  if !valid then
	    PanelNotify(emsg)
	    return
	  end
	  local slot = tonumber(rankmake.RankSlots)
	  local power = tonumber(rankmake.RankPower)
	    if slot == nil or slot < 1 or slot > 5 then
		  PanelNotify("Invalid Slots provided or out of range!")
		  return
		elseif power == nil or power < 1 or power > 10 then
		  PanelNotify("Invalid Power provided or out of range!")
		  return		  
		end
	rankmake:Remove()
    LocalPlayer():AddClRank(name,power,slot)
  end,
  "Cancel",function()
    surface.PlaySound("ui/ok.mp3")
  end)
  --
  window.OldPaint = window.Paint
  window.Paint = function(mez)
    Derma_DrawBackgroundBlur(mez,mez.Time)
    mez.OldPaint(mez)
  end
end
--
----
local buts = {}
buts[1] = {
Text = "Enter Rank Name",
Func = function(text)
  rankmake.RankName = text
end}

buts[2] = {
Text = "Enter Rank Slots (from 1-5)",
Func = function(text)
  rankmake.RankSlots = text
end}

buts[3] = {
Text = "Enter Rank Power (from 1-10)",
Func = function(text)
  rankmake.RankPower = text
end}
--
  for k,v in SortedPairs(buts) do
    local base = vgui.Create("DPanel")
	base:SetSize(list:GetWide(),list:GetTall() / 3)
	base.Paint = function(me)
	  Fallout_HalfBox(3,3,me:GetWide(),me:GetTall(),me:GetTall()*.25)
	end
	local text,blur = Fallout_DLabel(base,0,0,v.Text,v.Font or "FO3FontHUD",Schema.GameColor)
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
	list:AddItem(base)
  end
end

function PANEL:Party()
local ply_ranktbl = {}
  for k,v in pairs(self.Elements) do
    v:Remove()
  end
local ply = LocalPlayer()
local name = ply:GetFac()
local members = FactionMembers(name)
local spacing = 2
--
local save_hier = pig.CreateButton(self,"Save Changes","FO3FontHUD")
save_hier.changed = false
save_hier:SetSize(self:GetWide()*.2,self:GetTall()*.065)
save_hier:SetPos(self:GetWide()*.565,self:GetTall()*.08)
save_hier.OnCursorExited = function() return end
save_hier.ins = true
  save_hier.DoClick = function(me)
    surface.PlaySound("ui/ok.mp3")
    LocalPlayer():SaveClRanks(ply_ranktbl)
	me.changed = false
  end
  save_hier.Think = function(me)
    if me.changed == true then
	  me:SetVisible(true)
	else
	  me:SetVisible(false)
	end
  end
--
local list = vgui.Create("pig_PanelList",self)
self.Elements[1] = list
list:SetSize(self:GetWide()*.35,self:GetTall()*.725)
list:EnableHorizontal(true)
list:SetSpacing(spacing)
list:SetPos(self.Off,self:GetTall()*.16)
  list.Paint = function(me)
    Fallout_HalfBox(3,0,me:GetWide(),me:GetTall(),me:GetTall()*.075)
  end
----------------
  local size = (list:GetWide()/3) - spacing
  local setkval = 0
  for k,v in pairs(members) do
    if v:GetRank() != "Member" then continue end
    setkval = setkval+1
    local base = vgui.Create( "CircularAvatarImage" )
    base:SetSize( size,size )
	base.KVal = setkval
    base:SetPlayer( v, size )
	base.Player = v
	--
	local but = vgui.Create("DButton",base)
	but:SetText("")
	but:Droppable("faction")
	but:SetSize(base:GetSize())
	but:NoClipping(true)
	but.OldThink = but.Think
	but.Think = function(me)
	  local parent = me:GetParent()
	  if IsValid(parent) and me.Player != parent.Player or IsValid(parent) and me.Player == nil then
	    me.Player = parent.Player
	  end
	end
	but.Paint = function(me)
	  local col = Schema.GameColor
	  if list.SelectedPlayer == me.Player or me.Glow then
	    pig.DrawCircle(me:GetWide()/2,me:GetTall()/2,me:GetWide()/2,32,Color(col.r,col.g,col.b,20))
		if !IsValid(me.Player) then return end
		Fallout_DrawText(me:GetWide()/2,me:GetTall()/2,me.Player:Name(),"FO3FontSmall",Schema.GameColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_LEFT)
	  end
	end
	but.OnCursorEntered = function(me)
	  list.SelectedPlayer = me.Player
	end
	but.OnCursorExited = function(me)
	  list.SelectedPlayer = nil
	end
	but.OldMousePress = but.OnMousePressed
	but.OldMouseRelease = but.OnMouseReleased
	but.OnMousePressed = function(me)
	  me.Glow = true
	  me.OldMousePress(me)
	end
	but.OnMouseReleased = function(me,mouse)
	  me.Glow = false
	  me.OldMouseRelease(me)
	    if mouse == MOUSE_RIGHT then
		  me.DoRightClick(me)
		end
	end
	but.DoRightClick = function(me)
	  local window = Derma_Query("Select option for "..v:Name(),"",
	  "Add to Party Info Slot",function()
	    surface.PlaySound("ui/ok.mp3") 
	    self:RequestSlot(v)
	  end,
	  "Remove from Party Info Slot",function()
	    surface.PlaySound("ui/ok.mp3") 
	    self:RequestSlot(v,true)	    
	  end,
	  "Kick from Party",function()
	    surface.PlaySound("ui/ok.mp3")
		local kicked = LocalPlayer():KickFromClFac(v)
		if kicked then me:GetParent():Remove() end
	  end,
	  "Cancel",function() surface.PlaySound("ui/ok.mp3") end)
	  --
	  window.OldPaint = window.Paint
	  window.Paint = function(me)
	    Derma_DrawBackgroundBlur(me,me.Time)
	    me.OldPaint(me)
	  end
	end
	--but:SetSize(list:GetWide(),list:GetTall()/9)
	list:AddItem(base)
  end
-------------
local count = table.Count(members)
local s = "s"
  if count < 2 then
    s = ""
  end
  self.DrawFunc = function(me)
    draw.DrawText(name.." - "..count.." Member"..s.."","FO3FontHUD",me.Off,me:GetTall()*.1,Schema.GameColor)
    draw.DrawText("Ranks","FO3FontHUD",me:GetWide()*.43,me:GetTall()*.1,Schema.GameColor)	
  end
------------
local butlist = vgui.Create("pig_PanelList",self)
self.Elements[2] = butlist
butlist:SetSize(self:GetWide()*.15,self:GetTall()*.65)
butlist:SetPos((self:GetWide()-butlist:GetWide()) - self.Off,self:GetTall()*.16)
--
local buttons = {}
buttons[1] = {
Name = "Leave Faction",
Click = function(me)
  local party = LocalPlayer():GetFac()
  if LocalPlayer():IsFactionLeader(party) then
    Derma_Query("Party leaders cannot abandon a faction without disbanding it","",
	"Ok",function() surface.PlaySound("ui/ok.mp3") end)
    return
  end
  ---
  Derma_Query("Are you sure you want to leave your current faction?","",
  "Yes",function()
    surface.PlaySound("ui/ok.mp3")
    LocalPlayer():LeaveClParty()
    self:Remove()
  end,
  "No",function() surface.PlaySound("ui/ok.mp3") end)
end
}

buttons[2] = {
Name = "Disband Faction",
Click = function(me)
  local party = LocalPlayer():GetFac()
    if !LocalPlayer():IsFactionLeader(party) then
	  Derma_Query("You must be party leader in order to do this!","",
	  "Ok",function() surface.PlaySound("ui/ok.mp3") end)
	  return
	end
  Derma_Query("Are you sure you want to disband this faction? This will also remove all members","",
  "Yes",function()
    surface.PlaySound("ui/ok.mp3")
    LocalPlayer():LeaveClParty()
    self:Remove()
  end,
  "No",function() surface.PlaySound("ui/ok.mp3") end)
end
}

buttons[3] = {
Name = "Faction Invites",
Click = function(me)
  self:PartyInvites()
end
}

buttons[4] = {
Name = "Invite Player",
Click = function(me)
  local window = Derma_StringRequest("","Enter Recipient Name","",function(text)
    surface.PlaySound("ui/ok.mp3")
    LocalPlayer():InvitePlayer(text)
	self:Remove()
  end)
  window.OldPaint = window.Paint
  window.Paint = function(mez)
    Derma_DrawBackgroundBlur(mez,mez.Time)
    mez.OldPaint(mez)
  end
end
}

buttons[5] = {
Name = "Add Rank",
Click = function(me)
  self:AddRank()
end
}
--
  for k,v in SortedPairs(buttons) do
    local but = pig.CreateButton(nil,v.Name,"FO3FontSmall")
	but:SetSize(list:GetWide(),list:GetTall()/7)
	but.DoClick = function(me)
	  v.Click(me)
	end
	butlist:AddItem(but)
  end
--
  local ranklist = vgui.Create("pig_PanelList",self)
  self.Elements[3] = ranklist
  ranklist:SetSize(self:GetWide()*.35,self:GetTall()*.725)
  ranklist:EnableHorizontal(true)
  ranklist:SetSpacing(spacing)
  local lx,ly = list:GetPos()
  ranklist:SetPos(lx + list:GetWide() + (self.Off/2),ly)
  ranklist.Paint = function(me)
    Fallout_HalfBox(3,0,me:GetWide(),me:GetTall(),me:GetTall()*.075)
  end
  local start = ranklist:GetWide()*.95
  local startingval = {}
  startingval[1] = start *.4
  startingval[2] = start *.75
  startingval[3] = start *.9
  startingval[4] = start
  --
  local ranks = PlayerFaction[name].Ranks or {}
  ranks[0] = {Name = "Leader", Slot = 1}
  for k,v in SortedPairs(ranks) do
    local base = vgui.Create("DPanel")
	base:SetSize(start,ranklist:GetTall()/3)
	base.Paint = function(me)
      Fallout_DrawText(me:GetWide()/2,0,v.Name,"FO3FontHUD",Schema.GameColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP)
	end
	local slot = v.Slot
    local w = base:GetWide()/slot
	w = math.Clamp(w,0,size*.85)
	local loop = 0
	--
	local player_tbl = RankMembers(name,v.Name)
    for i=1,slot do
      local element = vgui.Create("CircularAvatarImage",base)
	  element:SetSize(w - (spacing*2),w)
	  local ypos = base:GetTall()/2 - element:GetTall()/2
	  local xpos = startingval[slot]
	  local remaining = base:GetWide() - (w*slot)
	  local spacing = remaining/slot
	  xpos = (base:GetWide()*.012) + (remaining/slot)/2+(w*loop)+(spacing*loop)
	  element:SetPos(xpos,ypos)
	  element.Rank = k
	  element.OnCursorEntered = function(me)
	    list.SelectedPlayer = me.Player
	  end
	  element.OnCursorExited = function(me)
	    list.SelectedPlayer = nil
	  end
	  if player_tbl[i] then
	    local pl = player_tbl[i]
	    element:SetPlayer(pl,size)
		element.Player = pl
	  end
      element.OldPaint = element.Paint
	  element:Receiver("faction",function(me,panels,isDropped)
	    local panel = panels[1]:GetParent()
	    if !isDropped then return end
		local power = LocalPlayer():GetRankPower()
		if !power or me.Rank < power then return end
	    save_hier.changed = true
		save_hier:SetVisible(true)
		local ourparent = me:GetParent()
	    local theirPosX,theirPosY = panel:GetPos()
		local myPosX,myPosY = me:GetPos()
		local myOffX = myPosX+0
		local myOffY = myPosY+0
		local theirOffX = theirPosX+0
		local theirOffY = theirPosY+0
		local scrolltime = ranklist.VBar:GetOffset()
		local scrolltime2 = list.VBar:GetOffset()
		--
		local p1 = panel.Player
		local p2 = me.Player
		local rank = me.Rank
		--
		local ex,ey = ourparent:GetPos()
		panel:SetParent(self)
		me:SetParent(self)
		local rx,ry = ranklist:GetPos()
		local lx,ly = list:GetPos()
		myPosX = rx + myPosX + ex
		myPosY = ry + myPosY + ey + scrolltime
		theirPosX = lx + theirPosX
		theirPosY = ly + theirPosY + scrolltime2
		me:SetPos(myPosX,myPosY)
		panel:SetPos(theirPosX,theirPosY)
		--
		me:MoveTo(theirPosX,theirPosY,0.8,0,-1,function()
		  me:SetParent(ourparent)
		  me:SetPos(myOffX,myOffY)
		  me:SetPlayer(p1,size)
		  me.Player = p1
		  ply_ranktbl[p1:Name()] = rank
		end)
		panel:MoveTo(myPosX,myPosY,0.8,0,-1,function()
		  if !IsValid(p2) then panel:Remove() return end
          list:AddItem(panel)
		  panel:SetPlayer(p2,size)
		  if ply_ranktbl[p2:Name()] then
		    ply_ranktbl[p2:Name()] = nil
		  end
		  panel.Player = p2
		end)		
	  end)
	  element.Paint = function(me)
	    me.OldPaint(me)
		local col = Schema.GameColor
		surface.SetDrawColor(col)
		surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
		if list.SelectedPlayer == me.Player then
	      pig.DrawCircle(me:GetWide()/2,me:GetTall()/2,me:GetWide()/2,32,Color(col.r,col.g,col.b,20))
		  if !IsValid(me.Player) then return end
		  Fallout_DrawText(me:GetWide()/2,me:GetTall()/2,me.Player:Name(),"FO3FontSmall",Schema.GameColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_LEFT)
	    end
	  end
	  loop = loop+1
	end
	--
	ranklist:AddItem(base)
  end
end

vgui.Register("Fallout_Party", PANEL, "Fallout_Frame")