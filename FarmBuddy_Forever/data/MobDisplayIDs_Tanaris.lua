-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Tanaris (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=440). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Tanaris", {
    -- Beasts
    [5426] = MobInfo(1536, "S"),        -- Blisterpaw Hyena
    [5419] = MobInfo(141, "S"),         -- Glasshide Basilisk
    [5420] = MobInfo(7344, "S"),        -- Glasshide Gazer
    [5421] = MobInfo(12339, "S"),       -- Glasshide Petrifier
    [8208] = MobInfo(1534, "S"),        -- Murderous Blisterpaw, Rare
    [5427] = MobInfo(2609, "S"),        -- Rabid Blisterpaw
    [5424] = MobInfo(10986, "S"),       -- Scorpid Dunestalker
    [5422] = MobInfo(2414, "S"),        -- Scorpid Hunter
    [5423] = MobInfo(10987, "S"),       -- Scorpid Tail Lasher
    [5425] = MobInfo(1535, "S"),        -- Starving Blisterpaw
    [14123] = MobInfo(7114, "S"),       -- Steeljaw Snapper
    [5431] = MobInfo(7114, "S"),        -- Surf Glider

    -- Humanoids
    [7883] = MobInfo(9073, "C"),        -- Andre Firebeard
    [7847] = MobInfo(9169, "C"),        -- Caliph Scorpidsting
    [8202] = MobInfo(11532, "C"),       -- Cyclok the Mad, Rare
    [5474] = MobInfo(11545, "C"),       -- Dunemaul Brute
    [5472] = MobInfo(11544, "C"),       -- Dunemaul Enforcer
    [5471] = MobInfo(11545, "C"),       -- Dunemaul Ogre
    [5473] = MobInfo(12003, "C"),       -- Dunemaul Ogre Mage
    [5475] = MobInfo(11542, "C"),       -- Dunemaul Warlock
    [12046] = MobInfo(10709, "C"),      -- Gor'marok the Ravager
    [8200] = MobInfo(9024, "C"),        -- Jin'Zallah the Sandbringer, Rare-Elite
    [8203] = MobInfo(7509, "C"),        -- Kregg Keelhaul, Rare
    [8201] = MobInfo(11570, "C"),       -- Omgorn the Lost, Rare
    [5646] = MobInfo(6411, "C"),        -- Sandfury Axe Thrower, Elite
    [5647] = MobInfo(6415, "C"),        -- Sandfury Firecaller, Elite
    [5645] = MobInfo(6413, "C"),        -- Sandfury Hideskinner, Elite
    [260419] = MobInfo(415, "C"),       -- Slugjaw
    [7857] = MobInfo(6938, "C"),        -- Southsea Dock Worker
    [7856] = MobInfo(6948, "C"),        -- Southsea Freebooter
    [7855] = MobInfo(6944, "C"),        -- Southsea Pirate
    [7858] = MobInfo(6950, "C"),        -- Southsea Swashbuckler
    [7902] = MobInfo(6957, "C"),        -- Treasure Hunting Buccaneer
    [7899] = MobInfo(6959, "C"),        -- Treasure Hunting Pirate
    [7901] = MobInfo(6963, "C"),        -- Treasure Hunting Swashbuckler
    [8199] = MobInfo(9023, "C"),        -- Warleader Krazzilak, Rare-Elite
    [5623] = MobInfo(5573, "C"),        -- Wastewander Assassin
    [5618] = MobInfo(5568, "C"),        -- Wastewander Bandit
    [5615] = MobInfo(5571, "C"),        -- Wastewander Rogue
    [7805] = MobInfo(5573, "C"),        -- Wastewander Scofflaw
    [5617] = MobInfo(5530, "C"),        -- Wastewander Shadow Mage
    [5616] = MobInfo(5532, "C"),        -- Wastewander Thief

    -- Giants
    [5466] = MobInfo(10039, "C"),       -- Coast Strider, Elite
    [5467] = MobInfo(12812, "C"),       -- Deep Dweller, Elite

    -- Dragonkin
    [8197] = MobInfo(6370, "S"),        -- Chronalis, Elite
    [8196] = MobInfo(8317, "S"),        -- Occulus, Elite
    [8198] = MobInfo(8318, "S"),        -- Tick, Elite
})
