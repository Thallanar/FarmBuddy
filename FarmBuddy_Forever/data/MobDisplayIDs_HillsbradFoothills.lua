-- =============================================================================
-- FarmBuddy: Forever - DisplayIDs: Hillsbrad Foothills (Eastern Kingdoms)
-- =============================================================================
-- Formato: [npcID] = MobInfo(displayID, profissão),  -- Nome do mob[, Rare/Elite]
--   profissão: "S" esfolável, "C" dropa tecido, "SC" os dois, "" nenhum,
--              nil = pendente (o core usa a regra por tipo)
-- Fonte: Wowhead Forever (zone=267). displayID 0 = pendente: o mob aparece
-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.
-- =============================================================================

local MobInfo = FarmBuddyForever.MobInfo

FarmBuddyForever:RegisterZone("Hillsbrad Foothills", {
    -- Beasts
    [14280] = MobInfo(706, "S"),        -- Big Samras, Rare
    [277881] = MobInfo(149118, "S"),    -- Bloodwing Bat
    [2356] = MobInfo(3201, "S"),        -- Elder Gray Bear
    [2385] = MobInfo(1056, "S"),        -- Feral Mountain Lion
    [2351] = MobInfo(806, "S"),         -- Gray Bear
    [2559] = MobInfo(11316, "S"),       -- Highland Strider
    [2407] = MobInfo(2300, "S"),        -- Hulking Mountain Lion
    [2406] = MobInfo(1058, "S"),        -- Mountain Lion
    [2408] = MobInfo(1244, "S"),        -- Snapjaw
    [2384] = MobInfo(1059, "S"),        -- Starving Mountain Lion
    [2354] = MobInfo(1007, "S"),        -- Vicious Gray Bear
    [2347] = MobInfo(1149, "S"),        -- Wild Gryphon

    -- Humanoids
    [2248] = MobInfo(3206, "S"),        -- Cave Yeti
    [2403] = MobInfo(3620, "C"),        -- Farmer Getz
    [2249] = MobInfo(3207, "S"),        -- Ferocious Yeti
    [2305] = MobInfo(3635, "C"),        -- Foreman Bonds
    [2427] = MobInfo(3625, "C"),        -- Jailor Eston
    [2428] = MobInfo(3626, "C"),        -- Jailor Marlgen
    [266216] = MobInfo(144743, "C"),    -- Lord Tomas
    [2450] = MobInfo(3645, "C"),        -- Miner Hackett
    [2372] = MobInfo(10643, "C"),       -- Mudsnout Gnoll
    [2373] = MobInfo(662, "C"),         -- Mudsnout Shaman
    [14278] = MobInfo(491, "C"),        -- Ro'Bark, Rare
    [2434] = MobInfo(3627, "C"),        -- Shadowy Assassin
    [2240] = MobInfo(3706, "C"),        -- Syndicate Footpad
    [2260] = MobInfo(3616, "C"),        -- Syndicate Rogue
    [2244] = MobInfo(3621, "C"),        -- Syndicate Shadow Mage
    [2241] = MobInfo(3709, "C"),        -- Syndicate Thief
    [2261] = MobInfo(3623, "C"),        -- Syndicate Watchman

    -- Undead
    [7068] = MobInfo(5828, "C"),        -- Condemned Acolyte, Elite
    [7070] = MobInfo(5824, "C"),        -- Condemned Cleric, Elite
    [7069] = MobInfo(5822, "C"),        -- Condemned Monk, Elite
    [7072] = MobInfo(5820, "C"),        -- Cursed Justicar, Elite
    [7071] = MobInfo(5816, "C"),        -- Cursed Paladin, Elite
    [7075] = MobInfo(5814, "C"),        -- Writhing Mage, Elite

    -- Dragonkin
    [2447] = MobInfo(6371, "S"),        -- Narillasanz, Rare-Elite
})
