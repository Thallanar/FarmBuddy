-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Zephras Isle (Forever)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=16593). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Zephras Isle", {
    -- Beasts
    [271712] = MobInfo(146732, "S"),         -- Cloudrunner
    [271710] = MobInfo(146732, "S"),         -- Cloudrunner Matriarch
    [256492] = MobInfo(144242, "S"),         -- Fernfeather, Rare
    [251661] = MobInfo(144243, "S"),         -- Galestrider
    [250928] = MobInfo(136604, "S"),         -- Highlands Ursera
    [251261] = MobInfo(3211, "S"),         -- Hippogryph Matriarch
    [251284] = MobInfo(6756, "S"),         -- Hippogryph Protector
    [251291] = MobInfo(479, "S"),         -- Hippogryph Youth
    [271707] = MobInfo(146732, "S"),         -- Juvenile Cloudrunner
    [250873] = MobInfo(136536, "S"),         -- Juvenile Vuldren
    [259388] = MobInfo(136608, "S"),         -- Mystmane, Rare
    [251707] = MobInfo(144242, "S"),         -- Ornery Galestrider
    [251245] = MobInfo(143625, "S"),         -- Prideclaw
    [250926] = MobInfo(136607, "S"),         -- Scrawny Ursera
    [256092] = MobInfo(142400, "S"),         -- Shadowgale Shriekling
    [250927] = MobInfo(136605, "S"),         -- Shadowgale Ursera
    [253282] = MobInfo(139491, "S"),         -- Shriekling Fledgling
    [253283] = MobInfo(139493, "S"),         -- Shriekling Matriarch
    [255887] = MobInfo(139280, "S"),         -- Slydris, Rare-Elite
    [259394] = MobInfo(10894, "S"),         -- Snapbeak the Quick, Rare-Elite
    [258443] = MobInfo(136605, "S"),         -- Ur'endra
    [251115] = MobInfo(136606, "S"),         -- Urs'anah
    [250937] = MobInfo(136605, "S"),         -- Ursera Scavenger
    [250868] = MobInfo(136536, "S"),         -- Vuldren
    [250874] = MobInfo(136537, "S"),         -- Vuldren Alpha
    [254589] = MobInfo(136523, "S"),         -- Vulgara the Insatiable, Elite

    -- Humanoids
    [255534] = MobInfo(138933, "C"),         -- "Badwind" Bennic
    [252875] = MobInfo(137636, "C"),         -- Bandit Henchman
    [252820] = MobInfo(137640, "C"),         -- Bandit Highwayman
    [251918] = MobInfo(137266, "C"),         -- Highlands Bandit
    [252802] = MobInfo(137638, "C"),         -- Hungry Bandit
})
