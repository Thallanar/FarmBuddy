-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Blasted Lands (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=4). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Blasted Lands", {
    -- Beasts
    [5992] = MobInfo(3026, "S"),        -- Ashmane Boar
    [5982] = MobInfo(10824, "S"),       -- Black Slayer
    [221740] = MobInfo(0, nil),         -- Calefactus the Unleashed, Elite
    [8301] = MobInfo(10983, "S"),       -- Clack the Reaver, Rare
    [8303] = MobInfo(8870, "S"),        -- Grunter, Rare
    [8300] = MobInfo(10904, "S"),       -- Ravage, Rare
    [5990] = MobInfo(2743, "S"),        -- Redstone Basilisk
    [5991] = MobInfo(798, "S"),         -- Redstone Crystalhide
    [5988] = MobInfo(6068, "S"),        -- Scorpok Stinger
    [5985] = MobInfo(2714, "S"),        -- Snickerfang Hyena
    [272386] = MobInfo(0, nil),         -- Snickerfang Matriarch
    [5984] = MobInfo(8050, "S"),        -- Starving Snickerfang

    -- Humanoids
    [8298] = MobInfo(10920, "C"),       -- Akubar the Seer, Rare
    [5976] = MobInfo(11584, "C"),       -- Dreadmaul Brute
    [5977] = MobInfo(14401, "C"),       -- Dreadmaul Mauler
    [5974] = MobInfo(14402, "C"),       -- Dreadmaul Ogre
    [5975] = MobInfo(11542, "C"),       -- Dreadmaul Ogre Mage
    [5978] = MobInfo(11543, "C"),       -- Dreadmaul Warlock
    [8304] = MobInfo(7844, "C"),        -- Dreadscorn, Rare
    [8297] = MobInfo(11564, "C"),       -- Magronos the Unyielding, Rare
    [8296] = MobInfo(11562, "C"),       -- Mojo the Twisted, Rare
    [222702] = MobInfo(0, nil),         -- Murderous Lost One
    [5981] = MobInfo(10921, "C"),       -- Portal Seeker
    [7670] = MobInfo(6855, "C"),        -- Servant of Allistarj
    [7669] = MobInfo(6874, "C"),        -- Servant of Grol
    [7668] = MobInfo(6847, "C"),        -- Servant of Razelikh
    [7671] = MobInfo(6869, "C"),        -- Servant of Sevine
    [6006] = MobInfo(6770, "C"),        -- Shadowsworn Adept
    [6004] = MobInfo(7838, "C"),        -- Shadowsworn Cultist
    [6009] = MobInfo(6784, "C"),        -- Shadowsworn Dreadweaver
    [6007] = MobInfo(6787, "C"),        -- Shadowsworn Enforcer
    [228532] = MobInfo(0, nil),         -- Shadowsworn Sacrifice
    [6005] = MobInfo(6793, "C"),        -- Shadowsworn Thug
    [6008] = MobInfo(6789, "C"),        -- Shadowsworn Warlock
    [5979] = MobInfo(152, "C"),         -- Wretched Lost One

    -- Demons
    [7666] = MobInfo(6769, "C"),        -- Archmage Allistarj, Elite
    [12396] = MobInfo(4426, "C"),       -- Doomguard Commander, Elite
    [8716] = MobInfo(10543, "C"),       -- Dreadlord, Elite
    [223544] = MobInfo(0, nil),         -- Fel Interloper
    [8675] = MobInfo(7949, "S"),        -- Felbeast
    [7735] = MobInfo(5047, "C"),        -- Felcular, Elite
    [8717] = MobInfo(7970, "C"),        -- Felguard Elite, Elite
    [6011] = MobInfo(9017, "C"),        -- Felguard Sentry
    [6010] = MobInfo(1913, "S"),        -- Felhound
    [7665] = MobInfo(10169, "C"),       -- Grol the Destroyer, Elite
    [5993] = MobInfo(11410, "S"),       -- Helboar
    [228414] = MobInfo(0, nil),         -- Heliath, Elite
    [7734] = MobInfo(6380, "C"),        -- Ilifar, Elite
    [7728] = MobInfo(6688, "C"),        -- Kirith the Damned, Elite
    [7667] = MobInfo(6768, "C"),        -- Lady Sevine, Elite
    [8718] = MobInfo(6173, "S"),        -- Manahound, Elite
    [7664] = MobInfo(10543, "C"),       -- Razelikh the Defiler, Elite
    [247015] = MobInfo(0, nil),         -- Vek'zol, Elite
    [228533] = MobInfo(0, nil),         -- Voidwalker Minion
})
