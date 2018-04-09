Fallout_ChatTalk = Fallout_ChatTalk or {}

function RegisterChatTalk(talk,sound,char)
  Fallout_ChatTalk[talk] = {Sound = sound,Char = char}
end

if SERVER then

function Schema.Hooks:pig_PlayerNormalChat(ply,radius,text)
  if ply:GetPlayerVar(ply:Name()) then
    for k,v in SortedPairs(Fallout_ChatTalk) do
	if v.Char != ply:Name() then continue end
	  local res1, res2 = string.find(text:lower(), k:lower())
      if res1 and (not text[res1 - 1] or text[res1 - 1] == "" or text[res1 - 1] == " ") and (not text[res2 + 1] or text[res2 + 1] == "" or text[res2 + 1] == " ") then
        ply:EmitSound(v.Sound,80,100,1,CHAN_VOICE)
		break
	  end
	end
  end
end

concommand.Add("PW_GiveChatSound", function(ply,cmd,args)
if !ply:IsSuperAdmin() then return end
local name = args[1]
local var = args[2]
if !name or !var then return end
local thePly = pig.FindPlayerByName(name)
if !IsValid(thePly) then return end
local ret = true
  for k,v in pairs(Fallout_ChatTalk) do
    if v.Char == var then
	  ret = false
	  break
	end
  end
--
  if ret then
    return
  end
--
thePly:SetPlayerVar(var,true)
end)

end