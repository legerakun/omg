ENT.Type = "anim"
ENT.Base = "pig_ent_base"
ENT.Author = "extra.game"
ENT.Category = "Fallout 3 RP"
ENT.PrintName = "Terminal"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:GetPassword()
local pass = self:GetNWString("Pass", "")
  if pass == "" or !pass then
    return
  end
return pass
end
