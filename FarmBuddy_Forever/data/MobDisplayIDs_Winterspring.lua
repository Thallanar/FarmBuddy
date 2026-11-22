-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Winterspring (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=618). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Winterspring", {
    -- Beasts
    [228814] = MobInfo(0, nil),         -- Arcterris, Rare-Elite
    [10807] = MobInfo(12683, "S"),      -- Brumeran, Elite
    [7448] = MobInfo(10810, "S"),       -- Chillwind Chimaera
    [7449] = MobInfo(10809, "S"),       -- Chillwind Ravager
    [7445] = MobInfo(8837, "S"),        -- Elder Shardtooth
    [7447] = MobInfo(10807, "S"),       -- Fledgling Chillwind
    [7431] = MobInfo(9953, "S"),        -- Frostsaber
    [7430] = MobInfo(9958, "S"),        -- Frostsaber Cub
    [7433] = MobInfo(11444, "S"),       -- Frostsaber Huntress
    [7434] = MobInfo(9954, "S"),        -- Frostsaber Pride Watcher
    [7432] = MobInfo(11445, "S"),       -- Frostsaber Stalker
    [269276] = MobInfo(0, nil),         -- Kamuro
    [269275] = MobInfo(0, nil),         -- Kuroma
    [15554] = MobInfo(10133, "S"),      -- Number Two, Elite
    [7446] = MobInfo(3200, "S"),        -- Rabid Shardtooth
    [10200] = MobInfo(10054, "S"),      -- Rak'shiri, Rare
    [7444] = MobInfo(865, "S"),         -- Shardtooth Bear
    [7443] = MobInfo(8842, "S"),        -- Shardtooth Mauler
    [10806] = MobInfo(10618, "S"),      -- Ursius, Elite

    -- Humanoids
    [10199] = MobInfo(9491, "C"),       -- Grizzle Snowpaw, Rare
    [7459] = MobInfo(10945, "S"),       -- Ice Thistle Matriarch
    [7460] = MobInfo(10946, "S"),       -- Ice Thistle Patriarch
    [7458] = MobInfo(10579, "S"),       -- Ice Thistle Yeti
    [10197] = MobInfo(3208, "S"),       -- Mezzir the Howler, Rare
    [232399] = MobInfo(0, nil),         -- Outcast Cryomancer
    [7457] = MobInfo(6767, "S"),        -- Rogue Ice Thistle
    [7440] = MobInfo(6828, "C"),        -- Winterfall Den Watcher
    [7442] = MobInfo(6211, "C"),        -- Winterfall Pathfinder
    [10916] = MobInfo(6829, "C"),       -- Winterfall Runner
    [7439] = MobInfo(6830, "C"),        -- Winterfall Shaman
    [7441] = MobInfo(6818, "C"),        -- Winterfall Totemic
    [7438] = MobInfo(6829, "C"),        -- Winterfall Ursa

    -- Demons
    [232945] = MobInfo(0, nil),         -- Azgaloth, Elite
    [232943] = MobInfo(0, nil),         -- Diathorus the Seeker
    [232532] = MobInfo(0, nil),         -- Fel Interloper
    [232939] = MobInfo(0, nil),         -- Felguard Elite, Elite
    [232940] = MobInfo(0, nil),         -- Felhound Spellseeker
    [7461] = MobInfo(10924, "C"),       -- Hederine Initiate, Elite
    [7462] = MobInfo(6172, "S"),        -- Hederine Manastalker, Elite
    [7463] = MobInfo(9018, "C"),        -- Hederine Slayer, Elite
    [232942] = MobInfo(0, nil),         -- Hulking Doomguard, Elite
    [232075] = MobInfo(0, nil),         -- Incubus Enthraller, Elite
    [10201] = MobInfo(10925, "C"),      -- Lady Hederine, Rare-Elite
    [232534] = MobInfo(0, nil),         -- Manathirst Imp

    -- Giants
    [269213] = MobInfo(0, nil),         -- Hailspite, Elite

    -- Undead
    [7524] = MobInfo(10702, "C"),       -- Anguished Highborne
    [228891] = MobInfo(0, nil),         -- Enraged Shade
    [7523] = MobInfo(10701, "C"),       -- Suffering Highborne

    -- Dragonkin
    [10202] = MobInfo(6373, "S"),       -- Azurous, Rare-Elite
    [10660] = MobInfo(10584, "S"),      -- Cobalt Broodling
    [7437] = MobInfo(8316, "S"),        -- Cobalt Mageweaver, Elite
    [7436] = MobInfo(6760, "S"),        -- Cobalt Scalebane, Elite
    [10659] = MobInfo(10585, "S"),      -- Cobalt Whelp
    [7435] = MobInfo(6761, "S"),        -- Cobalt Wyrmkin, Elite
    [10196] = MobInfo(9489, "S"),       -- General Colbatann, Rare-Elite
    [10663] = MobInfo(9996, "S"),       -- Manaclaw, Elite
    [10664] = MobInfo(6373, "S"),       -- Scryer, Elite
    [10661] = MobInfo(10583, "S"),      -- Spell Eater
    [10662] = MobInfo(9995, "S"),       -- Spellmaw, Elite
})
