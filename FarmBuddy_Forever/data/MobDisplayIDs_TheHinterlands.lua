-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: The Hinterlands (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=47). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("The Hinterlands", {
    -- Beasts
    [271333] = MobInfo(0, nil),         -- Aerie Gryphon, Elite
    [221333] = MobInfo(0, nil),         -- Doomkin, Rare
    [221312] = MobInfo(0, nil),         -- Dreadfeather Hippogryph
    [221328] = MobInfo(0, nil),         -- Dreamwater Vicejaw
    [221330] = MobInfo(0, nil),         -- Fallen Moonkin
    [7977] = MobInfo(7114, "S"),        -- Gammerita, Elite
    [221334] = MobInfo(0, nil),         -- Ghamoo-Raja, Elite
    [221324] = MobInfo(0, nil),         -- Grief-Crazed Gryphon
    [8213] = MobInfo(7840, "S"),        -- Ironback, Rare
    [2923] = MobInfo(11413, "S"),       -- Mangy Silvermane
    [8211] = MobInfo(11414, "S"),       -- Old Cliff Jumper, Rare
    [2505] = MobInfo(5027, "S"),        -- Saltwater Snapjaw
    [2925] = MobInfo(11417, "S"),       -- Silvermane Howler
    [2926] = MobInfo(11418, "S"),       -- Silvermane Stalker
    [2924] = MobInfo(11419, "S"),       -- Silvermane Wolf
    [2681] = MobInfo(782, "S"),         -- Vilebranch Raiding Wolf, Elite
    [2680] = MobInfo(781, "S"),         -- Vilebranch Wolf Pup

    -- Humanoids
    [10802] = MobInfo(10659, "C"),      -- Hitah'ya the Keeper, Elite
    [262388] = MobInfo(0, nil),         -- Juo
    [8217] = MobInfo(6512, "C"),        -- Mith'rethis the Enchanter, Rare-Elite
    [221933] = MobInfo(0, nil),         -- Moonkin Avatar
    [8636] = MobInfo(7918, "C"),        -- Morta'gya the Keeper, Elite
    [7996] = MobInfo(7122, "C"),        -- Qiaga the Keeper, Elite
    [8216] = MobInfo(6512, "C"),        -- Retherokk the Berserker, Rare
    [7995] = MobInfo(7121, "C"),        -- Vile Priestess Hexx, Elite
    [2648] = MobInfo(6997, "C"),        -- Vilebranch Aman'zasi Guard, Elite
    [7809] = MobInfo(6512, "C"),        -- Vilebranch Ambusher
    [2639] = MobInfo(6491, "C"),        -- Vilebranch Axe Thrower
    [2643] = MobInfo(6493, "C"),        -- Vilebranch Berserker, Elite
    [2646] = MobInfo(6495, "C"),        -- Vilebranch Blood Drinker, Elite
    [2641] = MobInfo(6497, "C"),        -- Vilebranch Headhunter, Elite
    [2644] = MobInfo(6510, "C"),        -- Vilebranch Hideskinner, Elite
    [4466] = MobInfo(6512, "C"),        -- Vilebranch Scalper
    [2645] = MobInfo(6538, "C"),        -- Vilebranch Shadow Hunter, Elite
    [2642] = MobInfo(6514, "C"),        -- Vilebranch Shadowcaster, Elite
    [4467] = MobInfo(6535, "C"),        -- Vilebranch Soothsayer
    [2647] = MobInfo(6540, "C"),        -- Vilebranch Soul Eater, Elite
    [4465] = MobInfo(6508, "C"),        -- Vilebranch Warrior, Elite
    [2640] = MobInfo(6542, "C"),        -- Vilebranch Witch Doctor
    [270772] = MobInfo(0, nil),         -- Witch Doctor Ti'ik
    [2654] = MobInfo(6487, "C"),        -- Witherbark Caller
    [2651] = MobInfo(6483, "C"),        -- Witherbark Hideskinner
    [2653] = MobInfo(6489, "C"),        -- Witherbark Sadist
    [2649] = MobInfo(6479, "C"),        -- Witherbark Scalper
    [2652] = MobInfo(6485, "C"),        -- Witherbark Venomblood
    [2650] = MobInfo(6480, "C"),        -- Witherbark Zealot
    [8218] = MobInfo(6479, "C"),        -- Witherheart the Stalker, Rare
    [8219] = MobInfo(6479, "C"),        -- Zul'arek Hatefowler, Rare

    -- Demons
    [221356] = MobInfo(0, nil),         -- Doomspark Starsworn
    [221357] = MobInfo(0, nil),         -- Stardust Imp
    [221360] = MobInfo(0, nil),         -- Starkiller Hound

    -- Elementals
    [222232] = MobInfo(0, nil),         -- Corrupt Moderate Manifestation of Air

    -- Undead
    [221828] = MobInfo(0, nil),         -- Vengeful Spirit

    -- Dragonkin
    [12496] = MobInfo(7553, "S"),       -- Dreamtracker, Elite
    [221331] = MobInfo(0, nil),         -- Florius, Elite
    [5718] = MobInfo(7553, "S"),        -- Rothos, Elite
    [12477] = MobInfo(12509, "S"),      -- Verdantine Boughguard, Elite
    [12478] = MobInfo(7974, "S"),       -- Verdantine Oracle, Elite
    [12479] = MobInfo(625, "S"),        -- Verdantine Tree Warder, Elite
    [221326] = MobInfo(0, nil),         -- Wrath Whelp
    [221325] = MobInfo(0, nil),         -- Wyrmkin Starhunter, Elite
})
