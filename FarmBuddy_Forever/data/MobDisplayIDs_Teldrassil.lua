-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Teldrassil (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=141). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Teldrassil", {
    -- Beasts
    [14430] = MobInfo(11453, "S"),      -- Duskstalker, Rare
    [2033] = MobInfo(3030, "S"),        -- Elder Nightsaber
    [2034] = MobInfo(3030, "S"),        -- Feral Nightsaber
    [2032] = MobInfo(11448, "S"),       -- Mangy Nightsaber
    [2042] = MobInfo(6805, "S"),        -- Nightsaber
    [2043] = MobInfo(14318, "S"),       -- Nightsaber Stalker
    [1985] = MobInfo(6807, "S"),        -- Thistle Boar
    [1984] = MobInfo(8869, "S"),        -- Young Thistle Boar

    -- Humanoids
    [2162] = MobInfo(936, "C"),         -- Agal
    [2019] = MobInfo(3022, "C"),        -- Bloodfeather Fury
    [2015] = MobInfo(3021, "C"),        -- Bloodfeather Harpy
    [2021] = MobInfo(6813, "C"),        -- Bloodfeather Matriarch
    [2017] = MobInfo(6812, "C"),        -- Bloodfeather Rogue
    [2018] = MobInfo(2296, "C"),        -- Bloodfeather Sorceress
    [2020] = MobInfo(10869, "C"),       -- Bloodfeather Wind Witch
    [7234] = MobInfo(1996, "C"),        -- Ferocitas the Dream Eater
    [14431] = MobInfo(2296, "C"),       -- Fury Shelda, Rare
    [2152] = MobInfo(3024, "C"),        -- Gnarlpine Ambusher
    [2011] = MobInfo(3024, "C"),        -- Gnarlpine Augur
    [2013] = MobInfo(6803, "C"),        -- Gnarlpine Avenger
    [2010] = MobInfo(6801, "C"),        -- Gnarlpine Defender
    [2007] = MobInfo(6799, "C"),        -- Gnarlpine Gardener
    [7235] = MobInfo(6804, "C"),        -- Gnarlpine Mystic
    [2012] = MobInfo(6802, "C"),        -- Gnarlpine Pathfinder
    [2009] = MobInfo(897, "C"),         -- Gnarlpine Shaman
    [2014] = MobInfo(936, "C"),         -- Gnarlpine Totemic
    [2006] = MobInfo(6798, "C"),        -- Gnarlpine Ursa
    [2008] = MobInfo(6800, "C"),        -- Gnarlpine Warrior
    [1993] = MobInfo(6819, "C"),        -- Greenpaw
    [14429] = MobInfo(1011, "C"),       -- Grimmaw, Rare
    [272034] = MobInfo(969, "C"),         -- Hatescreech
    [6911] = MobInfo(2013, "C"),        -- Minion of Sethir
    [7318] = MobInfo(6231, "C"),        -- Rageclaw
    [2039] = MobInfo(6818, "C"),        -- Ursal the Mauler
    [14428] = MobInfo(6818, "C"),       -- Uruson, Rare
    [272044] = MobInfo(1255, "C"),         -- Windmistress Gaedress
    [272046] = MobInfo(2143, "C"),         -- Witchmother Arysa

    -- Demons
    [2004] = MobInfo(568, "C"),         -- Dark Sprite
    [2038] = MobInfo(1013, "C"),        -- Lord Melenas
    [2002] = MobInfo(3023, "C"),        -- Rascal Sprite
    [6909] = MobInfo(11339, "C"),       -- Sethir the Ancient
    [2003] = MobInfo(6809, "C"),        -- Shadow Sprite
    [14432] = MobInfo(904, "C"),        -- Threggil, Rare
    [2005] = MobInfo(6811, "C"),        -- Vicious Grell
    [6128] = MobInfo(2015, "C"),        -- Vorlus Vilehoof
    [272116] = MobInfo(2011, "C"),         -- Xethorr the Wicked, Elite
})
