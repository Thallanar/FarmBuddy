local f = CreateFrame("Frame", "FarmTrackerFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
f:SetSize(240, 160)
f:SetPoint("CENTER")
f:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", f.StartMoving)
f:SetScript("OnDragStop", f.StopMovingOrSizing)

-- TítleBar
local titleBar = CreateFrame("Frame", nil, f)
titleBar:SetSize(f:GetWidth(), 24)
titleBar:SetPoint("TOP", f, "TOP", 0, -6)

-- Title
local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetText("Farm Buddy")
titleText:SetPoint("LEFT", 15, 0)

FarmTracker.frame = f -- Referência global

local success, err = pcall(function()
    if DisplayItem and DisplayItem.Init then
        DisplayItem:Init(f)
    end
end)

--Close Button
local closeButton = CreateFrame("Button", nil, titleBar)
closeButton:SetSize(24, 24)
closeButton:SetPoint("RIGHT", -8, 0)
closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

local closeIcon = closeButton:CreateTexture(nil, "ARTWORK")
closeIcon:SetAllPoints()
closeIcon:SetTexture("Interface\\AddOns\\FarmBuddy\\icon\\close.png")  -- Ícone de "X" visual

closeButton:SetScript("OnClick", function() 
    f:Hide() 
end)

-- Settings Button
local settingsButton = CreateFrame("Button", nil, titleBar)
settingsButton:SetSize(22, 22)
settingsButton:SetPoint("RIGHT", closeButton, "LEFT", 1, 0)
settingsButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

local settingsIcon = settingsButton:CreateTexture(nil, "ARTWORK")
settingsIcon:SetPoint("CENTER", settingsButton, "CENTER", 0, 0)
settingsIcon:SetSize(18, 18)
settingsIcon:SetTexture("Interface\\AddOns\\FarmBuddy\\icon\\gear.png")

settingsButton:SetScript("OnClick", function() 
    TrackerSettings:Toggle() 
end)


-- Tempo decorrido (FontString)
local timerText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
timerText:SetPoint("BOTTOM", f, "BOTTOM", 0, 10)
timerText:SetText("Tempo: 00:00:00")

local updateInterval = 0
f:SetScript("OnUpdate", function(self, elapsed)
    if FarmTracker.sessionActive then
        updateInterval = updateInterval + elapsed
        if updateInterval >= 1 then
            local totalSeconds = math.floor(GetTime() - FarmTracker.startTime)
            local hours = math.floor(totalSeconds / 3600)
            local minutes = math.floor((totalSeconds % 3600) / 60)
            local seconds = totalSeconds % 60
            timerText:SetText(string.format("Tempo: %02d:%02d:%02d", hours, minutes, seconds))
            updateInterval = 0
        end
    else
        timerText:SetText("Tempo: 00:00:00")
    end
end)

-- Interface do Botão de Start: 
local startButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
startButton:SetPoint("CENTER", f, "CENTER")
startButton:SetSize(120, 20)
startButton:SetText("Iniciar")
startButton:SetScript("OnClick", function()
    FarmTracker:StartSession()
end)

-- Interface do Botão de Stop:
local stopButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
stopButton:SetPoint("TOP", startButton, "BOTTOM", 0, -10)
stopButton:SetSize(120, 20)
stopButton:SetText("Parar")
stopButton:SetScript("OnClick", function()
    FarmTracker:StopSession()
end)

f:Hide()
SLASH_FARMBUDDY1 = "/farmbuddy"
SlashCmdList["FARMBUDDY"] = function()
    if f:IsShown() then
        f:Hide()
    else
        f:Show()
    end
end
