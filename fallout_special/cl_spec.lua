
function Fallout_SPECIAL(tag_amt)
  if IsValid(pig.vgui.Special) then
    pig.vgui.Special:Remove()
  end
  pig.vgui.Special = vgui.Create("pig_Attributes")
  local att = pig.vgui.Special
  att:MakePopup()
  att:Center()
  att.SkillPoints = LocalPlayer():GetSpecialPoints()
  att.Skill = "S.P.E.C.I.A.L. POINTS"
  att.DownFont = "FO3Font"
  --
  local old = att.CloseButton.DoClick
  att.CloseButton.DoClick = function(me)
  surface.PlaySound("ui/ui_menu_prevnext.wav")
  local atts = {}
  local total = 0
    for k,v in pairs(me:GetParent().AttributeTable:GetItems()) do
      local point = v.Val - v.Orig
      total = total + point
  	  atts[v.Attribute] = point
	  LocalPlayer():AddToAttribute(v.Attribute,point)
    end
    if total > 0 then
      net.Start("F_SetSpec")
      net.WriteTable(atts)
      net.SendToServer()
    end
	if tag_amt then
	  Fallout_TagSkills(tag_amt)
	end
    me:GetParent():Remove()
  end
  --
  for k,v in pairs(att.AttributeTable:GetItems()) do v:Remove() end
  local special = Fallout_GetSpecial()
    for k,v in SortedPairs(special) do
	  local point = LocalPlayer():GetAttributeValue(v)
	  local var = {Point = point, Lock = point}
	  if point == nil then continue end
	  local base = att.MakeButt(att,v,var)
	  att.AttributeTable:AddItem(base)
	end
return att
end

net.Receive("F_OpenSpec",function()
Fallout_SPECIAL()
end)

concommand.Add("test_SPECIAL",function()
Fallout_SPECIAL()
end)

function Fallout_SPECIALCharSel(id)
local amt = 3
  if LocalPlayer():GetLevel() == 1 and LocalPlayer():GetSkillPoints() >= (15*amt) then
    Fallout_SPECIAL(amt)
  end
end
