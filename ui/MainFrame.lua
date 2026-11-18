-- =============================================================================
-- FarmBuddy - Janela principal
-- =============================================================================
-- Header (mapa de mobs, histórico, configurações, fechar), blocos de resumo,
-- lista de loot e um rodapé com duas abas: Timer e Time limit.
-- =============================================================================

local L = FarmBuddyL
local T = FarmBuddyTheme

local WIDTH, HEIGHT = 380, 560
local FOOTER_H = 206
local ICON_PATH = "Interface\\AddOns\\FarmBuddy\\icon\\"

-- Janela principal fica aberta durante o farm: ESC e o mapa não a fecham
local f = T:CreateWindow("FarmTrackerFrame", WIDTH, HEIGHT, "FarmBuddy", true)
FarmTracker.frame = f

-- -----------------------------------------------------------------------------
-- Header
-- -----------------------------------------------------------------------------
local divider = T:CreateHeaderDivider(f.header)
divider:SetPoint("RIGHT", f.closeButton, "LEFT", -5, 0)

local settingsButton = T:CreateIconButton(f.header, ICON_PATH .. "gear.png", 26, 18, L["Settings"])
settingsButton:SetPoint("RIGHT", divider, "LEFT", -5, 0)
settingsButton:SetScript("OnClick", function()
    if TrackerSettings and TrackerSettings.Toggle then TrackerSettings:Toggle() end
end)

local historyButton = T:CreateIconButton(f.header, ICON_PATH .. "history.png", 26, 18, L["Farm History"])
historyButton:SetPoint("RIGHT", settingsButton, "LEFT", -2, 0)
historyButton:SetScript("OnClick", function()
    if FarmBuddyHistory then FarmBuddyHistory:Toggle() end
end)

local mobMapButton = T:CreateIconButton(f.header, "Interface\\Icons\\Ability_Druid_PrimalPrecision", 26, 18,
    L["Mob Map"], L["Skinning & Tailoring"])
mobMapButton.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
mobMapButton:SetPoint("RIGHT", historyButton, "LEFT", -2, 0)
mobMapButton:SetScript("OnClick", function()
    if FarmBuddyMapPreview and FarmBuddyMobTracker then
        FarmBuddyMapPreview:Show(nil, "mobs")
    end
end)

-- -----------------------------------------------------------------------------
-- Blocos de resumo
-- -----------------------------------------------------------------------------
local body = f.body
local statW = (WIDTH - 4 - 24 - 12) / 3

local statItems = T:CreateStatBox(body, L["Items"])
statItems:SetSize(statW, 50)
statItems:SetPoint("TOPLEFT", 12, -12)

local statValue = T:CreateStatBox(body, L["Est. value"])
statValue:SetSize(statW, 50)
statValue:SetPoint("LEFT", statItems, "RIGHT", 6, 0)

local statRate = T:CreateStatBox(body, L["Gold / hour"])
statRate:SetSize(statW, 50)
statRate:SetPoint("LEFT", statValue, "RIGHT", 6, 0)

-- -----------------------------------------------------------------------------
-- Lista de loot
-- -----------------------------------------------------------------------------
local listPanel = T:CreatePanel(body, "panel", "borderDim")
listPanel:SetPoint("TOPLEFT", 12, -72)
listPanel:SetPoint("BOTTOMRIGHT", -12, FOOTER_H + 10)

if DisplayItem and DisplayItem.Init then
    DisplayItem:Init(listPanel)
end

-- -----------------------------------------------------------------------------
-- Rodapé
-- -----------------------------------------------------------------------------
local footer = CreateFrame("Frame", nil, body, BackdropTemplateMixin and "BackdropTemplate")
footer:SetPoint("BOTTOMLEFT")
footer:SetPoint("BOTTOMRIGHT")
footer:SetHeight(FOOTER_H)
footer:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
T:Register(footer, function(fr) fr:SetBackdropColor(T:Color("header")) end)
local footerLine = T:CreateColorTexture(footer, "borderMid", "BORDER")
footerLine:SetPoint("TOPLEFT")
footerLine:SetPoint("TOPRIGHT")
footerLine:SetHeight(1)

