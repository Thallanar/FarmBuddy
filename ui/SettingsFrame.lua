-- =============================================================================
-- FarmBuddy - Janela de configurações
-- =============================================================================
-- Seções: Appearance (tema, fonte, escala), Alerts (som do alarme),
-- Filters (categorias da lista de loot) e Profiles (export/import e
-- GatherMate2).
-- =============================================================================

local L = FarmBuddyL
local T = FarmBuddyTheme

local WIDTH, HEIGHT = 640, 520
local NAV_W = 168
local CW = WIDTH - 4 - NAV_W - 44 -- largura útil do conteúdo

local frame = T:CreateWindow("FarmBuddySettingsFrame", WIDTH, HEIGHT, L["Settings"])
frame:SetFrameStrata("HIGH")
local body = frame.body

TrackerSettings = TrackerSettings or {}
TrackerSettings.frame = frame

-- -----------------------------------------------------------------------------
-- Navegação
-- -----------------------------------------------------------------------------
local nav = CreateFrame("Frame", nil, body, BackdropTemplateMixin and "BackdropTemplate")
nav:SetPoint("TOPLEFT")
nav:SetPoint("BOTTOMLEFT")
nav:SetWidth(NAV_W)
nav:SetBackdrop({ bgFile = "Interface\\Buttons\\WHITE8x8" })
T:Register(nav, function(n) n:SetBackdropColor(T:Color("header")) end)
local navLine = T:CreateColorTexture(nav, "borderMid", "BORDER")
navLine:SetPoint("TOPRIGHT")
navLine:SetPoint("BOTTOMRIGHT")
navLine:SetWidth(1)

local scroll = T:CreateScrollArea(body)
scroll:SetPoint("TOPLEFT", NAV_W + 1, -2)
scroll:SetPoint("BOTTOMRIGHT", -4, 2)

local SECTIONS = {
    { id = "appearance", label = L["Appearance"], icon = "Interface\\Icons\\INV_Misc_Gem_Variety_01" },
    { id = "alerts", label = L["Alerts"], icon = "Interface\\Icons\\INV_Misc_PocketWatch_01" },
    { id = "filters", label = L["Filters"], icon = "Interface\\Icons\\INV_Misc_Spyglass_03" },
    { id = "profiles", label = L["Profiles"], icon = "Interface\\Icons\\INV_Misc_Note_01" },
}

local pages = {}
local navButtons = {}
local currentSection = "appearance"

local function NewPage(id)
    local p = CreateFrame("Frame", nil, scroll.child)
    p:SetPoint("TOPLEFT", 18, -16)
    p:SetWidth(CW)
    p:SetHeight(10)
    p:Hide()
    pages[id] = p
    return p
end

local function AddTitle(page, title, desc)
    local t = T:CreateText(page, 19, "accent")
    t:SetPoint("TOPLEFT", 0, 0)
    t:SetText(title)
    local d = T:CreateText(page, 12, "muted")
    d:SetPoint("TOPLEFT", 0, -26)
    d:SetWidth(CW)
    d:SetText(desc)
end

local function AddLabel(page, text, x, y, size)
    local fs = T:CreateText(page, size or 13, "accent")
    fs:SetPoint("TOPLEFT", x, y)
    fs:SetText(text)
    return fs
end

local function ShowSection(id)
    currentSection = id
    for _, b in ipairs(navButtons) do
        b:SetSelected(b.sectionId == id)
    end
    for pid, p in pairs(pages) do
        p:SetShown(pid == id)
    end
    local page = pages[id]
    if page.Refresh then page:Refresh() end
    scroll:SetContentHeight(page:GetHeight() + 32)
    scroll.bar:SetValue(0)
end

for i, s in ipairs(SECTIONS) do
    local b = T:CreateNavButton(nav, 36)
    b:SetPoint("TOPLEFT", 8, -10 - (i - 1) * 39)
    b:SetPoint("RIGHT", nav, "RIGHT", -9, 0)
    b.sectionId = s.id
    local icon = b:CreateTexture(nil, "ARTWORK")
    icon:SetSize(20, 20)
    icon:SetPoint("LEFT", 8, 0)
    icon:SetTexture(s.icon)
    icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    b.label = T:CreateText(b, 14, "text")
    b.label:SetPoint("LEFT", icon, "RIGHT", 9, 0)
    b.label:SetText(s.label)
    function b:OnPaint()
        T:SetTextRole(self.label, self.fbSelected and "accent" or "text")
    end
    T:Repaint(b)
    b:SetScript("OnClick", function() ShowSection(s.id) end)
    navButtons[i] = b
