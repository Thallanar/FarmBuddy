-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Badlands (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=3). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Badlands", {
    -- Beasts
    [2753] = MobInfo(9372, "S"),        -- Barnabus, Rare
    [2850] = MobInfo(6082, "SC"),       -- Broken Tooth, Rare
    [2727] = MobInfo(161, "S"),         -- Crag Coyote
    [2729] = MobInfo(1164, "S"),        -- Elder Crag Coyote
    [2728] = MobInfo(557, "S"),         -- Feral Crag Coyote
    [2831] = MobInfo(1106, "S"),        -- Giant Buzzard
    [2730] = MobInfo(161, "S"),         -- Rabid Crag Coyote
    [2732] = MobInfo(1055, "S"),        -- Ridge Huntress
    [2731] = MobInfo(632, "S"),         -- Ridge Stalker
    [2734] = MobInfo(917, "S"),         -- Ridge Stalker Patriarch

    -- Humanoids
    [2944] = MobInfo(10170, "C"),       -- Boss Tho'grun
    [7057] = MobInfo(7220, "C"),        -- Digmaster Shovelphlange, Rare-Elite
    [2715] = MobInfo(10714, "C"),       -- Dustbelcher Brute
    [2719] = MobInfo(1120, "C"),        -- Dustbelcher Lord
    [2717] = MobInfo(1120, "C"),        -- Dustbelcher Mauler
    [2907] = MobInfo(1122, "C"),        -- Dustbelcher Mystic
    [2701] = MobInfo(10704, "C"),       -- Dustbelcher Ogre
    [2720] = MobInfo(11546, "C"),       -- Dustbelcher Ogre Mage
    [2718] = MobInfo(11545, "C"),       -- Dustbelcher Shaman
    [2906] = MobInfo(5782, "C"),        -- Dustbelcher Warrior
    [2716] = MobInfo(11548, "C"),       -- Dustbelcher Wyrmhunter
    [2932] = MobInfo(4938, "C"),        -- Magregan Deepshadow, Elite
    [2945] = MobInfo(1194, "C"),        -- Murdaloc
    [2742] = MobInfo(4935, "C"),        -- Shadowforge Chanter
    [2744] = MobInfo(4937, "C"),        -- Shadowforge Commander, Rare
    [2740] = MobInfo(4933, "C"),        -- Shadowforge Darkweaver
    [4846] = MobInfo(6052, "C"),        -- Shadowforge Digger, Elite
    [4845] = MobInfo(6053, "C"),        -- Shadowforge Ruffian, Elite
    [4844] = MobInfo(6051, "C"),        -- Shadowforge Surveyor, Elite
    [2739] = MobInfo(4932, "C"),        -- Shadowforge Tunneler
    [2743] = MobInfo(4936, "C"),        -- Shadowforge Warrior
    [6733] = MobInfo(721, "C"),         -- Stonevault Basher, Elite
    [2893] = MobInfo(1194, "C"),        -- Stonevault Bonesnapper
    [4856] = MobInfo(722, "C"),         -- Stonevault Cave Hunter, Elite
    [4851] = MobInfo(721, "C"),         -- Stonevault Rockchewer, Elite
    [2892] = MobInfo(722, "C"),         -- Stonevault Seer, Elite
    [2894] = MobInfo(721, "C"),         -- Stonevault Shaman

    -- Dragonkin
    [2725] = MobInfo(715, "S"),         -- Scalding Whelp
    [2726] = MobInfo(9586, "S"),        -- Scorched Guardian, Elite

    -- Mechanicals
    [14224] = MobInfo(6889, "C"),       -- 7:XT, Rare
})
