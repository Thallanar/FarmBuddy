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

-- History Button
local historyButton = CreateFrame("Button", nil, titleBar)
historyButton:SetSize(22, 22)
historyButton:SetPoint("RIGHT", closeButton, "LEFT", 1, 0)
historyButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

local historyIcon = historyButton:CreateTexture(nil, "ARTWORK")
historyIcon:SetPoint("CENTER", historyButton, "CENTER", 0, 0)
historyIcon:SetSize(18, 18)
historyIcon:SetTexture("Interface\\AddOns\\FarmBuddy\\icon\\history.png")

historyButton:SetScript("OnClick", function()
    if FarmBuddyHistory then
        FarmBuddyHistory:Toggle()
    end
end)

historyButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine("Histórico de Farm")
    GameTooltip:Show()
end)
historyButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-- Import Button
local importButton = CreateFrame("Button", nil, titleBar)
importButton:SetSize(22, 22)
importButton:SetPoint("RIGHT", historyButton, "LEFT", 1, 0)
importButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

local importIcon = importButton:CreateTexture(nil, "ARTWORK")
importIcon:SetPoint("CENTER", importButton, "CENTER", 0, 0)
importIcon:SetSize(18, 18)
importIcon:SetTexture("Interface\\AddOns\\FarmBuddy\\icon\\map.png")

importButton:SetScript("OnClick", function()
    if FarmBuddyImportManager then
        FarmBuddyImportManager:Toggle()
    end
end)

importButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine("Importar GatherMate2")
    GameTooltip:Show()
end)
importButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-- Settings Button
local settingsButton = CreateFrame("Button", nil, titleBar)
settingsButton:SetSize(22, 22)
settingsButton:SetPoint("RIGHT", importButton, "LEFT", 1, 0)
settingsButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

local settingsIcon = settingsButton:CreateTexture(nil, "ARTWORK")
settingsIcon:SetPoint("CENTER", settingsButton, "CENTER", 0, 0)
settingsIcon:SetSize(18, 18)
settingsIcon:SetTexture("Interface\\AddOns\\FarmBuddy\\icon\\gear.png")

settingsButton:SetScript("OnClick", function() 
    TrackerSettings:Toggle() 
end)

-- Interface do Botão de Pause:
local pauseButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
pauseButton:SetPoint("CENTER", f)
pauseButton:SetSize(120, 20)
pauseButton:SetText("Pausar")

-- Interface do Botão de Start:
local startButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
startButton:SetPoint("BOTTOM", pauseButton, "TOP", 0, 5)
startButton:SetSize(120, 20)
startButton:SetText("Iniciar")

-- Interface do Botão de Stop:
local stopButton = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
stopButton:SetPoint("TOP", pauseButton, "BOTTOM", 0, -5)
stopButton:SetSize(120, 20)
stopButton:SetText("Parar")

-- Atualiza estado dos botões conforme sessão
local function UpdateButtonStates()
    if FarmTracker.sessionActive then
        startButton:Disable()
        pauseButton:Enable()
        stopButton:Enable()
        if FarmTracker:isPaused() then
            pauseButton:SetText("Retomar")
        else
            pauseButton:SetText("Pausar")
        end
    else
        startButton:Enable()
        pauseButton:Disable()
        stopButton:Disable()
        pauseButton:SetText("Pausar")
    end
end

startButton:SetScript("OnClick", function()
    FarmTracker:StartSession()
    UpdateButtonStates()
end)

pauseButton:SetScript("OnClick", function()
    if FarmTracker:isPaused() then
        FarmTracker:Resume()
    else
        FarmTracker:Pause()
    end
    UpdateButtonStates()
end)

stopButton:SetScript("OnClick", function()
    FarmTracker:StopSession()
    UpdateButtonStates()
end)

-- Estado inicial: pause e stop desabilitados
UpdateButtonStates()

-- Tempo decorrido (FontString)
local timerText = f:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
timerText:SetPoint("TOP", stopButton, "BOTTOM", 0, -10)
timerText:SetText("Tempo: 00:00:00")

local updateInterval = 0
f:SetScript("OnUpdate", function(self, elapsed)
    if FarmTracker.sessionActive then
        updateInterval = updateInterval + elapsed
        if updateInterval >= 1 then
            local totalSeconds = math.floor(FarmTracker:GetElapsedTime())
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

-- Salva estado de visibilidade no profile
f:SetScript("OnShow", function()
    local profile = FarmTracker:GetProfile()
    profile.frameVisible = true
end)

f:SetScript("OnHide", function()
    local profile = FarmTracker:GetProfile()
    profile.frameVisible = false
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
