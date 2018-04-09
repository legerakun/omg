include("shared.lua")
local TerminalCol = Color(73,245,144)
local TerminalTime = 0.013
local TerminalMaxChar = 470

surface.CreateFont( "TerminalFont",
{
		font      = "RuneScape UF",
		size      = ScreenScale(11),
		weight    = 1000,
		antialias = false,
		ScanLines = 5,
		blursize = 0
	})	
surface.CreateFont( "TerminalFontSmall",
{
		font      = "RuneScape UF",
		size      = ScreenScale(9),
		weight    = 1000,
		antialias = false,
		ScanLines = 5,
		blursize = 0
	})		

function ENT:Draw()
	self:DrawModel()
end

local function CreateLetter(single_w,single_h)
local badletters = {"%","@","*","!","/","&","?"}
local letter = vgui.Create("DButton")
letter:SetText(table.Random(badletters))
letter:SetFont("TerminalFontSmall")
letter:SetSize(single_w,single_h)
letter:SetTextColor(TerminalCol)
  letter.OnCursorEntered = function(me)
    me.ins = true
	me:SetTextColor(Color(0,0,0))
  end
  letter.OnCursorExited = function(me)
    me.ins = false
	me:SetTextColor(TerminalCol)
  end
  letter.Paint = function(me) 
    if me.ins then
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),TerminalCol)
	end
  end
--
return letter
end

local function CreateButt(word,screen,ent)
local button = vgui.Create("DButton")
button:SetText(word:upper())
button:SetTextColor(TerminalCol)
button:SetFont("TerminalFontSmall")
button:SizeToContents()
  button.DoClick = function(me)
    if ent.HackedSystem then return end
    if screen.Word:lower() == word:lower() then
	  screen.OpenHack(screen,word)
	else
	  local correct = 0
	  local tab = string.ToTable(word)
	  local letters = {}
	    for k,v in SortedPairs(tab) do
		  if screen.Word:find(v) and !letters[v] then 
		    correct = correct + 1
			letters[v] = true
		  end
		end
	  screen.FailAttempt(screen,word,correct)
	end
  end
  button.OnCursorEntered = function(me)
    me.ins = true
	me:SetTextColor(Color(0,0,0))
	screen.SelText = word
	screen.WriteLabel.TitleTime = CurTime()+0.12
	screen.WriteLabel.Texts = nil
	screen.WriteLabel:SetText("")
  end
  button.OnCursorExited = function(me)
    me.ins = false
	me:SetTextColor(TerminalCol)
  end
  button.Paint = function(me) 
    if me.ins then
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),TerminalCol)
	end
  end
--
return button
end

local function CreateList(screen,my_words,words,lw,lh,ent)
local list = vgui.Create("pig_PanelList",screen)
list:SetSize(lw,lh)
list:EnableHorizontal(true)
---
local loop = 0
local tall = 0
local wide = 0
local single_w = list:GetWide()/12
local single_h = list:GetTall()*.07
  for k,v in RandomPairs(my_words) do
      for i=1,v.Letters do
	    local letter = CreateLetter(single_w,single_h)
		wide = wide + letter:GetWide()
		if wide >= list:GetWide() then
		  wide = 0
		  tall = tall + letter:GetTall()
		end
		list:AddItem(letter)
	  end
    local button = CreateButt(v.Word,screen,ent)
	if wide + button:GetWide() > list:GetWide() then 
	  for i=1,math.Round((list:GetWide() - wide)/single_w) do
	    local letter = CreateLetter(single_w,single_h)
		list:AddItem(letter)
		wide = wide + letter:GetWide()
	  end
	end
	wide = wide + button:GetWide()
      if wide >= list:GetWide() then
		wide = 0
		tall = tall + button:GetTall()
	  end	
	list:AddItem(button)
	loop = loop + 1
	my_words[k] = nil
	if loop >= (words/2) then break end
  end
--
tall = math.Round(tall*1.225)
local maxtall_loops = math.Round((list:GetTall()-tall)/single_h)
maxtall_loops = math.Clamp(maxtall_loops,0,14)
  if tall < list:GetTall() then
    for i=1,maxtall_loops-1 do
	  for a=1,math.Round((list:GetWide())/single_w)-2 do
        local letter = CreateLetter(single_w,single_h)
		list:AddItem(letter)
      end
	end
  end
