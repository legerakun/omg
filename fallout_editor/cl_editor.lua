print("[Editor]: Loaded!")
local cMdl = FindMetaTable("Entity")
FCL_Models = FCL_Models or {}

function CreateFModel(model)
local mdl = ClientsideModel(model)
table.insert(FCL_Models,mdl)
return mdl
end

function cMdl:PerformAnim(anim,speed)
  anim = anim:lower()
  local seq = self:LookupSequence( anim )
  self:SetSequence( seq or 1 )
  self.AnimSpeed = (speed or 1)
end

function InspectOpen()
  if IsValid(pig.vgui.InspectMenu) then
    pig.vgui.InspectMenu:Remove()
  end
pig.vgui.InspectMenu = vgui.Create("FInspect")
local menu = pig.vgui.InspectMenu
menu:Center()
menu:MakePopup()
menu:ShowClose(true)
menu:SetTitle1("ARMOR EDITOR")
--
local close = menu.CloseButton
local mx,my = close:GetPos()
close:SetPos(menu:GetWide()*.04,my)
return menu
end
concommand.Add("FIOpen",InspectOpen)

function FCLThink()
  for k,v in pairs(FCL_Models) do
  if !v then break end
    if !IsValid(v) or !v.AnimSpeed then FCL_Models[k] = nil continue end
    v.LastAdvace = v.LastAdvace or 0
	local frametime = ( RealTime() - v.LastAdvace ) * v.AnimSpeed
    v:FrameAdvance( frametime )
  end
end