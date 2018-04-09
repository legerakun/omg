local FHUD = {}
FHUD.W = ScrW() *.215
FHUD.H = ScrH() *.125
FHUD.X = ScrW() *.035
FHUD.Y = (ScrH() - FHUD.H) - ScrH() *.06
FHUD.BarTime = 3
FHUD.ArmorTime = 4
FHUD.Offset = 0
FHUD.BloodMax = 21
FHUD.BloodSplashTime = 11
FHUD.Tick = Material("hud/ticks.png", "noclamp smooth")
FHUD.Bar = Material("hud/player_bar.png")
FHUD.Compass = Material("hud/compass.vtf")
FHUD.ObjMat = Material("pw_fallout/waypoint_custom.png")
-------------
local function getCompassPos(targ_pos)
local toscreen = targ_pos:ToScreen()
local xpos = toscreen.x
local w = FHUD.W
local x = FHUD.X + 10
--
xpos = x + math.Clamp(w*(xpos/ScrW()), 0, w)
--
return xpos
end
--

function Schema.Hooks:HUDShouldDraw(name)
local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
	CHudCrosshair = true,
	CHudVguiScreenCursor = true,
	CHudDamageIndicator = true,
}
if ( hide[ name ] ) then
return false
end
end
----
-------------------------------------------
function FalloutHPPaint()
if LocalPlayer():InEditor() or FalloutHUDHide then return end
local col = Schema.GameColor
--
local health = LocalPlayer():Health()
  if health <= 0 and !FHUD.PlayedSound then
    surface.PlaySound("fallout/die.mp3")
	FHUD.PlayedSound = true
  elseif health > 0 then
    FHUD.PlayedSound = false
  end
local max_health = LocalPlayer():GetMaxHealth()
  if FHUD.PLastHealth and FHUD.PLastHealth > health then
    FHUD.PLastDamage = FHUD.PLastHealth - health
    FHUD.PLastHealth = health
	FHUD.PArmorShow = CurTime() + FHUD.ArmorTime
	FHUD.BloodTime = CurTime() + FHUD.BloodSplashTime
	FHUD.BloodAdd = true
  else
    FHUD.PLastHealth = health
  end

local w,h,x,y,tick_width,spacing = FalloutHUDSize()
local tick_height = h *.16
--BLOOD SPLASH
  if FHUD.BloodTime and FHUD.BloodTime > CurTime() then
	if FHUD.BloodAdd and FHUD.PLastDamage >= 4 then
	  FHUD.SelectedBloods = FHUD.SelectedBloods or {}
	  for i=1,math.random(2,5) do
	  local cur = table.Count(FHUD.SelectedBloods) + 1
	  if cur < FHUD.BloodMax then
	    local xpos = math.Rand(.075, .975)
	    local ypos = math.Rand(.075, .8)
	    xpos = math.Round(xpos, 3)
	    ypos = math.Round(ypos, 3)
	    local mat = Material("pw_fallout/blood/blood"..math.random(1,3).."")
	    local bw = math.Rand(.1, .45)
	    bw = math.Round(bw, 3)
	    local max = (FHUD.BloodTime - CurTime())
	    FHUD.SelectedBloods[cur] = {x = xpos, y = ypos, size = bw, mat = mat, time = CurTime() + max, max = max}
	    FHUD.BloodAdd = false
	  end
	  end
	end
	
	if FHUD.SelectedBloods then
      for k,v in pairs(FHUD.SelectedBloods) do
	    local alpha = math.Clamp(255*((v.time - CurTime())/v.max), 0, 255)
	    if alpha <= 0 then
	      continue
	    end
	    surface.SetDrawColor(255, 255, 255, alpha)
	    surface.SetMaterial(v.mat)
	    local bw = ScrW()*v.size
	    surface.DrawTexturedRectRotated(ScrW()*v.x, ScrH()*v.y, bw, bw, 0)
	  end
	end
  elseif FHUD.BloodTime and FHUD.BloodTime <= CurTime() then
    FHUD.BloodTime = nil
	FHUD.SelectedBloods = nil
	FHUD.BloodAdd = nil
  end

