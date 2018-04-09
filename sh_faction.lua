-----------------------FLAGS----------------------------
-----NCR------

-------------
------------------------
--Legion

---
--Factions--------------------------
factionDefaultWeps = {"fo3_m_base", "fo3_pda"}
Schema.DefaultFaction = 1--Index of default faction
Schema.DefaultFaction_Walk = 70
Schema.DefaultFaction_Run = 270
Schema.DefaultFaction_Crouch = 0.9
Schema.DefaultFaction_Jump = 150

faction[1] = {--Unique number. MUST BE NUMBER
Name = "Wastelander",--Name of faction
weapons = {},--Classes of Weapons this faction has
--Model = ".mdl",--Path to model of faction
color = Color(255,255,102),--Color of faction
WalkSpeed = Schema.DefaultFaction_Walk,--Walk Speed of this faction
RunSpeed = Schema.DefaultFaction_Run,--Run Speed of this faction
CrouchSpeed = Schema.DefaultFaction_Crouch,--Crouch Speed of this faction
JumpPower = Schema.DefaultFaction_Jump--Jump Power of this faction
}

faction[2] = {--Unique number. MUST BE NUMBER
Name = "New California Republic",
weapons = {},--Classes of Weapons this faction has
color = Color(204,153,0),--Color of faction
WalkSpeed = Schema.DefaultFaction_Walk,--Walk Speed of this faction
RunSpeed = Schema.DefaultFaction_Run,--Run Speed of this faction
CrouchSpeed = Schema.DefaultFaction_Crouch,--Crouch Speed of this faction
JumpPower = Schema.DefaultFaction_Jump--Jump Power of this faction
}

faction[3] = {--Unique number. MUST BE NUMBER
Name = "Caesars Legion",
weapons = {},--Classes of Weapons this faction has
color = Color(143,0,0),--Color of faction
WalkSpeed = Schema.DefaultFaction_Walk,--Walk Speed of this faction
RunSpeed = Schema.DefaultFaction_Run,--Run Speed of this faction
CrouchSpeed = Schema.DefaultFaction_Crouch,--Crouch Speed of this faction
JumpPower = Schema.DefaultFaction_Jump--Jump Power of this faction
}

faction[4] = {--Unique number. MUST BE NUMBER
Name = "Brotherhood Of Steel",
weapons = {},--Classes of Weapons this faction has
color = Color(53,23,255),--Color of faction
WalkSpeed = Schema.DefaultFaction_Walk,--Walk Speed of this faction
RunSpeed = Schema.DefaultFaction_Run,--Run Speed of this faction
CrouchSpeed = Schema.DefaultFaction_Crouch,--Crouch Speed of this faction
JumpPower = Schema.DefaultFaction_Jump--Jump Power of this faction
}
