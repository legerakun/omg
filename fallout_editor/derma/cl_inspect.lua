local PANEL = {}

function PANEL:Init()
--
FalloutTutorial("Armor Editor")
--
self:SetSize(ScrW()*.75,ScrH()*.75)
---
self.CamPos = Vector(2267.239502, 13179.476563, 1110.041016)
self.CamAng = Angle(3.942, 27.814, 0.681)

self.MPos = Vector(2318, 13208, 1050)
self.MAng = Angle(5, -154, 0.000000)
--
local offset = self:GetWide()*.045
local hoffset = self:GetTall()*.07
local spacing = offset/2
local infow = self:GetWide()*.255
local main = vgui.Create("pig_PanelList",self)
self.Main = main
main:SetSize( self:GetWide() - (infow+(offset*2)+(spacing*.75)), self:GetTall() - (hoffset*2) )
main:SetPos( self:GetWide() - main:GetWide() - offset, hoffset)
  main.Paint = function(me)
    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,150))
  end
--
local infopanel = vgui.Create("DPanel",self)
infopanel:SetSize(infow,self:GetTall()*.275)
infopanel:SetPos(offset,hoffset)
  infopanel.Paint = function(me)
    local money = LocalPlayer():GetMoney()
	local level = LocalPlayer():GetLevel()
    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,150))
	draw.DrawText(LocalPlayer():Name().."\n"..money .." "..Schema.Currency.."\n\nLevel "..level, "FO3FontSmall", me:GetWide()*.3, me:GetTall()*.075, Schema.GameColor)
    --
	local totalw = me:GetWide()*.75
	local totalh = 6
	local xpos = me:GetWide()/2 - (totalw/2)
	local ypos = me:GetTall()*.85 - (totalh/2)
	local remaining = LocalPlayer():GetRequiredXP()
	local xp = LocalPlayer():GetXP()
	local percentage = xp/(remaining+xp)
	--
	draw.RoundedBox(0,xpos,ypos,totalw,totalh,Color(80,80,80))
	draw.RoundedBox(0,xpos,ypos,totalw*percentage,totalh,Color(255,255,255))
	--
	local space = me:GetWide()*.06
	draw.SimpleText(level, "FO3FontSmall", xpos-(space*1.25), ypos - space, Schema.GameColor)
	draw.SimpleText(level+1, "FO3FontSmall", xpos+totalw+space, ypos - space, Schema.GameColor,TEXT_ALIGN_RIGHT)	
  end

local scroll = vgui.Create("pig_PanelList", self)
scroll:SetSize(infow, self:GetTall() *.4)
scroll:SetPos(offset, self:GetTall()*.35 + (spacing*.25))
  scroll.Paint = function(me)
    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,150))
  end
local ltext = "\nWelcome to the Armor Editor!\n\nHere is where you can edit your Power Armors that you have collected. You can personalise your armor by re-naming them and adding paintjobs for a sleek new look. Adding paintjobs adds value to your Power Armor, some paintjobs being more expensive - but also more valuable, than others.\n"
local label = vgui.Create("DLabel")
label:SetFont("FO3Font")
label:SetText(ltext)
label:SetTextColor(Schema.GameColor)
label:SetWrap(true)
label:SetAutoStretchVertical(true)
scroll:AddItem(label)
  
local avatar = vgui.Create("AvatarImage", infopanel)
avatar:SetSize(infopanel:GetWide()*.25,infopanel:GetWide()*.25)
avatar:SetPos(infopanel:GetWide()*.025,infopanel:GetTall()*.05)
avatar:SetPlayer(LocalPlayer(),128)
  avatar.PaintOver = function(me,w,h)
	Fallout_FullBox(0,0,w,h)
  end
