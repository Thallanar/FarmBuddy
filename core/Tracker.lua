local mainUI = CreateFrame("Frame")
mainUI:RegisterEvent("LOOT_OPENED")

FarmTracker = FarmTracker or {}
FarmTracker.name = "FarmBuddy"
FarmTracker.version = "0.1"
FarmTracker.sessionActive = false
FarmTracker.startTime = 0
FarmTracker.lootTable = FarmTracker.lootTable or {}

function FarmTracker:StartSession()
    self.sessionActive = true
    self.startTime = GetTime()
    self.lootTable = {}
end

function FarmTracker:StopSession()
    if not self.sessionActive then return end
    self.sessionActive = false
    local elapsed = GetTime() - self.startTime

    for item, count in pairs(self.lootTable) do
        print(item .. ": " .. count)
    end
end

mainUI:SetScript("OnEvent", function(_, event) 
    if event == "LOOT_OPENED" and FarmTracker.sessionActive then
        local numLootItems = GetNumLootItems()
        for i = 1, numLootItems do
            local itemLink = GetLootSlotLink(i)
            if itemLink then
                local itemName, _, itemQuality, _, _, itemType, itemSubType, _, _, iconTexture = GetItemInfo(itemLink)
                local _, _, quantity = GetLootSlotInfo(i)
                quantity = quantity or 1

                local itemID = GetItemInfoInstant(itemLink)
                local categoryGroup = FarmTracker:GetCategoryGroup(itemSubType)
                FarmTracker.lootTable[itemID] = FarmTracker.lootTable[itemID] or {
                    count = 0,
                    icon = iconTexture or "",
                    label = itemName or itemLink,
                    link = itemLink,
                    group = categoryGroup,
                    category = itemSubType,
                }

                FarmTracker.lootTable[itemID].count = FarmTracker.lootTable[itemID].count + quantity

                -- Atualiza a exibição
                if DisplayItem and DisplayItem.UpdateDisplay then
                    DisplayItem:UpdateDisplay(FarmTracker.lootTable)
                    DisplayItem:UpdateDisplay(FarmTracker.lootTable)
                end
            end
        end
    end
end)

