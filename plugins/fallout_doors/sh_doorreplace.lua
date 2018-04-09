local Plugin = {}
-- Quick little prop_dynamic mod that makes it so that prop_dynamics of a certain model will automatically react to the USE key and play the right sound.
-- If you're using NP++, the indentation might be fucked for you, not sure, I use atom and it looks fine for me, not sure why it does this. :(
--  - Bizzclaw

local DoorTrace = {
  mins = Vector(-6,-6,-6),
  maxs = Vector(6,6,6),
  mask = MASK_SOLID,
  dist = 90,
}

DoorReplacements = DoorReplacements or {} -- table of models, global so people can add their own doors to it with external scripts I guess whyt not???

DoorReplacements["models/fallout/clutter/clfence/clfencegate01.mdl"] = { -- table is keyed by the model name
  opentext = LangText and "#DOOR_GATE_OPEN" or "Open Gate",
  closetext = LangText and "#DOOR_GATE_CLOSE" or "Close Gate",
  snd_open = "fx/drs/drs_gatechainlink_01_open.mp3", -- opening sound, you can mke this a table and it will select random ones.
  snd_close = "fx/drs/drs_gatechainlink_01_close.mp3", -- closing sound
  snd_delay_open = 0, -- delay before open sound plays
  snd_delay_close = 1, -- ditto, but for closing
  snd_lock = "physics/metal/metal_chainlink_impact_soft1.wav",
  anim_open = "open", -- sequence for opening, default "open"
  anim_close = "close", -- ditto, default "close"
}
DoorReplacements["models/fallout/clutter/clfence/clfencegateroad01.mdl"] = {
  opentext = LangText and "#DOOR_GATE_OPEN" or "Open Gate",
  closetext = LangText and "#DOOR_GATE_CLOSE" or "Close Gate",
  snd_open = "fx/drs/drs_gatechainlink_01_open.mp3",
  snd_close = "fx/drs/drs_gatechainlink_01_close.mp3",
  snd_delay_close = 1
}
DoorReplacements["models/fallout/dungeons/utility/utldoor01.mdl"] = {
  opentext = LangText and "#DOOR_DOOR_OPEN" or "Open Door",
  closetext = LangText and "#DOOR_DOOR_CLOSE" or "Close Door",
  snd_open = "fx/drs/drs_metalutilitysmall_open.mp3",
  snd_close = "fx/drs/drs_metalutilitysmall_close.mp3"
}
DoorReplacements["models/fallout/dungeons/vault/halls/vdoor01.mdl"] = {
  opentext = LangText and "#DOOR_DOOR_OPEN" or "Open Door",
  closetext = LangText and "#DOOR_DOOR_CLOSE" or "Close Door",
  snd_open = "fx/drs/vault/drs_vault_blast_01_open.mp3",
  snd_close = "fx/drs/vault/drs_vault_blast_01_close.mp3"
}
DoorReplacements["models/fallout/dungeons/vault/doors/vdoorsliding01.mdl"] = {
  opentext = LangText and "#DOOR_DOOR_OPEN" or "Open Door",
  closetext = LangText and "#DOOR_DOOR_CLOSE" or "Close Door",
  snd_open = "fx/drs/vault/drs_vaultvertical_01_open.mp3",
  snd_close = "fx/drs/vault/drs_vaultvertical_01_close.mp3"
}
DoorReplacements["models/fallout/dungeons/enclave/ecvdoorsm01.mdl"] = {
  opentext = LangText and "#DOOR_DOOR_OPEN" or "Open Door",
  closetext = LangText and "#DOOR_DOOR_CLOSE" or "Close Door",
  snd_open = "fx/drs/drs_enclave_small_open.mp3",
  snd_close = "fx/drs/drs_enclave_small_close.mp3"
}
DoorReplacements["models/fallout/dungeons/enclave/ecvdoorbg01.mdl"] = {
  opentext = LangText and "#DOOR_DOOR_OPEN" or "Open Door",
  closetext = LangText and "#DOOR_DOOR_CLOSE" or "Close Door",
  snd_open = "fx/drs/drs_enclave_large_open.mp3",
  snd_close = "fx/drs/drs_enclave_large_close.mp3"
}
DoorReplacements["models/optinvfallout/moatgate.mdl"] = {
  opentext = LangText and "#DOOR_DOOR_OPEN" or "Open Door",
  closetext = LangText and "#DOOR_DOOR_CLOSE" or "Close Door",
  snd_open = "fx/drs/drs_enclave_large_open.mp3",
  snd_close = "fx/drs/drs_enclave_large_close.mp3"
}

local function CanUseDoor(door)
  return IsValid(door) and (door:GetCycle() <= 0.05 or door:GetCycle() >= 0.95)
end

