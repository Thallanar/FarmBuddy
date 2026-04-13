-- =============================================================================
-- FarmBuddy - DisplayIDs: Eversong Woods
-- =============================================================================

local IDs = {
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
    [242982] = 127808,  -- Twilight Bruiser (Elite)
    [245939] = 127811,  -- Twilight Darkcaller (Elite)
    [242980] = 124906,  -- Twilight Death-Dealer (Elite)
}

for npcID, displayID in pairs(IDs) do
    FarmBuddyMobDisplayIDs[npcID] = displayID
end
