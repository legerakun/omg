local Plugin = {}
local Reflectron = {}
Plugin.Mat = Material("ui/reflectron.png")
FalloutReflectronModels = FalloutReflectronModels or {}
-------------
Plugin.RefColor = Color(42,193,112)

Plugin.Stage = {}
Plugin.Stage[1] = "Sex"
Plugin.Stage[2] = "Race"
Plugin.Stage[3] = "Face"
Plugin.Stage[4] = "Hair"

Plugin.FuncStage = {}
-------------

function Reflectron.SetHair(panel,val)
local model = panel.Model:GetEntity()
  if IsValid(FalloutReflectronModels["Hair"]) then 
    FalloutReflectronModels.Hair:Remove()
	FalloutReflectronModels["Hair"] = nil
  end
val = math.Round(val)
panel.Hair = val
local str = val..""..panel.Gender
  if panel.Ghoul then
    str = val.."Ghoul"
  end
--
local tbl = Fallout_HairStyles()
--
if !tbl[str] then return end
local mdl = ClientsideModel(tbl[str], RENDER_GROUP_OPAQUE_ENTITY)
mdl:SetIK(false)
mdl:SetNoDraw(true)
mdl:SetAngles(model:GetAngles())
local attachment = model:LookupAttachment("headgear")
mdl:SetParent(model,attachment)
FalloutReflectronModels["Hair"] = mdl
end

function Reflectron.SetFacial(panel,val)
  if panel.Gender == "Female" then
    if FalloutReflectronModels["FacialHair"] then
	  FalloutReflectronModels["FacialHair"]:Remove()
	  FalloutReflectronModels["FacialHair"] = nil
	end
  return end
if IsValid(FalloutReflectronModels["FacialHair"]) then FalloutReflectronModels.FacialHair:Remove() end
local model = panel.Model:GetEntity()
val = math.Round(val)
panel.FacHair = val
--
local tbl = Fallout_FacHairStyles()
--
local str = val.."F"
if !tbl[str] then return end
local mdl = ClientsideModel(tbl[str],RENDERGROUP_OPAQUE)
mdl:SetIK(false)
mdl:SetNoDraw(true)
mdl:SetColor(Color(204,0,0))
mdl:SetAngles(model:GetAngles())
local attachment = model:LookupAttachment("headgear")
mdl:SetParent(model,attachment)
FalloutReflectronModels["FacialHair"] = mdl
end

function Reflectron.SetRace(panel,ghoul)
local face = panel.Model
local bg = face:GetEntity():FindBodygroupByName("heads")
panel.Ghoul = ghoul
  if ghoul then
	face:GetEntity():SetSkin(1)
	face:GetEntity():SetBodygroup(bg,1)
  else
	face:GetEntity():SetSkin(0)
	face:GetEntity():SetBodygroup(bg,0)	
  end
Reflectron.SetHair(panel,panel.Hair or 1)
end

function Reflectron.SetSkin(panel,skin)
local tbl = nil--Fallout_HumanSkins()
local gh = ""
local searchhead = "headhuman"
  if panel.Ghoul then
    tbl = Fallout_GhoulSkins()
	gh = "ghoul"
	if panel.Gender:lower() == "male" then
	  searchhead = "headhumanghoul"
	else
	  searchhead = "headghoul"..panel.Gender:lower()..""
	end
  else
    tbl = Fallout_HumanSkins(panel.Gender)
  end
--
panel.Skin = skin
local ent = panel.Model:GetEntity()
local sub = panel.Sub[panel.Gender..""..gh]
local body = panel.Sub[panel.Gender.."Body"..gh]
  if !sub then
    for k,v in pairs(ent:GetMaterials()) do
      if v:find(searchhead) then
	    sub = (k-1)
	    panel.Sub[panel.Gender..""..gh] = sub
	    break
	  end
    end
	
    for k,v in pairs(ent:GetMaterials()) do
      if v:find("upperbody"..panel.Gender:lower()..""..gh) then
	    body = (k-1)
	    panel.Sub[panel.Gender.."Body"..gh] = body
	    break
	  end
    end	
  end
