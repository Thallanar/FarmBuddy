-- =============================================================================
-- FarmBuddy - DisplayIDs: Harandar
-- =============================================================================

local IDs = {
    -- Beasts
    [242773] = 109505,  -- Agitated Rootbat
    [250183] = 131469,  -- Bloated Drifter
    [240113] = 131468,  -- Delectable Root Drifter
    [256810] = 131465,  -- Drifting Sporepuff
    [256246] = 125191,  -- Fungal Sporewing
    [254215] = 131472,  -- Grazing Root Drifter
    [250168] = 125189,  -- Latticewing Sporeglider
    [260031] = 125189,  -- Latticewing Sporeglider
    [239744] = 125218,  -- Pangquill Reminiscence
    [239668] = 127673,  -- Razorquill Remembrance
    [237258] = 109505,  -- Rock Sporebat
    [256387] = 131466,  -- Rotting Sporedrifter
    [256061] = 125191,  -- Scavenging Sporeglider
    [250182] = 131465,  -- Sporecloud Drifter
    [256385] = 131470,  -- Swollen Sporepuff
    [256357] = 125189,  -- Vale Sporeglider
    [256381] = 125189,  -- Vale Sporeglider
    [251525] = 131470,  -- Dri'hara (Elite)
    [245690] = 125989,  -- Lumenfin (Elite)
    [248741] = 15869,   -- Rhazul (Rare)
    [249849] = 125988,  -- Ha'kalawe (Rare)
    [249844] = 136899,  -- Chironex (Rare)
    [250180] = 115119,  -- Serrasa (Rare)
    [250321] = 109505,  -- Pterrock (Rare)
    
    -- Humanoids (novos)
    [237692] = 127756,  -- Lattice Elder Root
    [237161] = 127782,  -- Lattice Mistcaller
    [237642] = 127764,  -- Lattice Thornguard
    [237644] = 127764,  -- Lattice Thornguard
    [237545] = 127946,  -- Lightblinded Grovewarden
    [237547] = 127944,  -- Lightblinded Mistcaller
    [237546] = 127944,  -- Lightblinded Sap Spinner
    [237582] = 127945,  -- Lightblinded Sap Weaver
    [237498] = 127940,  -- Lightblinded Thornguard
    [260289] = 127940,  -- Lightblinded Thornguard
    [240344] = 127946,  -- Lightbloom Grovewarden
    [240457] = 127946,  -- Lightbloom Grovewarden
    [240656] = 127944,  -- Lightbloom Sap Weaver
}

for npcID, displayID in pairs(IDs) do
    FarmBuddyMobDisplayIDs[npcID] = displayID
end
