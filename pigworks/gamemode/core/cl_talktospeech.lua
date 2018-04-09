--http://translate.google.com/translate_tts?tl=hi&q=
--https://www.youtube.com/watch?v=bMDv8P4gmQg&oref=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3DbMDv8P4gmQg&has_verified=1

local function getWords(str)
local len = 1
for i=1,string.len(str) do
if string.sub(str,i,i) == " " or string.sub(str,i,i) == "," then
len = len + 1
end
end
return len
end

function NPCSay(text_tbl,func,index)
local max = #text_tbl.TextTable
local playing = index or 1
if !IsValid(pig.vgui.NPC_Menu) then return end
for k,v in pairs(pig.vgui.NPC_Menu:GetChildren()) do
v:SetVisible(false)
end
pig.vgui.NPC_Menu.Talk = vgui.Create("DLabel",pig.vgui.NPC_Menu)
local npc_text = pig.vgui.NPC_Menu.Talk
if LocalPlayer().NPCSound != nil then LocalPlayer().NPCSound:Stop() end
LocalPlayer().NPCSound = CreateSound(LocalPlayer(),text_tbl.SoundTable[playing])
LocalPlayer().NPCSound:Play()
LocalPlayer().NPCSound:ChangeVolume(1)
if AmbientTrack != nil and !LocalPlayer().AmbDisabled then
AmbientTrack:ChangeVolume(0.055)
end
local length = getWords(text_tbl.TextTable[playing])
if length > 3 then
length = length *.3895
end
timer.Simple(length,function()
npc_text:Remove()
if playing + 1 > max then
if !IsValid(pig.vgui.NPC_Menu) then return end
for k,v in pairs(pig.vgui.NPC_Menu:GetChildren()) do
v:SetVisible(true)
end
pig.vgui.NPC_Menu:ShowCloseButton(false)
LocalPlayer().NPCSound:Stop()
if AmbientTrack != nil and !LocalPlayer().AmbDisabled then
AmbientTrack:ChangeVolume(Schema.AmbVol)
end
if func then
func()
end
pig.vgui.NPC_Menu:ReOpen()
else
LocalPlayer().NPCSound:Stop()
if func then
NPCSay(text_tbl,func,playing + 1)
else
NPCSay(text_tbl,nil,playing + 1)
end
end
end)
npc_text:SetText(text_tbl.TextTable[playing])
npc_text:SetTextColor(Schema.GameColor)
npc_text:SetFont("PigFontSmall")
npc_text:SizeToContents()
npc_text:SetPos(pig.vgui.NPC_Menu:GetWide() *.01,pig.vgui.NPC_Menu:GetTall() *.175)
hook.Call("pig_SetFont_NPCTalk",GAMEMODE,npc_text)
surface.SetFont(npc_text:GetFont())
npc_text:SetText(pig.NewLines(npc_text:GetText(),pig.vgui.NPC_Menu))
npc_text:SizeToContents()
end


/*
function NPCSay(text_tbl,func,index,times)
local max = #text_tbl
local playing = index or 1
if !IsValid(pig.vgui.NPC_Menu) then return end
for k,v in pairs(pig.vgui.NPC_Menu:GetChildren()) do
v:SetVisible(false)
end
pig.vgui.NPC_Menu.Talk = vgui.Create("DLabel",pig.vgui.NPC_Menu)
local npc_text = pig.vgui.NPC_Menu.Talk
sound.PlayURL( "http://tts.peniscorp.com/speak.lua?"..text_tbl[playing], "3d", function( station )
if !IsValid(station) then
chat.AddText(Color(204,0,0),"[PigWorks]: ERROR: Unable to play speech. Retrying..")
chat.AddText(Color(204,204,0),"[PigWorks]: Attempting to Retry..")
if times != nil and times > 4 then
chat.AddText(Color(104,0,0),"[PigWorks]: Speech failed after 4 retries. Text is either too long or language is invalid.")
pig.vgui.NPC_Menu:Remove()
return end
NPCSay(text_tbl,func,playing,(times or 0) + 1)
return end
length = station:GetLength()
if AmbientTrack != nil and !LocalPlayer().AmbDisabled then
AmbientTrack:ChangeVolume(0.055)
end
station:SetPos( LocalPlayer():GetPos() )
station:Play()
station:SetVolume(100)
timer.Simple(station:GetLength(),function()
npc_text:Remove()
if index == max or playing == max then
if !IsValid(pig.vgui.NPC_Menu) then return end
for k,v in pairs(pig.vgui.NPC_Menu:GetChildren()) do
v:SetVisible(true)
end
pig.vgui.NPC_Menu:ShowCloseButton(false)
station:Stop()
if AmbientTrack != nil and !LocalPlayer().AmbDisabled then
AmbientTrack:ChangeVolume(Schema.AmbVol)
end
if func then
func()
end
else
station:Stop()
if func then
NPCSay(text_tbl,func,playing + 1)
else
NPCSay(text_tbl,nil,playing + 1)
end
end
end)
end)
npc_text:SetText(text_tbl[playing])
npc_text:SetTextColor(Schema.GameColor)
npc_text:SetFont("PigFontSmall")
npc_text:SizeToContents()
npc_text:SetPos(pig.vgui.NPC_Menu:GetWide() *.01,pig.vgui.NPC_Menu:GetTall() *.175)
hook.Call("pig_SetFont_NPCTalk",GAMEMODE,npc_text)
surface.SetFont(npc_text:GetFont())
npc_text:SetText(pig.NewLines(npc_text:GetText(),pig.vgui.NPC_Menu))
npc_text:SizeToContents()
end*/
