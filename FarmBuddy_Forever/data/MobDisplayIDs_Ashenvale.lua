-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Ashenvale (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=331). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Ashenvale", {
    -- Beasts
    [3809] = MobInfo(820, "S"),         -- Ashenvale Bear
    [221257] = MobInfo(0, nil),         -- Deathhorn Stag
    [221258] = MobInfo(0, nil),         -- Dreamthorn Stalker
    [3810] = MobInfo(982, "S"),         -- Elder Ashenvale Bear
    [3818] = MobInfo(1992, "S"),        -- Elder Shadowhorn Stag
    [3825] = MobInfo(776, "S"),         -- Ghostpaw Alpha
    [3824] = MobInfo(1207, "S"),        -- Ghostpaw Howler
    [3823] = MobInfo(802, "S"),         -- Ghostpaw Runner
    [3811] = MobInfo(14315, "S"),       -- Giant Ashenvale Bear
    [10644] = MobInfo(165, "S"),        -- Mist Howler, Rare
    [221230] = MobInfo(0, nil),         -- Nightmare Grizzly
    [3817] = MobInfo(1991, "S"),        -- Shadowhorn Stag
    [12037] = MobInfo(706, "S"),        -- Ursol'lok, Rare
    [3816] = MobInfo(1917, "S"),        -- Wild Buck

    -- Humanoids
    [3735] = MobInfo(4156, "C"),        -- Apothecary Falthis, Rare
    [216662] = MobInfo(0, nil),         -- Blackfathom Oracle, Elite
    [216661] = MobInfo(0, nil),         -- Blackfathom Tide Priestess, Elite
    [3932] = MobInfo(1996, "C"),        -- Bloodtooth Guard
    [222409] = MobInfo(0, nil),         -- Boss "Gobb" Goldnick, Elite
    [12918] = MobInfo(6825, "C"),       -- Chief Murgut
    [3987] = MobInfo(2002, "C"),        -- Dal Bloodclaw
    [3728] = MobInfo(4220, "C"),        -- Dark Strand Adept
    [3879] = MobInfo(4227, "C"),        -- Dark Strand Assassin
    [3725] = MobInfo(4255, "C"),        -- Dark Strand Cultist
    [3727] = MobInfo(1643, "C"),        -- Dark Strand Enforcer
    [3730] = MobInfo(9751, "C"),        -- Dark Strand Excavator
    [3893] = MobInfo(4157, "C"),        -- Forsaken Scout
    [3746] = MobInfo(6819, "C"),        -- Foulweald Den Watcher
    [3745] = MobInfo(937, "C"),         -- Foulweald Pathfinder
    [3748] = MobInfo(6822, "C"),        -- Foulweald Shaman
    [3750] = MobInfo(6821, "C"),        -- Foulweald Totemic
    [3749] = MobInfo(1996, "C"),        -- Foulweald Ursa
    [3743] = MobInfo(6824, "C"),        -- Foulweald Warrior
    [3664] = MobInfo(2532, "C"),        -- Ilkrud Magthrull
    [10640] = MobInfo(5773, "C"),       -- Oakpaw, Rare
    [3696] = MobInfo(1012, "C"),        -- Ran Bloodtooth
    [10639] = MobInfo(6800, "C"),       -- Rorgish Jowl, Rare
    [3789] = MobInfo(203, "S"),         -- Terrowulf Fleshripper
    [3792] = MobInfo(522, "S"),         -- Terrowulf Packlord, Rare
    [3791] = MobInfo(736, "S"),         -- Terrowulf Shadow Weaver
    [3925] = MobInfo(6823, "C"),        -- Thistlefur Avenger
    [3923] = MobInfo(936, "C"),         -- Thistlefur Den Watcher
    [3926] = MobInfo(897, "C"),         -- Thistlefur Pathfinder
    [3924] = MobInfo(6801, "C"),        -- Thistlefur Shaman
    [3922] = MobInfo(6803, "C"),        -- Thistlefur Totemic
    [3921] = MobInfo(1999, "C"),        -- Thistlefur Ursa
    [3715] = MobInfo(4981, "C"),        -- Wrathtail Sea Witch

    -- Demons
    [3773] = MobInfo(1912, "C"),        -- Akkrilus, Rare
    [3898] = MobInfo(467, "C"),         -- Aligar the Tormentor
    [3899] = MobInfo(2007, "C"),        -- Balizar the Umbrage
    [3771] = MobInfo(2013, "C"),        -- Bleakheart Hellcaller
    [3765] = MobInfo(2007, "C"),        -- Bleakheart Satyr
    [3770] = MobInfo(2017, "C"),        -- Bleakheart Shadowstalker
    [3767] = MobInfo(2018, "C"),        -- Bleakheart Trickster
    [3900] = MobInfo(9781, "C"),        -- Caedakar the Vicious
    [6072] = MobInfo(348, "C"),         -- Diathorus the Seeker
    [221261] = MobInfo(0, nil),         -- Dreamfire Betrayer
    [221262] = MobInfo(0, nil),         -- Dreamfire Hellcaller
    [221292] = MobInfo(0, nil),         -- Dreamhunter Hound
    [221283] = MobInfo(0, nil),         -- Dreampyre Imp
    [221282] = MobInfo(0, nil),         -- Emberspark Dreamsworn
    [4789] = MobInfo(2011, "C"),        -- Fallenroot Rogue, Elite
    [216660] = MobInfo(0, nil),         -- Fallenroot Rogue, Elite
    [4788] = MobInfo(2012, "C"),        -- Fallenroot Satyr, Elite
    [216659] = MobInfo(0, nil),         -- Fallenroot Satyr, Elite
    [223542] = MobInfo(0, nil),         -- Fel Interloper
    [6115] = MobInfo(5048, "C"),        -- Felguard
    [213710] = MobInfo(0, nil),         -- Felguard
    [3762] = MobInfo(2011, "C"),        -- Felmusk Felsworn
    [3759] = MobInfo(2875, "C"),        -- Felmusk Rogue
    [3758] = MobInfo(2010, "C"),        -- Felmusk Satyr
    [3763] = MobInfo(6741, "C"),        -- Felmusk Shadowstalker
    [3774] = MobInfo(10950, "S"),       -- Felslayer
    [4619] = MobInfo(2021, "C"),        -- Geltharis
    [213708] = MobInfo(0, nil),         -- Legion Hound
    [3772] = MobInfo(5049, "C"),        -- Lesser Felguard
    [11697] = MobInfo(2834, "C"),       -- Mannoroc Lasher
    [213709] = MobInfo(0, nil),         -- Mannoroc Lasher
    [10647] = MobInfo(11331, "C"),      -- Prince Raze, Rare
    [213711] = MobInfo(0, nil),         -- Searing Infernal, Elite
    [3754] = MobInfo(11344, "C"),       -- Xavian Betrayer
    [3755] = MobInfo(11346, "C"),       -- Xavian Felsworn
    [3757] = MobInfo(11345, "C"),       -- Xavian Hellcaller
    [3752] = MobInfo(2878, "C"),        -- Xavian Rogue
    [221266] = MobInfo(0, nil),         -- Zalius, Elite

    -- Elementals
    [221263] = MobInfo(0, nil),         -- Vengeful Ancient, Elite

    -- Giants
    [211956] = MobInfo(0, nil),         -- Scarimous the Wandering, Boss

    -- Undead
    [273642] = MobInfo(0, nil),         -- Highborne Spirit, Elite
    [3942] = MobInfo(4163, "C"),        -- Mavoris Cloudsbreak
    [3802] = MobInfo(4160, "C"),        -- Severed Dreamer
    [3799] = MobInfo(4161, "C"),        -- Severed Druid
    [3803] = MobInfo(4164, "C"),        -- Severed Keeper
    [3801] = MobInfo(4159, "C"),        -- Severed Sleeper
    [3940] = MobInfo(4166, "C"),        -- Taneel Darkwood
    [3941] = MobInfo(4165, "C"),        -- Uthil Mooncall

    -- Dragonkin
    [3815] = MobInfo(1267, "S"),        -- Blink Dragon
    [12498] = MobInfo(7553, "S"),       -- Dreamstalker, Elite
    [12474] = MobInfo(12509, "S"),      -- Emeraldon Boughguard, Elite
    [12476] = MobInfo(7974, "S"),       -- Emeraldon Oracle, Elite
    [12475] = MobInfo(625, "S"),        -- Emeraldon Tree Warder, Elite
    [211042] = MobInfo(0, nil),         -- Green Dragon Whelp
    [221265] = MobInfo(0, nil),         -- Larsera, Elite
    [5314] = MobInfo(7553, "S"),        -- Phantim, Elite
    [222977] = MobInfo(0, nil),         -- Phantim, Elite
    [221260] = MobInfo(0, nil),         -- Terror Whelp
    [221259] = MobInfo(0, nil),         -- Wyrmkin Nightstalker, Elite

    -- Mechanicals
    [221264] = MobInfo(0, nil),         -- Dreamharvester, Elite
    [221267] = MobInfo(0, nil),         -- Shredder 9000, Elite
})
