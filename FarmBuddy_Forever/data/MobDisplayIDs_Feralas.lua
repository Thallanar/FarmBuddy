-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Feralas (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=357). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Feralas", {
    -- Beasts
    [5347] = MobInfo(10889, "S"),       -- Antilus the Soarer, Rare
    [5349] = MobInfo(7569, "S"),        -- Arash-ethis, Rare
    [12801] = MobInfo(10810, "S"),      -- Arcane Chimaerok, Elite
    [12800] = MobInfo(4269, "S"),       -- Chimaerok, Elite
    [12802] = MobInfo(9560, "S"),       -- Chimaerok Devourer, Elite
    [5300] = MobInfo(3210, "S"),        -- Frayfeather Hippogryph
    [5306] = MobInfo(6756, "S"),        -- Frayfeather Patriarch
    [5305] = MobInfo(3211, "S"),        -- Frayfeather Skystormer
    [5304] = MobInfo(10890, "S"),       -- Frayfeather Stagwing
    [12418] = MobInfo(2712, "S"),       -- Gordok Hyena
    [5272] = MobInfo(8838, "S"),        -- Grizzled Ironfur Bear
    [5260] = MobInfo(3186, "S"),        -- Groddoc Ape
    [5262] = MobInfo(3188, "S"),        -- Groddoc Thunderer
    [5268] = MobInfo(3201, "S"),        -- Ironfur Bear
    [5274] = MobInfo(3200, "S"),        -- Ironfur Patriarch
    [5287] = MobInfo(3202, "S"),        -- Longtooth Howler
    [5286] = MobInfo(165, "S"),         -- Longtooth Runner
    [12803] = MobInfo(12683, "S"),      -- Lord Lakmaeran, Elite
    [269057] = MobInfo(0, nil),         -- Mirrorscale
    [4124] = MobInfo(1056, "S"),        -- Needles Cougar
    [5352] = MobInfo(706, "S"),         -- Old Grizzlegut, Rare
    [4249] = MobInfo(10903, "S"),       -- Pesterhide Snarler
    [5288] = MobInfo(3203, "S"),        -- Rabid Longtooth
    [221364] = MobInfo(0, nil),         -- Rampaging Chimaera
    [5308] = MobInfo(3204, "S"),        -- Rogue Vale Screecher
    [5356] = MobInfo(780, "S"),         -- Snarler, Rare
    [272401] = MobInfo(0, nil),         -- Vale Screamer
    [5307] = MobInfo(2699, "S"),        -- Vale Screecher

    -- Humanoids
    [221389] = MobInfo(0, nil),         -- Alondrius, Elite
    [5346] = MobInfo(7336, "S"),        -- Bloodroar the Stalker, Rare
    [223127] = MobInfo(0, nil),         -- Dead Diseased Grimtotem Shaman
    [223128] = MobInfo(0, nil),         -- Dead Diseased Woodpaw Mystic
    [221370] = MobInfo(0, nil),         -- Dreamspring Roguefeather
    [221371] = MobInfo(0, nil),         -- Dreamspring Stormcaller
    [8075] = MobInfo(974, "C"),         -- Edana Hatetalon, Elite
    [5297] = MobInfo(3209, "S"),        -- Elder Rage Scar
    [5295] = MobInfo(10943, "S"),       -- Enraged Feral Scar
    [5292] = MobInfo(3207, "S"),        -- Feral Scar Yeti
    [5299] = MobInfo(3208, "S"),        -- Ferocious Rage Scar
    [11440] = MobInfo(12471, "C"),      -- Gordok Enforcer, Elite
    [11442] = MobInfo(12473, "C"),      -- Gordok Mauler, Elite
    [11443] = MobInfo(12472, "C"),      -- Gordok Ogre-Mage, Elite
    [5238] = MobInfo(11533, "C"),       -- Gordunni Battlemaster
    [5232] = MobInfo(11554, "C"),       -- Gordunni Brute
    [5239] = MobInfo(11556, "C"),       -- Gordunni Mage-Lord
    [5234] = MobInfo(11557, "C"),       -- Gordunni Mauler
    [5229] = MobInfo(597, "C"),         -- Gordunni Ogre
    [5237] = MobInfo(11558, "C"),       -- Gordunni Ogre Mage
    [5236] = MobInfo(11559, "C"),       -- Gordunni Shaman
    [5240] = MobInfo(11560, "C"),       -- Gordunni Warlock
    [5241] = MobInfo(11561, "C"),       -- Gordunni Warlord
    [7726] = MobInfo(6831, "C"),        -- Grimtotem Naturalist
    [7725] = MobInfo(6835, "C"),        -- Grimtotem Raider
    [7727] = MobInfo(6833, "C"),        -- Grimtotem Shaman
    [5293] = MobInfo(10944, "S"),       -- Hulking Feral Scar
    [221375] = MobInfo(0, nil),         -- Lost Daughter
    [222286] = MobInfo(0, nil),         -- Namida Grimtotem, Elite
    [5362] = MobInfo(10872, "C"),       -- Northspring Harpy
    [5363] = MobInfo(10873, "C"),       -- Northspring Roguefeather
    [5364] = MobInfo(10874, "C"),       -- Northspring Slayer
    [5366] = MobInfo(1352, "C"),        -- Northspring Windcaller
    [222233] = MobInfo(0, nil),         -- Ohk'zi, Elite
    [5296] = MobInfo(3220, "S"),        -- Rage Scar Yeti
    [221391] = MobInfo(0, nil),         -- Slirena, Elite
    [222044] = MobInfo(0, nil),         -- Twilight Dark Shaman, Elite
    [221377] = MobInfo(0, nil),         -- Vengeful Son
    [5258] = MobInfo(10793, "C"),       -- Woodpaw Alpha
    [5253] = MobInfo(543, "C"),         -- Woodpaw Brute
    [5249] = MobInfo(8598, "C"),        -- Woodpaw Mongrel
    [5254] = MobInfo(10794, "C"),       -- Woodpaw Mystic
    [5255] = MobInfo(10795, "C"),       -- Woodpaw Reaver
    [5251] = MobInfo(10796, "C"),       -- Woodpaw Trapper

    -- Demons
    [221407] = MobInfo(0, nil),         -- Dreamshadow Imp
    [223544] = MobInfo(0, nil),         -- Fel Interloper
    [221406] = MobInfo(0, nil),         -- Moonwalker Betrayer
    [221408] = MobInfo(0, nil),         -- Night Hunter

    -- Elementals
    [221365] = MobInfo(0, nil),         -- Deathpetal Lasher
    [223123] = MobInfo(0, nil),         -- Diseased Forest Walker
    [222799] = MobInfo(0, nil),         -- Simmering Elemental
    [221935] = MobInfo(0, nil),         -- Treant Avatar
    [223130] = MobInfo(0, nil),         -- Uprooted Gloomwood
    [222919] = MobInfo(0, nil),         -- Whirling Tempest

    -- Giants
    [5360] = MobInfo(12812, "C"),       -- Deep Strider, Elite
    [221373] = MobInfo(0, nil),         -- Enraged Mountain Giant, Elite
    [211956] = MobInfo(0, nil),         -- Scarimous the Wandering, Boss
    [5359] = MobInfo(4945, "C"),        -- Shore Strider, Elite
    [222789] = MobInfo(0, nil),         -- The Giant, Elite
    [5361] = MobInfo(10039, "C"),       -- Wave Strider, Elite

    -- Dragonkin
    [12497] = MobInfo(7553, "S"),       -- Dreamroarer, Elite
    [221369] = MobInfo(0, nil),         -- Frenzied Whelp
    [5320] = MobInfo(12509, "S"),       -- Jademir Boughguard, Elite
    [5317] = MobInfo(7974, "S"),        -- Jademir Oracle, Elite
    [5319] = MobInfo(625, "S"),         -- Jademir Tree Warder, Elite
    [5312] = MobInfo(7553, "S"),        -- Lethlas, Elite
    [222968] = MobInfo(0, nil),         -- Lethlas, Elite
    [221361] = MobInfo(0, nil),         -- Mad Sprite
    [5276] = MobInfo(8471, "S"),        -- Sprite Dragon
    [221393] = MobInfo(0, nil),         -- Tyrannikus, Elite
    [221367] = MobInfo(0, nil),         -- Wyrmkin Berserker, Elite
})
