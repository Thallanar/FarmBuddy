-- =============================================================================
-- FarmBuddy - DisplayIDs: Harandar
-- =============================================================================

local IDs = {
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
}

for npcID, displayID in pairs(IDs) do
    FarmBuddyMobDisplayIDs[npcID] = displayID
end
