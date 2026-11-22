-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Burning Steppes (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=46). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Burning Steppes", {
    -- Beasts
    [7055] = MobInfo(741, "S"),         -- Blackrock Worg
    [9695] = MobInfo(10984, "S"),       -- Deathlash Scorpid
    [10077] = MobInfo(9562, "S"),       -- Deathmaw, Rare
    [9690] = MobInfo(9371, "S"),        -- Ember Worg
    [227746] = MobInfo(0, nil),         -- Escaped Core Hound
    [269254] = MobInfo(780, nil),       -- Famished Blackworg
    [9698] = MobInfo(10985, "S"),       -- Firetail Scorpid
    [9697] = MobInfo(9370, "S"),        -- Giant Ember Worg
    [10262] = MobInfo(9556, "S"),       -- Opus
    [9694] = MobInfo(11420, "S"),       -- Slavering Ember Worg
    [9691] = MobInfo(8970, "S"),        -- Venomtip Scorpid

    -- Humanoids
    [228233] = MobInfo(0, nil),         -- Abel
    [203138] = MobInfo(0, nil),         -- Anvilrage Overseer, Elite
    [9522] = MobInfo(8699, "C"),        -- Blackrock Ambusher, Elite
    [7029] = MobInfo(6049, "C"),        -- Blackrock Battlemaster
    [228610] = MobInfo(121945, nil),    -- Blackrock Bootlegger
    [9605] = MobInfo(6049, "C"),        -- Blackrock Raider
    [7027] = MobInfo(6047, "C"),        -- Blackrock Slayer
    [7025] = MobInfo(6045, "C"),        -- Blackrock Soldier
    [7026] = MobInfo(6046, "C"),        -- Blackrock Sorcerer
    [7028] = MobInfo(6048, "C"),        -- Blackrock Warlock
    [2719] = MobInfo(1120, "C"),        -- Dustbelcher Lord
    [2720] = MobInfo(11546, "C"),       -- Dustbelcher Ogre Mage
    [7035] = MobInfo(10707, "C"),       -- Firegut Brute
    [7033] = MobInfo(11549, "C"),       -- Firegut Ogre
    [7034] = MobInfo(11550, "C"),       -- Firegut Ogre Mage
    [9176] = MobInfo(11553, "C"),       -- Gor'tesh
    [9604] = MobInfo(11562, "C"),       -- Gorgon'och, Rare
    [8979] = MobInfo(11510, "C"),       -- Gruklash, Rare
    [9602] = MobInfo(11564, "C"),       -- Hahk'Zor, Rare
    [228230] = MobInfo(0, nil),         -- Harrigen
    [8977] = MobInfo(11543, "C"),       -- Krom'Grul
    [228231] = MobInfo(0, nil),         -- Montrose
    [228232] = MobInfo(0, nil),         -- Plio
    [9043] = MobInfo(8899, "C"),        -- Scarshield Grunt, Elite
    [9044] = MobInfo(8901, "C"),        -- Scarshield Sentry, Elite
    [228609] = MobInfo(121945, nil),    -- Sulfuron Smuggler
    [8978] = MobInfo(11511, "C"),       -- Thauris Balgarr, Rare
    [7038] = MobInfo(6668, "C"),        -- Thaurissan Agent
    [7037] = MobInfo(8170, "C"),        -- Thaurissan Firewalker
    [7036] = MobInfo(6649, "C"),        -- Thaurissan Spy

    -- Demons
    [230146] = MobInfo(0, nil),         -- Fel Interloper
    [10078] = MobInfo(1018, "C"),       -- Terrorspark, Rare

    -- Elementals
    [228725] = MobInfo(0, nil),         -- Firesworn, Elite
    [233093] = MobInfo(0, nil),         -- Magma Elemental
    [232398] = MobInfo(0, nil),         -- Primordial Flame
    [232855] = MobInfo(0, nil),         -- Prismatic Elemental, Elite

    -- Dragonkin
    [7047] = MobInfo(397, "S"),         -- Black Broodling
    [7040] = MobInfo(143, "S"),         -- Black Dragonspawn, Elite
    [7044] = MobInfo(6374, "S"),        -- Black Drake, Elite
    [7041] = MobInfo(8249, "S"),        -- Black Wyrmkin, Elite
    [7049] = MobInfo(457, "S"),         -- Flamescale Broodling
    [7042] = MobInfo(2554, "S"),        -- Flamescale Dragonspawn, Elite
    [7043] = MobInfo(8309, "S"),        -- Flamescale Wyrmkin, Elite
    [8976] = MobInfo(6369, "S"),        -- Hematos, Rare-Elite
    [14388] = MobInfo(6374, "S"),       -- Rogue Black Drake, Elite
    [7048] = MobInfo(400, "S"),         -- Scalding Broodling
    [7045] = MobInfo(9585, "S"),        -- Scalding Drake, Elite
    [7046] = MobInfo(6377, "S"),        -- Searscale Drake, Elite
})
