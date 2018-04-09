local PANEL = {}
PANEL.Pages = {}
PANEL.Pages[1] = {Title = "Chat-Commands",Text = [[
Chat Commands allow you to do things with the chatbox. For example when you want to act out an action, you would use the command '/me'. The commands are below as follows:

/me  -Acts out an action in chat
/ooc OR //  -Used to speak global Out of Character 
/looc OR .//   -Used to speak Out of Character locally
/y   -Used to yell. Also has a wider chat range
/w   -Used to whisper. Has a very small chat range

]]}

PANEL.Pages[2] = {Title = "Pip-Boy",Text = [[
This is the Pip-Boy, this is where you manage your stats, inventory, visit the map or listen to Radio.

To bring the Pip-Boy up press [F]. You can cycle the STAT, ITEMS and DATA tab by clicking the buttons OR use the hotkeys [Q] to cycle left and [E] to cycle right.

To close the Pip-Boy press [F] again. 
]]}

PANEL.Pages[3] = {Title = "World Map",Text = [[
The world map allows you to navigate the map on your Pip-Boy. You can view what the world has to offer as well as set way points.

Small flashing blips (circles) indicate Brahmin Pick-up Points where you can pick up gear you have purchased.

To Zoom in/out Hold [SHIFT] and [Right Mouse Button] and while moving the mouse in and outwards.

To place a waypoint press the [Right Mouse Button] on an area. You can then view this marker on your HUD Compass.

You can move around the World Map if you press and drag it around with [Left Mouse Button]
]]}

PANEL.Pages[4] = {Title = "Attributes",Text = [[
Attributes affect your character in multiple areas. For example a higher Strength skill allows you to carry more weight.

You can increase the value of these stats by applying on the forums or with skill points. Skill points are also given to players by Super-Admins. These are awarded under certain conditions. Every player starts with the ability to tag 3 skills that increases them by 15. Increasing certain S.P.E.C.I.A.L skills can also increase other attributes.

For more info on these stats open the Attributes menu via the F4 menu.
]]}

PANEL.Pages[5] = {Title = "Flag Perks",Text = [[
Flags/Perks allow players certain advantages such as Power Armor Training. You can read further on Perk Flags by opening the Menu in the F4 Screen. These flags are only awarded on Super-Admin grants after a successful application on the forums.

Note that most (if not all) flags do not offer much (if any) combat advantages. Combat is only effected by gear and weapons.
]]}

PANEL.Pages[6] = {Title = "Trade Offers",Text = [[
You can send trade offers to players requesting to take some of their gear in return for some of your gear (or nothing). 

You can do this via looking at a player and typing /trade

Using this menu you can choose what you offer and what you receive. After the offer is sent, the player can view it via F4 > Trade Offers. Here they may accept or reject your trade offer.

If a trade offer is successful gear is automatically given and taken from each player. This is a useful feature when dealing in mass trades, making it quicker and more efficient.
]]}

PANEL.Pages[7] = {Title = "Armor Editor",Text = [[
The Armor Editor is a tool used to apply skins onto armor. Certain apparel items can have skins applied to them for a certain amount of caps. 

You can also rename an item which costs considerably less but offers no other value other than cosmetic. 

Users can submit skins to be used on their armor only available for their personal use via the forums. Please note that this is a Donator feature only.
]]}

PANEL.Pages[8] = {Title = "The Shop",Text = [[
The Shop is where traders purchase items to then re-sell to the public. As a trader there are a bunch of variables to take into account.

There are different Shops to buy from, each requiring certain Flag(s). These include the NCR, BoS, Legion, Gun Runners Shops. Each shop has a different price range for different items. For example the Brotherhood can buy cheaper Energy Weapon ammo but have almost no access to balistic weapon ammo. This motivates factions to trade with one another.

The dynamic shop system also has a limited amount of stock. Some items take Real Time minutes, days, weeks or even months to re-stock. Some items do not re-stock and are simply unavailable when run out of.

Depending on the current markets value, the trader will then re-sell an item to players with added value to make profit. 

The traders must also take into account order times. Every item ordered takes time to deliver which makes it better to buy in bulks. When delivered, it can be picked up at the Brahmin Pick-up Point which can be found on the map as a flashing blip.
]]}

