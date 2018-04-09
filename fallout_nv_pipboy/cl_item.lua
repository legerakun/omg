PipBoy3000 = PipBoy3000 or {}
local tab = {}
------------------
--FUNCS
local function getAmmoIndex(k)
local wep_name = Schema.InvNameTbl[k] or k
--
local ammo_tbl = {}
ammo_tbl["10mm Pistol"] = "10mm Rounds"
ammo_tbl[".44 Magnum Revolver"] = ".44 Magnum Rounds"
ammo_tbl["10mm Carbine"] = "10mm Rounds"
ammo_tbl["10mm Sub-Machine Gun"] = "10mm Rounds"
ammo_tbl["9mm Pistol"] = "9mm Rounds"
ammo_tbl["9mm Sub-Machine Gun"] = "9mm Rounds"
ammo_tbl["AK-112"] = "5mm Rounds"
ammo_tbl["Alien Blaster"] = "Alien Power Cell"
ammo_tbl["Bottlecap Mine"] = "Bottlecap Mine"
ammo_tbl["Chinese Assault Rifle"] = "5.56mm Rounds"
ammo_tbl["Chinese Pistol"] = "10mm Pistol"
ammo_tbl["Combat Shotgun"] = "12 Gauge Rounds"
ammo_tbl["Cowboy Repeater"] = ".308 Rounds"
ammo_tbl["Double Barreled Shotgun"] = "12 Gauge Rounds"
ammo_tbl["Fatman"] = "Mini-Nuke"
ammo_tbl["Frag Grenade"] = "Frag Grenade"
ammo_tbl["Frag Mine"] = "Frag Mine"
ammo_tbl["Gatling Laser"] = "EC-Pack"
ammo_tbl["Hunting Rifle"] = ".308 Rounds"
ammo_tbl["Laser Pistol"] = "Energy-Cell"
ammo_tbl["Laser Rifle"] = "Microfusion Cell"
ammo_tbl["Multiplas Rifle"] = "Microfusion Cell"
ammo_tbl["Plasma Pistol"] = "Energy-Cell"
ammo_tbl["Plasma Rifle"] = "Microfusion Cell"
ammo_tbl["Sawn-off Shotgun"] = "12 Gauge Rounds"
ammo_tbl["Service Rifle"] = "5.56mm Rounds"
ammo_tbl["Silenced 10mm Pistol"] = "10mm Rounds"
ammo_tbl["Sniper Rifle"] = ".308 Rounds"
ammo_tbl["Tesla-Beaton Prototype"] = "EC-Pack"
ammo_tbl["Turbo Plasma Rifle"] = "Microfusion Cell"
--
local type = ammo_tbl[wep_name]
return type
end

