local Plugin = Plugin or {}
Fallout_Outfits = Fallout_Outfits or {}
Fallout_HelmetOrientation = Fallout_HelmetOrientation or {}
FalloutSubs = FalloutSubs or {}
local char = FindMetaTable("Player")

function Fallout_RegisterOutfit(name,mdl,ent_mdl,dt,helmet,vars)
Fallout_Outfits[name] = {
  Model = mdl,
  Ent_Model = ent_mdl,
  DT = dt,
  helmet = helmet,
  AppVars = vars
}
end

function Fallout_GetAppVars(name)
local tbl = Fallout_Outfits[name]
  if tbl and tbl.AppVars then
    return tbl.AppVars
  end
end

function Fallout_GetOutfit(name)
return Fallout_Outfits[name]
end

function Fallout_OutfitDT(name)
  local tbl = Fallout_GetOutfit(name)
  if !tbl then return end
  return tbl.DT
end

function Fallout_OutfitModel(name,gender)
local model = Fallout_Outfits[name]
  if model then
    model = model.Model
  else
    print("RETURNING NIL for "..name.."!!")
    return
  end
  if type(model) == "table" then
    if gender == "Male" then
      model = model.Male
    else
      model = model.Female
    end
  end
return model,Fallout_Outfits[name].Ent_Model
end

function Fallout_IsHelmet(name)
local tbl = Fallout_GetOutfit(name)
if tbl and tbl.helmet then return true end
end

function Fallout_HairStyles()
local tbl = {}
tbl["1Male"] = "models/fallout/player/hair/hairbase.mdl"
tbl["2Male"] = "models/fallout/player/hair/hairbalding.mdl"
tbl["3Male"] = "models/fallout/player/hair/hairbuzzcut.mdl"
tbl["4Male"] = "models/fallout/player/hair/haircombover.mdl"
tbl["5Male"] = "models/fallout/player/hair/haircurly.mdl"
tbl["6Male"] = "models/fallout/player/hair/hairda.mdl"
tbl["7Male"] = "models/fallout/player/hair/hairdefaultfacegen.mdl"
tbl["8Male"] = "models/fallout/player/hair/hairmessy01.mdl"
tbl["9Male"] = "models/fallout/player/hair/hairmessy02.mdl"
tbl["10Male"] = "models/fallout/player/hair/hairraidermid.mdl"
tbl["11Male"] = "models/fallout/player/hair/hairraiderspike.mdl"
tbl["12Male"] = "models/fallout/player/hair/hairspikey.mdl"
tbl["13Male"] = "models/fallout/player/hair/hairwastelandm.mdl"
tbl["14Male"] = "models/fallout/player/hair/hairwavy.mdl"
--
tbl["1Ghoul"] = "models/fallout/player/hair/hairghoul01.mdl"
tbl["2Ghoul"] = "models/fallout/player/hair/hairmessy02.mdl"
tbl["3Ghoul"] = "models/fallout/player/hair/hairwastelandm.mdl"
--
tbl["1Female"] = "models/fallout/player/hair/hairbun.mdl"
tbl["2Female"] = "models/fallout/player/hair/hairf01.mdl"
tbl["3Female"] = "models/fallout/player/hair/hairf01b.mdl"
tbl["4Female"] = "models/fallout/player/hair/hairf01c.mdl"
tbl["5Female"] = "models/fallout/player/hair/hairf02.mdl"
tbl["6Female"] = "models/fallout/player/hair/hairraiderside.mdl"
tbl["7Female"] = "models/fallout/player/hair/slippedtail01.mdl"
tbl["8Female"] = "models/fallout/player/hair/slippedtail02.mdl"
tbl["9Female"] = "models/fallout/player/hair/waves.mdl"
tbl["10Female"] = "models/fallout/player/hair/apachii/apachii12.mdl"
tbl["11Female"] = "models/fallout/player/hair/apachii/apachii13.mdl"
tbl["12Female"] = "models/fallout/player/hair/apachii/lightning.mdl"
tbl["13Female"] = "models/fallout/player/hair/coolhair/cool42.mdl"
tbl["14Female"] = "models/fallout/player/hair/coolhair/cool45.mdl"
tbl["15Female"] = "models/fallout/player/hair/coolhair/cool51.mdl"
tbl["16Female"] = "models/fallout/player/hair/coolhair/cool56.mdl"
tbl["17Female"] = "models/fallout/player/hair/coolhair/cool60.mdl"
tbl["18Female"] = "models/fallout/player/hair/coolhair/cool65.mdl"
tbl["19Female"] = "models/fallout/player/hair/coolhair/cool73.mdl"
tbl["20Female"] = "models/fallout/player/hair/coolhair/cool77.mdl"
tbl["21Female"] = "models/fallout/player/hair/coolhair/cool82.mdl"
tbl["22Female"] = "models/fallout/player/hair/coolhair/cool84.mdl"
tbl["23Female"] = "models/fallout/player/hair/coolhair/cool85.mdl"
tbl["24Female"] = "models/fallout/player/hair/coolhair/cool93.mdl"
return tbl
end

