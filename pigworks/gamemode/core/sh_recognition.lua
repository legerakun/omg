local char = FindMetaTable("Player")
local CoolTime = 2

if SERVER then
util.AddNetworkString("PW_Rec")
util.AddNetworkString("PW_Recognise")

net.Receive("PW_Rec",function(_,ply)
ply.LastRecognise = ply.LastRecognise or CurTime()-1
if ply.LastRecognise > CurTime() then return end
ply.LastRecognise = CurTime() + CoolTime
local tab = net.ReadTable()
  for k,v in pairs(tab) do
    local plays = pig.FindPlayerByName(v)
    if !plays or plays:InEditor() then continue end
	if plays:Recognises(ply) then continue end
	ply:Recognise(plays)
  end
end)

hook.Add("pig_SortedCharVars","PW_Recognition",function(ply)
local rec = ply:GetCharVar("Recognised")
  if !rec then
    ply:SetCharVar("Recognised",{},true)
  else
    ply:SendCharVar("Recognised")
  end
end)

function char:Recognise(ply)
local tbl = ply:GetCharVar("Recognised")
table.insert(tbl,self:GetCharID())
ply:SetCharVar("Recognised",tbl)
net.Start("PW_Recognise")
net.WriteString(self:GetCharID())
net.Send(ply)
end

end

function char:Recognises(ply)
if !self.CharVars then return end
if ply == self then return true end
  if table.HasValue(self:GetCharVar("Recognised"),ply:GetCharID()) then
    return true
  end
end

if CLIENT then

function char:SendRecognition(dist)
local tab = {}
  for k,v in pairs(player.GetAll()) do
    if v:InEditor() or v == self then continue end
	local tdist = v:GetPos():Distance(self:GetPos())
	if tdist > dist then continue end
	tab[k] = v:Name()
  end
if table.Count(tab) < 1 then return end
net.Start("PW_Rec")
net.WriteTable(tab)
net.SendToServer()
end

function pig.F2Menu()
  if IsValid(pig.vgui.F2Menu) then
    pig.vgui.F2Menu:Remove()
	return
  end
pig.vgui.F2Menu = vgui.Create("DPanel")
local f2 = pig.vgui.F2Menu
local space = ScrW()*.01
f2:SetSize(ScrW()*.2,ScrH()*.2)
f2:SetPos(ScrW()/2 - f2:GetWide() - (space/2),0)
f2:CenterVertical()
f2:MakePopup()
  f2.Paint = function(me)
    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,100))
	surface.SetDrawColor(Schema.GameColor)
	surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
  end
--
local options = {}
options["Whispering Range"] = 100
options["Talking Range"] = Schema.TalkRadius
options["Yelling Distance"] = math.Round(Schema.TalkRadius*1.5)
--
local list = vgui.Create("pig_PanelList",f2)
list:SetSize(f2:GetSize())
  for k,v in SortedPairs(options) do
    local base = pig.CreateButton(nil,k,"PigFont")
	base:SetSize(list:GetWide(),list:GetTall()/3)
	base.DoClick = function(me)
	  LocalPlayer().LastRecognise = LocalPlayer().LastRecognise or CurTime() - 1
	  if LocalPlayer().LastRecognise > CurTime() then f2:Remove() return end
	  LocalPlayer().LastRecognise = CurTime()+(CoolTime+1)
	  LocalPlayer():SendRecognition(v)
	  f2:Remove()
	end
	list:AddItem(base)
  end
----------------
pig.CreateAnimationMenu(f2,space)
end

hook.Add("Think","RecogniseThink",function()
local time = 0.25
--
  if pig.IsKeyPressed(KEY_F2) then
    pig.NextF2Press = pig.NextF2Press or CurTime()-1
    if (pig.NextF2Press) > CurTime() then return end
    pig.NextF2Press = CurTime()+time
    pig.F2Menu()
  end
end)

net.Receive("PW_Recognise",function()
local id = net.ReadString()
table.insert(LocalPlayer().CharVars["Recognised"],id)
end)

end