--PLAYER BAR
surface.SetDrawColor(col)
surface.SetMaterial(FHUD.Bar)
surface.DrawTexturedRect(x,y,w,h)
local h_loops = Fallout_GetMaxLoops(w,tick_width,spacing)
local perc = (health / max_health)
perc = math.Clamp(perc,0,1)
h_loops = h_loops * perc
h_loops = h_loops - 1
  for i=1,(h_loops) do
    surface.SetDrawColor(Color(col.r,col.g,col.b,250))
    surface.SetMaterial(FHUD.Tick)
    surface.DrawTexturedRect(x + tick_width*2 + (tick_width * i) + ((spacing * 2) * i),y + ((h *.465) - tick_height),tick_width,tick_height)
  end
  local dt = Fallout_OutfitDT(LocalPlayer():GetOutfit())
  local p_lastdmg = FHUD.PLastDamage
  local p_armorshow = FHUD.PArmorShow  
    if dt and p_lastdmg and p_armorshow then
      if p_armorshow > CurTime() then
	    local p_mat = ""
	    if p_lastdmg <= dt then
	      p_mat = "hud/armor.png"
	    elseif p_lastdmg > dt then
	      p_mat = "hud/armor_broken.png"
	    end
		local aw = w*.0825
		surface.SetDrawColor(Schema.GameColor)
		surface.SetMaterial(Material(p_mat))
		surface.DrawTexturedRect(x+w+(aw*.5),y+(aw*1.35),aw,aw)
	  end
    end
Fallout_DrawText(x + (tick_width * 6),y - (tick_height / 4),"HP","FO3Font",Schema.GameColor,TEXT_ALIGN_LEFT)
----------------------------
--FLASH
local alpha = FHUD.Alpha or 255
local lowest = 40
local startTime = FHUD.AStartTime or CurTime()
local lifeTime = 0.65
local startVal = FHUD.AStartVal or alpha
local endVal = FHUD.AEndVal or lowest
local value = startVal
  
local fraction = ( CurTime( ) - startTime ) / lifeTime;
fraction = math.Clamp( fraction, 0, 1 );
value = Lerp( fraction, startVal, endVal );
alpha = value
FHUD.Alpha = alpha
  if alpha >= 255 then
	FHUD.AStartTime = CurTime()
	FHUD.AStartVal = alpha
	FHUD.AEndVal = lowest
  elseif alpha <= lowest then
	FHUD.AStartTime = CurTime()
	FHUD.AStartVal = alpha
	FHUD.AEndVal = 255
  end
local flash_col = Color(col.r, col.g, col.b, alpha)
----------------------------
--COMPASS
surface.SetDrawColor(Schema.GameColor)
surface.SetMaterial(FHUD.Compass)
surface.DrawPartialTexturedRect( x + (tick_width * 2),y + (h / 2),w - (tick_width * 2),h *.75, (-LocalPlayer():GetAngles().y/360) * 1024, 0, 336, 84,1024,64 )
local d_w = tick_width * 1.5
local d_h = tick_height *.75
local d_x = 0

  if PipBoy3000 and PipBoy3000.WayPoint then
    local waypoint = PipBoy3000.WayPoint
    local tx = getCompassPos(waypoint)
	local obj_h = tick_width*6
	local obj_w = obj_h*.625
	surface.SetDrawColor(flash_col)
	surface.SetMaterial(FHUD.ObjMat)
	surface.DrawTexturedRect(tx - (obj_w/2), y + h*.85, obj_w, obj_h)
  end
-------------------
-----------------------------
--CROSSHAIR
local cr_w = 56
local cr_h = 55
--
local hitpos = {x = ScrW() / 2,y = ScrH() / 2}
local trace = pig.utility.PlayerQuickTrace(LocalPlayer())
  if LocalPlayer().ThirdPersonActive then
    hitpos = trace.HitPos:ToScreen()
  end
local ent = trace.Entity
local distance = nil
-----------------------------
------COLOR
  if IsValid(ent) then
    distance = ent:GetPos():Distance(LocalPlayer():GetPos())
    if ent:IsNPC() or string.find(ent:GetClass(),"npc") then
	  if distance <= 300 or IsValid(FHUD.HUD_CurEnemy) then
        surface.SetDrawColor(Color(248,66,41))
	  else
	    surface.SetDrawColor(col)
	  end
    else
      surface.SetDrawColor(col)
    end
  else
    surface.SetDrawColor(col)
  end