-----------------------
--ITEMS
tab[1] = {Name = "Weapons",Func = function(me,x)
local tb = {}
local pip = LocalPlayer():GetActiveWeapon()
--
me.Wep = pip.WepIndex
local list = vgui.Create("pig_PanelList",me)
tb[1] = list
list:SetSize(me:GetWide() *.375,me:GetTall() *.615)
list:SetPos(x - 3,me:GetTall() *.166)
list:SetSpacing(1)
list.SortFList = function(list)
  for k,v in pairs(list:GetItems()) do
    v:Remove()
  end
  for k,v in SortedPairs(LocalPlayer():GetInventoryWeapons()) do
    local base = vgui.Create("DButton")
	base:SetText("")
    base:SetSize(list:GetWide(),me:GetTall() *.075)
	base.DoClick = function(self)
	  if me.Wep == k then 
	    me.Wep = nil
		pip.WepIndex = nil
		return 
	  end
	  pip = LocalPlayer():GetActiveWeapon()
	  pip.WepIndex = k
	  surface.PlaySound(Fallout_PickupSound(k))
	  me.Wep = k
	end
    base.DoRightClick = function(self)
	  if !LocalPlayer():InvCanDropWeapon(k) then
	    if !LocalPlayer().InvDropNotif or LocalPlayer().InvDropNotif <= CurTime() then
	      LocalPlayer().InvFirstNotif = CurTime()+4
	      pig.Notify(Schema.RedColor, "You cannot drop any faction or default weapons!", 3, nil, "pw_fallout/v_sad.png")
	    end
	    return
	  end
	  --
	  v.Amount = v.Amount - 1
	  v.Weight = v.Weight - (v.SingleWG)
	  list.Info.Mass = math.Round(v.Weight,2)
	  if me.Wep == k then 
	    me.Wep = nil
		pip.WepIndex = nil
	  end
	  surface.PlaySound("ui/ui_items_generic_down.mp3")
	  DropItem(k)
	  if v.Amount < 1 then
	    self:Remove()
	  end
	end
	base.OnCursorEntered = function(self)
      self.ins = true
	  list.Info = {}
	  list.Info.Class = v.Saved_Vars[v.Amount].WepClass
	  list.Info.Mass = math.Round(v.Weight,2)
	  list.Info.Clip = v.Saved_Vars[v.Amount].Clip
	  list.Info.AmmoType = getAmmoIndex(k)
	  --me.Class = v.Saved_Vars[v.Amount].WepClass
	  --me.Mass = math.Round(v.Weight,2)
	  --me.Clip = v.Saved_Vars[v.Amount].Clip
      surface.PlaySound("ui/focus.mp3")
    end
    base.Paint = function(self)
      col = Schema.GameColor
	   if me.Wep == k then
		  local mh = self:GetTall()*.225
		  surface.SetDrawColor(col)
		  surface.DrawRect(self:GetWide()*.04,self:GetTall()/2 - (mh/2),mh,mh)
		elseif self.ins then
		  local mh = self:GetTall()*.225
		  local mx = self:GetWide()*.04
		  local my = self:GetTall()/2 - (mh/2)
		  local lw = 2
		  Fallout_Line(mx,my,"right",mh,true,col,lw)
          Fallout_Line(mx,my,"down",mh,true,col,lw)
		  Fallout_Line(mx,my+mh-lw,"right",mh,true,col,lw)
		  Fallout_Line(mx + mh-lw,my,"down",mh,true,col,lw)
		end
      local name = k
	    if v.Amount > 1 then
		  name = name.." ("..v.Amount..")"
		end
      if !self.ins then 
        draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        return 
      end
      surface.SetDrawColor(col)
      surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
      draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(col.r,col.g,col.b,5))
      draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
	end
    base.OnCursorExited = function(self)
      self.ins = false
    end
    list:AddItem(base)
  end
end
list:SortFList()
--------
local dv = list.VBar
  dv.OnMousePressed = function(self, x, y)

  end
--------
  
local infobar = vgui.Create("DPanel",me)
tb[2] = infobar
infobar:SetSize(me:GetWide()*.4525,me:GetTall()*.175)
infobar:SetPos(me:GetWide()*.475,me:GetTall()*.54)
infobar.Paint = function(self)
  local info = list.Info
  --
  local dam = 0
  local wg = 0
  local val = 0
  local atype = "--"
  local clip = 0
  local ammo = 0
  local cnd = 100
    if info then
	  dam = info.Dam or 0
	  wg = info.Mass or wg
	  clip = info.Clip or clip
	  atype = info.AmmoType or atype
	  ammo = LocalPlayer():GetInvAmount(atype)
	else
	  return
	end
  local w = self:GetWide()*.315
  local spacing = self:GetWide()*.015
  PipBoy3000.AddInfo(0+(spacing*1),0,w,"DAM",dam)
  PipBoy3000.AddInfo(0+(spacing*2)+(w*1),0,w,"WG",wg)  
  PipBoy3000.AddInfo(0+(spacing*3)+(w*2),0,w,"VAL",val)
  --
  PipBoy3000.AddInfo(0+(spacing*1),self:GetTall()/2,w,"CND","")
  local ch = self:GetTall()*.15
  local cw = self:GetWide()*.175
  draw.RoundedBox(0,self:GetWide()*.12, self:GetTall()*.7 - (ch/2), cw*(cnd/100), ch, Schema.GameColor)
  PipBoy3000.AddInfo(0+(spacing*2)+(w*1),self:GetTall()/2,w*2+spacing,atype.." ("..clip.."/"..ammo..")","")    
