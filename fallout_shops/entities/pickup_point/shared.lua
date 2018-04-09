ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true
ENT.Base = "pig_ent_base"
ENT.Author = "extra.game"
ENT.Category = "Fallout 3 RP"
ENT.PrintName = "Pickup Point"
ENT.Spawnable = true
ENT.AdminSpawnable = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end