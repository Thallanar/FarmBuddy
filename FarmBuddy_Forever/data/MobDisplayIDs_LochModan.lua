-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Loch Modan (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=38). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Loch Modan", {
    -- Beasts
    [1189] = MobInfo(762, "S"),         -- Black Bear Patriarch
    [270693] = MobInfo(146652, "S"),    -- Daggerfang
    [1186] = MobInfo(707, "S"),         -- Elder Black Bear
    [1192] = MobInfo(1208, "S"),        -- Elder Mountain Boar
    [1188] = MobInfo(762, "S"),         -- Grizzled Black Bear
    [210107] = MobInfo(2996, "S"),      -- Kackle, Rare
    [2476] = MobInfo(831, "S"),         -- Large Loch Crocolisk, Rare
    [1693] = MobInfo(1034, "S"),        -- Loch Crocolisk
    [1193] = MobInfo(1004, "S"),        -- Loch Frenzy
    [1191] = MobInfo(3027, "S"),        -- Mangy Mountain Boar
    [1190] = MobInfo(704, "S"),         -- Mountain Boar
    [1225] = MobInfo(706, "S"),         -- Ol' Sooty, Elite
    [1224] = MobInfo(867, "S"),         -- Young Threshadon

    -- Humanoids
    [1393] = MobInfo(721, "C"),         -- Berserk Trogg
    [1398] = MobInfo(1194, "C"),        -- Boss Galgosh, Rare
    [1207] = MobInfo(721, "C"),         -- Brawler
    [1210] = MobInfo(1054, "C"),        -- Chok'sul, Elite
    [1981] = MobInfo(3452, "C"),        -- Dark Iron Ambusher
    [1169] = MobInfo(3456, "C"),        -- Dark Iron Insurgent
    [2149] = MobInfo(3451, "C"),        -- Dark Iron Raider
    [1222] = MobInfo(870, "C"),         -- Dark Iron Sapper
    [14267] = MobInfo(3189, "C"),       -- Emogg the Crusher, Rare-Elite
    [1206] = MobInfo(721, "C"),         -- Gnasher
    [2477] = MobInfo(3443, "C"),        -- Gradok, Elite
    [1205] = MobInfo(1194, "C"),        -- Grawmug
    [1425] = MobInfo(774, "C"),         -- Grizlak, Rare
    [1399] = MobInfo(160, "C"),         -- Magosh, Rare
    [1180] = MobInfo(14403, "C"),       -- Mo'grosh Brute, Elite
    [1179] = MobInfo(6692, "C"),        -- Mo'grosh Enforcer, Elite
    [1183] = MobInfo(1052, "C"),        -- Mo'grosh Mystic, Elite
    [1178] = MobInfo(1122, "C"),        -- Mo'grosh Ogre, Elite
    [1181] = MobInfo(1045, "C"),        -- Mo'grosh Shaman, Elite
    [1380] = MobInfo(1657, "C"),        -- Saean
    [4846] = MobInfo(6052, "C"),        -- Shadowforge Digger, Elite
    [4844] = MobInfo(6051, "C"),        -- Shadowforge Surveyor, Elite
    [1164] = MobInfo(722, "C"),         -- Stonesplinter Bonesnapper
    [1167] = MobInfo(722, "C"),         -- Stonesplinter Digger
    [1165] = MobInfo(160, "C"),         -- Stonesplinter Geomancer
    [1162] = MobInfo(764, "C"),         -- Stonesplinter Scout
    [1166] = MobInfo(764, "C"),         -- Stonesplinter Seer
    [1197] = MobInfo(763, "C"),         -- Stonesplinter Shaman
    [1163] = MobInfo(160, "C"),         -- Stonesplinter Skullthumper
    [1161] = MobInfo(763, "C"),         -- Stonesplinter Trogg
    [7170] = MobInfo(3443, "C"),        -- Thragomm, Elite
    [1175] = MobInfo(373, "C"),         -- Tunnel Rat Digger
    [1176] = MobInfo(10912, "C"),       -- Tunnel Rat Forager
    [1174] = MobInfo(163, "C"),         -- Tunnel Rat Geomancer
    [1202] = MobInfo(26, "C"),          -- Tunnel Rat Kobold
    [1173] = MobInfo(365, "C"),         -- Tunnel Rat Scout
    [1177] = MobInfo(2299, "C"),        -- Tunnel Rat Surveyor
    [1172] = MobInfo(10913, "C"),       -- Tunnel Rat Vermin
})
