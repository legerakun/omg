
if SERVER then
util.AddNetworkString("PW_ActualChat")
util.AddNetworkString("PW_ChatPrint")
util.AddNetworkString("PW_SendChat")
util.AddNetworkString("PW_SChat")
util.AddNetworkString("PW_FChat")

function GM:PlayerSay(ply,text,team)
  if !ply:GetCharID() then
    local tbl = Schema.ChatCommands["OOC"]
	if tbl then
	  pig.AddChat("OOC",text,ply)
	end
    return ""
  end
  if text == "/drop" then
    pig_DropWeapon(ply)
    return ""
  end
  if string.sub(text,1,1) == "/" then
    local index = nil
    text = string.gsub(text,"/","")
    for k,v in pairs(Schema.ChatCommands) do
      if v.cmd == string.sub(text,1,string.len(v.cmd)) then
        index = k
        break
      end
    end
    if !Schema.ChatCommands[index] then 
      PW_Notify(ply,Color(204,0,0),"Unknown Chat Command!")
      return ""
    end
local tbl = Schema.ChatCommands[index]
local toreplace = string.sub(text,1,string.len(tbl.cmd) + 1)

local cmd = string.sub(text,1,string.len(tbl.cmd))
local oldtext = string.gsub(text,toreplace,"")
local contin,reptext = hook.Call("pig_PrePlayerCommand",GAMEMODE,ply,cmd,oldtext)
text = reptext or text
if contin == false then return "" end
--
  if tbl.non_text_callback then
    local funcs = tbl.func
    funcs(ply,text)
    return ""
  elseif tbl.ClientFunc then
    pig.AddChat(index, text, ply)
	return ""
  end
text = string.gsub(text,toreplace,"")
local hooks = hook.Call("pig_PostPlayerCommand",GAMEMODE,ply,text)
  if hooks then
    text = hooks
  end
  if !tbl.global then
      for k,v in pairs(ents.FindInSphere(ply:GetPos(),tbl.range)) do
        if v:IsPlayer() then
        pig.AddChat(index,text,ply,v)
      end
    end
  else
    pig.AddChat(index,text,ply,nil)
  end
  return ""
end
local name = ply:Name()
local should = hook.Call("pig_PlayerNormalChat",GAMEMODE,ply,Schema.TalkRadius,text)
  if should != false then
    for k,v in pairs(ents.FindInSphere(ply:GetPos(),Schema.TalkRadius)) do
      if v:IsPlayer() then
        pig.AddChat("..",text,ply,v,nil)
      end
    end
  end
  return ""
end

function pig.ChatPrint(ply,color,text)
net.Start("PW_ChatPrint")
net.WriteTable(color or {})
net.WriteString(text)
net.Send(ply)
end

function pig.ChatPrintAll(text,color)
net.Start("PW_ChatPrint")
net.WriteTable(color or {})
net.WriteString(text)
net.Broadcast()
end

function pig.AddChat(tbl_index,text,typer,reader,col)
net.Start("PW_ActualChat")
net.WriteString(tbl_index)
net.WriteString(text)
net.WriteEntity(typer)
if !col then col = {} end
  if Schema.ChatCommands[tbl_index] then
    local tbl = Schema.ChatCommands[tbl_index]
      if tbl.col then
        col = tbl.col
      end
  end
net.WriteTable(col)
  if reader != nil and reader:IsPlayer() then
    net.Send(reader)
  else
    net.Broadcast()
  end
end

net.Receive("PW_SendChat",function(_,ply)
local defaultMax = pig.GetMaxChatChars()
local text = net.ReadString()
  if text:len() > defaultMax then
    text = text:sub(1,defaultMax)
  end
hook.Run("PlayerSay", ply, text, false)
end)

net.Receive("PW_SChat",function(_,ply)
ply:SetNWBool("PigTyping",true)
end)

net.Receive("PW_FChat",function(_,ply)
ply:SetNWBool("PigTyping",false)
end)

end

local char = FindMetaTable("Player")
function char:IsTypingChat()
  if self:GetNWBool("PigTyping",false) == true then
    return true
  end
end

function pig.GetMaxChatChars()
local defaultMax = 420
return Schema.MaxChatChars or defaultMax
end

if CLIENT then

function GM:pig_ChatName(ply,tbl)
  if LocalPlayer():Recognises(ply) or tbl and tbl.global then
    return ply:Name()
  else
    local max = 24
	  if ply:GetDesc():len() < max then
	    max = ply:GetDesc():len()
	  end
	local ret = string.sub(ply:GetDesc(),1,max)
	ret = "'"..ret.."...'"
    return ret
  end
end

net.Receive("PW_ActualChat",function()
local index = net.ReadString()
local text = net.ReadString()
local ply = net.ReadEntity()
local col = net.ReadTable()
local team = ply:Team()
local tbl = Schema.ChatCommands[index]
local funcs = nil
local tag = ""
  if tbl and tbl.ClientFunc then
    tbl.ClientFunc(ply, text)
	return
  elseif tbl then
    funcs = tbl.func
    col = tbl.col
    tag = tbl.tag
    tag_col = tbl.tag_col
  end
--
  if !col or !col.r or !col.g or !col.b then
    col = Schema.GameColor
  end
--
local name = ply:Name()
local new_name = hook.Call("pig_ChatName",GAMEMODE,ply,tbl)
name = new_name or name
local time = os.time()
local timestring = os.date( "%H:%M" , time )
local timecol = Color(150,150,150)
  if tbl then
    local sign = tbl.sign
	local speech = tbl.speech
	local namecol = tbl.namecol or tag_col
	local sign_col = tbl.sign_col
	  if speech then
	    text = '"'..text..'"'
	  end
	  if tbl.UseCharName then
	    name = ply:Name()
	  end
	--
	hook.Call("pig_PreChatCom", GAMEMODE, tbl, text)
	--
	local timestamp = pig.GetOption("TimeStamp")

	if timestamp != false then
	  chat.AddText(timecol,"("..timestring..") ", tag_col or col, tag.." ", namecol, name, sign_col or namecol, ""..sign.." ", col, text)
    else
	  chat.AddText(tag_col or col, tag.." ", namecol, name, sign_col or namecol, ""..sign.." ", col, text)
	end
    --
	hook.Call("pig_PostChatCom", GAMEMODE, tbl, text)
  else
  	local timestamp = pig.GetOption("TimeStamp")
	if timestamp != false then
	  chat.AddText(timecol,"("..timestring..") ", col," "..name.."", Color(250, 250, 160), " says ", col, '"'..text..'"')
    else
	  chat.AddText(col," "..name.."", Color(250, 250, 160), " says ", col, '"'..text..'"')
	end
  end
end)

net.Receive("PW_ChatPrint",function()
local color = net.ReadTable()
local text = net.ReadString()
  if !color.r then
    color = Schema.GameColor
  end
chat.AddText(color,text)
end)

function pig.SendClientChat(text)
local defaultMax = pig.GetMaxChatChars()
  if text:len() > defaultMax then
    text = text:sub(1,defaultMax)
  end
net.Start("PW_SendChat")
net.WriteString(text)
net.SendToServer()
end

function GM:OnPlayerChat( ply, text )
  if string.sub(text,1,1) == "/" then
    return true
  end
end

end

hook.Remove("PlayerSay", "ULXMeCheck")