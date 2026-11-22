-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Silithus (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=1377). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Silithus", {
    -- Beasts
    [15196] = MobInfo(15327, "S"),      -- Deathclasp, Elite
    [11741] = MobInfo(14524, "S"),      -- Dredge Crusher
    [11740] = MobInfo(15386, "S"),      -- Dredge Striker
    [14477] = MobInfo(14523, "S"),      -- Grubthor, Rare
    [14476] = MobInfo(6068, "S"),       -- Krellack, Rare
    [227493] = MobInfo(0, nil),         -- Sandworm, Elite
    [231984] = MobInfo(0, nil),         -- Silithid Darter
    [11737] = MobInfo(15385, "S"),      -- Stonelash Flayer
    [11736] = MobInfo(15384, "S"),      -- Stonelash Pincer
    [11735] = MobInfo(15383, "S"),      -- Stonelash Scorpid

    -- Humanoids
    [11880] = MobInfo(11811, "C"),      -- Twilight Avenger
    [15201] = MobInfo(2896, "C"),       -- Twilight Flamereaver
    [11881] = MobInfo(11819, "C"),      -- Twilight Geolord
    [14479] = MobInfo(14526, "C"),      -- Twilight Lord Everun, Rare
    [15542] = MobInfo(15552, "C"),      -- Twilight Marauder
    [15541] = MobInfo(15551, "C"),      -- Twilight Marauder Morna, Elite
    [11883] = MobInfo(11824, "C"),      -- Twilight Master
    [15213] = MobInfo(15407, "C"),      -- Twilight Overlord
    [11882] = MobInfo(11815, "C"),      -- Twilight Stonecaller
    [15202] = MobInfo(15411, "C"),      -- Vyral the Vile

    -- Undead
    [12199] = MobInfo(12291, "C"),      -- Shade of Ambermoon
    [12178] = MobInfo(12269, "C"),      -- Tortured Druid
    [12179] = MobInfo(12270, "C"),      -- Tortured Sentinel
})
