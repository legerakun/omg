ENT.Type = "anim"
ENT.Base = "pig_ent_base"
ENT.Author = "extra.game"
ENT.Category = "Gambling"
ENT.PrintName = "Spinjoy"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:CantPlaceBet(ply, timeleft, bet)
  if CLIENT and bet then
    if ply:GetChips() < bet then
	  return true
	end
  end
  --
  if timeleft > 10 then
    return true
  end
  --
  if SERVER then
    local tbl = self.Gamblers
	if tbl[ply:SteamID64()] and tbl[ply:SteamID64()].bet then
	  return true
	end
  end
  --
end

function ENT:NumToColor(num)
local tbl = {}
tbl[29] = "black"
tbl[25] = "red"
tbl[10] = "black"
tbl[27] = "red"
tbl[0] = "green"
tbl[1] = "red"
tbl[13] = "black"
tbl[36] = "red"
tbl[24] = "black"
tbl[3] = "red"
tbl[15] = "black"
tbl[34] = "red"
tbl[22] = "black"
tbl[5] = "red"
tbl[17] = "black"
tbl[32] = "red"
tbl[20] = "black"
tbl[7] = "red"
tbl[11] = "black"
tbl[30] =  "red"
tbl[26] = "black"
tbl[9] = "red"
tbl[28] = "black"
tbl[0] = "green"
tbl[2] = "black"
tbl[14] = "red"
tbl[35] = "black"
tbl[23] = "red"
tbl[4] = "black"
tbl[16] = "red"
tbl[33] = "black"
tbl[21] = "red"
tbl[6] = "black"
tbl[18] = "red"
tbl[31] = "black"
tbl[19] = "red"
tbl[8] = "black"
tbl[12] = "red"

return tbl[num]
end