--
local mdlskin = tbl[skin]
local bodymat = nil
  if type(mdlskin) == "table" then
	bodymat = mdlskin.Body
    mdlskin = mdlskin.Mat
  end
--
ent:SetSubMaterial(sub, mdlskin)
ent:SetSubMaterial(body, bodymat)
end

function Reflectron.SetHairCol(panel,col)
panel.HairCol = col
  for k,v in pairs(FalloutReflectronModels) do
    if IsValid(v) then
	  v:SetColor(col)
	end
  end
end

function Reflectron.SetGender(panel,gender)
local face = panel.Model
local model = nil
  if gender == "Female" then
    model = "models/fallout/player/female/default.mdl"
  else
    model = "models/pw_newvegas/player/default.mdl"
  end
panel.FacHair = 0
panel.Gender = gender
--
face:SetModel(model)
local bone = face.Entity:LookupBone("Bip01 Head")
local headpos = nil
  if bone then
    headpos = face.Entity:GetBonePosition(bone)
  else
    headpos = Vector(0,0,0)
  end
  if gender == "Male" then
	face:SetFOV(68)
  else
	face:SetFOV(70)
  end
  local seq = face:GetEntity():LookupSequence("mtidle")
  face:GetEntity():SetSequence(seq)
  --
  if gender == "Male" then
    face:SetLookAt(headpos+Vector(0,0,1))
	face:SetCamPos(headpos+Vector(18,6,4))
  else
    face:SetLookAt(headpos+Vector(-3,0,3))
	face:SetCamPos(headpos+Vector(18,6,4))
	Reflectron.SetFacial(panel,0)
  end
-------
Reflectron.SetRace(panel,panel.Ghoul or false)
Reflectron.SetHairCol(panel,Color(255,255,255))
end

function Reflectron.FinishChar(panel)
  if panel.Ghoul and !LocalPlayer():CanBeGhoul() then
    local Window = Derma_Query("To play as a Ghoul you must either apply on the forums or have the Donator rank!", "",
	"Ok", function() surface.PlaySound("ui/ok.mp3") end)
	Window.OldPaint = Window.Paint
	Window.Paint = function(me)
	  Derma_DrawBackgroundBlur(me, me.Time)
	  me:OldPaint()
	end
	panel:SetVisible(true)
	Reflectron.SetStage(panel,4)
    return
  end
--
panel.Parent:SetVisible(true)
panel:Remove()
--
local char_vars = {}
char_vars["Name"] = panel.Name
char_vars["Description"] = panel.Desc
char_vars["Model"] = 1
char_vars["Ghoul"] = panel.Ghoul
char_vars["Gender"] = panel.Gender
char_vars["Hair"] = panel.Hair
char_vars["Facial Hair"] = panel.FacHair
char_vars["HairCol"] = panel.HairCol
char_vars["Skin"] = panel.Skin
--
pig.CreateClientChar(char_vars)
end

function Reflectron.AskDesc(panel,invalid,desc)
  if !invalid then
    panel:SetVisible(false)
  end
  local title = "Enter your characters physical description"
  local default = desc or ""
    if invalid then
	  title = "Invalid description! Enter again"
	end
-------------
	Derma_StringRequest(
	"",
	title,
	default,
	function( text )
  	  pig.utility.CheckDescription(text,function()
        panel.Desc = text
		Reflectron.FinishChar(panel)
	  end,
	  function( )
	    Reflectron.AskDesc(panel,true,desc)
	  end) 
	end,
	function( text ) panel:SetVisible(true) Reflectron.SetStage(panel,4) end,
     "Accept","Back",true)
---------------
end

function Reflectron.AskName(panel,invalid,name)
  if !invalid then
    panel:SetVisible(false)
  end
  local title = "Enter your characters name"
  local default = name or "Courier"
    if invalid then
	  title = "Invalid name! Enter a new name"
	end
