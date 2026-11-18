local mainUI = CreateFrame("Frame")
mainUI:RegisterEvent("LOOT_OPENED")

FarmTracker = FarmTracker or {}
FarmTracker.name = "FarmBuddy"
FarmTracker.version = (C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata)("FarmBuddy", "Version")
FarmTracker.sessionActive = false
FarmTracker.paused = false
FarmTracker.startTime = 0
FarmTracker.pauseStartTime = 0
FarmTracker.totalPausedTime = 0
FarmTracker.lootTable = FarmTracker.lootTable or {}

-- Ouvintes de mudança de estado da sessão (UI)
local stateListeners = {}
function FarmTracker:OnStateChanged(callback)
    table.insert(stateListeners, callback)
end

function FarmTracker:FireStateChanged()
    for _, cb in ipairs(stateListeners) do
        pcall(cb)
    end
end

-- Configuração do timer (por personagem)
function FarmTracker:GetTimerSettings()
    local profile = self:GetProfile()
    profile.timer = profile.timer or {}
    local t = profile.timer
    if t.freeMode == nil then t.freeMode = false end
    if t.limit == nil then t.limit = 0 end
    if t.stopAtEnd == nil then t.stopAtEnd = true end
    if t.soundAlert == nil then t.soundAlert = true end
    return t
end

-- Limite efetivo em segundos (nil = sem limite / modo livre)
function FarmTracker:GetConfiguredLimit()
    local t = self:GetTimerSettings()
    if t.freeMode or (t.limit or 0) <= 0 then
        return nil
    end
    return t.limit
end

-- Limite da sessão em andamento (fixado no Start)
function FarmTracker:GetSessionLimit()
    return self.sessionActive and self.sessionLimit or nil
end

local limitTicker

local function CheckTimeLimit()
    local self = FarmTracker
    if not self.sessionActive or self.paused or not self.sessionLimit then return end

    local elapsed = self:GetElapsedTime()
    local remaining = self.sessionLimit - elapsed

    if not self.warnedBefore and remaining <= 300 and remaining > 0 and self.sessionLimit > 300 then
        self.warnedBefore = true
        if FarmBuddyAlerts then FarmBuddyAlerts:WarnBefore(remaining) end
    end

    if not self.limitReached and remaining <= 0 then
        self.limitReached = true
        local timer = self:GetTimerSettings()
        if FarmBuddyAlerts then FarmBuddyAlerts:LimitReached(timer.soundAlert) end
        if timer.stopAtEnd then
            self:StopSession()
        end
        self:FireStateChanged()
    end
end

function FarmTracker:StartSession()
    self.sessionActive = true
    self.paused = false
    self.startTime = GetTime()
    self.sessionStartDate = date("%Y-%m-%d %H:%M:%S")
    self.sessionStartTimestamp = time()
    self.totalPausedTime = 0
    self.lootTable = {}

    -- Modo e limite ficam fixos durante a sessão
    self.sessionLimit = self:GetConfiguredLimit()
    self.sessionMode = self.sessionLimit and "limit" or "free"
    self.warnedBefore = false
    self.limitReached = false

    if limitTicker then limitTicker:Cancel() end
    limitTicker = C_Timer.NewTicker(1, CheckTimeLimit)

    if DisplayItem and DisplayItem.UpdateDisplay then
        DisplayItem:UpdateDisplay(self.lootTable)
    end
    self:FireStateChanged()
end

function FarmTracker:StopSession()
    if not self.sessionActive then return end

    -- Salva a sessão no histórico do profile
    local duration = self:GetElapsedTime()
    if duration > 0 and next(self.lootTable) then
        local profile = self:GetProfile()
        local session = {
            startTime = self.sessionStartDate or FarmBuddyL["Unknown"],
            startTimestamp = self.sessionStartTimestamp,
            duration = math.floor(duration),
            mode = self.sessionMode,
            limit = self.sessionLimit,
            lootTable = CopyTable(self.lootTable),
        }
        -- Congela os preços no momento da conclusão
        self:FreezeSessionValue(session)
        table.insert(profile.sessionHistory, session)
    end

    self.sessionActive = false
    self.paused = false
    self.lastSessionDuration = math.floor(duration)
    if limitTicker then
        limitTicker:Cancel()
        limitTicker = nil
    end
    self:FireStateChanged()
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
    self:FireStateChanged()
end

function FarmTracker:Resume()
    if not self.sessionActive or not self.paused then 
        return 
    end

    local now = GetTime()
    self.totalPausedTime = self.totalPausedTime + (now - self.pauseStartTime)
    self.paused = false
    self:FireStateChanged()
end

function FarmTracker:isPaused()
    return self.paused    
end

local function IsFarmPaused()
    return FarmTracker.isPaused and FarmTracker:isPaused()
end

local SafeGetItemInfo = C_Item and C_Item.GetItemInfo or GetItemInfo
local SafeGetItemInfoInstant = C_Item and C_Item.GetItemInfoInstant or GetItemInfoInstant

mainUI:SetScript("OnEvent", function(_, event)
    if event == "LOOT_OPENED" and FarmTracker.sessionActive and not IsFarmPaused() then
        local numLootItems = GetNumLootItems()
        for i = 1, numLootItems do
            local itemLink = GetLootSlotLink(i)
            if itemLink then
                local itemName, _, itemQuality, _, _, itemType, itemSubType, _, _, iconTexture, _, _, _, bindType = SafeGetItemInfo(itemLink)
                local _, _, quantity = GetLootSlotInfo(i)
                quantity = quantity or 1

                local itemID, _, _, _, _, classID, subclassID = SafeGetItemInfoInstant(itemLink)
                if itemID then
                    -- Usa classID/subclassID para categoria (independente de idioma)
                    local englishSubType = FarmTracker:GetEnglishSubType(classID, subclassID) or itemSubType
                    local categoryGroup = FarmTracker:GetCategoryGroup(englishSubType)
                    FarmTracker.lootTable[itemID] = FarmTracker.lootTable[itemID] or {
                        count = 0,
                        icon = iconTexture or "",
                        label = itemName or itemLink,
                        link = itemLink,
                        group = categoryGroup,
                        category = englishSubType,
                        bindType = bindType,
                        quality = itemQuality,
                    }

                    FarmTracker.lootTable[itemID].count = FarmTracker.lootTable[itemID].count + quantity

                    -- Atualiza a exibição
                    if DisplayItem and DisplayItem.UpdateDisplay then
                        DisplayItem:UpdateDisplay(FarmTracker.lootTable)
                    end
                end
            end
        end
    end
end)