end

-- =============================================================================
-- Appearance
-- =============================================================================
do
    local page = NewPage("appearance")
    AddTitle(page, L["Appearance"], L["Theme and fonts used by every FarmBuddy window."])
    AddLabel(page, L["Theme"], 0, -52)

    local cards = {}
    local cardW = (CW - 16) / 3
    for i, id in ipairs(T.themeOrder) do
        local pal = T.themes[id]
        local card = T:CreateNavButton(page, 86)
        card:SetSize(cardW, 86)
        card:SetPoint("TOPLEFT", (i - 1) * (cardW + 8), -74)
        card.themeId = id

        -- Miniatura com as cores fixas daquele tema
        local mini = CreateFrame("Frame", nil, card, BackdropTemplateMixin and "BackdropTemplate")
        mini:SetPoint("TOPLEFT", 7, -7)
        mini:SetPoint("TOPRIGHT", -7, -7)
        mini:SetHeight(50)
        T:Register(mini, function(m)
            T:ApplyEdge(m, 1, true)
            m:SetBackdropColor(unpack(pal.bg))
            m:SetBackdropBorderColor(unpack(pal.border))
        end)
        local head = mini:CreateTexture(nil, "ARTWORK")
        head:SetPoint("TOPLEFT", 1, -1)
        head:SetPoint("TOPRIGHT", -1, -1)
        head:SetHeight(11)
        head:SetColorTexture(unpack(pal.header))
        local lines = { { 0.6, pal.accent }, { 0.85, pal.borderMid }, { 0.45, pal.borderMid } }
        for li, spec in ipairs(lines) do
            local line = mini:CreateTexture(nil, "ARTWORK")
            line:SetHeight(4)
            line:SetWidth((cardW - 26) * spec[1])
            line:SetPoint("TOPLEFT", 6, -16 - (li - 1) * 9)
            line:SetColorTexture(unpack(spec[2]))
        end

        card.label = T:CreateText(card, 12, "text")
        card.label:SetPoint("BOTTOMLEFT", 8, 8)
        card.label:SetText(L[T.themeLabels[id]])
        card.check = card:CreateTexture(nil, "OVERLAY")
        card.check:SetSize(18, 18)
        card.check:SetPoint("BOTTOMRIGHT", -5, 4)
        card.check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
        function card:OnPaint()
            if not self.fbSelected then
                local r, g, b = T:Color("panel")
                self:SetBackdropColor(r, g, b, 1)
                self:SetBackdropBorderColor(T:Color("borderDim"))
            end
            T:SetTextRole(self.label, self.fbSelected and "accent" or "text")
            self.check:SetShown(self.fbSelected)
        end
        card:SetScript("OnClick", function()
            T:GetSettings().theme = id
            T:Apply()
            pages.appearance:Refresh()
        end)
        cards[i] = card
    end

    -- Fonte
    local half = (CW - 16) / 2
    AddLabel(page, L["Font"], 0, -178)
    local fontDropdown = T:CreateDropdown(page, half, function()
        local items = {}
        for _, f in ipairs(T:GetFonts()) do
            table.insert(items, { value = f.key, label = f.label })
        end
        return items
    end, function() return T:GetSettings().font end, function(value)
        T:GetSettings().font = value
        T:Apply()
    end)
    fontDropdown:SetPoint("TOPLEFT", 0, -198)
    local fontNote = T:CreateText(page, 10, "muted")
    fontNote:SetPoint("TOPLEFT", 0, -230)
    fontNote:SetWidth(half)
    fontNote:SetText(L["Fonts from LibSharedMedia also show up here."])

    local sizeLabel = AddLabel(page, L["Font size"], half + 16, -178)
    local sizeValue = T:CreateText(page, 12, "text")
    sizeValue:SetPoint("TOPRIGHT", 0, -179)
    sizeValue:SetJustifyH("RIGHT")
    local sizeSlider = T:CreateSlider(page, half, 10, 18, 1)
    sizeSlider:SetPoint("TOPLEFT", half + 16, -204)
    sizeSlider:SetScript("OnValueChanged", function(_, v)
        v = math.floor(v + 0.5)
        sizeValue:SetText(string.format(L["%d pt"], v))
        if T:GetSettings().fontSize ~= v then
            T:GetSettings().fontSize = v
            T:Apply()
        end
    end)

    -- Prévia
    local preview = T:CreatePanel(page, "panel", "borderDim")
    preview:SetPoint("TOPLEFT", 0, -252)
    preview:SetSize(CW, 64)
    local pvLabel = T:CreateText(preview, 10, "muted")
    pvLabel:SetPoint("TOPLEFT", 12, -8)
    pvLabel:SetText(L["Preview"])
    local pv1 = T:CreateText(preview, 17, "accent")
    pv1:SetPoint("TOPLEFT", 12, -22)
    pv1:SetText(L["Peacebloom"] .. " x84")
    local pv2 = T:CreateText(preview, 12, "text")
    pv2:SetPoint("TOPLEFT", pv1, "BOTTOMLEFT", 0, -4)
    pv2:SetText("01:24:37 · " .. T:FormatMoney(12843712) .. " · " .. T:FormatMoney(9120455) .. " " .. L["per hour"])

    -- Escala e opacidade
    AddLabel(page, L["Window scale"], 0, -334)
    local scaleValue = T:CreateText(page, 12, "text")
    scaleValue:SetPoint("TOPLEFT", half - 40, -335)
    scaleValue:SetWidth(40)
    scaleValue:SetJustifyH("RIGHT")
    local scaleSlider = T:CreateSlider(page, half, 70, 150, 5)
    scaleSlider:SetPoint("TOPLEFT", 0, -360)
    scaleSlider:SetScript("OnValueChanged", function(_, v)
        scaleValue:SetText(math.floor(v + 0.5) .. "%")
    end)
    -- Aplica a escala ao soltar (a janela muda de tamanho sob o mouse)
    scaleSlider:SetScript("OnMouseUp", function(self)
        local v = math.floor(self:GetValue() + 0.5)
        if T:GetSettings().scale ~= v then
            T:GetSettings().scale = v
            T:Apply()
        end
    end)

    AddLabel(page, L["Background opacity"], half + 16, -334)
    local opValue = T:CreateText(page, 12, "text")
    opValue:SetPoint("TOPRIGHT", 0, -335)
    opValue:SetJustifyH("RIGHT")
    local opSlider = T:CreateSlider(page, half, 30, 100, 5)
    opSlider:SetPoint("TOPLEFT", half + 16, -360)
    opSlider:SetScript("OnValueChanged", function(_, v)
        v = math.floor(v + 0.5)
        opValue:SetText(v .. "%")
        if T:GetSettings().opacity ~= v then
            T:GetSettings().opacity = v
            T:Apply()
        end
    end)

    page:SetHeight(380)

    function page:Refresh()
        local s = T:GetSettings()
        for _, card in ipairs(cards) do card:SetSelected(card.themeId == s.theme) end
        T:RefreshFontList()
        fontDropdown:Refresh()
        sizeSlider:SetValue(s.fontSize)
        sizeValue:SetText(string.format(L["%d pt"], s.fontSize))
        scaleSlider:SetValue(s.scale)
        scaleValue:SetText(s.scale .. "%")
        opSlider:SetValue(s.opacity)
        opValue:SetText(s.opacity .. "%")
    end
    page.sizeLabel = sizeLabel
