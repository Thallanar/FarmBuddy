local mainUI = CreateFrame("Frame")
mainUI:RegisterEvent("LOOT_OPENED")

FarmTracker = FarmTracker or {}
FarmTracker.name = "FarmBuddy"
FarmTracker.version = "0.1"
FarmTracker.sessionActive = false
FarmTracker.paused = false
FarmTracker.startTime = 0
FarmTracker.pauseStartTime = 0
FarmTracker.totalPausedTime = 0
FarmTracker.lootTable = FarmTracker.lootTable or {}

function FarmTracker:StartSession()
    self.sessionActive = true
    self.paused = false
    self.startTime = GetTime()
    self.totalPausedTime = 0
    self.lootTable = {}
end

function FarmTracker:StopSession()
    if not self.sessionActive then return end
    self.sessionActive = false
end

function FarmTracker:GetElapsedTime()
    if not self.sessionActive then
        return 0
    end

    local now = GetTime()
    if self.paused then
        return (self.pauseStartTime - self.startTime) - self.totalPausedTime
    else
        return (now - self.startTime) - self.totalPausedTime
    end
end

function FarmTracker:Pause()
    if not self.sessionActive or self.paused then
        return
    end

    self.paused = true
    self.pauseStartTime = GetTime()
end

function FarmTracker:Resume()
    if not self.sessionActive or not self.paused then 
        return 
    end

    local now = GetTime()
    self.totalPausedTime = self.totalPausedTime + (now - self.pauseStartTime)
    self.paused = false
end

function FarmTracker:isPaused()
    return self.paused    
end

local function IsFarmPaused()
    return FarmTracker.IsPaused and FarmTracker:IsPaused()
end

mainUI:SetScript("OnEvent", function(_, event) 
    if event == "LOOT_OPENED" and FarmTracker.sessionActive and not IsFarmPaused() then
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

