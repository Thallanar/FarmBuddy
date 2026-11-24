-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Riverglades (Forever)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=16591). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Riverglades", {
    -- Beasts
    [259263] = MobInfo(161, "S"),       -- Coyote Prowler
    [270310] = MobInfo(229, "S"),       -- Farholde Steed
    [259046] = MobInfo(1251, "S"),      -- Freshwater Crocolisk
    [263380] = MobInfo(2850, "S"),      -- Ghostmaw, Elite
    [263307] = MobInfo(14557, "S"),     -- Glade Viper
    [259269] = MobInfo(2305, "S"),      -- High Plains Buzzard
    [266862] = MobInfo(144906, "S"),    -- Juvenile Paletusk
    [263615] = MobInfo(143766, "S"),    -- Krek the Noxious, Elite
    [263343] = MobInfo(2305, "S"),      -- Low Plains Buzzard
    [255851] = MobInfo(3027, "S"),      -- Mature Paletusk
    [260244] = MobInfo(992, "S"),       -- Monstrous Threshadon
    [259267] = MobInfo(161, "S"),       -- Plains Coyote
    [268831] = MobInfo(161, "S"),       -- Plains Prowler
    [262037] = MobInfo(10033, "S"),     -- Roosting Duskbat
    [263348] = MobInfo(1284, "S"),      -- Roving Tallstrider
    [255901] = MobInfo(5557, "S"),      -- Sand Crawler
    [256807] = MobInfo(999, "S"),       -- Shore Crawler
    [258522] = MobInfo(7339, "S"),      -- Sootfur
    [260235] = MobInfo(1939, "S"),      -- Trapclaw
    [257017] = MobInfo(246, "S"),       -- Twilight Worg
    [259055] = MobInfo(1933, "S"),      -- Wildplains Huntress
    [259054] = MobInfo(1977, "S"),      -- Wildplains Patriarch
    [258331] = MobInfo(6807, "S"),      -- Young Paletusk

    -- Humanoids
    [257861] = MobInfo(140431, "C"),    -- Admiral Lamora
    [256899] = MobInfo(16020, "C"),     -- Chogg'Zac, Elite
    [259258] = MobInfo(141425, "C"),    -- Converted Farmer
    [257916] = MobInfo(140461, "C"),    -- Eastsea Bombardier
    [257901] = MobInfo(140452, "C"),    -- Eastsea Buccaneer
    [257910] = MobInfo(140456, "C"),    -- Eastsea Musketeer
    [257915] = MobInfo(140459, "C"),    -- Eastsea Raider
    [261711] = MobInfo(142910, "C"),    -- Empowered Brute
    [256892] = MobInfo(139861, "C"),    -- Kargra the Blind, Rare
    [260973] = MobInfo(11569, "C"),     -- Klunk
    [257034] = MobInfo(139922, "C"),    -- Mad Marrius, Rare-Elite
    [255769] = MobInfo(609, "C"),       -- Redridge Brute
    [255770] = MobInfo(10789, "C"),     -- Redridge Mystic
    [255774] = MobInfo(269, "C"),       -- Redridge Scout
    [255772] = MobInfo(551, "C"),       -- Redridge Trapper
    [255906] = MobInfo(376, "C"),       -- Snargl, Elite
    [261710] = MobInfo(10714, "C"),     -- Twilight Brute
    [256799] = MobInfo(139889, "C"),    -- Twilight Champion
    [256797] = MobInfo(139817, "C"),    -- Twilight Corrupter
    [256800] = MobInfo(142910, "C"),    -- Twilight Enforcer, Elite
    [256795] = MobInfo(147688, "C"),    -- Twilight Fanatic
    [261497] = MobInfo(142909, "C"),    -- Twilight Firecaller
    [258032] = MobInfo(140581, "C"),    -- Twilight Forgemaster, Rare-Elite
    [260969] = MobInfo(138242, "C"),    -- Twilight Instigator
    [260968] = MobInfo(142910, "C"),    -- Twilight Mauler
    [256798] = MobInfo(147664, "C"),    -- Twilight Neophyte
    [256952] = MobInfo(139999, "C"),    -- Twilight Raider
    [262169] = MobInfo(143078, "C"),    -- Twilight Ritualist
    [254560] = MobInfo(138242, "C"),    -- Twilight Shadowmancer
    [260996] = MobInfo(140328, "C"),    -- Twilight Subjugator

    -- Giants
    [259758] = MobInfo(12812, "C"),     -- Gul'gash, Rare-Elite

    -- Dragonkin
    [262477] = MobInfo(143, "S"),       -- Cinderscale Warrior
    [262473] = MobInfo(497, "S"),       -- Cinderscale Whelp
    [263141] = MobInfo(9585, "S"),      -- Scaldaron, Rare-Elite

    -- Mechanicals
    [272228] = MobInfo(378, "C"),       -- Harvest Sentry
})