---------------
local ew = main:GetWide()/4
local espacing = main:GetWide()*.01
local eminus = espacing*.82
main:SetSpacing(espacing)
main:EnableHorizontal(true)
/*
  local testtbl = {
  [1] = {skin = "pw_fallout/skins/sic"},
  [2] = {},
  [3] = {},
  [4] = {},
  [5] = {}
  }*/
  local inv = LocalPlayer():GetInventoryByClass("fallout_c_base")
  local tbl = {}
    for k,v in pairs(inv) do
	  local amt = LocalPlayer():GetInvAmount(k)
	  for i=1,amt do
	    if v.Saved_Vars and v.Saved_Vars[i].Outfit then
	      local outfit = v.Saved_Vars[i].Outfit
		  if !FIValidArmor(outfit) then continue end
		  local skin = v.Saved_Vars[i].Skin
		  local mdl = Fallout_OutfitModel(outfit,LocalPlayer():GetGender())
		  local matIndex = FIGetMatIndex(outfit,LocalPlayer():GetGender())
		  tbl[k..i] = {Index = k, ANumber = i, Model = mdl, Skin = skin, MatIndex = matIndex}
	    end
	  end
	end
--
  for k,v in pairs(tbl) do
    local element = vgui.Create("DPanel")
	element:SetSize(ew-eminus,ew-eminus)
	local col = FIGetCol(v.Skin) or Color(130,130,130)
	local icon = vgui.Create("DModelPanel",element)
	local bh = element:GetTall()*.25
	element.helmet = false
	icon.DoClick = function()
	  self:Inspect(v.Index, v.Model, v.MatIndex, v.Skin, v.ANumber, element.helmet)
	end
	icon:SetModel(v.Model)
	icon:SetSize(element:GetWide()-bh, element:GetTall()-(bh*1.5))
	icon:SetPos(0,bh*.25)
	icon:CenterHorizontal()
	  if v.Skin then
	    local skin = FIGetSkin(v.Skin)
	    icon.Entity:SetSubMaterial(v.MatIndex, skin)
	  end
	--
	local bone = icon.Entity:LookupBone( "Bip01 Spine" )
	local addvec = Vector(0,28,0)
	local setang = Angle(-10,90,0)
	local addang1 = 10
	local addang2 = 45
	if !bone then
	  element.helmet = true
	  local newmodel = FIGetNewModel(v.Index)
	  if newmodel then
	    icon.Entity:SetModel(newmodel)
	  end
	  bone = icon.Entity:LookupBone( "Helmet" )
	  addvec = Vector(2,15,0)
	  setang = Angle(0, -90, 0)
	  addang2 = 55
	end
	--
	local cpos = nil
	if bone then
	  cpos = icon.Entity:GetBonePosition( bone )
	else
	  cpos = Vector(0, -2, -1)
	end
	--
	cpos = cpos+addvec
	local ang = ( icon.vLookatPos-icon.vCamPos ):Angle()
	ang = Angle(ang.p+10, ang.y+45, 0)
	icon:SetLookAt(cpos)
	icon:SetCursor("arrow")
	icon:SetFOV(86)
	icon:SetCamPos(cpos+Vector(-2,0,9.5))
	icon:SetLookAng(ang)
	function icon:LayoutEntity( Entity ) 
	  Entity:SetAngles(setang)
	end
	--
	element.Paint = function(me)
	  local col2 = Color(col.r*1.5,col.g*1.5,col.b*1.5)
	  surface.SetDrawColor(col2)
	  surface.SetMaterial(Material("pw_fallout/skins/background.png"))
	  surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall() - bh)
	  --
	  surface.SetDrawColor(col)
	  surface.SetMaterial(Material("pw_fallout/skins/bar.png"))
	  surface.DrawTexturedRect(0,me:GetTall() - bh,me:GetWide(),bh)
	  --
	  local name = v.Index
	  local skin = v.Skin or "Default"
	  draw.DrawText(name,"FO3FontSmall",me:GetWide()*.025,me:GetTall() - bh + me:GetTall()*.01, Color(255,255,255))
	  draw.DrawText(skin,"FO3FontSmall",me:GetWide()*.025,me:GetTall() - bh + me:GetTall()*.1, Color(255,255,255))	  
	end
	main:AddItem(element)
  end
