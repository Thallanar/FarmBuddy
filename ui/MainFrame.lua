local f = CreateFrame("Frame", "FarmTrackerFrame", UIParent, "BasicFrameTemplateWithInset")
f:SetSize(200, 120)
f:SetPoint("CENTER")
f:SetMovable(true)
f:EnableMouse(true)
f:RegisterForDrag("LeftButton")
f:SetScript("OnDragStart", f.StartMoving)
f:SetScript("OnDragStop", f.StopMovingOrSizing)

f.title = f:CreateFontString(nil, "OVERLAY")
f.title:SetFontObject("GameFontHighlight")
f.title:SetPoint("LEFT", f.TitleBg, "LEFT", 5, 0)
f.title:SetText("Farm Buddy")

FarmTracker.frame = f -- Referência global

local success, err = pcall(function()
    if DisplayItem and DisplayItem.Init then
        DisplayItem:Init(f)
    end
end)

if not success then
    print("Erro ao inicializar DisplayItem:", err)
end

-- Settings
local settingsButton = CreateFrame("Button", nil, f)
settingsButton:SetSize(24, 24)
settingsButton:SetPoint("RIGHT", f.CloseButton, "LEFT", -4, 0)

-- Fundo do botão (hover e clique suave, sem template complexo)
settingsButton:SetNormalTexture("Interface\\Buttons\\UI-Quickslot2")
settingsButton:SetPushedTexture("Interface\\Buttons\\UI-Quickslot-Depress")
settingsButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

local gearIcon = settingsButton:CreateTexture(nil, "ARTWORK")
gearIcon:SetTexture("Interface\\AddOns\\FarmBuddy\\Media\\gear.tga") -- ou outro ícone
gearIcon:SetAllPoints()
gearIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

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
startButton:SetPoint("TOP", f, "TOP", 0, -40)
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

print("MainFrame carregado")
