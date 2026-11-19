-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Silverpine Forest (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=130). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Silverpine Forest", {
    -- Beasts
    [1923] = MobInfo(741, "S"),         -- Bloodsnout Worg
    [1778] = MobInfo(902, "S"),         -- Ferocious Grizzled Bear
    [277882] = MobInfo(1954, "S"),         -- Foothills Duskbat
    [1797] = MobInfo(820, "S"),         -- Giant Grizzled Bear
    [12431] = MobInfo(11413, "S"),      -- Gorefang, Rare
    [1766] = MobInfo(246, "S"),         -- Mottled Worg
    [12432] = MobInfo(982, "S"),        -- Old Vicejaw, Rare
    [2173] = MobInfo(245, "S"),         -- Reef Frenzy
    [2408] = MobInfo(1244, "S"),        -- Snapjaw
    [1765] = MobInfo(11421, "S"),       -- Worg

    -- Humanoids
    [2067] = MobInfo(3576, "C"),        -- Councilman Brunswick, Elite
    [2065] = MobInfo(3578, "C"),        -- Councilman Cooper, Elite
    [2064] = MobInfo(3570, "C"),        -- Councilman Hartin, Elite
    [2062] = MobInfo(3565, "C"),        -- Councilman Hendricks, Elite
    [2066] = MobInfo(3574, "C"),        -- Councilman Higarth, Elite
    [2060] = MobInfo(3557, "C"),        -- Councilman Smithers, Elite
    [2061] = MobInfo(3563, "C"),        -- Councilman Thatcher, Elite
    [2063] = MobInfo(3577, "C"),        -- Councilman Wilhelm, Elite
    [6570] = MobInfo(10834, "C"),       -- Fenwick Thatros
    [1972] = MobInfo(564, "S"),         -- Grimson the Pale
    [2068] = MobInfo(3575, "C"),        -- Lord Mayor Morrison, Elite
    [1924] = MobInfo(574, "S"),         -- Moonrage Bloodhowler
    [1770] = MobInfo(729, "S"),         -- Moonrage Darkrunner
    [1782] = MobInfo(574, "S"),         -- Moonrage Darksoul
    [1896] = MobInfo(729, "SC"),        -- Moonrage Elder, Elite
    [1779] = MobInfo(1947, "S"),        -- Moonrage Glutton
    [3533] = MobInfo(729, "SC"),        -- Moonrage Leatherworker, Elite
    [1893] = MobInfo(564, "SC"),        -- Moonrage Sentry, Elite
    [3531] = MobInfo(729, "SC"),        -- Moonrage Tailor, Elite
    [1892] = MobInfo(574, "SC"),        -- Moonrage Watcher, Elite
    [1769] = MobInfo(11180, "S"),       -- Moonrage Whitescalp
    [259897] = MobInfo(574, "S"),         -- Old Fire-Eye, Elite
    [203139] = MobInfo(1098, "S"),         -- Son of Arugal, Elite
    [1947] = MobInfo(4430, "C"),        -- Thule Ravenclaw, Elite

    -- Undead
    [1870] = MobInfo(732, "C"),         -- Hand of Ravenclaw
    [1971] = MobInfo(1065, "C"),        -- Ivar the Foul
    [1983] = MobInfo(915, "C"),         -- Nightlash
    [1943] = MobInfo(10856, "C"),       -- Raging Rot Hide
    [1869] = MobInfo(732, "C"),         -- Ravenclaw Champion
    [1974] = MobInfo(828, "C"),         -- Ravenclaw Drudger
    [1973] = MobInfo(370, "C"),         -- Ravenclaw Guardian
    [1865] = MobInfo(732, "C"),         -- Ravenclaw Raider
    [2283] = MobInfo(1019, "C"),        -- Ravenclaw Regent, Rare
    [1868] = MobInfo(828, "C"),         -- Ravenclaw Servant
    [1866] = MobInfo(829, "C"),         -- Ravenclaw Slave
    [1944] = MobInfo(10850, "C"),       -- Rot Hide Bruiser, Rare
    [1939] = MobInfo(10851, "C"),       -- Rot Hide Brute
    [1772] = MobInfo(848, "C"),         -- Rot Hide Gladerunner
    [1773] = MobInfo(10854, "C"),       -- Rot Hide Mystic
    [1940] = MobInfo(10855, "C"),       -- Rot Hide Plague Weaver
    [1942] = MobInfo(858, "C"),         -- Rot Hide Savage
    [1948] = MobInfo(965, "C"),         -- Snarlmane, Rare
})