--
return list,tall
end

function ENT:SuccessHack(screen)
self.HackedSystem = true
  timer.Simple(2,function()
    if IsValid(screen) then
	  self:TerminalScreen()
	end
  end)
end

function ENT:GetAttempts()
self.Attempts = self.Attempts or 4
return self.Attempts
end

function ENT:Hack()
local terminal,screen = self:MakeTerminal()
screen.Attempts = self:GetAttempts()
screen.Think = function() return end
--
local oldpaint = screen.Paint
  screen.FailAttempt = function(me,word,correct)
    surface.PlaySound("ui/ui_hacking_bad.mp3")
    me.Attempts = me.Attempts - 1
	self.Attempts = me.Attempts
	local attemplabel = me.AttemptLabel
	attemplabel:SetText(attemplabel:GetText().."\n>"..word:upper().."\n"..">Entry denied\n>"..correct.."/"..me.Word:len()..".")
	if me.Attempts <= 0 then
	  self:Hack()
	  me:GetParent():Remove()
	end
  end
  screen.Paint = function(me)
    oldpaint(me)
	draw.DrawText("ROBCO INDUSTRIES (TM) TERMLINK PROTOCOL","TerminalFont",me:GetWide()*.1,me:GetTall()*.075,TerminalCol,TEXT_ALIGN_LEFT)
    draw.DrawText("ENTER PASSWORD NOW","TerminalFont",me:GetWide()*.1,me:GetTall()*.125,TerminalCol,TEXT_ALIGN_LEFT)
	local attempttext = me.Attempts.." ATTEMPTS LEFT:"
	  for i=1,me.Attempts do
	    attempttext = attempttext.." *"
	  end
    draw.DrawText(attempttext,"TerminalFont",me:GetWide()*.1,me:GetTall()*.2,TerminalCol,TEXT_ALIGN_LEFT)  
    if me.Attempts <= 0 then
      draw.DrawText("TERMINAL LOCKED\nPLEASE CONTACT AN ADMINISTRATOR","TerminalFont",me:GetWide()*.1,me:GetTall()*.35,TerminalCol,TEXT_ALIGN_LEFT) 
    end	
	--draw.DrawText(me.Title4 or "","TerminalFont",me.Offset,me:GetTall()*.225,TerminalCol,TEXT_ALIGN_LEFT)
  end
  if screen.Attempts <= 0 then return end
  screen.Line = nil
  screen.OpenHack = function(me,word)
    surface.PlaySound("ui/ui_hacking_good.mp3")
	local attemplabel = me.AttemptLabel
	attemplabel:SetText(attemplabel:GetText().."\n>"..word:upper().."\n"..">Exact match!\n>Please wait\n>while system\n>is accessed.")
    self:SuccessHack(me)
  end
--
local diff = self:GetNWInt("SecLevel", 0)
  if diff >= 75 and diff <= 100 then
    diff = 4
  elseif diff >= 50 and diff <= 74 then
    diff = 3
  elseif diff >= 25 and diff <= 49 then
    diff = 2
  else
    diff = 1
  end
--
local word_tbl = {}
word_tbl[1] = {"jazz", "mush", "bruv", "fuzz", "quiz", "quid", "jinx", "jeux", "feif", "junk", "gimp", "cimp", "punk", "sicc", "juke", "zonk", "java"}
word_tbl[2] = {"muzzily", "fuzzily", "muzzled", "buzzwig", "abrader", "absence", "abubble", "bruises", "courses", "craters", "stanley", "dislord" }
word_tbl[3] = {"razzmatazz", "whizzbangs", "puzzlingly", "blizzardly", "showbizzes", "zombifying", "jackrabbit", "jeopardize", "johnnycake", "jacklights"}
word_tbl[4] = {"procrastination", "personification", "characteristics", "acknowledgeable", "parthenogenesis", "miniaturization", "procrastinating", "roentgenization", "medicamentation", "misappreciation", "anticoagulation"}
local words = 14
--
local my_words = {}
  for i=1,words do
    my_words[i] = {Word = table.Random(word_tbl[diff]), Letters = math.random(2,15)}
  end
