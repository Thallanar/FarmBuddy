-- =============================================================================
-- FarmBuddy - Alertas do limite de tempo (som, mensagem na tela, ícone)
-- =============================================================================

local L = FarmBuddyL

FarmBuddyAlerts = {}
local A = FarmBuddyAlerts

-- Sons nativos (SoundKit IDs, existem em todas as versões do cliente)
local BUILTIN_SOUNDS = {
    { key = "raid_warning", label = "Raid Warning", kit = 8959 },
    { key = "ready_check", label = "Ready Check", kit = 8960 },
    { key = "alarm_clock", label = "Alarm Clock", kit = 12889 },
    { key = "level_up", label = "Level Up", kit = 888 },
    { key = "quest_complete", label = "Quest Complete", kit = 878 },
    { key = "auction_bell", label = "Auction House Bell", kit = 5274 },
}

A.channels = {
    { value = "Master", label = "Master" },
    { value = "SFX", label = "Sound effects" },
    { value = "Dialog", label = "Dialog" },
    { value = "Ambience", label = "Ambience" },
}

function A:GetSettings()
    local profile = FarmTracker:GetProfile()
    profile.alerts = profile.alerts or {}
    local s = profile.alerts
    if s.sound == nil then s.sound = "raid_warning" end
    if s.channel == nil then s.channel = "Master" end
    if s.warnBefore == nil then s.warnBefore = true end
    if s.screenMessage == nil then s.screenMessage = true end
    if s.flashIcon == nil then s.flashIcon = false end
    return s
end

-- Lista de sons: nativos + LibSharedMedia (se instalado)
function A:GetSounds()
    local list = {}
    for _, snd in ipairs(BUILTIN_SOUNDS) do
        table.insert(list, { key = snd.key, label = L[snd.label], kit = snd.kit })
    end
    local LSM = LibStub and LibStub("LibSharedMedia-3.0", true)
    if LSM then
        for _, name in ipairs(LSM:List("sound") or {}) do
            local path = LSM:Fetch("sound", name, true)
            if path and name ~= "None" then
                table.insert(list, { key = "lsm:" .. name, label = name, file = path })
            end
        end
    end
    return list
end

function A:Play(key)
    local settings = self:GetSettings()
    key = key or settings.sound
    for _, snd in ipairs(self:GetSounds()) do
        if snd.key == key then
            if snd.kit then
                PlaySound(snd.kit, settings.channel)
            elseif snd.file then
                PlaySoundFile(snd.file, settings.channel)
            end
            return
        end
    end
end

local function ScreenMessage(text)
    if RaidNotice_AddMessage and RaidWarningFrame and ChatTypeInfo then
        RaidNotice_AddMessage(RaidWarningFrame, text, ChatTypeInfo["RAID_WARNING"])
    else
        UIErrorsFrame:AddMessage(text, 1, 0.82, 0)
    end
end

function A:WarnBefore(remaining)
    local s = self:GetSettings()
    if not s.warnBefore then return end
    local minutes = math.max(1, math.ceil(remaining / 60))
    local text = string.format(L["FarmBuddy: %d minutes left"], minutes)
    if s.screenMessage then ScreenMessage(text) end
    print("|cffffd100[FarmBuddy]|r " .. text)
    if FarmTracker:GetTimerSettings().soundAlert then self:Play() end
end

function A:LimitReached(playSound)
    local s = self:GetSettings()
    local text = L["FarmBuddy: time limit reached"]
    if s.screenMessage then ScreenMessage(text) end
    print("|cffffd100[FarmBuddy]|r " .. text)
    if playSound then self:Play() end
    if s.flashIcon and FlashClientIcon then FlashClientIcon() end
end