----------------------------
----------------------------
--MATERIAL
  local wep = LocalPlayer():GetActiveWeapon()
  local iron = false
  if IsValid(wep) and wep:GetNetworkedBool("IronSight",false) == true then
    iron = true
  end
  --
  if !iron or LocalPlayer().ThirdPersonActive then
    if IsValid(ent) and !ent:IsPlayer() and !ent:IsNPC() and distance <= 100 and !string.find(ent:GetClass(),"crucifix") then
      surface.SetMaterial(Material("hud/glow_crosshair_filled.vtf"))
    else
      surface.SetMaterial(Material("hud/crhossair.vtf"))
    end
    surface.DrawTexturedRect(hitpos.x - (cr_w / 2),hitpos.y - (cr_h / 2),cr_w,cr_h)
  end
-----------------------------
--ENEMY HEALTH
local enemy = FHUD.HUD_CurEnemy

  if IsValid(ent) and ent == enemy or IsValid(ent) and distance <= 400 then
    if ent:IsNPC() or string.find(ent:GetClass(),"npc") or ent:IsPlayer() then
	  local stealth = ent:GetNWBool("Stealthing",false)
	  if !stealth then
        FHUD.HUD_CurEnemy = ent
        FHUD.HUD_RemoveEnemy = CurTime() + FHUD.BarTime
	  end
    end
  end

local time = FHUD.HUD_RemoveEnemy
  if time != nil and time < CurTime() then
    enemy = nil
	FHUD.HUD_CurEnemy = nil
  end

  if enemy != nil and IsValid(enemy) then
  local e_name = enemy:GetClass()
    if enemy:IsPlayer() then
	  if LocalPlayer():Recognises(enemy) then
        e_name = enemy:Name()
	  else
	    e_name = "Unknown"
	  end
    elseif enemy.PrintName then
      e_name = enemy.PrintName
    end
local e_w = w *.9
local e_h = h / 2
local e_x = ScrW() / 2 - (e_w / 2)
local e_y = y + (e_h *.65)
local e_col = Schema.RedColor or Color(248,66,41)
if enemy:IsPlayer() then
e_col = Schema.GameColor
end

surface.SetDrawColor(e_col)
surface.SetMaterial(Material("hud/enemy_healths.png"))
surface.DrawTexturedRect(e_x,e_y,e_w,e_h)
Fallout_DrawText(ScrW() / 2,e_y - (e_h *.4),e_name,"FO3FontHUD",e_col,TEXT_ALIGN_CENTER)

local e_health = enemy:Health()
local e_max_health = enemy:GetMaxHealth()
local e_loops = Fallout_GetMaxLoops(e_w - (e_w *.15),tick_width,spacing)
e_loops = e_loops * (e_health / e_max_health)

for i = 1,e_loops / 2 do
surface.SetDrawColor(Color(e_col.r,e_col.g,e_col.b,250))
surface.SetMaterial(FHUD.Tick)
surface.DrawTexturedRect((e_x + (e_w *.475)) + (tick_width * i) + ((spacing * 2) * i),e_y + (e_h *.18),tick_width,tick_height)
end

for i = 1,e_loops / 2 do
surface.SetDrawColor(Color(e_col.r,e_col.g,e_col.b,250))
surface.SetMaterial(FHUD.Tick)
surface.DrawTexturedRect((e_x + (e_w *.525)) - (tick_width/2) - (tick_width * i) - ((spacing * 2) * i),e_y + (e_h *.18),tick_width,tick_height)
end

end
--------------------------------------------------------------------------
-----------------------------
--INFO
if !IsValid(ent) or ent:IsPlayer() or ent:IsNPC() or string.find(ent:GetClass(),"npc") or string.find(ent:GetClass(),"crucifix") then return end
if distance > 100 then return end
FHUD.HUD_CurEnemy = nil
--
local key_use = (input.LookupBinding( "+use" ) or "E"):upper()
local key_alt = (input.LookupBinding("+walk") or "ALT"):upper()
local key = key_alt
local act = "Pickup"
local name = nil
local itemname = ent:GetNWString("ItemName", "")
  if itemname != "" then
    name = itemname
  else
    name = ent:GetClass()
  end
--
if ent.PrintName != nil and ent.PrintName != "" then name = ent.PrintName end
if ent:GetClass() == "func_door" or
		ent:GetClass() == "func_door_rotating" or
		ent:GetClass() == "prop_door_rotating" or
		ent:GetClass() == "prop_dynamic" then
		key = key_use
		act = "Use"
		name = "Door"
		elseif ent:GetClass() == "prop_ragdoll" then
		key = key_use
		act = "Search"
		name = "Corpse"
		elseif ent:GetClass() == "goopile" then
		key = key_use
		act = "Search"
		name = "Goopile"
	    elseif pig.utility.IsFunction(ent.Use) then
		key = key_use
		act = "Use"
