-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Searing Gorge (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=51). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Searing Gorge", {
    -- Beasts
    [222699] = MobInfo(0, nil),         -- Enraged Stormcrow
    [269254] = MobInfo(780, nil),       -- Famished Blackworg
    [9318] = MobInfo(8509, "S"),        -- Incendosaur
    [5833] = MobInfo(10933, "S"),       -- Margol the Rager, Elite

    -- Humanoids
    [203138] = MobInfo(0, nil),         -- Anvilrage Overseer, Elite
    [228610] = MobInfo(121945, nil),    -- Blackrock Bootlegger
    [5839] = MobInfo(7793, "C"),        -- Dark Iron Geologist
    [8566] = MobInfo(7865, "C"),        -- Dark Iron Lookout
    [8504] = MobInfo(7814, "C"),        -- Dark Iron Sentry, Elite
    [5844] = MobInfo(7789, "C"),        -- Dark Iron Slaver
    [5840] = MobInfo(7796, "C"),        -- Dark Iron Steamsmith
    [8337] = MobInfo(7761, "C"),        -- Dark Iron Steelshifter
    [5846] = MobInfo(7798, "C"),        -- Dark Iron Taskmaster
    [8637] = MobInfo(7929, "C"),        -- Dark Iron Watchman
    [262294] = MobInfo(0, nil),         -- Durganon
    [228727] = MobInfo(0, nil),         -- Flamebringer Defender, Elite
    [228726] = MobInfo(0, nil),         -- Flamebringer Elementalist, Elite
    [228728] = MobInfo(0, nil),         -- Flamebringer Kelris, Rare-Elite
    [228747] = MobInfo(0, nil),         -- Flamebringer Stalker, Elite
    [228970] = MobInfo(0, nil),         -- Galenges, Rare
    [8282] = MobInfo(7835, "C"),        -- Highlord Mastrogonde, Rare-Elite
    [8391] = MobInfo(7764, "C"),        -- Lathoric the Black, Elite
    [228721] = MobInfo(0, nil),         -- Lieutenant Skarresh, Rare
    [228969] = MobInfo(0, nil),         -- Lord Gazzran, Rare
    [8442] = MobInfo(7810, "C"),        -- Shadowsilk Poacher
    [8283] = MobInfo(7819, "C"),        -- Slave Master Blackheart, Rare
    [5843] = MobInfo(487, "C"),         -- Slave Worker
    [228609] = MobInfo(121945, nil),    -- Sulfuron Smuggler
    [8924] = MobInfo(8390, "C"),        -- The Behemoth, Rare-Elite
    [5860] = MobInfo(7821, "C"),        -- Twilight Dark Shaman, Elite
    [5861] = MobInfo(7825, "C"),        -- Twilight Fire Guard, Elite
    [5862] = MobInfo(7830, "C"),        -- Twilight Geomancer, Elite
    [8419] = MobInfo(7729, "C"),        -- Twilight Idolater, Elite
    [276078] = MobInfo(143055, nil),    -- Twilight Laborer

    -- Demons
    [8280] = MobInfo(2346, "S"),        -- Shleipnarr, Rare

    -- Elementals
    [222620] = MobInfo(0, nil),         -- Corrupt Moderate Manifestation of Fire
    [228720] = MobInfo(0, nil),         -- Duke Searbrand, Elite
    [228729] = MobInfo(0, nil),         -- Duke Tectonis, Elite
    [228719] = MobInfo(0, nil),         -- Firelands Drudge
    [228718] = MobInfo(0, nil),         -- Firelands Invader
    [228723] = MobInfo(0, nil),         -- Obsidian Reaver
    [228724] = MobInfo(0, nil),         -- Obsidian Surger

    -- Giants
    [228722] = MobInfo(0, nil),         -- Infernus Siege Giant, Elite
    [222546] = MobInfo(0, nil),         -- Iodax the Obliterator, Elite

    -- Mechanicals
    [8447] = MobInfo(6569, "C"),        -- Clunk, Elite
})
