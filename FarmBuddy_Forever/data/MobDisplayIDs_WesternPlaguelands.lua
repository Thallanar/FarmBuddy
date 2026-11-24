-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Western Plaguelands (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=28). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Western Plaguelands", {
    -- Beasts
    [1815] = MobInfo(1082, "S"),        -- Diseased Black Bear
    [1816] = MobInfo(1083, "S"),        -- Diseased Grizzly
    [1817] = MobInfo(4124, "S"),        -- Diseased Wolf
    [10979] = MobInfo(2709, "S"),       -- Scarlet Hound

    -- Humanoids
    [11611] = MobInfo(11459, "C"),      -- Cavalier Durgen
    [12128] = MobInfo(10512, "C"),      -- Crimson Elite, Elite
    [1843] = MobInfo(10340, "C"),       -- Foreman Jerris, Rare-Elite
    [1844] = MobInfo(10354, "C"),       -- Foreman Marcrid, Rare
    [1840] = MobInfo(10339, "C"),       -- Grand Inquisitor Isillien, Elite
    [1846] = MobInfo(10338, "C"),       -- High Protector Lorik, Elite
    [1845] = MobInfo(10345, "C"),       -- High Protector Tarsen
    [11613] = MobInfo(11462, "C"),      -- Huntsman Radley
    [1848] = MobInfo(10356, "C"),       -- Lord Maldazzar, Rare
    [227324] = MobInfo(0, nil),         -- Novice Frost Mage
    [227385] = MobInfo(0, nil),         -- Novice Frost Mage
    [227386] = MobInfo(0, nil),         -- Novice Frost Mage
    [227387] = MobInfo(0, nil),         -- Novice Frost Mage
    [4493] = MobInfo(10295, "C"),       -- Scarlet Avenger
    [1841] = MobInfo(10344, "C"),       -- Scarlet Executioner, Rare-Elite
    [1839] = MobInfo(10342, "C"),       -- Scarlet High Clerist, Rare-Elite
    [1831] = MobInfo(10277, "C"),       -- Scarlet Hunter
    [1838] = MobInfo(10343, "C"),       -- Scarlet Interrogator, Rare-Elite
    [1835] = MobInfo(10320, "C"),       -- Scarlet Invoker
    [1837] = MobInfo(10355, "C"),       -- Scarlet Judge, Rare
    [1833] = MobInfo(10291, "C"),       -- Scarlet Knight
    [1884] = MobInfo(10299, "C"),       -- Scarlet Lumberjack
    [1826] = MobInfo(10286, "C"),       -- Scarlet Mage
    [1832] = MobInfo(10328, "C"),       -- Scarlet Magus, Elite
    [10605] = MobInfo(10311, "C"),      -- Scarlet Medic
    [1834] = MobInfo(10324, "C"),       -- Scarlet Paladin, Elite
    [10608] = MobInfo(10332, "C"),      -- Scarlet Priest, Elite
    [1827] = MobInfo(10350, "C"),       -- Scarlet Sentinel, Elite
    [1885] = MobInfo(10346, "C"),       -- Scarlet Smith, Rare
    [4494] = MobInfo(10307, "C"),       -- Scarlet Spellbinder
    [1883] = MobInfo(10303, "C"),       -- Scarlet Worker

    -- Demons
    [8596] = MobInfo(7890, "S"),        -- Plaguehound Runt

    -- Undead
    [1852] = MobInfo(7919, "C"),        -- Araj the Summoner, Elite
    [4475] = MobInfo(10970, "C"),       -- Blighted Zombie
    [10996] = MobInfo(10459, "C"),      -- Fallen Hero, Elite
    [228612] = MobInfo(0, nil),         -- Festering Ghoul
    [10580] = MobInfo(4631, "C"),       -- Fetid Zombie
    [1805] = MobInfo(1693, "C"),        -- Flesh Golem, Elite
    [1847] = MobInfo(519, "C"),         -- Foulmane, Rare
    [1796] = MobInfo(10487, "C"),       -- Freezing Ghoul
    [4472] = MobInfo(146, "C"),         -- Haunting Vision
    [1802] = MobInfo(4629, "C"),        -- Hungering Wraith
    [10801] = MobInfo(10487, "C"),      -- Jabbering Ghoul
    [1850] = MobInfo(10612, "C"),       -- Putridius, Rare-Elite
    [4474] = MobInfo(4631, "C"),        -- Rotting Cadaver
    [1793] = MobInfo(137, "C"),         -- Rotting Ghoul
    [1795] = MobInfo(414, "C"),         -- Searing Ghoul
    [1789] = MobInfo(9790, "C"),        -- Skeletal Acolyte
    [1787] = MobInfo(11401, "C"),       -- Skeletal Executioner
    [1783] = MobInfo(733, "C"),         -- Skeletal Flayer
    [1784] = MobInfo(11403, "C"),       -- Skeletal Sorcerer
    [1785] = MobInfo(11404, "C"),       -- Skeletal Terror
    [1788] = MobInfo(775, "C"),         -- Skeletal Warlord, Elite
    [1791] = MobInfo(570, "C"),         -- Slavering Ghoul
    [1794] = MobInfo(10626, "C"),       -- Soulless Ghoul
    [11873] = MobInfo(146, "C"),        -- Spectral Attendant
    [1804] = MobInfo(10690, "C"),       -- Wailing Death
    [10816] = MobInfo(7550, "C"),       -- Wandering Skeleton
})
