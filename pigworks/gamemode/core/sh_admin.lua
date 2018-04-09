
if SERVER then
util.AddNetworkString("PW_ANotify")

function GM:PlayerNoClip(ply)
  return ply:IsModerator()
end

function pig.AdminNotify(str)
  for k,v in pairs(player.GetAll()) do
    if v:IsAdmin() or v:IsModerator() then
	  v:PrintMessage(HUD_PRINTCONSOLE,"[PW ADMIN NOTIFY]: "..str)
	  net.Start("PW_ANotify")
	  net.WriteString(str)
	  net.Send(v)
	end
  end
end

end

function GM:CanTool( ply, tr, tool )
  if ply:IsAdmin() then
    return true
  end
end

local plyMeta = FindMetaTable("Player")
function plyMeta:IsModerator()
if self:IsAdmin() then return true end
local usergroup = self:GetUserGroup()
  if usergroup:lower():find("moderator") then
    return true
  end
  if Schema.ModeratorGroups and table.HasValue(Schema.ModeratorGroups, usergroup) then
    return true
  end
end

if CLIENT then

net.Receive("PW_ANotify",function()
local str = net.ReadString()
--
chat.AddText(Color(204,20,20),"[PW Admin]: ", Color(255,255,255), str)
end)

concommand.Add("PW_AdminMenu",function(ply)

pig.vgui.AdminMenu = vgui.Create("pig_AdminMenu")
local menu = pig.vgui.AdminMenu
menu:SetSize(ScrW() / 2,ScrH() *.75)
menu:Center()
menu:MakePopup()

end) 

end