screen.Word = table.Random(my_words).Word
--
local lw = screen:GetWide()*.5
local lh = screen:GetTall()*.65
local list1,tall = CreateList(screen,my_words,words,(lw/2),lh, self)
local cw = lw*.2
local ly = screen:GetTall()*.28
local l1x = screen:GetWide()*.05 + cw
local single_h = list1:GetTall()/12
list1:SetPos(l1x,ly)
--
local list2,tall = CreateList(screen,my_words,words,(lw/2),lh,self)
local l2x = l1x + list1:GetWide() + (cw + lw*.05)
list2:SetPos(l2x,ly)
--
local code1 = vgui.Create("pig_PanelList",screen)
code1:SetSize(cw,list1:GetTall())
code1:SetPos(l1x - code1:GetWide(),ly)
--
local str = {"AFF8","B056","BQ7C","L2G6","B00B","BEA7","LEM2","B6G6"}
--
  for i=1,(code1:GetTall()/single_h) do
    local dlabel = vgui.Create("DLabel")
	dlabel:SetText("0x"..table.Random(str)..":")
	dlabel:SetTextColor(TerminalCol)
	dlabel:SetFont("TerminalFont")
	dlabel:SetSize(code1:GetWide(),single_h)
	code1:AddItem(dlabel)
  end
--
local code2 = vgui.Create("pig_PanelList",screen)
code2:SetSize(cw,list2:GetTall())
code2:SetPos(l2x - code2:GetWide(),ly)
--
  for i=1,(code2:GetTall()/single_h) do
    local dlabel = vgui.Create("DLabel")
	dlabel:SetText("0x"..table.Random(str)..":")
	dlabel:SetTextColor(TerminalCol)
	dlabel:SetFont("TerminalFont")
	dlabel:SetSize(code2:GetWide(),single_h)
	code2:AddItem(dlabel)
  end
---------------------
local attemplabel = vgui.Create("DLabel",screen)
screen.AttemptLabel = attemplabel
attemplabel:SetText("")
attemplabel:SetFont("TerminalFontSmall")
attemplabel:SetTextColor(TerminalCol)
local cx = list2:GetPos()
attemplabel:SetPos(cx + list2:GetWide()*1.1,0)
  attemplabel.Think = function(me)
    me:SizeToContents()
	local mx = me:GetPos()
	me:SetPos(mx,screen:GetTall()*.85-me:GetTall())
  end
  
local writelabel = vgui.Create("DLabel",screen)
screen.WriteLabel = writelabel
writelabel:SetText("")
writelabel:SetFont("TerminalFontSmall")
writelabel:SetTextColor(TerminalCol)
local cx = list2:GetPos()
writelabel:SetPos(cx + list2:GetWide()*1.1,0)
writelabel.TitleTime = CurTime()
  writelabel.Think = function(me)
    me:SizeToContents()
	local mx = me:GetPos()
	me:SetPos(mx,screen:GetTall()*.91-me:GetTall())
	--
	local htext = screen.SelText
	if htext == nil then return end
	htext = htext:upper()
    if CurTime() > me.TitleTime then
	  me.Texts = me.Texts or ""
	  if #me.Texts < #htext then
		me.Texts = self:MakeText(me.Texts,htext,me)
		me:SetText(me.Texts)
	  end
	end
  end

end

function ENT:WriteDisc()
local htext = "ERROR 1x01(201B) <:NO HOLOTAPE DATA DETECTED:>"
  if self.HoloText and self.HoloText != "" then
    htext = self.HoloText
  end
local screen = pig.vgui.Terminal.Screen
screen.List:SetVisible(false)
--
screen.Text = vgui.Create("DLabel",screen)
local text = screen.Text
text:SetFont("TerminalFont")
text:SetText(htext)
text:SetTextColor(TerminalCol)
text.MaxWide = screen:GetWide()-screen.Offset*1.5
text:SetSize(text.MaxWide,screen:GetTall()*.5)
text:SetAutoStretchVertical(true)
text:SetWrap(true)
text:SetPos(screen.Offset,screen:GetTall()*.35)

