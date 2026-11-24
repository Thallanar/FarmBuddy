-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Deadwind Pass (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=41). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Deadwind Pass", {
    -- Beasts
    [7376] = MobInfo(10826, "S"),       -- Sky Shadow

    -- Humanoids
    [7369] = MobInfo(11533, "C"),       -- Deadwind Brute
    [7371] = MobInfo(11536, "C"),       -- Deadwind Mauler
    [7379] = MobInfo(11537, "C"),       -- Deadwind Ogre Mage
    [7372] = MobInfo(11538, "C"),       -- Deadwind Warlock

    -- Demons
    [247015] = MobInfo(0, nil),         -- Vek'zol, Elite
})