-------------
	Derma_StringRequest(
	"",
	title,
	default,
	function( text )
  	  pig.utility.CheckName(text,function()
        panel.Name = text
		Reflectron.AskDesc(panel)
	  end,
	  function()
	    Reflectron.AskName(panel,true,text)
	  end) 
	end,
	function( text ) panel:SetVisible(true) Reflectron.SetStage(panel,4) end,
     "Accept","Back",true)
---------------
end

function Reflectron.SetStage(panel,stage,load_screen,attempt)
stage = math.Clamp(stage,0,5)
  if stage == 0 then
    load_screen:SetVisible(true)
    panel:Remove()
  elseif stage == 5 then
    Reflectron.AskName(panel)
  return end
panel.Stage = stage
local parent = panel.List
local font = "FO3Font"
  for k,v in SortedPairs(parent:GetItems()) do
    v:Remove()
  end
  for k,v in SortedPairs(Plugin.FuncStage[stage] or {},false) do
    if v.Slider then
	  local base = vgui.Create("DPanel")
	  base:SetSize(parent:GetWide(),parent:GetTall() *.25)
	  base.Paint = function(me) 
	    local col = Plugin.RefColor
		  if panel.Glower == me then
	        draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,15))
		  end
		draw.SimpleText(v.Text,"FO3Font",me:GetWide() *.055,me:GetTall() *.05,col)
	  end
	  base.OnCursorEntered = function(me)
	    panel.Glower = me
		surface.PlaySound("ui/focus.mp3")
	  end
	  
	  local slider = vgui.Create("DSlider",base)
	  if pig.utility.IsFunction(v.Max) then
	    slider.Max = v.Max(panel)
	  else
	    slider.Max = v.Max	  
	  end
	  slider.Min = 0
	  slider.Val = math.Round(slider.Max/2)
	  slider:SetSize(base:GetWide() *.6,base:GetTall() *.4)
	  slider:SetPos(base:GetWide()/2-(slider:GetWide()/2),base:GetTall() - (slider:GetTall()))
	    slider.Think = function(me)
		  if me:GetDragging() and me.LastX and me.LastX != me.Knob.x then
		    me.Val = (me.Max*( me.Knob.x/(me:GetWide()-me.Knob:GetWide()) ))
			me.Val = math.Round(me.Val)
		    me.Val = math.Clamp(me.Val,me.Min,me.Max)
			me.ValueChanged(me,panel,me.Val)
		  end
		  me.LastX = me.Knob.x
		end
		slider.ValueChanged = function(me,panel,val)
		  v.ClickFunc(me,panel,val)
		end
	    slider.Paint = function(me)
		  local meh = me:GetTall() *.225
	      Fallout_Line(me:GetWide()*.1,me:GetTall()/2 - (meh/2),"right",me:GetWide()*.8,true,Plugin.RefColor,meh)
		 
		  surface.SetDrawColor(Plugin.RefColor)
		  surface.SetMaterial(Material("ui/left.png"))
		  surface.DrawTexturedRect(0,me:GetTall()/2 - (me:GetTall() *.325),me:GetWide()*.075,me:GetTall()*.75)
		
		  surface.SetDrawColor(Plugin.RefColor)
		  surface.SetMaterial(Material("ui/right.png"))
		  surface.DrawTexturedRect(me:GetWide() *.925,me:GetTall()/2 - (me:GetTall() *.325),me:GetWide()*.075,me:GetTall()*.75)
	    end
		slider.Knob.Paint = function(me)
		  Fallout_Line(me:GetWide()/2-(3/2),0,"down",me:GetTall(),true,Plugin.RefColor)
		end
	  parent:AddItem(base)
	continue end
    local but = pig.CreateButton(nil,"",font)
	but.Color = Plugin.RefColor
	but:SetSize(parent:GetWide(),panel:GetTall() *.05)
	but.Paint = function(me)
	local col = Plugin.RefColor
	    if me.ins then
	      draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,14))
	    end
		if panel.Glower == me then
		  local w = me:GetTall() *.265
		  local h = w
		  draw.RoundedBox(0,me:GetWide() *.05,me:GetTall()/2 - (h/2),w,h,col)
		end
	  draw.SimpleText(v.Text,font,me:GetWide() *.125, me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	end
	but.DoClick = function(me)
	  surface.PlaySound("ui/ok.mp3")
	  panel.Glower = me
	  v.ClickFunc(panel,me)
	end
	parent:AddItem(but)
  end
  if !attempt and stage == 4 then
    Reflectron.SetStage(panel,4,load_screen,true)
  end
end

function Plugin:pig_CreateScreen_Open(panel,load_screen)
panel:Remove()
--
  for k,v in pairs(FalloutReflectronModels) do
    if IsValid(v) then
	  v:Remove()
	  FalloutReflectronModels[k] = nil
	end
  end
--
load_screen.MakeScreen = vgui.Create("DFrame")
panel = load_screen.MakeScreen
panel.Parent = load_screen
panel:SetTitle("")
panel.Sub = {}
panel:ShowCloseButton(false)
panel:SetDraggable(false)
panel.Stage = 1
--------
  panel.Think = function(me)
    if !IsValid(load_screen) then
	  me:Remove()
	  return
	end
  end
panel:SetSize(ScrW()*.825,ScrH() *.95)
panel:Center()
panel:MakePopup()
panel.Make = SysTime()
  panel.Paint = function(me)
    Derma_DrawBackgroundBlur( me, me.Make )
  end
  panel.PaintOver = function(me)
    local mat = Plugin.Mat
	if mat:IsError() then return end
  	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
  end
-----------------
local charbox = vgui.Create("DPanel",panel)
charbox:SetSize(panel:GetWide()*.345,panel:GetTall() *.635)
charbox:SetPos(panel:GetWide()*.195,panel:GetTall() *.145)
  charbox.Paint = function(me)
    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(54,72,60))
  end

