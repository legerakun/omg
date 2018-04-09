local PANEL = {}
local faction_list = {}
----------------------------------
--EDIT BELOW THIS LINE
faction_list[1] = {Name = "New California Republic", Mat = Material("pw_fallout/factions/ncr.png"), Icon = Material("pw_fallout/factions/ncr_icon.png"), Leader = "Megalomaniac", SteamID = "76561197975441473", Desc = [[
The New California Republic are a democratic faction based in the state of California with various holdings in surrounding areas. 

The NCR boasts the largest military in the wasteland and have managed to accumulate a large amount of land into their republic through various means. 

Their goal is to rebuild an old-world style society with an actual government and proper infrastructure, however, some would argue that they have expanded too quickly and sacrificed the safety of some of their land because of this. 

The NCR battalion in the area are looking to establish a base of operations and bring the area into the republic’s sphere of influence. 

The NCR are currently suffering from a leadership crisis as two political parties fight over control over the government, expansionists and traditionalists led by General Moore and Chief Hanlon respectively.]]}

faction_list[2] = {Name = "Caesars Legion", Mat = Material("pw_fallout/factions/legion.png"), Icon = Material("pw_fallout/factions/legion_icon.jpg"), Leader = "Pilot", SteamID = "76561198012465995", Desc = [[
Caesar's Legion is an autocratic, traditionalist, imperialistic slaver society, and a totalitarian dictatorship. Founded in 2247 by Edward Sallow (also known as Caesar) and Joshua Graham, it is based on the ancient Roman Empire.

After the Second Battle of Hoover Dam, and after both the NCR and Legion had been pushed out of the Mojave; Centurion Tycho Favus received a letter from Vulpes Inculta commanding his forces to march eastward to acompany the Legate to Zion.

After Zion had been conquered the Legate ordered the Centurions forces to scout out Caliente, where it was thought a supply line could be established further improving the Legions strength.

The Legion currently has an encampment in the area known as Dead-Ridge Town, rightly named after all of it's settlers were slaughtered or brought into slavery to mine Metal. This is often traded to merchants of Caliente, those of which are willing to trade with the slavers.
]]}
faction_list[3] = {Name = "Brotherhood of Steel", Mat = Material("pw_fallout/factions/bos.png"), Icon = Material("pw_fallout/factions/bos_icon.jpg"), Leader = "Bradley", SteamID = "76561197971538063", Desc = [[
Originally Founded by Rodger Maxon, the Brotherhood of Steel are techno experts who preserve pre-war technology in attempts to secure the knowledge behind them.

Outcasts from the Lost Hills chapter, diposing of the raiders whom resided in Vault 9 unbeknown to the residences of Caliente they themselves have now taken up resdience inside. 

Taking the time to lick their wounds and reassess their strength they have kept their presence within the region as secret as possible but rumours of armour clad figures patrolling the hills around the Vault have still managed to spread, supplies within the group are running low and sooner or later they will have to make themselves known.
]]}
faction_list[4] = {Name = "La Caliente Familia", Mat = Material("pw_fallout/factions/lcf.png"), Icon = Material("pw_fallout/factions/familia_icon.jpg"), Leader = "Robin", SteamID = "76561198023620192", Desc = [[
Founded by Roderick Luciano, who declared himself the Boss, La Caliente Familia are an organisation who are rumoured to have made a fortune from offering 'protection' to vulnerable business owners in the early days of starting up.

After they gathered enough caps, Roderick purchased a Casino for the La Caliente Familia, where they legally obtain caps from roullette and other means. They try not to get involved in the NCR and Legion conflicts but only time will tell what will become of this organisation.
]]}
faction_list[5] = {Name = "Thesus", Mat = Material("pw_fallout/factions/thesus.png"), Icon = Material("pw_fallout/factions/thesus_icon.png"), Leader = "Twisted Machine", SteamID = "76561198080818883", Desc = [[
A small group of revolutionaries among the former independent state of Vault City. The most intellectual minds that the city had to offer cast away their shackles the NCR had forced upon them, quietly starting their plan to break out and regain their scientific freedoms.

With their freedoms stolen, their way of life disrupted, the indentured servants that the VC scientists had long enjoyed now freed by the new government, the men and women of science saw fit to take action. Banding together, a small group of them struck out from the city under the cover of darkness, forcibly taking along some of their former servants with them. After they had made their escape, the small group began to broadcast back to their home city, a constant plea for more to join their cause, to throw off the overlords that reigned over them. 
Few ever came, save the most nationalistic of citizens in the city. Years passed, and the group attempted to begin anew, accepting that they may never see home as it was again. 

After having made it to the wasteland around Caliente, more problems began to arise within the newly formed group. The older generations of leadership began to clash with the new, and deep rifts were driven between the newest members that had fled from Vault City.

After having taken over what remained of the Directorate, the new Founder started to make drastic changes to how the faction operated. No longer would they deny commoners, and sought only to grow their ranks. With what supplies remained, uniforms, weapons, and scientific gear had to be acquired rapidly. 

Emerging from their mountainside base, the group began its trek down to the town of Caliente, where they sought refuge and safety whilst seeking to grow their influence. 
Remaining ardent about being neutral, no attempts to exert political power over the town, and the Directorate was left to start over, building its own future alongside of the inhabitants of Caliente.
]]}
faction_list[6] = {Name = "The Liberty Party", Mat = Material("pw_fallout/factions/liberty.png"), Icon = Material("pw_fallout/factions/lib.jpg"), Leader = "Pic Heartman", SteamID = "76561198077312335", Desc = [[
The Liberty Party is a political movement founded by the infamous politician Pic Hartman. First founded in the town of Scrapville, the movement now goes wherever Pic goes.The liberty Party belives in true, commie free, american freedom. No taxes, no goverment, only freedom.
Any type of authoritarianism is seen as communism and is despised within the party.

During elections, The Liberty Party will act as a political plattform for a candidate (Usually the founder, Pic Hartman) with all the money and backing being focused on getting the candidate in office. 

The Liberty Militia is a protection/police force for the Liberty Party and it's members. It's founded and led by the ex-NCR Correctional facilty lead, Robert Walker. The liberty Militia acts as a protection group. Stopping communists and others from disrupting Liberty Party speeches and meetings.  The organization also takes the role of local police force, helping the community and sniffing out any hiding communists.
]]}
faction_list[7] = {Name = "Desert Rangers", Mat = Material("pw_fallout/factions/dranger.png"), Icon = Material("pw_fallout/factions/dranger_icon.jpg"), Leader = "Apollo", SteamID = "76561198079438973", Desc = [[
The Desert Rangers were a group of survivalists and vigilantes, living in the Nevada area but also have been known to be found in Zion Canyon and Arizona.

The Rangers hail from the badlands of Nevada, from survivor communities that survived the nuclear devastation relatively unscathed. They trace their heritage all the way back to the Texas Rangers, who inspired their mission to make the wasteland better, one step at a time. To this end, they learn survival and combat skills before taking to the road to carry out their mission.

A band of Rangers moved to the Caliente area, where they found a prospering community in Settlement of Caliente, in which they offered protection in return for supplies such as food and ammo. They can be found patrolling the Caliente walls or on the sniper towers.
]]}
faction_list[8] = {Name = "Caliente", Mat = Material("pw_fallout/factions/caliente.png")}
------------------------------------
--------------------

