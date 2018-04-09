include("shared.lua")

function ENT:Draw()
	self:DrawModel()
end

function ENT:Use(ply)
  if IsValid(pig.vgui.BenchMenu) then
    pig.vgui.BenchMenu:Remove()
  end
pig.vgui.BenchMenu = vgui.Create("Fallout_LootMenu")
local base = pig.vgui.BenchMenu
base:SetTitles("RECIPES","WORKBENCH")
local my_inv = base.Table1
local l_inv = base.Table2
local cur_itm = nil

  local actual = vgui.Create("pig_PanelList",l_inv)
  actual:SetSize(l_inv:GetWide()*.9,l_inv:GetTall()*.35)
  actual:SetPos(l_inv:GetWide()*.1,l_inv:GetTall()-(actual:GetTall()) )
  actual.MakeList = function(me,mats)
	  for a,b in pairs(actual:GetItems()) do b:Remove() end
	  for a,b in pairs(mats) do
	    local ta = vgui.Create("DPanel")
		ta:SetSize(me:GetWide(),actual:GetTall()/4)
		ta.Paint = function(self)
		  local p_col = Schema.GameColor
		  local name = (Schema.InvNameTbl[a] or a)
		  local ours = LocalPlayer():GetInvAmount(name)
		    if ours < b then
			  p_col = Color(p_col.r*.65,p_col.g*.65,p_col.b*.65)
			end
		  draw.SimpleText(name.." ("..ours.."/"..b..")","FO3FontHUD",self:GetWide()*.05,self:GetTall()/2,p_col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
		end
		me:AddItem(ta)
	  end
  end
  
  
  for k,v in SortedPairs(Fallout_Items) do
    --if !v.Weapon then continue end
	local tab = pig.CreateButton(nil,"","FO3FontSmall")
    tab:SetSize(my_inv:GetWide(),my_inv:GetTall()/7)
	tab.OnCursorEntered = function(me)
	  surface.PlaySound("ui/focus.mp3")
	  me.ins = true
	  cur_itm = k
	  base.dam = 0
	  base.wg = 0
	  base.val = 0
	  base.pic = Schema.Icons[v.Class] or "pw_fallout/icons/misc/junk.png"
	  base.cnd = 100
      actual.MakeList(actual,v.Materials)
	end
	tab.DoClick = function(me)
	  surface.PlaySound("ui/ok.mp3")
	  local window = Derma_Query("Do you wish to craft "..k.."?", "",
			"Accept", function() 
			  local status = LocalPlayer():CraftClientItem(k)
			    if status != true then
				  surface.PlaySound("ui/notify.mp3")
				  base:Remove()
				  me.Can = false
				else
				  surface.PlaySound("ui/craft"..math.random(1,2)..".mp3")
				  net.Start("F_WCraft")
				  net.WriteString(k)
				  net.SendToServer()
				  me.Can = true
				end
			end,
			"Decline", function() surface.PlaySound("ui/ok.mp3") end)
	  window.OldPaint = window.Paint
	  window.Paint = function(self)
	    Derma_DrawBackgroundBlur(self,SysTime()-0.35)
	    self:OldPaint(self)
	  end
	end
	  if LocalPlayer():CanCraftItem(k) then
	    tab.Can = true
	  else
	    tab.Can = false
	  end
	tab.Paint = function(me)
	  local col = Schema.GameColor
	  if me.Can then
	    draw.SimpleText(k,"FO3FontHUD",me:GetWide()*.05,me:GetTall()/2,col,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  else
	    draw.SimpleText(k,"FO3FontHUD",me:GetWide()*.05,me:GetTall()/2,Color(col.r*.6,col.g*.6,col.b*.6),TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
	  end
	  if !me.ins then return end
	  col = me.Color or col
	  surface.SetDrawColor(col)
	  surface.DrawOutlinedRect(0,0,me:GetWide(),me:GetTall())
	  draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(col.r,col.g,col.b,5))
	end
	my_inv:AddItem(tab)
  end
  
  l_inv.Paint = function(me)
    Fallout_DrawText(me:GetWide()*.05,me:GetTall()*.05,"Skill Requirements","FO3Font",Schema.GameColor)
	  surface.SetFont("FO3Font")
	  local tw,th = surface.GetTextSize("S")
	  local multi = 0
	  if cur_itm then
	    for k,v in pairs(Fallout_Items[cur_itm].Skills) do
		  multi = multi + 1
		  Fallout_DrawText(me:GetWide()*.085,me:GetTall()*.1+(th*multi),k.." ("..LocalPlayer():GetAttributeValue(k).."/"..v..")","FO3FontHUD",Schema.GameColor)	
	  	end
		--multi = multi + 1
		--Fallout_DrawText(me:GetWide()*.0835,me:GetTall()*.1+(th*multi),"(Tier 1 Weapons)","FO3FontHUD",Schema.GameColor)	
	  end
	 -----------
	  Fallout_DrawText(me:GetWide()*.05,me:GetTall()*.535,"Materials","FO3Font",Schema.GameColor)
  end
end