--
  local loops = 12 - table.Count(tbl)
  if loops > 0 then
    for i=1,loops do
	  local base = vgui.Create("DPanel")
	  base:SetSize(ew-eminus,ew-eminus)
	  local bh = base:GetTall()*.25
	  base.Paint = function(me)
	    surface.SetDrawColor(255,255,255)
	    surface.SetMaterial(Material("pw_fallout/skins/background.png"))
	    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall() - bh)
	    --
	    surface.SetDrawColor(Color(130,130,130))
	    surface.SetMaterial(Material("pw_fallout/skins/bar.png"))
	    surface.DrawTexturedRect(0,me:GetTall() - bh,me:GetWide(),bh)
	    --
	    local name = "Empty"
	    local skin = "--"
	    draw.DrawText(name,"FO3FontSmall",me:GetWide()*.025,me:GetTall() - bh + me:GetTall()*.01, Color(255,255,255))
	    draw.DrawText(skin,"FO3FontSmall",me:GetWide()*.025,me:GetTall() - bh + me:GetTall()*.1, Color(255,255,255))	  
	  end
	  main:AddItem(base)
	end
  end
  --
end

function PANEL:RefreshPanelList()
local main = self.Main
local ew = main:GetWide()/4
local espacing = main:GetWide()*.01
local eminus = espacing*.82
  for k,v in pairs(main:GetItems()) do
    v:Remove()
  end
--
  local inv = LocalPlayer():GetInventoryByClass("fallout_c_base")
  local tbl = {}
    for k,v in pairs(inv) do
	  local amt = LocalPlayer():GetInvAmount(k)
	  for i=1,amt do
	    if v.Saved_Vars and v.Saved_Vars[i].Outfit then
	      local outfit = v.Saved_Vars[i].Outfit
		  if !FIValidArmor(outfit) then continue end
		  local skin = v.Saved_Vars[i].Skin
		  local mdl = Fallout_OutfitModel(outfit,LocalPlayer():GetGender())
		  local matIndex = FIGetMatIndex(outfit,LocalPlayer():GetGender())
		  tbl[k..i] = {Index = k, ANumber = i, Model = mdl, Skin = skin, MatIndex = matIndex}
	    end
	  end
	end
--
  for k,v in pairs(tbl) do
    local element = vgui.Create("DPanel")
	element:SetSize(ew-eminus,ew-eminus)
	local col = FIGetCol(v.Skin) or Color(130,130,130)
	local icon = vgui.Create("DModelPanel",element)
	local bh = element:GetTall()*.25
	element.helmet = false
	icon.DoClick = function()
	  self:Inspect(v.Index, v.Model, v.MatIndex, v.Skin, v.ANumber, element.helmet)
	end
	icon:SetModel(v.Model)
	icon:SetSize(element:GetWide()-bh, element:GetTall()-(bh*1.5))
	icon:SetPos(0,bh*.25)
	icon:CenterHorizontal()
	  if v.Skin then
	    local skin = FIGetSkin(v.Skin)
	    icon.Entity:SetSubMaterial(v.MatIndex, skin)
	  end
	--
	local bone = icon.Entity:LookupBone( "Bip01 Spine" )
	local addvec = Vector(0,28,0)
	local setang = Angle(-10,90,0)
	local addang1 = 10
	local addang2 = 45
	if !bone then
	  element.helmet = true
	  local newmodel = FIGetNewModel(v.Index)
	  if newmodel then
	    icon.Entity:SetModel(newmodel)
	  end
	  bone = icon.Entity:LookupBone( "Helmet" )
	  addvec = Vector(2,15,0)
	  setang = Angle(0, -90, 0)
	  addang2 = 55
	end
	--
	local cpos = nil
	if bone then
	  cpos = icon.Entity:GetBonePosition( bone )
	else
	  cpos = Vector(0, -2, -1)
	end
	--
	cpos = cpos+addvec
	local ang = ( icon.vLookatPos-icon.vCamPos ):Angle()
	ang = Angle(ang.p+10, ang.y+45, 0)
	icon:SetLookAt(cpos)
	icon:SetCursor("arrow")
	icon:SetFOV(86)
	icon:SetCamPos(cpos+Vector(-2,0,9.5))
	icon:SetLookAng(ang)
	function icon:LayoutEntity( Entity ) 
	  Entity:SetAngles(setang)
	end
	--
	element.Paint = function(me)
	  local col2 = Color(col.r*1.5,col.g*1.5,col.b*1.5)
	  surface.SetDrawColor(col2)
	  surface.SetMaterial(Material("pw_fallout/skins/background.png"))
	  surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall() - bh)
	  --
	  surface.SetDrawColor(col)
	  surface.SetMaterial(Material("pw_fallout/skins/bar.png"))
	  surface.DrawTexturedRect(0,me:GetTall() - bh,me:GetWide(),bh)
	  --
	  local name = v.Index
	  local skin = v.Skin or "Default"
	  draw.DrawText(name,"FO3FontSmall",me:GetWide()*.025,me:GetTall() - bh + me:GetTall()*.01, Color(255,255,255))
	  draw.DrawText(skin,"FO3FontSmall",me:GetWide()*.025,me:GetTall() - bh + me:GetTall()*.1, Color(255,255,255))	  
	end
	main:AddItem(element)
  end
