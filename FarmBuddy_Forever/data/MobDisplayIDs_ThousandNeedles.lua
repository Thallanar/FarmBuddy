-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Thousand Needles (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=400). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Thousand Needles", {
    -- Beasts
    [4117] = MobInfo(2705, "S"),        -- Cloud Serpent
    [4126] = MobInfo(1043, "S"),        -- Crag Stalker
    [4119] = MobInfo(2703, "S"),        -- Elder Cloud Serpent
    [10992] = MobInfo(1095, "S"),       -- Enraged Panther, Elite
    [4250] = MobInfo(2726, "S"),        -- Galak Packhound
    [5934] = MobInfo(11011, "S"),       -- Heartrazor, Rare-Elite
    [4109] = MobInfo(2297, "S"),        -- Highperch Consort
    [4110] = MobInfo(4585, "S"),        -- Highperch Patriarch
    [4107] = MobInfo(2298, "S"),        -- Highperch Wyvern
    [5935] = MobInfo(2076, "S"),        -- Ironeye the Invincible, Rare-Elite
    [4124] = MobInfo(1056, "S"),        -- Needles Cougar
    [4248] = MobInfo(2713, "S"),        -- Pesterhide Hyena
    [4249] = MobInfo(10903, "S"),       -- Pesterhide Snarler
    [4147] = MobInfo(12340, "S"),       -- Saltstone Basilisk
    [4151] = MobInfo(12341, "S"),       -- Saltstone Crystalhide
    [4150] = MobInfo(8392, "S"),        -- Saltstone Gazer
    [4140] = MobInfo(3247, "S"),        -- Scorpid Reaver
    [4139] = MobInfo(2491, "S"),        -- Scorpid Terror
    [4144] = MobInfo(2307, "S"),        -- Sparkleshell Borer
    [4143] = MobInfo(2308, "S"),        -- Sparkleshell Snapper
    [4142] = MobInfo(5052, "S"),        -- Sparkleshell Tortoise
    [4548] = MobInfo(2609, "S"),        -- Steelsnap
    [270094] = MobInfo(6085, "S"),      -- Stormheart, Elite
    [4118] = MobInfo(10991, "S"),       -- Venomous Cloud Serpent
    [5937] = MobInfo(10988, "S"),       -- Vile Sting, Rare-Elite

    -- Humanoids
    [5933] = MobInfo(9418, "C"),        -- Achellios the Banished, Rare
    [10896] = MobInfo(10243, "C"),      -- Arnak Grimtotem
    [7872] = MobInfo(6098, "C"),        -- Death's Head Cultist, Elite
    [10720] = MobInfo(9435, "C"),       -- Galak Assassin
    [7404] = MobInfo(2290, "C"),        -- Galak Flame Guard
    [4099] = MobInfo(9415, "C"),        -- Galak Marauder
    [4095] = MobInfo(9417, "C"),        -- Galak Mauler
    [10617] = MobInfo(9532, "C"),       -- Galak Messenger
    [4094] = MobInfo(9411, "C"),        -- Galak Scout
    [4097] = MobInfo(9416, "C"),        -- Galak Stormer
    [4096] = MobInfo(9412, "C"),        -- Galak Windchaser
    [4093] = MobInfo(9414, "C"),        -- Galak Wrangler
    [14427] = MobInfo(511, "C"),        -- Gibblesnik, Rare
    [4113] = MobInfo(511, "C"),         -- Gravelsnout Digger
    [4114] = MobInfo(2299, "C"),        -- Gravelsnout Forager
    [4111] = MobInfo(2153, "C"),        -- Gravelsnout Kobold
    [4116] = MobInfo(774, "C"),         -- Gravelsnout Surveyor
    [4112] = MobInfo(373, "C"),         -- Gravelsnout Vermin
    [4490] = MobInfo(974, "C"),         -- Grenka Bloodscreech
    [10758] = MobInfo(10223, "C"),      -- Grimtotem Bandit
    [10760] = MobInfo(10227, "C"),      -- Grimtotem Geomancer
    [10761] = MobInfo(10233, "C"),      -- Grimtotem Reaver
    [10759] = MobInfo(10238, "C"),      -- Grimtotem Stomper
    [14426] = MobInfo(3898, "C"),       -- Harb Foulmountain, Rare
    [7873] = MobInfo(6108, "C"),        -- Razorfen Battleguard, Elite
    [7874] = MobInfo(1963, "C"),        -- Razorfen Thornweaver, Elite
    [4100] = MobInfo(1352, "C"),        -- Screeching Harpy
    [4101] = MobInfo(1350, "C"),        -- Screeching Roguefeather
    [4104] = MobInfo(10876, "C"),       -- Screeching Windcaller
})