PANEL.Pages[9] = {Title = "Third Person",Text = [[
To enable third person press F4 > Options > Toggle Third Person. You can also rotate around and view your character model in third person. You can do this by holding [G] and moving the mouse around.

If you want to disable third person, go back into options and press 'Toggle Third Person' again. 
]]}

PANEL.Pages[10] = {Title = "Combat and Gear",Text = [[
If you do not want to initiate holstilities try holstering your weapon by holding [E] and [R].

Every piece of clothing has a set amount of DT (Damage Threshold) which knocks off damage points from projectiles. For example if you are being attacked with a Laser Rifle with the damage of 9 and you're wearing Power Armor with a DT of 8, the DT is taken away from the damage ( 9 - 8 DT = 1 ) therefore you would only take 1 damage point.

If your DT surpasses the damage, for example your gear has 6 DT and you are taking 3 damage points, the damage is instead 20% of what it would be rather than being 0. Headgear offers more protection to your head, and armor protects the rest of your body. Most un-armored clothing such as suits offer no Damage Threshold. 

When indicating combat, the two parties must decide between S2K (Shoot to Kill) or Handle it via RolePlay (Chat-box). LOOC (Local Out of Character) is used to discuss what the party will agree on doing.
]]}

PANEL.Pages[11] = {Title = "Mining/Crafting",Text = [[
You can mine ores (located on your map) using a pick axe. These ores refill by themselves after a certain amount of time has passed (ranging from every 30-60 minutes). After mining them, you will receive metal fragments that are the basis of crafting Scrap Metal. 

NCR offer mining contracts while the Legion will tend to use slave labour on these mines. After the metal fragments are extracted, they can then be sold or crafted into Scrap Metal at a workbench. Scrap Metal is used in most crafting recipes.

To craft an object, you must meet the skill requirements aswell as have the necessary materials in your inventory. You will be prompted what is required via to the right of the Crafting Menu. Once you craft an object it is then added to your inventory.
]]}

PANEL.Pages[12] = {Title = "Gambling",Text = [[
To gamble you first need to get hold of chips which can be purchased or sold for caps. 

** Roulette: The basis of this game is inserting a bet onto either a colour, Green, Red or Black OR placing a bet on an individual number. Once the wheel has landed, if your colour or number was correct you will receive a multiplier of your original bet. The multiplier depends on the colour or if it was a number, the multipliers are explained on the game.

** Slots: Simply insert a chip, and luck does the rest. Depending on your bet, it will multiply your chips by a number depending on matching pictures your spin received. Beware though, this machine is very unpredictable.
]]}

PANEL.Pages[13] = {Title = "Terminals and Hacking",Text = [[
Terminals can provide many features including opening doors and writing text entries onto a Holo-tape. Holo-tapes are inserted into the terminal and can then be ejected and transported to other terminals and be read, useful for transmitting a message across far distances.

Terminals have a password protection feature. If you ever forget the password an admin can reset it for you. However, terminals can still be hacked by those skillful enough in the science skill. When hacking, you must guess the password from a list with hints as to what letters are included. You are limited to 4 attemps.

When locked out of a terminal, this state is reversed when the password is reset/changed. 
]]}
-----------------------------------------------------------
---------------------------------------

function PANEL:Init()
self.Time = SysTime()
self.OldPaint = self.Paint
self:MakePopup()
self:SetSize(ScrW()*.75,ScrH()*.7)
self:Center()
self:ShowClose(true)
self.DownWidth = self:GetTall()*.08
self.Off = self:GetWide()*.075
self.ANum = 1
self.Count = table.Count(self.Pages)
--
self:SetTitle1("<Undefined>")
self:SetTitle2("VDSG MANUAL")
--
local off_x = self:GetWide()*.025
local off_y = self:GetTall()*.09
local list = vgui.Create("pig_PanelList", self)
list:SetSize(self:GetWide() - (off_x*2) - self:GetWide()*.07, self:GetTall() - (off_y*2) - self:GetTall()*.09 )
list:SetPos(off_x, off_y + self:GetTall()*.05)
self.List = list
--
local next = pig.CreateButton(self, "Next A)", "FO3Font")
next:SizeToContents()
next:SetPos(self:GetWide()*.98 - next:GetWide(), off_y + self:GetTall()*.075)
  next.DoClick = function(me)
    local nxt = self.ANum + 1
	local max = table.Count(self.Pages)
	if nxt > max then
	  nxt = 1
	end
	self:SetPage(nxt)
	surface.PlaySound("ui/ok.mp3")
  end