--
  local loops = 12 - table.Count(tbl)
  if loops > 0 then
    for i=1,loops do
	  local base = vgui.Create("DPanel")
	  base:SetSize(ew-eminus,ew-eminus)
	  local bh = base:GetTall()*.25
	  base.Paint = function(me)
	    surface.SetDrawColor(255,255,255)
	    surface.SetMaterial(Material("pw_fallout/skins/background.png"))
	    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall() - bh)
	    --
	    surface.SetDrawColor(Color(130,130,130))
	    surface.SetMaterial(Material("pw_fallout/skins/bar.png"))
	    surface.DrawTexturedRect(0,me:GetTall() - bh,me:GetWide(),bh)
	    --
	    local name = "Empty"
	    local skin = "--"
	    draw.DrawText(name,"FO3FontSmall",me:GetWide()*.025,me:GetTall() - bh + me:GetTall()*.01, Color(255,255,255))
	    draw.DrawText(skin,"FO3FontSmall",me:GetWide()*.025,me:GetTall() - bh + me:GetTall()*.1, Color(255,255,255))	  
	  end
	  main:AddItem(base)
	end
  end
end

function PANEL:Inspect(name, model, sub, mat, anum, helmet)
surface.PlaySound("ui/item_inspect.wav")
local skincol = nil
local newmat = nil
local caps = nil
  if IsValid(self.PopUp) then
    for k,v in pairs(self.PopUp.Models) do
	  v:Remove()
	  v = nil
	  self.PopUp.Models[k] = nil
	end
    self.PopUp:Remove() 
  end
--------
local pos = self.PlacePos
local ang = self.PlaceAng
local cpos = self.CamPos
local cang = self.CamAng
local ch_pos = self.MPos
local ch_ang = self.MAng

--
/*
local background = ClientsideModel("models/optinvfallout/vault3entrance.mdl")
background:SetPos(pos)
background:SetAngles(ang)
*/
local preview = CreateFModel(model)
  if helmet then
    ch_pos = Vector(-5745, 8447, 9347)
	ch_ang = Angle(0, 45, 0)
  else
    preview:PerformAnim("mtidle")
  end
preview:SetPos(ch_pos)
preview:SetAngles(ch_ang)
  if sub and mat then
    local skin = FIGetSkin(mat)
    preview:SetSubMaterial(sub,skin)
	skincol = FIGetCol(mat)
  end