end
--------------------
surface.SetFont("FO3FontHUD")
local message = key..") "..act
local key_w = surface.GetTextSize( key )
local text_w,text_h = surface.GetTextSize( message )
local info_x = ScrW() / 2
local info_y = y

Fallout_DrawText(info_x,info_y,message,"FO3FontHUD",Schema.GameColor,TEXT_ALIGN_CENTER)
Fallout_DrawText(info_x + key_w,info_y + text_h,name,"FO3FontHUD",Schema.GameColor,TEXT_ALIGN_CENTER)
--
if act == "Pickup" then
local d_w = w *.75
local d_h = h / 2
local d_x = ScrW() / 2 - (d_w / 2)
local d_y = y + (h / 2)
surface.SetDrawColor(Schema.GameColor)
surface.SetMaterial(Material("hud/divider.png"))
surface.DrawTexturedRect(d_x,d_y,d_w,d_h)
--
Fallout_DrawText(d_x,d_y + (d_h *.3),"WG","FO3FontHUD",Schema.GameColor,TEXT_ALIGN_LEFT)
Fallout_DrawText(d_x + (d_w *.55),d_y + (d_h *.3),"VAL","FO3FontHUD",Schema.GameColor,TEXT_ALIGN_LEFT)
--
local index = ent.ItemName or ent:GetClass()
local wg = Schema.InvMassTbl[index] or 0
local val = 0
local shop = Shop.Items[index]
  if shop then
    val = shop.Price
  end
--
local wg_w = surface.GetTextSize(wg)
local val_w = surface.GetTextSize(val)
Fallout_DrawText(d_x + (d_w *.45) - wg_w,d_y + (d_h *.3),wg,"FO3FontHUD",Schema.GameColor,TEXT_ALIGN_LEFT)
Fallout_DrawText(d_x + d_w - val_w,d_y + (d_h *.3),val,"FO3FontHUD",Schema.GameColor,TEXT_ALIGN_LEFT)
end
-----------------------------
end

function FalloutAPPaint()
if LocalPlayer():InEditor() or FalloutHUDHide then return end
local ply = LocalPlayer()
local w,h,x,y,tick_width,spacing = FalloutHUDSize()
x = (ScrW()-w) - x
local col = Schema.GameColor
--
local ap = LocalPlayer():GetAP()
local max_ap = LocalPlayer():GetMaxAP()
local tick_height = h *.16
--
Fallout_DrawText((x+w) - (tick_width * 5),y - (tick_height / 4),"AP","FO3Font",Schema.GameColor,TEXT_ALIGN_RIGHT)

local clip = ""
local col = Schema.GameColor
local ammo = ""
local wep = LocalPlayer():GetActiveWeapon()
local percent = 0
  if IsValid(wep) then
    clip = wep:Clip1()
	ammo = LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType())
	--
	  if wep.Primary and wep.Primary.InvAmmo then
	    local name = wep.Primary.InvAmmo
		name = Schema.InvNameTbl[name] or name
		local tbl = LocalPlayer().Inventory[name]
		if tbl then
		  ammo = tbl.Amount
		end
	  end
	--
	  if wep.Condition then
	    percent = wep.Condition/100
	  else
	    percent = 1
	  end
  end
  if tonumber(clip) and clip > 0 or tonumber(ammo) and ammo > 0 then
    Fallout_DrawText((x+w) - (tick_width * 5),y + (h*.625),clip.."/"..ammo,"FO3Font",Schema.GameColor,TEXT_ALIGN_RIGHT)
  end
Fallout_DrawText(x + (w*.2),y + (h*.625),"CND","FO3Font",Schema.GameColor,TEXT_ALIGN_LEFT)
surface.SetFont("FO3Font")
local tw,th = surface.GetTextSize("CND")
local cnd_w = w*.165
draw.RoundedBox(2,x + (w*.225) + tw,y + (h*.665),cnd_w,h*.175,Color(col.r*.4,col.g*.4,col.b*.4))
  if percent > 0 then
    draw.RoundedBox(2,x + (w*.225) + tw,y + (h*.665),cnd_w*percent,h*.175,Color(col.r,col.g,col.b))
  end