screen.TextEntry = vgui.Create("DTextEntry",screen)
local textentry = screen.TextEntry
textentry:SetSize(screen:GetWide()-screen.Offset*1.5,screen:GetTall()*.5)
textentry:SetPos(screen.Offset,screen:GetTall()*.35)
textentry:SetFont("TerminalFont")
textentry:SetText(htext)
textentry:SetDrawBorder(true)
textentry:SetEnterAllowed( true ) 
textentry:SetMultiline(true)
textentry:RequestFocus()
  textentry.OnLoseFocus = function(me)
    me:RequestFocus()
  end
  textentry.Paint = function() return end
  textentry.OldChange = textentry.OnTextChanged
  textentry.OnTextChanged = function(me)
    if me:GetValue():len() > TerminalMaxChar then 
	  me:SetValue(me.OldText)
	else
	  me.OldText = me:GetValue()
	  me.OldChange(me)  
	end
  end
  textentry.OnChange = function(me)
    surface.PlaySound("ui/char"..math.random(1,5)..".wav")
	text:SetText(me:GetValue())
  end
  
local base = self:MakeButton(screen,"Back")
base:SetSize(screen:GetWide()*.1,screen:GetTall()*.075)
base:SetPos(screen.Offset,screen:GetTall()*.835)
  base.DoClick = function(me)
    if IsValid(screen.Accept) then
      screen.Accept:Remove()
	end
    screen.List:SetVisible(true)
	textentry:Remove()
	text:Remove()
	me:Remove()
  end
  
  if self:GetNWBool("Holodisk",false) != true then
    text:SetText("NO HOLOTAPE INSERTED")
	textentry:Remove()
    return
  end

local accept = self:MakeButton(screen,"Accept")
screen.Accept = accept
accept:SetSize(screen:GetWide()*.125,screen:GetTall()*.075)
accept:SetPos(screen:GetWide()*.91 - accept:GetWide(),screen:GetTall()*.835)
  accept.DoClick = function(me)
    if text:GetText():len() <= 1 then return end
  --
    net.Start("F_Text")
	net.WriteEntity(self)
	net.WriteString(text:GetText())
	net.SendToServer()
	self.HoloText = text:GetText()
	------------------
    screen.List:SetVisible(true)
	text:Remove()
	base:Remove()
	textentry:Remove()
	me:Remove()
  end  
  
end

function ENT:ReadDisc()
local screen = pig.vgui.Terminal.Screen
screen.List:SetVisible(false)
--
local htext = "ERROR 1x01(201B) <:NO HOLOTAPE DATA DETECTED:>"
  if self.HoloText and self.HoloText != "" then
    htext = self.HoloText
  end
--
screen.Text = vgui.Create("DLabel",screen)
local text = screen.Text
text:SetFont("TerminalFont")
text:SetTextColor(TerminalCol)
text.MaxWide = screen:GetWide()-screen.Offset*1.5
text:SetSize(text.MaxWide,screen:GetTall()*.5)
text:SetAutoStretchVertical(true)
text:SetWrap(true)
text:SetPos(screen.Offset,screen:GetTall()*.35)
text.TitleTime = CurTime()
text.OldThink = text.Think
--
  text.Think = function(me)
    me.OldThink(me)
    if CurTime() > me.TitleTime then
	  me.Texts = me.Texts or ""
	  if #me.Texts < #htext then
		me.Texts = self:MakeText(me.Texts,htext,me)
		me:SetText(me.Texts)
	  end
	end
  end
  
local base = self:MakeButton(screen,"Back")
base:SetSize(screen:GetWide()*.1,screen:GetTall()*.075)
base:SetPos(screen.Offset,screen:GetTall()*.835)
  base.DoClick = function(me)
    screen.List:SetVisible(true)
	text:Remove()
	me:Remove()
  end
 
end

function ENT:EjectDisc()
if self:GetNWBool("Holodisk",false) != true then return end
self.HoloText = nil
net.Start("F_Eject")
net.WriteEntity(self)
net.SendToServer()
end

