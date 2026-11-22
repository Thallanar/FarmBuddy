-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Stranglethorn Vale (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=33). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Stranglethorn Vale", {
    -- Beasts
    [728] = MobInfo(613, "S"),          -- Bhag'thera, Elite
    [698] = MobInfo(320, "S"),          -- Bloodscalp Tiger
    [690] = MobInfo(8797, "S"),         -- Cold Eye Basilisk
    [689] = MobInfo(601, "S"),          -- Crystal Spine Basilisk
    [1557] = MobInfo(838, "S"),         -- Elder Mistvale Gorilla
    [2635] = MobInfo(1038, "S"),        -- Elder Saltwater Crocolisk, Elite
    [1713] = MobInfo(11452, "S"),       -- Elder Shadowmaw Panther
    [1085] = MobInfo(698, "S"),         -- Elder Stranglethorn Tiger
    [1551] = MobInfo(2174, "S"),        -- Ironjaw Basilisk
    [2522] = MobInfo(613, "S"),         -- Jaguero Stalker
    [687] = MobInfo(11317, "S"),        -- Jungle Stalker
    [1114] = MobInfo(845, "S"),         -- Jungle Thunderer
    [731] = MobInfo(616, "S"),          -- King Bangalash, Elite
    [1559] = MobInfo(792, "S"),         -- King Mukla, Elite
    [14491] = MobInfo(3186, "S"),       -- Kurmokk, Rare
    [977] = MobInfo(599, "S"),          -- Kurzen War Panther
    [976] = MobInfo(320, "S"),          -- Kurzen War Tiger
    [686] = MobInfo(788, "S"),          -- Lashtail Raptor
    [1108] = MobInfo(843, "S"),         -- Mistvale Gorilla
    [736] = MobInfo(599, "S"),          -- Panther
    [14490] = MobInfo(14528, "S"),      -- Rippa, Rare
    [1150] = MobInfo(1039, "S"),        -- River Crocolisk
    [1151] = MobInfo(2548, "S"),        -- Saltwater Crocolisk
    [1552] = MobInfo(12342, "S"),       -- Scale Belly, Rare
    [684] = MobInfo(633, "S"),          -- Shadowmaw Panther
    [905] = MobInfo(705, "S"),          -- Sharptooth Frenzy
    [1558] = MobInfo(844, "S"),         -- Silverback Patriarch
    [729] = MobInfo(471, "S"),          -- Sin'Dall
    [756] = MobInfo(633, "S"),          -- Skullsplitter Panther
    [2521] = MobInfo(809, "S"),         -- Skymane Gorilla
    [1152] = MobInfo(833, "S"),         -- Snapjaw Crocolisk
    [688] = MobInfo(12344, "S"),        -- Stone Maw Basilisk
    [685] = MobInfo(788, "S"),          -- Stranglethorn Raptor
    [682] = MobInfo(320, "S"),          -- Stranglethorn Tiger
    [772] = MobInfo(614, "S"),          -- Stranglethorn Tigress
    [730] = MobInfo(8472, "S"),         -- Tethis, Elite
    [1550] = MobInfo(8802, "S"),        -- Thrashtail Basilisk
    [854] = MobInfo(615, "S"),          -- Young Jungle Stalker
    [856] = MobInfo(2571, "S"),         -- Young Lashtail Raptor
    [683] = MobInfo(2437, "S"),         -- Young Panther
    [855] = MobInfo(180, "S"),          -- Young Stranglethorn Raptor
    [681] = MobInfo(138617, "S"),       -- Young Stranglethorn Tiger

    -- Humanoids
    [2545] = MobInfo(4641, "C"),        -- "Pretty Boy" Duncan
    [1059] = MobInfo(4634, "C"),        -- Ana'thek the Cruel
    [4505] = MobInfo(2557, "C"),        -- Bloodsail Deckhand
    [1653] = MobInfo(2563, "C"),        -- Bloodsail Elder Magus
    [1562] = MobInfo(2561, "C"),        -- Bloodsail Mage
    [1561] = MobInfo(793, "C"),         -- Bloodsail Raider
    [1565] = MobInfo(796, "C"),         -- Bloodsail Sea Dog
    [4506] = MobInfo(1902, "C"),        -- Bloodsail Swabby
    [1563] = MobInfo(796, "C"),         -- Bloodsail Swashbuckler
    [1564] = MobInfo(4461, "C"),        -- Bloodsail Warlock
    [694] = MobInfo(4572, "C"),         -- Bloodscalp Axe Thrower
    [699] = MobInfo(4576, "C"),         -- Bloodscalp Beastmaster
    [597] = MobInfo(4579, "C"),         -- Bloodscalp Berserker
    [671] = MobInfo(4580, "C"),         -- Bloodscalp Headhunter
    [595] = MobInfo(4574, "C"),         -- Bloodscalp Hunter
    [701] = MobInfo(4577, "C"),         -- Bloodscalp Mystic
    [702] = MobInfo(4571, "C"),         -- Bloodscalp Scavenger
    [588] = MobInfo(4575, "C"),         -- Bloodscalp Scout
    [697] = MobInfo(4573, "C"),         -- Bloodscalp Shaman
    [587] = MobInfo(4570, "C"),         -- Bloodscalp Warrior
    [660] = MobInfo(4581, "C"),         -- Bloodscalp Witch Doctor
    [815] = MobInfo(4451, "C"),         -- Bookie Herod
    [2548] = MobInfo(7208, "C"),        -- Captain Keelhaul
    [2550] = MobInfo(4873, "C"),        -- Captain Stillwater
    [813] = MobInfo(637, "C"),          -- Colonel Kurzen, Elite
    [2546] = MobInfo(797, "C"),         -- Fleet Master Firallon
    [4723] = MobInfo(7207, "C"),        -- Foreman Cozzle
    [1061] = MobInfo(4582, "C"),        -- Gan'zulah
    [2549] = MobInfo(4648, "C"),        -- Garr Salthoof
    [11355] = MobInfo(11167, "C"),      -- Gurubashi Warrior, Elite
    [11346] = MobInfo(11158, "C"),      -- Hakkari Oracle, Elite
    [11383] = MobInfo(11295, "C"),      -- High Priestess Hai'watna, Rare-Elite
    [2547] = MobInfo(4657, "C"),        -- Ironpatch
    [938] = MobInfo(4439, "C"),         -- Kurzen Commando
    [939] = MobInfo(4446, "C"),         -- Kurzen Elite
    [941] = MobInfo(4444, "C"),         -- Kurzen Headshrinker
    [937] = MobInfo(4443, "C"),         -- Kurzen Jungle Fighter
    [940] = MobInfo(4436, "C"),         -- Kurzen Medicine Man
    [979] = MobInfo(4454, "C"),         -- Kurzen Shadow Hunter
    [978] = MobInfo(4459, "C"),         -- Kurzen Subchief
    [942] = MobInfo(4450, "C"),         -- Kurzen Witch Doctor
    [943] = MobInfo(4438, "C"),         -- Kurzen Wrangler
    [775] = MobInfo(4460, "C"),         -- Kurzen's Agent
    [818] = MobInfo(11546, "C"),        -- Mai'Zoth, Elite
    [1060] = MobInfo(4633, "C"),        -- Mogh the Undying, Elite
    [1142] = MobInfo(11567, "C"),       -- Mosh'Ogg Brute
    [723] = MobInfo(11568, "C"),        -- Mosh'Ogg Butcher, Rare-Elite
    [680] = MobInfo(11569, "C"),        -- Mosh'Ogg Lord, Elite
    [678] = MobInfo(416, "C"),          -- Mosh'Ogg Mauler, Elite
    [679] = MobInfo(536, "C"),          -- Mosh'Ogg Shaman, Elite
    [710] = MobInfo(6704, "C"),         -- Mosh'Ogg Spellcrafter, Elite
    [709] = MobInfo(655, "C"),          -- Mosh'Ogg Warmonger, Elite
    [1144] = MobInfo(610, "C"),         -- Mosh'Ogg Witch Doctor
    [1062] = MobInfo(4584, "C"),        -- Nezzliok the Dire
    [14488] = MobInfo(5782, "C"),       -- Roloch, Rare
    [9046] = MobInfo(8900, "C"),        -- Scarshield Quartermaster, Rare-Elite
    [814] = MobInfo(4455, "C"),         -- Sergeant Malthus
    [696] = MobInfo(4622, "C"),         -- Skullsplitter Axe Thrower
    [784] = MobInfo(4624, "C"),         -- Skullsplitter Beastmaster
    [783] = MobInfo(4623, "C"),         -- Skullsplitter Berserker
    [781] = MobInfo(4635, "C"),         -- Skullsplitter Headhunter
    [669] = MobInfo(4628, "C"),         -- Skullsplitter Hunter
    [780] = MobInfo(4616, "C"),         -- Skullsplitter Mystic
    [782] = MobInfo(4625, "C"),         -- Skullsplitter Scout
    [672] = MobInfo(4621, "C"),         -- Skullsplitter Spiritchaser
    [667] = MobInfo(4632, "C"),         -- Skullsplitter Warrior
    [670] = MobInfo(4627, "C"),         -- Skullsplitter Witch Doctor
    [260429] = MobInfo(7237, "C"),      -- Venture Co. Agent
    [675] = MobInfo(7196, "C"),         -- Venture Co. Foreman
    [1096] = MobInfo(7197, "C"),        -- Venture Co. Geologist
    [921] = MobInfo(7198, "C"),         -- Venture Co. Lumberjack
    [1097] = MobInfo(7200, "C"),        -- Venture Co. Mechanic
    [1094] = MobInfo(7201, "C"),        -- Venture Co. Miner
    [674] = MobInfo(7202, "C"),         -- Venture Co. Strip Miner
    [676] = MobInfo(7203, "C"),         -- Venture Co. Surveyor
    [677] = MobInfo(7204, "C"),         -- Venture Co. Tinkerer
    [1095] = MobInfo(7205, "C"),        -- Venture Co. Workboss
    [14492] = MobInfo(7232, "C"),       -- Verifonix, Rare
    [2530] = MobInfo(4663, "C"),        -- Yenniku
    [1490] = MobInfo(317, "C"),         -- Zanzil Witch Doctor
    [2534] = MobInfo(314, "C"),         -- Zanzil the Outcast
    [300] = MobInfo(655, "C"),          -- Zzarc' Vul

    -- Giants
    [1492] = MobInfo(10039, "C"),       -- Gorlash, Elite
    [1493] = MobInfo(12812, "C"),       -- Mok'rash, Elite
    [1494] = MobInfo(4945, "C"),        -- Negolash, Elite

    -- Undead
    [2537] = MobInfo(987, "C"),         -- Chucky "Ten Thumbs"
    [2536] = MobInfo(987, "C"),         -- Jon-Jon the Crow
    [2535] = MobInfo(987, "C"),         -- Maury "Club Foot" Wilkins
    [1489] = MobInfo(828, "C"),         -- Zanzil Hunter
    [1488] = MobInfo(1065, "C"),        -- Zanzil Zombie

    -- Mechanicals
    [4260] = MobInfo(1269, "C"),        -- Venture Co. Shredder
})