--
local h_loops = Fallout_GetMaxLoops(w,tick_width,spacing)
h_loops = h_loops - 1
h_loops = h_loops * (ap / max_ap)
--
surface.SetDrawColor(Schema.GameColor)
surface.SetMaterial(Material("hud/ammo_bar.png"))
surface.DrawTexturedRect(x, y, w, h)
--
for i=1,(h_loops) do
surface.SetDrawColor(Color(col.r,col.g,col.b,250))
surface.SetMaterial(FHUD.Tick)
surface.DrawTexturedRect((x+w) - (tick_width*2) - (tick_width * i) - ((spacing * 2) * i),y + ((h *.4465) - tick_height),tick_width,tick_height)
end
--
end
-------------------------------------------
---
function SetFHUDOffset(y)
FHUD.OffsetLast = CurTime()
FHUD.Offset = y
end

function FalloutHUDSize()
FHUD.W = ScrW() *.215
FHUD.H = ScrH() *.125
FHUD.X = ScrW() *.035
FHUD.Y = (ScrH() - FHUD.H) - ScrH() *.06
local tick_width = 5
local spacing = 1
  if ScrW() > 1600 then
    tick_width = 6
  end
return FHUD.W,FHUD.H,FHUD.X,FHUD.Y,tick_width,spacing
end

function Fallout_GetMaxLoops(bar_w,tick_width,spacing)
local h_loops = (bar_w - (bar_w *.14)) / (tick_width + (spacing * 2))
h_loops = math.Round(h_loops)
return h_loops
end
------------------------------------------------------
--BELOW CODE NOT MADE BY ME-----------
------------------------------------------------------
function surface.DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texw, texh )
	--[[ 
		Arguments:
		x: Where is it drawn on the x-axis of your screen
		y: Where is it drawn on the y-axis of your screen
		w: How wide must the image be?
		h: How high must the image be?
		partx: Where on the given texture's x-axis can we find the image you want?
		party: Where on the given texture's y-axis can we find the image you want?
		partw: How wide is the partial image in the given texture?
		parth: How high is the partial image in the given texture?
		texw: How wide is the texture?
		texh: How high is the texture?
	]]--
	
	-- Verify that we recieved all arguments
	if not( x && y && w && h && partx && party && partw && parth && texw && texh ) then
		ErrorNoHalt("surface.DrawPartialTexturedRect: Missing argument!");
		
		return;
	end;
	
	-- Get the positions and sizes as percentages / 100
	local percX, percY = partx / texw, party / texh;
	local percW, percH = partw / texw, parth / texh;
	
	-- Process the data
	local vertexData = {
		{
			x = x,
			y = y,
			u = percX,
			v = percY
		},
		{
			x = x + w,
			y = y,
			u = percX + percW,
			v = percY
		},
		{
			x = x + w,
			y = y + h,
			u = percX + percW,
			v = percY + percH
		},
		{
			x = x,
			y = y + h,
			u = percX,
			v = percY + percH
		}
	};
		
	surface.DrawPoly( vertexData );
end;

-- A function to draw a certain part of a texture
function draw.DrawPartialTexturedRect( x, y, w, h, partx, party, partw, parth, texturename )
	--[[ 
		Arguments:
		- Also look at the arguments of the surface version of this
		texturename: What is the name of the texture?
	]]--
	
	-- Verify that we recieved all arguments
	if not( x && y && w && h && partx && party && partw && parth && texturename ) then
		ErrorNoHalt("draw.DrawPartialTexturedRect: Missing argument!");
		
		return;
	end;
	
	-- Get the texture
	local texture = surface.GetTextureID(texturename);
	
	-- Get the positions and sizes as percentages / 100
	local texW, texH = surface.GetTextureSize( texture );
	local percX, percY = partx / texW, party / texH;
	local percW, percH = partw / texW, parth / texH;
	
	-- Process the data
	local vertexData = {
		{
			x = x,
			y = y,
			u = percX,
			v = percY
		},
		{
			x = x + w,
			y = y,
			u = percX + percW,
			v = percY
		},
		{
			x = x + w,
			y = y + h,
			u = percX + percW,
			v = percY + percH
		},
		{
			x = x,
			y = y + h,
			u = percX,
			v = percY + percH
		}
	};
	
	surface.SetTexture( texture );
	surface.SetDrawColor( 255, 255, 255, 255 );
	surface.DrawPoly( vertexData );
end;