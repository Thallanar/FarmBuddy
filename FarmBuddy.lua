FarmTracker = {}
FarmTracker.sessionActive = false
FarmTracker.startTime = 0
FarmTracker.lootTable = {}

local frame = CreateFrame("Frame")
frame:RegisterEvent("LOOT_OPENED")

frame:SetScript("OnEvent", function(_, event) 
    if event == "LOOT_OPENED" and FarmTracker.sessionActive then
        local numLootItems = GetNumLootItems()
        for i = 1, numLootItems do
            local itemLink = GetLootSlotLink(i)
            if itemLink then
                local itemName = GetItemInfo(itemLink)
                local _, _, quantity = GetLootSlotInfo(i)

                quantity = quantity or 1

                FarmTracker.lootTable[itemName] = (FarmTracker.lootTable[itemName] or 0) + quantity
            end
        end
    end
end)

function FarmTracker:StartSession()
    self.sessionActive = true
    self.startTime = GetTime()
    self.lootTable = {}
    print("Sessão de farm iniciada")
end

function FarmTracker:StopSession()
    if not self.sessionActive then return end
    self.sessionActive = false
    local elapsed = GetTime() - self.startTime
    print("Sessão de farm encerrada. Tempo decorrido de: " .. math.floor(elapsed) .. " segundos")

    for item, count in pairs(self.lootTable) do
        print(item .. ": " .. count)
    end
end