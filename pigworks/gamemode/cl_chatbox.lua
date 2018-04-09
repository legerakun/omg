print("\n[PigWorks CHATBOX]: Client Chatbox loaded")
MsgC(Color(100,50,200),"[PigWorks CHATBOX]: Initialized!\n\n")
------
pig.ChatBox = pig.ChatBox or {}
--

hook.Add("PlayerBindPress","PW_ChatBox",function(ply,bind,pressed)
  if string.find(bind,"messagemode") then
	local bTeam = false
	if bind == "messagemode" then
	elseif bind == "messagemode2" then
		bTeam = true
	else
		return
	end
	  pig.ChatBox.openChatbox( bTeam )
	  return true
  end
end)

hook.Add("ChatText","PW_ChatBox",function(index,name,text,type)
  if !IsValid(pig.ChatBox.dFrame) then
	pig.ChatBox.buildChatbox()
  end
pig.ChatBox.lastMessage = CurTime()
pig.ChatBox.dTextEntry:SetVisible(true)
  if type == "joinleave" or type == "none" then
    local col = Schema.GameColor
    pig.ChatBox.dFrame.dRichText:InsertColorChange( col.r, col.g, col.b, 255 )
    pig.ChatBox.dFrame.dRichText:AppendText( text.."\n" )
	pig.ChatBox.dFrame.PreviewText:InsertColorChange( col.r, col.g, col.b, 255 )
	pig.ChatBox.dFrame.PreviewText:AppendText( text.."\n" )
	  timer.Create("PW_ChatBox_Prev",Schema.ChatFadeTime,1,function()
	    pig.ChatBox.dFrame.PreviewText:SetText("")
	  end)
	pig.ChatBox.dFrame.PreviewText:InsertFade(Schema.ChatFadeTime-1,1)
	pig.ChatBox.dFrame.PreviewText:GotoTextEnd( )
    pig.ChatBox.dFrame.dRichText:GotoTextEnd( )	
  end
end)

hook.Add("HUDShouldDraw","PW_ChatBox",function(name)
  	if name == "CHudChat" then
		return false
	end
end)

---------------------
function pig.ChatBox.buildChatbox()
  if IsValid(pig.ChatBox.dFrame) then
	pig.ChatBox.dFrame:Remove()
  end
    pig.ChatBox.dFrame = vgui.Create("DFrame")
	pig.ChatBox.dTextEntry = vgui.Create("DTextEntry",pig.ChatBox.dFrame)
	local col = Schema.GameColor
	local chatbox = pig.ChatBox.dFrame
	local textentry = pig.ChatBox.dTextEntry
	pig.ChatBox.dFrame.Show = false
	pig.ChatBox.dTextEntry.Show = false
    local new_w,new_h = hook.Call("pig_ChatBoxSize",GAMEMODE,chatbox)
	chatbox:SetSize(new_w or ScrW() *.3,new_h or ScrH() *.285)
	local new_x,new_y = hook.Call("pig_ChatBoxPos",GAMEMODE,chatbox)
	chatbox:SetPos(new_x or ScrW() *.025,new_y or ScrH() - chatbox:GetTall() - ScrH() *.165)
	chatbox:ShowCloseButton(false)
	chatbox.dRichText = vgui.Create("RichText",chatbox)
	local richtext = chatbox.dRichText
	local rw,rh = hook.Call("pig_ChatTextSize",GAMEMODE,chatbox,richtext)
	richtext:SetSize(rw or chatbox:GetWide() *.9,rh or chatbox:GetTall() *.6)
	richtext:SetPos(chatbox:GetWide()/2 - (richtext:GetWide()/2),chatbox:GetTall() *.145)
	richtext:GotoTextEnd()
	richtext.PerformLayout = function( self )
	    local font,fcol = hook.Call("pig_ChatBoxFont",GAMEMODE)
		self:SetFontInternal(font or "PigFont")
		self:SetFGColor( fcol or col )
	end
	
	chatbox.PreviewText = vgui.Create("RichText",chatbox)
	local preview = chatbox.PreviewText
	preview:SetSize(richtext:GetWide(), richtext:GetTall()*.75)
	local rx,ry = richtext:GetPos()
	local offset = richtext:GetTall()*.25
	preview:SetPos(rx,ry+offset)
	preview.PerformLayout = richtext.PerformLayout
	preview:SetVerticalScrollbarEnabled(false)
	
	local tw,th = hook.Call("pig_TextEntrySize",GAMEMODE,chatbox,textentry)
	textentry:SetSize(tw or chatbox:GetWide() *.875,th or chatbox:GetTall() *.11)
	local rx,ry = richtext:GetPos()
	textentry:SetPos(chatbox:GetWide()/2 - (textentry:GetWide()/2),chatbox:GetTall() *.9 - textentry:GetTall() - chatbox:GetTall() *.02)
	textentry:SetTextColor( color_white )
	local textfont = hook.Call("pig_TextEntryFont",GAMEMODE)
	textentry:SetFont(textfont or "PigFont")
	textentry:SetDrawBorder( false )
	textentry:SetDrawBackground( false )
	textentry:SetAllowNonAsciiCharacters(true);
	textentry:SetCursorColor( color_white )
	textentry:SetHighlightColor( Color(52, 152, 219) )
	textentry.Think = function(self)
	  local text = self:GetValue()
	  local len = text:len()
	  local max = pig.GetMaxChatChars()
	  if len > max then
	    text = text:sub(1,max)
	    self:SetText(text)
		self:SetCaretPos(text:len())
	  end
	end
	textentry.OnTextChanged = function( self )
	  local text = self:GetValue()
		if text then 
			gamemode.Call( "ChatTextChanged", text or "" )
		end
	end
	textentry.OnKeyCodeTyped = function( self, code )
	if code == KEY_ESCAPE then
		pig.ChatBox.closeChatbox()
		gui.HideGameUI()
	elseif code == KEY_ENTER then
	  local text = self:GetValue()
		if string.Trim( text ) != "" then
		    local can = hook.Call("pig_ChatBoxSendText",GAMEMODE,LocalPlayer(), text)
			if can == false then return end
			-----
			local replacers = {}
			replacers["//"] = "/ooc"
			replacers[".//"] = "/looc"
			replacers["./ooc"] = "/looc"
			
			for k,v in pairs(replacers) do
			  if text:find(k) then
			    text = string.gsub(text, k, v)
				break
			  end
			end
			-----
			pig.SendClientChat(text)
		end
		pig.ChatBox.closeChatbox()
	end