function Fallout_FacHairStyles()
local tbl = {}
tbl["1F"] = "models/fallout/player/beards/beardchincurtain.mdl"
tbl["2F"] = "models/fallout/player/beards/beardchinstrip.mdl"
tbl["3F"] = "models/fallout/player/beards/beardchinwide.mdl"
tbl["4F"] = "models/fallout/player/beards/beardchopper.mdl"
tbl["5F"] = "models/fallout/player/beards/beardcircle.mdl"
tbl["6F"] = "models/fallout/player/beards/beardfull.mdl"
tbl["7F"] = "models/fallout/player/beards/beardgoatee.mdl"
tbl["8F"] = "models/fallout/player/beards/beardgoateewide.mdl"
tbl["9F"] = "models/fallout/player/beards/beardmustache.mdl"
tbl["10F"] = "models/fallout/player/beards/beardmustachecurly.mdl"
tbl["11F"] = "models/fallout/player/beards/beardmuttonchops.mdl"
tbl["12F"] = "models/fallout/player/beards/beardside.mdl"
tbl["13F"] = "models/fallout/player/beards/beardsoulpatch.mdl"
tbl["14F"] = "models/fallout/player/beards/beardthin.mdl"
return tbl
end

function Fallout_HumanSkins(gender, skin)
local tbl = {}
tbl[0] = nil
tbl[1] = {Mat = "models/fallout/characters/"..gender:lower().."/headhuman_african", Body = "models/fallout/characters/"..gender:lower().."/r_upperbody"..gender:lower().."_african", Hand = "models/fallout/characters/female/handfemale_african"}
tbl[2] = {Mat = "models/fallout/characters/"..gender:lower().."/headhuman_aisan3", Body = "models/fallout/characters/"..gender:lower().."/r_upperbody"..gender:lower().."_aisan3", Hand = "models/fallout/characters/female/handfemale_aisan"}
--
tbl[10] = "models/fallout/characters/"..gender:lower().."/headhuman_andy"
tbl[11] = "models/fallout/characters/"..gender:lower().."/headhuman_boone"
tbl[12] = "models/fallout/characters/"..gender:lower().."/headhuman_caesar"
tbl[13] = "models/fallout/characters/"..gender:lower().."/headhuman_caucaisan30"
tbl[14] = "models/fallout/characters/"..gender:lower().."/headhuman_caucaisan40"
tbl[15] = "models/fallout/characters/"..gender:lower().."/headhuman_caucaisan50"
tbl[16] = {Mat = "models/fallout/characters/"..gender:lower().."/headhumandirt", Body = "models/fallout/characters/"..gender:lower().."/r_upperbody"..gender:lower().."_raider"}
tbl[17] = "models/fallout/characters/"..gender:lower().."/headhumanold"
tbl[18] = "models/fallout/characters/"..gender:lower().."/headhuman_niner"
--
  if skin then
    return tbl[skin]
  end
--
return tbl
end

function Fallout_GhoulSkins(skin)
local tbl = {}
tbl[10] = "models/fallout/characters/ghoul/headghoul2"
tbl[11] = {Mat = "models/fallout/characters/ghoul/headghoul3", Body = "models/fallout/characters/ghoul/upperbodyghoul3"}
tbl[12] = {Mat = "models/fallout/characters/ghoul/headghoul4", Body = "models/fallout/characters/ghoul/upperbodyghoul4"}
tbl[13] = {Mat = "models/fallout/characters/ghoul/headghoul5", Body = "models/fallout/characters/ghoul/upperbodyghoul5"}
--
  if skin then
    return tbl[skin]
  end
--
return tbl
end

function Fallout_FaceMapIndex(outfit, gender, ghoul)
if !outfit then return end
local gh = ""
  if ghoul then
    gh = "ghoul"
  end
--
local index = outfit.."_"..gender..""..gh
local indexBody = index.."Body"
local indexHand = index.."Hand"
return index, indexBody, indexHand
end

function Fallout_SortFaceMap(ent,skin,gender,ghoul,outfit)
local tbl = nil--Fallout_HumanSkins()
local gh = ""
local searchhead = "headhuman"
local mdlskin = nil
  if ghoul then
    mdlskin = Fallout_GhoulSkins(skin)
	gh = "ghoul"
	if gender:lower() == "male" then
	  searchhead = "headhumanghoul"
	else
	  searchhead = "headghoul"..gender:lower()..""
	end
  else
    mdlskin = Fallout_HumanSkins(gender, skin)
  end