local timerPage = CreateFrame("Frame", nil, footer)
timerPage:SetAllPoints()
local limitPage = CreateFrame("Frame", nil, footer)
limitPage:SetAllPoints()

-- ---------------------------- Aba Timer --------------------------------------
-- Conteúdo centralizado verticalmente no rodapé
local timerBlock = CreateFrame("Frame", nil, timerPage)
timerBlock:SetSize(WIDTH - 28, 120)
timerBlock:SetPoint("CENTER", 0, 0)

local statusDot = T:CreateColorTexture(timerBlock, "muted", "OVERLAY")
statusDot:SetSize(8, 8)
statusDot:SetPoint("TOPLEFT", 0, -4)

local statusText = T:CreateText(timerBlock, 12, "muted")
statusText:SetPoint("LEFT", statusDot, "RIGHT", 7, 0)

local elapsedText = T:CreateText(timerBlock, 30, "accent")
elapsedText:SetPoint("TOPLEFT", 0, -24)
elapsedText:SetShadowOffset(1, -2)
elapsedText:SetShadowColor(0, 0, 0, 1)

local stopButton = T:CreateButton(timerBlock, L["Stop"], 64, 30, "primary")
stopButton:SetPoint("TOPRIGHT", 0, -26)

local primaryButton = T:CreateButton(timerBlock, L["Start"], 84, 30, "primary")
primaryButton:SetPoint("RIGHT", stopButton, "LEFT", -6, 0)

local limitBar = T:CreatePanel(timerBlock, "input", "borderDim")
limitBar:SetPoint("TOPLEFT", 0, -76)
limitBar:SetPoint("TOPRIGHT", 0, -76)
limitBar:SetHeight(10)
local limitFill = T:CreateColorTexture(limitBar, "bar", "ARTWORK")
limitFill:SetPoint("TOPLEFT", 1, -1)
limitFill:SetPoint("BOTTOMLEFT", 1, 1)
limitFill:SetWidth(1)

local limitLabel = T:CreateText(timerBlock, 11, "muted")
limitLabel:SetPoint("TOPLEFT", limitBar, "BOTTOMLEFT", 0, -5)
local limitRemaining = T:CreateText(timerBlock, 11, "text")
limitRemaining:SetPoint("TOPRIGHT", limitBar, "BOTTOMRIGHT", 0, -5)
limitRemaining:SetJustifyH("RIGHT")

local noLimitText = T:CreateText(timerBlock, 11, "muted")
noLimitText:SetPoint("TOPLEFT", 0, -80)

-- ---------------------------- Aba Time limit ---------------------------------
local timer -- configurações do timer (carregadas no login)

local freePanel = T:CreatePanel(limitPage, "selected", "borderMid")
freePanel:SetPoint("TOPLEFT", 12, -12)
freePanel:SetPoint("TOPRIGHT", -12, -12)
freePanel:SetHeight(42)

local freeCheck = T:CreateCheckbox(freePanel, "")
freeCheck:SetPoint("LEFT", 10, 0)
local freeTitle = T:CreateText(freePanel, 13, "accent")
freeTitle:SetPoint("TOPLEFT", freeCheck, "TOPRIGHT", 9, 5)
freeTitle:SetText(L["Free mode"])
local freeSub = T:CreateText(freePanel, 10, "muted")
freeSub:SetPoint("TOPLEFT", freeTitle, "BOTTOMLEFT", 0, -2)
freeSub:SetPoint("RIGHT", -8, 0)
freeSub:SetWordWrap(false)
freeSub:SetText(L["No time limit. Elapsed time is still saved to the history."])
freeCheck:SetHitRectInsets(0, -(WIDTH - 60), -12, -12)

local draft = { h = 0, m = 0, s = 0 }
local units = {}
local UNIT_DEFS = {
    { key = "h", label = L["Hours"], max = 23, step = 1 },
    { key = "m", label = L["Minutes"], max = 59, step = 5 },
    { key = "s", label = L["Seconds"], max = 59, step = 10 },
}

local function SetDraft(key, value, max)
    value = tonumber(value) or 0
    draft[key] = math.min(max, math.max(0, math.floor(value)))
end

local function RefreshUnitBoxes()
    for _, u in ipairs(units) do
        if not u.box:HasFocus() then
            u.box:SetText(string.format("%02d", draft[u.def.key]))
        end
    end