end

local mw = me:GetWide()*.4
local pic = vgui.Create("DPanel",me)
tb[3] = pic
pic:SetSize(mw,mw)
pic:SetPos(me:GetWide()*.725 - (mw/2),me:GetTall()*.05)
pic.Paint = function(self)
if !list.Info then return end
local index = Schema.InvNameTbl[list.Info.Class]
local cpic = Schema.Icons[index] or Schema.Icons[list.Info.Class] or "pw_fallout/icons/missing.png"
  if !cpic then
    return
  end
  surface.SetDrawColor(Schema.GameColor)
  surface.SetMaterial(Material(cpic))
  surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
end

return tb
end}

tab[2] = {Name = "Apparel",Func = function(me,x)
local tb = {}
--
local list = vgui.Create("pig_PanelList",me)
tb[1] = list
list:SetSize(me:GetWide() *.375,me:GetTall() *.615)
list:SetPos(x - 3,me:GetTall() *.166)
list:SetSpacing(1)
list.SortFList = function(list)
  for k,v in pairs(list:GetItems()) do
    v:Remove()
  end
  for k,v in SortedPairs(LocalPlayer():GetInventoryByClass("fallout_c_base")) do
    local base = vgui.Create("DButton")
	base:SetText("")
    base:SetSize(list:GetWide(),me:GetTall() *.075)
	base.OutfitName = v.Saved_Vars[1].Outfit
    base.DoClick = function(self)
	  if self.OutfitName == LocalPlayer():GetOutfit() then 
	    surface.PlaySound("ui/app_off.wav")
	  else
	    surface.PlaySound("ui/app_on.wav")
	  end
	  UseItem(k)
	end
	base.DoRightClick = function(self)
	  surface.PlaySound("ui/app_off.wav")
	  DropItem(k)
	  v.Amount = v.Amount - 1
	  v.Weight = v.Weight - v.SingleWG
	  if v.Amount <= 0 then
	    self:Remove()
	  end
	end
	base.OnCursorEntered = function(self)
      self.ins = true
	  me.Outfit = self.OutfitName
	  me.Weight = math.Round(v.Weight,2)
      surface.PlaySound("ui/focus.mp3")
    end
    base.Paint = function(self)
      col = Schema.GameColor
      local name = k
	    if v.Amount > 1 then
		  name = name.." ("..v.Amount..")"
		end
	  if self.OutfitName == LocalPlayer():GetOutfit() or self.OutfitName == LocalPlayer():GetOutfit(true) then
	  	local mh = self:GetTall()*.225
		surface.SetDrawColor(col)
		surface.DrawRect(self:GetWide()*.04,self:GetTall()/2 - (mh/2),mh,mh)
	  elseif self.ins then
		local mh = self:GetTall()*.225
	    local mx = self:GetWide()*.04
		local my = self:GetTall()/2 - (mh/2)
		local lw = 2
		Fallout_Line(mx,my,"right",mh,true,col,lw)
        Fallout_Line(mx,my,"down",mh,true,col,lw)
		Fallout_Line(mx,my+mh-lw,"right",mh,true,col,lw)
		Fallout_Line(mx + mh-lw,my,"down",mh,true,col,lw)
	  end
      if !self.ins then 
        draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        return 
      end
      surface.SetDrawColor(col)
      surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
      draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(col.r,col.g,col.b,5))
      draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
    end
    base.OnCursorExited = function(self)
      self.ins = false
    end
    list:AddItem(base)
  end
end
list:SortFList()
 --