end

-- =============================================================================
-- Alerts
-- =============================================================================
do
    local page = NewPage("alerts")
    AddTitle(page, L["Alerts"], L["What plays when a time limit runs out."])
    AddLabel(page, L["Alarm sound"], 0, -52)

    local list = T:CreatePanel(page, "panel", "borderDim")
    list:SetPoint("TOPLEFT", 0, -74)
    list:SetWidth(CW)
    local rows = {}
    local ROW_H = 26

    local channelLabel = AddLabel(page, L["Sound channel"], 0, 0)
    local channelDropdown = T:CreateDropdown(page, 180, function()
        local items = {}
        for _, c in ipairs(FarmBuddyAlerts.channels) do
            table.insert(items, { value = c.value, label = L[c.label] })
        end
        return items
    end, function() return FarmBuddyAlerts:GetSettings().channel end, function(value)
        FarmBuddyAlerts:GetSettings().channel = value
    end)
    local channelNote = T:CreateText(page, 10, "muted")
    channelNote:SetText(L["Master plays even with sound effects muted."])

    local warnCheck = T:CreateCheckbox(page, L["Warn 5 minutes before the end"])
    local screenCheck = T:CreateCheckbox(page, L["Show a message in the middle of the screen"])
    local flashCheck = T:CreateCheckbox(page, L["Flash the game icon in the taskbar"])
    warnCheck:SetScript("OnClick", function(self) FarmBuddyAlerts:GetSettings().warnBefore = self:GetChecked() and true or false end)
    screenCheck:SetScript("OnClick", function(self) FarmBuddyAlerts:GetSettings().screenMessage = self:GetChecked() and true or false end)
    flashCheck:SetScript("OnClick", function(self) FarmBuddyAlerts:GetSettings().flashIcon = self:GetChecked() and true or false end)

    function page:Refresh()
        local settings = FarmBuddyAlerts:GetSettings()
        local sounds = FarmBuddyAlerts:GetSounds()
        for i, snd in ipairs(sounds) do
            local row = rows[i]
            if not row then
                row = CreateFrame("Frame", nil, list)
                row:SetHeight(ROW_H)
                row:SetPoint("TOPLEFT", 0, -4 - (i - 1) * ROW_H)
                row:SetPoint("RIGHT", list, "RIGHT", 0, 0)
                row.radio = T:CreateCheckbox(row, "", true)
                row.radio:SetPoint("LEFT", 12, 0)
                row.play = T:CreateIconButton(row, "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up", 24, 20, L["Preview"])
                row.play:SetPoint("RIGHT", -8, 0)
                rows[i] = row
            end
            row.radio:SetLabel(snd.label)
            row.radio:SetChecked(snd.key == settings.sound)
            T:SetTextRole(row.radio.label, snd.key == settings.sound and "accent" or "text")
            row.radio:SetScript("OnClick", function()
                settings.sound = snd.key
                page:Refresh()
            end)
            row.play:SetScript("OnClick", function() FarmBuddyAlerts:Play(snd.key) end)
            row:Show()
        end
        for i = #sounds + 1, #rows do rows[i]:Hide() end
        local listH = #sounds * ROW_H + 8
        list:SetHeight(listH)

        local y = -74 - listH - 18
        channelLabel:ClearAllPoints()
        channelLabel:SetPoint("TOPLEFT", 0, y)
        channelDropdown:ClearAllPoints()
        channelDropdown:SetPoint("TOPLEFT", 0, y - 20)
        channelDropdown:Refresh()
        channelNote:ClearAllPoints()
        channelNote:SetPoint("LEFT", channelDropdown, "RIGHT", 10, 0)
        channelNote:SetWidth(CW - 190)

        warnCheck:ClearAllPoints()
        warnCheck:SetPoint("TOPLEFT", 0, y - 66)
        screenCheck:ClearAllPoints()
        screenCheck:SetPoint("TOPLEFT", 0, y - 90)
        flashCheck:ClearAllPoints()
        flashCheck:SetPoint("TOPLEFT", 0, y - 114)
        warnCheck:SetChecked(settings.warnBefore)
        screenCheck:SetChecked(settings.screenMessage)
        flashCheck:SetChecked(settings.flashIcon)

        page:SetHeight(-(y - 130))
    end