end

for i, def in ipairs(UNIT_DEFS) do
    local group = CreateFrame("Frame", nil, limitPage)
    group:SetSize(66, 48)
    group:SetPoint("TOPLEFT", 12 + (i - 1) * 72, -62)

    local label = T:CreateText(group, 11, "muted")
    label:SetPoint("TOPLEFT", 0, 0)
    label:SetText(def.label)

    local box = T:CreateEditBox(group, 44, 30, 18)
    box:SetPoint("TOPLEFT", 0, -16)
    box:SetJustifyH("CENTER")
    box:SetTextInsets(2, 2, 0, 0)
    box:SetNumeric(true)
    box:SetMaxLetters(2)
    T:SetTextRole(box, "accent")
    box:SetScript("OnEditFocusLost", function(self)
        SetDraft(def.key, self:GetText(), def.max)
        RefreshUnitBoxes()
    end)
    box:SetScript("OnEnterPressed", function(self) self:ClearFocus() end)

    local up = T:CreateIconButton(group, "Interface\\Buttons\\Arrow-Up-Up", 18, 14, nil)
    up:SetPoint("TOPLEFT", box, "TOPRIGHT", 2, 1)
    up.icon:SetPoint("CENTER", 0, -3)
    local down = T:CreateIconButton(group, "Interface\\Buttons\\Arrow-Down-Up", 18, 14, nil)
    down:SetPoint("BOTTOMLEFT", box, "BOTTOMRIGHT", 2, -1)
    down.icon:SetPoint("CENTER", 0, 3)
    up:SetHeight(16)
    down:SetHeight(16)

    up:SetScript("OnClick", function()
        box:ClearFocus()
        SetDraft(def.key, draft[def.key] + def.step, def.max)
        RefreshUnitBoxes()
    end)
    down:SetScript("OnClick", function()
        box:ClearFocus()
        SetDraft(def.key, draft[def.key] - def.step, def.max)
        RefreshUnitBoxes()
    end)

    units[i] = { def = def, box = box, up = up, down = down }
end

local presets = {}
local PRESETS = { { "15m", 900 }, { "30m", 1800 }, { "1h", 3600 }, { "2h", 7200 } }
for i, p in ipairs(PRESETS) do
    local b = T:CreateButton(limitPage, p[1], 38, 22, "secondary")
    local col = (i - 1) % 2
    local row = math.floor((i - 1) / 2)
    b:SetPoint("TOPRIGHT", -12 - (1 - col) * 42, -70 - row * 26)
    b:SetScript("OnClick", function()
        draft.h = math.floor(p[2] / 3600)
        draft.m = math.floor((p[2] % 3600) / 60)
        draft.s = 0
        RefreshUnitBoxes()
    end)
    presets[i] = b
end

local stopAtEndCheck = T:CreateCheckbox(limitPage, L["Stop the session when time is up"])
stopAtEndCheck:SetPoint("TOPLEFT", 12, -122)
local soundCheck = T:CreateCheckbox(limitPage, L["Play a sound alert"])
soundCheck:SetPoint("TOPLEFT", 12, -142)

local setButton = T:CreateButton(limitPage, L["Set limit"], 92, 28, "primary")
setButton:SetPoint("BOTTOMRIGHT", -12, 12)
local clearButton = T:CreateButton(limitPage, L["Clear"], 64, 28, "primary")
clearButton:SetPoint("RIGHT", setButton, "LEFT", -6, 0)

local lockText = T:CreateText(limitPage, 10, "muted")
lockText:SetPoint("BOTTOMLEFT", 12, 20)
lockText:SetPoint("RIGHT", clearButton, "LEFT", -6, 0)

-- -----------------------------------------------------------------------------
-- Abas
-- -----------------------------------------------------------------------------
local timerTab = T:CreateTab(f, L["Timer"])
timerTab:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 14, 2)
local limitTab = T:CreateTab(f, L["Time limit"])
limitTab:SetPoint("TOPLEFT", timerTab, "TOPRIGHT", 2, 0)

local activeTab = "timer"
local Refresh