local infobar = vgui.Create("DPanel",me)
tb[2] = infobar
infobar:SetSize(me:GetWide()*.4525,me:GetTall()*.175)
infobar:SetPos(me:GetWide()*.475,me:GetTall()*.54)
infobar.Paint = function(self)
  local info = nil
  --
  local dt = 0
  local wg = 0
  local val = 0
    if me.Outfit then
      dt = Fallout_OutfitDT(me.Outfit)
	  wg = me.Weight
	else
	  return
	end
  local w = self:GetWide()*.315
  local spacing = self:GetWide()*.015
  PipBoy3000.AddInfo(0+(spacing*1),0,w,"DT",dt)
  PipBoy3000.AddInfo(0+(spacing*2)+(w*1),0,w,"WG",wg)  
  PipBoy3000.AddInfo(0+(spacing*3)+(w*2),0,w,"VAL",val)
  --
  PipBoy3000.AddInfo(0+(spacing*1),self:GetTall()/2,w,"CND","")  
  local ch = self:GetTall()*.15
  local cw = self:GetWide()*.175
  local cnd = 100
  draw.RoundedBox(0,self:GetWide()*.12, self:GetTall()*.7 - (ch/2), cw*(cnd/100), ch, Schema.GameColor)
end

local mw = me:GetWide()*.4
local pic = vgui.Create("DPanel",me)
tb[3] = pic
pic:SetSize(mw,me:GetTall()*.55)
pic:SetPos(me:GetWide()*.725 - (mw/2),me:GetTall()*.05)
pic.Paint = function(self)
  local cpic = Schema.Icons[me.Outfit]--GetApparelInfo(me.Outfit)
  if !cpic then
    return
  end
  surface.SetDrawColor(Schema.GameColor)
  surface.SetMaterial(Material(cpic))
  surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
end

return tb
end}

tab[3] = {Name = "Aid",Func = function(me,x)
local tb = {}
--
local list = vgui.Create("pig_PanelList",me)
tb[1] = list
list:SetSize(me:GetWide() *.375,me:GetTall() *.615)
list:SetPos(x - 3,me:GetTall() *.166)
list:SetSpacing(1)
list.SortFList = function(list)
  for k,v in pairs(list:GetItems()) do
    v:Remove()
  end
  for k,v in SortedPairs(LocalPlayer():FindInventoryByClass("fo3_aid")) do
    local base = vgui.Create("DButton")
	base:SetText("")
    base:SetSize(list:GetWide(),me:GetTall() *.075)
    base.DoClick = function(self)
	  UseItem(k)
	  v.Amount = v.Amount - 1
	  if v.Amount <= 0 then
	    self:Remove()
	  end
	end
	base.DoRightClick = function(self)
	  if v.Amount >= 10 then
	    if IsValid(pig.vgui.AmtBox) then pig.vgui.AmtBox:Remove() end
	    local box = Fallout_AmountBox("How many?", 0, v.Amount, function(amt)
		  surface.PlaySound("ui/app_off.wav")
	      DropItem(k, amt or 0)
	      v.Amount = v.Amount - (amt or 0)
	      if v.Amount <= 0 then
	        self:Remove()
	      end
		end)
		pig.vgui.AmtBox = box
	    return
	  end
	  surface.PlaySound("ui/app_off.wav")
	  DropItem(k)
	  v.Amount = v.Amount - 1
	  if v.Amount <= 0 then
	    self:Remove()
	  end
	end
	base.OnCursorEntered = function(self)
      self.ins = true
	  me.Aid = k
	  me.Weight = math.Round(v.Weight,2)
      surface.PlaySound("ui/focus.mp3")
    end
    base.Paint = function(self)
      col = Schema.GameColor
      local name = k
	    if v.Amount > 1 then
		  name = name.." ("..v.Amount..")"
		end
	  if self.ins then
		local mh = self:GetTall()*.225
	    local mx = self:GetWide()*.04
		local my = self:GetTall()/2 - (mh/2)
		local lw = 2
		Fallout_Line(mx,my,"right",mh,true,col,lw)
        Fallout_Line(mx,my,"down",mh,true,col,lw)
		Fallout_Line(mx,my+mh-lw,"right",mh,true,col,lw)
		Fallout_Line(mx + mh-lw,my,"down",mh,true,col,lw)
	  end
      if !self.ins then 
        draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        return 
      end
      surface.SetDrawColor(col)
      surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
      draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(col.r,col.g,col.b,5))
      draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
    end
    base.OnCursorExited = function(self)
      self.ins = false
    end
    list:AddItem(base)
  end
