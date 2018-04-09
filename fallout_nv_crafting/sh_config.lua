----------------
--Misc
RegisterTierItem("scrapmetal", false, false, {
  metalfrag = 2
},{})

RegisterTierItem("scrapelec", false, false, {
  scrapmetal = 5
},{
  ["Crafting"] = 5,
  ["Science"] = 10
})

RegisterTierItem("syringe", false, false, {
  glass = 2
},{
  ["Crafting"] = 5
})

RegisterTierItem("glass", false, false, {
  sodabottle = 1
},{
  ["Crafting"] = 5
})

RegisterTierItem("liquid_coolant", false, false, {
  turpentine = 2,
  cherrybomb = 1,
  metalfrag = 4,
},{
  ["Crafting"] = 10,
  ["Science"] = 15
})

RegisterTierItem("holodisk", false, false, {
  scrapelec = 2,
  scrapmetal = 2
},{
  ["Crafting"] = 10,
  ["Science"] = 25
})

-----------------
--Aid
RegisterTierItem("fo3_aid_medx", false, false, {
  syringe = 1,
  bloodpack = 1,
  liquid_coolant = 1
},{
  ["Crafting"] = 10,
  ["Medicine"] = 25,
})

RegisterTierItem("fo3_aid_docbag", false, false, {
  syringe = 1,
  bloodpack = 2,
  surgicaltubing = 2,
  leather = 1,
},{
  ["Crafting"] = 10,
  ["Medicine"] = 30,
})

RegisterTierItem("fo3_aid_jet", false, false, {
  sodabottle = 1,
  brahmin_dung = 2,
  turpentine = 2,
},{
  ["Crafting"] = 5,
  ["Medicine"] = 25,
})

RegisterTierItem("fo3_aid_buffout", false, false, {
  mentats = 1,
  turpentine = 2,
  glass = 1,
},{
  ["Crafting"] = 5,
  ["Medicine"] = 25,
})

RegisterTierItem("fo3_aid_superstim", false, false, {
  fo3_aid_stimpack = 2,
  fo3_aid_healingp = 1,
  leather = 1,
},{
  ["Crafting"] = 5,
  ["Science"] = 10,
  ["Medicine"] = 50,
})

-----------------
--Animals
RegisterTierItem("leather", false, false, {
  geckohide = 1
},{
  ["Crafting"] = 10
})

-----------------
--Armor
RegisterTierItem("Leather Armor", false, true, {
  leather = 6,
  scrapmetal = 10
},{
  ["Crafting"] = 10
})

-----------------
--Weapons
RegisterTierItem("fo3_10mm", true, false, {
  lead = 12,
  scrapmetal = 6,
  casing_10mm = 1
},{
  ["Crafting"] = 10,
  ["Guns"] = 10
})

RegisterTierItem("fo3_mine_bot", true, false, {
  lunchbox = 1,
  fo3_mine_base = 1,
  cherrybomb = 1,
},{
  ["Crafting"] = 10,
  ["Explosives"] = 25
})

RegisterTierItem("fo3_m_shish", true, false, {
  cherrybomb = 10,
  liquid_coolant = 6,
  lead = 10,
  steamgauge = 2,
},{
  ["Crafting"] = 50,
  ["Melee Weapons"] = 50
})
