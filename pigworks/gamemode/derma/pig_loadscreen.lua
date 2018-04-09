local PANEL = {}

function PANEL:Init()
self.CharBox = {}
self.NonModify = true

self.CharBox["Name"] = {
Title = "Name",
Desc = "Enter full name",
Font = "PigFont",
Text = true,
CheckBox = false,
Slider = false
}
self.CharBox["Desc"] = {
Title = "Description",
Desc = "Enter description",
Font = "PigFont",
Text = true,
CheckBox = false,
Slider = false
}
self.CharBox["Gender"] = {
Title = "Gender",
Desc = "Are you male?",
Font = "PigFont",
Text = false,
CheckBox = true,
Slider = false,
OnChange = function(me)
if me:GetChecked() then
self.Male = true
self.MakeScreen.ModelBackground.Model:SetModel(Schema.GuyModels[1])
else
self.Male = false
self.MakeScreen.ModelBackground.Model:SetModel(Schema.GirlModels[1])
end
end
}
self.CharBox["Model"] = {
Title = "Model",
Desc = "Select Model",
Font = "PigFont",
Text = false,
CheckBox = false,
Slider = true,
Max = #Schema.GuyModels,
Min = 1,
OnValueChanged = function(me)
if self.Male then
me:SetMax(#Schema.GuyModels)
self.MakeScreen.ModelBackground.Model:SetModel(Schema.GuyModels[math.Round(me:GetValue())])
else
me:SetMax(#Schema.GirlModels)
self.MakeScreen.ModelBackground.Model:SetModel(Schema.GirlModels[math.Round(me:GetValue())])
end
end
}

self:ShowCloseButton(false)
self:SetTitle("")
self:SetDraggable(false)
self:SetSize(ScrW()*.225,ScrH())
self:MakePopup()
self:SetBackgroundBlur( true )
self.NewChar = pig.CreateButton(self,"Create..","PigFont")
local NewChar = self.NewChar
NewChar:SetSize(self:GetWide() *.725,self:GetTall() *.11)
NewChar:SetPos(0,self:GetTall() *.3)
NewChar:CenterHorizontal()
NewChar.DoClick = function()
self:CreateScreen()
end
self.LoadChar = pig.CreateButton(self,"Load..","PigFont")
local LoadChar = self.LoadChar
LoadChar:SetSize(self:GetWide() *.725,self:GetTall() *.11)
LoadChar:SetPos(0,self:GetTall() *.35 + NewChar:GetTall())
LoadChar:CenterHorizontal()
LoadChar.DoClick = function()
self:LoadCharScreen()
end

hook.Call("pig_LoadScreen_Open",GAMEMODE,self)
end  

function PANEL:CreateScreen()
if ClientCharacterTable then
if table.Count(ClientCharacterTable) >= Schema.MaxChar and !LocalPlayer():IsDonator() or table.Count(ClientCharacterTable) >= Schema.MaxCharVIP and LocalPlayer():IsDonator() then
pig.Notify(Color(204,0,0),"You cannot create any more characters!",2,nil,false,true)
return end
end
self:SetVisible(false)
if IsValid(self.MakeScreen) then
self.MakeScreen:Remove()
end
self.MakeScreen = vgui.Create("pig_Frame")
self.MakeScreen:SetSize(ScrW() *.5,ScrH() *.625)
self.MakeScreen:MakePopup()
self.MakeScreen:Center()
self.MakeScreen.Parent = self
self.MakeScreen.Think = function(me)
if !IsValid(self) then 
me:Remove()
return end
end
local mainframe = self.MakeScreen
mainframe.ModelBackground = vgui.Create("DPanel",mainframe)
local background = mainframe.ModelBackground
background.Model = vgui.Create("DModelPanel",background)
---------
local model = background.Model
mainframe.Options = vgui.Create("pig_PanelList",mainframe)
local options = mainframe.Options
options:SetSize(mainframe:GetWide() / 2,mainframe:GetTall() *.815)
options:EnableVerticalScrollbar(true)
options:EnableHorizontal(true)
options:SetPos(self:GetWide() *.05,0)
options:CenterVertical()
options:SetSpacing(self:GetWide() *.05)
for k,v in SortedPairs(self.CharBox,true) do
local base = vgui.Create("DFrame")
base:SetDraggable(false)
base:ShowCloseButton(false)
base:SetTitle("")
base.Titles = v.Title
base.Descs = v.Desc
base:SetSize(options:GetWide(),mainframe:GetTall() *.225)
base.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
draw.RoundedBox( 2, 0, 0, me:GetWide(), me:GetTall(), Color(0,0,0,165) )
draw.SimpleText(v.Title, v.Font, me:GetWide() / 2, me:GetTall() *.135, Color(255,255,255,255), 1, 1)
draw.SimpleText(v.Desc, "PigFontSmall", me:GetWide() / 2, me:GetTall() *.375, Color(255,255,255,255), 1, 1)
end
if v.Text then
base.Text = vgui.Create("DTextEntry",base)
local based = base.Text
based:SetSize(base:GetWide() *.875,base:GetTall() *.25)
based:SetFont("PigFontSmall")
based:SetPos(0,base:GetTall() *.575)
based:CenterHorizontal()
elseif v.CheckBox then
base.CheckBox = vgui.Create("DCheckBox",base)
local based = base.CheckBox
based:SetSize(base:GetWide() *.05,base:GetTall() *.15)
based:SetValue(0)
based:SetPos(0,base:GetTall() *.675)
based:CenterHorizontal()
based.OnChange = v.OnChange
elseif v.Slider then
base.Slider = vgui.Create("DNumSlider",base)
local based = base.Slider
based:SetSize(base:GetWide() *.75,base:GetTall() *.2)
based:SetPos(base:GetWide() *.025,base:GetTall() *.75)
based:SetMin(v.Min)
based:SetDecimals(0)
based:SetMax(v.Max)
based.OnValueChanged = v.OnValueChanged
elseif v.ColorPalette then
base.ColorPalette = vgui.Create("DColorPalette",base)
local based = base.ColorPalette
based:SetSize(base:GetWide() *.45,base:GetTall() *.35)
based:SetPos(0,base:GetTall() *.575)
based:CenterHorizontal()
based.OnValueChanged = v.OnValueChanged
end
options:AddItem(base)
end

background:SetSize(mainframe:GetWide() *.425,mainframe:GetTall() *.815)
background:SetPos(mainframe:GetWide() *.55,0)
background:CenterVertical()
background.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
draw.RoundedBox( 2, 0, 0, me:GetWide(), me:GetTall(), Color(0,0,0,165) )
end

model:SetSize(background:GetWide(),background:GetTall() *.725)
model:SetModel(Schema.GirlModels[1])
function model:LayoutEntity( ent ) return end
model:SetCamPos(Vector(18,-7.25,65))
local bone = model.Entity:LookupBone("ValveBiped.Bip01_Head1")
local headpos = nil
  if bone then
    headpos = model.Entity:GetBonePosition(bone)
  else
    headpos = Vector(0,0,0)
  end
model:SetLookAt(headpos-Vector(30,-10,0))
--
mainframe.Back = pig.CreateButton(self.MakeScreen,"Back","PigFontTiny")
local back = mainframe.Back
mainframe:ShowClose(false)
back:SetPos(mainframe:GetWide() *.025,mainframe:GetTall() *.025)
back:SetSize(mainframe:GetWide() *.075,mainframe:GetTall() *.05)
back.DoClick = function()
self.MakeScreen:Remove()
self:SetVisible(true)
end
--
mainframe.Done = pig.CreateButton(self.MakeScreen,"Done","PigFontTiny")
local done = mainframe.Done
done:SetPos(mainframe:GetWide() *.225,mainframe:GetTall() *.025)
done:SetSize(mainframe:GetWide() *.075,mainframe:GetTall() *.05)
done.DoClick = function(me)
for k,v in pairs(mainframe.Options:GetItems()) do
if v.Text and v.Text:GetValue() == "" or v.Text and string.sub(v.Text:GetValue(),1,1) == " " or v.Text and string.len(v.Text:GetValue()) < Schema.MinimumChar then
me:SetTextColor(Color(204,0,0))
me.NotFinished = true
return
end
end
---------
local tbl = {}
for k,v in pairs(mainframe.Options:GetItems()) do
if v.Text then
tbl[v.Titles] = v.Text:GetValue()
elseif v.CheckBox then
if v.CheckBox:GetChecked() then
tbl[v.Titles] = "Male"
else
tbl[v.Titles] = "Female"
end
elseif v.Slider then
tbl[v.Titles] = math.Round(v.Slider:GetValue())
elseif v.ColorPalette then
tbl[v.Titles] = model:GetColor()
end
end
self.MakeScreen:Remove()
self:SetVisible(true)
pig.CreateClientChar(tbl)
end
hook.Call("pig_CreateScreen_Open",GAMEMODE,self.MakeScreen,self)
end

function PANEL:LoadCharScreen()
self:SetVisible(false)
if IsValid(self.LoadScreen) then
self.LoadScreen:Remove()
end
self.LoadScreen = vgui.Create("pig_Frame")
self.LoadScreen.FromLoadScreen = true
self.LoadScreen:SetSize(ScrW() *.5,ScrH() *.625)
self.LoadScreen:MakePopup()
self.LoadScreen.Parent = self
self.LoadScreen:Center()
self.LoadScreen.Think = function(me)
if !IsValid(self) then 
me:Remove()
return end
end
local mainframe = self.LoadScreen
mainframe.Back = pig.CreateButton(self.LoadScreen,"Back","PigFontTiny")
local back = mainframe.Back
mainframe:ShowClose(false)
back:SetPos(mainframe:GetWide() *.025,mainframe:GetTall() *.025)
back:SetSize(mainframe:GetWide() *.075,mainframe:GetTall() *.05)
back.DoClick = function()
self.LoadScreen:Remove()
self:SetVisible(true)
end

mainframe.CharList = vgui.Create("pig_PanelList",mainframe)
local charList = mainframe.CharList
charList:SetSize(mainframe:GetWide() *.45,mainframe:GetTall() *.825)
charList:SetPos(mainframe:GetWide() *.05,0)
charList:CenterVertical()
charList:EnableVerticalScrollbar(true)
charList:EnableHorizontal(true)
charList:SetSpacing(5)
charList.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
end

mainframe.PreviewModel = vgui.Create("DModelPanel",mainframe)
local prev_model = mainframe.PreviewModel
prev_model:SetSize(mainframe:GetWide() *.4,mainframe:GetTall() *.525)
local cx,cy = charList:GetPos()
prev_model:SetPos(mainframe:GetWide() *.1 + charList:GetWide(),cy)
prev_model.DoClick = function()
if mainframe.SelectedChar == nil then return end
self.LoadScreen:Remove()
self:Remove()
pig.SelectCharacter(mainframe.SelectedChar)
end

mainframe.InfoPanel = vgui.Create("DPanel",mainframe)
local infoPanel = mainframe.InfoPanel
infoPanel:SetSize(prev_model:GetWide(),mainframe:GetTall() *.225)
local px,py = prev_model:GetPos()
infoPanel:SetPos(px,py + prev_model:GetTall() + mainframe:GetTall() *.075)
infoPanel.Paint = function(me)
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, me:GetWide(), me:GetTall() )
draw.SimpleText("Level: "..(mainframe.SelectedLevel or "..."), "PigFont", me:GetWide() / 2, me:GetTall() *.025, Schema.GameColor, TEXT_ALIGN_CENTER,TEXT_ALIGN_LEFT)
end
---
infoPanel.Text = vgui.Create("DLabel",infoPanel)
local text = infoPanel.Text
text:SetPos(infoPanel:GetWide() *.05,infoPanel:GetTall() *.425)
text:SetFont("PigFont")
text:SetText("Name: ...\n"..Schema.Currency..": ...")
text:SetTextColor(Schema.GameColor)
text:SizeToContents()

for k,v in pairs(ClientCharacterTable or {}) do
local but = pig.CreateButton(mainframe,"","PigFont")
but.vars = {}
  for a,b in pairs(ClientCharVar) do
    if b.char_id == v.char_id then
      if tonumber(b.var) != nil then b.var = tonumber(b.var)
      end
      but.vars[b.varname] = b.var
    end
  end
local vars = but.vars
but:SetText(vars.Name or "")
but.char_id = v.char_id
but:SetSize(charList:GetWide(),mainframe:GetTall() *.2)
but.DoClick = function(me)
mainframe.SelectedChar = me.char_id
if me.vars.Gender == "Male" then
prev_model:SetModel(Schema.GuyModels[me.vars.Model])
else
prev_model:SetModel(Schema.GirlModels[me.vars.Model])
end
prev_model:SetCamPos(Vector(18,-7.25,65))
local bone = prev_model.Entity:LookupBone("ValveBiped.Bip01_Head1")
local headpos = nil
  if bone then
    headpos = prev_model.Entity:GetBonePosition(bone)
  else
    headpos = Vector(0,0,0)
  end
prev_model:SetLookAt(headpos-Vector(30,-10,0))
text:SetText("Name: "..vars.Name.."\n"..Schema.Currency..": "..(vars.Money or Schema.StartingMoney))
text:SizeToContents()
mainframe.SelectedLevel = vars.Level or 1
end
charList:AddItem(but)
end

hook.Call("pig_LoadChar_Open",GAMEMODE,self.LoadScreen,self)
end

function PANEL:Paint()
Derma_DrawBackgroundBlur( self, SysTime() - 10 )
surface.SetDrawColor( Schema.GameColor )
surface.DrawOutlinedRect( 0,0, self:GetWide(), self:GetTall() )
draw.RoundedBox( 2, 0, 0, self:GetWide(), self:GetTall(), Color(0,0,0,105) )
end

vgui.Register("pig_LoadScreen", PANEL, "DFrame")