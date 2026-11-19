-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Duskwood (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=10). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Duskwood", {
    -- Beasts
    [628] = MobInfo(741, "S"),          -- Black Ravager
    [1258] = MobInfo(9562, "S"),        -- Black Ravager Mastiff
    [833] = MobInfo(161, "S"),          -- Coyote Packleader
    [1922] = MobInfo(380, "S"),         -- Gray Forest Wolf
    [277645] = MobInfo(148953, "S"),    -- Gray Fox
    [521] = MobInfo(11412, "S"),        -- Lupos, Rare
    [565] = MobInfo(802, "S"),          -- Rabid Dire Wolf
    [7376] = MobInfo(10826, "S"),       -- Sky Shadow
    [213] = MobInfo(801, "S"),          -- Starving Dire Wolf
    [923] = MobInfo(246, "S"),          -- Young Black Ravager

    -- Humanoids
    [6866] = MobInfo(2340, "C"),        -- Defias Bodyguard
    [6927] = MobInfo(2357, "C"),        -- Defias Dockworker
    [910] = MobInfo(4281, "C"),         -- Defias Enchanter
    [909] = MobInfo(4279, "C"),         -- Defias Night Blade
    [215] = MobInfo(4276, "C"),         -- Defias Night Runner
    [507] = MobInfo(11179, "S"),        -- Fenros, Rare
    [218] = MobInfo(4275, "C"),         -- Grave Robber
    [6170] = MobInfo(203, "S"),         -- Gutspill
    [1200] = MobInfo(4272, "C"),        -- Morbent Fel, Elite
    [534] = MobInfo(11181, "S"),        -- Nefaru, Rare
    [205] = MobInfo(736, "S"),          -- Nightbane Dark Runner
    [533] = MobInfo(203, "S"),          -- Nightbane Shadow Weaver
    [920] = MobInfo(1098, "S"),         -- Nightbane Tainted One
    [206] = MobInfo(522, "S"),          -- Nightbane Vile Fang
    [898] = MobInfo(657, "S"),          -- Nightbane Worgen
    [478] = MobInfo(512, "C"),          -- Riverpaw Outrunner
    [1487] = MobInfo(6170, "C"),        -- Splinter Fist Enslaver
    [891] = MobInfo(326, "C"),          -- Splinter Fist Fire Weaver
    [1251] = MobInfo(3190, "C"),        -- Splinter Fist Firemonger
    [889] = MobInfo(415, "C"),          -- Splinter Fist Ogre
    [892] = MobInfo(11567, "C"),        -- Splinter Fist Taskmaster
    [212] = MobInfo(610, "C"),          -- Splinter Fist Warrior
    [300] = MobInfo(655, "C"),          -- Zzarc' Vul

    -- Undead
    [210] = MobInfo(570, "C"),          -- Bone Chewer
    [570] = MobInfo(569, "C"),          -- Brain Eater
    [771] = MobInfo(7848, "C"),         -- Commander Felstrom, Rare
    [314] = MobInfo(10487, "C"),        -- Eliza, Elite
    [1270] = MobInfo(559, "C"),         -- Fetid Corpse
    [3] = MobInfo(987, "C"),            -- Flesh Eater
    [511] = MobInfo(828, "C"),          -- Insane Ghoul
    [503] = MobInfo(10626, "C"),        -- Lord Malathrom, Rare
    [272284] = MobInfo(146984, "C"),    -- Lost Defender
    [272291] = MobInfo(146988, "C"),    -- Lost Knight
    [272260] = MobInfo(146980, "C"),    -- Lost Stalker
    [272273] = MobInfo(146979, "C"),    -- Lost Watcher
    [522] = MobInfo(612, "C"),          -- Mor'Ladim, Elite
    [604] = MobInfo(519, "C"),          -- Plague Spreader
    [948] = MobInfo(137, "C"),          -- Rotted One
    [531] = MobInfo(7550, "C"),         -- Skeletal Fiend
    [787] = MobInfo(7555, "C"),         -- Skeletal Healer
    [202] = MobInfo(9786, "C"),         -- Skeletal Horror
    [203] = MobInfo(9783, "C"),         -- Skeletal Mage
    [1110] = MobInfo(734, "C"),         -- Skeletal Raider
    [785] = MobInfo(612, "C"),          -- Skeletal Warder
    [48] = MobInfo(200, "C"),           -- Skeletal Warrior
    [315] = MobInfo(1562, "C"),         -- Stalvan Mistmantle
    [412] = MobInfo(1693, "C"),         -- Stitches, Elite
    [3094] = MobInfo(146, "C"),         -- Unseen
})