function PANEL:Init()
self.OldPaint = self.Paint
self:MakePopup()
self:SetSize(ScrW()*.55,ScrH()*.55)
self:Center()
self:ShowClose(true)
self.DownWidth = self:GetTall()*.055
self.Off = self:GetWide()*.075
--
self:SetTitle1("FACTIONS")
--
local list = vgui.Create("pig_PanelList", self)
self.List = list
list:SetSize(self:GetWide()*.915, self:GetTall()*.735)
list:EnableHorizontal(true)
local spacing = self:GetWide()*.02
list:SetPos(0, self:GetTall()*.08)
list:CenterHorizontal()
list:SetSpacing(spacing)
-------------
local bw = list:GetWide()/2 - (spacing/2)
--
  for k,v in SortedPairs(faction_list) do
    local base = vgui.Create("DButton")
	base:SetText("")
	base.DoClick = function()
	  list:SetVisible(false)
	  self:FactionInfo(k)
	end
	base:SetSize(bw, list:GetTall()/2.5)
	base.Paint = function(me, w, h)
	  surface.SetDrawColor(255,255,255)
	  surface.SetMaterial(v.Mat)
	  surface.DrawTexturedRect(0,0,w,h)
	  --
	  local iw = h*.475
	  local ix = w*.0225
	  local iy = h - iw - ix
	  local off = iw*.02
	  --
	  if !v.Icon then return end
	  surface.SetDrawColor(255,255,255)
	  surface.SetMaterial(v.Icon)
	  surface.DrawTexturedRect(ix + (off/2), iy + (off/2), iw - (off*2), iw - (off*2))
	  --
	  Fallout_Line(ix, iy, "right", iw, true)
	  Fallout_Line(ix, iy, "down", iw, true)
	  Fallout_Line(ix + iw - 3, iy, "down", iw, true)
	  Fallout_Line(ix, iy + iw - 3, "right", iw, true)	  
	end
	
	list:AddItem(base)
  end
