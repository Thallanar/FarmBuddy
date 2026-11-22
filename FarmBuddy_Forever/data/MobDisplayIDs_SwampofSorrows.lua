-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Swamp of Sorrows (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=8). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Swamp of Sorrows", {
    -- Beasts
    [5224] = MobInfo(4767, "S"),        -- Murk Slitherer, Elite
    [5225] = MobInfo(4768, "S"),        -- Murk Spitter, Elite
    [14356] = MobInfo(14389, "S"),      -- Sawfin Frenzy
    [1082] = MobInfo(807, "S"),         -- Sawtooth Crocolisk
    [1087] = MobInfo(815, "S"),         -- Sawtooth Snapper
    [768] = MobInfo(633, "S"),          -- Shadow Panther
    [767] = MobInfo(632, "S"),          -- Swamp Jaguar
    [1084] = MobInfo(814, "S"),         -- Young Sawtooth Crocolisk

    -- Humanoids
    [5269] = MobInfo(4776, "C"),        -- Atal'ai Priest, Elite
    [5243] = MobInfo(4779, "C"),        -- Cursed Atal'ai, Elite
    [5261] = MobInfo(6672, "C"),        -- Enthralled Atal'ai, Elite
    [5401] = MobInfo(6694, "C"),        -- Kazkaz the Unholy, Elite
    [763] = MobInfo(10921, "C"),        -- Lost One Chieftain, Rare
    [1106] = MobInfo(152, "C"),         -- Lost One Cook, Rare
    [757] = MobInfo(152, "C"),          -- Lost One Fisherman
    [759] = MobInfo(152, "C"),          -- Lost One Hunter
    [760] = MobInfo(628, "C"),          -- Lost One Muckdweller
    [755] = MobInfo(628, "C"),          -- Lost One Mudlurker
    [762] = MobInfo(4688, "C"),         -- Lost One Riftseeker
    [761] = MobInfo(4688, "C"),         -- Lost One Seer
    [5477] = MobInfo(10920, "C"),       -- Noboru the Cudgel
    [5622] = MobInfo(4688, "C"),        -- Ongeku

    -- Demons
    [7735] = MobInfo(5047, "C"),        -- Felcular, Elite

    -- Undead
    [5263] = MobInfo(4769, "C"),        -- Mummified Atal'ai, Elite

    -- Dragonkin
    [740] = MobInfo(9582, "S"),         -- Adolescent Whelp
    [741] = MobInfo(621, "S"),          -- Dreaming Whelp
    [746] = MobInfo(625, "S"),          -- Elder Dragonkin
    [744] = MobInfo(7903, "S"),         -- Green Scalebane
    [742] = MobInfo(7863, "S"),         -- Green Wyrmkin
    [14445] = MobInfo(7976, "S"),       -- Lord Captain Wyrmak, Rare-Elite
    [745] = MobInfo(7976, "S"),         -- Scalebane Captain
    [743] = MobInfo(7974, "S"),         -- Wyrmkin Dreamwalker
})
