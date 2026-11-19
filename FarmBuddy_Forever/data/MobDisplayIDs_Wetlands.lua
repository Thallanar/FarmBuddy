-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Wetlands (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=11). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Wetlands", {
    -- Beasts
    [271336] = MobInfo(143340, "S"),    -- Carnage, Elite
    [1019] = MobInfo(788, "S"),         -- Elder Razormaw
    [2089] = MobInfo(925, "S"),         -- Giant Wetlands Crocolisk
    [1016] = MobInfo(673, "S"),         -- Highland Lashtail
    [1015] = MobInfo(670, "S"),         -- Highland Raptor
    [1018] = MobInfo(180, "S"),         -- Highland Razormaw
    [1017] = MobInfo(649, "S"),         -- Highland Scytheclaw
    [260809] = MobInfo(4829, "S"),         -- Highland Tortoise
    [271334] = MobInfo(140708, "S"),    -- Maddened Rotclaw
    [1020] = MobInfo(960, "S"),         -- Mottled Raptor
    [1023] = MobInfo(949, "S"),         -- Mottled Razormaw
    [1021] = MobInfo(677, "S"),         -- Mottled Screecher
    [1022] = MobInfo(648, "S"),         -- Mottled Scytheclaw
    [1140] = MobInfo(11316, "S"),       -- Razormaw Matriarch, Rare
    [1353] = MobInfo(755, "S"),         -- Sarltooth
    [1400] = MobInfo(1036, "S"),        -- Wetlands Crocolisk
    [1417] = MobInfo(1035, "S"),        -- Young Wetlands Crocolisk

    -- Humanoids
    [1364] = MobInfo(1398, "C"),        -- Balgaras the Foul, Elite
    [2091] = MobInfo(4915, "C"),        -- Chieftain Nek'rosh, Elite
    [4062] = MobInfo(3954, "C"),        -- Dark Iron Bombardier
    [1054] = MobInfo(3487, "C"),        -- Dark Iron Demolitionist, Elite
    [1051] = MobInfo(825, "C"),         -- Dark Iron Dwarf, Elite
    [1169] = MobInfo(3456, "C"),        -- Dark Iron Insurgent
    [6523] = MobInfo(825, "C"),         -- Dark Iron Rifleman, Elite
    [1052] = MobInfo(3490, "C"),        -- Dark Iron Saboteur, Elite
    [2575] = MobInfo(3969, "C"),        -- Dark Iron Supplier
    [1053] = MobInfo(3488, "C"),        -- Dark Iron Tunneler, Elite
    [1037] = MobInfo(4912, "C"),        -- Dragonmaw Battlemaster, Rare
    [1057] = MobInfo(4918, "C"),        -- Dragonmaw Bonewarder
    [1036] = MobInfo(4919, "C"),        -- Dragonmaw Centurion
    [2102] = MobInfo(4927, "C"),        -- Dragonmaw Grunt
    [271346] = MobInfo(146631, "C"),    -- Dragonmaw Infiltrator, Elite
    [1034] = MobInfo(4916, "C"),        -- Dragonmaw Raider
    [271351] = MobInfo(146635, "C"),    -- Dragonmaw Reclaimer, Elite
    [2103] = MobInfo(4925, "C"),        -- Dragonmaw Scout
    [1038] = MobInfo(4924, "C"),        -- Dragonmaw Shadowwarder
    [271348] = MobInfo(146634, "C"),    -- Dragonmaw Soulbinder, Elite
    [1035] = MobInfo(4917, "C"),        -- Dragonmaw Swamprunner
    [2108] = MobInfo(4913, "C"),        -- Garneg Charskull, Rare
    [14425] = MobInfo(543, "C"),        -- Gnawbone, Rare
    [2090] = MobInfo(4914, "C"),        -- Ma'ruk Wyrmscale, Rare
    [1014] = MobInfo(543, "C"),         -- Mosshide Alpha
    [1012] = MobInfo(3196, "C"),        -- Mosshide Brute
    [1010] = MobInfo(714, "C"),         -- Mosshide Fenrunner
    [1007] = MobInfo(3199, "C"),        -- Mosshide Gnoll
    [1009] = MobInfo(3197, "C"),        -- Mosshide Mistweaver
    [1008] = MobInfo(355, "C"),         -- Mosshide Mongrel
    [1013] = MobInfo(714, "C"),         -- Mosshide Mystic
    [1011] = MobInfo(8598, "C"),        -- Mosshide Trapper

    -- Undead
    [1160] = MobInfo(3494, "C"),        -- Captain Halyndor
    [1158] = MobInfo(11372, "C"),       -- Cursed Marine
    [1157] = MobInfo(3505, "C"),        -- Cursed Sailor
    [1159] = MobInfo(3512, "C"),        -- First Mate Snellig

    -- Dragonkin
    [12899] = MobInfo(12821, "S"),      -- Axtroz, Elite
    [1069] = MobInfo(505, "S"),         -- Crimson Whelp
    [1044] = MobInfo(8712, "S"),        -- Flamesnorting Whelp
    [1043] = MobInfo(956, "S"),         -- Lost Whelp
    [1045] = MobInfo(363, "S"),         -- Red Dragonspawn, Elite
    [1047] = MobInfo(8313, "S"),        -- Red Scalebane, Elite
    [1042] = MobInfo(9583, "S"),        -- Red Whelp
    [1046] = MobInfo(8312, "S"),        -- Red Wyrmkin, Elite
    [1048] = MobInfo(716, "S"),         -- Scalebane Lieutenant, Elite
    [1050] = MobInfo(8315, "S"),        -- Scalebane Royal Guard, Elite
    [271373] = MobInfo(363, "S"),       -- Subdued Dragonspawn, Elite
    [1049] = MobInfo(8314, "S"),        -- Wyrmkin Firebrand, Elite
})