end

function PANEL:FactionInfo(index)
local list = self.List
local scroll = vgui.Create("pig_PanelList", self)
scroll:SetPos(list:GetPos())
scroll:SetSize(list:GetSize())
  
local tbl = faction_list[index]
local total = 0
local panel = vgui.Create("DPanel")
panel:SetSize(scroll:GetWide(), ScrH())
  panel.Paint = function(me, w, h)
    draw.RoundedBox(0,0,0,w,h,Color(0,0,0,80))
  end
  
scroll:AddItem(panel)
--
local banner = vgui.Create("DPanel", panel)
banner:SetSize(panel:GetWide(), scroll:GetTall()*.6)
  banner.Paint = function(me, w, h)
    surface.SetDrawColor(255,255,255)
	surface.SetMaterial(tbl.Mat)
	surface.DrawTexturedRect(0,0,w,h)
  end
  
local spacing = scroll:GetTall()*.025
local bx, by = banner:GetPos()
local title, blur = Fallout_DLabel(panel, 0, by + banner:GetTall() + spacing,  tbl.Name, "FO3FontBig", Schema.GameColor)
title:CenterHorizontal()
blur:CenterHorizontal()

local tx, ty = title:GetPos()
ty = ty + blur:GetTall()
local off = scroll:GetWide()*.05
local text = tbl.Desc or "<No Description>"
local length = text:len()
local limit = 800
local labels = length/limit
  if math.Round(labels) < labels then
    labels = math.Round(labels) + 1
  elseif math.Round(labels) > labels then
    labels = math.Round(labels)
  end
--
local ltbl = {}
local ttime = 0.1
for i=1, labels do
local ltime = 0.1*i
ttime = ttime + ltime
  timer.Simple(ltime, function()
    local start = 0
    if i > 1 then
	  start = (limit * (i-1)) + 1
      local last = ltbl[i-1]
      local last_x, last_y = last:GetPos()
      ty = last_y + last:GetTall()
    end
	--
    local max = math.Clamp(start + limit, start, length)
	local curtext = text:sub(start, max)
	--
    local txt, txtblur = Fallout_DLabel(panel, off/2, ty + spacing,  curtext, "FO3Font", Schema.GameColor)
    ltbl[i] = txtblur
    txt:SetWide( panel:GetWide() - off )
    txtblur:SetWide(panel:GetWide() - off)
  end)
end

  timer.Simple(ttime, function()
    if !IsValid(scroll) then return end
	local count = table.Count(ltbl)
	local txtblur = ltbl[count]
	local tx, ty = txtblur:GetPos()
	local ltxt, lblur = Fallout_DLabel(panel, 0, ty + txtblur:GetTall() + (spacing*4),  "Leader - "..(tbl.Leader or "<Unknown>"), "FO3Font", Schema.GameColor)
	ltxt:CenterHorizontal()
	lblur:CenterHorizontal()
	
	local avatar = vgui.Create("AvatarImage", panel)
	local aw = scroll:GetWide()*.2
	avatar:SetSize(aw, aw)
	local lx, ly = lblur:GetPos()
	avatar:SetPos(0,ly + lblur:GetTall() + spacing)
	avatar:CenterHorizontal()
	avatar:SetSteamID(tbl.SteamID or "", 180)
	--
	local ax, ay = avatar:GetPos()
	total = ay+avatar:GetTall()
	panel:SetTall(total + spacing)
  end)

end

vgui.Register("Fallout_Factions", PANEL, "Fallout_Frame")