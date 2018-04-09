-------------------------
--CONFIG
local function initSTELARIS()
--
  STELARIS.CombatTime = 18--Seconds that combat music lasts, before taking more damage
  --
  STELARIS.RegisterTrack("Desert Wanderer","nv_ambiant/nv_1.mp3",213,false,100)
  STELARIS.RegisterTrack("Shady Sands","nv_ambiant/nv_2.mp3",244,false,100, {"Legion"})
  STELARIS.RegisterTrack("Mojave Express","nv_ambiant/nv_3.mp3",210,false,100)
  STELARIS.RegisterTrack("The Courier","nv_ambiant/nv_4.mp3",244,false,100, {"NCR"})
  STELARIS.RegisterTrack("Lone Drifter","nv_ambiant/nv_5.mp3",205,false,100, {"Legion"})
  STELARIS.RegisterTrack("Goodsprings","nv_ambiant/nv_6.mp3",131,false,100, {"NCR"})  
  STELARIS.RegisterTrack("Desert Wastes","nv_ambiant/nv_7.mp3",180,false,100, {"Legion"})
  STELARIS.RegisterTrack("Knock on my Cazadore","nv_ambiant/nv_8.mp3",120,false,100, {"NCR"})
  STELARIS.RegisterTrack("Desert Wastes #2","nv_ambiant/nv_9.mp3",258,false,100, {"NCR"})
  STELARIS.RegisterTrack("Marcus Needs a Favour","nv_ambiant/nv_10.mp3",243,false,100, {"Legion"})  
  STELARIS.RegisterTrack("Desert Wastes #3","nv_ambiant/nv_11.mp3",243,false,100)    
  STELARIS.RegisterTrack("Thorn in my Side","nv_ambiant/nv_12.mp3",253,false,100, {"NCR"})
  STELARIS.RegisterTrack("The Courier Walks Softly","nv_ambiant/nv_13.mp3",246,false,100)  
  -------------
  --COMBAT
  STELARIS.RegisterTrack("Combat #1","nv_ambiant/combat_1l.mp3",120,true,100)  
  STELARIS.RegisterTrack("Combat #2","nv_ambiant/combat_2l.mp3",122,true,100)
  STELARIS.RegisterTrack("Combat #3","nv_ambiant/combat_3l.mp3",128,true,100)  
  STELARIS.RegisterTrack("Combat #4","nv_ambiant/combat_4l.mp3",133,true,100)    
  --------------
  --RADIUS
  STELARIS.RegisterTrack("Legion #1","nv_ambiant/legion1.mp3",262,false,100, nil, "Legion")  
  STELARIS.RegisterTrack("Legion #2","nv_ambiant/legion2.mp3",263,false,100, nil, "Legion")
  STELARIS.RegisterTrack("Legion #3","nv_ambiant/legion3.mp3",135,false,100, nil, "Legion")
  
  STELARIS.RegisterTrack("NCR #1","nv_ambiant/ncr1.mp3",247,false,100, nil, "NCR")
  STELARIS.RegisterTrack("NCR #2","nv_ambiant/ncr2.mp3",246,false,100, nil, "NCR")
  
  STELARIS.RegisterTrack("BoS #1","nv_ambiant/bos1.mp3",97,false,100, nil, "BoS")
  STELARIS.RegisterTrack("BoS #2","nv_ambiant/bos2.mp3",97,false,100, nil, "BoS")
  STELARIS.RegisterTrack("BoS #3","nv_ambiant/bos3.mp3",97,false,100, nil, "BoS")  
  --------------  
  --VECS
  STELARIS.RadiusVecs["Legion"] = {Vec = Vector(-9221.476563, -12393.857422, 0.000031), Rad = 3000}
  STELARIS.RadiusVecs["NCR"] = {Vec = Vector(9089.292969, 3391.824463, 27.031250), Rad = 2900}
  STELARIS.RadiusVecs["BoS"] = {Vec = Vector(-8303.502930, 10646.334961, -1612.858765), Rad = 3000}  
--
end

------------------------
--
timer.Simple(1,function()
initSTELARIS()
end)