end
list:SortFList()
--
local infobar = vgui.Create("DPanel",me)
tb[2] = infobar
infobar:SetSize(me:GetWide()*.4525,me:GetTall()*.175)
infobar:SetPos(me:GetWide()*.475,me:GetTall()*.54)
infobar.Paint = function(self)
  local wg = 0
  local val = 0
  wg = me.Weight or wg
  if !me.Aid then return end
  local w = self:GetWide()*.315
  local spacing = self:GetWide()*.015
  PipBoy3000.AddInfo(0+(spacing*2)+(w*1),0,w,"WG",wg)  
  PipBoy3000.AddInfo(0+(spacing*3)+(w*2),0,w,"VAL",val)
  --
  PipBoy3000.AddInfo(0+(spacing*1),self:GetTall()/2,w*3+(spacing*2),"EFF","+Health Effects (???)")  
end

local mw = me:GetWide()*.4
local pic = vgui.Create("DPanel",me)
tb[3] = pic
pic:SetSize(mw,me:GetTall()*.55)
pic:SetPos(me:GetWide()*.725 - (mw/2),me:GetTall()*.05)
pic.Paint = function(self)
  local cpic = Schema.Icons[me.Aid]
  if !cpic then
    return
  end
  surface.SetDrawColor(Schema.GameColor)
  surface.SetMaterial(Material(cpic))
  surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
end

return tb
end}

tab[4] = {Name = "Misc",Func = function(me,x)
local tb = {}
--
local list = vgui.Create("pig_PanelList",me)
tb[1] = list
list:SetSize(me:GetWide() *.375,me:GetTall() *.615)
list:SetPos(x - 3,me:GetTall() *.166)
list:SetSpacing(1)
--
list.SortFList = function(list)
  for k,v in pairs(list:GetItems()) do
    v:Remove()
  end
--
local misc = {}
  for k,v in pairs(LocalPlayer().Inventory) do
    local class = v.Class
	if class == ("pig_ent_wep") or class == ("fallout_c_base") or class:find("fo3_aid") or class:find("fo3_ammo") then continue end
	misc[k] = v
  end
--
  for k,v in SortedPairs(misc) do
    local base = vgui.Create("DButton")
	base:SetText("")
    base:SetSize(list:GetWide(),me:GetTall() *.075)
	base.DoRightClick = function(self)
	  if v.Amount >= 10 then
	    if IsValid(pig.vgui.AmtBox) then pig.vgui.AmtBox:Remove() end
	    local box = Fallout_AmountBox("How many?", 0, v.Amount, function(amt)
		  surface.PlaySound("ui/app_off.wav")
	      DropItem(k, amt or 0)
	      v.Amount = v.Amount - (amt or 0)
	      if v.Amount <= 0 then
	        self:Remove()
	      end
		end)
		pig.vgui.AmtBox = box
	    return
	  end
	  surface.PlaySound("ui/app_off.wav")
	  DropItem(k)
	  v.Amount = v.Amount - 1
	  if v.Amount <= 0 then
	    self:Remove()
	  end
	end
	base.OnCursorEntered = function(self)
      self.ins = true
	  me.Misc = k
	  me.Weight = math.Round(v.Weight,2)
      surface.PlaySound("ui/focus.mp3")
    end
    base.Paint = function(self)
      col = Schema.GameColor
      local name = k
	    if v.Amount > 1 then
		  name = name.." ("..v.Amount..")"
		end
	  if self.ins then
		local mh = self:GetTall()*.225
	    local mx = self:GetWide()*.04
		local my = self:GetTall()/2 - (mh/2)
		local lw = 2
		Fallout_Line(mx,my,"right",mh,true,col,lw)
        Fallout_Line(mx,my,"down",mh,true,col,lw)
		Fallout_Line(mx,my+mh-lw,"right",mh,true,col,lw)
		Fallout_Line(mx + mh-lw,my,"down",mh,true,col,lw)
	  end
      if !self.ins then 
        draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        return 
      end
      surface.SetDrawColor(col)
      surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
      draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(col.r,col.g,col.b,5))
      draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
    end
    base.OnCursorExited = function(self)
      self.ins = false
    end
    list:AddItem(base)
  end
