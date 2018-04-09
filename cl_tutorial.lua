
local function openHelpMenu(page, force)
  if IsValid(pig.vgui.HelpMenu) then
    pig.vgui.HelpMenu:Remove()
  end
pig.vgui.HelpMenu = vgui.Create("Fallout_HelpMenu")
local help = pig.vgui.HelpMenu
help:SetPage(page)
  if force then
    help.OnKeyCodeReleased = function(me, key)
      return
    end
    vgui.ForceDrawCursor = true
    help.OnRemove = function(me)
      vgui.ForceDrawCursor = false
    end
  end
end

-------------------------
--TABLE------------
local tbl = {}
tbl["Chatbox"] = function()
  openHelpMenu(1)
end
tbl["Pip-Boy"] = function()
  timer.Simple(6, function()
    UseItem("PipBoy 2500")
    openHelpMenu(2,true)
  end)
end
tbl["World Map"] = function()
  openHelpMenu(3,true)
end
tbl["Third Person"] = function()
  openHelpMenu(9)
end
tbl["Trading"] = function()
  timer.Simple(0.5, function()
    openHelpMenu(6)
  end)
end
tbl["Shop"] = function()
  timer.Simple(0.5, function()
    openHelpMenu(8)
  end)
end
tbl["Armor Editor"] = function()
  timer.Simple(0.5, function()
    openHelpMenu(7)
  end)
end
tbl["Gambling"] = function()
  timer.Simple(0.5, function()
    openHelpMenu(12)
  end)
end

function FalloutTutorial(str)
local tab = pig.GetOption("TutorialTable") or {}
--
  if tab[str] then
    return
  end
--
tbl[str]()
tab[str] = true
pig.SetOption("TutorialTable", tab)
end
