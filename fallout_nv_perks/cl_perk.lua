
function Fallout_Perks()
  if IsValid(pig.vgui.PerkMenu) then
    pig.vgui.PerkMenu:Remove()
  end
pig.vgui.PerkMenu = vgui.Create("pig_Attributes")
local menu = pig.vgui.PerkMenu
menu.Reset:Remove()
menu:Center()
menu:MakePopup()
  menu.UpdateDown = function(me)
    local item = "PERKS"
    me.DownText = "SELECT 0 "..item
  end
menu.UpdateDown(menu)
menu.Perks = {}
--
for k,v in pairs(menu.AttributeTable:GetItems()) do
  v:Remove()
end
--
local text1 = menu.Title
local text2 = menu.Blur
for k,v in SortedPairs(Fallout_GetPerks()) do
  if !LocalPlayer():HasFlag(v.Flag) then continue end
  local base = vgui.Create("DButton")
  base:SetSize(menu.AttributeTable:GetWide(),menu.AttributeTable:GetTall()/13)
  base:SetText("")
  base.OnCursorEntered = function(me)
    surface.PlaySound("ui/focus.mp3")
	me.ins = true
    menu.SelectedImage = Material(Fallout_PerkIcon(k), "noclamp smooth")
    local text = Fallout_PerkDescription(k)
	text = me.Text.."\nFlag: "..v.Flag.."\n\n"..text
    menu.DescPanel.Text:SetText(text)
	menu.DescPanel.TextBlur:SetText(text)
  end
  base.OnCursorExited = function(me)
    me.ins = false
  end
  base:SetTextColor(Schema.GameColor)
  base.Text = "Req: Super-Admin Grant / Forum Application"
  base.Paint = function(me)
  local col = Schema.GameColor
    if me.ins then
	  surface.SetDrawColor(col)
	  surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
	  surface.SetDrawColor(col)
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
	end
	if table.HasValue(menu.Perks,k) then
	  local dw = me:GetTall()*.3
	  surface.SetDrawColor(col)
      surface.DrawRect(me:GetWide()*.025,me:GetTall()/2 - (dw/2),dw,dw)
	end
    if me.Disabled then
	  col = Color(col.r*.5,col.g*.5,col.b*.5)
	end
    draw.SimpleText(k, "FO3FontHUD", me:GetWide() *.075, me:GetTall()/2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  end  
  
  menu.AttributeTable:AddItem(base)
end
--
for k,v in SortedPairs(Fallout_GetPerks()) do
  if LocalPlayer():HasFlag(v.Flag) then continue end
  local base = vgui.Create("DButton")
  base:SetSize(menu.AttributeTable:GetWide(),menu.AttributeTable:GetTall()/13)
  base:SetText("")
  base.OnCursorEntered = function(me)
    surface.PlaySound("ui/focus.mp3")
	me.ins = true
    menu.SelectedImage = Material(Fallout_PerkIcon(k), "noclamp smooth")
    local text = Fallout_PerkDescription(k)
	text = me.Text.."\nFlag: "..v.Flag.."\n\n"..text
    menu.DescPanel.Text:SetText(text)
	menu.DescPanel.TextBlur:SetText(text)
  end
  base.OnCursorExited = function(me)
    me.ins = false
  end
  base:SetTextColor(Schema.GameColor)
  base.Text = "Req: Super-Admin Grant / Forum Application"
  base.Disabled = true
  base.Paint = function(me)
  local col = Schema.GameColor
    if me.ins then
	  surface.SetDrawColor(col)
	  surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
	  surface.SetDrawColor(col)
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
	end
	if table.HasValue(menu.Perks,k) then
	  local dw = me:GetTall()*.3
	  surface.SetDrawColor(col)
      surface.DrawRect(me:GetWide()*.025,me:GetTall()/2 - (dw/2),dw,dw)
	end
    if me.Disabled then
	  col = Color(col.r*.5,col.g*.5,col.b*.5)
	end
    draw.SimpleText(k, "FO3FontHUD", me:GetWide() *.075, me:GetTall()/2, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
  end  
  --
  base.DoClick = function(me)
    if me.Disabled or !LocalPlayer():IsSuperAdmin() then return
    elseif table.HasValue(menu.Perks,k) then
	  surface.PlaySound("ui/ui_menu_prevnext.wav")
	  table.RemoveByValue(menu.Perks,k)
	  return
	end
	surface.PlaySound("ui/ui_menu_prevnext.wav")
	table.insert(menu.Perks,k)
  end
  
  menu.AttributeTable:AddItem(base)
end
--
  menu.CloseButton.DoClick = function(me)
    surface.PlaySound("ui/ok.mp3")
	/*
    if table.Count(me:GetParent().Perks) > 0 then
      net.Start("F_Perk")
	  net.WriteTable(me:GetParent().Perks)
	  net.SendToServer()
	  LocalPlayer().LastPerk = CurTime()+60
    end*/	
    me:GetParent():Remove()
  end
return menu
end
