-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Tirisfal Glades (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=85). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Tirisfal Glades", {
    -- Beasts
    [271080] = MobInfo(146542, "S"),         -- Blightsculler, Rare
    [1815] = MobInfo(1082, "S"),        -- Diseased Black Bear
    [1512] = MobInfo(4732, "S"),        -- Duskbat
    [277882] = MobInfo(1954, "S"),         -- Foothills Duskbat
    [1553] = MobInfo(4734, "S"),        -- Greater Duskbat
    [1513] = MobInfo(9535, "S"),        -- Mangy Duskbat
    [277730] = MobInfo(143460, "S"),         -- Rabid Forest Wolf
    [5288] = MobInfo(3203, "S"),        -- Rabid Longtooth
    [10357] = MobInfo(9750, "S"),       -- Ressan the Needler, Rare
    [1554] = MobInfo(8808, "S"),        -- Vampiric Duskbat
    [1765] = MobInfo(11421, "S"),       -- Worg

    -- Humanoids
    [1665] = MobInfo(1739, "C"),        -- Captain Melrache
    [1662] = MobInfo(1738, "C"),        -- Captain Perrine
    [1664] = MobInfo(1737, "C"),        -- Captain Vachon
    [275437] = MobInfo(10391, "C"),         -- Dark Enforcer
    [267006] = MobInfo(10408, "C"),         -- Dark Neophyte
    [1936] = MobInfo(3535, "C"),        -- Farmer Solliden, Rare
    [4284] = MobInfo(2495, "C"),        -- Scarlet Augur, Elite
    [1660] = MobInfo(3144, "C"),        -- Scarlet Bodyguard
    [4285] = MobInfo(2505, "C"),        -- Scarlet Disciple, Elite
    [1538] = MobInfo(2466, "C"),        -- Scarlet Friar
    [4282] = MobInfo(2512, "C"),        -- Scarlet Magician, Elite
    [1536] = MobInfo(2468, "C"),        -- Scarlet Missionary
    [1539] = MobInfo(2469, "C"),        -- Scarlet Neophyte
    [4280] = MobInfo(2475, "C"),        -- Scarlet Preserver, Elite
    [4281] = MobInfo(2516, "C"),        -- Scarlet Scout, Elite
    [4283] = MobInfo(2520, "C"),        -- Scarlet Sentry, Elite
    [1540] = MobInfo(2481, "C"),        -- Scarlet Vanguard
    [1535] = MobInfo(2471, "C"),        -- Scarlet Warrior
    [1537] = MobInfo(2483, "C"),        -- Scarlet Zealot
    [1934] = MobInfo(3532, "C"),        -- Tirisfal Farmer
    [1935] = MobInfo(3534, "C"),        -- Tirisfal Farmhand

    -- Demons
    [10356] = MobInfo(7892, "S"),       -- Bayne, Rare
    [1548] = MobInfo(9020, "S"),        -- Cursed Darkhound
    [1547] = MobInfo(9021, "S"),        -- Decrepit Darkhound
    [1549] = MobInfo(3916, "S"),        -- Ravenous Darkhound

    -- Undead
    [1529] = MobInfo(1198, "C"),        -- Bleeding Horror
    [1658] = MobInfo(733, "C"),         -- Captain Dargol
    [1523] = MobInfo(535, "C"),         -- Cracked Skull Soldier
    [1522] = MobInfo(11398, "C"),       -- Darkeye Bonecaster
    [1657] = MobInfo(11399, "C"),       -- Devlin Agamand
    [10996] = MobInfo(10459, "C"),      -- Fallen Hero, Elite
    [10358] = MobInfo(5430, "C"),       -- Fellicent's Shade, Rare
    [1654] = MobInfo(646, "C"),         -- Gregor Agamand
    [1527] = MobInfo(1202, "C"),        -- Hungering Dead
    [1946] = MobInfo(10772, "C"),       -- Lillith Nefara
    [1531] = MobInfo(985, "C"),         -- Lost Soul, Rare
    [1753] = MobInfo(848, "C"),         -- Maggot Eye
    [1655] = MobInfo(10702, "C"),       -- Nissa Agamand
    [1520] = MobInfo(200, "C"),         -- Rattlecage Soldier
    [1526] = MobInfo(1201, "C"),        -- Ravaged Corpse
    [276020] = MobInfo(148451, "C"),         -- Riptear, Elite
    [1674] = MobInfo(10852, "C"),       -- Rot Hide Gnoll
    [1941] = MobInfo(10853, "C"),       -- Rot Hide Graverobber
    [1675] = MobInfo(847, "C"),         -- Rot Hide Mongrel
    [1530] = MobInfo(1196, "C"),        -- Rotting Ancestor
    [1525] = MobInfo(1200, "C"),        -- Rotting Dead
    [260428] = MobInfo(10978, "C"),         -- Shadowvale Lurcher
    [260431] = MobInfo(10978, "C"),         -- Shadowvale Lurcher
    [260430] = MobInfo(9787, "C"),         -- Shadowvale Mystic
    [260432] = MobInfo(9787, "C"),         -- Shadowvale Mystic
    [1528] = MobInfo(1197, "C"),        -- Shambling Horror
    [276089] = MobInfo(201, "C"),         -- The Condemned One, Rare
    [1656] = MobInfo(1196, "C"),        -- Thurman Agamand
    [1533] = MobInfo(9534, "C"),        -- Tormented Spirit, Rare
    [1534] = MobInfo(10752, "C"),       -- Wailing Ancestor
    [1532] = MobInfo(3227, "C"),        -- Wandering Spirit
})