end
list:SortFList()
--
local infobar = vgui.Create("DPanel",me)
tb[2] = infobar
infobar:SetSize(me:GetWide()*.4525,me:GetTall()*.175)
infobar:SetPos(me:GetWide()*.475,me:GetTall()*.54)
infobar.Paint = function(self)
  local wg = 0
  local val = 0
  wg = me.Weight or wg
  if !me.Misc then return end
  local w = self:GetWide()*.315
  local spacing = self:GetWide()*.015
  PipBoy3000.AddInfo(0+(spacing*2)+(w*1),0,w,"WG",wg)  
  PipBoy3000.AddInfo(0+(spacing*3)+(w*2),0,w,"VAL",val)
end

local mw = me:GetWide()*.4
local pic = vgui.Create("DPanel",me)
tb[3] = pic
pic:SetSize(mw,me:GetTall()*.55)
pic:SetPos(me:GetWide()*.725 - (mw/2),me:GetTall()*.05)
pic.Paint = function(self)
  local cpic = Schema.Icons[me.Misc]
  if !cpic then
    return
  end
  surface.SetDrawColor(Schema.GameColor)
  surface.SetMaterial(Material(cpic))
  surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
end

return tb
end}

tab[5] = {Name = "Ammo",Func = function(me, x)
local tb = {}
--
local list = vgui.Create("pig_PanelList",me)
tb[1] = list
list:SetSize(me:GetWide() *.375,me:GetTall() *.615)
list:SetPos(x - 3,me:GetTall() *.166)
list:SetSpacing(1)
list.SortFList = function(list)
  for k,v in pairs(list:GetItems()) do
    v:Remove()
  end
  --
  for k,v in SortedPairs(LocalPlayer():FindInventoryByClass("fo3_ammo")) do
    local base = vgui.Create("DButton")
	base:SetText("")
    base:SetSize(list:GetWide(),me:GetTall() *.075)
	base.DoRightClick = function(self)
	  if v.Amount >= 10 then
	    if IsValid(pig.vgui.AmtBox) then pig.vgui.AmtBox:Remove() end
	    local box = Fallout_AmountBox("How many?", 0, v.Amount, function(amt)
		  surface.PlaySound("ui/app_off.wav")
	      DropItem(k, amt or 0)
	      v.Amount = v.Amount - (amt or 0)
	      if v.Amount <= 0 then
	        self:Remove()
	      end
		end)
		pig.vgui.AmtBox = box
	    return
	  end
	  surface.PlaySound("ui/app_off.wav")
	  DropItem(k)
	  v.Amount = v.Amount - 1
	  if v.Amount <= 0 then
	    self:Remove()
	  end
	end
	base.OnCursorEntered = function(self)
      self.ins = true
	  me.Ammo = k
	  me.Weight = math.Round(v.Weight,2)
      surface.PlaySound("ui/focus.mp3")
    end
    base.Paint = function(self)
      col = Schema.GameColor
      local name = k
	    if v.Amount > 1 then
		  name = name.." ("..v.Amount..")"
		end
	  if self.ins then
		local mh = self:GetTall()*.225
	    local mx = self:GetWide()*.04
		local my = self:GetTall()/2 - (mh/2)
		local lw = 2
		Fallout_Line(mx,my,"right",mh,true,col,lw)
        Fallout_Line(mx,my,"down",mh,true,col,lw)
		Fallout_Line(mx,my+mh-lw,"right",mh,true,col,lw)
		Fallout_Line(mx + mh-lw,my,"down",mh,true,col,lw)
	  end
      if !self.ins then 
        draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        return 
      end
      surface.SetDrawColor(col)
      surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
      draw.RoundedBox(0,0,0,self:GetWide(),self:GetTall(),Color(col.r,col.g,col.b,5))
      draw.SimpleText(name,"FO3FontPip",self:GetWide() *.1,self:GetTall() / 2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER) 
    end
    base.OnCursorExited = function(self)
      self.ins = false
    end
    list:AddItem(base)
  end
end
list:SortFList()
--
local infobar = vgui.Create("DPanel",me)
tb[2] = infobar
infobar:SetSize(me:GetWide()*.4525,me:GetTall()*.175)
infobar:SetPos(me:GetWide()*.475,me:GetTall()*.54)
infobar.Paint = function(self)
  local wg = 0
  local val = 0
  wg = me.Weight or wg
  if !me.Ammo then return end
  local w = self:GetWide()*.315
  local spacing = self:GetWide()*.015
  PipBoy3000.AddInfo(0+(spacing*2)+(w*1),0,w,"WG",wg)  
  PipBoy3000.AddInfo(0+(spacing*3)+(w*2),0,w,"VAL",val)
end

local mw = me:GetWide()*.4
local pic = vgui.Create("DPanel",me)
tb[3] = pic
pic:SetSize(mw,me:GetTall()*.55)
pic:SetPos(me:GetWide()*.725 - (mw/2),me:GetTall()*.05)
pic.Paint = function(self)
  local cpic = Schema.Icons[me.Ammo]
  if !cpic then
    return
  end
  surface.SetDrawColor(Schema.GameColor)
  surface.SetMaterial(Material(cpic))
  surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
end

return tb
end}
------------------------

