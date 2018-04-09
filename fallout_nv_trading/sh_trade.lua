local char = FindMetaTable("Player")

function char:IsTradeDisabled()
return 
end

-------------------------------
Schema.ChatCommands["Trade"] = {
cmd = "trade",--The Chat Command to type
--col = Color(204,204,0),--Color of the chat
--range = 100,--The range of people so that they can see it
--global = false,--Set true so everyone can see regardless of position 
non_text_callback = true,--Set to true to activate the commands function Server-side. Set to false to activate Client-side.
--no_colon = true,--Takes away the ":" in the text
--tag = "[Trade]",
--tag_col = Color(204,204,0),
func = function(ply)--The function callback. Used to easily return the new text. func( player that typed , player text )
  ply.LastTrade = ply.LastTrade or CurTime() - 1
  if ply.LastTrade > CurTime() then return end
  local ent = pig.utility.PlayerQuickTrace(ply,110).Entity
  if !IsValid(ent) or !ent:IsPlayer() then return end
  ply.LastTrade = CurTime() + Schema.TradeTraceCool
  --
    if ent:IsTradeDisabled() then 
      PW_Notify(ply,Schema.RedColor,"This person has disabled trade offers")
    return end
    ply:OpenTrade(ent)
  end
}