--------
local popup = vgui.Create("DPanel")
popup.Models = {}
--popup.Models[1] = background
popup.Models[2] = preview
-----
self.PopUp = popup
popup:SetSize(ScrW()*.4,ScrH()*.55)
popup:MakePopup()
popup:Center()
popup.Time = SysTime()
local offset = popup:GetWide()*.01
local h1 = popup:GetTall()*.07
local h2 = popup:GetTall()*.02
------
  local myx,myy = popup:GetPos()
  local takevec = cang:Forward()*80 - cang:Right()*26
  local viewtbl = {
		origin = cpos - takevec,
		angles = cang,
		x = myx + offset,
		y = myy + h1,
		w = popup:GetWide() - (offset*2),
		h = popup:GetTall() - (h1+h2)
	 } 
------
  popup:SetDrawOnTop(true)
  popup.Paint = function(me,w,h)
    if !skincol then
      surface.SetDrawColor(Color(255,255,255))
	else
      surface.SetDrawColor(Color(skincol.r*1.5,skincol.g*1.5,skincol.b*1.5))	  
	end
	surface.SetMaterial(Material("pw_fallout/skins/frame.png"))
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
	local skinname = mat or "Default"
	--
	draw.DrawText(name.." | "..skinname,"FO3FontHUD",me:GetWide()/2,me:GetTall()*.01,Color(255,255,255),TEXT_ALIGN_CENTER)
	--
	local vx = viewtbl.origin.x
	local vy = viewtbl.origin.y
	local radius = 1
	local speed = FrameTime()*115
	if vx < (cpos.x-radius) then
	  vx = vx+speed
	end
	if vx > (cpos.x+radius) then
	  vx = vx-speed
	end
	if vy < (cpos.y-radius) then
	  vy = vy+speed
	end
	if vy > (cpos.y+radius) then
	  vy = vy-speed
	end
	viewtbl.origin.x = vx
	viewtbl.origin.y = vy
	--
	render.RenderView( viewtbl )
  end
-----
local list = vgui.Create("DFrame")
list:SetTitle("")
list:ShowCloseButton(false)
list:SetDraggable(false)
list:SetSize(popup:GetWide()*.6,popup:GetTall())
local px,py = popup:GetPos()
local lx = px - list:GetWide()
list:SetPos(lx+list:GetWide(), py)
list:MakePopup()
  list.Paint = function(me)
    draw.Blur(me,3,4,255)
    draw.RoundedBox(8,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,170))
  end
  list.Think = function(me)
    if !IsValid(popup) then
	  me:Remove()
	end
	local mx,my = gui.MousePos()
	local lix,liy = me:GetPos()
	local tmv = 0.35
	if mx >= (lx) and mx <= (lx+me:GetWide()) then
	  if lix != lx and !me.Moving then
	    me.Moving = true
	    me:MoveTo(lx,liy,tmv,0,-1,function()
		  if !IsValid(me) then return end
		  me.Moving = false
		  me.Out = true
		end)
	  end
	elseif !me.Moving and me.Out then
	  me.Moving = true
	  me:MoveTo((lx+me:GetWide()),liy,tmv,0,-1,function()
	    me.Out = false
		me.Moving = false
	  end)	  
	end
  end

local skins = vgui.Create("pig_PanelList",list)
skins:SetSize(list:GetWide()*.95,list:GetTall()*.75)
skins:Center()
skins:EnableHorizontal(true)
local space = skins:GetWide()*.02
--------
local text = vgui.Create("DLabel",list)
text:SetText("Rename (250 "..Schema.Currency..")")
text:SetFont("FO3FontSmall")
text:SetTextColor(Schema.GameColor)
text:SizeToContents()
text:SetPos(space*1.5, list:GetTall()*.035)

