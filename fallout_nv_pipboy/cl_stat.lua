PipBoy3000 = PipBoy3000 or {}
local tab = {}
-----------------------
--Status
tab[1] = {Name = "Status",Func = function(me,x)
local tb = {}
local parts = GetAllLimbs()
local body = vgui.Create("DPanel",me)
tb[1] = body
body:SetSize(me:GetWide()*.425,me:GetTall()*.55)
body:SetPos(0,me:GetTall()*.165)
body:CenterHorizontal()
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
--
body.Paint = function(self)
  local col = Schema.GameColor
  local total = 0
  --
  for k,v in SortedPairs(parts,false) do
    surface.SetDrawColor(col)
    local str = string.gsub(v," ","_"):lower()
	local lp = LocalPlayer():GetLimb(v)
    total = total + lp
	  if lp <= 0 then
	    str = str.."_broken"
	  end
	surface.SetMaterial(Material("pw_fallout/limbs/"..str..".png"))
	surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
	--
	local px = tbl[v].x
	local py = tbl[v].y
	local pw = self:GetWide()*.225
	local ph = self:GetTall()*.04
	if lp > 0 then
	  surface.SetMaterial(Material("pw_fallout/limbs/health_big.png"))
	  surface.DrawTexturedRect(self:GetWide()*px,self:GetTall()*py,pw*1.6,ph*2)
	  --
      surface.SetDrawColor(Color(col.r*.4,col.g*.4,col.b*.4))	
	  surface.DrawRect(self:GetWide()*px+(pw*.125),self:GetTall()*py+(ph*.5),pw,ph)	
      surface.SetDrawColor(col)	
	  local percent = lp/100
	  surface.DrawRect(self:GetWide()*px+(pw*.125),self:GetTall()*py+(ph*.5),pw*percent,ph)
	else
	  draw.SimpleText("CRIPPLED","FO3FontPip",self:GetWide()*px,self:GetTall()*py,Schema.GameColor)
	end
    --
  end
  --
  local face = nil
    for k,v in SortedPairs(face_tbl) do
	  if total >= v.first and total <= v.last then
	    face = v.dir
	  end
	end
  surface.SetMaterial(Material(face))
  surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
end

local info = vgui.Create("DPanel",me)
tb[2] = info
info:SetSize(me:GetWide(),me:GetTall()*.06)
local bx,by = body:GetPos()
info:SetPos(0,(by+body:GetTall()) + me:GetTall()*.025)
info.Paint = function(me)
  draw.SimpleText(LocalPlayer():Name().." - Level "..LocalPlayer():GetLevel(),"FO3FontPip",me:GetWide()/2,0,Schema.GameColor,TEXT_ALIGN_CENTER)
end

local stim = pig.CreateButton(me,"S) Stimpack","FO3FontPip")
tb[3] = stim
stim:SetSize(me:GetWide()*.165,me:GetTall()*.05)
stim:SetPos(me:GetWide() - stim:GetWide() - me:GetWide()*.075,me:GetTall()*.17)

local cnd = pig.CreateButton(me,"CND","FO3FontPip")
tb[4] = cnd
cnd.glow = true
cnd:SetSize(me:GetWide()*.085,me:GetTall()*.05)
cnd:SetPos(me:GetWide()*.085,me:GetTall()*.185)

local rad = pig.CreateButton(me,"RAD","FO3FontPip")
tb[5] = rad
rad:SetSize(me:GetWide()*.085,me:GetTall()*.05)
rad:SetPos(me:GetWide()*.085,me:GetTall()*.186+cnd:GetTall())

return tb
end}
--SPECIAL
tab[2] = {Name = "S.P.E.C.I.A.L",Func = function(me,x)
local tb = {}
local col = Schema.GameColor
--------------
local special = Fallout_GetSpecial()
--
local list = vgui.Create("pig_PanelList",me)
list.SelectedPic = Material("pipboy/icons/special/special_endurance.vtf")
list.SelectedText = "Select an Skill to learn more about it!"
tb[1] = list
list:SetSize(me:GetWide() *.375,me:GetTall() *.615)
list:SetPos(x - 3,me:GetTall() *.17)
list:SetSpacing(1)
for k,v in pairs(special) do
local base = vgui.Create("DPanel")
base:SetSize(list:GetWide(),me:GetTall() *.065)
base.OnCursorEntered = function(self)
  self.ins = true
  surface.PlaySound("ui/focus.mp3")
  if !pig.Attributes[v] then return end
  list.SelectedPic = Material(pig.Attributes[v].Image)
  list.SelectedText = pig.Attributes[v].Description
  tb[4]:SetText(list.SelectedText)
end
base.Paint = function(self)
col = Schema.GameColor
local val = 0
surface.SetFont("FO3FontPip")
local tw,th = surface.GetTextSize(val)
  if pig.Attributes[v] then
    val = LocalPlayer():GetAttributeValue(v)
  end
if !self.ins then 
draw.SimpleText(v,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
draw.SimpleText(val,"FO3FontPip",self:GetWide() - (self:GetWide() *.1) - tw,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
return 
end
surface.SetDrawColor(col)
surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(col.r,col.g,col.b,5))
draw.SimpleText(v,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
draw.SimpleText(val,"FO3FontPip",self:GetWide() - (self:GetWide() *.1) - tw,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
end
base.OnCursorExited = function(self)
self.ins = false
end
list:AddItem(base)
end

local pic = vgui.Create("DPanel",me)
tb[2] = pic
pic:SetSize(me:GetWide() *.35,me:GetTall() *.5)
pic:SetPos(me:GetWide() *.7 - (pic:GetWide() / 2),me:GetTall() *.105)
pic.Paint = function(me)
surface.SetDrawColor(Color(col.r,col.g,col.b,111))
if list.SelectedPic == nil then return end
surface.SetMaterial(list.SelectedPic)
surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
end

local desc = vgui.Create("DPanel",me)
tb[3] = desc
local spacing = me:GetWide() *.015
desc:SetSize(me:GetWide() *.45,me:GetTall() *.2)
local px,py = pic:GetPos()
px = me:GetWide() - (me:GetWide() * PipBoy3000.StartPos.x) + (me:GetWide() * (PipBoy3000.StartPos.x *.45))
desc:SetPos(px - desc:GetWide(),py + pic:GetTall())
desc.Paint = function(self)
Fallout_Line(0,0,"right",self:GetWide(),true,col)
Fallout_Line(self:GetWide() - 3,0,"down",self:GetTall() *.25,false,col)
end
local text = vgui.Create("DLabel",desc)
tb[4] = text
text:SetPos(0,6)
text:SetFont("FO3FontPip")
text:SetWrap(true)
text:SetAutoStretchVertical(true)
text:SetSize(desc:GetSize())
text:SetTextColor(col)
text:SetText(list.SelectedText or "")
--------------
return tb
end}
-----------------------
--SKILLS
tab[3] = {Name = "Skills",Func = function(me,x)
local tb = {}
local col = Schema.GameColor
--------------
local list = vgui.Create("pig_PanelList",me)
list.SelectedPic = Material("pipboy/icons/special/special_endurance.vtf")
list.SelectedText = "Select an Skill to learn more about it!"
tb[1] = list
list:SetSize(me:GetWide() *.375,me:GetTall() *.615)
list:SetPos(x - 3,me:GetTall() *.17)
list:SetSpacing(1)
for k,v in SortedPairs(pig.Attributes) do
if Fallout_IsSpecial(k) then continue end
local base = vgui.Create("DPanel")
base:SetSize(list:GetWide(),me:GetTall() *.065)
base.OnCursorEntered = function(self)
  self.ins = true
  surface.PlaySound("ui/focus.mp3")
  list.SelectedPic = Material(v.Image)
  list.SelectedText = v.Description
  tb[4]:SetText(list.SelectedText)
end
base.Paint = function(self)
col = Schema.GameColor
surface.SetFont("FO3FontPip")
local val = LocalPlayer():GetAttributeValue(k)
local tw,th = surface.GetTextSize(val)
if !self.ins then 
draw.SimpleText(k,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
draw.SimpleText(val,"FO3FontPip",self:GetWide() - (self:GetWide() *.1) - tw,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
return 
end
surface.SetDrawColor(col)
surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(col.r,col.g,col.b,5))
draw.SimpleText(k,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
draw.SimpleText(val,"FO3FontPip",self:GetWide() - (self:GetWide() *.1) - tw,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
end
base.OnCursorExited = function(self)
self.ins = false
end
list:AddItem(base)
end

local pic = vgui.Create("DPanel",me)
tb[2] = pic
pic:SetSize(me:GetWide() *.35,me:GetTall() *.5)
pic:SetPos(me:GetWide() *.7 - (pic:GetWide() / 2),me:GetTall() *.105)
pic.Paint = function(me)
surface.SetDrawColor(Color(col.r,col.g,col.b,111))
if list.SelectedPic == nil then return end
surface.SetMaterial(list.SelectedPic)
surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
end

local desc = vgui.Create("DPanel",me)
tb[3] = desc
local spacing = me:GetWide() *.015
desc:SetSize(me:GetWide() *.45,me:GetTall() *.2)
local px,py = pic:GetPos()
px = me:GetWide() - (me:GetWide() * PipBoy3000.StartPos.x) + (me:GetWide() * (PipBoy3000.StartPos.x *.45))
desc:SetPos(px - desc:GetWide(),py + pic:GetTall())
desc.Paint = function(self)
Fallout_Line(0,0,"right",self:GetWide(),true,col)
Fallout_Line(self:GetWide() - 3,0,"down",self:GetTall() *.25,false,col)
end
local text = vgui.Create("DLabel",desc)
tb[4] = text
text:SetPos(0,6)
text:SetFont("FO3FontPip")
text:SetWrap(true)
text:SetAutoStretchVertical(true)
text:SetSize(desc:GetSize())
text:SetTextColor(col)
text:SetText(list.SelectedText or "")
--------------
return tb
end}
----------------------
--GENERAL
tab[4] = {Name = "General",Func = function(me,x)
local tb = {}
local list = vgui.Create("pig_PanelList",me)
tb[1] = list
list:SetSize(me:GetWide() *.6,me:GetTall() *.6)
list:SetPos(x - 3,me:GetTall() *.17)
list:SetSpacing(1)
 
  local infos = {}
  infos["Name"] = LocalPlayer():Name()
  infos["Faction"] = LocalPlayer():GetFactionName()
  infos["Session Kills"] = LocalPlayer():Frags()
  infos["Session Deaths"] = LocalPlayer():Deaths()
  infos["User Group"] = LocalPlayer():GetUserGroup():upper()
  infos["Level"] = LocalPlayer():GetLevel()
  infos["XP"] = LocalPlayer():GetXP()
  infos["Remaining XP"] = LocalPlayer():GetRequiredXP() 
  infos["Karma"] = 0
  
  for k,v in SortedPairs(infos) do
    local base = vgui.Create("DPanel")
    base:SetSize(list:GetWide(),me:GetTall() *.075)
    base.OnCursorEntered = function(self)
      self.ins = true
      surface.PlaySound("ui/focus.mp3")
    end
    base.Paint = function(self)
      local col = Schema.GameColor
	  if self.ins then
        surface.SetDrawColor(col)
        surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
        draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(col.r,col.g,col.b,5))
	  end
	  draw.SimpleText(k..":","FO3FontPip",self:GetWide() *.05,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
      draw.SimpleText(v,"FO3FontPip",self:GetWide() *.95,self:GetTall() / 2,col,TEXT_ALIGN_RIGHT,TEXT_ALIGN_CENTER) 
	end
    base.OnCursorExited = function(self)
      self.ins = false
    end
    list:AddItem(base)
  end
  
return tb
end}

function PipBoy3000.OpenStats(dont)
  if PipBoy3000.SavedMode != "STATS" then
    PipBoy3000.SavedTab = nil
  end
PipBoy3000.SavedMode = "STATS"
-----------------------
local model = LocalPlayer():GetActiveWeapon().VMWeapon
local pip = "pipboyarm01"
  if LocalPlayer():IsDonator() then
    pip = "pimpboy"
  end
local new_mat = "models/llama/"..pip.."_stat"
  if IsValid(model) then
    model:SetSubMaterial(0,new_mat)
  end
----------------------
local screen = PipBoy3000.Base.Screen
local col = Schema.GameColor
local tbl = PipBoy3000.Base.Tabs
for k,v in ipairs(tab) do
PipBoy3000.MakeTab(v.Name,v.Func,k)
end
PipBoy3000.Base.Title = "STATS"
PipBoy3000.SortTabs()
--
  if PipBoy3000.SavedTab then
    local tab = PipBoy3000.SavedTab
    local but = PipBoy3000.Base.Tabs[tab]
	if IsValid(but) then
      but.DoClick(but)
	end
  else
    local but1 = PipBoy3000.Base.Tabs[1]
    but1.DoClick(but1,dont)
  end
------------------------------------------
screen.PaintFunc = function(me,text_x,line_y)
local x = text_x + (me:GetWide() *.015)
local spacing = me:GetWide() *.015
local w = me:GetWide() - (x+me:GetWide()*.075) - (spacing*3)
w = w/4
--
PipBoy3000.AddInfo(x,line_y,w,"LVL", LocalPlayer():GetLevel())
PipBoy3000.AddInfo(x + spacing + (w*1),line_y,w,"HP",LocalPlayer():Health().."/"..LocalPlayer():GetMaxHealth(),"FO3FontPip")
PipBoy3000.AddInfo(x + (spacing * 2) + (w*2),line_y,w,"AP",LocalPlayer():Armor().."/100","FO3FontPip")
PipBoy3000.AddInfo(x + (spacing * 3) + (w*3),line_y,w,"XP",LocalPlayer():GetXP().."/"..LocalPlayer():GetRequiredXP() + LocalPlayer():GetXP(),"FO3FontPip")
end
--
end
