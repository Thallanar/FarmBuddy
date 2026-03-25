-- =============================================================================
-- FarmBuddy - Tabela de DisplayIDs de Mobs
-- =============================================================================
-- Lookup rápido: npcID → displayID para renderizar portraits no mapa.
-- Dados extraídos do Wowhead. Quando o npcID não está nesta tabela,
-- o addon usa ícone genérico por tipo de criatura (Beast/Humanoid/Dragonkin).
--
-- Para adicionar novos mobs:
--   1. Abra wowhead.com/npc=NPCID
--   2. No model viewer, encontre o displayID
--   3. Adicione a entrada: [NPCID] = DISPLAYID,
-- =============================================================================

FarmBuddyMobDisplayIDs = {

    -- =====================================================================
    -- Eversong Woods
    -- =====================================================================

    -- Beasts
    [238089] = 124934,  -- Territorial Dragonhawk
    [253939] = 131956,  -- Springpaw Lynx
    [243171] = 125357,  -- Gloombelly Toad
    [250030] = 124012,  -- Ghostfeather Dragonhawk
    [250035] = 131993,  -- Ghostclaw Lynx
    [256843] = 129979,  -- Glistening Hawkstrider
    [256841] = 129979,  -- Resplendent Hawkstrider
    [256862] = 129979,  -- Brilliant Hawkstrider
    [237407] = 129979,  -- Displaced Hawkstrider
    [246633] = 130084,  -- Harried Hawkstrider (Rare)
    [255302] = 136093,  -- Duskburn (Rare, Serpent)
    [245688] = 124943,  -- Gloomclaw (Rare, Lynx)
    [252526] = 125033,  -- Yoked Pangolin (Rare)

    -- Humanoids
    [250683] = 66815,   -- Coralfang

    -- =====================================================================
    -- Zul'Aman
    -- =====================================================================

    -- Humanoids
    [254726] = 130754,  -- Fallen Amani Scout

    -- =====================================================================
    -- Harandar
    -- =====================================================================

    -- Beasts
    [251569] = 128671,  -- Grimlynx
    [252189] = 128673,  -- Har'athir Grimlynx
    [251627] = 128675,  -- Swift Grimlynx
    [248741] = 15869,   -- Rhazul (Rare)
    [249849] = 125988,  -- Ha'kalawe (Rare, Sporebat)

    -- =====================================================================
    -- Voidstorm
    -- =====================================================================

    -- Beasts
    [238476] = 125833,  -- Vicious Karion
    [235413] = 80502,   -- Territorial Netherwasp
}
