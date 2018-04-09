
surface.CreateFont( "FO3FontChat",
{
	    font = "Monofonto",
		size      = ScreenScale(7.75),
		weight    = 0,
		shadow = true,
		antialias = true,
	    blursize = 0,
	    scanlines = 1,
	})
surface.CreateFont( "FO3FontChat_Blur",
{
	    font = "Monofonto",
		size      = ScreenScale(7.75),
		weight    = 400,
		antialias = true,
	    blursize = 4,
	    scanlines = 1,
	})	

function Schema.Hooks:pig_ChatBoxSize(chatbox)
return ScrW() *.35,ScrH() *.311
end

function Schema.Hooks:pig_ChatBoxPos(chatbox)
local mw,mh = chatbox:GetSize()
local w,h,x,y = FalloutHUDSize()
return x-ScrW()*.02,(y-mh)-ScrH() *.02
end

function Schema.Hooks:pig_ChatBoxFont()
local font = pig.ChatBox.OverrideFont or "FO3FontChat"
return font,Schema.GameColor
end

function Schema.Hooks:pig_TextEntryFont()
return "FO3FontChat"
end

function Schema.Hooks:pig_TextEntrySize(chatbox,textentry)
local cbox = chatbox
local preview = cbox.PreviewText
local richtext = cbox.dRichText
local col = Schema.GameColor
--
local fancytext = vgui.Create("DFancyText", chatbox)
fancytext:SetPos(richtext:GetPos())
fancytext:SetSize(richtext:GetSize())
local font,fcol = hook.Call("pig_ChatBoxFont",GAMEMODE)
fancytext:SetFontInternal(font or "PigFont")
fancytext:SetFGColor( fcol or col )

local fancypreview = vgui.Create("DFancyText", chatbox)
fancypreview:SetPos(preview:GetPos())
fancypreview:SetSize(preview:GetSize())
fancypreview:SetVerticalScrollbarEnabled(false)
fancypreview:SetFontInternal(font or "PigFont")
fancypreview:SetFGColor( fcol or col )

preview:Remove()
richtext:Remove()

cbox.dRichText = fancytext
cbox.PreviewText = fancypreview
--
return chatbox:GetWide() *.85,chatbox:GetTall() *.1
end

function Schema.Hooks:pig_ChatTextSize(chatbox,richtext)
return chatbox:GetWide()*.825,chatbox:GetTall() *.6
end

function Schema.Hooks:pig_ChatTextEntryPaint(me)
Fallout_HalfBox(0,0,me:GetWide(),me:GetTall(),me:GetTall()*.375)
--
return true
end

function Schema.Hooks:pig_ChatBoxPaint(me)
FalloutBlur(me,10)
--
local blur_x = me:GetWide() *.05
local blur_y = me:GetTall() *.08

Fallout_HalfBox(blur_x,blur_y,me:GetWide(),me:GetTall(),me:GetTall()*.1)
--
return true
end
