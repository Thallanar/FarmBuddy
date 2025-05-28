local mainUI = CreateFrame("Frame")
mainUI:RegisterEvent("LOOT_OPENED")

FarmTracker = {}
FarmTracker.sessionActive = false
FarmTracker.startTime = 0
FarmTracker.lootTable = {}

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
                local itemName, _, itemQuality, _, _, _, _, _, _, iconTexture = GetItemInfo(itemLink)
                local _, _, quantity = GetLootSlotInfo(i)
                quantity = quantity or 1

                -- Usa o itemLink como chave para garantir separação por qualidade (ícone incluso)
                FarmTracker.lootTable[itemLink] = FarmTracker.lootTable[itemLink] or {
                    count = 0,
                    icon = iconTexture or "",
                    label = itemName or itemLink,
                    link = itemLink
                }

                FarmTracker.lootTable[itemLink].count = FarmTracker.lootTable[itemLink].count + quantity

                -- Atualiza a exibição
                if DisplayItem and DisplayItem.UpdateDisplay then
                    DisplayItem:UpdateDisplay(FarmTracker.lootTable)
                    DisplayItem:UpdateDisplay(FarmTracker.lootTable)
                end
            end
        end
    end
end)