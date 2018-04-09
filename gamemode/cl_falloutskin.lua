MsgC(Color(104,144,204),"[New Vegas]: Derma Skin Loaded!\n")

function Derma_Query( strText, strTitle, ... )

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( "" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )
	Window:SetBackgroundBlur( true )
	Window:SetDrawOnTop( true )
	Window.Time = SysTime()
	Window.Paint = function(me)
	  FalloutBlur(me,9)
	  Fallout_HalfBox(me:GetWide() *.035,me:GetTall()*.15,me:GetWide(),me:GetTall(),me:GetTall()*.125)
	end

	local InnerPanel = vgui.Create( "DPanel", Window )
	Window.InnerPanel = InnerPanel
	InnerPanel:SetPaintBackground( false )

	local Text = vgui.Create( "DLabel", InnerPanel )
	Text:SetFont("FO3FontSmall")
	Text:SetText( strText or "Message Text (Second Parameter)" )
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( Schema.GameColor )

	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
	ButtonPanel:SetPaintBackground( false )
	Window.ButtonPanel = ButtonPanel

	-- Loop through all the options and create buttons for them.
	local NumOptions = 0
	local x = 5

	for k=1, 8, 2 do

		local Text = select( k, ... )
		if Text == nil then break end

		local Func = select( k+1, ... ) or function() end

		local Button = pig.CreateButton(ButtonPanel,Text,"FO3FontSmall")
		Button:SizeToContents()
		Button:SetTall( 20 )
		Button:SetWide( Button:GetWide() + 20 )
		Button.DoClick = function() Window:Close() Func() end
		Button:SetPos( x, 5 )

		x = x + Button:GetWide() + 5

		ButtonPanel:SetWide( x )
		NumOptions = NumOptions + 1

	end

	local w, h = Text:GetSize()

	w = math.max( w, ButtonPanel:GetWide() )

	Window:SetSize( w + 50, h + 25 + 45 + 10 )
	Window:SetTall(Window:GetTall() *1.25)
	Window:Center()

	InnerPanel:StretchToParent( 5, 25, 5, 45 )

	Text:StretchToParent( 5, 5, 5, 5 )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( Window:GetTall()*.165 )

	Window:MakePopup()
	Window:DoModal()

	if ( NumOptions == 0 ) then

		Window:Close()
		Error( "Derma_Query: Created Query with no Options!?" )
		return nil

	end

	return Window

end

