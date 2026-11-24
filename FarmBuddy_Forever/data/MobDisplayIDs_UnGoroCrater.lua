-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Un'Goro Crater (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=490). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Un'Goro Crater", {
    -- Beasts
    [232818] = MobInfo(0, nil),         -- Anne Tenna
    [232816] = MobInfo(0, nil),         -- Bearthold
    [6498] = MobInfo(5239, "S"),        -- Devilsaur, Elite
    [9163] = MobInfo(8511, "S"),        -- Diemetradon
    [9164] = MobInfo(8512, "S"),        -- Elder Diemetradon
    [9165] = MobInfo(8410, "S"),        -- Fledgling Pterrordax
    [9167] = MobInfo(8412, "S"),        -- Frenzied Pterrordax
    [6583] = MobInfo(10932, "S"),       -- Gruff, Rare-Elite
    [6499] = MobInfo(5238, "S"),        -- Ironhide Devilsaur, Elite
    [6584] = MobInfo(5305, "S"),        -- King Mosh, Rare-Elite
    [6502] = MobInfo(5287, "S"),        -- Plated Stegodon, Elite
    [9166] = MobInfo(8411, "S"),        -- Pterrordax
    [6505] = MobInfo(5242, "S"),        -- Ravasaur
    [6507] = MobInfo(5292, "S"),        -- Ravasaur Hunter
    [6581] = MobInfo(11319, "S"),       -- Ravasaur Matriarch, Rare
    [6506] = MobInfo(5290, "S"),        -- Ravasaur Runner
    [232817] = MobInfo(0, nil),         -- Roary
    [6503] = MobInfo(5288, "S"),        -- Spiked Stegodon, Elite
    [6501] = MobInfo(5241, "S"),        -- Stegodon, Elite
    [6504] = MobInfo(5289, "S"),        -- Thunderstomp Stegodon, Elite
    [6500] = MobInfo(5240, "S"),        -- Tyrant Devilsaur, Elite
    [9622] = MobInfo(8844, "S"),        -- U'cha
    [6585] = MobInfo(8129, "S"),        -- Uhk'loc, Rare
    [6514] = MobInfo(844, "S"),         -- Un'Goro Gorilla
    [6513] = MobInfo(5294, "S"),        -- Un'Goro Stomper
    [6516] = MobInfo(5244, "S"),        -- Un'Goro Thunderer
    [6508] = MobInfo(5291, "S"),        -- Venomhide Ravasaur
    [269206] = MobInfo(0, nil),         -- Venomhide Ravasaur
    [9162] = MobInfo(8510, "S"),        -- Young Diemetradon

    -- Humanoids
    [232755] = MobInfo(0, nil),         -- Van Amburgh
})
