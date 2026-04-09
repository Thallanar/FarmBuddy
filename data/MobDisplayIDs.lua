-- =============================================================================
-- FarmBuddy - Tabela de DisplayIDs de Mobs
-- =============================================================================
-- Lookup rápido: npcID → displayID para renderizar portraits no mapa.
-- Dados extraídos do Wowhead. Quando o npcID não está nesta tabela,
-- o addon usa ícone genérico por tipo de criatura (Beast/Humanoid/Dragonkin).
--
-- Para adicionar novos mobs:
--   1. Abra wowhead.com/npc=NPCID
--   2. No model viewer, encontre o displayID
--   3. Adicione a entrada: [NPCID] = DISPLAYID,
-- =============================================================================

FarmBuddyMobDisplayIDs = {

    -- =====================================================================
    -- Eversong Woods
    -- =====================================================================

    -- Beasts
    [238089] = 124934,  -- Territorial Dragonhawk
    [253939] = 131956,  -- Springpaw Lynx
    [243171] = 125357,  -- Gloombelly Toad
    [250030] = 124012,  -- Ghostfeather Dragonhawk
    [250035] = 131993,  -- Ghostclaw Lynx
    [256843] = 129979,  -- Glistening Hawkstrider
    [256841] = 129979,  -- Resplendent Hawkstrider
    [256862] = 129979,  -- Brilliant Hawkstrider
    [237407] = 129979,  -- Displaced Hawkstrider
    [246633] = 130084,  -- Harried Hawkstrider (Rare)
    [255302] = 136093,  -- Duskburn (Rare, Serpent)
    [245688] = 124943,  -- Gloomclaw (Rare, Lynx)
    [252526] = 125033,  -- Yoked Pangolin (Rare)
    [249959] = 136083,  -- Arcane Wyrm
    [250026] = 136083,  -- Arcane Manathirster
    [253985] = 124016,  -- Bloodfeather Dragonhawk
    [253950] = 124934,  -- Crimson Bloodfeather
    [247553] = 103364,  -- Daggerspine Snapdragon
    [254690] = 114976,  -- Elder Mournbat
    [246365] = 131956,  -- Encroaching Lynx
    [242521] = 136083,  -- Encroaching Mana Wyrm
    [250043] = 719,     -- Eversong Mauler
    [250038] = 136159,  -- Ghostclaw Elder
    [254363] = 131993,  -- Ghostclaw Lynx
    [254610] = 124929,  -- Ghostfeather Alpha
    [254313] = 124012,  -- Ghostfeather Dragonhawk
    [250047] = 114968,  -- Ghostwing Bat
    [250048] = 114961,  -- Ghostwing Screecher
    [245900] = 114964,  -- Giant Bat
    [254732] = 114972,  -- Giant Duskwing
    [256844] = 129979,  -- Gleaming Hawkstrider
    [256836] = 129979,  -- Glistening Hawkstrider
    [254628] = 124217,  -- Mountain Rocktalon
    [245897] = 122176,  -- Nether Ray
    [242227] = 242227,  -- Nightshade Flutterer
    [250044] = 33920,   -- Rageclaw Matriarch
    [256835] = 129979,  -- Refulgent Hawkstrider
    [256834] = 129979,  -- Resplendent Hawkstrider
    [254631] = 124969,  -- Rocktalon Scavenger
    [256857] = 132017,  -- Roving Springrunner
    [256858] = 132017,  -- Skittish Springrunner
    [250037] = 131957,  -- Springclaw Elder
    [250033] = 131956,  -- Springpaw Lynx
    [252837] = 129338,  -- Sunset Doe
    [252836] = 137596,  -- Sunset Stag
    [242226] = 124952,  -- Underbrush Prowler
    [249421] = 114962,  -- Venomous Mournbat
    [247504] = 33920,   -- Wandering Mauler
    [247505] = 131993,  -- Wandering Stalker
    [250826] = 136563,  -- Banuran (Rare)
    [250582] = 106511,  -- Bloated Snapdragon (Rare)
    [255348] = 138806,  -- Dame Bloodshed (Rare)
    [250876] = 136539,  -- Terrinor (Rare)

    -- Humanoids
    [250683] = 66815,   -- Coralfang
    [250719] = 131678,  -- Cre'van (Rare)
    [250841] = 130603,  -- Bad Zed (Rare)

    -- Humanoids (displayID pendente - preencher via Wowhead)
    [244031] = 130714,  -- Amani Battlerager
    [236374] = 130720,  -- Amani Enforcer
    [236372] = 130714,  -- Amani Feller
    [237428] = 130714,  -- Amani Grunt
    [237429] = 130732,  -- Amani Spiritwarden
    [236616] = 130720,  -- Amani Towerbreaker
    [237344] = 130755,  -- Amani Watcher
    [244044] = 91647,   -- Blackfathom Siren
    [236369] = 127945,  -- Bloom Dominator
    [236367] = 127944,  -- Bloom Propagator
    [244434] = 125690,  -- Cultist Ambusher
    [247966] = 91647,   -- Daggerspine Infuser
    [247551] = 138674,  -- Daggerspine Myrmidon
    [242976] = 127813,  -- Darkness Evoker
    [244046] = 91621,   -- Encroaching Scalemaster
    [249301] = 130755,  -- Forest Forager
    [242972] = 127813,  -- Heavy Caster
    [244038] = 130755,  -- Invading Lynxhunter
    [241549] = 127940,  -- Invasive Lightblade
    [237479] = 127944,  -- Lash'ra Mistcaller
    [237478] = 127940,  -- Lash'ra Thornguard
    [241574] = 127944,  -- Lightblessed Invader
    [237394] = 127940,  -- Lightblinded Rutaani Grovewarden
    [240991] = 127940,  -- Lightfueled Defender
    [240981] = 127944,  -- Lightfused Leafmancer
    [236368] = 127940,  -- Radiant Ruiner
    [248801] = 125034,  -- Twilight Agent
    [242970] = 125465,  -- Twilight Blade
    [248797] = 127694,  -- Twilight Bonebreaker
    [248800] = 124885,  -- Twilight Crystal Seer
    [249186] = 129798,  -- Twilight Disruptor
    [245941] = 124885,  -- Twilight Initiate
    [242971] = 124885,  -- Twilight Shadecaster
    [248798] = 127813,  -- Twilight Voidcaster
    [236627] = 125463,  -- Twilight's Blade Adherent
    [236628] = 137592,  -- Twilight's Blade Recruit
    [246115] = 125034,  -- Twilight's Blade Spy
    [249965] = 131704,  -- Vilebranch Stalker
    [245940] = 124904,  -- Voidstruck Executioner
    [250780] = 115149,  -- Waverly (Rare)
    [244040] = 130726,  -- Amani Bearserker (Elite)
    [244043] = 125473,  -- Blackfathom Destroyer (Elite)
    [242979] = 124892,  -- Dark Caller (Elite)
    [242978] = 127811,  -- Death Caster (Elite)
    [244432] = 130796,  -- Hal'nok the Trampler (Elite)
    [246955] = 0,  -- Lamyne of the Undercroft (Elite)
    [246976] = 0,  -- Lost Theldrin (Elite)
    [246938] = 0,  -- Nexus-Edge Hadim (Elite)
    [246979] = 0,  -- Neydra the Starving (Elite)
    [246952] = 0,  -- Petyoll the Razorleaf (Elite)
    [259048] = 0,  -- Seladine (Elite)
    [246927] = 0,  -- Senior Tinker Ozwold (Elite)
    [246944] = 0,  -- The Talon of Jan'alai (Elite)
    [246946] = 0,  -- The Wing of Akil'zon (Elite)
    [246982] = 0,  -- Thorn-Witch Liset (Elite)
    [246981] = 0,  -- Thornspeaker Edgath (Elite)
    [242982] = 0,  -- Twilight Bruiser (Elite)
    [245939] = 0,  -- Twilight Darkcaller (Elite)
    [242980] = 0,  -- Twilight Death-Dealer (Elite)
    [242913] = 0,  -- Vael'thas Dawnsoar (Elite)
    [246975] = 0,  -- Vylenna the Defector (Elite)
    [246942] = 0,  -- Zadu, Fist of Nalorakk (Elite)

    -- =====================================================================
    -- Zul'Aman
    -- =====================================================================

    -- Beasts
    [242035] = 124479,  -- The Devouring Invader (Rare, Ray)
    [242024] = 136483,  -- The Snapping Scourge (Rare, Lizard)
    [242028] = 129847,  -- Lightwood Borer (Rare, Wasp)
    [242032] = 131356,  -- Oophaga (Rare, Hopper)
    [242034] = 129849,  -- Voidtouched Crustacean (Rare, Crab)
    [245691] = 129470,  -- The Decaying Diamondback (Rare-Elite, Serpent)

    -- Humanoids
    [254726] = 130754,  -- Fallen Amani Scout
    [242025] = 129831,  -- Skullcrusher Harak (Rare)
    [245975] = 125385,  -- Mrrlokk (Rare)
    [247976] = 136081,  -- Poacher Rav'ik (Rare)
    [242026] = 129833,  -- Elder Oaktalon (Rare)
    [245692] = 137850,  -- Ash'an the Empowered (Rare-Elite)

    -- =====================================================================
    -- Harandar
    -- =====================================================================

    -- Beasts
    [251569] = 128671,  -- Grimlynx
    [252189] = 128673,  -- Har'athir Grimlynx
    [251627] = 128675,  -- Swift Grimlynx
    [248741] = 15869,   -- Rhazul (Rare)
    [249849] = 125988,  -- Ha'kalawe (Rare, Sporebat)
    [249844] = 136899,  -- Chironex (Rare)
    [250180] = 115119,  -- Serrasa (Rare)
    [250321] = 109505,  -- Pterrock (Rare, Ray)
    [250226] = 142224,  -- Mindrot (Rare, Water Strider)

    -- =====================================================================
    -- Voidstorm
    -- =====================================================================

    -- Beasts
    [238476] = 125833,  -- Vicious Karion
    [235413] = 80502,   -- Territorial Netherwasp
    [238498] = 138725,  -- Territorial Voidscythe (Rare)
    [245044] = 66132,   -- Nightbrood (Rare, Wasp)
    [256770] = 131609,  -- Bilemaw the Gluttonous (Rare)
    [241443] = 127478,  -- Tremora (Rare)
    [256923] = 139866,  -- Bane of the Vilebloods (Rare, Blood Beast)
    [256922] = 136432,  -- Screammaxa the Matriarch (Rare)
    [256808] = 142956,  -- Ravengerus (Rare-Elite)
    [257027] = 136199,  -- Rakshur the Bonegrinder (Rare)
    [255549] = 115073,  -- Netherwasp Drone
    [240227] = 125792,  -- Voidstalker Patriarch
    [247101] = 138723,  -- Netherscythe (Elite, Lure)

    -- Humanoids
    [256925] = 139930,  -- Lotus Darkblossom (Rare)
    [256821] = 139841,  -- Far'thana the Mad (Rare-Elite)
}
