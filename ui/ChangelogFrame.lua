-- =============================================================================
-- FarmBuddy - Janela "What's new" (changelog após atualização)
-- =============================================================================
-- Abre sozinha uma vez quando a versão do addon muda (FarmBuddyDB.lastSeenVersion).
-- Também abre com /farmbuddy changelog.
-- =============================================================================

local L = FarmBuddyL
local T = FarmBuddyTheme

local WIDTH, HEIGHT = 480, 460

local frame = T:CreateWindow("FarmBuddyChangelogFrame", WIDTH, HEIGHT, L["What's new in FarmBuddy"])
frame:SetFrameStrata("DIALOG")
local body = frame.body

local okButton = T:CreateButton(body, L["Got it"], 100, 28, "primary")
okButton:SetPoint("BOTTOMRIGHT", -14, 12)
okButton:SetScript("OnClick", function() frame:Hide() end)

local hint = T:CreateText(body, 11, "muted")
hint:SetPoint("BOTTOMLEFT", 14, 20)
hint:SetPoint("RIGHT", okButton, "LEFT", -10, 0)
hint:SetText(L["Type /farmbuddy changelog to see this again."])

local panel = T:CreatePanel(body, "panel", "borderDim")
panel:SetPoint("TOPLEFT", 12, -12)
panel:SetPoint("BOTTOMRIGHT", -12, 52)

local scroll = T:CreateScrollArea(panel)
scroll:SetPoint("TOPLEFT", 1, -3)
scroll:SetPoint("BOTTOMRIGHT", -3, 3)

local TEXT_W = WIDTH - 4 - 24 - 2 - 40

local headers, titles, texts, chips = {}, {}, {}, {}

-- Compara "1.10.0" > "1.9.2" numericamente
local function IsNewer(a, b)
    if not b then return true end
    local pa, pb = {}, {}
    for n in tostring(a):gmatch("%d+") do table.insert(pa, tonumber(n)) end
    for n in tostring(b):gmatch("%d+") do table.insert(pb, tonumber(n)) end
    for i = 1, math.max(#pa, #pb) do
        local x, y = pa[i] or 0, pb[i] or 0
        if x ~= y then return x > y end
    end
    return false
end

local function Build(lastSeen)
    local y = 12
    local hi, ti = 0, 0
    for _, entry in ipairs(FarmBuddyChangelog or {}) do
        hi = hi + 1
        local h = headers[hi]
        if not h then
            h = T:CreateText(scroll.child, 16, "accent")
            headers[hi] = h
            local chip = T:CreatePanel(scroll.child, "selected", "border")
            chip:SetHeight(18)
            chip.text = T:CreateText(chip, 10, "accent")
            chip.text:SetPoint("CENTER")
            chip.text:SetText(L["New"])
            chips[hi] = chip
        end
        h:ClearAllPoints()
        h:SetPoint("TOPLEFT", 14, -y)
        h:SetText("v" .. entry.version)
        h:Show()

        local chip = chips[hi]
        local isNew = IsNewer(entry.version, lastSeen)
        chip:ClearAllPoints()
        chip:SetPoint("LEFT", h, "RIGHT", 8, 0)
        chip:SetWidth(chip.text:GetStringWidth() + 14)
        chip:SetShown(isNew)
        y = y + 26

        for _, note in ipairs(entry.notes) do
            ti = ti + 1
            local t = titles[ti]
            if not t then
                t = T:CreateText(scroll.child, 13, "white")
                t:SetWidth(TEXT_W)
                titles[ti] = t
                local d = T:CreateText(scroll.child, 12, "text")
                d:SetWidth(TEXT_W)
                d:SetSpacing(2)
                texts[ti] = d
            end
            local d = texts[ti]
            t:ClearAllPoints()
            t:SetPoint("TOPLEFT", 24, -y)
            t:SetText("• " .. L[note[1]])
            t:Show()
            y = y + t:GetStringHeight() + 3
            d:ClearAllPoints()
            d:SetPoint("TOPLEFT", 34, -y)
            d:SetText(L[note[2]])
            d:Show()
            y = y + d:GetStringHeight() + 10
        end
        y = y + 10
    end
    for i = hi + 1, #headers do headers[i]:Hide(); chips[i]:Hide() end
    for i = ti + 1, #titles do titles[i]:Hide(); texts[i]:Hide() end
    scroll:SetContentHeight(y)
    scroll.bar:SetValue(0)
end

FarmBuddyChangelogUI = {}

function FarmBuddyChangelogUI:Show()
    Build(FarmBuddyDB.lastSeenVersion)
    frame:Show()
end

T:OnChange(function()
    if frame:IsShown() then Build(FarmBuddyDB.lastSeenVersion) end
end)

-- Abre sozinho uma vez depois de uma atualização
local watcher = CreateFrame("Frame")
watcher:RegisterEvent("PLAYER_LOGIN")
watcher:SetScript("OnEvent", function(self)
    self:UnregisterEvent("PLAYER_LOGIN")
    C_Timer.After(4, function()
        local current = FarmTracker.version
        if current and IsNewer(current, FarmBuddyDB.lastSeenVersion) then
            FarmBuddyChangelogUI:Show()
            -- Marca como vista ao exibir: aparece uma única vez por atualização
            FarmBuddyDB.lastSeenVersion = current
        end
    end)
end)