panel.Model = vgui.Create("DModelPanel",charbox)
local model = panel.Model
  model.PostDrawModel = function(self)
    for k,v in pairs(FalloutReflectronModels) do
	  if IsValid(v) then
	    v:DrawModel()
	  end
	end
  end
  model.OnRemove = function(me)
    if IsValid(me.Entity) then
	  me.Entity:Remove()
	end
    for k,v in pairs(FalloutReflectronModels) do
      if IsValid(v) then
	    v:Remove()
	    FalloutReflectronModels[k] = nil
	  end
    end
  end
-----
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
	self:DrawModel()
	local col = panel.HairCol or Color(255,255,255)
	render.SetColorModulation( col.r / 255, col.g / 255, col.b / 255 )
	render.SetBlend( ( self:GetAlpha() / 255 ) * 1 )		
	for k,v in pairs(FalloutReflectronModels) do
	  if IsValid(v) then
	    v:DrawModel()
	  end
	end
	render.SuppressEngineLighting( false )
	cam.End3D()
	self.LastPaint = RealTime()
  end
-----
model.Rotate = 30
  model.OnCursorEntered = function(me)
    me.ins = true
  end
  model.OnCursorExited = function(me)
    me.ins = false
  end
  model.Think = function(me)
  local cursorx = gui.MouseX()
  local cursory = gui.MouseY()
    if input.IsMouseDown(MOUSE_LEFT) and me.ins or me.Down and input.IsMouseDown(MOUSE_LEFT) then
	  local mx = me.MousePos.x
	  mx = cursorx -  math.Clamp( mx, 1, ScrW()-1 )
	  mx = mx/100
	  --
	  local ang = me.Rotate
	  me.Rotate = ang+mx
	  me.Down = true
	else
	  me.Down = false
	  me.MousePos = {x = cursorx, y = cursory}    
	end
  end
model:SetSize(charbox:GetSize())
model:SetModel("models/fallout/player/default.mdl")
model:SetAnimated(true)
  function model:LayoutEntity(ent)
   ent:SetAngles(Angle(0,self.Rotate,0))
    if ( self.bAnimated ) then
      self:RunAnimation()
    end
 end
