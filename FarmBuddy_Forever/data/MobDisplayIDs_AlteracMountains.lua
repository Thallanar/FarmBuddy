-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Alterac Mountains (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=36). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Alterac Mountains", {
    -- Beasts
    [14222] = MobInfo(1933, "S"),       -- Araga, Rare
    [14223] = MobInfo(5026, "S"),       -- Cranky Benj, Rare
    [2356] = MobInfo(3201, "S"),        -- Elder Gray Bear
    [2351] = MobInfo(806, "S"),         -- Gray Bear
    [2407] = MobInfo(2300, "S"),        -- Hulking Mountain Lion
    [2406] = MobInfo(1058, "S"),        -- Mountain Lion
    [2408] = MobInfo(1244, "S"),        -- Snapjaw
    [2384] = MobInfo(1059, "S"),        -- Starving Mountain Lion
    [13602] = MobInfo(13644, "S"),      -- The Abominable Greench, Elite

    -- Humanoids
    [2318] = MobInfo(3723, "C"),        -- Argus Shadow Mage
    [2306] = MobInfo(1827, "C"),        -- Baron Vardus
    [266357] = MobInfo(144792, "C"),    -- Barton
    [2248] = MobInfo(3206, "S"),        -- Cave Yeti
    [2253] = MobInfo(610, "C"),         -- Crushridge Brute
    [2256] = MobInfo(416, "C"),         -- Crushridge Enforcer, Elite
    [2255] = MobInfo(6705, "C"),        -- Crushridge Mage, Elite
    [2254] = MobInfo(655, "C"),         -- Crushridge Mauler, Elite
    [2252] = MobInfo(11567, "C"),       -- Crushridge Ogre
    [2416] = MobInfo(415, "C"),         -- Crushridge Plunderer, Elite
    [2287] = MobInfo(536, "C"),         -- Crushridge Warmonger, Elite
    [2440] = MobInfo(3732, "C"),        -- Drunken Footpad
    [2249] = MobInfo(3207, "S"),        -- Ferocious Yeti
    [2251] = MobInfo(6767, "S"),        -- Giant Yeti
    [2422] = MobInfo(11552, "C"),       -- Glommus, Elite
    [3985] = MobInfo(2052, "C"),        -- Grandpa Vishas, Elite
    [14221] = MobInfo(2582, "C"),       -- Gravis Slipknot, Rare
    [2417] = MobInfo(11563, "C"),       -- Grel'borg the Miser, Elite
    [2431] = MobInfo(1830, "C"),        -- Jailor Borhuin
    [14281] = MobInfo(3616, "C"),       -- Jimmy the Bleeder, Rare
    [2453] = MobInfo(11566, "C"),       -- Lo'Grosh, Rare
    [2423] = MobInfo(1833, "C"),        -- Lord Aliden Perenolde
    [2250] = MobInfo(1050, "S"),        -- Mountain Yeti
    [2421] = MobInfo(416, "C"),         -- Muckrake, Elite
    [2257] = MobInfo(11568, "C"),       -- Mug'thol, Elite
    [2320] = MobInfo(1836, "C"),        -- Nagaz
    [3984] = MobInfo(2047, "C"),        -- Nancy Vishas, Elite
    [2452] = MobInfo(1078, "S"),        -- Skhowl, Rare
    [2246] = MobInfo(3727, "C"),        -- Syndicate Assassin
    [2247] = MobInfo(3729, "C"),        -- Syndicate Enforcer
    [2240] = MobInfo(3706, "C"),        -- Syndicate Footpad
    [2245] = MobInfo(3725, "C"),        -- Syndicate Saboteur
    [2243] = MobInfo(3721, "C"),        -- Syndicate Sentry
    [2242] = MobInfo(3716, "C"),        -- Syndicate Spy
    [2241] = MobInfo(3709, "C"),        -- Syndicate Thief
    [2319] = MobInfo(3712, "C"),        -- Syndicate Wizard
    [2420] = MobInfo(536, "C"),         -- Targ, Elite
    [2415] = MobInfo(1840, "C"),        -- Warden Belamoore

    -- Dragonkin
    [2447] = MobInfo(6371, "S"),        -- Narillasanz, Rare-Elite
})
