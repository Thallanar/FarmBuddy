-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Arathi Highlands (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=45). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Arathi Highlands", {
    -- Beasts
    [2356] = MobInfo(3201, "S"),        -- Elder Gray Bear
    [2565] = MobInfo(1104, "S"),        -- Giant Plains Creeper
    [2561] = MobInfo(961, "S"),         -- Highland Fleshstalker
    [2559] = MobInfo(11316, "S"),       -- Highland Strider
    [2560] = MobInfo(180, "S"),         -- Highland Thrasher
    [217836] = MobInfo(15234, "S"),     -- Needletooth, Rare

    -- Humanoids
    [2566] = MobInfo(3193, "C"),        -- Boulderfist Brute
    [2564] = MobInfo(1054, "C"),        -- Boulderfist Enforcer
    [2571] = MobInfo(448, "C"),         -- Boulderfist Lord, Elite
    [2567] = MobInfo(6170, "C"),        -- Boulderfist Magus
    [2569] = MobInfo(1051, "C"),        -- Boulderfist Mauler, Elite
    [2562] = MobInfo(1052, "C"),        -- Boulderfist Ogre
    [2570] = MobInfo(416, "C"),         -- Boulderfist Shaman, Elite
    [2598] = MobInfo(4027, "C"),        -- Darbel Montrose, Rare-Elite
    [4062] = MobInfo(3954, "C"),        -- Dark Iron Bombardier
    [1052] = MobInfo(3490, "C"),        -- Dark Iron Saboteur, Elite
    [2577] = MobInfo(3970, "C"),        -- Dark Iron Shadowcaster
    [2575] = MobInfo(3969, "C"),        -- Dark Iron Supplier
    [2574] = MobInfo(511, "C"),         -- Drywhisker Digger
    [2572] = MobInfo(2153, "C"),        -- Drywhisker Kobold
    [2573] = MobInfo(371, "C"),         -- Drywhisker Surveyor
    [2601] = MobInfo(11551, "C"),       -- Foulbelly, Rare-Elite
    [2793] = MobInfo(6168, "C"),        -- Kor'gresh Coldrage
    [2603] = MobInfo(610, "C"),         -- Kovork, Rare
    [2597] = MobInfo(3985, "C"),        -- Lord Falconcrest, Elite
    [2783] = MobInfo(4031, "C"),        -- Marez Cowl, Elite
    [2604] = MobInfo(536, "C"),         -- Molok the Crusher, Rare
    [2606] = MobInfo(4033, "C"),        -- Nimar the Slayer, Rare
    [2773] = MobInfo(11568, "C"),       -- Or'Kalar, Elite
    [2599] = MobInfo(3971, "C"),        -- Otto, Elite
    [2602] = MobInfo(11572, "C"),       -- Ruul Onestone, Rare-Elite
    [2600] = MobInfo(4026, "C"),        -- Singer, Rare
    [2590] = MobInfo(4014, "C"),        -- Syndicate Conjuror, Elite
    [2586] = MobInfo(3984, "C"),        -- Syndicate Highwayman
    [2591] = MobInfo(4018, "C"),        -- Syndicate Magus, Elite
    [2589] = MobInfo(3987, "C"),        -- Syndicate Mercenary
    [2587] = MobInfo(3982, "C"),        -- Syndicate Pathstalker
    [2588] = MobInfo(4016, "C"),        -- Syndicate Prowler, Elite
    [267065] = MobInfo(144954, "C"),    -- Syndicate Smuggler
    [2554] = MobInfo(3991, "C"),        -- Witherbark Axe Thrower
    [2558] = MobInfo(4001, "C"),        -- Witherbark Berserker, Elite
    [218029] = MobInfo(6489, "C"),      -- Witherbark Champion
    [218032] = MobInfo(7709, "C"),      -- Witherbark Goliath, Elite
    [2556] = MobInfo(3997, "C"),        -- Witherbark Headhunter
    [2557] = MobInfo(3999, "C"),        -- Witherbark Shadow Hunter
    [2553] = MobInfo(3993, "C"),        -- Witherbark Shadowcaster
    [2552] = MobInfo(3986, "C"),        -- Witherbark Troll
    [2555] = MobInfo(3995, "C"),        -- Witherbark Witch Doctor
    [2605] = MobInfo(4003, "C"),        -- Zalas Witherbark, Rare
})
