-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Darkshore (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=148). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Darkshore", {
    -- Beasts
    [2174] = MobInfo(245, "S"),         -- Coastal Frenzy
    [2185] = MobInfo(992, "S"),         -- Darkshore Thresher
    [6788] = MobInfo(1007, "S"),        -- Den Mother
    [2187] = MobInfo(994, "S"),         -- Elder Darkshore Thresher
    [2322] = MobInfo(178, "S"),         -- Foreststrider
    [2321] = MobInfo(1042, "S"),        -- Foreststrider Fledgling
    [2323] = MobInfo(1283, "S"),        -- Giant Foreststrider
    [2165] = MobInfo(14316, "S"),       -- Grizzled Thistle Bear
    [2069] = MobInfo(321, "S"),         -- Moonstalker
    [2071] = MobInfo(3031, "S"),        -- Moonstalker Matriarch
    [2070] = MobInfo(11449, "S"),       -- Moonstalker Runt
    [2237] = MobInfo(11450, "S"),       -- Moonstalker Sire
    [2164] = MobInfo(8840, "S"),        -- Rabid Thistle Bear
    [2175] = MobInfo(3030, "S"),        -- Shadowclaw, Rare
    [2172] = MobInfo(38, "S"),          -- Strider Clutchmother, Rare
    [2163] = MobInfo(1006, "S"),        -- Thistle Bear
    [6789] = MobInfo(5510, "S"),        -- Thistle Cub

    -- Humanoids
    [3660] = MobInfo(4413, "C"),        -- Athrikus Narassin
    [2167] = MobInfo(1010, "C"),        -- Blackwood Pathfinder
    [2171] = MobInfo(6822, "C"),        -- Blackwood Shaman
    [2169] = MobInfo(6821, "C"),        -- Blackwood Totemic
    [2170] = MobInfo(5773, "C"),        -- Blackwood Ursa
    [2168] = MobInfo(1011, "C"),        -- Blackwood Warrior
    [2324] = MobInfo(6820, "C"),        -- Blackwood Windtalker
    [2186] = MobInfo(5773, "C"),        -- Carnivous the Breaker, Rare
    [3727] = MobInfo(1643, "C"),        -- Dark Strand Enforcer
    [3730] = MobInfo(9751, "C"),        -- Dark Strand Excavator
    [2336] = MobInfo(4217, "C"),        -- Dark Strand Fanatic
    [2337] = MobInfo(4230, "C"),        -- Dark Strand Voidcaller
    [2192] = MobInfo(5772, "C"),        -- Firecaller Radison, Rare
    [7015] = MobInfo(1305, "C"),        -- Flagglemurk the Cruel, Rare
    [2159] = MobInfo(6528, "C"),        -- Gravelflint Bonesnapper
    [2160] = MobInfo(976, "C"),         -- Gravelflint Geomancer
    [2158] = MobInfo(6529, "C"),        -- Gravelflint Scout
    [7016] = MobInfo(4982, "C"),        -- Lady Vespira, Rare
    [7017] = MobInfo(4762, "C"),        -- Lord Sinslayer, Rare
    [11714] = MobInfo(11661, "C"),      -- Marosh the Devious
    [11196] = MobInfo(11442, "C"),      -- Shatterspear Drummer
    [2338] = MobInfo(2873, "C"),        -- Twilight Disciple
    [2339] = MobInfo(2869, "C"),        -- Twilight Thug
    [2189] = MobInfo(2452, "C"),        -- Vile Sprite
    [2190] = MobInfo(1015, "C"),        -- Wild Grell

    -- Demons
    [3898] = MobInfo(467, "C"),         -- Aligar the Tormentor
    [3899] = MobInfo(2007, "C"),        -- Balizar the Umbrage
    [3900] = MobInfo(9781, "C"),        -- Caedakar the Vicious
    [3662] = MobInfo(467, "C"),         -- Delmanis the Hated
    [2212] = MobInfo(1013, "C"),        -- Deth'ryll Satyr
    [4788] = MobInfo(2012, "C"),        -- Fallenroot Satyr, Elite
    [2191] = MobInfo(10819, "C"),       -- Licillin, Rare
    [10373] = MobInfo(2007, "C"),       -- Xabraxxis

    -- Undead
    [3667] = MobInfo(1937, "C"),        -- Anaya Dawnrunner
    [2176] = MobInfo(985, "C"),         -- Cursed Highborne
    [2184] = MobInfo(5774, "C"),        -- Lady Moongazer, Rare
    [6133] = MobInfo(4958, "C"),        -- Shade of Elura
    [2178] = MobInfo(10690, "C"),       -- Wailing Highborne
    [2177] = MobInfo(5430, "C"),        -- Writhing Highborne
})
