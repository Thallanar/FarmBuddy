-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Westfall (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=40). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Westfall", {
    -- Beasts
    [834] = MobInfo(643, "S"),          -- Coyote
    [833] = MobInfo(161, "S"),          -- Coyote Packleader
    [157] = MobInfo(3027, "S"),         -- Goretusk
    [547] = MobInfo(3035, "S"),         -- Great Goretusk
    [822] = MobInfo(1006, "S"),         -- Young Forest Bear
    [454] = MobInfo(8871, "S"),         -- Young Goretusk

    -- Humanoids
    [502] = MobInfo(4422, "C"),         -- Benny Blaanco
    [596] = MobInfo(3267, "C"),         -- Brainwashed Noble, Rare-Elite
    [619] = MobInfo(2329, "C"),         -- Defias Conjurer, Elite
    [824] = MobInfo(2441, "C"),         -- Defias Digger
    [481] = MobInfo(2333, "C"),         -- Defias Footpad
    [594] = MobInfo(2323, "C"),         -- Defias Henchman, Elite
    [122] = MobInfo(2342, "C"),         -- Defias Highwayman
    [449] = MobInfo(2344, "C"),         -- Defias Knuckleduster
    [590] = MobInfo(2340, "C"),         -- Defias Looter
    [1726] = MobInfo(2321, "C"),        -- Defias Magician, Elite
    [550] = MobInfo(2312, "C"),         -- Defias Messenger
    [121] = MobInfo(2336, "C"),         -- Defias Pathstalker
    [589] = MobInfo(2338, "C"),         -- Defias Pillager
    [6180] = MobInfo(4908, "C"),        -- Defias Raider
    [450] = MobInfo(4420, "C"),         -- Defias Renegade Mage
    [95] = MobInfo(4418, "C"),          -- Defias Smuggler
    [504] = MobInfo(2331, "C"),         -- Defias Trapper
    [1727] = MobInfo(341, "C"),         -- Defias Worker
    [448] = MobInfo(384, "C"),          -- Hogger, Elite
    [7053] = MobInfo(5805, "C"),        -- Klaven Mortwake, Elite
    [1236] = MobInfo(373, "C"),         -- Kobold Digger
    [599] = MobInfo(2355, "C"),         -- Marisa du'Paige, Rare-Elite
    [1424] = MobInfo(774, "C"),         -- Master Digger, Rare
    [452] = MobInfo(383, "C"),          -- Riverpaw Bandit
    [124] = MobInfo(384, "C"),          -- Riverpaw Brute
    [117] = MobInfo(175, "C"),          -- Riverpaw Gnoll
    [501] = MobInfo(413, "C"),          -- Riverpaw Herbalist
    [1426] = MobInfo(374, "C"),         -- Riverpaw Miner
    [123] = MobInfo(383, "C"),          -- Riverpaw Mongrel
    [453] = MobInfo(502, "C"),          -- Riverpaw Mystic
    [478] = MobInfo(512, "C"),          -- Riverpaw Outrunner
    [125] = MobInfo(10790, "C"),        -- Riverpaw Overseer
    [97] = MobInfo(10791, "C"),         -- Riverpaw Runt
    [500] = MobInfo(374, "C"),          -- Riverpaw Scout
    [1065] = MobInfo(204, "C"),         -- Riverpaw Shaman
    [98] = MobInfo(376, "C"),           -- Riverpaw Taskmaster
    [506] = MobInfo(383, "C"),          -- Sergeant Brashclaw, Rare

    -- Undead
    [626] = MobInfo(10628, "C"),        -- Foreman Thistlenettle, Elite
    [2044] = MobInfo(915, "C"),         -- Forlorn Spirit
    [572] = MobInfo(1065, "C"),         -- Leprithus, Rare
    [623] = MobInfo(11402, "C"),        -- Skeletal Miner, Elite
    [625] = MobInfo(829, "C"),          -- Undead Dynamiter, Elite
    [624] = MobInfo(10630, "C"),        -- Undead Excavator, Elite
})
