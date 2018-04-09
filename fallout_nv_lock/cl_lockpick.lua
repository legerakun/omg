
function Fallout_Lockpick(diff,as)
  if IsValid(pig.vgui.Lockscreen) then
    pig.vgui.Lockscreen:Remove()
  end
-----------
local difficulty = diff or math.random(50,110)
local angle_start = as or math.random(0,360-difficulty)
local angle_end = angle_start + difficulty
-----------
pig.vgui.Lockscreen = vgui.Create("DPanel")
local lock = pig.vgui.Lockscreen
lock:MakePopup()
lock:SetSize(ScrW(),ScrH())
lock.Opened = function(me)
  surface.PlaySound("lockpick/ui_lockpicking_unlock.wav")
  me:Remove()
end
  lock.Paint = function(me)
    Derma_DrawBackgroundBlur(me,SysTime()-1)
    draw.RoundedBox(0,0,0,me:GetWide(),me:GetTall(),Color(0,0,0,200))
  end
----
--
local ent = vgui.Create("DModelPanel",lock)
ent:SetCursor("blank")
ent:SetSize(lock:GetSize())
ent:SetModel("models/fallout/terminals/lockinterface.mdl")
local entity = ent:GetEntity()
local pos,ang = ent:GetEntity():GetBonePosition( 1 )
ent:SetCamPos(pos-Vector(-4,0,35))
local start = 0.1
entity.Rot = start
local max = 100
  function ent:LayoutEntity( entity )
    entity:SetAngles(Angle(-90,0,0))
	entity:ManipulateBoneAngles( 2, Angle(entity.Rot,0,0) )
	entity:ManipulateBoneAngles( 5, Angle(entity.Rot,-(entity.Rot*.25),0) )
  end
----
local bobby =vgui.Create("DModelPanel",lock)
bobby:SetCursor("blank")
bobby:SetSize(lock:GetSize())
bobby:SetModel("models/fallout/terminals/bobbypin.mdl")
local bob = bobby:GetEntity()
local pos,ang = bobby:GetEntity():GetBonePosition( 1 )
bobby:SetCamPos(pos-Vector(3,0,35))
bob.Rot = 0
bob.HP = 100
  function bobby:LayoutEntity( entity )
    entity:SetAngles(Angle(-90,0,0))
	entity:ManipulateBoneAngles( 1, Angle(entity.Rot,0,0) )
  end
----
--
local mx,my = lock:CursorPos()
lock.Mx = mx
lock.LastHit = CurTime() - 1
lock.NextSound = CurTime() - 1
  function lock:Think()
  local me = lock
    if me.Broke then
	  Fallout_Lockpick(difficulty,angle_start)
	  surface.PlaySound("lockpick/ui_lockpicking_pickbreak0"..math.random(1,3)..".wav")
	  me:Remove()
	  return
	end
  mx,my = lock:CursorPos()
  local speed = 100*FrameTime()
  ----------------------
  local off = mx/me:GetWide()
  off = math.Clamp(360*off,0,360)
  bob.Rot = (off)
  ----------------------
  local add = entity.Rot
    if input.IsKeyDown(KEY_A) then
	  local bpos = bob.Rot + ((difficulty*.8)*(entity.Rot/max))
	  --print(bpos..": AS: "..angle_start.." - "..angle_end)
	  if bpos >= angle_start and bpos <= angle_end then
	    if me.NextSound <= CurTime() and me.LastHit <= CurTime() then
	      me.NextSound = CurTime()+0.5
	      surface.PlaySound("lockpick/ui_lockpicking_cylindersqueak"..math.random(1,13)..".wav")
	    end
	    add = add+speed
	  else
	    me.LastHit = CurTime() + 1
		if me.NextSound <= CurTime() then
	      me.NextSound = CurTime()+0.5
	      surface.PlaySound("lockpick/ui_lockpicking_cylinderstop0"..math.random(1,4)..".wav")
	    end
	    add = (add-(speed*.5))
		local health = 100*FrameTime()
		bob.HP = bob.HP - health
	    if bob.HP <= 0 then
		  lock.Broke = true
		return end
	  end
	else
	  add = entity.Rot-(speed*1.5)
	end
  add = math.Clamp(add,start,max)
  entity.Rot = add
    if add >= max then
	  lock.Opened(lock)
	end
  end
---
end

concommand.Add("test_lock",function(ply,cmd,args)
  Fallout_Lockpick(args[1])
end)