function Derma_StringRequest( strTitle, strText, strDefaultText, fnEnter, fnCancel, strButtonText, strButtonCancelText, blur )

	local Window = vgui.Create( "DFrame" )
	Window:SetTitle( "" )
	Window:SetDraggable( false )
	Window:ShowCloseButton( false )
	Window:SetBackgroundBlur( true )
	Window:SetDrawOnTop( true )
	Window.Time = SysTime()
	Window.Paint = function(me)
	  if blur then
	    Derma_DrawBackgroundBlur(me,me.Time)
	  end
	  FalloutBlur(me,9)
	  Fallout_HalfBox(me:GetWide() *.035,me:GetTall()*.15,me:GetWide(),me:GetTall(),me:GetTall()*.125)
	end
	
	local InnerPanel = vgui.Create( "DPanel", Window )
	InnerPanel:SetPaintBackground( false )

	local Text = vgui.Create( "DLabel", InnerPanel )
	Text:SetFont("FO3FontSmall")
	Text:SetText( strText or "Message Text (Second Parameter)" )
	Text:SizeToContents()
	Text:SetContentAlignment( 5 )
	Text:SetTextColor( Schema.GameColor )

	local TextEntry = vgui.Create( "DTextEntry", InnerPanel )
	TextEntry:SetText( strDefaultText or "" )
	TextEntry:SetFont("FO3FontSmall")
	TextEntry:SetTextColor(Schema.GameColor)
	TextEntry:SetDrawBorder( false )
	TextEntry:SetDrawBackground( false )
	TextEntry:SetCursorColor(color_white)
	TextEntry.Paint = function(me)
	Fallout_Line(0,0,"right",me:GetWide(),true)
	Fallout_Line(0,me:GetTall() - 3,"right",me:GetWide(),true)
	Fallout_Line(0,0,"down",me:GetTall(),true)
	Fallout_Line(me:GetWide() - 3,0,"down",me:GetTall(),true)
	derma.SkinHook( "Paint", "TextEntry", me, me:GetWide(), me:GetTall() )
	end
	TextEntry.OnEnter = function() Window:Close() fnEnter( TextEntry:GetValue() ) end
	Window.TextEntry = TextEntry
	
	local ButtonPanel = vgui.Create( "DPanel", Window )
	ButtonPanel:SetTall( 30 )
	ButtonPanel:SetPaintBackground( false )
	Window.ButtonPanel = ButtonPanel

	local Button = pig.CreateButton(ButtonPanel,"OK","FO3FontSmall")
	Button:SetText( strButtonText or "OK" )
	Button:SizeToContents()
	Button:SetTall( 20 )
	Button:SetWide( Button:GetWide() + 20 )
	Button:SetPos( 5, 5 )
	Button.DoClick = function() Window:Close() fnEnter( TextEntry:GetValue() ) end
	Window.OK = Button

	local ButtonCancel = pig.CreateButton(ButtonPanel,"Cancel","FO3FontSmall")
	ButtonCancel:SetText( strButtonCancelText or "Cancel" )
	ButtonCancel:SizeToContents()
	ButtonCancel:SetTall( 20 )
	ButtonCancel:SetWide( Button:GetWide() + 20 )
	ButtonCancel:SetPos( 5, 5 )
	ButtonCancel.DoClick = function() Window:Close() if ( fnCancel ) then fnCancel( TextEntry:GetValue() ) end end
	ButtonCancel:MoveRightOf( Button, 5 )
	Window.Cancel = ButtonCancel

	ButtonPanel:SetWide( Button:GetWide() + 5 + ButtonCancel:GetWide() + 10 )

	local w, h = Text:GetSize()
	w = math.max( w, 400 )

	Window:SetSize( w + 50, h + 25 + 75 + 10 )
	Window:SetTall(Window:GetTall()*1.125)
	Window:Center()

	InnerPanel:StretchToParent( 5, 25, 5, 45 )

	Text:StretchToParent( 5, 5, 5, 35 )
	
	TextEntry:StretchToParent( 5, nil, 5, nil )
	TextEntry:SetWide(TextEntry:GetWide()*.85)
	TextEntry:SetTall(TextEntry:GetTall()*1.25)
	TextEntry:CenterHorizontal()
	TextEntry:AlignBottom( 5 )

	TextEntry:RequestFocus()
	TextEntry:SelectAllText( true )

	ButtonPanel:CenterHorizontal()
	ButtonPanel:AlignBottom( Window:GetTall()*.14 )

	Window:MakePopup()
	Window:DoModal()

	return Window

end

------------------------
--FALLOUT MOUSE
------------------------
vgui.AllElements = vgui.AllElements or {}
vgui.OldCreate = vgui.OldCreate or vgui.Create

hook.Add("Think", "hideCursor", function()
local all_panels = vgui.AllElements
  for k,v in pairs(all_panels) do
    if v and IsValid(v) then
	  if !v.blankCursor then
	    v:SetCursor("blank")
		v.blankCursor = true
	  end
	else
	  table.RemoveByValue(vgui.AllElements, v)
	end
  end
end)

function vgui.Create(...)
local pnl = vgui.OldCreate(...)
table.insert(vgui.AllElements, pnl)
return pnl;
end

local mouseCursor = Material("ui/facursor.png", "noclamp smooth")
function Schema.Hooks:PostRenderVGUI()
if !vgui.CursorVisible() then return end
  if PipBoy3000 and IsValid(PipBoy3000.Base) then
    if !vgui.ForceDrawCursor then
      return
	end
  end
--
local cw = 28
local mx, my = gui.MousePos()
surface.SetDrawColor(255,255,255)
surface.SetMaterial(mouseCursor)
surface.DrawTexturedRect(mx, my, cw, cw)
end