local function SelectTab(which)
    activeTab = which
    timerTab:SetSelected(which == "timer")
    limitTab:SetSelected(which == "limit")
    timerPage:SetShown(which == "timer")
    limitPage:SetShown(which == "limit")
    Refresh()
end
timerTab:SetScript("OnClick", function() SelectTab("timer") end)
limitTab:SetScript("OnClick", function() SelectTab("limit") end)

-- -----------------------------------------------------------------------------
-- Atualização
-- -----------------------------------------------------------------------------
local function CurrentElapsed()
    if FarmTracker.sessionActive then
        return FarmTracker:GetElapsedTime()
    end
    return FarmTracker.lastSessionDuration or 0
end

local function RefreshStats()
    local elapsed = CurrentElapsed()
    local items = DisplayItem.totalItems or 0
    local value = DisplayItem.totalValue or 0
    local hasPrices = FarmTracker:GetPriceSource() ~= nil

    statItems:SetValue(tostring(items))
    if hasPrices then
        statValue:SetValue(T:FormatMoney(value))
        if elapsed >= 60 then
            statRate:SetValue(T:FormatMoney(value / (elapsed / 3600)))
        else
            statRate:SetValue("—")
        end
    else
        statValue:SetValue("—")
        statRate:SetValue("—")
    end
end

local function RefreshTimer()
    local active = FarmTracker.sessionActive
    local paused = active and FarmTracker:isPaused()
    local elapsed = CurrentElapsed()

    if active and not paused then
        statusText:SetText(L["Farming"])
        T:SetTextRole(statusText, "good")
        T:SetTextureRole(statusDot, "good")
    elseif paused then
        statusText:SetText(L["Paused"])
        T:SetTextRole(statusText, "warn")
        T:SetTextureRole(statusDot, "warn")
    else
        statusText:SetText(L["Ready"])
        T:SetTextRole(statusText, "muted")
        T:SetTextureRole(statusDot, "muted")
    end
    elapsedText:SetText(T:FormatClock(elapsed))

    primaryButton:SetLabel(not active and L["Start"] or (paused and L["Resume"] or L["Pause"]))
    stopButton:SetEnabled(active)

    local limit = active and FarmTracker:GetSessionLimit() or (not active and FarmTracker:GetConfiguredLimit())
    if limit then
        limitBar:Show()
        limitLabel:Show()
        limitRemaining:Show()
        noLimitText:Hide()
        local shownElapsed = active and elapsed or 0
        local pct = math.min(1, shownElapsed / limit)
        limitFill:SetWidth(math.max(1, (limitBar:GetWidth() - 2) * pct))
        limitLabel:SetText(string.format(L["Limit %s"], T:FormatClock(limit)))
        limitRemaining:SetText(string.format(L["%s left"], T:FormatClock(limit - shownElapsed)))
    else
        limitBar:Hide()
        limitLabel:Hide()
        limitRemaining:Hide()
        noLimitText:Show()
        local freeMode = (active and FarmTracker.sessionMode == "free" and timer and timer.freeMode)
            or (not active and timer and timer.freeMode)
        noLimitText:SetText(freeMode and L["Free mode · no time limit"]
            or L["No time limit · set one in the Time limit tab"])
    end
end

local function RefreshLimitPage()
    if not timer then return end
    local locked = FarmTracker.sessionActive
    freeCheck:SetChecked(timer.freeMode)
    freeCheck:SetEnabled(not locked)
    stopAtEndCheck:SetChecked(timer.stopAtEnd)
    soundCheck:SetChecked(timer.soundAlert)

    local editable = not locked and not timer.freeMode
    for _, u in ipairs(units) do
        u.box:SetEnabled(editable)
        u.box:SetAlpha(editable and 1 or 0.45)
        u.up:SetEnabled(editable)
        u.down:SetEnabled(editable)
        u.up:SetAlpha(editable and 1 or 0.45)
        u.down:SetAlpha(editable and 1 or 0.45)
    end
    for _, b in ipairs(presets) do b:SetEnabled(editable) end
    stopAtEndCheck:SetEnabled(editable)
    soundCheck:SetEnabled(editable)
    setButton:SetEnabled(editable)
    clearButton:SetEnabled(editable and (timer.limit or 0) > 0)
    setButton:SetLabel((timer.limit or 0) > 0 and L["Update"] or L["Set limit"])

    if locked then
        lockText:SetText(L["Locked while a session is running."])
    elseif timer.freeMode then
        lockText:SetText("")
    elseif (timer.limit or 0) > 0 then
        lockText:SetText(string.format(L["Current: %s"], T:FormatClock(timer.limit)))
    else
        lockText:SetText(L["No limit set."])
    end
    RefreshUnitBoxes()
