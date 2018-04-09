
function Schema.Hooks:pig_AddMenuButtons()
pig.PigMenuButtons[2] = {
  Name = "Inventory",
  panel = function(self)
    UseItem("PipBoy 2500")
	self:Remove()
    return
  end
}
pig.PigMenuButtons[5] = {
  Name = "Trade Offers",
  panel = "Fallout_Trades"
}
pig.PigMenuButtons[6] = {
  Name = "Armor Editor",
  panel = function()
    local panel = InspectOpen()
	return panel
  end
}
pig.PigMenuButtons[7] = {
  Name = "Perk Flags",
  panel = function()
    local panel = Fallout_Perks()
	return panel
  end
}
pig.PigMenuButtons[8] = {
  Name = "Shop",
  panel = function()
    local panel = Shop.ShowMenu()
	return panel
  end
}
pig.PigMenuButtons[9] = {
  Name = "Factions",
  panel = "Fallout_Factions"
}
pig.PigMenuButtons[10] = {
  Name = "Help Menu",
  panel = "Fallout_HelpMenu"
}
pig.PigMenuButtons[11] = {
  Name = "S.P.E.C.I.A.L",
  panel = function()
    local panel = Fallout_SPECIAL()
	return panel
  end
}
end