--
local index, indexBody, indexHand = Fallout_FaceMapIndex(outfit, gender, ghoul)
if !index then MsgC(Color(204,0,0), "[Error Fallout]: Unable to Sort Face Map! Index = nil\n") return end
local sub = FalloutSubs[index]
local body = FalloutSubs[indexBody]
local hand = FalloutSubs[indexHand]
  if !sub then
    print("Searching..")
	local mats = ent:GetMaterials()
    for k,v in pairs(mats) do
	  if ghoul then
        if v:find(searchhead) then
	      sub = (k-1)
	      FalloutSubs[index] = sub
	    end
	  else
        if v:find(searchhead) and !v:find("ghoul") then
	      sub = (k-1)
	      FalloutSubs[index] = sub
	    end	  
	  end
	  
	  if ghoul then
        if v:find("upperbody"..gender:lower()..""..gh) then
	      body = (k-1)
	      FalloutSubs[indexBody] = body
	    end
	  else
        if v:find("upperbody"..gender:lower().."") and !v:find("ghoul") then
	      body = (k-1)
	      FalloutSubs[indexBody] = body
	    end	  
	  end
	  
	  if ghoul then
        if v:find("hand"..gender:lower()..""..gh) then
	      hand = (k-1)
	      FalloutSubs[indexHand] = hand
	    end
	  else
	    if v:find("hand"..gender:lower().."") and !v:find("ghoul") then
	      hand = (k-1)
	      FalloutSubs[indexHand] = hand
	    end
	  end
	  
    end
  end
--
local bodymat = nil
local handmat = nil
  if type(mdlskin) == "table" then
	bodymat = mdlskin.Body
	handmat = mdlskin.Hand
    mdlskin = mdlskin.Mat
  end
--
ent:SetSubMaterial(sub, mdlskin)
ent:SetSubMaterial(body, bodymat)
  if hand then
    ent:SetSubMaterial(hand, handmat)
  end
end
---------------
--CHAR
function char:CanBeGhoul()
  if self:IsDonator() or self:HasFlag("c_gh") then
    return true
  end
end

function char:IsGhoul()
  if SERVER then
    local ghoul = tobool(self:GetCharVar("Ghoul"))
	  if ghoul then
	    return true
	  end
  end
local ghoul = self:GetNWBool("FalloutGhoul",false)
  if ghoul == true then
    return true
  end
end

function char:GetFaceMap()
local skin = self:GetNWFloat("FalloutSkin",0)
return skin
end

function char:GetHairCol()
local hair_col = self:GetNWString("FalloutCol")
local color = string.Explode(  " ", hair_col )
color[1] = (color[1] or 255) color[2] = (color[2] or 255) color[3] = (color[3] or 255)
--
color[1] = tonumber(color[1]) color[2] = tonumber(color[2]) color[3] = tonumber(color[3])
color = Color(color[1] or 255,color[2] or 255,color[3] or 255,255)
return color
end

function char:GetHair()
local tbl = Fallout_HairStyles()
local val = self:GetNWFloat("FalloutHair",0)
local str = val..""..self:GetGender()
  if self:IsGhoul() then
    str = val.."Ghoul"
  end
--
return tbl[str]
end

function char:GetFacialHair()
if self:GetGender() == "Female" then return end
local tbl = Fallout_FacHairStyles()
local val = self:GetNWFloat("FalloutFHair",0)
if val == 0 then return end
local str = val.."F"
--
return tbl[str]
end

function char:GetOutfit(helmet)
local outfit = self:GetNWString("FalloutOutfit")
  if helmet then
    outfit = self:GetNWString("FalloutOutfitH")
  end
if !outfit or outfit == "" then return end
return outfit
end

function char:GetHelmet()
local helm = self:GetOutfit(true)
  if helm then
    return Fallout_Outfits[helm].Model
  end
end

function char:WearingPowerArmor()
  local outfit = self:GetOutfit()
  if outfit then
	if outfit:find("Power Armor") or outfit:find("Hellfire") then
      return true
	end
  end
end
----------------
local function checkInit()
local man, manBody = Fallout_FaceMapIndex("Naked", "Male", false)
  if !man then
    local woman, womanBody = Fallout_FaceMapIndex("Naked", "Female", false)
	local manGhoul, manGhoulBody = Fallout_FaceMapIndex("Naked", "Male", true)
	local womanGhoul, womanGhoulBody =Fallout_FaceMapIndex("Naked", "Female", true)
	--
	FalloutSubs[man] = 4
	FalloutSubs[manBody] = 1	
	FalloutSubs[manGhoul] = 6
	FalloutSubs[manGhoulBody] = 9

	FalloutSubs[woman] = 6
	FalloutSubs[womanBody] = 0
	FalloutSubs[womanGhoul] = 8
	FalloutSubs[womanGhoulBody] = 17	
  end
end
--
checkInit()
-------------

return Plugin