local entry = vgui.Create("DTextEntry", list)
entry:SetSize(list:GetWide()*.55, text:GetTall()*1.5)
local tx,ty = text:GetPos()
entry:SetPos(tx + text:GetWide() + space, ty)
entry:SetDrawBorder( false )
entry:SetDrawBackground( false )
entry:SetFont("FO3FontSmall")
entry:SetTextColor(color_white)
entry:SetCursorColor(color_white)
	entry.Think = function(self)
	  local text = self:GetValue()
	  local len = text:len()
	  local max = 20
	  if len > max then
	    text = text:sub(1,max)
	    self:SetText(text)
		self:SetCaretPos(text:len())
	  end
	end
  entry.Paint = function(me)
    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,20))
    Fallout_HalfBox(0,0,me:GetWide(),me:GetTall(),me:GetTall()*.375)
	derma.SkinHook( "Paint", "TextEntry", me, me:GetWide(), me:GetTall() )
  end
  
local confirm = pig.CreateButton(list,"Confirm","FO3FontHUD")
confirm:SetPos(0,list:GetTall()*.95 - confirm:GetTall())
confirm:CenterHorizontal()
  confirm.DoClick = function(me)
    local total = caps or 0
	local Myname = entry:GetText()
	if Myname:len() < 3 then
	  Myname = nil
	end
	if Myname then
	  total = total+250
	end
	if total > LocalPlayer():GetMoney() then
	  surface.PlaySound("ui/ok.mp3")
	  pig.Notify(Schema.RedColor, "You cannot afford this", 3)
	return end
	if !Myname and newmat == nil then
	  surface.PlaySound("ui/ok.mp3")
	return end
	-----------------
	if newmat and !LocalPlayer():IsDonator() and FIDonatorSkin(newmat) then
	  surface.PlaySound("ui/ok.mp3")
	  pig.Notify(Schema.RedColor, "You must be a Donator to use this skin", 5)	
	  return
	end
	if Myname and !LocalPlayer():IsDonator() then
	  surface.PlaySound("ui/ok.mp3")
	  pig.Notify(Schema.RedColor, "You must be a Donator to rename items", 5)
	  return
	end
	if Myname and LocalPlayer():HasInvItem(Myname) then
	  pig.Notify(Schema.RedColor, "You already own an item with this name!", 2)	  
	  return
	end
	--
	surface.PlaySound("ui/item_drop3_rare.wav")
	net.Start("FIPaint")
	net.WriteString(name)
	net.WriteString(Myname or "")
	net.WriteString(newmat or "")
	net.WriteFloat(anum)
	net.SendToServer()
	--
	if Myname == "" then
	  Myname = nil
	else
	  TakeInvVars(name,1)
	end
	self:Inspect(Myname or name, model, sub, mat, anum, helmet)
	timer.Simple(1,function()
	  if !IsValid(self) then return end
	  self:RefreshPanelList()
	end)
  end
