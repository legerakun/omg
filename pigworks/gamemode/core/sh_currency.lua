local char = FindMetaTable("Player")

if SERVER then

function char:SetMoney(amt,added)
if tonumber(amt) == nil then
error("Invalid Integer provided!")
return end
amt = math.Round(amt)
local hooks,can = hook.Call("pig_MoneyChanged",GAMEMODE,self,self:GetMoney(),amt,added or 0)
  if can == false then return false end
  if hooks != nil then
    amt = hooks
  end
self:SetCharVar("Money",amt,true)
self:SetNWFloat("Money", amt)
end

function char:DropMoney(amt)
if tonumber(amt) == nil then
error("Invalid Integer provided!")
return end
CreateMoneyAtPly(amt,self)
self:AddMoney(-amt)
PW_Notify(self,Schema.GameColor,"You dropped "..amt.." "..Schema.Currency.."", Schema.CurrencyDropIcon)
end

function CreateMoneyAtPly(amt,ply)
CreateMoney(amt,ply:GetPos() + ply:GetAngles():Up() * 30 + ply:GetAngles():Forward() * 40,ply:GetAngles())
end

function CreateMoney(amt,pos,ang)
local money = ents.Create("pig_money")
money:SetPos(pos)
money:SetAngles(ang)
money:Spawn()
money:SetAmount(amt)
end

function char:AddMoney(amt)
if tonumber(amt) == nil then
error("Invalid Integer provided!")
return end
amt = math.Round(amt)
self:SetMoney(self:GetMoney() + amt,amt)
end

concommand.Add("PW_SetMoney",function(ply,cmd,args)
  local money = tonumber(args[2])
  local ply2 = pig.FindPlayerByName(args[1])
    if ply2 == nil then
	  MsgC(Color(204,0,0),"\n[PigWorks SV]: Player not found!\n")
	  return
	elseif money == nil then
	  MsgC(Color(204,0,0),"\n[PigWorks SV]: Invalid amount of money!\n")
	  return
	end
	MsgC(Color(0,0,204),"\n[PigWorks SV]: "..ply:GetName().." set "..ply2:GetName().."'s Money from "..ply2:GetMoney().." to "..money.."\n")
	ply2:SetMoney(money)
end)

end

function char:GetMoney()
  if CLIENT and self != LocalPlayer() then
    return self:GetNWFloat("Money",0)
  end
return tonumber(self:GetCharVar("Money"))
end

if CLIENT then


end

-------------------------
--CHAT COMMANDS
Schema.ChatCommands["dropmoney"] = {
cmd = "dropmoney",
col = Color(255,255,255),
global = false,
range = 0,
non_text_callback = true,
func = function(ply,text)
  local command = "dropmoney  "
  text = text:sub(command:len(),text:len())
  local amt = tonumber(text)
  local money = ply:GetMoney()
  if amt == nil or amt <= 0 then
    return
  elseif amt > money then
    PW_Notify(ply, Schema.RedColor, "You do not have this much money to drop")
	return
  end
  --
  ply:DropMoney(amt)
end
}