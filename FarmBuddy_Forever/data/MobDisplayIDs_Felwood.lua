-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Felwood (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=361). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Felwood", {
    -- Beasts
    [8956] = MobInfo(9276, "S"),        -- Angerclaw Bear
    [8957] = MobInfo(9277, "S"),        -- Angerclaw Grizzly
    [8958] = MobInfo(1083, "S"),        -- Angerclaw Mauler
    [14339] = MobInfo(11412, "S"),      -- Death Howl, Rare
    [8961] = MobInfo(9280, "S"),        -- Felpaw Ravager
    [8960] = MobInfo(9278, "S"),        -- Felpaw Scavenger
    [8959] = MobInfo(4124, "S"),        -- Felpaw Wolf
    [14344] = MobInfo(14315, "S"),      -- Mongress, Rare

    -- Humanoids
    [9462] = MobInfo(8589, "C"),        -- Chieftain Bloodmaw
    [7157] = MobInfo(2003, "C"),        -- Deadwood Avenger
    [7156] = MobInfo(6825, "C"),        -- Deadwood Den Watcher
    [7154] = MobInfo(3028, "C"),        -- Deadwood Gardener
    [7155] = MobInfo(2000, "C"),        -- Deadwood Pathfinder
    [7158] = MobInfo(6746, "C"),        -- Deadwood Shaman
    [7153] = MobInfo(2000, "C"),        -- Deadwood Warrior
    [7115] = MobInfo(6390, "C"),        -- Jaedenar Adept
    [7112] = MobInfo(6389, "C"),        -- Jaedenar Cultist
    [7118] = MobInfo(6393, "C"),        -- Jaedenar Darkweaver
    [7114] = MobInfo(6397, "C"),        -- Jaedenar Enforcer
    [7113] = MobInfo(6399, "C"),        -- Jaedenar Guardian
    [7120] = MobInfo(6405, "C"),        -- Jaedenar Warlock
    [9464] = MobInfo(8589, "C"),        -- Overlord Ror
    [14342] = MobInfo(1012, "C"),       -- Ragepaw, Rare
    [9517] = MobInfo(10198, "C"),       -- Shadow Lord Fel'dan
    [14523] = MobInfo(14563, "C"),      -- Ulathek
    [10916] = MobInfo(6829, "C"),       -- Winterfall Runner

    -- Demons
    [14340] = MobInfo(2879, "C"),       -- Alshirr Banebreath, Rare
    [7108] = MobInfo(11333, "C"),       -- Jadefire Betrayer
    [7109] = MobInfo(11334, "C"),       -- Jadefire Felsworn
    [7111] = MobInfo(11335, "C"),       -- Jadefire Hellcaller
    [7106] = MobInfo(8575, "C"),        -- Jadefire Rogue
    [7105] = MobInfo(2019, "C"),        -- Jadefire Satyr
    [7110] = MobInfo(11336, "C"),       -- Jadefire Shadowstalker
    [7107] = MobInfo(11337, "C"),       -- Jadefire Trickster
    [7125] = MobInfo(6172, "S"),        -- Jaedenar Hound
    [7126] = MobInfo(6173, "S"),        -- Jaedenar Hunter
    [9862] = MobInfo(9129, "C"),        -- Jaedenar Legionnaire
    [9516] = MobInfo(8611, "C"),        -- Lord Banehollow, Elite
    [9861] = MobInfo(10926, "C"),       -- Moora
    [9877] = MobInfo(11335, "C"),       -- Prince Xavalis
    [9518] = MobInfo(10191, "C"),       -- Rakaiah
    [9860] = MobInfo(10927, "C"),       -- Salia
    [10648] = MobInfo(2879, "C"),       -- Xavaric
    [9454] = MobInfo(2880, "C"),        -- Xavathras

    -- Elementals
    [235912] = MobInfo(0, nil),         -- Ancient Irontree Walker, Elite
})