function ENT:MakeButton(parent,text)
local base = pig.CreateButton(parent,"> "..text.."","TerminalFont")
base:SetText("")
  base.Paint = function(me)
    if me.ins then
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(TerminalCol.r*.5,TerminalCol.g*.5,TerminalCol.b*.5,150))
	  draw.SimpleText("> "..text,"TerminalFont",me:GetWide()*.01,me:GetTall()/2,Color(0,0,0),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
    else
	  draw.SimpleText("> "..text,"TerminalFont",me:GetWide()*.01,me:GetTall()/2,TerminalCol,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
  end
base.Color = TerminalCol
return base
end

function ENT:MakeText(selected,endtext,me)
selected = selected..""..string.sub(endtext,#selected+1,#selected+1)
me.TitleTime = me.TitleTime+TerminalTime
me.NextSound = me.NextSound or CurTime()-1
  if me.NextSound < CurTime() then
    surface.PlaySound("ui/t_scroll.mp3")
    me.NextSound = CurTime()+0.55
  end
return selected
end

function ENT:MakeTerminal()
  if IsValid(pig.vgui.Terminal) then
    pig.vgui.Terminal:Remove()
  end
pig.vgui.Terminal = vgui.Create("DFrame")
local terminal = pig.vgui.Terminal
terminal:SetSize(ScrW(),ScrH())
terminal:SetDraggable(false)
terminal:ShowCloseButton(false)
terminal:SetTitle("")
terminal:MakePopup()
terminal.Paint = function() return end
  terminal.PaintOver = function(me)
    surface.SetDrawColor(255,255,255)
	surface.SetMaterial(Material("ui/terminal.png"))
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
  end

local close = vgui.Create("DButton", terminal)
close:SetText("")
close.Paint = function() return end
  close.DoClick = function(me)
    terminal:Remove()
  end
local ch = ScrH()*.07
close:SetSize(ch, ch)
close:SetPos(terminal:GetWide()*.64, terminal:GetTall()*.95 - ch)
--
local title1 = "ROBCO INDUSTRIES UNIFIED OPERATING SYSTEM"
local title2 = "COPYRIGHT 2075-2077 ROBCO INDUSTRIES"
local title3 = "-Server "..self:EntIndex().."-"
local title4 = self.TerminalName or "Welcome User"
--
terminal.Screen = vgui.Create("DFrame",terminal)
local screen = terminal.Screen
screen:SetDraggable(false)
screen:ShowCloseButton(false)
screen:SetTitle("")
screen:SetSize(terminal:GetWide()*.571,terminal:GetTall()*.715)
screen.Offset = screen:GetWide()*.075
screen:SetPos(0,terminal:GetTall()*.095)
screen:CenterHorizontal()
screen.TitleTime = CurTime()
screen.Line = "________________"
  screen.Think = function(me)
    if CurTime() > me.TitleTime then
	me.Title1 = (me.Title1 or "")
	me.Title2 = (me.Title2 or "")
	me.Title3 = (me.Title3 or "")
	me.Title4 = (me.Title4 or "")
	  if #me.Title1 < #title1 then
		me.Title1 = self:MakeText(me.Title1,title1,me)
	  elseif #me.Title2 <#title2 then
	    me.Title2 = self:MakeText(me.Title2,title2,me)
	  elseif #me.Title3 <#title3 then
	    me.Title3 = self:MakeText(me.Title3,title3,me)
	  elseif #me.Title4 <#title4 then
	    me.Title4 = self:MakeText(me.Title4,title4,me)		
	  end
	end
  end
  screen.Paint = function(me)
    Derma_DrawBackgroundBlur(me,SysTime()-0.6)
    surface.SetDrawColor(255,255,255)
	surface.SetMaterial(Material("ui/terminal_screen2.png"))
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
	PipBoy3000.Scan(me,TerminalCol)
    -------------------
    draw.DrawText(me.Title1 or "","TerminalFont",me:GetWide()/2,me:GetTall()*.075,TerminalCol,TEXT_ALIGN_CENTER)
    draw.DrawText(me.Title2 or "","TerminalFont",me:GetWide()/2,me:GetTall()*.125,TerminalCol,TEXT_ALIGN_CENTER)
    draw.DrawText(me.Title3 or "","TerminalFont",me:GetWide()/2,me:GetTall()*.175,TerminalCol,TEXT_ALIGN_CENTER)
    draw.DrawText(me.Title4 or "","TerminalFont",me.Offset,me:GetTall()*.225,TerminalCol,TEXT_ALIGN_LEFT)
    draw.DrawText(me.Line or "","TerminalFont",me.Offset,me:GetTall()*.275,TerminalCol,TEXT_ALIGN_LEFT)
    draw.DrawText(">","TerminalFont",me.Offset,me:GetTall()*.85,TerminalCol,TEXT_ALIGN_LEFT)
  end

return terminal,screen
end

function ENT:TerminalScreen()
local terminal,screen = self:MakeTerminal()
local tbuts = {}
tbuts[1] = {
  Text = "Write Holo-Tape",
  Func = self.WriteDisc
}
tbuts[2] = {
  Text = "Read Holo-Tape",
  Func = self.ReadDisc
}
tbuts[3] = {
  Text = "Eject Holo-Tape",
  Func = self.EjectDisc
}
tbuts[4] = {
  Text = "Change Password",
  Func = self.ChangePass
}
--
  if self.Funcs then
    local count = table.Count(tbuts)
    for k,v in pairs(self.Funcs) do
	  count = count+1
	  tbuts[count] = {
	    Text = k,
	    Func = function()
		  self.NextUse = self.NextUse or CurTime()-1
		  if self.NextUse > CurTime() then return end
		  self.NextUse = CurTime() + 1
		  --
		  surface.PlaySound("ui/ui_hacking_good.mp3")
		  net.Start("F_TFunc")
		  net.WriteEntity(self)
		  net.WriteString(k)
		  net.SendToServer()
		end
	  }
	end
  end
--
  if !self.HackedSystem and self:GetPassword() then
    tbuts = {}
	tbuts[1] = {
	  Text = "Input Password",
	  Func = self.EnterPass
	}
	tbuts[2] = {
	  Text = "Hack System",
	  Func = function()
	    local seclevel = self:GetNWInt("SecLevel", 0)
	    if LocalPlayer():GetAttributeValue("Science") < seclevel then
		  pig.Notify(Schema.RedColor, "You require a Science level of "..seclevel.." to hack this Terminal")
		  return
		end
	    self:Hack()
	  end
	}
	if self:GetAttempts() <= 0 then
      self:Hack()
    return end
  end
--
  local list = vgui.Create("pig_PanelList",screen)
  screen.List = list
  list:SetSize(screen:GetWide() *.55,screen:GetTall()*.55)
  list:SetPos(screen.Offset,screen:GetTall()*.35)
    for k,v in pairs(tbuts) do
	  local base = self:MakeButton(nil,v.Text)
	  base:SetSize(list:GetWide(),screen:GetTall()*.075)
	  base.DoClick = function()
	    if v.Func then
		  v.Func(self)
		end
	  end
	  list:AddItem(base)
	end
  
end

function ENT:EnterPass()
local screen = pig.vgui.Terminal.Screen
local oldtitle = (screen.Title4 or "")..""
screen.Attempts = self:GetAttempts()
screen.List:SetVisible(false)
--
  if screen.Attempts <= 0 then
    self:Hack()
  return end
--
screen.Title4 = "Enter Current Password ("..screen.Attempts.." ATTEMPTS)"

screen.Text = vgui.Create("DLabel",screen)
local text = screen.Text
text:SetFont("TerminalFont")
text:SetText("")
text:SetTextColor(TerminalCol)
text.MaxWide = screen:GetWide()-screen.Offset*1.5
text:SetSize(text.MaxWide,screen:GetTall()*.5)
text:SetAutoStretchVertical(true)
text:SetWrap(true)
text:SetPos(screen.Offset,screen:GetTall()*.35)

screen.TextEntry = vgui.Create("DTextEntry",screen)
local textentry = screen.TextEntry
textentry:SetSize(screen:GetWide()-screen.Offset*1.5,screen:GetTall()*.5)
textentry:SetPos(screen.Offset,screen:GetTall()*.35)
textentry:SetFont("TerminalFont")
textentry:SetText("")
textentry:SetDrawBorder(true)
textentry:SetEnterAllowed( true ) 
textentry:SetMultiline(true)
textentry:RequestFocus()
  textentry.OnLoseFocus = function(me)
    me:RequestFocus()
  end
  textentry.Paint = function() return end
  textentry.OldChange = textentry.OnTextChanged
  textentry.OnTextChanged = function(me)
    if me:GetValue():len() > TerminalMaxChar then 
	  me:SetValue(me.OldText)
	else
	  me.OldText = me:GetValue()
	  me.OldChange(me)  
	end
  end
  textentry.OnChange = function(me)
    surface.PlaySound("ui/char"..math.random(1,5)..".wav")
	text:SetText(me:GetValue())
  end

--
local base = self:MakeButton(screen,"Back")
base:SetSize(screen:GetWide()*.1,screen:GetTall()*.075)
base:SetPos(screen.Offset,screen:GetTall()*.835)
  base.DoClick = function(me)
    screen.List:SetVisible(true)
	text:Remove()
	textentry:Remove()
	screen.Title4 = oldtitle
	screen.Accept:Remove()
	me:Remove()
  end
  
local accept = self:MakeButton(screen,"Accept")
screen.Accept = accept
accept:SetSize(screen:GetWide()*.125,screen:GetTall()*.075)
accept:SetPos(screen:GetWide()*.91 - accept:GetWide(),screen:GetTall()*.835)
  accept.DoClick = function(me)
    local txt = text:GetText()
    --
    local pass = self:GetPassword()
	if txt != pass then
	  surface.PlaySound("ui/ui_hacking_bad.mp3")
	  screen.Attempts = screen.Attempts - 1
	  self.Attempts = screen.Attempts
	  screen.Title4 = "Enter Current Password ("..screen.Attempts.." ATTEMPTS)"
	  --
	  if self.Attempts <= 0 then
	    text:Remove()
		textentry:Remove()
		me:Remove()
		self:Hack()
	  end
	return end
	--
	surface.PlaySound("ui/ui_hacking_good.mp3")
	base:DoClick()
	self.HackedSystem = true
	self:TerminalScreen()
	me:Remove()
  end  
  
end

function ENT:ChangePass()
local screen = pig.vgui.Terminal.Screen
local oldtitle = (screen.Title4 or "")..""
screen.List:SetVisible(false)
--
  if !self:GetPassword() then
    self:NewPass("", oldtitle)
	return
  end
--
screen.Title4 = "Enter Current Password"

screen.Text = vgui.Create("DLabel",screen)
local text = screen.Text
text:SetFont("TerminalFont")
text:SetText("")
text:SetTextColor(TerminalCol)
text.MaxWide = screen:GetWide()-screen.Offset*1.5
text:SetSize(text.MaxWide,screen:GetTall()*.5)
text:SetAutoStretchVertical(true)
text:SetWrap(true)
text:SetPos(screen.Offset,screen:GetTall()*.35)

screen.TextEntry = vgui.Create("DTextEntry",screen)
local textentry = screen.TextEntry
textentry:SetSize(screen:GetWide()-screen.Offset*1.5,screen:GetTall()*.5)
textentry:SetPos(screen.Offset,screen:GetTall()*.35)
textentry:SetFont("TerminalFont")
textentry:SetText("")
textentry:SetDrawBorder(true)
textentry:SetEnterAllowed( true ) 
textentry:SetMultiline(true)
textentry:RequestFocus()
  textentry.OnLoseFocus = function(me)
    me:RequestFocus()
  end
  textentry.Paint = function() return end
  textentry.OldChange = textentry.OnTextChanged
  textentry.OnTextChanged = function(me)
    if me:GetValue():len() > TerminalMaxChar then 
	  me:SetValue(me.OldText)
	else
	  me.OldText = me:GetValue()
	  me.OldChange(me)  
	end
  end
  textentry.OnChange = function(me)
    surface.PlaySound("ui/char"..math.random(1,5)..".wav")
	text:SetText(me:GetValue())
  end

--
local base = self:MakeButton(screen,"Back")
base:SetSize(screen:GetWide()*.1,screen:GetTall()*.075)
base:SetPos(screen.Offset,screen:GetTall()*.835)
  base.DoClick = function(me)
    screen.List:SetVisible(true)
	text:Remove()
	textentry:Remove()
	screen.Title4 = oldtitle
	screen.Accept:Remove()
	me:Remove()
  end
  
local accept = self:MakeButton(screen,"Accept")
screen.Accept = accept
accept:SetSize(screen:GetWide()*.125,screen:GetTall()*.075)
accept:SetPos(screen:GetWide()*.91 - accept:GetWide(),screen:GetTall()*.835)
  accept.DoClick = function(me)
    local txt = text:GetText()
    --
    local pass = self:GetPassword()
	if txt != pass then
	  surface.PlaySound("ui/ui_hacking_bad.mp3")
	return end
	--
	base:DoClick()
	self:NewPass(txt, oldtitle)
	me:Remove()
  end  
  
end

function ENT:NewPass(pass, oldtitle)
local screen = pig.vgui.Terminal.Screen
screen.List:SetVisible(false)
--
screen.Title4 = "(2) Enter New Password"

screen.Text = vgui.Create("DLabel",screen)
local text = screen.Text
text:SetFont("TerminalFont")
text:SetText("")
text:SetTextColor(TerminalCol)
text.MaxWide = screen:GetWide()-screen.Offset*1.5
text:SetSize(text.MaxWide,screen:GetTall()*.5)
text:SetAutoStretchVertical(true)
text:SetWrap(true)
text:SetPos(screen.Offset,screen:GetTall()*.35)

screen.TextEntry = vgui.Create("DTextEntry",screen)
local textentry = screen.TextEntry
textentry:SetSize(screen:GetWide()-screen.Offset*1.5,screen:GetTall()*.5)
textentry:SetPos(screen.Offset,screen:GetTall()*.35)
textentry:SetFont("TerminalFont")
textentry:SetText("")
textentry:SetDrawBorder(true)
textentry:SetEnterAllowed( true ) 
textentry:SetMultiline(true)
textentry:RequestFocus()
  textentry.OnLoseFocus = function(me)
    me:RequestFocus()
  end
  textentry.Paint = function() return end
  textentry.OldChange = textentry.OnTextChanged
  textentry.OnTextChanged = function(me)
    if me:GetValue():len() > TerminalMaxChar then 
	  me:SetValue(me.OldText)
	else
	  me.OldText = me:GetValue()
	  me.OldChange(me)  
	end
  end
  textentry.OnChange = function(me)
    surface.PlaySound("ui/char"..math.random(1,5)..".wav")
	text:SetText(me:GetValue())
  end

--
local base = self:MakeButton(screen,"Cancel")
base:SetSize(screen:GetWide()*.1,screen:GetTall()*.075)
base:SetPos(screen.Offset,screen:GetTall()*.835)
  base.DoClick = function(me)
    screen.List:SetVisible(true)
	text:Remove()
	textentry:Remove()
	screen.Title4 = oldtitle
	screen.Accept:Remove()
	me:Remove()
  end
  
local accept = self:MakeButton(screen,"Accept")
screen.Accept = accept
accept:SetSize(screen:GetWide()*.125,screen:GetTall()*.075)
accept:SetPos(screen:GetWide()*.91 - accept:GetWide(),screen:GetTall()*.835)
  accept.DoClick = function(me)
    local txt = text:GetText()
    --
	net.Start("F_TPass")
	net.WriteEntity(self)
	net.WriteString(pass)
	net.WriteString(txt or "")
	net.SendToServer()
	--
	base:DoClick()
	me:Remove()
	surface.PlaySound("ui/ui_hacking_good.mp3")
  end  
  
end

--
net.Receive("F_TAcc", function()
local ent = net.ReadEntity()
ent.HackedSystem = false
ent.Attempts = 4
end)

net.Receive("F_Terminal",function()
local ent = net.ReadEntity()
local holotext = net.ReadString()
local f_tbl = net.ReadTable()
  if table.Count(f_tbl) > 0 then
    ent.Funcs = f_tbl
  end
  if holotext != "" then
    ent.HoloText = holotext
  end
  ent:TerminalScreen()
end)
