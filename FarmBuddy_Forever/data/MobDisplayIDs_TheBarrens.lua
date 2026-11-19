-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: The Barrens (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=17). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("The Barrens", {
    -- Beasts
    [5834] = MobInfo(2702, "S"),        -- Azzere the Skyblade, Rare
    [3248] = MobInfo(4473, "S"),        -- Barrens Giraffe
    [3236] = MobInfo(1453, "S"),        -- Barrens Kodo
    [5827] = MobInfo(1308, "S"),        -- Brontus, Rare-Elite
    [3231] = MobInfo(1034, "S"),        -- Corrupted Dreadmaw Crocolisk
    [3630] = MobInfo(1742, "S"),        -- Deviate Coiler, Elite
    [3632] = MobInfo(1744, "S"),        -- Deviate Creeper, Elite
    [3641] = MobInfo(1752, "S"),        -- Deviate Lurker, Elite
    [3633] = MobInfo(949, "S"),         -- Deviate Slayer, Elite
    [3634] = MobInfo(1746, "S"),        -- Deviate Stalker, Elite
    [3631] = MobInfo(4091, "S"),        -- Deviate Stinglash, Elite
    [5865] = MobInfo(1043, "S"),        -- Dishu, Rare
    [3110] = MobInfo(1250, "S"),        -- Dreadmaw Crocolisk
    [3475] = MobInfo(1934, "S"),        -- Echeyakee
    [3246] = MobInfo(1284, "S"),        -- Fleeting Plainstrider
    [3235] = MobInfo(1232, "S"),        -- Greater Barrens Kodo
    [3244] = MobInfo(178, "S"),         -- Greater Plainstrider
    [3249] = MobInfo(1974, "S"),        -- Greater Thunderhawk
    [4127] = MobInfo(2710, "S"),        -- Hecklefang Hyena
    [4129] = MobInfo(2711, "S"),        -- Hecklefang Snarler
    [4128] = MobInfo(2712, "S"),        -- Hecklefang Stalker
    [5828] = MobInfo(4424, "SC"),       -- Humar the Pridelord, Rare-Elite
    [3476] = MobInfo(846, "S"),         -- Isha Awak
    [4316] = MobInfo(1535, "S"),        -- Kolkar Packhound
    [3474] = MobInfo(1241, "S"),        -- Lakota'mani
    [3234] = MobInfo(10918, "S"),       -- Lost Barrens Kodo
    [8236] = MobInfo(7449, "S"),        -- Muck Frenzy
    [3461] = MobInfo(6368, "S"),        -- Oasis Snapjaw
    [3245] = MobInfo(6076, "S"),        -- Ornery Plainstrider
    [3473] = MobInfo(10934, "S"),       -- Owatanka
    [3243] = MobInfo(1973, "S"),        -- Savannah Highmane
    [3415] = MobInfo(1056, "S"),        -- Savannah Huntress
    [3416] = MobInfo(1058, "S"),        -- Savannah Matriarch
    [3241] = MobInfo(1977, "S"),        -- Savannah Patriarch
    [3425] = MobInfo(1973, "S"),        -- Savannah Prowler
    [3250] = MobInfo(2730, "S"),        -- Silithid Creeper
    [3251] = MobInfo(7572, "S"),        -- Silithid Grub
    [3252] = MobInfo(2731, "S"),        -- Silithid Swarmer
    [5829] = MobInfo(2713, "S"),        -- Snort the Heckler, Rare
    [3238] = MobInfo(1539, "S"),        -- Stormhide
    [3240] = MobInfo(1537, "S"),        -- Stormsnout
    [3254] = MobInfo(1744, "S"),        -- Sunscale Lashtail
    [3255] = MobInfo(1747, "S"),        -- Sunscale Screecher
    [3256] = MobInfo(4442, "S"),        -- Sunscale Scytheclaw
    [5831] = MobInfo(6084, "S"),        -- Swiftmane, Rare-Elite
    [5842] = MobInfo(1337, "S"),        -- Takk the Leaper, Rare-Elite
    [3424] = MobInfo(1975, "S"),        -- Thunderhawk Cloudscraper
    [3247] = MobInfo(1742, "S"),        -- Thunderhawk Hatchling
    [3239] = MobInfo(1538, "S"),        -- Thunderhead
    [5832] = MobInfo(6085, "S"),        -- Thunderstomp, Rare
    [3463] = MobInfo(2193, "S"),        -- Wandering Barrens Giraffe
    [3472] = MobInfo(2699, "S"),        -- Washte Pawne
    [3237] = MobInfo(10914, "S"),       -- Wooly Kodo
    [3426] = MobInfo(2187, "S"),        -- Zhevra Charger
    [3466] = MobInfo(6086, "S"),        -- Zhevra Courser
    [3242] = MobInfo(6087, "S"),        -- Zhevra Runner

    -- Humanoids
    [10896] = MobInfo(10243, "C"),      -- Arnak Grimtotem
    [3394] = MobInfo(4874, "C"),        -- Barak Kodobane
    [3467] = MobInfo(797, "C"),         -- Baron Longshore
    [9336] = MobInfo(8569, "C"),        -- Boss Copperplug
    [3263] = MobInfo(6091, "C"),        -- Bristleback Geomancer
    [3258] = MobInfo(4745, "C"),        -- Bristleback Hunter
    [3261] = MobInfo(6077, "C"),        -- Bristleback Thornweaver
    [3260] = MobInfo(1274, "C"),        -- Bristleback Water Seeker
    [5838] = MobInfo(9448, "C"),        -- Brokespear, Rare
    [3380] = MobInfo(4196, "C"),        -- Burning Blade Acolyte
    [3379] = MobInfo(4198, "C"),        -- Burning Blade Bruiser
    [12320] = MobInfo(4198, "C"),       -- Burning Blade Crusher
    [12319] = MobInfo(4196, "C"),       -- Burning Blade Toxicologist
    [3454] = MobInfo(1863, "C"),        -- Cannoneer Smythe
    [3455] = MobInfo(1864, "C"),        -- Cannoneer Whessan
    [3393] = MobInfo(1855, "C"),        -- Captain Fairmount
    [5851] = MobInfo(4598, "C"),        -- Captain Gerogg Hammertoe, Rare-Elite
    [267307] = MobInfo(145023, "C"),    -- Chol'aruk, Elite
    [262119] = MobInfo(143070, "C"),    -- Corporal Adamore
    [7872] = MobInfo(6098, "C"),        -- Death's Head Cultist, Elite
    [5849] = MobInfo(4596, "C"),        -- Digger Flameforge, Rare
    [3270] = MobInfo(6095, "C"),        -- Elder Mystic Razorsnout, Rare-Elite
    [5836] = MobInfo(7049, "C"),        -- Engineer Whirleygig, Rare
    [5835] = MobInfo(4593, "C"),        -- Foreman Grills, Rare
    [5863] = MobInfo(6116, "C"),        -- Geopriest Gukk'rok, Rare
    [5859] = MobInfo(6114, "C"),        -- Hagg Taurenbane, Rare-Elite
    [3396] = MobInfo(9448, "C"),        -- Hezrul Bloodmark
    [3397] = MobInfo(9447, "C"),        -- Kolkar Bloodcharger
    [9524] = MobInfo(1349, "C"),        -- Kolkar Invader
    [3275] = MobInfo(4874, "C"),        -- Kolkar Marauder
    [3274] = MobInfo(9445, "C"),        -- Kolkar Pack Runner
    [3273] = MobInfo(9443, "C"),        -- Kolkar Stormer
    [9523] = MobInfo(4871, "C"),        -- Kolkar Stormseer
    [3272] = MobInfo(9442, "C"),        -- Kolkar Wrangler
    [3438] = MobInfo(6115, "C"),        -- Kreenig Snarlsnout
    [3436] = MobInfo(6093, "C"),        -- Kuz
    [3435] = MobInfo(6104, "C"),        -- Lok Orcbane
    [6668] = MobInfo(5385, "C"),        -- Lord Cyrik Blackforge
    [3655] = MobInfo(7221, "C"),        -- Mad Magglish, Elite
    [5848] = MobInfo(4597, "C"),        -- Malgin Barleybrew, Rare
    [3434] = MobInfo(6105, "C"),        -- Nak
    [6606] = MobInfo(7047, "C"),        -- Overseer Glibby
    [3392] = MobInfo(1400, "C"),        -- Prospector Khazgorm
    [7873] = MobInfo(6108, "C"),        -- Razorfen Battleguard, Elite
    [6132] = MobInfo(1343, "C"),        -- Razorfen Servitor, Elite
    [7874] = MobInfo(1963, "C"),        -- Razorfen Thornweaver, Elite
    [267314] = MobInfo(4751, "C"),         -- Razormane Berserker, Elite
    [3266] = MobInfo(1253, "C"),        -- Razormane Defender
    [267308] = MobInfo(6096, "C"),         -- Razormane Flesheater, Elite
    [3269] = MobInfo(6093, "C"),        -- Razormane Geomancer
    [3265] = MobInfo(6094, "C"),        -- Razormane Hunter
    [3271] = MobInfo(4643, "C"),        -- Razormane Mystic
    [3456] = MobInfo(1964, "C"),        -- Razormane Pathfinder
    [268624] = MobInfo(1253, "C"),         -- Razormane Raider
    [3458] = MobInfo(6095, "C"),        -- Razormane Seer
    [3457] = MobInfo(1253, "C"),        -- Razormane Stalker
    [3268] = MobInfo(6096, "C"),        -- Razormane Thornweaver
    [3459] = MobInfo(4751, "C"),        -- Razormane Warfrenzy
    [3267] = MobInfo(1964, "C"),        -- Razormane Water Seeker
    [3452] = MobInfo(2295, "C"),        -- Serena Bloodfeather
    [5830] = MobInfo(10876, "C"),       -- Sister Rathtalon, Rare-Elite
    [3381] = MobInfo(3829, "C"),        -- Southsea Brigand
    [3382] = MobInfo(3827, "C"),        -- Southsea Cannoneer
    [3383] = MobInfo(3835, "C"),        -- Southsea Cutthroat
    [3384] = MobInfo(3833, "C"),        -- Southsea Privateer
    [5837] = MobInfo(4874, "C"),        -- Stonearm, Rare
    [3445] = MobInfo(7035, "C"),        -- Supervisor Lugwizzle
    [5864] = MobInfo(6117, "C"),        -- Swinegart Spearhide, Rare-Elite
    [6494] = MobInfo(5236, "C"),        -- Tazan
    [3471] = MobInfo(7048, "C"),        -- Tinkerer Sniggles
    [3284] = MobInfo(3918, "C"),        -- Venture Co. Drudger
    [3283] = MobInfo(7234, "C"),        -- Venture Co. Enforcer
    [3282] = MobInfo(7237, "C"),        -- Venture Co. Mercenary
    [3286] = MobInfo(7238, "C"),        -- Venture Co. Overseer
    [3285] = MobInfo(7241, "C"),        -- Venture Co. Peon
    [3395] = MobInfo(9446, "C"),        -- Verog the Dervish
    [9456] = MobInfo(4874, "C"),        -- Warlord Krom'zar, Elite
    [3279] = MobInfo(2143, "C"),        -- Witchwing Ambusher
    [3276] = MobInfo(3218, "C"),        -- Witchwing Harpy
    [3277] = MobInfo(2162, "C"),        -- Witchwing Roguefeather
    [3278] = MobInfo(2163, "C"),        -- Witchwing Slayer
    [3280] = MobInfo(1350, "C"),        -- Witchwing Windcaller

    -- Demons
    [3470] = MobInfo(5047, "C"),        -- Rathorian, Rare

    -- Undead
    [7895] = MobInfo(7043, "C"),        -- Ambassador Bloodrage, Rare-Elite
    [12865] = MobInfo(12909, "C"),      -- Ambassador Malcin, Elite
})
