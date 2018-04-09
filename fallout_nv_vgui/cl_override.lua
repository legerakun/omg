local FVGUI = {}
FVGUI.Order = 0
FVGUI.SpamText = {"You must wait","You do not have enough space!","Crippled arms reduces"}
FVGUI.Mat = Material("pw_fallout/main.png")
FVGUI.Scroll = Material("hud/scrollbar/vert_marker.vtf")
FVGUI.Up = Material("hud/scrollbar/arrow_up.vtf")
FVGUI.Dwn = Material("hud/scrollbar/arrow_down.vtf")
FVGUI.Border = Material("pw_fallout/border.png")
FVGUI.Wheel = Material("pw_fallout/wheel.png")
FVGUI.Ball = Material("pw_fallout/load_roulette_ball.png")
FVGUI.Bars = Material("pw_fallout/bars.png")
FVGUI.XPBar = Material("hud/xpbar_frame.png")

local function Cl_Notify(color,text,time,image)
  if image == "" then
  local red = Schema.RedColor
    if color.r == red.r and color.g == red.g and color.b == red.b then
	  image = "pw_fallout/v_sad.png"
	else
      image = nil
    end	
  end
image = image or "pw_fallout/v_normal.png"
-----------------
local tab = {}
tab["pw_fallout/v_normal.png"] = "ui/notify.mp3"
tab["pw_fallout/v_bcap.png"] = "ui/ui_items_bottlecaps_down_02.wav"
  if text:find("You got") then
    image = "pw_fallout/v_gift.png"
	local str = string.Explode(" ",text)
	local class = ""
	local maxstr = #str
	  for i=4,maxstr do
	    if i == maxstr then
		  class = class..""..str[i]..""
		else
		  class = class..""..str[i].." "
		end
	  end
	text = str[1].." "..str[2].." "..str[3].." "..class
	surface.PlaySound(Fallout_PickupSound(class))
  elseif text:find("picked") and text:find(Schema.Currency) or text:find("given") and text:find(Schema.Currency) then
    surface.PlaySound("ui/ui_items_bottlecaps_up_0"..math.random(1,4)..".wav")  
  end
--
  if tab[image] then
    surface.PlaySound(tab[image])
  end
-----------------
  if IsValid(pig.vgui.NotifyBox) then
    pig.vgui.NotifyBox:Remove()
  end
pig.vgui.NotifyBox = vgui.Create("DPanel")
local notify = pig.vgui.NotifyBox
  timer.Create("F_Clear",time,1,function()
    if IsValid(notify) then notify:Remove() end
  end)
notify:SetSize(ScrW() *.195, ScrH() *.125)
notify:SetPos(ScrW() *.035,ScrH() *.05)
notify.Paint = function(me)
  surface.SetDrawColor(color)
  surface.SetMaterial(FVGUI.Border)
  surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
end

notify.Pic = vgui.Create("DPanel",notify)
local pic = notify.Pic
local px,py = pic:GetPos()
pic:SetSize(notify:GetWide() *.185,notify:GetTall() *.65)
pic:SetPos(notify:GetWide() *.05,notify:GetTall() *.1)
pic.Paint = function(me)
surface.SetDrawColor(color)
surface.SetMaterial(Material(image))
surface.DrawTexturedRect( 0,0,me:GetWide(),me:GetTall() )
end

notify.TextPanel = vgui.Create("DPanel",notify)
local textPanel = notify.TextPanel
local space = notify:GetWide()*.075
textPanel:SetSize(notify:GetWide() - pic:GetWide() - space,notify:GetTall() *.825)
textPanel:SetPos(px + pic:GetWide() + space,0)
textPanel:CenterVertical()
textPanel.Paint = function() return end
textPanel.Text = vgui.Create("DLabel",textPanel)
local texts = textPanel.Text
texts:Remove()
text1,text2 = Fallout_DLabel(textPanel,0,textPanel:GetTall() *.025,text,"FO3FontSmall",color)
text1:SetWide(textPanel:GetWide())
text2:SetWide(textPanel:GetWide())

end

local function Cl_Notify_Timer(time)
  timer.Create("F_Notify",time,1,function()
    FVGUI.SelectedOrder = FVGUI.SelectedOrder or 0
    FVGUI.SelectedOrder = FVGUI.SelectedOrder + 1
    local order = FVGUI.SelectedOrder
	local tbl = FVGUI.NotifyTbl[order]
    Cl_Notify(tbl.Col,tbl.Text,tbl.Time,tbl.Img)
	FVGUI.NotifyTbl[order] = nil
	--
	local next = order + 1
	local nexttbl = FVGUI.NotifyTbl[next]
	  if nexttbl then
	    Cl_Notify_Timer(tbl.Time)
	  else
	    FVGUI.Order = 0
		FVGUI.SelectedOrder = 0
	  end
  end)
end

function Fallout_PickupSound(index)
local generic = {"ui/ui_items_generic_up_01.mp3","ui/ui_items_generic_up_02.mp3","ui/ui_items_generic_up_03.mp3","ui/ui_items_generic_up_04.mp3"}
local class = index
local ar_sounds = {"ui/ui_items_gunsbig_up.mp3"}
local gr_sounds = {"ui/ui_items_grenade_up.mp3"}
local mel_sounds = {"ui/ui_items_melee_up.mp3"}
local gs_sounds = {"ui/ui_items_gunssmall_up.mp3"}
--
local weps = {}
--
local tab = {}
tab["Casino Chips"] = {"ui/ui_items_bottlecaps_up_01.wav", "ui/ui_items_bottlecaps_up_02.wav", "ui/ui_items_bottlecaps_up_03.wav", "ui/ui_items_bottlecaps_up_04.wav"}
--
print(tab[index])
print(index)
  if weps[index] then
	  if class:find("bg") then
	    return table.Random(ar_sounds)
	  elseif class:find("gr") then
	    return table.Random(gr_sounds)
	  elseif class:find("_m_") then
	    return table.Random(mel_sounds)
	  else
	    return table.Random(gs_sounds)
	  end
  elseif class == "fallout_c_base" then
	return "ui/app_on.wav"
  elseif tab[index] then
	return table.Random(tab[index])
  else
	return table.Random(generic)
  end
end

function Schema.Hooks:pig_Cl_Notify(color,text,time,image)
  if FVGUI.LastText then 
    for k,v in pairs(FVGUI.SpamText) do
	  if FVGUI.LastText:lower():find(v:lower()) then
	    return true
	  end
	end
  end
  timer.Create("F_ResetLastText",7,1,function()
    FVGUI.LastText = nil
  end)
FVGUI.LastText = text
time = time or 6
FVGUI.NotifyTbl = FVGUI.NotifyTbl or {}
--
  if !IsValid(pig.vgui.NotifyBox) and FVGUI.Order < 1 then
    Cl_Notify(color,text,time,image)
  else
    local order = FVGUI.Order + 1
	FVGUI.Order = order
	FVGUI.NotifyTbl[order] = {
      Col = color,
      Text = text,
      Img = image,
	  Time = time
    }
    if !timer.Exists("F_Notify") then
	  local timeleft = timer.TimeLeft("F_Clear") or 0
      Cl_Notify_Timer(timeleft)
	end	
  end
return true
end

