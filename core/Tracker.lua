local mainUI = CreateFrame("Frame")
mainUI:RegisterEvent("LOOT_OPENED")

FarmTracker.sessionActive = false
FarmTracker.startTime = 0
FarmTracker.lootTable = {}

local function QualityToStars(quality)
    if quality == 1 then return "★"
    elseif quality == 2 then return "★★"
    elseif quality == 3 then return "★★★"
    else return ""
    end
end

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
                local itemName = GetItemInfo(itemLink)
                local _, _, quantity = GetLootSlotInfo(i)
                quantity = quantity or 1

                local itemID = tonumber(string.match(itemLink, "item:(%d+):"))
                local quality = select(3, GetItemInfo(itemLink))
                local stars = QualityToStars(quality)

                local key = itemName .. " [" .. stars .. "]"

                FarmTracker.lootTable[key] = (FarmTracker.lootTable[key] or 0) + quantity
            end
        end
    end
end)