--------
skins:SetSpacing(space)
local eleW = skins:GetWide()/2 - space
  for k,v in SortedPairsByMemberValue(FISkins,"Price") do
    local mdlname = FIModelToArmor(model)
    if !FICanApplySkin(mdlname,k) then continue end
    local element = vgui.Create("DButton")
	element.Render = function(me,py)
	  local offset = -skins.VBar:GetOffset()
	  local ypos = me.y + py
	  local tall = skins:GetTall()
	  if (ypos) < offset or ypos > (offset+tall) then
	    return false
	  end
	  return true
	end
	element:SetSize(eleW,eleW)
	element:SetText("")
	element:SetCursor("arrow")
	--
	local icon = vgui.Create("DModelPanel",element)
	local bh = element:GetTall()*.25
	icon:SetModel(model)
	icon:SetSize(element:GetWide()-bh, element:GetTall()-(bh*1.5))
	icon:SetPos(0,bh*.25)
	icon:CenterHorizontal()
	--
	icon.Entity:SetSubMaterial(sub, v.Dir)
	icon.DoClick = function(me)
	  skins.NextPaint = skins.NextPaint or CurTime() - 1
	  if skins.NextPaint <= CurTime() then
	    surface.PlaySound("ui/paintjob.mp3")
		skins.NextPaint = CurTime()+7
	  else
	    surface.PlaySound("ui/paint.mp3")
	  end
	  preview:SetSubMaterial(sub, v.Dir)
	  mat = k
	  newmat = k
	  skincol = v.Col
	  caps = v.Price
	end
	icon.DoRightClick = function()
	  preview:SetSubMaterial(sub, nil)
	  mat = nil
	  skincol = nil
	  newmat = nil
	  caps = nil
	end
	--
	local bone = icon.Entity:LookupBone( "Bip01 Spine" )
	local addvec = Vector(0,28,0)
	local setang = Angle(-10,90,0)
	local addang1 = 10
	local addang2 = 45
	if !bone then
	  element.helmet = true
	  local newmodel = FIGetNewModel(v.Armor)
	  if newmodel then
	    icon.Entity:SetModel(newmodel)
	  end
	  bone = icon.Entity:LookupBone( "Helmet" )
	  addvec = Vector(0,15,0)
	  setang = Angle(0, -73, 0)
	  addang2 = 55
	end
	--
	local cpos = nil
	if bone then
	  cpos = icon.Entity:GetBonePosition( bone )
	else
	  cpos = Vector(0, -2, -1)
	end
	--
	cpos = cpos+addvec
	local ang = ( icon.vLookatPos-icon.vCamPos ):Angle()
	ang = Angle(ang.p+addang1, ang.y+addang2, 0)
	icon:SetLookAt(cpos)
	icon:SetFOV(86)
	icon:SetCamPos(cpos+Vector(-2,0,9.5))
	icon:SetLookAng(ang)
	function icon:LayoutEntity( Entity ) 
	  Entity:SetAngles(setang)
	end
	--
	element.Paint = function(me)
	  local col = v.Col
	  col = Color(col.r*1.5,col.g*1.5,col.b*1.5)
	  surface.SetDrawColor(col)
	  surface.SetMaterial(Material("pw_fallout/skins/background.png"))
	  surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall() - bh)
	  --
	  surface.SetDrawColor(v.Col)
	  surface.SetMaterial(Material("pw_fallout/skins/bar.png"))
	  surface.DrawTexturedRect(0,me:GetTall() - bh,me:GetWide(),bh)
	  --
	  local name = k
	  draw.DrawText(name,"FO3FontSmall",me:GetWide()*.025,me:GetTall() - bh + me:GetTall()*.01, Color(255,255,255))
	  draw.DrawText(v.Price.." "..Schema.Currency,"FO3FontSmall",me:GetWide()*.025,me:GetTall() - bh + me:GetTall()*.1, Color(255,255,255))
	end
	
	skins:AddItem(element)
  end
-----
  popup:RequestFocus()
  popup.RemoveModels = function(me)
	for k,v in pairs(me.Models) do
	  v:Remove()
	  v = nil
	  me.Models[k] = nil
	end
  end
  
  popup.Think = function(me)
    local mx,my = gui.MousePos()
	local myx, myy = me:GetPos()
	local lix,liy = list:GetPos()
	if !list:IsVisible() and mx < myx then
	  list:SetVisible(true)
	elseif list:IsVisible() and lix >= myx-0.75 then
	  list:SetVisible(false)
	end
	if input.IsMouseDown(MOUSE_LEFT) then
	  if list.Moving or mx < myx - (lix+list:GetWide()) or mx > ( myx+me:GetWide() ) or my < myy or my > (myy+me:GetTall()) then
	    me:Remove()
		me.RemoveModels(me)
	  return end
	end
    if !IsValid(self) then
      me.RemoveModels(me)
	  me:Remove()
	  return
	end
  end
-------
local close = vgui.Create("DButton",popup)
close:SetSize(popup:GetWide()*.035,popup:GetWide()*.035)
close:SetPos(popup:GetWide() - close:GetWide() - offset, offset)
close:SetText("")
close.Paint = function() return end
  close.DoClick = function(me)
    local parent = me:GetParent()
      for k,v in pairs(parent.Models) do
	    v:Remove()
		v = nil
		parent.Models[k] = nil
	  end
    parent:Remove()
  end
end

vgui.Register("FInspect",PANEL,"Fallout_Frame")