-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Durotar (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=14). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Durotar", {
    -- Beasts
    [3126] = MobInfo(2487, "S"),        -- Armored Scorpid
    [3248] = MobInfo(4473, "S"),        -- Barrens Giraffe
    [268530] = MobInfo(11316, "S"),     -- Bloodtalon Matriarch
    [3123] = MobInfo(1959, "S"),        -- Bloodtalon Scythemaw
    [3122] = MobInfo(1960, "S"),        -- Bloodtalon Taillasher
    [3125] = MobInfo(2486, "S"),        -- Clattering Scorpid
    [3227] = MobInfo(787, "S"),         -- Corrupted Bloodtalon Scythemaw
    [3231] = MobInfo(1034, "S"),        -- Corrupted Dreadmaw Crocolisk
    [3225] = MobInfo(744, "S"),         -- Corrupted Mottled Boar
    [3226] = MobInfo(2488, "S"),        -- Corrupted Scorpid
    [5823] = MobInfo(2491, "S"),        -- Death Flayer, Rare
    [3099] = MobInfo(381, "S"),         -- Dire Mottled Boar
    [3110] = MobInfo(1250, "S"),        -- Dreadmaw Crocolisk
    [3121] = MobInfo(598, "S"),         -- Durotar Tiger
    [3100] = MobInfo(193, "S"),         -- Elder Mottled Boar
    [266852] = MobInfo(10933, "S"),     -- Halikor, Elite
    [3131] = MobInfo(1532, "S"),        -- Lightning Hide
    [3098] = MobInfo(503, "S"),         -- Mottled Boar
    [3281] = MobInfo(2864, "S"),        -- Sarkoth
    [3124] = MobInfo(2485, "S"),        -- Scorpid Worker
    [276198] = MobInfo(6805, "S"),      -- Shal'ma, Rare
    [3130] = MobInfo(2179, "S"),        -- Thunder Lizard
    [3127] = MobInfo(2732, "S"),        -- Venomtail Scorpid

    -- Humanoids
    [3198] = MobInfo(4190, "C"),        -- Burning Blade Apprentice
    [3199] = MobInfo(4194, "C"),        -- Burning Blade Cultist
    [3197] = MobInfo(4192, "C"),        -- Burning Blade Fanatic
    [3196] = MobInfo(4186, "C"),        -- Burning Blade Neophyte
    [3195] = MobInfo(4188, "C"),        -- Burning Blade Thug
    [5824] = MobInfo(1346, "C"),        -- Captain Flat Tusk, Rare-Elite
    [276194] = MobInfo(2143, "C"),      -- Dustwind Eggtender, Rare
    [3115] = MobInfo(3012, "C"),        -- Dustwind Harpy
    [3116] = MobInfo(6814, "C"),        -- Dustwind Pillager
    [3117] = MobInfo(2166, "C"),        -- Dustwind Savage
    [3118] = MobInfo(6815, "C"),        -- Dustwind Storm Witch
    [5822] = MobInfo(4594, "C"),        -- Felweaver Scornn, Rare-Elite
    [3203] = MobInfo(7128, "C"),        -- Fizzle Darkstorm
    [3204] = MobInfo(240, "C"),         -- Gazz'uz
    [5826] = MobInfo(6113, "C"),        -- Geolord Mottle, Rare
    [3207] = MobInfo(4079, "C"),        -- Hexed Troll
    [3119] = MobInfo(9442, "C"),        -- Kolkar Drudge
    [3120] = MobInfo(9443, "C"),        -- Kolkar Outrunner
    [3192] = MobInfo(1276, "C"),        -- Lieutenant Benedict
    [13157] = MobInfo(13089, "C"),      -- Makasgar
    [3114] = MobInfo(1964, "C"),        -- Razormane Battleguard
    [3113] = MobInfo(6088, "C"),        -- Razormane Dustrunner
    [3111] = MobInfo(1218, "C"),        -- Razormane Quilboar
    [3112] = MobInfo(1252, "C"),        -- Razormane Scout
    [275663] = MobInfo(4983, "C"),      -- Spitelash Attendant
    [275662] = MobInfo(4762, "C"),      -- Spitelash Scout
    [3206] = MobInfo(4076, "C"),        -- Voodoo Troll
    [5808] = MobInfo(9444, "C"),        -- Warlord Kolkanis, Rare
    [5809] = MobInfo(4592, "C"),        -- Watch Commander Zalaphil, Rare
    [3205] = MobInfo(4078, "C"),        -- Zalazane

    -- Giants
    [275666] = MobInfo(791, "C"),       -- Aggor the Young, Elite
})
