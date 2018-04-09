TOOL.Category = "Fallout 3"
TOOL.Name = "Container Placer"
TOOL.Command = nil
TOOL.ConfigName	= nil

if (CLIENT) then
	language.Add("tool.container.name", "Container Placer")
	language.Add("tool.container.desc", "Place containers that automatically save on spawn")
	language.Add("tool.container.0", "LeftClick to place container, RightClick to remove the one you're facing")	
end

function TOOL:Reload()

end

function TOOL:LeftClick(trace)
if !SERVER then return true end
self.LastClick = self.LastClick or CurTime() - 1
if self.LastClick > CurTime() then return end
self.LastClick = CurTime()+0.2
local owner = self:GetOwner()
if !owner:IsSuperAdmin() then return end
--
local pos = trace.HitPos
local ang = Angle(0, self:GetOwner():GetAngles()[2], 0)
--
local ent = ents.Create("container")
ent:SetPos(pos)
ent:SetAngles(ang)
ent:Spawn()
local cid = FalloutSaveContainer(ent)
ent.CID = cid
pig.ChatPrint(owner, Color(204, 204, 0), "[Containers]: Successfully placed and saved container")
--
return true
end

function TOOL:RightClick(trace)
if !SERVER then return true end
self.LastClick = self.LastClick or CurTime() - 1
if self.LastClick > CurTime() then return end
self.LastClick = CurTime()+0.2
local owner = self:GetOwner()
if !owner:IsSuperAdmin() then return end
--
local ent = trace.Entity
if !IsValid(ent) or ent:GetClass() != "container" then return end
FalloutDeleteContainer(ent)
pig.ChatPrint(owner, Color(204, 0, 0), "[Containers]: Successfully removed container from Database")
--
return true
end

function TOOL:Allowed()
return true
end