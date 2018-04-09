local ScoreMat = Material("pw_fallout/scoreboard_main.png")

function pig.vgui.ScoreboardShow()
  if IsValid(pig.vgui.Scoreboard) then
    pig.vgui.Scoreboard:Remove()
  end
--
gui.EnableScreenClicker( true )
pig.vgui.Scoreboard = vgui.Create("DPanel")
local scoreboard = pig.vgui.Scoreboard
scoreboard:SetSize(ScrW()*.35, ScrH()*.4)
scoreboard:Center()
local count = table.Count(player.GetAll())
local max_count = game.MaxPlayers()
  scoreboard.Paint = function(me)
    local col = Schema.GameColor
    FalloutBlur(me, 10)
	local off_x = me:GetWide()*.039
	local off_y = me:GetTall()*.05
	Fallout_HalfBox(off_x, off_y, me:GetWide(), me:GetTall(), me:GetTall()*.055)
	--IMG
	local sy = off_y*1.5
	local sw = me:GetWide()*.898
	local sx = me:GetWide()/2 - (sw/2)
	local sh = sw*.215
	surface.SetDrawColor(255,255,255)
	surface.SetMaterial(Material("pw_fallout/scoreboard_main.png"))
	surface.DrawTexturedRect(sx, sy, sw, sh)
	
	draw.DrawText("Players\n"..count.."/"..max_count.."", "FO3FontSmall", sx + sw*.985, sy, col, TEXT_ALIGN_RIGHT)
	------
	local space = sh*.275
	local liney = sy + sh + space
	local downh = sh*.18
	Fallout_Line(sx, liney, "right", sw, true)
	
	Fallout_Line(sx, liney, "down", downh)	
	Fallout_Line(sx, liney - (downh) + 3, "up", downh)
	
	Fallout_Line(sx + sw - 3, liney, "down", downh)	
	Fallout_Line(sx + sw - 3, liney - (downh) + 3, "up", downh)
	--NAMES
	local text_x = sx + sw*.02
	
	draw.SimpleText("Player", "FO3FontSmall", text_x, sy + sh + (space*.5), col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw.SimpleText("Ping", "FO3FontSmall", me:GetWide()*.99 - text_x, sy + sh + (space*.5), col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
  	draw.SimpleText("User-Group", "FO3FontSmall", me:GetWide()*.6, sy + sh + (space*.5), col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  end

local list = vgui.Create("DPanelList", scoreboard)
local base_h = scoreboard:GetTall()*.08
local pcount = table.Count(player.GetAll())
local max_score = 8
list:SetSize(scoreboard:GetWide()*.865, base_h*3.5)
list:SetPos(0, scoreboard:GetTall()*.55)
list:EnableVerticalScrollbar(true)
  local mat_up = Material("hud/scrollbar/arrow_up.vtf")
  local mat_down = Material("hud/scrollbar/arrow_down.vtf")
  local mat_scroll = Material("hud/scrollbar/vert_marker.vtf")
  list.VBar.Paint = function(self)
    return
  end
  list.VBar.btnUp.Paint = function(me)
    local col = Schema.GameColor
    surface.SetDrawColor(col)
    surface.SetMaterial(mat_up)
    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall()*.65)      
  end
  list.VBar.btnDown.Paint = function(me)
    local col = Schema.GameColor
    surface.SetDrawColor(col)
    surface.SetMaterial(mat_down)
    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall()*.65)  
  end
  list.VBar.btnGrip.Paint = function(me)
    local col = Schema.GameColor
    surface.SetDrawColor(col)
    surface.SetMaterial(mat_scroll)
    surface.DrawTexturedRect(0,0,me:GetWide(),me:GetTall())
  end
list:CenterHorizontal()
list.SortList = function(me)
  local col = Schema.GameColor
  local tab = {}
  for k,v in pairs(player.GetAll()) do
    local rank = 0
	if pig.IsExtra(v) then
	  rank = 5
	elseif v:IsSuperAdmin() then
	  rank = 4
	elseif v:IsAdmin() then
	  rank = 3
	elseif v:GetUserGroup():lower():find("moderator") then
	  rank = 2
	elseif v:IsDonator() then
	  rank = 1
	end
    tab[k] = {ply = v, rank = rank}
  end
 --
  local coltab = {}
  coltab[5] = Color(173, 31, 209)
  coltab[4] = Color(8, 140, 201)
  coltab[3] = Color(183, 11, 11)
  coltab[2] = Color(19, 140, 25)
  coltab[1] = Color(229, 170, 34)
  for _, v in SortedPairsByMemberValue(tab, "rank", true) do
    local ply = v.ply
    local base = pig.CreateButton(nil, "", "FO3Font")
	base:SetSize(me:GetWide(), base_h)
	local aw = base:GetTall()*.915
	base.OnCursorEntered = function() return end
	base.DoClick = function(self)
	  local Window = Derma_Query("What would you like to do with this player?", "",
	  "Steam Profile", function() ply:ShowProfile() end,
	  "Go to", function() LocalPlayer():ConCommand("say !goto "..ply:Name().."") end,
	  "Bring", function() LocalPlayer():ConCommand("say !bring "..ply:Name().."") end,
	  "Cancel", function() surface.PlaySound("ui/ok.mp3") end)
	  Window.OldPaint = Window.Paint
	  Window.Paint = function(me)
	    Derma_DrawBackgroundBlur(me, me.Time)
		me.OldPaint(me)
	  end
	end
	
	base.Think = function(self)
	  if !IsValid(ply) then
	    self:Remove()
		count = table.Count(player.GetAll())
	  end
	end
	base.Col = coltab[v.rank]
	base.Paint = function(me)
	  local tcol = me.Col or col
	  draw.SimpleText(ply:GetName(), "FO3FontSmall", aw*1.2, me:GetTall()/2, tcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	  draw.SimpleText(ply:Ping(), "FO3FontSmall", me:GetWide()*.99, me:GetTall()/2, tcol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	  draw.SimpleText(ply:GetUserGroup():upper(), "FO3FontSmall", me:GetWide()*.65, me:GetTall()/2, tcol, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)	
	end
	
	local avatar = vgui.Create("CircularAvatarImage", base)
	avatar:SetSize(aw, aw)
	avatar:CenterVertical()
	avatar:SetPlayer(ply, 32)
	me:AddItem(base)
  end
end

local lx,ly = list:GetPos()
local total_h = base_h*pcount
  if total_h > list:GetTall() then
    local max = base_h*math.Clamp(pcount, 0, max_score)
	local sh = (scoreboard:GetWide()*.898)*.215
	local space = (sh*.275)
	local liney = scoreboard:GetTall()*.075 + sh + space
	ly = liney + (3/2) + space*.8
	
	local leftover = (ly + max) - scoreboard:GetTall() + (base_h*.9)
    scoreboard:SetTall(scoreboard:GetTall() + leftover + 3)
	scoreboard:Center()
	
	list:SetPos(lx, ly)
    list:SetTall(max)
  end
list:SortList()
end

function pig.vgui.ScoreboardHide()
  if IsValid(pig.vgui.Scoreboard) then
    gui.EnableScreenClicker( false )
    pig.vgui.Scoreboard:Remove()
  end
end
