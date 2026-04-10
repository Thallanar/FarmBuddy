-- =============================================================================
-- FarmBuddy - DisplayIDs: Zul'Aman
-- =============================================================================

local IDs = {
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
}

for npcID, displayID in pairs(IDs) do
    FarmBuddyMobDisplayIDs[npcID] = displayID
end
