-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Dustwallow Marsh (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=15). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Dustwallow Marsh", {
    -- Beasts
    [4357] = MobInfo(2573, "S"),        -- Bloodfen Lashtail
    [4351] = MobInfo(2571, "S"),        -- Bloodfen Raptor
    [4356] = MobInfo(11315, "S"),       -- Bloodfen Razormaw
    [4352] = MobInfo(1962, "S"),        -- Bloodfen Screecher
    [4841] = MobInfo(2850, "S"),        -- Deadmire
    [4341] = MobInfo(1080, "S"),        -- Drywallow Crocolisk
    [4345] = MobInfo(807, "S"),         -- Drywallow Daggermaw
    [4343] = MobInfo(814, "S"),         -- Drywallow Snapper
    [4390] = MobInfo(6431, "S"),        -- Elder Murk Thresher
    [14234] = MobInfo(2703, "S"),       -- Hayoc, Rare
    [4344] = MobInfo(2548, "S"),        -- Mottled Drywallow Crocolisk
    [4397] = MobInfo(7836, "S"),        -- Mudrock Spikeshell
    [4389] = MobInfo(2601, "S"),        -- Murk Thresher
    [4374] = MobInfo(2423, "S"),        -- Strashaz Hydra, Elite
    [4388] = MobInfo(2602, "S"),        -- Young Murk Thresher

    -- Humanoids
    [5046] = MobInfo(2994, "C"),        -- Lieutenant Caldwell
    [15591] = MobInfo(15560, "C"),      -- Minion of Weavil, Elite
    [5045] = MobInfo(3003, "C"),        -- Private Hallan

    -- Dragonkin
    [4339] = MobInfo(6374, "S"),        -- Brimgore, Rare-Elite
    [10321] = MobInfo(6374, "S"),       -- Emberstrife, Elite
    [4331] = MobInfo(8249, "S"),        -- Firemane Ash Tail
    [4334] = MobInfo(8309, "S"),        -- Firemane Flamecaller
    [4328] = MobInfo(8310, "S"),        -- Firemane Scalebane
    [4329] = MobInfo(143, "S"),         -- Firemane Scout
    [4323] = MobInfo(715, "S"),         -- Searing Hatchling
    [4324] = MobInfo(397, "S"),         -- Searing Whelp
})