end

Refresh = function()
    RefreshStats()
    RefreshTimer()
    RefreshLimitPage()
end

local function LoadDraftFromSettings()
    local limit = timer and timer.limit or 0
    draft.h = math.floor(limit / 3600)
    draft.m = math.floor((limit % 3600) / 60)
    draft.s = limit % 60
end

-- -----------------------------------------------------------------------------
-- Ações
-- -----------------------------------------------------------------------------
primaryButton:SetScript("OnClick", function()
    if not FarmTracker.sessionActive then
        FarmTracker:StartSession()
        SelectTab("timer")
    elseif FarmTracker:isPaused() then
        FarmTracker:Resume()
    else
        FarmTracker:Pause()
    end
end)

stopButton:SetScript("OnClick", function()
    FarmTracker:StopSession()
end)

freeCheck:SetScript("OnClick", function(self)
    timer.freeMode = self:GetChecked() and true or false
    Refresh()
end)
stopAtEndCheck:SetScript("OnClick", function(self)
    timer.stopAtEnd = self:GetChecked() and true or false
end)
soundCheck:SetScript("OnClick", function(self)
    timer.soundAlert = self:GetChecked() and true or false
end)

setButton:SetScript("OnClick", function()
    for _, u in ipairs(units) do u.box:ClearFocus() end
    local secs = draft.h * 3600 + draft.m * 60 + draft.s
    if secs <= 0 then return end
    timer.limit = secs
    SelectTab("timer")
end)

clearButton:SetScript("OnClick", function()
    timer.limit = 0
    draft.h, draft.m, draft.s = 0, 0, 0
    Refresh()
end)

FarmTracker:OnStateChanged(function()
    if f:IsShown() then Refresh() end
end)
T:OnChange(function()
    timerTab:SetWidth(math.max(80, timerTab.label:GetStringWidth() + 32))
    limitTab:SetWidth(math.max(80, limitTab.label:GetStringWidth() + 32))
    if f:IsShown() then Refresh() end
end)

local tick = 0
f:SetScript("OnUpdate", function(_, elapsed)
    tick = tick + elapsed
    if tick >= 0.5 then
        tick = 0
        if FarmTracker.sessionActive then
            RefreshStats()
            RefreshTimer()
        end
    end
end)

-- Salva estado de visibilidade no profile
f:SetScript("OnShow", function()
    FarmTracker:GetProfile().frameVisible = true
    if not timer then
        timer = FarmTracker:GetTimerSettings()
        LoadDraftFromSettings()
    end
    if DisplayItem and DisplayItem.UpdateDisplay then
        DisplayItem:UpdateDisplay(FarmTracker.lootTable)
    end
    Refresh()
end)

-- OnHide também dispara quando o jogo esconde o UIParent (tela de carregamento
-- do /reload). Nesse caso a janela continua "aberta" (IsShown = true), então
-- só salva como fechada quando ela mesma foi fechada.
f:SetScript("OnHide", function(self)
    FarmTracker:GetProfile().frameVisible = self:IsShown() and true or false
end)

-- Recarrega as configurações do timer (ex.: após importar/copiar perfil)
function FarmTracker:ReloadTimerSettings()
    timer = self:GetTimerSettings()
    LoadDraftFromSettings()
    if f:IsShown() then Refresh() end
end

timerTab:SetSelected(true)
limitTab:SetSelected(false)
limitPage:Hide()

SLASH_FARMBUDDY1 = "/farmbuddy"
SlashCmdList["FARMBUDDY"] = function(msg)
    msg = (msg or ""):lower():match("^%s*(.-)%s*$")
    if msg == "changelog" then
        if FarmBuddyChangelogUI then FarmBuddyChangelogUI:Show() end
        return
    end
    if f:IsShown() then
        f:Hide()
    else
        f:Show()
    end
end