function Schema.Hooks:pig_CreatedButton(button)
local col = button.Color or Schema.GameColor
button:SetTextColor(col)
button.Paint = function(me)
if !me.ins and !me.glow then return end
col = me.Color or Schema.GameColor
surface.SetDrawColor(col)
surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
end
button.OnCursorEntered = function(self)
self.ins = true
if LocalPlayer().ButtonSound != nil then LocalPlayer().ButtonSound:Stop() end
LocalPlayer().ButtonSound = CreateSound(LocalPlayer(),"ui/focus.mp3")
local sound = LocalPlayer().ButtonSound
sound:ChangeVolume(1)
sound:Play()
end
button.OnCursorExited = function(self)
self.ins = false
end
-------------
end

function Schema.Hooks:pig_LoadScreen_Open(panel)
-----------------------------
--PLAY THEME
-----------------------------
local menu_theme = CreateSound( LocalPlayer(), "nv_ambiant/main.mp3")
menu_theme:Play()
menu_theme:ChangeVolume(1)
----
panel.Background = vgui.Create("DPanel")
local back = panel.Background
back:SetSize(ScrW(),ScrH())
  back.Think = function(me)
    if !IsValid(panel) then 
	  me:Remove() 
	  menu_theme:Stop()
	end
  end
  back.Paint = function(me)
    surface.SetDrawColor(255,255,255)
	surface.SetMaterial(FVGUI.Mat)
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
	--
	Fallout_DrawText(me:GetWide() *.35, me:GetTall()/2,"PigWorks:", "FO3FontBig", Schema.GameColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	surface.SetFont("FO3FontBig")
	local tw,th = surface.GetTextSize("PW:")
	Fallout_DrawText(me:GetWide() *.35, me:GetTall()/2+(th+me:GetTall()*.015),Schema.Name,"FO3FontTitle", Schema.GameColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	--
  end
------------
  panel:SetPos(ScrW()-panel:GetWide()-ScrW() *.025,0)
  panel.Paint = function(me)
    return
  end
-------------
  local origin = panel:GetTall() *.375
  local spacing = panel:GetTall()*.015
  local new = panel.NewChar
  local load = panel.LoadChar
  local old_paint = nil
  --
  new:SetSize(panel:GetWide()*.85,panel:GetTall()*.045)
  new:SetPos(0,origin)
  old_paint = new.Paint
  new.OldClick = new.DoClick
  new.DoClick = function(me)
    if IsValid(panel.Opened) then panel.Opened:Remove() end
    surface.PlaySound("ui/ok.mp3")
    me.OldClick(me)
  end
  new.Paint = function(me)
    old_paint(me)
	draw.SimpleText("New","FO3Font",me:GetWide()*.825,me:GetTall()/2,Schema.GameColor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
  end
  new:SetText("")
  
  load:SetSize(panel:GetWide()*.85,panel:GetTall()*.045)
  load:SetPos(0,(origin+spacing) + (new:GetTall()*1))
  load.DoClick = function(me)
    if IsValid(panel.Opened) then panel.Opened:Remove() end
	surface.PlaySound("ui/ok.mp3")
	if IsValid(me.chars) then
	  me.chars:Remove()
	end
	me.chars = vgui.Create("DPanel")
	local chars = me.chars
	chars:SetSize(ScrW()*.425, ScrH())
	chars:SetPos(ScrW()*.4)
	  chars.Think = function(self)
	    if !IsValid(me) then self:Remove() end
		if input.IsMouseDown(MOUSE_LEFT) then
		  local mx = gui.MouseX()
		  local myx = self:GetPos()
		  if mx < myx or mx > (myx+self:GetWide()) then
		    self:Remove()
		  end
		end
	  end
	  chars.Paint = function(self)
	    FalloutBlur(self,6)
		if self.SelName == nil then return end
		--IMG
		local img_x = self:GetWide()*.05
		local img_y = self:GetTall()*.1
		local img_w = self:GetWide()*.75
		local img_h = self:GetTall()*.28
		local off = self:GetWide()*.065
		
		FalloutBlur(nil,7,img_x, img_y, img_w, img_h)
		if !file.IsDir("pw_newvegas", "DATA") then
		  file.CreateDir("pw_newvegas")
		end
		local name = self.SelName or "Butch DeLoria"
		local img_dir = "../data/pw_newvegas/"..name..".jpg"
		if !file.Exists("pw_newvegas/"..name..".jpg", "DATA") then
		  img_dir = "pw_fallout/default_pic.png"
		end
		
		surface.SetDrawColor(255,255,255,180)
		surface.SetMaterial(Material(img_dir))
		surface.DrawTexturedRect(img_x + (off/2), img_y + (off/2), img_w - off, img_h - off)
		--Info
		surface.SetFont("FO3Font")
		local tw, th = surface.GetTextSize("|")
		local info_x = img_x
		local info_y = img_y + img_h*.9
		--
		local faction = faction[self.SelFac or 1].Name
		local gender = self.SelGender or "Male"
		
		Fallout_DrawText(info_x, info_y + (th*1), name, "FO3Font", Schema.GameColor, TEXT_ALIGN_LEFT)
		Fallout_DrawText(info_x, info_y + (th*2), "Faction: "..faction, "FO3Font", Schema.GameColor, TEXT_ALIGN_LEFT)
		Fallout_DrawText(info_x, info_y + (th*3), "Gender: "..gender, "FO3Font", Schema.GameColor, TEXT_ALIGN_LEFT)		
		Fallout_DrawText(info_x, info_y + (th*4), "Version: ENGLISH", "FO3Font", Schema.GameColor, TEXT_ALIGN_LEFT)		  
	  end
	local clist = vgui.Create("pig_PanelList", chars)
	clist:SetSize(chars:GetWide()*.975, chars:GetTall()*.225)
	clist:SetPos(0, chars:GetTall()*.6)
	local num_display = table.Count(ClientCharacterTable or {})+1
	  for k,v in SortedPairs(ClientCharacterTable or {}, true) do
	    num_display = num_display-1
	    local but = pig.CreateButton(nil,"","PigFont")
		but:SetSize(clist:GetWide(), clist:GetTall()/5)
		but.OldCursorEnter = but.OnCursorEntered
		but.OldCursorExit = but.OnCursorExited
		but.OnCursorEntered = function(self)
          self.OldCursorEnter(self)
		  chars.SelName = self.vars.Name
		  chars.SelFac = self.vars.Faction
		  chars.SelGender = self.vars.Gender
		end
		but.OnCursorExited = function(self)
		  self.OldCursorExit(self)
		  self.SelName = nil
		end
		but.NumDisplay = num_display+0
	    but.vars = {}
	      for a,b in pairs(ClientCharVar) do
	        if b.char_id == v.char_id then
	          if b.var == "true" or b.var == "false" then
			    b.var = tobool(b.var)
			  elseif tonumber(b.var) != nil then 
			    b.var = tonumber(b.var)
	          end
	          but.vars[b.varname] = b.var
	        end
	      end
		  local vars = but.vars
		  but.OldPaint = but.Paint
		  but.Paint = function(self)
		    self.OldPaint(self)
			Fallout_DrawText(self:GetWide()*.015, self:GetTall()/2, "#0"..self.NumDisplay.." ".. (self.vars.Name or "Unknown"), "FO3Font", Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		  end
          but.DoClick = function(self)
		    surface.PlaySound("ui/ok.mp3")
		    local Window = Derma_Query("Are you sure you want to select this character?", "",
			"Confirm", function() 
			  surface.PlaySound("ui/ok.mp3") 
			  pig.SelectCharacter(v.char_id) 
			  panel:Remove()
			end,
			"Cancel", function() surface.PlaySound("ui/ok.mp3") end)
			Window.OldPaint = Window.Paint
			Window.Paint = function(self)
			  Derma_DrawBackgroundBlur(self, self.Time)
			  self.OldPaint(self)
			end
		  end
          but.DoRightClick = function(self)
		    surface.PlaySound("ui/ok.mp3")
		    local Window = Derma_Query("Are you sure you want to delete this character? This cannot be undone!", "",
			"Confirm", function() 
			  surface.PlaySound("ui/ok.mp3") 
			  pig.DeleteCharacter(v.char_id) 
			  self:Remove()
			end,
			"Cancel", function() surface.PlaySound("ui/ok.mp3") end)
			Window.OldPaint = Window.Paint
			Window.Paint = function(self)
			  Derma_DrawBackgroundBlur(self, self.Time)
			  self.OldPaint(self)
			end
		  end		  
		 clist:AddItem(but)
	  end
  end
  load.Paint = function(me)
    old_paint(me)
	draw.SimpleText("Load","FO3Font",me:GetWide()*.825,me:GetTall()/2,Schema.GameColor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
  end
  load:SetText("")
  --
  local count = 2
  local buts = {}
  buts[1] = {
  Text = "Settings",
  Func = function()
    local settings = vgui.Create("pig_Options")
    panel.Opened = settings
	settings:SetPos(ScrW()*.4)
	settings.Think = function(self)
	  if !IsValid(panel) then self:Remove() end
	  if input.IsMouseDown(MOUSE_LEFT) then
	    local mx = gui.MouseX()
	    local myx = self:GetPos()
	    if mx < myx or mx > (myx+self:GetWide()) then
		  self:Remove()
	    end
	  end
	end
  end
  }
  buts[2] = {
  Text = "Credits"
  }
  buts[3] = {
  Text = "Quit",
  Func = function()
    Derma_Query("Are you sure you wish to Disconnect?", "", 
	"Cancel", function() surface.PlaySound("ui/ok.mp3") end,
	"Confirm", function()
	  surface.PlaySound("ui/ok.mp3")
	  RunConsoleCommand("disconnect")
	end)
  end
  }  
  
  for k,v in SortedPairs(buts) do
    local but = pig.CreateButton(panel,"","FO3Font")
	but:SetSize(panel:GetWide()*.85,panel:GetTall()*.045)
	but:SetPos(0,origin + (spacing*count) + (new:GetTall()*count))
	but.Paint = function(me)
	  old_paint(me)
	  draw.SimpleText(v.Text,"FO3Font",me:GetWide()*.825,me:GetTall()/2,Schema.GameColor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER)
	end
	but.DoClick = function()
	  surface.PlaySound("ui/ok.mp3")
	  if IsValid(panel.Opened) then panel.Opened:Remove() end
	  v.Func()
	end
	count = count + 1
  end
end

function Schema.Hooks:pig_DescFont()
return "FO3FontHUD"
end

function Schema.Hooks:pig_DrawDesc(desc,pos,text_w,text_h,ent)
local stealth = ent:GetNWBool("Stealthing",false)
if (stealth == true) then return false end
local mew = text_w*1.2
local meh = text_h*1.5
pos.y = pos.y - meh
local pos_y = pos.y-(text_h) - (meh*.15)
FalloutBlur(nil,6,pos.x-(mew/2),pos_y,mew,meh)
Fallout_DrawFullText(pos.x-(text_w/2),pos.y-text_h,desc,"FO3FontHUD",Schema.GameColor,nil)
SetFHUDOffset(pos_y)
return false
end

function Schema.Hooks:pig_PanelList_Open(panel)
  panel.VBar.Paint = function(me)
    return
  end
  panel.VBar.btnGrip.Paint = function(me)
    local col = panel.PaintCol or Schema.GameColor
    surface.SetDrawColor(col)
    surface.SetMaterial(FVGUI.Scroll)
    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
  end
  panel.VBar.btnUp.Paint = function(me)
    local col = panel.PaintCol or Schema.GameColor
    surface.SetDrawColor(col)
    surface.SetMaterial(FVGUI.Up)
    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall()*.65)    
  end
  panel.VBar.btnDown.Paint = function(me)
    local col = panel.PaintCol or Schema.GameColor
    surface.SetDrawColor(col)
    surface.SetMaterial(FVGUI.Dwn)
    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall()*.65)      
  end
  panel.OldLayout = panel.PerformLayout
  panel.PerformLayout = function(self)
    self.OldLayout(self)
	local Wide = self:GetWide()
	local YPos = 0
	local XPos = 0
	local vwide = 16
	if self.DisableOverride then
	  vwide = 13
	end
	if ( self.VBar ) then
		self.VBar:SetPos( 0, 0 )
		self.VBar:SetSize( vwide, self:GetTall() )
		self.VBar:SetUp( self:GetTall(), self.pnlCanvas:GetTall() ) -- Disables scrollbar if nothing to scroll
		YPos = self.VBar:GetOffset()
		if ( self.VBar.Enabled ) then Wide = Wide - vwide XPos = vwide end
	end
	self.pnlCanvas:SetWide( Wide )
	self.pnlCanvas:SetPos( XPos, YPos )
	self:Rebuild()
  end
end

function Schema.Hooks:OnLimbCrippled(ply,limb)
  if IsValid(pig.vgui.Limb) then
    pig.vgui.Limb:Remove()
  end
pig.vgui.Limb = vgui.Create("DPanel")
local base = pig.vgui.Limb
local spacing = ScrW()*.05
base:SetSize(ScrW()*.16,ScrH()*.3)
base:SetPos(ScrW()-base:GetWide()-spacing,ScrH()*.075)
  timer.Simple(6,function()
    if !IsValid(base) then return end
	base:Remove()
  end)
local crippled = {}
local tbl = {}
tbl["Head"] = {x = .35,y=.025}
tbl["Upper Body"] = {x=.375,y=.375}
tbl["Left Arm"] = {x=.035,y=.2}
tbl["Right Arm"] = {x=.75,y=.2}
tbl["Left Leg"] = {x=.025,y=.75}
tbl["Right Leg"] = {x=.775,y=.75}
local face_tbl = {}
face_tbl[1] = {first = 0,last = 120,dir = "pw_fallout/limbs/dead.png"}
face_tbl[2] = {first = 121,last = 240,dir = "pw_fallout/limbs/pain.png"}
face_tbl[3] = {first = 241,last = 360,dir = "pw_fallout/limbs/scared.png"}
face_tbl[4] = {first = 361,last = 480,dir = "pw_fallout/limbs/sad.png"}
face_tbl[5] = {first = 481,last = 600,dir = "pw_fallout/limbs/happy.png"}
local parts = GetAllLimbs()
  base.Paint = function(self)
  local col = Schema.GameColor
  local total = 0
  --
  for k,v in SortedPairs(parts,false) do
    surface.SetDrawColor(col)
    local str = string.gsub(v," ","_"):lower()
	local lp = LocalPlayer():GetLimb(v)
    total = total + lp
	  if lp <= 0 then
	    crippled[k] = str.."_broken"
		continue
	  end
	surface.SetMaterial(Material("pw_fallout/limbs/"..str..".png"))
	surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
  end
  --
  self.Alpha = self.Alpha or 0
  local alpha = self.Alpha
  local speed = (800*FrameTime())
    if self.Plus then
	  alpha = alpha + speed
	  if alpha >= 255 then
	    self.Plus = false
	  end
	else
	  alpha = alpha - speed
	  if alpha <= 0 then
	    self.Plus = true
	  end	
	end
  self.Alpha = alpha
  local rcol = Schema.RedColor
  for k,v in SortedPairs(crippled) do
    surface.SetDrawColor(Color(rcol.r,rcol.g,rcol.b,alpha))
    surface.SetMaterial(Material("pw_fallout/limbs/"..v..".png"))
    surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
  end
  --
  local face = nil
    for k,v in SortedPairs(face_tbl) do
	  if total >= v.first and total <= v.last then
	    face = v.dir
	  end
	end
    surface.SetDrawColor(col)
  surface.SetMaterial(Material(face))
  surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
  end
end

function Schema.Hooks:pig_Attributes_Open(panel)
panel:SetSize(ScrW()*.7,ScrH()*.85)
panel.Title,blur = Fallout_DLabel(panel,panel:GetWide()*.075,panel:GetTall()*.02,"WELCOME TO NEW VEGAS","FO3FontBig",Schema.GameColor)
panel.Blur = blur
local off = panel:GetWide()*.035
local tall = panel:GetTall()*.085
local spacing = panel:GetWide()*.012
  panel.Paint = function(me)
    Derma_DrawBackgroundBlur(me,SysTime()-0.6)
    FalloutBlur(me,12)
	Fallout_QuarterBoxTitle(off,me:GetTall()*.05,me:GetWide() - (off*2),spacing,tall,me.Title)
	Fallout_QuarterBox(off,me:GetTall()*.95,me:GetWide()-(off*2),tall,"up")
	Fallout_Line(me:GetWide()-off-(3/2),me:GetTall()-tall*2,"down",tall)
	Fallout_Line(me:GetWide()*.475,me:GetTall()-tall*2,"right",me:GetWide()*.49,true)
	draw.SimpleText(me.DownText or "ASSIGN "..(panel.SkillPoints or 0).." "..(panel.Skill or "SKILL POINTS").."", me.DownFont or "FO3FontBig",me:GetWide()*.475, me:GetTall()-(tall*1.8),Schema.GameColor)
  end
--
local closefunc = panel.CloseButton.DoClick
panel.CloseButton:Remove()
panel.CloseButton = pig.CreateButton(panel,"Done A)","FO3FontHUD")
local close = panel.CloseButton
close:SizeToContents()
close:SetPos(panel:GetWide()-off-close:GetWide(),panel:GetTall()*.05+6+tall)
close.DoClick = function(me)
  surface.PlaySound("ui/ok.mp3")
  closefunc(me)
end
--
local reset = pig.CreateButton(panel,"Reset R)","FO3FontHUD")
reset:SizeToContents()
local cx,cy = close:GetPos()
reset:SetPos(panel:GetWide()-off-reset:GetWide(),cy+close:GetTall()+(panel:GetTall()*.02))
reset.DoClick = function()
surface.PlaySound("ui/ok.mp3")
  for k,v in pairs(panel.AttributeTable:GetItems()) do
    local points = (v.Val-v.Orig)
    panel.CopyTab[v.Attribute].Point = (v.Orig+0) 
    v.Val = (v.Orig+0)
	panel.SkillPoints = panel.SkillPoints+points
	if IsValid(v.minus) then
	  v.minus:SetVisible(false)
	end
  end
end
panel.Reset = reset
--
panel.AttributeTable:SetSize(panel:GetWide()*.4,panel:GetTall()*.725)
panel.AttributeTable:SetPos(off+1-(13/2),0)
panel.AttributeTable:CenterVertical()
--
local pw = panel:GetWide()*.275
panel.PrevPic:SetSize(pw,pw)
panel.PrevPic:SetPos(panel:GetWide()*.725 - (pw/2),panel:GetTall()*.1)
panel.PrevPic.Paint = function(me)
  surface.SetDrawColor( Schema.GameColor )
  surface.SetMaterial( panel.SelectedImage or Material("pw_fallout/skills/skills_survival.png") )
  surface.DrawTexturedRect( 0, 0, me:GetWide(), me:GetTall() )
end  
--
panel.DescPanel:SetSize(panel:GetWide()*.475,panel:GetTall()*.4)
panel.DescPanel:SetPos(panel:GetWide()*.475,panel:GetTall()*.525)
panel.DescPanel.Paint = function(me)
  Fallout_Line(0,0,"right",me:GetWide(),true)
  Fallout_Line(me:GetWide() - 3,0,"down",me:GetTall()*.15)  
end
--
panel.DescPanel.Text:Remove()
local text1,text2 = Fallout_DLabel(panel.DescPanel,panel.DescPanel:GetWide()*.025,3,"...","FO3FontHUD",Schema.GameColor)
panel.DescPanel.Text = text1
panel.DescPanel.TextBlur = text2
text1:SetWide(panel.DescPanel:GetWide()*.975)
text2:SetWide(panel.DescPanel:GetWide()*.975)
--
  for k,v in pairs(panel.AttributeTable:GetItems()) do
    v:Remove()
  end
--
local copy_tab = table.Copy(LocalPlayer().Attributes)
  for k,v in pairs(copy_tab) do
    if Fallout_IsSpecial(k) then copy_tab[k] = nil end
  end
panel.CopyTab = copy_tab
panel.MakeButt = function(panel,k,v)
  local base = vgui.Create("DButton")
  base:SetSize(panel.AttributeTable:GetWide(),panel.AttributeTable:GetTall()/13)
  base:SetText("")
  base.Orig = (v.Point+0)
  base.Val = (v.Point+0)
  base.OnCursorEntered = function(me)
    surface.PlaySound("ui/focus.mp3")
	me.ins = true
    panel.SelectedImage = Material(pig.Attributes[k].Image, "noclamp smooth")
    local text = pig.Attributes[k].Description
    text1:SetText(text)
	text2:SetText(text)
  end
  base.OnCursorExited = function(me)
    me.ins = false
  end
  base:SetTextColor(Schema.GameColor)
  base.Attribute = k
  base.Paint = function(me)
    if me.ins then
	  local col = Schema.GameColor
	  surface.SetDrawColor(col)
	  surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
	end
    draw.SimpleText(k, "FO3FontHUD", me:GetWide() *.075, me:GetTall()/2, Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    draw.SimpleText(me.Val, "FO3FontHUD", me:GetWide() *.8, me:GetTall()/2, Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  end

  local bw = base:GetTall()*.5
  
  base.plus = vgui.Create("DButton",base)
  base.plus:SetText("")
  base.plus:SetSize(bw*1.3,bw)
  base.plus:SetPos(base:GetWide() *.9,0)
  base.plus:CenterVertical()
  base.plus.OnCursorEntered = function(me)
    me:GetParent().ins = true
	me.ins = true
  end
  base.plus.OnCursorExited = function(me)
    me.ins = false
	me:GetParent().ins = false
  end
  base.plus.DoClick = function(me)
    surface.PlaySound("ui/ui_menu_prevnext.wav")
    if panel.SkillPoints <= 0 or me:GetParent().Orig >= 100 then return end
    panel.SkillPoints = panel.SkillPoints - 1
    me:GetParent().Val = me:GetParent().Val + 1
	  if me:GetParent().Val == me:GetParent().Orig then
	    me:GetParent().minus:SetVisible(false)
	  else
	    me:GetParent().minus:SetVisible(true)	    
	  end
  end
  base.plus.Paint = function(me)
    local mat = "pw_fallout/increase.png"
	  if me.ins then
	    mat = "pw_fallout/increase_over.png"
	  end
    surface.SetDrawColor( Schema.GameColor )
    surface.SetMaterial(Material(mat))
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
  end

  base.minus = vgui.Create("DButton",base)
  base.minus:SetText("")
  base.minus:SetSize(bw*1.3,bw)
  base.minus:SetPos(base:GetWide() *.68,0)
  base.minus:CenterVertical()
  base.minus.OnCursorEntered = function(me)
    me:GetParent().ins = true
	me.ins = true
  end
  base.minus.OnCursorExited = function(me)
    me.ins = false
	me:GetParent().ins = false
  end
  base.minus.DoClick = function(me)
    surface.PlaySound("ui/ui_menu_prevnext.wav")
    if me:GetParent().Val <= me:GetParent().Orig then return end
    panel.SkillPoints = panel.SkillPoints + 1
    me:GetParent().Val = me:GetParent().Val-1
	if me:GetParent().Val <= me:GetParent().Orig then me:SetVisible(false) end
  end
  base.minus.Paint = function(me)
    local mat = "pw_fallout/decrease.png"
	  if me.ins then
	    mat = "pw_fallout/decrease_over.png"
	  end
    surface.SetDrawColor( Schema.GameColor )
    surface.SetMaterial(Material(mat))
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
  end
  base.minus:SetVisible(false)
  return base
end
panel.MakeAttList = function(me,tbl)
    for k,v in SortedPairs(tbl) do
      local base = me.MakeButt(me,k,v)
      panel.AttributeTable:AddItem(base)
    end
  end
panel:MakeAttList(panel.CopyTab)
end


local load_imgs = {}
local loadfiles = file.Find("materials/pw_fallout/loadscreen/*", "GAME")
  for k,v in SortedPairs(loadfiles) do
    load_imgs[k] = Material("pw_fallout/loadscreen/"..v)
  end
function Schema.Hooks:pig_WaitScreenOpen(me)
-----------
--MAIN
local screentime = 3
me.NextScreen = me.NextScreen or CurTime() + screentime
me.Index = me.Index or 1
  if me.NextScreen <= CurTime() then
    me.StartTime = me.StartTime or CurTime()
    local startTime = me.StartTime
    local lifeTime = 1;
    local startVal = 0;
    local endVal = 255;
 
    local value = startVal;
    local fraction = ( CurTime( ) - startTime ) / lifeTime;
    fraction = math.Clamp( fraction, 0, 1 );
    value = Lerp( fraction, startVal, endVal );
	--
	local cur = load_imgs[me.Index]
	local next = me.Index + 1
	  if !load_imgs[next] then
	    next = 1
	  end
	local new = load_imgs[next]
	--
    surface.SetDrawColor(255,255,255)
    surface.SetMaterial(new)
    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
	
	surface.SetDrawColor(Color(255,255,255, 255 - value))
    surface.SetMaterial(cur)
    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
	
	if CurTime() >= (me.StartTime + (lifeTime+0.5)) then
	  me.NextScreen = CurTime() + screentime
	  me.StartTime = nil
	  me.Index = next
	end
  else
    surface.SetDrawColor(255,255,255)
    surface.SetMaterial(load_imgs[me.Index] or Material("pw_fallout/loadscreen/l2.png"))
    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
  end
----------
--
me.Rotation = me.Rotation or 0
local speed = (111*FrameTime())
me.Rotation = me.Rotation + speed
  if me.Rotation > 360 then
    me.Rotation = 0
  end
local rotation = me.Rotation
--
me.LoadText = me.LoadText or "Please wait while "..GAMEMODE.Name.." is loading, it should be complete soon..\nIn the meantime feel free to use the chatbox."
--
  local wheel_w = me:GetWide()*.1
  local wheel_h = wheel_w
  local y = me:GetTall()*.825
  surface.SetDrawColor(Schema.GameColor)
  surface.SetMaterial(FVGUI.Bars)
  surface.DrawTexturedRectRotated(me:GetWide()/2 + (wheel_w*.85),y,wheel_w,wheel_h,0) 
  surface.DrawTexturedRectRotated(me:GetWide()/2 - (wheel_w*.85),y,wheel_w,wheel_h,180)   
  
  surface.SetDrawColor(Schema.GameColor)
  surface.SetMaterial(FVGUI.Wheel)
  surface.DrawTexturedRectRotated(me:GetWide()/2,y,wheel_w,wheel_h,rotation)
  --
  surface.SetDrawColor(Schema.GameColor)
  surface.SetMaterial(FVGUI.Ball)
  surface.DrawTexturedRectRotated(me:GetWide()/2,y,wheel_w,wheel_h,-rotation)  
--
  local w = me:GetWide()*.75
  local h = me:GetTall()*.115
  FalloutBlur(nil,11,me:GetWide()/2-(w/2),me:GetTall()*.04,w,h)
  Fallout_DrawFullText(me:GetWide()/2,me:GetTall()*.065, me.LoadText, "FO3Font",Schema.GameColor,nil,TEXT_ALIGN_CENTER)
----
return true
end

function Schema.Hooks:pig_XPBar_Open(panel)
local w,h,x,y = FalloutHUDSize()
panel:SetSize(w,h)
panel:SetPos(ScrW() - panel:GetWide() - x,y-panel:GetTall() - (h*.1))
--
panel.Pointer:SetPos(0,panel:GetTall()*.35 - panel.Pointer:GetTall())
panel.XPText:Remove()
--
  panel.Paint = function(me)
    surface.SetDrawColor(Schema.GameColor)
	surface.SetMaterial(FVGUI.XPBar)
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
	--
	Fallout_DrawText(me:GetWide()*.1,me:GetTall()*.075,me.Level,"FO3FontBig",Schema.GameColor,TEXT_ALIGN_LEFT)
	Fallout_DrawText(me:GetWide()*.85,me:GetTall()*.075,me.Level+1,"FO3FontBig",Schema.GameColor,TEXT_ALIGN_LEFT)	
	--
	Fallout_DrawText(me:GetWide()*.865,me:GetTall()*.9,"+"..(me.Added or 0),"FO3FontBig",Schema.GameColor,TEXT_ALIGN_RIGHT,TEXT_ALIGN_BOTTOM)
	Fallout_DrawText(me:GetWide()*.875,me:GetTall()*.785,"XP","FO3FontHUD",Schema.GameColor,TEXT_ALIGN_LEFT,TEXT_ALIGN_BOTTOM)	
  end
end

function Schema.Hooks:pig_XPBar_PointerStartPos(panel,percent)
--
  if panel.Added >= LocalPlayer():GetRequiredXP() then
    surface.PlaySound("ui/levelup.mp3")
  end
--
local max = panel:GetWide()*.75
local offset = panel:GetWide() - max
--
local pos = 0 + (offset/2)
pos = math.Clamp(pos+(max*percent),pos,max)
return pos
end

function Schema.Hooks:pig_XPBar_PointerPos(panel,percent)
local max = panel:GetWide()*.75
local offset = panel:GetWide() - max
--
local pos = 0 + (offset/2)
pos = math.Clamp(pos+(max*percent),pos,max)
return pos
end

function Schema.Hooks:pig_Inv_Open(panel)
---
panel.Models = {}
  panel.OnRemove = function(me)
    for k,v in pairs(me.Models) do
	  print("Removing model "..v:GetModel())
	  v:Remove()
	  v = nil
	  me.Models[k] = nil
	end
    if IsValid(me.Emitter) then
      me.Emitter:Finish()
	end
  end
  --
  local model = panel.Model
  local haircol = LocalPlayer():GetHairCol()
  
  model.DrawSmoke = function(self)
	
	local vOffset = self.Entity:GetPos()
	local vNorm = self.Entity:GetAngles():Up()
	
	local emitter = self.Emitter or ParticleEmitter( vOffset )
	if !self.Emitter then
	  self.Emitter = emitter
	end
	
	local Smoke = emitter:Add( "effects/extinguisher", vOffset - Vector(0, 0, 10))
	Smoke:SetVelocity(Vector(0,math.random(-20,20), math.random(0, 40)))
	Smoke:SetDieTime(math.Rand(5, 6))
	Smoke:SetStartAlpha(150)
	Smoke:SetEndAlpha(15)
	Smoke:SetColor(0,0,0)
	Smoke:SetStartSize(math.random(15, 20))
	Smoke:SetEndSize(10)
	Smoke:SetRoll( math.Rand( 0,10  ) )
	Smoke:SetRollDelta(math.Rand( -0.2, 0.2 ))
		
	return emitter
  end

  local emitter = model:DrawSmoke()
  local smoke_delay = .1
  model.Emitter = emitter
  model.Paint = function(self,w,h)
	if ( !IsValid( self.Entity ) ) then return end
	local x, y = self:LocalToScreen( 0, 0 )
	self:LayoutEntity( self.Entity )
	local ang = self.aLookAngle
	if ( !ang ) then
		ang = ( self.vLookatPos - self.vCamPos ):Angle()
	end
	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )
	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
	render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
	render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) )
	for i = 0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
		end
	end
	
	self.LastSEffect = self.LastSEffect or CurTime()-1
	if self.LastSEffect + smoke_delay < CurTime() then
	  self.LastSEffect = CurTime()
	  emitter = self:DrawSmoke()
	end
	emitter:SetPos(self.Entity:GetPos())
	emitter:Draw()
	self:DrawModel()
	local col = nil
	for k,v in pairs(panel.Models) do
	  if v.Hair then
	    col = haircol
	  else
	    col = Color(255,255,255)
	  end
	  render.SetColorModulation( col.r / 255, col.g / 255, col.b / 255 )
	  render.SetBlend( ( self:GetAlpha() / 255 ) * 1 )		
	  if IsValid(v) then
	    v:DrawModel()
	  end
	end
	render.SuppressEngineLighting( false )
	cam.End3D()
	self.LastPaint = RealTime()
  end
---

model:SetAnimated(true)
  model.SortModel = function(me,model)
    if model then
      me:SetModel(model)
	end
	  if LocalPlayer():IsGhoul() then
		local body = me.Entity:FindBodygroupByName("heads")
		me.Entity:SetBodygroup(body,1)
		me.Entity:SetSkin(1)
	  end
	for k,v in pairs(panel.Models) do
	  if tonumber(k) == nil then 
	  	local attachment = me.Entity:LookupAttachment("headgear")
        v:SetParent(me.Entity,attachment)
	  continue end
	  v:SetParent(me.Entity)
	  v:AddEffects(EF_BONEMERGE)
	end
	local idle = me.Entity:LookupSequence("mtidle")
	me.Entity:SetSequence(idle)  
  end
model.OldThink = model.Think
--
  model.CreateWeapon = function(me,wepmdl)
    local mdl = ClientsideModel(wepmdl)
	mdl:SetParent(me.Entity)
	mdl:AddEffects(EF_BONEMERGE)
	panel.Models["Weapon"] = mdl
  end
--
  model.Think = function(me)
    me.OldThink(me)
	local lmod = LocalPlayer():GetModel()
	if me:GetModel() != lmod then
	  me.SortModel(me, lmod)
	end
	local weapon = panel.Models["Weapon"]
	local activeweapon = LocalPlayer():GetActiveWeapon()
	if IsValid(weapon) then
	  if IsValid(activeweapon) then
	    local fmdl = activeweapon.WeaponModel
		if fmdl and fmdl != weapon:GetModel() then
		  weapon:SetModel(fmdl)
		end
	  end
	elseif IsValid(activeweapon) and !IsValid(weapon) then
	  local fmdl = activeweapon.WeaponModel
	  if fmdl then
	    me.CreateWeapon(me, fmdl)
	  end
	end
  end
--
model.SortModel(model)
model:SetTall(model:GetTall()*1.15)
model:SetCamPos(Vector(55,55,49))
model:SetFOV(35)
--------
local wep = LocalPlayer():GetActiveWeapon()
  if IsValid(wep) then
    local wepmdl = wep.WeaponModel
	if wepmdl then
	  model.CreateWeapon(model, wepmdl)
	end
  end
-------
  local fachairmodel = LocalPlayer():GetFacialHair()
  local hairmodel = LocalPlayer():GetHair()
  if hairmodel then
    local ply = model.Entity
    local hair = ClientsideModel(hairmodel)
	hair.Hair = true
	local attachment = ply:LookupAttachment("headgear")
    hair:SetParent(ply,attachment)
	panel.Models["Hair"] = hair
  end
  if fachairmodel then
    local ply = model.Entity
    local hair = ClientsideModel(fachairmodel)
	hair.Hair = true
	local attachment = ply:LookupAttachment("headgear")
    hair:SetParent(ply,attachment)
	panel.Models["FHair"] = hair	
  end  
end

function Schema.Hooks:pig_DrawTyping(ply,pos,ang)
local bone = "Bip01 Head"
bone = ply:LookupBone(bone)
if !bone then return end
pos = ply:GetBonePosition(bone)
pos = pos + ang:Up()*20
local type_pos = pos:ToScreen()
Fallout_DrawText(type_pos.x, type_pos.y,"Typing..","FO3FontHUD",Schema.GameColor,TEXT_ALIGN_CENTER)
return false
end

function Schema.Hooks:pig_DrawHotbar(x,y,w,h)
 if (true) then return false end
y = y
local off = h*.65
local thick = pig.GetOption("HotbarAlpha") or 100
if thick <= 0 then return end
thick = thick/25
FalloutBlur(nil, thick, x - (off/2), y - (off/2), w + off, h + off)
return --true
end

function Schema.Hooks:pig_SetHotbarWidth(maxW)
return maxW*.825 + 3
end

function Schema.Hooks:pig_DrawHotbarSlot(x,y,w,i)
  if (true) then return false end
	if pig.Hotbar.LastSlot == i then
      
	end
	local col = Schema.GameColor
	local alpha = pig.GetOption("HotbarAlpha") or 100
	col = Color(col.r,col.g,col.b,alpha)
	Fallout_Line(x,y,"up",w,false,col)
	Fallout_Line((x+w),y,"up",w,false,col)
	Fallout_Line(x,(y+w-3),"right",w,true,col)
	--
	local item = pig.Hotbar[i]
	if pig.Hotbar.LastSlot == i or !item or item and LocalPlayer():HasInvItem(item) then
	  surface.SetDrawColor(255,255,255)
	else
	  surface.SetDrawColor(135,135,135)	
	end
	local mat = nil
	local iw = w*.55
	local toff = w*.05 + 3
	  if alpha > 0 then
	    Fallout_DrawText(x + toff, y + toff, i, "FO3FontSmall", Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
	  end
	  if item then
	    mat = pig.GetInvIcon(item)
		surface.SetMaterial(mat)
	    --surface.DrawTexturedRect(x + (w/2) - (iw/2), y + (w/2) - (iw*.35), iw, iw)
	  end
  return false
end

function Schema.Hooks:pig_Options_Open(panel)
panel:SetSize(ScrW()*.25, ScrH())
panel:SetPos(ScrW()*.65,0)
panel:SetDraggable(false)
  panel.Paint = function(me)
    FalloutBlur(me, 10)
  end

local close = panel.CloseButton
close:SetSize(panel:GetWide()*.075, panel:GetTall()*.025)
close:SetPos(panel:GetWide() - close:GetWide(), 0)

local oplist = panel.OpsList
oplist:SetSize(panel:GetWide()*.89 + 0.5, panel:GetTall()*.4)
oplist:SetPos(0, panel:GetTall()*.6)
oplist:Center()
	
  for k,v in pairs(oplist:GetItems()) do
    if v.Added then continue end
    if v.IsSlider then
	  local min = v:GetMin()
	  local max = v:GetMax()
	  local name = v.Label:GetText()
	  --
	  local slider = vgui.Create("FalloutNumSlider")
	  slider.Added = true
	  slider:SetSize(oplist:GetWide(), oplist:GetTall()/8)
	  slider.OldValueChanged = v.OnValueChanged
	  slider:SetDecimals(0)
	  slider:SetMin(min)
	  slider:SetMax(max)
	  slider:SetText(name)
	  slider:SetValue(v:GetValue())
	  slider.OnValueChanged = function(me)
	    me.NextPlay = me.NextPlay or CurTime()-1
	    if me.NextPlay <= CurTime() then
	      surface.PlaySound("ui/ui_menu_prevnext.wav")
          me.NextPlay = CurTime()+0.1
	    end
	    local func = me.OldValueChanged
	    if !func then return end
	    func(me)
	  end
	  slider:InitSlider()
	  --
	  v:Remove()
	  oplist:AddItem(slider)
	else
	  local base = vgui.Create("DPanel")
	  base.Added = true
	  base:SetSize(oplist:GetWide(), oplist:GetTall()/8)
	  base.Name = v:GetText()
	  base.OnCursorEntered = function(me)
	    surface.PlaySound("ui/focus.mp3")
	    me.ins = true
	  end
	  base.OnCursorExited = function(me)
	    me.ins = false
	  end
	  base.Paint = function(me)
	    if me.ins then
		  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,5))
		  surface.SetDrawColor(Schema.GameColor)
		  surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
		end
	    draw.SimpleText(me.Name, "FO3FontSmall", me:GetWide()*.025, me:GetTall()/2, Schema.GameColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	  end
	
	  local but = pig.CreateButton(base, "TOGGLE", "FO3FontSmall")
	  but:SetSize(base:GetWide()*.2, base:GetTall())
	  but:SetPos(base:GetWide()*.95 - but:GetWide())
	  but.DoClick = v.DoClick
	  
	  v:Remove()
	  oplist:AddItem(base)
	end
  end
end

function Schema.Hooks:pig_F4Menu_Open(panel)
panel:Remove()
--
panel = vgui.Create("DPanel")
local pw = 640
panel:SetSize(pw, pw)
panel:MakePopup()
panel:Center()
panel.Page = 0
-----------
--ARCS
panel.Materials = {}
panel.Materials["back"] = Material("pw_fallout/hud_comp_bkg.png", "noclamp smooth")
panel.Materials[0] = Material("pw_fallout/hud_comp_pie.png", "noclamp smooth")
  for i=1,8 do
    panel.Materials[i] = Material("pw_fallout/hud_comp_slice"..i..".png", "noclamp smooth")
  end
  
  local funcs = {}
  local amt = 0
  for k,v in SortedPairs(pig.PigMenuButtons) do
    amt = amt+1
    funcs[amt] = {Name = v.Name, Func = function(panel)
	  surface.PlaySound("ui/ok.mp3")
	  if pig.utility.IsFunction(v.panel) then
	    pig.vgui.PigMenuPan = v.panel(panel)
	  else
	    pig.vgui.PigMenuPan = vgui.Create(v.panel)
	  end
	  local pan = pig.vgui.PigMenuPan
	  if !IsValid(pan) then return end
	  if !pan.NonModify then
        pan:Center()
	  end
      pan:MakePopup()
	  panel:Remove()
	end}
  end
  
  local icon_pos = {}
  icon_pos[8] = {x = .275, y = .265}
  icon_pos[7] = {x = .205, y = .415}
  icon_pos[6] = {x = .21, y = .579, scale = .85}
  icon_pos[5] = {x = .3, y = .695}
  icon_pos[4] = {x = .745, y = .695}
  icon_pos[3] = {x = .81, y = .579, scale = .8}
  icon_pos[2] = {x = .8, y = .415, scale = .825}  
  icon_pos[1] = {x = .76, y = .265, scale = .825}    
  
  local icons = {}
  icons["Perk Flags"] = Material("pw_fallout/perks/herenow.png", "noclamp smooth")
  icons["Armor Editor"] = Material("pw_fallout/perks/power.png", "noclamp smooth")  
  icons["Trade Offers"] = Material("pw_fallout/perks/barter.png", "noclamp smooth")    
  icons["Quests"] = Material("pw_fallout/perks/radres.png", "noclamp smooth")   
  icons["Character Screen"] = Material("pw_fallout/skills/skills_science.png", "noclamp smooth")
  icons["Attributes"] = Material("pw_fallout/perks/intense.png", "noclamp smooth")    
  icons["Inventory"] = Material("pw_fallout/perks/strongback.png", "noclamp smooth")
  icons["Options"] = Material("pw_fallout/icons/misc/junk.png", "noclamp smooth")
  icons["Shop"] = Material("pw_fallout/perks/barter.png", "noclamp smooth")
  icons["Factions"] = Material("pw_fallout/perks/power.png", "noclamp smooth")  
  icons["Help Menu"] = Material("pw_fallout/skills/skills_science.png", "noclamp smooth")
  icons["S.P.E.C.I.A.L"] = Material("pw_fallout/perks/intense.png", "noclamp smooth")   
  
	local range = {}
	range[15]	= 	{panel.Materials[8], 8}
	range[14]	= 	{panel.Materials[8], 8}
	range[13]	= 	{panel.Materials[8], 8}
	range[12]	= 	{panel.Materials[8], 8}
	range[18]	= 	{panel.Materials[7], 7}
	range[17]	= 	{panel.Materials[7], 7}
	range[16]	= 	{panel.Materials[7], 7}
	range[-18] 	= 	{panel.Materials[6], 6}
	range[-17] 	= 	{panel.Materials[6], 6}
	range[-16] 	= 	{panel.Materials[6], 6}
	range[-15] 	= 	{panel.Materials[5], 5}
	range[-14] 	= 	{panel.Materials[5], 5}
	range[-13] 	= 	{panel.Materials[5], 5}
	range[-12] 	= 	{panel.Materials[5], 5}
	range[-4] 	= 	{panel.Materials[4], 4}
	range[-5] 	= 	{panel.Materials[4], 4}
	range[-6] 	= 	{panel.Materials[4], 4}
	range[-1] 	= 	{panel.Materials[3], 3}
	range[-2] 	= 	{panel.Materials[3], 3}
	range[-3] 	= 	{panel.Materials[3], 3}
	range[0] 	= 	{panel.Materials[2], 2}
	range[1] 	= 	{panel.Materials[2], 2}
	range[2] 	= 	{panel.Materials[2], 2}
	range[3] 	= 	{panel.Materials[1], 1}
	range[4] 	= 	{panel.Materials[1], 1}
	range[5] 	= 	{panel.Materials[1], 1}
	range[6] 	= 	{panel.Materials[1], 1}
---------
--
  panel.ArcButtons = function(me)
	for i=1,8 do
	  local button = i + (8*me.Page)
	  local icon = nil
	  if funcs[button] then
	    local name = funcs[button].Name
		icon = icons[name]
	  end
	  if icon then
	    local tbl = icon_pos[button]
		if !tbl then continue end
	    local xpos = tbl.x
		local ypos = tbl.y
		local scale = tbl.scale
		local iw = me:GetWide()*.25
		if scale then
		  iw = iw*scale
		end
	    surface.SetDrawColor(Schema.GameColor)
	    surface.SetMaterial(icon)
	    surface.DrawTexturedRectRotated(me:GetWide()*xpos, me:GetTall()*ypos, iw, iw, 0)
	  end
	end
	--
	if me.NoClick then return end
    local cX, cY = ScrW()/2, ScrH()/2
	local mX, mY = input.GetCursorPos() 
	local ang2 = math.deg(math.atan2(cY-mY, mX-cX))
	local num = math.Round(ang2*0.1, 0)
	--
	if range[num] and range[num][2] then
	  local button = range[num][2] + (8*me.Page)
	  surface.SetDrawColor(Schema.GameColor)
	  surface.SetMaterial(range[num][1])
	  surface.DrawTexturedRect(0,0,me:GetWide(), me:GetTall())
	  me.Selected = button
	    if input.IsMouseDown(MOUSE_LEFT) and !me.Clicked and funcs[button] then
		  funcs[button].Func(me)
		  me.Clicked = true
		elseif !input.IsMouseDown(MOUSE_LEFT) and me.Clicked then
		  me.Clicked = false
		end
	else
	  me.Selected = nil
	end
  end
-----
  --MAX PAGES
    local count = table.Count(funcs)
	local div = count/8
	  if pig.utility.IsFloat(div) then
        local rounded = math.Round(div)
          if rounded > div then
            --0.5 +
			div = rounded
          elseif rounded < div then
		    --below 0.5
			div = rounded+1
          end
		div = div-1
	  end
	-----------
local next = pig.CreateButton(panel, "Next", "FO3Font")
next:SetPos(panel:GetWide()/2 + (next:GetWide()/2), panel:GetTall()*.86 - next:GetTall())
  next.DoClick = function(me)
    if panel.Page >= div then return end
	surface.PlaySound("ui/ok.mp3")
    panel.Page = panel.Page+1
  end
  
local prev = pig.CreateButton(panel, "Prev", "FO3Font")
prev:SetPos(panel:GetWide()/2 - (next:GetWide()*1.5), panel:GetTall()*.86 - next:GetTall())
  prev.DoClick = function(me)
    if panel.Page <= 0 then return end
	surface.PlaySound("ui/ok.mp3")
    panel.Page = panel.Page-1
  end

local exit = pig.CreateButton(panel, "Exit", "FO3Font")
exit:Center()
  exit.OnCursorEntered = function(me)
    me.ins = true
	surface.PlaySound("ui/focus.mp3")
    panel.NoClick = true
  end
  exit.OnCursorExited = function(me)
    me.ins = false
	panel.NoClick = false
  end
  exit.DoClick = function(me)
    surface.PlaySound("ui/ok.mp3")
	panel:Remove()
  end
-----
panel.Time = SysTime()
  panel.Paint = function(me)
    --Derma_DrawBackgroundBlur(me, me.Time)
    local col = Schema.GameColor
	--
    surface.SetDrawColor(col)
	surface.SetMaterial(me.Materials["back"])
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
	
    surface.SetDrawColor(col)
	surface.SetMaterial(me.Materials[0])
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())	
	
	draw.SimpleText(me.Page, "FO3FontHUD", me:GetWide()/2, me:GetTall()*.8, col, TEXT_ALIGN_CENTER)
	
	draw.SimpleText("F4 Menu", "FO3Font", me:GetWide()/2, me:GetTall()*.12, col, TEXT_ALIGN_CENTER)	
	local name = "--"
	if me.Selected and funcs[me.Selected] then
	  name = funcs[me.Selected].Name
	end
	draw.SimpleText(name, "FO3FontHUD", me:GetWide()/2, me:GetTall()*.2, col, TEXT_ALIGN_CENTER)
	--
	me:ArcButtons()
  end
end

-------------------------
local main_timer = Material("pw_fallout/main_timer.png")
local timer_bar = Material("pw_fallout/main_timer_bar.png")
local s_rotation = 0
local s_starttime = 0
local s_life = 5
function FalloutSavePaint()
if s_starttime + s_life <= CurTime() then return end
--
local _,_,tx, ty = FalloutHUDSize()
local tw = ScrH()*.12
local space = ScrH()*.0365

tx = ScrW() - tw - tx - space
ty = ty - (tw*1.2)
local speed = (50*FrameTime())
s_rotation = s_rotation + speed
  if s_rotation > 360 then
    s_rotation = 0
  end
--
local startFade = s_starttime + 3.75
local value = 0
if startFade <= CurTime() then
  local startTime = startFade
  local lifeTime = 1.25;
  local startVal = 0;
  local endVal = 255;
 
  value = startVal;
  local fraction = ( CurTime() - startTime ) / lifeTime;
  fraction = math.Clamp( fraction, 0, 1 );
  value = Lerp( fraction, startVal, endVal );
end
--
local col = Schema.GameColor
surface.SetDrawColor(Color(col.r, col.g, col.b, 255 - value))

surface.SetMaterial(main_timer)
surface.DrawTexturedRect(tx, ty, tw, tw)

surface.SetMaterial(timer_bar)
surface.DrawTexturedRectRotated(tx + (tw/2), ty + (tw/2), tw*.1, tw, -s_rotation)
end

net.Receive("FSavePic", function()
FalloutHUDHide = true
local format = "jpg"
  timer.Simple(0.015, function()
    local data = render.Capture( {
	  format = "jpeg",
	  quality = 70,
	  w = ScrW(),
	  h = ScrH(),
	  x = 0,
	  y = 0,
    } )
    local name = LocalPlayer():Name()
    if file.Exists("pw_newvegas/"..name.."."..format, "DATA") then
      file.Delete("pw_newvegas/"..name.."."..format)
    end
    file.Write( "pw_newvegas/"..name.."."..format, data )
    print("[PW NV]: Saved char screenshot for "..name)
    FalloutHUDHide = false
  end)
end)

net.Receive("FSaveIcon", function()
pig.Notify(Schema.GameColor, "Saving your character..", 2)
s_starttime = CurTime()
end)