if SERVER then -- didn't feel like splitting this in to two files, this is getting released anyways
  function InitDoors()
  	local ents1 = ents.FindByClass("prop_dynamic")
  	for k, v in pairs(ents1) do
  		local Dtable = DoorReplacements[v:GetModel()]
  		if Dtable then
  			v.Dtable = Dtable
  		end
  	end
  end
  InitDoors()
  
  local function UpdateDoors(pos)
    for _, door in ipairs(ents.FindByClass("prop_door_rotating")) do
      if pos and door:GetPos():Distance(pos) > 256 then continue end
      timer.Create("DoorUpdate_"..door:EntIndex(), 0.5, 1, function()
        local tab = door:GetSaveTable()
        local state = tonumber(tab.m_eDoorState)
        if tab.m_bLocked then
          door:SetNWString("DoorUse", "PromptLocked")
        elseif state == 9 or state == 3 then
          door:SetNWString("DoorUse", "PromptOpen")
        else
          door:SetNWString("DoorUse", "PromptClose")
        end
      end)
    end
  end
  
  function Plugin:OnEntityCreated(ent)
    if ent:GetClass() == "prop_dynamic" then
      local Dtable = DoorReplacements[ent:GetModel()]
      if Dtable then
        ent.Dtable = Dtable
      end
    end
  end

  function Plugin:InitPostEntity()
    InitDoors()
  end

  function Plugin:KeyPress(ply, key)
	if key == IN_USE then
      UpdateDoors(ply:GetPos())
    end
	--
    if ply:Alive() and key == IN_USE then

      local traced = table.Copy(DoorTrace) -- copy the table to tracedata, or ,traced so it doens't get overridden
      traced.start = ply:EyePos()
      traced.endpos = traced.start + ply:EyeAngles():Forward() * traced.dist
      traced.filter = ply

      local htr = util.TraceHull(traced)
      local door = htr.Entity

      if IsValid(door) and door.Dtable then
        local d = door.Dtable
        if door:GetSaveTable().m_bLocked then
          if d.snd_lock then
            door:EmitSound(d.snd_lock, 60)
          end
          return false
        end

        if not CanUseDoor(door) then return false end

        door.Open = not door.Open
        local anim = door.Open and (d.anim_open or "open") or (d.anim_close or "close")
        local snd = door.Open and d.snd_open or d.snd_close
        local delay = door.Open and (d.opentime or 1) or (d.closetime or 1)

        door:SetPlaybackRate(1)
        door:Fire("SetAnimation", anim)

        if snd then
          if istable(snd) then
            snd = table.Random(snd)
          end
          local delaytime = door.Open and (d.snd_delay_open or 0) or d.snd_delay_close or 0
          timer.Simple(delaytime, function()
            if not IsValid(door) then return false end
            door:EmitSound(snd, d.soundlvl or 70)
          end)
        end
      end
    end
  end

  concommand.Add("rsrg_testdoor", function(ply, cmd, args)
    if not ply:IsAdmin() then return false end

    local mdl = args[1]
    if not mdl or not DoorReplacements[mdl] then return false end
    local door = ents.Create("prop_dynamic")
    door:SetModel(mdl)
    door.Dtable = DoorReplacements[mdl]
    door:SetPos(ply:GetEyeTrace().HitPos)
    door:SetAngles(Angle(0,ply:EyeAngles().y,0))


    door:SetKeyValue( "solid", "6" )
    door:Spawn()
    door:Activate()

    undo.Create("Door")
    undo.AddEntity(door)
    undo.SetPlayer(ply)
    undo.Finish()
  end)

else


  local font = RSRG and "PDALarge" or "Trebuchet24"
  local NextCheck = 0
  local CurDoor
  local CurDoorText = ""
  local DoorA = 0

  local function GenerateDoorInfo(CurDoor)
    local e = "["..string.upper(input.LookupBinding("+use") or "USE KEY UNBOUND").."]" -- might aswell putt his here in case they change their bindings mid-game.
    local Text_Open = LangText and LangText(CurDoor.Dtable.opentext) or CurDoor.Dtable.opentext or "Open"
    local Text_Close = LangText and LangText(CurDoor.Dtable.closetext) or CurDoor.Dtable.closetext or "Close"
    CurDoorText = e.." "..(CurDoor:GetSequence() == CurDoor:LookupSequence(CurDoor.Dtable.anim_open or "open") and Text_Close or Text_Open)
  end

  function Plugin:HUDPaintOnTop()
    if CurTime() > NextCheck then
      local ply = LocalPlayer()
      local traced = table.Copy(DoorTrace)
      traced.start = ply:EyePos()
      traced.endpos = traced.start + ply:EyeAngles():Forward() * traced.dist
      traced.filter = ply

      local htr = util.TraceHull(traced)
      NextCheck = CurTime() + 0.2
      local door = htr.Entity
      if IsValid(door) and door:GetClass() == "prop_dynamic" and CanUseDoor(door) then
        if not CurDoor or CurDoor != door then
          door.Dtable = door.Dtable or DoorReplacements[door:GetModel()]
          CurDoor = door.Dtable and door or false
          if CurDoor then
            GenerateDoorInfo(CurDoor)
          end
        end
      else
        CurDoor = nil
      end
    end
    if CurDoor and CanUseDoor(CurDoor) then
      DoorA = DoorA != 1 and math.Approach(DoorA, 1, FrameTime()*5) or 1
    elseif DoorA != 0 then
      DoorA = math.Approach(DoorA, 0, FrameTime()*3)
    end
    if DoorA > 0 then
      surface.SetAlphaMultiplier(DoorA)
      draw.SimpleTextOutlined(CurDoorText, font, ScrW()*0.5,ScrH()*0.8, RSRG and RSRG.Colors.HudColor or Color(255,255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, Color(0,0,0,85))
    end
    surface.SetAlphaMultiplier(1)
  end
  
end

return Plugin