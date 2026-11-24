-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Eastern Plaguelands (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=139). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Eastern Plaguelands", {
    -- Beasts
    [11896] = MobInfo(11828, "S"),      -- Borelgore, Elite
    [11897] = MobInfo(11829, "S"),      -- Duskwing, Elite
    [272342] = MobInfo(0, nil),         -- Gargantuan Plaguebat
    [8602] = MobInfo(7897, "S"),        -- Monstrous Plaguebat
    [8601] = MobInfo(7896, "S"),        -- Noxious Plaguebat
    [8600] = MobInfo(7894, "S"),        -- Plaguebat
    [16117] = MobInfo(6121, "S"),       -- Plagued Swine
    [240247] = MobInfo(0, nil),         -- Scarlet Bloodhound, Elite

    -- Humanoids
    [12337] = MobInfo(10502, "C"),      -- Crimson Courier, Elite
    [11887] = MobInfo(11831, "C"),      -- Crypt Robber
    [232884] = MobInfo(0, nil),         -- Cult of the Damned Sacrifice
    [8546] = MobInfo(10408, "C"),       -- Dark Adept
    [8551] = MobInfo(10417, "C"),       -- Dark Summoner
    [8547] = MobInfo(10391, "C"),       -- Death Cultist
    [10827] = MobInfo(10432, "C"),      -- Deathspeaker Selendre, Rare
    [12339] = MobInfo(10507, "C"),      -- Demetria, Elite
    [10828] = MobInfo(10431, "C"),      -- High General Abbendis, Rare-Elite
    [243893] = MobInfo(0, nil),         -- High General Abbendis, Rare-Elite
    [8562] = MobInfo(10434, "C"),       -- Mossflayer Cannibal
    [8560] = MobInfo(10442, "C"),       -- Mossflayer Scout
    [8561] = MobInfo(10438, "C"),       -- Mossflayer Shadowhunter
    [8553] = MobInfo(10427, "C"),       -- Necromancer
    [242367] = MobInfo(0, nil),         -- New Avalon Citizen
    [242757] = MobInfo(0, nil),         -- New Avalon Councilman, Elite
    [240246] = MobInfo(0, nil),         -- New Avalon Defender
    [240998] = MobInfo(0, nil),         -- New Avalon Orchardist
    [241119] = MobInfo(0, nil),         -- New Avalon Watchman, Elite
    [241121] = MobInfo(0, nil),         -- Scarlet Archer, Elite
    [9451] = MobInfo(10413, "C"),       -- Scarlet Archmage, Elite
    [9449] = MobInfo(10387, "C"),       -- Scarlet Cleric, Elite
    [241122] = MobInfo(0, nil),         -- Scarlet Confessor, Elite
    [241437] = MobInfo(0, nil),         -- Scarlet Courier
    [9450] = MobInfo(10398, "C"),       -- Scarlet Curate, Elite
    [9452] = MobInfo(10403, "C"),       -- Scarlet Enchanter, Elite
    [241120] = MobInfo(0, nil),         -- Scarlet Footman, Elite
    [9448] = MobInfo(10395, "C"),       -- Scarlet Praetorian, Elite
    [241123] = MobInfo(0, nil),         -- Scarlet Priest, Elite
    [239047] = MobInfo(0, nil),         -- Scarlet Siege Commander, Elite
    [241616] = MobInfo(0, nil),         -- Scarlet Trainee
    [9447] = MobInfo(10376, "C"),       -- Scarlet Warder, Elite
    [8550] = MobInfo(10421, "C"),       -- Shadowmage
    [232903] = MobInfo(0, nil),         -- Shadowmage
    [8548] = MobInfo(10953, "C"),       -- Vile Tutor
    [10822] = MobInfo(10452, "C"),      -- Warlord Thresh'jin, Rare
    [10823] = MobInfo(10443, "C"),      -- Zul'Brin Warpbranch, Rare

    -- Demons
    [232875] = MobInfo(0, nil),         -- Abandoned Voidwalker
    [230146] = MobInfo(0, nil),         -- Fel Interloper
    [8598] = MobInfo(9022, "S"),        -- Frenzied Plaguehound
    [232848] = MobInfo(0, nil),         -- Manathirst Imp
    [8597] = MobInfo(7891, "S"),        -- Plaguehound
    [8596] = MobInfo(7890, "S"),        -- Plaguehound Runt
    [232896] = MobInfo(0, nil),         -- Ravenous Felhound
    [232853] = MobInfo(0, nil),         -- Xirath

    -- Undead
    [8545] = MobInfo(7858, "C"),        -- Abomination
    [8530] = MobInfo(10626, "C"),       -- Cannibal Ghoul
    [8524] = MobInfo(11397, "C"),       -- Cursed Mage
    [232900] = MobInfo(0, nil),         -- Cursed Mage
    [8526] = MobInfo(9788, "C"),        -- Dark Caster
    [8542] = MobInfo(8783, "C"),        -- Death Singer
    [8532] = MobInfo(571, "C"),         -- Diseased Flayer
    [8528] = MobInfo(11396, "C"),       -- Dread Weaver
    [8539] = MobInfo(7857, "C"),        -- Eyeless Watcher
    [10996] = MobInfo(10459, "C"),      -- Fallen Hero, Elite
    [8544] = MobInfo(10613, "C"),       -- Gangled Golem
    [8531] = MobInfo(10487, "C"),       -- Gibbering Ghoul
    [8541] = MobInfo(10751, "C"),       -- Hate Shrieker
    [10821] = MobInfo(10709, "C"),      -- Hed'mush the Rotting, Rare
    [10946] = MobInfo(11730, "C"),      -- Horgus the Ravager, Elite
    [12261] = MobInfo(4769, "C"),       -- Infected Mossflayer
    [12248] = MobInfo(12390, "C"),      -- Infiltrator Hameya
    [10826] = MobInfo(7847, "C"),       -- Lord Darkscythe, Rare
    [11290] = MobInfo(4778, "C"),       -- Mossflayer Zombie
    [8529] = MobInfo(7847, "C"),        -- Scourge Champion
    [8527] = MobInfo(370, "C"),         -- Scourge Guard
    [8523] = MobInfo(5231, "C"),        -- Scourge Soldier
    [8525] = MobInfo(612, "C"),         -- Scourge Warder
    [228620] = MobInfo(0, nil),         -- Slack-Jawed Ghoul
    [12263] = MobInfo(7864, "C"),       -- Slaughterhouse Protector, Elite
    [8543] = MobInfo(1693, "C"),        -- Stitched Horror
    [14564] = MobInfo(10700, "C"),      -- Terrordale Spirit
    [228934] = MobInfo(0, nil),         -- Thane Korth'azz, Boss
    [8540] = MobInfo(984, "C"),         -- Torn Screamer
    [11291] = MobInfo(4769, "C"),       -- Unliving Mossflayer
    [8538] = MobInfo(4629, "C"),        -- Unseen Servant
    [12250] = MobInfo(10275, "C"),      -- Zaeldarr the Outcast
    [12262] = MobInfo(10627, "C"),      -- Ziggurat Protector, Elite
})