end

	chatbox:SetTitle("")
	chatbox:SetDraggable(false)
	--richtext:CenterVertical()
	chatbox.Think = function(me)
	  if me.Show then
	    me.PreviewText:SetVisible(false)
		me.dRichText:SetVisible(true)
		return
	  end
	  me.dRichText:SetVisible(false)
	  -----------
	  if pig.ChatBox.lastMessage != nil and CurTime() - pig.ChatBox.lastMessage > Schema.ChatFadeTime then
        --Times up
       me.PreviewText:SetVisible(false)
	  else
	  me.PreviewText:SetVisible(true)
	    --Still time
	  end
	end
	
	chatbox.Paint = function(me)
	if !me.Show then return end
	local paint = hook.Call("pig_ChatBoxPaint",GAMEMODE,me)
	  if paint != true then
	    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,100))
	  end
	end
    textentry.Paint = function(me)
	if !me.Show then return end
	local paint = hook.Call("pig_ChatTextEntryPaint",GAMEMODE,me)
	  if paint != true then
	    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,100))
	  end
	derma.SkinHook( "Paint", "TextEntry", me, me:GetWide(), me:GetTall() )
	end
	
end

function pig.ChatBox.openChatbox()
    if !IsValid(pig.ChatBox.dFrame) then
	  pig.ChatBox.buildChatbox()
	  return
	end
	pig.ChatBox.dFrame:MakePopup()
	pig.ChatBox.dTextEntry:RequestFocus()
	gamemode.Call( "StartChat" )
	hook.Call("pig_ChatBoxOpen", GAMEMODE)
	pig.ChatBox.dFrame.Show = true
	pig.ChatBox.dTextEntry.Show = true
	local textentry = pig.ChatBox.dTextEntry
	local col = Schema.GameColor
	textentry:SetTextColor( col )
	textentry:SetCursorColor( col )
end

function pig.ChatBox.closeChatbox()
	pig.ChatBox.dFrame.Show = false
	pig.ChatBox.dTextEntry.Show = false
	pig.ChatBox.dFrame:SetMouseInputEnabled( false )
	pig.ChatBox.dFrame:SetKeyboardInputEnabled( false )
	gui.EnableScreenClicker( false )
	gamemode.Call( "FinishChat" )
	pig.ChatBox.dTextEntry:SetText( "" )
	gamemode.Call( "ChatTextChanged", "" )
	pig.ChatBox.lastMessage = pig.ChatBox.lastMessage or CurTime() - Schema.ChatFadeTime
end

function pig.ChatBox.IsOpen()
  if IsValid(pig.ChatBox.dFrame) and pig.ChatBox.dFrame.Show then
    return true
  end
end
---------------------

chat.PigText = chat.PigText or chat.AddText
function chat.AddText( ... )
if !IsValid(pig.ChatBox.dFrame) then
	pig.ChatBox.buildChatbox()
	return
end
if LocalPlayer() == nil or !IsValid(LocalPlayer()) then return end
surface.PlaySound(Schema.ChatSound or "")
	local args = { ... } -- Create a table of varargs
    local preview = pig.ChatBox.dFrame.PreviewText
	local richtext = pig.ChatBox.dFrame.dRichText
	for _, obj in pairs( args ) do
		if type( obj ) == "table" then -- We were passed a color object
			richtext:InsertColorChange( obj.r, obj.g, obj.b, 255 )
			    preview:InsertColorChange( obj.r, obj.g, obj.b, 255 )
			    preview:InsertFade(Schema.ChatFadeTime-1,1)
		elseif type( obj ) == "string" then -- This is just a string
			richtext:AppendText( obj )
			preview:AppendText( obj )
		elseif obj:IsPlayer() then
			local col = Schema.GameColor
			local colhook = hook.Call("pig_ChatTextCol",GAMEMODE,obj)
			col = colhook or col
			richtext:InsertColorChange( col.r, col.g, col.b, 255 ) -- Make their name that color
			richtext:AppendText( obj:Nick() )
			    preview:InsertColorChange( col.r, col.g, col.b, 255 )
				preview:AppendText( obj:Nick() )		
		end
	end
	richtext:AppendText( "\n" )
	richtext:GotoTextEnd( )
	    timer.Create("PW_ChatBox_Prev",Schema.ChatFadeTime,1,function()
		  pig.ChatBox.dFrame.PreviewText:SetText("")
		end)
	preview:InsertFade(Schema.ChatFadeTime-1,1)
	preview:AppendText("\n")
	preview:GotoTextEnd( )
	
	pig.ChatBox.lastMessage = CurTime()
	chat.PigText( ... )
end

-------------------
--Network Chat
hook.Add("StartChat","NetworkStart",function()
net.Start("PW_SChat")
net.SendToServer()
end)
hook.Add("FinishChat","NetworkStart",function()
net.Start("PW_FChat")
net.SendToServer()
end)
-------------------

concommand.Add("PW_RebuildChatbox",function(ply)
pig.ChatBox.buildChatbox()
end)
