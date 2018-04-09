
function Fallout_CalcOdds(player1,player2)
  if IsValid(pig.vgui.Odds) then
    pig.vgui.Odds:Remove()
  end
pig.vgui.Odds = vgui.Create("Fallout_Frame")
local odds = pig.vgui.Odds
odds:SetSize(ScrW()*.6,ScrH()*.7)
odds:Center()
odds:MakePopup()
odds:SetTitle1("COMBAT ODDS")
odds:ShowClose(true)
odds.DownWidth = odds:GetTall()*.1

end

concommand.Add("test_Odds",function(ply)
Fallout_CalcOdds()
end)
