-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Mulgore (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=215). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Mulgore", {
    -- Beasts
    [2956] = MobInfo(1220, "S"),        -- Adult Plainstrider
    [3058] = MobInfo(10916, "S"),       -- Arra'chea
    [2966] = MobInfo(8869, "S"),        -- Battleboar
    [2954] = MobInfo(6807, "S"),        -- Bristleback Battleboar
    [268558] = MobInfo(780, "S"),         -- Chakuyak
    [2957] = MobInfo(1221, "S"),        -- Elder Plainstrider
    [3035] = MobInfo(1059, "S"),        -- Flatland Cougar
    [3566] = MobInfo(1056, "S"),        -- Flatland Prowler
    [3056] = MobInfo(720, "S"),         -- Ghost Howl, Rare
    [2973] = MobInfo(1230, "S"),        -- Kodo Bull
    [2972] = MobInfo(1451, "S"),        -- Kodo Calf
    [2974] = MobInfo(10918, "S"),       -- Kodo Matriarch
    [3068] = MobInfo(1961, "S"),        -- Mazzranache, Rare
    [2961] = MobInfo(11451, "S"),       -- Mountain Cougar
    [2955] = MobInfo(1219, "S"),        -- Plainstrider
    [2959] = MobInfo(643, "S"),         -- Prairie Stalker
    [2958] = MobInfo(1100, "S"),        -- Prairie Wolf
    [2960] = MobInfo(161, "S"),         -- Prairie Wolf Alpha
    [5807] = MobInfo(1973, "S"),        -- The Rake, Rare

    -- Humanoids
    [3232] = MobInfo(1274, "C"),        -- Bristleback Interloper
    [5787] = MobInfo(6692, "C"),        -- Enforcer Emilgund, Rare
    [2967] = MobInfo(9410, "C"),        -- Galak Centaur
    [2968] = MobInfo(9409, "C"),        -- Galak Outrunner
    [11915] = MobInfo(26, "C"),         -- Gogger Rock Keeper
    [11918] = MobInfo(26, "C"),         -- Gogger Stonepounder
    [275767] = MobInfo(9447, "C"),         -- Herak the Pillager
    [2951] = MobInfo(1217, "C"),        -- Palemane Poacher
    [2950] = MobInfo(1216, "C"),        -- Palemane Skinner
    [2949] = MobInfo(550, "C"),         -- Palemane Tanner
    [5785] = MobInfo(2163, "C"),        -- Sister Hatelash, Rare-Elite
    [5786] = MobInfo(275, "C"),         -- Snagglespear, Rare
    [276109] = MobInfo(1887, "C"),         -- Snarlsnout, Rare
    [276105] = MobInfo(11637, "C"),         -- Stormherald Ukta, Rare
    [3051] = MobInfo(7134, "C"),        -- Supervisor Fizsprocket
    [276108] = MobInfo(6077, "C"),         -- Thornstarter Igleg, Rare
    [2975] = MobInfo(7243, "C"),        -- Venture Co. Hireling
    [2976] = MobInfo(7244, "C"),        -- Venture Co. Laborer
    [2979] = MobInfo(7245, "C"),        -- Venture Co. Supervisor
    [2977] = MobInfo(7246, "C"),        -- Venture Co. Taskmaster
    [2978] = MobInfo(7247, "C"),        -- Venture Co. Worker
    [2962] = MobInfo(10877, "C"),       -- Windfury Harpy
    [2965] = MobInfo(10869, "C"),       -- Windfury Matriarch
    [2964] = MobInfo(1255, "C"),        -- Windfury Sorceress
    [2963] = MobInfo(1351, "C"),        -- Windfury Wind Witch
})
