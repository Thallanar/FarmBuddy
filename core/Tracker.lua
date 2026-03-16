local mainUI = CreateFrame("Frame")
mainUI:RegisterEvent("LOOT_OPENED")

FarmTracker = FarmTracker or {}
FarmTracker.name = "FarmBuddy"
FarmTracker.version = C_AddOns.GetAddOnMetadata("FarmBuddy", "Version")
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
    self.sessionStartDate = date("%Y-%m-%d %H:%M:%S")
    self.totalPausedTime = 0
    self.lootTable = {}
end

function FarmTracker:StopSession()
    if not self.sessionActive then return end

    -- Salva a sessão no histórico do profile
    local duration = self:GetElapsedTime()
    if duration > 0 and next(self.lootTable) then
        local profile = self:GetProfile()
        table.insert(profile.sessionHistory, {
            startTime = self.sessionStartDate or "desconhecido",
            duration = math.floor(duration),
            lootTable = CopyTable(self.lootTable),
        })
    end

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
    return FarmTracker.isPaused and FarmTracker:isPaused()
end

mainUI:SetScript("OnEvent", function(_, event) 
    if event == "LOOT_OPENED" and FarmTracker.sessionActive and not IsFarmPaused() then
        local numLootItems = GetNumLootItems()
        for i = 1, numLootItems do
            local itemLink = GetLootSlotLink(i)
            if itemLink then
                local itemName, _, itemQuality, _, _, itemType, itemSubType, _, _, iconTexture, _, _, _, bindType = C_Item.GetItemInfo(itemLink)
                local _, _, quantity = GetLootSlotInfo(i)
                quantity = quantity or 1

                local itemID = C_Item.GetItemInfoInstant(itemLink)
                local categoryGroup = FarmTracker:GetCategoryGroup(itemSubType)
                FarmTracker.lootTable[itemID] = FarmTracker.lootTable[itemID] or {
                    count = 0,
                    icon = iconTexture or "",
                    label = itemName or itemLink,
                    link = itemLink,
                    group = categoryGroup,
                    category = itemSubType,
                    bindType = bindType,
                }

                FarmTracker.lootTable[itemID].count = FarmTracker.lootTable[itemID].count + quantity

                -- Atualiza a exibição
                if DisplayItem and DisplayItem.UpdateDisplay then
                    DisplayItem:UpdateDisplay(FarmTracker.lootTable)
                end
            end
        end
    end
end)