------------------------
panel.Screen = vgui.Create("DFrame",panel)
local screen = panel.Screen
screen:SetDraggable(false)
screen:ShowCloseButton(false)
screen:SetTitle("")
screen:SetSize(panel:GetWide() *.205,panel:GetTall() *.48)
screen:SetPos(panel:GetWide() *.595,panel:GetTall() *.275)
screen.Paint = function(me) 
surface.SetDrawColor(255,255,255)
surface.SetMaterial(Material("ui/reflectron_back.png"))
surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
--
local stage = panel.Stage
draw.DrawText(stage..". "..Plugin.Stage[stage],"FO3Font",me:GetWide() *.05,me:GetTall() *.075,Plugin.RefColor,TEXT_ALIGN_LEFT)
end

local orig = screen:GetWide() *.1
local next = pig.CreateButton(screen,"NEXT","FO3Font")
next:SetTextColor(Plugin.RefColor)
next.Color = Plugin.RefColor
next:SetSize(screen:GetWide() *.25,screen:GetTall() *.075)
next:SetPos((screen:GetWide() - next:GetWide()) - orig,screen:GetTall() - next:GetTall())
next.DoClick = function(me)
  surface.PlaySound("ui/ok.mp3")
  Reflectron.SetStage(panel,panel.Stage+1)
end

local back = pig.CreateButton(screen,"BACK","FO3Font")
back:SetTextColor(Plugin.RefColor)
back.Color = Plugin.RefColor
back:SetSize(screen:GetWide() *.25,screen:GetTall() *.075)
back:SetPos(orig,screen:GetTall() - next:GetTall())
back.DoClick = function(me)
  surface.PlaySound("ui/ok.mp3") 
  Reflectron.SetStage(panel,panel.Stage-1,load_screen)
end
--
panel.List = vgui.Create("pig_PanelList",screen)
local list = panel.List
list.PaintCol = Plugin.RefColor
list:SetSize(screen:GetWide(),screen:GetTall() *.55)
list:Center()
----
Reflectron.SetStage(panel,1)
Reflectron.SetGender(panel,"Male")
end

----
------------------

Plugin.FuncStage[1] = {
  {Text = "Male",ClickFunc = function(panel,button)
      if panel.Gender == "Male" then return end
      Reflectron.SetGender(panel,"Male")
  end},
  {Text = "Female",ClickFunc = function(panel,button)
    if panel.Gender == "Female" then return end
    Reflectron.SetGender(panel,"Female")
  end}
}

Plugin.FuncStage[2] = {
  {Text = "Human",ClickFunc = function(panel,button)
    Reflectron.SetRace(panel,false)
  end},
  {Text = "Ghoul",ClickFunc = function(panel,button)
    Reflectron.SetRace(panel,true)
  end},
}

Plugin.FuncStage[3] = {
  {Text = "Ethnic Skins",Slider = true,Max = 2,ClickFunc = function(me,panel,val)
    Reflectron.SetSkin(panel,val)
  end},
  {Text = "Skin Types",Slider = true,Max = 10,ClickFunc = function(me,panel,val)
    Reflectron.SetSkin(panel,val+9)
  end}
}

Plugin.FuncStage[4] = {
  {Text = "Hair",Slider = true,Max = function(panel)
    if panel.Gender == "Female" then
	  return 25
	else
	  return 14
	end
  end,ClickFunc = function(me,panel,val)
    Reflectron.SetHair(panel,val)
  end},
  {Text = "Facial Hair",Slider = true,Max = 15,ClickFunc = function(me,panel,val)
    Reflectron.SetFacial(panel,val)
  end},
  {Text = "Hair Colour Red",Slider = true,Max = 255,ClickFunc = function(me,panel,val)
    Reflectron.SetHairCol(panel,Color(val,panel.HairCol.g,panel.HairCol.b))
  end},
  {Text = "Hair Colour Green",Slider = true,Max = 255,ClickFunc = function(me,panel,val)
    Reflectron.SetHairCol(panel,Color(panel.HairCol.r,val,panel.HairCol.b))
  end},  
  {Text = "Hair Colour Blue",Slider = true,Max = 255,ClickFunc = function(me,panel,val)
    Reflectron.SetHairCol(panel,Color(panel.HairCol.r,panel.HairCol.g,val))
  end}
}
------------------
-----
return Plugin