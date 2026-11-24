-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Desolace (Kalimdor)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=405). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Desolace", {
    -- Beasts
    [4700] = MobInfo(1308, "S"),        -- Aged Kodo
    [11785] = MobInfo(11713, "S"),      -- Ambereye Basilisk, Elite
    [11786] = MobInfo(12338, "S"),      -- Ambereye Reaver, Elite
    [4702] = MobInfo(2767, "S"),        -- Ancient Kodo
    [4688] = MobInfo(10902, "S"),       -- Bonepaw Hyena
    [13837] = MobInfo(236, "S"),        -- Captured Stallion
    [4701] = MobInfo(1453, "S"),        -- Dying Kodo
    [4727] = MobInfo(2764, "S"),        -- Elder Thunder Lizard
    [14228] = MobInfo(2714, "S"),       -- Giggler, Rare
    [4728] = MobInfo(1074, "S"),        -- Gritjaw Basilisk
    [14227] = MobInfo(2076, "S"),       -- Hissperak, Rare
    [4729] = MobInfo(7345, "S"),        -- Hulking Gritjaw Basilisk
    [4662] = MobInfo(2716, "S"),        -- Magram Bonepaw
    [4690] = MobInfo(10271, "S"),       -- Rabid Bonepaw
    [4726] = MobInfo(2742, "S"),        -- Raging Thunder Lizard
    [11787] = MobInfo(12335, "S"),      -- Rock Borer, Elite
    [11788] = MobInfo(13009, "S"),      -- Rock Worm, Elite
    [4697] = MobInfo(2765, "S"),        -- Scorpashi Lasher
    [4696] = MobInfo(2729, "S"),        -- Scorpashi Snapper
    [4699] = MobInfo(2766, "S"),        -- Scorpashi Venomlash
    [4689] = MobInfo(2726, "S"),        -- Starving Bonepaw

    -- Humanoids
    [4665] = MobInfo(4697, "C"),        -- Burning Blade Adept
    [4663] = MobInfo(4699, "C"),        -- Burning Blade Augur
    [4666] = MobInfo(4701, "C"),        -- Burning Blade Felsworn
    [4705] = MobInfo(4707, "C"),        -- Burning Blade Invoker
    [4664] = MobInfo(4703, "C"),        -- Burning Blade Reaver
    [13019] = MobInfo(4707, "C"),       -- Burning Blade Seer
    [4667] = MobInfo(4705, "C"),        -- Burning Blade Shadowmage
    [4668] = MobInfo(4709, "C"),        -- Burning Blade Summoner
    [11688] = MobInfo(11640, "C"),      -- Cursed Centaur, Rare
    [4651] = MobInfo(9424, "C"),        -- Gelkis Earthcaller
    [255561] = MobInfo(9414, "C"),      -- Gelkis Guardian
    [4653] = MobInfo(9425, "C"),        -- Gelkis Marauder
    [4652] = MobInfo(9426, "C"),        -- Gelkis Mauler
    [4646] = MobInfo(9420, "C"),        -- Gelkis Outrunner
    [4647] = MobInfo(9421, "C"),        -- Gelkis Scout
    [4648] = MobInfo(9422, "C"),        -- Gelkis Stamper
    [4649] = MobInfo(9423, "C"),        -- Gelkis Windchaser
    [255003] = MobInfo(138589, "C"),    -- Gimashi
    [5771] = MobInfo(4696, "C"),        -- Jugkar Grim'rod
    [5600] = MobInfo(4860, "C"),        -- Khan Dez'hepah
    [5402] = MobInfo(9441, "C"),        -- Khan Hratha, Elite
    [5601] = MobInfo(9433, "C"),        -- Khan Jehn
    [5602] = MobInfo(9427, "C"),        -- Khan Shaka
    [12977] = MobInfo(9448, "C"),       -- Kolkar Ambusher
    [4636] = MobInfo(9448, "C"),        -- Kolkar Battle Lord
    [4632] = MobInfo(9447, "C"),        -- Kolkar Centaur
    [4637] = MobInfo(9446, "C"),        -- Kolkar Destroyer
    [4634] = MobInfo(4874, "C"),        -- Kolkar Mauler
    [4633] = MobInfo(9445, "C"),        -- Kolkar Scout
    [12976] = MobInfo(4871, "C"),       -- Kolkar Waylayer
    [4635] = MobInfo(4871, "C"),        -- Kolkar Windchaser
    [255560] = MobInfo(4583, "C"),      -- Magram Guardian
    [4644] = MobInfo(9432, "C"),        -- Magram Marauder
    [4645] = MobInfo(4583, "C"),        -- Magram Mauler
    [253272] = MobInfo(9433, "C"),      -- Magram Necromancer
    [4639] = MobInfo(9428, "C"),        -- Magram Outrunner
    [4643] = MobInfo(9430, "C"),        -- Magram Pack Runner
    [4638] = MobInfo(2292, "C"),        -- Magram Scout
    [4642] = MobInfo(9431, "C"),        -- Magram Stormer
    [4641] = MobInfo(9429, "C"),        -- Magram Windchaser
    [4640] = MobInfo(2293, "C"),        -- Magram Wrangler
    [6070] = MobInfo(9438, "C"),        -- Maraudine Khan Advisor
    [6069] = MobInfo(9436, "C"),        -- Maraudine Khan Guard
    [4659] = MobInfo(9439, "C"),        -- Maraudine Marauder
    [4656] = MobInfo(9436, "C"),        -- Maraudine Mauler
    [11685] = MobInfo(9440, "C"),       -- Maraudine Priest
    [4654] = MobInfo(9434, "C"),        -- Maraudine Scout
    [4658] = MobInfo(9440, "C"),        -- Maraudine Stormer
    [4657] = MobInfo(9438, "C"),        -- Maraudine Windchaser
    [4655] = MobInfo(9435, "C"),        -- Maraudine Wrangler
    [11559] = MobInfo(9531, "C"),       -- Outcast Necromancer
    [13718] = MobInfo(9426, "C"),       -- The Nameless Prophet, Elite
    [5643] = MobInfo(3790, "C"),        -- Tyranis Malem
    [6068] = MobInfo(172, "C"),         -- Warug's Bodyguard

    -- Demons
    [4677] = MobInfo(5049, "C"),        -- Doomwarder
    [4680] = MobInfo(9015, "C"),        -- Doomwarder Captain
    [4673] = MobInfo(11331, "C"),       -- Hatefury Betrayer
    [4672] = MobInfo(2014, "C"),        -- Hatefury Felsworn
    [4675] = MobInfo(2014, "C"),        -- Hatefury Hellcaller
    [4670] = MobInfo(6741, "C"),        -- Hatefury Rogue
    [4674] = MobInfo(11332, "C"),       -- Hatefury Shadowstalker
    [4671] = MobInfo(2021, "C"),        -- Hatefury Trickster
    [14226] = MobInfo(14255, "C"),      -- Kaskk, Rare
    [4685] = MobInfo(6173, "S"),        -- Ley Hunter
    [5760] = MobInfo(4426, "C"),        -- Lord Azrethoc, Elite
    [4681] = MobInfo(6172, "S"),        -- Mage Hunter
    [4678] = MobInfo(1913, "S"),        -- Mana Eater
    [4679] = MobInfo(159, "C"),         -- Nether Maiden
    [4682] = MobInfo(2834, "C"),        -- Nether Sister
    [4684] = MobInfo(2737, "C"),        -- Nether Sorceress
    [14225] = MobInfo(6743, "C"),       -- Prince Kellen, Rare

    -- Giants
    [4686] = MobInfo(10043, "C"),       -- Deepstrider Giant, Elite
    [4687] = MobInfo(10039, "C"),       -- Deepstrider Searcher, Elite

    -- Undead
    [11687] = MobInfo(11639, "C"),      -- Ghostly Marauder
    [11686] = MobInfo(11638, "C"),      -- Ghostly Raider
    [11561] = MobInfo(11369, "C"),      -- Undead Ravager

    -- Dragonkin
    [5320] = MobInfo(12509, "S"),       -- Jademir Boughguard, Elite
})