local nx, ny = next:GetPos()
local prev = pig.CreateButton(self, "Previous S)", "FO3Font")
prev:SizeToContents()
prev:SetPos(self:GetWide()*.98 - prev:GetWide(), ny + next:GetTall())
  prev.DoClick = function(me)
    local nxt = self.ANum - 1
	if nxt < 1 then
	  local max = table.Count(self.Pages)
	  nxt = max
	end
	self:SetPage(nxt)
	surface.PlaySound("ui/ok.mp3")
  end
--
self:SetPage(1)
end

function PANEL:SetPage(num)
self.ANum = num
local list = self.List
  for k,v in pairs(list:GetItems()) do
    v:Remove()
  end
--
local tbl = self.Pages[num]
self:SetTitle1(tbl.Title)
--
local panel = vgui.Create("DPanel")
panel:SetSize(list:GetWide(), ScrH())
panel.Paint = function() return end
list:AddItem(panel)
--
local ty = list:GetTall()*.05
local off = list:GetWide()*.065
local spacing = list:GetTall()*.02
local text = tbl.Text or "<No Text>"
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
    if !IsValid(panel) then return end
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
--
  timer.Simple(ttime, function()
    if !IsValid(panel) then return end
	local count = table.Count(ltbl)
	local txtblur = ltbl[count]
	local tx, ty = txtblur:GetPos()
	panel:SetTall(ty + txtblur:GetTall())
  end)
--
end

function PANEL:SetTitle2(str)
if IsValid(self.Title2) then self.Title2:Remove() end
if IsValid(self.TitleBlur2) then self.TitleBlur2:Remove() end
local t1h = self.TitleBlur:GetTall()
self.Title2, self.TitleBlur2 = Fallout_DLabel(self,self:GetWide()*.155,self:GetTall()*.9875 - t1h,str,"FO3FontBig",Schema.GameColor)
end

local vdsg = Material("pw_fallout/vdsg.png", "noclamp smooth")
function PANEL:Paint()
if !IsValid(self.Title2) then return end
Derma_DrawBackgroundBlur(self, self.Time)
local title = self.Title
FalloutBlur(self,10)
local dw = self.DownWidth or self:GetTall()*.15
local off_x = self:GetWide()*.03
local off_y = self:GetTall()*.04
  if IsValid(title) then 
    Fallout_QuarterBoxTitle(off_x,off_y,self:GetWide()-(off_x*2),self:GetWide()*.015,dw,title)
  else
    Fallout_QuarterBox(off_x,off_y,self:GetWide()-(off_x*2),dw,"down")
  end
--ICON
local iw = self:GetWide()*.055
local ih = self:GetTall()*.07
local ix = off_x + 3 + (iw)
local iy = self:GetTall() - off_y - (ih/2)
local full = self:GetWide() - off_x
local vx, vy = self.Title2:GetPos()
local vw = self.Title2:GetWide()
local space = iw*.125
local cut1 = ix - (off_x) - space
local cut2 = full - (vx + vw) - 6

surface.SetDrawColor(Schema.GameColor)
surface.SetMaterial(vdsg)
surface.DrawTexturedRect(ix, iy, iw, ih)
--
Fallout_Line(off_x, self:GetTall() - off_y - dw, "up", dw)
Fallout_Line(self:GetWide() - off_x - (3/2), self:GetTall() - off_y - dw, "up", dw)
Fallout_Line(off_x, self:GetTall() - off_y - (3/2), "right", cut1, true)
Fallout_Line(vx + vw + space, self:GetTall() - off_y - (3/2), "right", cut2, true)
--
local count = self.Count
draw.SimpleText(self.ANum.." / "..count, "FO3Font", self:GetWide()*.97, self:GetTall()*.3, Schema.GameColor, TEXT_ALIGN_RIGHT)
------
  if pig.utility.IsFunction(self.SecondaryPaint) then
    self:SecondaryPaint(self)
  end
end

vgui.Register("Fallout_HelpMenu", PANEL, "Fallout_Frame")