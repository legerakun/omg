
function Schema.Hooks:pig_Cl_XPAdded(before,after,added)
surface.PlaySound("ui/ui_xp_up.mp3")
end

function Fallout_LevelMenu(new_level)
surface.PlaySound("ui/leveltheme.mp3")
  if IsValid(pig.vgui.LevelUp) then 
    pig.vgui.LevelUp:Remove() 
  end
pig.vgui.LevelUp = vgui.Create("pig_Attributes")
local att = pig.vgui.LevelUp
local text = att.Title
local blur = att.Blur
text:SetText("WELCOME TO LEVEL "..new_level)
blur:SetText("WELCOME TO LEVEL "..new_level)
att:Center()
att:MakePopup()
end

function Fallout_LevelText(new_level)
surface.PlaySound("ui/ui_level.mp3")
  if IsValid(pig.vgui.LevelText) then
    pig.vgui.LevelText:Remove()
	pig.vgui.LevelText.Blur:Remove()
  end
  local w,h,x,y = FalloutHUDSize()
  text,blur = Fallout_DLabel(nil,x,y,"LEVEL UP","FO3FontBig",Schema.GameColor)
  pig.vgui.LevelText = text
  text.Blur = blur
  --
  y = y - ScrH()*.05
  text:SetPos((ScrW()-x)-text:GetWide(),y-text:GetTall())
  blur:SetPos((ScrW()-x)-text:GetWide(),y-blur:GetTall())
  --
  timer.Simple(2.5,function()
    Fallout_LevelMenu(new_level)
	  if IsValid(text) then
        text:Remove()  
      end
  end)
end

function Schema.Hooks:pig_Cl_LevelUp(pre_level,new_level)
  timer.Simple(2.5,function()
    Fallout_LevelText(new_level)
	  if IsValid(pig.vgui.XPBar) then
	    pig.vgui.XPBar:Remove()
	  end
  end)
end
