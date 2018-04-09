-----------------------------
--Lemon Punch greeting
function Atlas_ShowGreeting()
  if IsValid(pig.vgui.AtlasGreet) then
    pig.vgui.AtlasGreet:Remove()
  end
pig.vgui.AtlasGreet = vgui.Create("Fallout_Frame")
local lp_greet = pig.vgui.AtlasGreet
lp_greet:MakePopup()
lp_greet:SetSize(ScrW()*.6,ScrH()*.7)
lp_greet:Center()
lp_greet:ShowClose(true)
lp_greet:SetTitle1("WELCOME TO ATLAS 5")
lp_greet.DownWidth = lp_greet:GetTall()*.1
local mat = Material("atlas/a5new.png", "noclamp smooth")
  lp_greet.SecondaryPaint = function(me)
	local w = me:GetWide()*.265
	local h = me:GetTall()*.12
    surface.SetDrawColor(255,255,255)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(me:GetWide()/2 - (w/2),me:GetTall()*.075,w,h)
  end
--  
-------
local greeting = "Greetings "..LocalPlayer():GetName().."! Welcome to Atlas 5, the home of "..GAMEMODE.Name..". If you are ever stuck, remember to look at the help section or ask in chat. If you are interested in updates from us, make sure visit the steam group and sign up to our forums! In the forums, you can apply for factions, apply to be wasteland creatures, apply to be unique/special characters, apply for a position in our staff team, see trending topics and interact with our members outside of the gamemode.\n\nWe appologise for the downtime but now we're back and better than ever!\n\nWe hope you enjoy your experience with us, now get out there, develop your character and experience the Wasteland!"
---------------------

local text1,text2 = Fallout_DLabel(lp_greet,0,lp_greet:GetTall()*.225,greeting,"FO3Font",Schema.GameColor)
text1:SetWide(lp_greet:GetWide()*.8)
text1:CenterHorizontal()
text2:SetWide(lp_greet:GetWide()*.8)
text2:CenterHorizontal()
--
local close = lp_greet.CloseButton
close.OldClick = close.DoClick
  close.DoClick = function(me)
    local intro_sound = CreateSound(LocalPlayer(), "nv_ambiant/openings.mp3")
	intro_sound:Play()
	intro_sound:ChangeVolume(1)
	timer.Simple(30, function()
	  if intro_sound == nil then return end
	  intro_sound:Stop()
	end)
	FalloutTutorial("Pip-Boy")
	me:OldClick()
  end
end

function Schema.Hooks:pig_FirstTimeConnected(ply)
LocalPlayer().FirstTimer = true
end

concommand.Add("Atlas_ShowGreeting",function()
Atlas_ShowGreeting()
end)
------------------------
--TAG SKILLS
function Fallout_TagSkills(amt)
  if IsValid(pig.vgui.Tag) then
    pig.vgui.Tag:Remove()
  end
amt = amt or 3
local max = 0
local skillpoints = LocalPlayer():GetSkillPoints()
  for i=1,amt do
    if 15*i > skillpoints then break end
	max = i
  end
local selected = amt-max
----
pig.vgui.Tag = vgui.Create("pig_Attributes")
local tag = pig.vgui.Tag
tag.Tagged = selected
tag.TagTbl = {}
tag:Center()
tag:MakePopup()
tag.Title:Remove()
tag.Blur:Remove()
tag.DownText = "Tag "..amt.." Skills"
tag.DownFont = "FO3Font"
tag.Title,blur = Fallout_DLabel(tag,tag:GetWide()*.075,tag:GetTall()*.02,"TAG "..selected.."/"..amt.." SKILLS","FO3FontBig",Schema.GameColor)
local old = tag.Reset.DoClick
  tag.Reset.DoClick = function(me)
    old(me)
	tag.Title:SetText("TAG "..selected.."/"..amt.." SKILLS")
	blur:SetText(tag.Title:GetText())
	tag.Tagged = selected
	tag.TagTbl = {}
  end

local closeold = tag.CloseButton.DoClick
  tag.CloseButton.DoClick = function(me)
    if tag.Tagged < amt then return end
	if LocalPlayer().FirstTimer then
	  LocalPlayer().FirstTimer = false
	  Atlas_ShowGreeting()
	end
    closeold(me)
  end
 
 for k,v in pairs(tag.AttributeTable:GetItems()) do
    v.oldPaint = v.Paint
	v.DoClick = function(me)
	  if table.HasValue(tag.TagTbl,v.Attribute) then
	    table.RemoveByValue(tag.TagTbl,v.Attribute)
		tag.Tagged = tag.Tagged-1
		me.Val = me.Orig
		tag.Title:SetText("TAG "..tag.Tagged.."/"..amt.." SKILLS")
	    blur:SetText(tag.Title:GetText())
		surface.PlaySound("ui/ok.mp3")
		return
	  elseif tag.Tagged >= amt then return end
	  surface.PlaySound("ui/ok.mp3")
	  me.Val = math.Clamp(me.Orig+15,0,100)
	  tag.Tagged = tag.Tagged+1
	  tag.TagTbl[tag.Tagged] = v.Attribute
	  tag.Title:SetText("TAG "..tag.Tagged.."/"..amt.." SKILLS")
	  blur:SetText(tag.Title:GetText())
	end
	v.Paint = function(me)
	  me.oldPaint(me)
	  if table.HasValue(tag.TagTbl,v.Attribute) then
	    local dw = me:GetTall()*.3
	    surface.SetDrawColor(Schema.GameColor)
		surface.DrawRect(me:GetWide()*.025,me:GetTall()/2 - (dw/2),dw,dw)
	  end
	end
    v.plus:Remove()
	v.minus:Remove()
  end
end

concommand.Add("test_Tag",function()
Fallout_TagSkills()
end)
------------------------