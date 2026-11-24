-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Azshara (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=16). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Azshara", {
    -- Beasts
    [6648] = MobInfo(3212, "S"),        -- Antilos, Rare
    [247033] = MobInfo(0, nil),         -- Bloodshrike
    [222580] = MobInfo(0, nil),         -- Child of Apa'ro
    [6352] = MobInfo(10947, "S"),       -- Coralshell Lurker
    [6369] = MobInfo(2308, "S"),        -- Coralshell Tortoise
    [221928] = MobInfo(0, nil),         -- Hippogryph Avatar
    [8764] = MobInfo(4269, "S"),        -- Mistwing Ravager
    [8763] = MobInfo(12682, "S"),       -- Mistwing Rogue
    [8761] = MobInfo(10957, "S"),       -- Mosshoof Courser
    [8759] = MobInfo(8013, "S"),        -- Mosshoof Runner
    [8760] = MobInfo(2161, "S"),        -- Mosshoof Stag
    [13896] = MobInfo(7046, "S"),       -- Scalebeard, Rare-Elite
    [8660] = MobInfo(10807, "S"),       -- The Evalcharr, Rare
    [6380] = MobInfo(10891, "S"),       -- Thunderhead Consort
    [6375] = MobInfo(6757, "S"),        -- Thunderhead Hippogryph
    [223068] = MobInfo(0, nil),         -- Thunderhead Hippogryph
    [6379] = MobInfo(10892, "S"),       -- Thunderhead Patriarch
    [6378] = MobInfo(10893, "S"),       -- Thunderhead Skystormer
    [6377] = MobInfo(10894, "S"),       -- Thunderhead Stagwing

    -- Humanoids
    [247237] = MobInfo(0, nil),         -- Blackmaw Berserker, Elite
    [255394] = MobInfo(0, nil),         -- Blackmaw Champion, Elite
    [237733] = MobInfo(0, nil),         -- Blackmaw Den Watcher
    [250027] = MobInfo(0, nil),         -- Blackmaw Headhunter, Elite
    [237735] = MobInfo(0, nil),         -- Blackmaw Pathfinder
    [237736] = MobInfo(0, nil),         -- Blackmaw Shaman
    [250023] = MobInfo(0, nil),         -- Blackmaw Thrall, Elite
    [237734] = MobInfo(0, nil),         -- Blackmaw Totemic
    [237738] = MobInfo(0, nil),         -- Blackmaw Ursa
    [237732] = MobInfo(0, nil),         -- Blackmaw Warrior
    [246920] = MobInfo(0, nil),         -- Blood Elf Arcanist
    [6199] = MobInfo(7923, "C"),        -- Blood Elf Reclaimer
    [6198] = MobInfo(7922, "C"),        -- Blood Elf Surveyor
    [6651] = MobInfo(1012, "C"),        -- Gatekeeper Rageroar, Rare
    [239942] = MobInfo(0, nil),         -- Lady Sesspira
    [247006] = MobInfo(0, nil),         -- Lieutenant Suncrest
    [239939] = MobInfo(0, nil),         -- Lord Sarthiss
    [6647] = MobInfo(2240, "C"),        -- Magister Hawkhelm, Rare
    [246991] = MobInfo(0, nil),         -- Magister Hawkhelm
    [247470] = MobInfo(0, nil),         -- Makrinni Burrower
    [247013] = MobInfo(0, nil),         -- Ranger Lydrea
    [239971] = MobInfo(0, nil),         -- Razorgill
    [239966] = MobInfo(0, nil),         -- Storm Bay Tidecaller
    [6187] = MobInfo(6826, "C"),        -- Timbermaw Den Watcher
    [6184] = MobInfo(936, "C"),         -- Timbermaw Pathfinder
    [6188] = MobInfo(2000, "C"),        -- Timbermaw Shaman
    [6186] = MobInfo(1999, "C"),        -- Timbermaw Totemic
    [6189] = MobInfo(6746, "C"),        -- Timbermaw Ursa
    [6185] = MobInfo(6825, "C"),        -- Timbermaw Warrior

    -- Demons
    [237614] = MobInfo(0, nil),         -- Cauldron Imp
    [223544] = MobInfo(0, nil),         -- Fel Interloper
    [6127] = MobInfo(2020, "C"),        -- Haldarr Felsworn
    [6125] = MobInfo(11331, "C"),       -- Haldarr Satyr
    [6126] = MobInfo(11332, "C"),       -- Haldarr Trickster
    [236876] = MobInfo(0, nil),         -- Legashi Blackguard
    [6202] = MobInfo(11338, "C"),       -- Legashi Hellcaller
    [236874] = MobInfo(0, nil),         -- Legashi Hellraiser
    [6201] = MobInfo(6743, "C"),        -- Legashi Rogue
    [6200] = MobInfo(2878, "C"),        -- Legashi Satyr
    [272307] = MobInfo(0, nil),         -- Legashi Satyr, Elite
    [255347] = MobInfo(0, nil),         -- Legashi Slayer, Elite
    [236867] = MobInfo(0, nil),         -- Legashi Soulstealer
    [6652] = MobInfo(2687, "C"),        -- Master Feardred, Rare
    [236496] = MobInfo(0, nil),         -- Master Feardred
    [235892] = MobInfo(0, nil),         -- Prince Halanox, Elite
    [255247] = MobInfo(0, nil),         -- Swarming Imp

    -- Elementals
    [222004] = MobInfo(0, nil),         -- Corrupt Moderate Manifestation of Water

    -- Giants
    [6143] = MobInfo(12812, "C"),       -- Servant of Arkkoroc, Elite
    [6144] = MobInfo(4945, "C"),        -- Son of Arkkoroc, Elite

    -- Undead
    [6116] = MobInfo(10702, "C"),       -- Highborne Apparition
    [6117] = MobInfo(10700, "C"),       -- Highborne Lichling
    [7864] = MobInfo(146, "C"),         -- Lingering Highborne
    [6118] = MobInfo(10771, "C"),       -- Varo'then's Ghost, Rare

    -- Dragonkin
    [6109] = MobInfo(11460, "S"),       -- Azuregos, Boss
    [193] = MobInfo(196, "S"),          -- Blue Dragonspawn, Elite
    [6130] = MobInfo(6760, "S"),        -- Blue Scalebane, Elite
    [247972] = MobInfo(0, nil),         -- Celegosa, Elite
    [221651] = MobInfo(0, nil),         -- Ceruleos
    [6129] = MobInfo(6762, "S"),        -- Draconic Magelord, Elite
    [6131] = MobInfo(6761, "S"),        -- Draconic Mageweaver, Elite
})