end

-- =============================================================================
-- Filters
-- =============================================================================
do
    local page = NewPage("filters")
    AddTitle(page, L["Filters"], L["Choose which item types show up in the loot list."])

    local search = T:CreateEditBox(page, CW - 176, 28, 12)
    search:SetPoint("TOPLEFT", 0, -52)
    local searchHint = T:CreateText(search, 12, "muted")
    searchHint:SetPoint("LEFT", 9, 0)
    searchHint:SetText(L["Search item types"])

    local showAll = T:CreateButton(page, L["Show all"], 80, 28, "secondary")
    showAll:SetPoint("TOPRIGHT", -86, -52)
    local hideAll = T:CreateButton(page, L["Hide all"], 80, 28, "secondary")
    hideAll:SetPoint("TOPRIGHT", 0, -52)

    local list = T:CreatePanel(page, "panel", "borderDim")
    list:SetPoint("TOPLEFT", 0, -92)
    list:SetWidth(CW)

    local expanded = {}
    local groupRows, catChecks = {}, {}
    local GROUP_H, CAT_H = 32, 22

    local function Rebuild()
        local query = (search:GetText() or ""):lower()
        searchHint:SetShown(query == "" and not search:HasFocus())
        local y = 2
        local gi, ci = 0, 0
        for _, group in ipairs(TrackerSettings:GetGroups()) do
            local groupLabel = L[group]
            local matches = {}
            for _, category in ipairs(FarmTracker.categoryList[group]) do
                if query == "" or L[category]:lower():find(query, 1, true) or groupLabel:lower():find(query, 1, true) then
                    table.insert(matches, category)
                end
            end
            if #matches > 0 then
                gi = gi + 1
                local row = groupRows[gi]
                if not row then
                    row = CreateFrame("Button", nil, list)
                    row:SetHeight(GROUP_H)
                    row.check = T:CreateCheckbox(row, "")
                    row.check:SetPoint("LEFT", 10, 0)
                    row.check:SetHitRectInsets(0, 0, -3, -3)
                    row.label = T:CreateText(row, 13, "accent")
                    row.label:SetPoint("LEFT", row.check, "RIGHT", 9, 0)
                    row.arrow = row:CreateTexture(nil, "OVERLAY")
                    row.arrow:SetSize(12, 12)
                    row.arrow:SetPoint("RIGHT", -10, 0)
                    row.arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
                    T:Register(row.arrow, function(a) a:SetVertexColor(T:Color("accent")) end)
                    row.summary = T:CreateText(row, 11, "muted")
                    row.summary:SetPoint("RIGHT", row.arrow, "LEFT", -8, 0)
                    row.summary:SetJustifyH("RIGHT")
                    row.line = T:CreateColorTexture(row, "borderDim", "BORDER")
                    row.line:SetPoint("BOTTOMLEFT", 6, 0)
                    row.line:SetPoint("BOTTOMRIGHT", -6, 0)
                    row.line:SetHeight(1)
                    groupRows[gi] = row
                end
                row:ClearAllPoints()
                row:SetPoint("TOPLEFT", 0, -y)
                row:SetPoint("RIGHT", list, "RIGHT", 0, 0)
                row.label:SetText(groupLabel)
                local shown, total = TrackerSettings:CountShown(group)
                row.check:SetChecked(shown == total)
                if shown == total then
                    row.summary:SetText(L["All shown"])
                elseif shown == 0 then
                    row.summary:SetText(L["Hidden"])
                else
                    row.summary:SetText(string.format(L["%d of %d"], shown, total))
                end
                local isOpen = query ~= "" or expanded[group]
                row.arrow:SetRotation(isOpen and math.rad(-90) or 0)
                row.check:SetScript("OnClick", function(self)
                    TrackerSettings:SetGroup(group, self:GetChecked())
                    Rebuild()
                end)
                row:SetScript("OnClick", function()
                    expanded[group] = not expanded[group]
                    Rebuild()
                end)
                row:Show()
                y = y + GROUP_H + 2

                if isOpen then
                    local colW = (CW - 40) / 2
                    for idx, category in ipairs(matches) do
                        ci = ci + 1
                        local cb = catChecks[ci]
                        if not cb then
                            cb = T:CreateCheckbox(list, "")
                            catChecks[ci] = cb
                        end
                        local col = (idx - 1) % 2
                        local line = math.floor((idx - 1) / 2)
                        cb:ClearAllPoints()
                        cb:SetPoint("TOPLEFT", 30 + col * colW, -(y + line * CAT_H + 4))
                        cb:SetLabel(L[category])
                        local isOn = TrackerSettings:IsShown(group, category)
                        cb:SetChecked(isOn)
                        T:SetTextRole(cb.label, isOn and "text" or "muted")
                        cb:SetScript("OnClick", function(self)
                            TrackerSettings:SetShown(group, category, self:GetChecked())
                            TrackerSettings:FiltersChanged()
                            Rebuild()
                        end)
                        cb:Show()
                    end
                    y = y + math.ceil(#matches / 2) * CAT_H + 10
                end
            end
        end
        for i = gi + 1, #groupRows do groupRows[i]:Hide() end
        for i = ci + 1, #catChecks do catChecks[i]:Hide() end
        list:SetHeight(math.max(30, y + 2))
        page:SetHeight(92 + y + 10)
        if currentSection == "filters" then
            scroll:SetContentHeight(page:GetHeight() + 32)
        end
    end

    search:SetScript("OnTextChanged", function() Rebuild() end)
    search:SetScript("OnEditFocusGained", function() searchHint:Hide() end)
    search:SetScript("OnEditFocusLost", function() Rebuild() end)
    showAll:SetScript("OnClick", function() TrackerSettings:SetAll(true); Rebuild() end)
    hideAll:SetScript("OnClick", function() TrackerSettings:SetAll(false); Rebuild() end)

    page.Refresh = Rebuild
end

-- =============================================================================
-- Profiles
-- =============================================================================
do
    local page = NewPage("profiles")
    AddTitle(page, L["Profiles"], L["Move settings between characters and bring in GatherMate2 data."])

    -- Perfil atual + copiar de outro personagem
    local current = T:CreatePanel(page, "panel", "borderDim")
    current:SetPoint("TOPLEFT", 0, -52)
    current:SetSize(CW, 54)
    local curLabel = T:CreateText(current, 11, "muted")
    curLabel:SetPoint("TOPLEFT", 12, -10)
    curLabel:SetText(L["Current profile"])
    local curName = T:CreateText(current, 14, "white")
    curName:SetPoint("TOPLEFT", curLabel, "BOTTOMLEFT", 0, -4)

    local copyTarget
    local copyButton = T:CreateButton(current, L["Copy"], 56, 26, "secondary")
    copyButton:SetPoint("RIGHT", -12, 0)
    local copyDropdown = T:CreateDropdown(current, 150, function()
        local items = {}
        for _, key in ipairs(FarmBuddyProfileIO:GetOtherProfiles()) do
            table.insert(items, { value = key, label = key })
        end
        return items
    end, function() return copyTarget end, function(value) copyTarget = value end)
    copyDropdown:SetPoint("RIGHT", copyButton, "LEFT", -6, 0)
    local copyLabel = T:CreateText(current, 12, "muted")
    copyLabel:SetPoint("RIGHT", copyDropdown, "LEFT", -8, 0)
    copyLabel:SetText(L["Copy from"])

    -- Nomes de reino longos (ex.: Forever) cortam com reticências; o nome
    -- completo aparece no tooltip
    curName:SetPoint("RIGHT", copyLabel, "LEFT", -12, 0)
    curName:SetWordWrap(false)
    local curHover = CreateFrame("Frame", nil, current)
    curHover:SetPoint("TOPLEFT", curLabel, "TOPLEFT", -4, 4)
    curHover:SetPoint("BOTTOMRIGHT", curName, "BOTTOMRIGHT", 4, -4)
    curHover:SetScript("OnEnter", function(self)
        if curName:IsTruncated() then
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:AddLine(curName:GetText(), 1, 1, 1)
            GameTooltip:Show()
        end
    end)
    curHover:SetScript("OnLeave", function() GameTooltip:Hide() end)

    StaticPopupDialogs["FARMBUDDY_COPY_PROFILE"] = {
        text = L["Copy filters, timer and alert settings from %s? Your current ones will be replaced."],
        button1 = L["Yes"],
        button2 = L["No"],
        OnAccept = function(_, key)
            FarmBuddyProfileIO:CopyFrom(key)
            print("|cff00ff00[FarmBuddy]|r " .. string.format(L["Settings copied from %s."], key))
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }
    copyButton:SetScript("OnClick", function()
        if copyTarget then
            local dialog = StaticPopup_Show("FARMBUDDY_COPY_PROFILE", copyTarget)
            if dialog then dialog.data = copyTarget end
        end
    end)

    -- Export / import do perfil
    AddLabel(page, L["FarmBuddy profile"], 0, -124)
    local mode = "export"
    local importButtonTab = T:CreateButton(page, L["Import"], 70, 24, "secondary")
    importButtonTab:SetPoint("TOPRIGHT", 0, -120)
    local exportButtonTab = T:CreateButton(page, L["Export"], 70, 24, "secondary")
    exportButtonTab:SetPoint("RIGHT", importButtonTab, "LEFT", -6, 0)

    local hint = T:CreateText(page, 11, "muted")
    hint:SetPoint("TOPLEFT", 0, -150)
    hint:SetWidth(CW)
    local area = T:CreateTextArea(page, CW, 72)
    area:SetPoint("TOPLEFT", 0, -168)

    local options = { settings = true, filters = true, history = false }
    local optSettings = T:CreateCheckbox(page, L["Settings"])
    optSettings:SetPoint("TOPLEFT", 0, -252)
    local optFilters = T:CreateCheckbox(page, L["Filters"])
    optFilters:SetPoint("TOPLEFT", 100, -252)
    local optHistory = T:CreateCheckbox(page, L["History"])
    optHistory:SetPoint("TOPLEFT", 190, -252)

    local importAction = T:CreateButton(page, L["Import profile"], 120, 26, "primary")
    importAction:SetPoint("TOPRIGHT", 0, -246)
    local ioError = T:CreateText(page, 11, "warn")
    ioError:SetPoint("TOPLEFT", 0, -274)
    ioError:SetWidth(CW)

    local function RefreshIO()
        local exporting = mode == "export"
        -- Botão ativo usa o estilo selecionado
        exportButtonTab:SetAlpha(exporting and 1 or 0.65)
        importButtonTab:SetAlpha(exporting and 0.65 or 1)
        T:SetTextRole(exportButtonTab.label, exporting and "accent" or "text")
        T:SetTextRole(importButtonTab.label, exporting and "text" or "accent")
        importAction:SetShown(not exporting)
        ioError:SetText("")
        optSettings:SetChecked(options.settings)
        optFilters:SetChecked(options.filters)
        optHistory:SetChecked(options.history)
        if exporting then
            hint:SetText(L["Press Ctrl+C to copy this string, then paste it on another character."])
            local text, err = FarmBuddyProfileIO:Export(options)
            area.editBox:SetText(text or "")
            if not text then ioError:SetText(err or "") end
        else
            hint:SetText(L["Paste a string exported from FarmBuddy on any character."])
        end
    end

    -- Em modo export a caixa é só leitura: qualquer edição volta ao texto gerado
    area.editBox:SetScript("OnTextChanged", function(self, userInput)
        if userInput and mode == "export" then RefreshIO() end
    end)
    area.editBox:SetScript("OnEditFocusGained", function(self)
        if mode == "export" then self:HighlightText() end
    end)

    exportButtonTab:SetScript("OnClick", function() mode = "export"; RefreshIO() end)
    importButtonTab:SetScript("OnClick", function()
        mode = "import"
        area.editBox:SetText("")
        RefreshIO()
        area.editBox:SetFocus()
    end)
    optSettings:SetScript("OnClick", function(self) options.settings = self:GetChecked() and true or false; if mode == "export" then RefreshIO() end end)
    optFilters:SetScript("OnClick", function(self) options.filters = self:GetChecked() and true or false; if mode == "export" then RefreshIO() end end)
    optHistory:SetScript("OnClick", function(self) options.history = self:GetChecked() and true or false; if mode == "export" then RefreshIO() end end)

    StaticPopupDialogs["FARMBUDDY_IMPORT_PROFILE"] = {
        text = L["Import this profile? The selected parts will replace your current ones (history is added, never removed)."],
        button1 = L["Yes"],
        button2 = L["No"],
        OnAccept = function(_, payload)
            FarmBuddyProfileIO:Apply(payload, options)
            area.editBox:SetText("")
            print("|cff00ff00[FarmBuddy]|r " .. L["Profile imported."])
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }
    importAction:SetScript("OnClick", function()
        local payload, err = FarmBuddyProfileIO:Decode(area.editBox:GetText())
        if not payload then
            ioError:SetText(err or L["Invalid data format."])
            return
        end
        ioError:SetText("")
        local dialog = StaticPopup_Show("FARMBUDDY_IMPORT_PROFILE")
        if dialog then dialog.data = payload end
    end)

    -- GatherMate2
    AddLabel(page, "GatherMate2", 0, -298)
    local gmStatus = T:CreateText(page, 11, "good")
    gmStatus:SetPoint("TOPLEFT", 98, -300)
    local pasteButton = T:CreateButton(page, L["Paste string"], 96, 24, "secondary")
    pasteButton:SetPoint("TOPRIGHT", 0, -294)
    local dbButton = T:CreateButton(page, L["Import from database"], 150, 24, "secondary")
    dbButton:SetPoint("RIGHT", pasteButton, "LEFT", -6, 0)
    pasteButton:SetScript("OnClick", function() FarmBuddyImportManager:PasteString() end)
    dbButton:SetScript("OnClick", function() FarmBuddyImportManager:ImportFromDatabase() end)

    local importList = T:CreatePanel(page, "panel", "borderDim")
    importList:SetPoint("TOPLEFT", 0, -326)
    importList:SetWidth(CW)
    local emptyImports = T:CreateText(importList, 12, "muted")
    emptyImports:SetPoint("TOPLEFT", 12, -14)
    emptyImports:SetText(L["No GatherMate2 imports yet."])
    local importRows = {}
    local IMPORT_H = 44

    local function IsGatherMateLoaded()
        local isLoaded = C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded
        return isLoaded and isLoaded("GatherMate2")
    end

    local function RefreshImports()
        local imports = FarmTracker:GetProfile().gatherImports or {}
        for i, entry in ipairs(imports) do
            local row = importRows[i]
            if not row then
                row = CreateFrame("Frame", nil, importList)
                row:SetHeight(IMPORT_H)
                row.name = T:CreateText(row, 13, "white")
                row.name:SetPoint("TOPLEFT", 12, -7)
                row.name:SetWordWrap(false)
                row.meta = T:CreateText(row, 11, "muted")
                row.meta:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -3)
                row.del = T:CreateButton(row, L["Delete"], 52, 22, "secondary")
                row.del:SetPoint("RIGHT", -8, 0)
                row.exp = T:CreateButton(row, L["Export"], 52, 22, "secondary")
                row.exp:SetPoint("RIGHT", row.del, "LEFT", -4, 0)
                row.ren = T:CreateButton(row, L["Rename"], 60, 22, "secondary")
                row.ren:SetPoint("RIGHT", row.exp, "LEFT", -4, 0)
                row.map = T:CreateButton(row, L["Map"], 44, 22, "secondary")
                row.map:SetPoint("RIGHT", row.ren, "LEFT", -4, 0)
                row.name:SetPoint("RIGHT", row.map, "LEFT", -8, 0)
                row.line = T:CreateColorTexture(row, "borderDim", "BORDER")
                row.line:SetPoint("BOTTOMLEFT", 6, 0)
                row.line:SetPoint("BOTTOMRIGHT", -6, 0)
                row.line:SetHeight(1)
                importRows[i] = row
            end
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 0, -2 - (i - 1) * IMPORT_H)
            row:SetPoint("RIGHT", importList, "RIGHT", 0, 0)
            row.name:SetText(entry.name or L["Unnamed"])
            row.meta:SetText(string.format(L["%d nodes · %d maps"], entry.totalNodes or 0, entry.mapList and #entry.mapList or 0))
            row.line:SetShown(i < #imports)
            row.map:SetScript("OnClick", function() FarmBuddyImportManager:ViewMap(i) end)
            row.ren:SetScript("OnClick", function() FarmBuddyImportManager:Rename(i) end)
            row.exp:SetScript("OnClick", function() FarmBuddyImportManager:Export(i) end)
            row.del:SetScript("OnClick", function() FarmBuddyImportManager:Delete(i) end)
            row:Show()
        end
        for i = #imports + 1, #importRows do importRows[i]:Hide() end
        emptyImports:SetShown(#imports == 0)
        local listH = #imports == 0 and 42 or (#imports * IMPORT_H + 4)
        importList:SetHeight(listH)
        page:SetHeight(326 + listH + 10)
        if currentSection == "profiles" then
            scroll:SetContentHeight(page:GetHeight() + 32)
        end
    end

    FarmBuddyImportManager:SetOnChange(RefreshImports)

    function page:Refresh()
        curName:SetText(FarmTracker:GetProfileKey())
        local others = FarmBuddyProfileIO:GetOtherProfiles()
        if not copyTarget or not tContains(others, copyTarget) then copyTarget = others[1] end
        copyDropdown:Refresh()
        copyDropdown:SetEnabled(#others > 0)
        copyButton:SetEnabled(#others > 0)
        if IsGatherMateLoaded() then
            gmStatus:SetText(L["Detected"])
            T:SetTextRole(gmStatus, "good")
        else
            gmStatus:SetText(L["Not loaded"])
            T:SetTextRole(gmStatus, "muted")
        end
        dbButton:SetEnabled(IsGatherMateLoaded())
        RefreshIO()
        RefreshImports()
    end
end

-- -----------------------------------------------------------------------------
-- API pública
-- -----------------------------------------------------------------------------
function TrackerSettings:Open(section)
    frame:Show()
    ShowSection(section or currentSection)
end

function TrackerSettings:Toggle()
    if frame:IsShown() then
        frame:Hide()
    else
        self:Open(currentSection)
    end
end

-- Atualiza a seção aberta (ex.: depois de importar um perfil)
function TrackerSettings:Refresh()
    if frame:IsShown() then ShowSection(currentSection) end
end

T:OnChange(function()
    if frame:IsShown() then
        local page = pages[currentSection]
        if page and page.Refresh and currentSection ~= "appearance" then page:Refresh() end
    end
end)