function PipBoy3000.OpenItems(dont)
  if PipBoy3000.SavedMode != "ITEMS" then
    PipBoy3000.SavedTab = nil
  end
PipBoy3000.SavedMode = "ITEMS"
-----------------------
/*
local model = LocalPlayer().VMHands.VMWeapon
local pip = "pipboyarm01"
  if LocalPlayer():IsDonator() then
    pip = "pimpboy"
  end
local new_mat = "models/llama/"..pip.."_item"
model:SetSubMaterial(0,new_mat)
*/
----------------------
local screen = PipBoy3000.Base.Screen
local col = Schema.GameColor
local tbl = PipBoy3000.Base.Tabs
for k,v in ipairs(tab) do
PipBoy3000.MakeTab(v.Name,v.Func,k)
end
PipBoy3000.Base.Title = "ITEMS"
PipBoy3000.SortTabs()
--
  if PipBoy3000.SavedTab then
    local tab = PipBoy3000.SavedTab
    local but = PipBoy3000.Base.Tabs[tab]
	if IsValid(but) then
      but.DoClick(but)
	end
  else
    local but1 = PipBoy3000.Base.Tabs[1]
    but1.DoClick(but1,dont)
  end
------------------------------------------
screen.PaintFunc = function(me,text_x,line_y)
local x = text_x + (me:GetWide() *.015)
local spacing = me:GetWide() *.015
local w = me:GetWide() - (x+me:GetWide()*.075) - (spacing*3)
w = w/4
--
local outfit = LocalPlayer():GetOutfit()
local helmet = LocalPlayer():GetOutfit(true)
local dt = Fallout_OutfitDT(outfit)
  if dt and helmet then
    dt = dt+Fallout_OutfitDT(helmet)
  end
PipBoy3000.AddInfo(x,line_y,w,"WG",math.Round(LocalPlayer().WG,2).."/"..LocalPlayer():GetMaxWeight(),"FO3FontPip")
PipBoy3000.AddInfo(x + spacing + (w*1),line_y,w,"HP",LocalPlayer():Health().."/"..LocalPlayer():GetMaxHealth(),"FO3FontPip")
PipBoy3000.AddInfo(x + (spacing * 2) + (w*2),line_y,w,"DT",dt,"FO3FontPip")
PipBoy3000.AddInfo(x + (spacing * 3) + (w*3),line_y,w,"Caps",LocalPlayer():GetMoney(),"FO3FontPip")
end
--
end
