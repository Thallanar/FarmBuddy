-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Dun Morogh (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=1). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Dun Morogh", {
    -- Beasts
    [1130] = MobInfo(913, "S"),         -- Bjarn, Rare
    [1125] = MobInfo(138623, "S"),      -- Crag Boar
    [1127] = MobInfo(744, "S"),         -- Elder Crag Boar
    [260157] = MobInfo(749, "S"),       -- Elder Snow Leopard
    [276111] = MobInfo(9949, "S"),      -- Ghostfang, Rare
    [1196] = MobInfo(8840, "S"),        -- Ice Claw Bear
    [1199] = MobInfo(748, "S"),         -- Juvenile Snow Leopard
    [1126] = MobInfo(381, "S"),         -- Large Crag Boar
    [1961] = MobInfo(913, "S"),         -- Mangeclaw
    [1689] = MobInfo(193, "S"),         -- Scarred Crag Boar
    [708] = MobInfo(607, "S"),          -- Small Crag Boar
    [1201] = MobInfo(954, "S"),         -- Snow Leopard
    [269075] = MobInfo(749, "S"),       -- Snow Leopard Prowler
    [1138] = MobInfo(138625, "S"),      -- Snow Tracker Wolf
    [1133] = MobInfo(11416, "S"),       -- Starving Winter Wolf
    [1132] = MobInfo(11422, "S"),       -- Timber, Rare
    [1131] = MobInfo(785, "S"),         -- Winter Wolf
    [1128] = MobInfo(8843, "S"),        -- Young Black Bear

    -- Humanoids
    [6221] = MobInfo(6920, "C"),        -- Addled Leper
    [6124] = MobInfo(4957, "C"),        -- Captain Beld
    [6123] = MobInfo(4956, "C"),        -- Dark Iron Spy
    [1137] = MobInfo(931, "S"),         -- Edan the Howler, Rare
    [271530] = MobInfo(931, "S"),       -- Elder Wendigo
    [271587] = MobInfo(6767, "S"),      -- Frosthowl
    [1123] = MobInfo(5626, "C"),        -- Frostmane Headhunter
    [1122] = MobInfo(5612, "C"),        -- Frostmane Hideskinner
    [1397] = MobInfo(5610, "C"),        -- Frostmane Seer
    [1124] = MobInfo(5613, "C"),        -- Frostmane Shadowcaster
    [1121] = MobInfo(5607, "C"),        -- Frostmane Snowstrider
    [1120] = MobInfo(5608, "C"),        -- Frostmane Troll
    [8503] = MobInfo(7807, "C"),        -- Gibblewilt, Rare
    [1260] = MobInfo(5625, "C"),        -- Great Father Arctikus, Rare
    [1119] = MobInfo(830, "C"),         -- Hammerspine, Rare
    [1211] = MobInfo(6921, "C"),        -- Leper Gnome
    [1271] = MobInfo(1050, "S"),        -- Old Icebeard, Elite
    [1116] = MobInfo(726, "C"),         -- Rockjaw Ambusher
    [1118] = MobInfo(723, "C"),         -- Rockjaw Backbreaker
    [1117] = MobInfo(726, "C"),         -- Rockjaw Bonesnapper
    [1115] = MobInfo(726, "C"),         -- Rockjaw Skullthumper
    [1388] = MobInfo(1050, "S"),        -- Vagash, Elite
    [6113] = MobInfo(5611, "C"),        -- Vejrek
    [1135] = MobInfo(950, "S"),         -- Wendigo
    [271486] = MobInfo(146686, "S"),    -- Wendigo Shaman
    [1134] = MobInfo(929, "S"),         -- Young Wendigo
})
