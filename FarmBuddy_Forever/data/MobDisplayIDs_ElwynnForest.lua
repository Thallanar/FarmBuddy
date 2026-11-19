-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Elwynn Forest (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=12). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Elwynn Forest", {
    -- Beasts
    [248299] = MobInfo(706, "S"),       -- Elmpaw, Elite
    [1922] = MobInfo(380, "S"),         -- Gray Forest Wolf
    [119] = MobInfo(381, "S"),          -- Longsnout
    [525] = MobInfo(903, "S"),          -- Mangy Wolf
    [276189] = MobInfo(806, "S"),       -- Matriarch Bristlefur, Rare
    [390] = MobInfo(377, "S"),          -- Porcine Entourage
    [330] = MobInfo(8871, "S"),         -- Princess
    [118] = MobInfo(11415, "S"),        -- Prowler
    [565] = MobInfo(802, "S"),          -- Rabid Dire Wolf
    [524] = MobInfo(389, "S"),          -- Rockhide Boar
    [213] = MobInfo(801, "S"),          -- Starving Dire Wolf
    [113] = MobInfo(138616, "S"),       -- Stonetusk Boar
    [822] = MobInfo(1006, "S"),         -- Young Forest Bear

    -- Humanoids
    [6093] = MobInfo(4947, "C"),        -- Dead-Tooth Jack
    [583] = MobInfo(184, "C"),          -- Defias Ambusher
    [116] = MobInfo(2357, "C"),         -- Defias Bandit
    [6866] = MobInfo(2340, "C"),        -- Defias Bodyguard
    [94] = MobInfo(2361, "C"),          -- Defias Cutpurse
    [6846] = MobInfo(7849, "C"),        -- Defias Dockmaster
    [6927] = MobInfo(2357, "C"),        -- Defias Dockworker
    [474] = MobInfo(2359, "C"),         -- Defias Rogue Wizard
    [880] = MobInfo(3322, "C"),         -- Erlan Drudgemoor
    [472] = MobInfo(175, "C"),          -- Fedfennel, Rare
    [248474] = MobInfo(10911, "C"),     -- Geosculptor Yip, Elite
    [327] = MobInfo(2299, "C"),         -- Goldtooth
    [100] = MobInfo(175, "C"),          -- Gruff Swiftbite, Rare
    [448] = MobInfo(384, "C"),          -- Hogger, Elite
    [476] = MobInfo(163, "C"),          -- Kobold Geomancer
    [40] = MobInfo(373, "C"),           -- Kobold Miner
    [475] = MobInfo(139, "C"),          -- Kobold Tunneler
    [99] = MobInfo(3320, "C"),          -- Morgaine the Sly, Rare
    [473] = MobInfo(2074, "C"),         -- Morgan the Collector
    [79] = MobInfo(774, "C"),           -- Narg the Taskmaster, Rare
    [248464] = MobInfo(10911, "C"),     -- Nimsy, Elite
    [478] = MobInfo(512, "C"),          -- Riverpaw Outrunner
    [97] = MobInfo(10791, "C"),         -- Riverpaw Runt
    [60] = MobInfo(2153, "C"),          -- Ruklar the Trapper
    [248362] = MobInfo(774, "C"),       -- Shinyfinder Narf, Elite
    [881] = MobInfo(3321, "C"),         -- Surena Caledon
    [61] = MobInfo(3341, "C"),          -- Thuros Lightfingers, Rare
})
