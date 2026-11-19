-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Stonetalon Mountains (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=406). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Stonetalon Mountains", {
    -- Beasts
    [4018] = MobInfo(1917, "S"),        -- Antlered Courser
    [3809] = MobInfo(820, "S"),         -- Ashenvale Bear
    [4044] = MobInfo(2173, "S"),        -- Blackened Basilisk
    [6167] = MobInfo(12682, "S"),       -- Chimaera Matriarch
    [4008] = MobInfo(1537, "S"),        -- Cliff Stormer
    [4031] = MobInfo(8015, "S"),        -- Fledgling Chimaera
    [4019] = MobInfo(2161, "S"),        -- Great Courser
    [4014] = MobInfo(2297, "S"),        -- Pridewing Consort
    [4015] = MobInfo(4585, "S"),        -- Pridewing Patriarch, Rare
    [4013] = MobInfo(2298, "S"),        -- Pridewing Skyhunter
    [4012] = MobInfo(295, "S"),         -- Pridewing Wyvern
    [4009] = MobInfo(1538, "S"),        -- Raging Cliff Stormer
    [4041] = MobInfo(2175, "S"),        -- Scorched Basilisk
    [4042] = MobInfo(12343, "S"),       -- Singed Basilisk
    [4067] = MobInfo(11453, "S"),       -- Twilight Runner
    [4032] = MobInfo(6884, "S"),        -- Young Chimaera
    [4011] = MobInfo(2154, "S"),        -- Young Pridewing

    -- Humanoids
    [4025] = MobInfo(10869, "C"),       -- Bloodfury Ambusher
    [4022] = MobInfo(3022, "C"),        -- Bloodfury Harpy
    [12579] = MobInfo(2295, "C"),       -- Bloodfury Ripper, Elite
    [4023] = MobInfo(6813, "C"),        -- Bloodfury Roguefeather
    [4024] = MobInfo(10870, "C"),       -- Bloodfury Slayer
    [4027] = MobInfo(10871, "C"),       -- Bloodfury Storm Witch
    [4026] = MobInfo(10282, "C"),       -- Bloodfury Windcaller
    [5915] = MobInfo(4599, "C"),        -- Brother Ravenoak, Rare-Elite
    [5931] = MobInfo(4600, "C"),        -- Foreman Rigger, Rare-Elite
    [4202] = MobInfo(3885, "C"),        -- Gerenzo Wrenchwhistle
    [11917] = MobInfo(26, "C"),         -- Gogger Geomancer
    [11915] = MobInfo(26, "C"),         -- Gogger Rock Keeper
    [11918] = MobInfo(26, "C"),         -- Gogger Stonepounder
    [11914] = MobInfo(10225, "C"),      -- Gorehoof the Black
    [11912] = MobInfo(11874, "C"),      -- Grimtotem Brute
    [11911] = MobInfo(11882, "C"),      -- Grimtotem Mercenary
    [11910] = MobInfo(11878, "C"),      -- Grimtotem Ruffian
    [11913] = MobInfo(11886, "C"),      -- Grimtotem Sorcerer
    [11858] = MobInfo(11791, "C"),      -- Grundig Darkcloud
    [5930] = MobInfo(10875, "C"),       -- Sister Riven, Rare-Elite
    [5932] = MobInfo(487, "C"),         -- Taskmaster Whipfang, Rare-Elite
    [4070] = MobInfo(7224, "C"),        -- Venture Co. Builder
    [3991] = MobInfo(7226, "C"),        -- Venture Co. Deforester
    [3992] = MobInfo(7227, "C"),        -- Venture Co. Engineer
    [3989] = MobInfo(7228, "C"),        -- Venture Co. Logger
    [3993] = MobInfo(7229, "C"),        -- Venture Co. Machine Smith
    [3988] = MobInfo(7230, "C"),        -- Venture Co. Operator
    [3999] = MobInfo(2153, "C"),        -- Windshear Digger
    [4003] = MobInfo(163, "C"),         -- Windshear Geomancer
    [4004] = MobInfo(511, "C"),         -- Windshear Overlord
    [4002] = MobInfo(2299, "C"),        -- Windshear Stonecutter
    [4001] = MobInfo(373, "C"),         -- Windshear Tunnel Rat
    [3998] = MobInfo(26, "C"),          -- Windshear Vermin

    -- Dragonkin
    [4016] = MobInfo(1267, "S"),        -- Fey Dragon
    [4066] = MobInfo(8471, "S"),        -- Nal'taszar, Rare-Elite
    [4017] = MobInfo(2158, "S"),        -- Wily Fey Dragon

    -- Mechanicals
    [4073] = MobInfo(1269, "C"),        -- XT:4
    [4074] = MobInfo(1269, "C"),        -- XT:9
})
