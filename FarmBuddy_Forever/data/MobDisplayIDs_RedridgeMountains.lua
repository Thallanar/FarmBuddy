-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Redridge Mountains (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=44). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Redridge Mountains", {
    -- Beasts
    [345] = MobInfo(703, "S"),          -- Bellygrub
    [547] = MobInfo(3035, "S"),         -- Great Goretusk
    [14357] = MobInfo(14390, "S"),      -- Lake Thresher, Elite
    [6728] = MobInfo(5448, "S"),        -- Narnie

    -- Humanoids
    [711] = MobInfo(603, "C"),          -- Ardo Dirtpaw
    [435] = MobInfo(6044, "C"),         -- Blackrock Champion
    [4464] = MobInfo(6042, "C"),        -- Blackrock Gladiator, Elite
    [440] = MobInfo(6033, "C"),         -- Blackrock Grunt
    [4462] = MobInfo(6031, "C"),        -- Blackrock Hunter, Elite
    [485] = MobInfo(6034, "C"),         -- Blackrock Outrunner
    [437] = MobInfo(6037, "C"),         -- Blackrock Renegade
    [4064] = MobInfo(6038, "C"),        -- Blackrock Scout, Elite
    [4065] = MobInfo(6029, "C"),        -- Blackrock Sentry, Elite
    [436] = MobInfo(6039, "C"),         -- Blackrock Shadowcaster, Elite
    [4463] = MobInfo(6030, "C"),        -- Blackrock Summoner
    [615] = MobInfo(6040, "C"),         -- Blackrock Tracker
    [214456] = MobInfo(116033, "C"),    -- Dro'zem the Blasphemous, Rare-Elite
    [334] = MobInfo(6050, "C"),         -- Gath'Ilzogg, Elite
    [214519] = MobInfo(116064, "C"),    -- Incinerator Gar'im, Elite
    [584] = MobInfo(6041, "C"),         -- Kazon, Rare
    [703] = MobInfo(492, "C"),          -- Lieutenant Fangore
    [397] = MobInfo(3383, "C"),         -- Morganth, Elite
    [434] = MobInfo(275, "C"),          -- Rabid Shadowhide Gnoll
    [445] = MobInfo(609, "C"),          -- Redridge Alpha
    [446] = MobInfo(609, "C"),          -- Redridge Basher
    [426] = MobInfo(500, "C"),          -- Redridge Brute
    [255769] = MobInfo(255769, "C"),    -- Redridge Brute
    [580] = MobInfo(551, "C"),          -- Redridge Drudger
    [423] = MobInfo(487, "C"),          -- Redridge Mongrel
    [430] = MobInfo(10789, "C"),        -- Redridge Mystic
    [255770] = MobInfo(10789, "C"),     -- Redridge Mystic
    [424] = MobInfo(551, "C"),          -- Redridge Poacher
    [712] = MobInfo(489, "C"),          -- Redridge Thrasher
    [255772] = MobInfo(551, "C"),         -- Redridge Trapper
    [14271] = MobInfo(500, "C"),        -- Ribchaser, Rare
    [947] = MobInfo(10792, "C"),        -- Rohh the Silent, Rare
    [579] = MobInfo(550, "C"),          -- Shadowhide Assassin
    [432] = MobInfo(1887, "C"),         -- Shadowhide Brute
    [429] = MobInfo(491, "C"),          -- Shadowhide Darkweaver
    [433] = MobInfo(275, "C"),          -- Shadowhide Gnoll
    [431] = MobInfo(493, "C"),          -- Shadowhide Slayer
    [568] = MobInfo(662, "C"),          -- Shadowhide Warrior
    [255906] = MobInfo(376, "C"),         -- Snargl, Elite
    [486] = MobInfo(6043, "C"),         -- Tharil'zun, Elite
    [518] = MobInfo(488, "C"),          -- Yowler

    -- Demons
    [819] = MobInfo(3916, "S"),         -- Servant of Ilgalar

    -- Dragonkin
    [441] = MobInfo(387, "S"),          -- Black Dragon Whelp
    [335] = MobInfo(497, "S"),          -- Singe, Elite
    [14272] = MobInfo(497, "S"),        -- Snarlflare, Rare
})
