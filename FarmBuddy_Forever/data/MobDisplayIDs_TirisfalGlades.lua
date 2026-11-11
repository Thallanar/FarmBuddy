-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Tirisfal Glades (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = displayID,  -- Nome do mob[, Rare/Elite]
-- Fonte: Wowhead Forever (zone=85). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

FarmBuddyForever:RegisterZone("Tirisfal Glades", {
    -- Beasts
    [271080] = 0,     -- Blightsculler, Rare
    [1809] = 0,       -- Carrion Vulture
    [274300] = 0,     -- Coldrasp, Rare
    [1815] = 0,       -- Diseased Black Bear
    [1512] = 0,       -- Duskbat
    [277882] = 0,     -- Foothills Duskbat
    [1553] = 0,       -- Greater Duskbat
    [1513] = 0,       -- Mangy Duskbat
    [1688] = 0,       -- Night Web Matriarch
    [1505] = 0,       -- Night Web Spider
    [277730] = 0,     -- Rabid Forest Wolf
    [5288] = 0,       -- Rabid Longtooth
    [1509] = 0,       -- Ragged Scavenger
    [10357] = 0,      -- Ressan the Needler, Rare
    [10359] = 0,      -- Sri'skulk, Rare
    [1554] = 0,       -- Vampiric Duskbat
    [1822] = 0,       -- Venom Mist Lurker
    [1555] = 0,       -- Vicious Night Web Spider
    [1765] = 0,       -- Worg
    [1504] = 0,       -- Young Night Web Spider
    [1508] = 0,       -- Young Scavenger

    -- Humanoids
    [1665] = 0,       -- Captain Melrache
    [1662] = 0,       -- Captain Perrine
    [1664] = 0,       -- Captain Vachon
    [275437] = 0,     -- Dark Enforcer
    [267006] = 0,     -- Dark Neophyte
    [1911] = 0,       -- Deeb, Rare
    [1936] = 0,       -- Farmer Solliden, Rare
    [202060] = 0,     -- Frozen Murloc
    [208196] = 0,     -- Gillgar, Elite
    [13158] = 0,      -- Lieutenant Sanders
    [1667] = 0,       -- Meven Korgal
    [1910] = 0,       -- Muad, Rare
    [4284] = 0,       -- Scarlet Augur, Elite
    [1660] = 0,       -- Scarlet Bodyguard
    [1506] = 0,       -- Scarlet Convert
    [4285] = 0,       -- Scarlet Disciple, Elite
    [1538] = 0,       -- Scarlet Friar
    [238745] = 0,     -- Scarlet Infiltrator, Elite
    [1507] = 0,       -- Scarlet Initiate
    [4282] = 0,       -- Scarlet Magician, Elite
    [1536] = 0,       -- Scarlet Missionary
    [1539] = 0,       -- Scarlet Neophyte
    [4280] = 0,       -- Scarlet Preserver, Elite
    [4281] = 0,       -- Scarlet Scout, Elite
    [4283] = 0,       -- Scarlet Sentry, Elite
    [1540] = 0,       -- Scarlet Vanguard
    [1535] = 0,       -- Scarlet Warrior
    [1537] = 0,       -- Scarlet Zealot
    [1934] = 0,       -- Tirisfal Farmer
    [1935] = 0,       -- Tirisfal Farmhand
    [6390] = 0,       -- Ulag the Cleaver
    [250283] = 0,     -- Vile Fin Attacker
    [1544] = 0,       -- Vile Fin Minor Oracle
    [1545] = 0,       -- Vile Fin Muckdweller
    [1543] = 0,       -- Vile Fin Puddlejumper
    [250282] = 0,     -- Vile Fin Seer

    -- Demons
    [10356] = 0,      -- Bayne, Rare
    [1548] = 0,       -- Cursed Darkhound
    [1547] = 0,       -- Decrepit Darkhound
    [1549] = 0,       -- Ravenous Darkhound

    -- Undead
    [1529] = 0,       -- Bleeding Horror
    [1658] = 0,       -- Captain Dargol
    [1523] = 0,       -- Cracked Skull Soldier
    [1917] = 0,       -- Daniel Ulfman
    [1522] = 0,       -- Darkeye Bonecaster
    [1657] = 0,       -- Devlin Agamand
    [10996] = 0,      -- Fallen Hero, Elite
    [10358] = 0,      -- Fellicent's Shade, Rare
    [1654] = 0,       -- Gregor Agamand
    [1527] = 0,       -- Hungering Dead
    [1918] = 0,       -- Karrel Grayves
    [1946] = 0,       -- Lillith Nefara
    [1531] = 0,       -- Lost Soul, Rare
    [1753] = 0,       -- Maggot Eye
    [1501] = 0,       -- Mindless Zombie
    [1655] = 0,       -- Nissa Agamand
    [1890] = 0,       -- Rattlecage Skeleton
    [1520] = 0,       -- Rattlecage Soldier
    [1526] = 0,       -- Ravaged Corpse
    [276020] = 0,     -- Riptear, Elite
    [1674] = 0,       -- Rot Hide Gnoll
    [1941] = 0,       -- Rot Hide Graverobber
    [1675] = 0,       -- Rot Hide Mongrel
    [1530] = 0,       -- Rotting Ancestor
    [1525] = 0,       -- Rotting Dead
    [1919] = 0,       -- Samuel Fipps
    [260428] = 0,     -- Shadowvale Lurcher
    [260431] = 0,     -- Shadowvale Lurcher
    [260430] = 0,     -- Shadowvale Mystic
    [260432] = 0,     -- Shadowvale Mystic
    [1528] = 0,       -- Shambling Horror
    [16422] = 0,      -- Skeletal Soldier
    [16423] = 0,      -- Spectral Apparition
    [1916] = 0,       -- Stephen Bhartec
    [276089] = 0,     -- The Condemned One, Rare
    [1656] = 0,       -- Thurman Agamand
    [1533] = 0,       -- Tormented Spirit, Rare
    [1534] = 0,       -- Wailing Ancestor
    [1532] = 0,       -- Wandering Spirit
    [260396] = 0,     -- Whispering Horror, Elite
    [1502] = 0,       -- Wretched Zombie

    -- Mechanicals
    [211955] = 0,     -- Auxiliary Anti-Tamper Mechanism, Elite
    [211953] = 0,     -- Bulky Protective Ironweave, Elite
    [276061] = 0,     -- Decrepit Harvester, Rare
    [211954] = 0,     -- Electrostatic Discharge Shielding, Elite
    [212252] = 0,     -- Harvest Golem V000-A, Elite
})
