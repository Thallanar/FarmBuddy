-- =============================================================================
-- FarmBuddy - Histórico de sessões
-- =============================================================================
-- Coluna da esquerda: sessões agrupadas por dia (abas por data + hora).
-- Direita: detalhe da sessão selecionada (resumo e loot por categoria).
-- =============================================================================

local L = FarmBuddyL
local T = FarmBuddyTheme

local WIDTH, HEIGHT = 640, 560
local NAV_W = 190

local frame = T:CreateWindow("FarmBuddyHistoryFrame", WIDTH, HEIGHT, L["Farm History"])
frame:SetFrameStrata("HIGH")

local clearAllButton = T:CreateButton(frame.header, L["Clear all"], 80, 22, "secondary")
local headerDivider = T:CreateHeaderDivider(frame.header)
headerDivider:SetPoint("RIGHT", frame.closeButton, "LEFT", -5, 0)
clearAllButton:SetPoint("RIGHT", headerDivider, "LEFT", -6, 0)

local body = frame.body

-- -----------------------------------------------------------------------------
-- Helpers de dados
-- -----------------------------------------------------------------------------
local function GetSessionItemPrice(data, itemID)
    if data.unitPrice then
        return data.unitPrice > 0 and data.unitPrice or nil
    end
    if not FarmTracker:IsMarketable(data.bindType) then
        return nil
    end
    return FarmTracker:GetItemPrice(tonumber(itemID), data.link)
end

local function CalculateSessionValue(session)
    if session.valueFrozen then
        return (session.totalValue or 0) > 0 and session.totalValue or nil
    end
    if not FarmTracker:GetPriceSource() then
        return nil
    end
    local total = 0
    for itemID, data in pairs(session.lootTable or {}) do
        local price = GetSessionItemPrice(data, itemID)
        if price then total = total + price * (data.count or 0) end
    end
    return total > 0 and total or nil
end

local function CountItems(lootTable)
    local total = 0
    for _, data in pairs(lootTable or {}) do
        total = total + (data.count or 0)
    end
    return total
end

local function ShortDuration(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    if h > 0 then
        return string.format("%dh %02dm", h, m)
    end
    return string.format("%dm", math.max(m, seconds > 0 and 1 or 0))
end

local function DayLabel(ts)
    if not ts then return L["Unknown date"] end
    local key = date("%Y-%m-%d", ts)
    if key == date("%Y-%m-%d") then return L["Today"] end
    if key == date("%Y-%m-%d", time() - 86400) then return L["Yesterday"] end
    return date(L["%a, %b %d"], ts)
end

-- -----------------------------------------------------------------------------
-- Coluna de sessões
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

local navFooter = CreateFrame("Frame", nil, nav)
navFooter:SetPoint("BOTTOMLEFT")
navFooter:SetPoint("BOTTOMRIGHT", -1, 0)
navFooter:SetHeight(30)
local navFooterLine = T:CreateColorTexture(navFooter, "borderDim", "BORDER")
navFooterLine:SetPoint("TOPLEFT")
navFooterLine:SetPoint("TOPRIGHT")
navFooterLine:SetHeight(1)
local navCount = T:CreateText(navFooter, 11, "muted")
navCount:SetPoint("LEFT", 12, 0)
local navTotal = T:CreateText(navFooter, 11, "text")
navTotal:SetPoint("RIGHT", -12, 0)
navTotal:SetJustifyH("RIGHT")

local navScroll = T:CreateScrollArea(nav)
navScroll:SetPoint("TOPLEFT", 0, -6)
navScroll:SetPoint("BOTTOMRIGHT", navFooter, "TOPRIGHT", -2, 2)

local dayPool, tabPool = {}, {}

local function AcquireDay(i)
    local d = dayPool[i]
    if d then return d end
    d = CreateFrame("Frame", nil, navScroll.child)
    d:SetHeight(24)
    d.label = T:CreateText(d, 12, "accent")
    d.label:SetPoint("LEFT", 12, -2)
    d.line = T:CreateColorTexture(d, "borderDim", "BORDER")
    d.line:SetHeight(1)
    d.line:SetPoint("LEFT", d.label, "RIGHT", 6, 0)
    d.line:SetPoint("RIGHT", -10, -2)
    dayPool[i] = d
    return d
end

local function AcquireTab(i)
    local b = tabPool[i]
    if b then return b end
    b = T:CreateNavButton(navScroll.child, 42)
    b.time = T:CreateText(b, 15, "text")
    b.time:SetPoint("TOPLEFT", 8, -6)
    b.dur = T:CreateText(b, 11, "muted")
    b.dur:SetPoint("TOPRIGHT", -8, -8)
    b.dur:SetJustifyH("RIGHT")
    b.items = T:CreateText(b, 11, "muted")
    b.items:SetPoint("BOTTOMLEFT", 8, 6)
    b.gold = T:CreateText(b, 11, "text")
    b.gold:SetPoint("BOTTOMRIGHT", -8, 6)
    b.gold:SetJustifyH("RIGHT")
    function b:OnPaint()
        T:SetTextRole(self.time, self.fbSelected and "accent" or "text")
    end
    tabPool[i] = b
    return b
end

-- -----------------------------------------------------------------------------
-- Detalhe
-- -----------------------------------------------------------------------------
local detail = CreateFrame("Frame", nil, body)
detail:SetPoint("TOPLEFT", NAV_W + 14, -14)
detail:SetPoint("BOTTOMRIGHT", -14, 12)

local titleText = T:CreateText(detail, 18, "accent")
titleText:SetPoint("TOPLEFT")
titleText:SetShadowOffset(1, -1)
titleText:SetShadowColor(0, 0, 0, 1)
local rangeText = T:CreateText(detail, 12, "muted")
rangeText:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -4)

local modeChip = T:CreatePanel(detail, "secondary", "borderMid")
modeChip:SetHeight(20)
modeChip:SetPoint("TOPRIGHT", 0, 0)
local modeText = T:CreateText(modeChip, 11, "text")
modeText:SetPoint("CENTER")
modeText:SetJustifyH("CENTER")

local statDefs = { L["Duration"], L["Items"], L["Est. value"] }
local stats = {}
local detailWidth = WIDTH - 4 - NAV_W - 28
local statW = (detailWidth - 12) / 3
for i, label in ipairs(statDefs) do
    local box = T:CreateStatBox(detail, label, 16)
    box:SetSize(statW, 48)
    box:SetPoint("TOPLEFT", (i - 1) * (statW + 6), -48)
    stats[i] = box
end

local lootPanel = T:CreatePanel(detail, "panel", "borderDim")
lootPanel:SetPoint("TOPLEFT", 0, -106)
lootPanel:SetPoint("BOTTOMRIGHT", 0, 38)
local lootScroll = T:CreateScrollArea(lootPanel)
lootScroll:SetPoint("TOPLEFT", 1, -3)
lootScroll:SetPoint("BOTTOMRIGHT", -3, 3)

local deleteButton = T:CreateButton(detail, L["Delete session"], 120, 26, "primary")
deleteButton:SetPoint("BOTTOMRIGHT")
local priceNote = T:CreateText(detail, 11, "muted")
priceNote:SetPoint("BOTTOMLEFT", 0, 7)
priceNote:SetPoint("RIGHT", deleteButton, "LEFT", -8, 0)

local catPool, itemPool = {}, {}

local function AcquireCat(i)
    local h = catPool[i]
    if h then return h end
    h = CreateFrame("Frame", nil, lootScroll.child)
    h:SetHeight(26)
    h.label = T:CreateText(h, 12, "accent")
    h.label:SetPoint("LEFT", 10, -2)
    h.count = T:CreateText(h, 12, "muted")
    h.count:SetPoint("RIGHT", -10, -2)
    h.line = T:CreateColorTexture(h, "borderDim", "BORDER")
    h.line:SetPoint("BOTTOMLEFT", 6, 0)
    h.line:SetPoint("BOTTOMRIGHT", -6, 0)
    h.line:SetHeight(1)
    catPool[i] = h
    return h
end

local function AcquireItem(i)
    local r = itemPool[i]
    if r then return r end
    r = CreateFrame("Button", nil, lootScroll.child)
    r:SetHeight(30)
    r.hl = T:CreateColorTexture(r, "hover", "BACKGROUND")
    r.hl:SetAllPoints()
    r.hl:Hide()
    r.iconFrame = CreateFrame("Frame", nil, r, BackdropTemplateMixin and "BackdropTemplate")
    r.iconFrame:SetSize(24, 24)
    r.iconFrame:SetPoint("LEFT", 10, 0)
    r.icon = r.iconFrame:CreateTexture(nil, "ARTWORK")
    r.icon:SetPoint("TOPLEFT", 1, -1)
    r.icon:SetPoint("BOTTOMRIGHT", -1, 1)
    r.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    r.value = T:CreateText(r, 12, "text")
    r.value:SetPoint("RIGHT", -12, 0)
    r.value:SetJustifyH("RIGHT")
    r.value:SetWidth(140)
    r.count = T:CreateText(r, 13, "white")
    r.count:SetPoint("RIGHT", r.value, "LEFT", -8, 0)
    r.count:SetJustifyH("RIGHT")
    r.count:SetWidth(48)
    r.name = T:CreateText(r, 13, nil)
    r.name:SetPoint("LEFT", r.iconFrame, "RIGHT", 9, 0)
    r.name:SetPoint("RIGHT", r.count, "LEFT", -6, 0)
    r.name:SetWordWrap(false)
    r:SetScript("OnEnter", function(self)
        self.hl:Show()
        if self.link then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetHyperlink(self.link)
            GameTooltip:Show()
        end
    end)
    r:SetScript("OnLeave", function(self)
        self.hl:Hide()
        GameTooltip:Hide()
    end)
    r:SetScript("OnClick", function(self)
        if self.link and IsModifiedClick("CHATLINK") then
            ChatEdit_InsertLink(self.link)
        end
    end)
    itemPool[i] = r
    return r
end

-- Estado vazio
local emptyState = CreateFrame("Frame", nil, body)
emptyState:SetAllPoints()
local emptyIcon = emptyState:CreateTexture(nil, "ARTWORK")
emptyIcon:SetSize(40, 40)
emptyIcon:SetPoint("CENTER", 0, 30)
emptyIcon:SetTexture("Interface\\AddOns\\FarmBuddy\\icon\\history.png")
emptyIcon:SetAlpha(0.5)
local emptyTitle = T:CreateText(emptyState, 16, "accent")
emptyTitle:SetPoint("TOP", emptyIcon, "BOTTOM", 0, -10)
emptyTitle:SetText(L["No sessions recorded"])
local emptySub = T:CreateText(emptyState, 12, "muted")
emptySub:SetPoint("TOP", emptyTitle, "BOTTOM", 0, -6)
emptySub:SetText(L["Finished farms will show up here."])

-- -----------------------------------------------------------------------------
-- Montagem
-- -----------------------------------------------------------------------------
local selectedIndex
local Build

local function ShowDetail(session)
    local ts = session.startTimestamp
    local startHM = ts and date("%H:%M", ts) or (session.startTime or "?")
    titleText:SetText(ts and (DayLabel(ts) == L["Today"] and L["Today"] or date(L["%a, %b %d"], ts)) .. " · " .. startHM
        or (session.startTime or L["Unknown date"]))
    if ts then
        rangeText:SetText(startHM .. " – " .. date("%H:%M", ts + (session.duration or 0)))
    else
        rangeText:SetText("")
    end

    if session.mode == "free" then
        modeText:SetText(L["Free mode"])
        modeChip:Show()
    elseif session.mode == "limit" and session.limit then
        modeText:SetText(string.format(L["Limit %s"], T:FormatClock(session.limit)))
        modeChip:Show()
    else
        modeChip:Hide()
    end
    modeChip:SetWidth(modeText:GetStringWidth() + 18)

    local value = CalculateSessionValue(session)
    local duration = session.duration or 0
    stats[1]:SetValue(T:FormatClock(duration))
    stats[2]:SetValue(tostring(CountItems(session.lootTable)))
    if value then
        stats[3]:SetValue(T:FormatMoney(value))
    else
        stats[3]:SetValue("—")
    end

    if session.valueFrozen then
        priceNote:SetText(L["Prices frozen when the session ended"])
    elseif value then
        priceNote:SetText(L["Prices from current market data"])
    else
        priceNote:SetText(L["No price source (TSM or Auctionator)"])
    end

    -- Loot por categoria
    local groups, order = {}, {}
    for itemID, data in pairs(session.lootTable or {}) do
        local category = data.category or L["Others"]
        if not groups[category] then
            groups[category] = { items = {}, count = 0 }
            table.insert(order, category)
        end
        groups[category].count = groups[category].count + (data.count or 0)
        table.insert(groups[category].items, { id = itemID, data = data })
    end
    table.sort(order)

    local y, ci, ii = 2, 0, 0
    for _, category in ipairs(order) do
        local g = groups[category]
        ci = ci + 1
        local h = AcquireCat(ci)
        h:ClearAllPoints()
        h:SetPoint("TOPLEFT", 0, -y)
        h:SetPoint("RIGHT", lootScroll.child, "RIGHT", -8, 0)
        h.label:SetText(L[category])
        h.count:SetText(g.count)
        h:Show()
        y = y + 28
        table.sort(g.items, function(a, b) return (a.data.label or "") < (b.data.label or "") end)
        for _, entry in ipairs(g.items) do
            local data = entry.data
            ii = ii + 1
            local r = AcquireItem(ii)
            r:ClearAllPoints()
            r:SetPoint("TOPLEFT", 0, -y)
            r:SetPoint("RIGHT", lootScroll.child, "RIGHT", -8, 0)
            r.link = data.link
            r.icon:SetTexture(data.icon ~= "" and data.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
            local qr, qg, qb = T:QualityColor(data.quality)
            T:ApplyEdge(r.iconFrame, 1, false)
            r.iconFrame:SetBackdropBorderColor(qr, qg, qb, 0.9)
            r.name:SetText(data.label or data.link or "?")
            r.name:SetTextColor(qr, qg, qb)
            r.count:SetText("x" .. (data.count or 0))
            local price = GetSessionItemPrice(data, entry.id)
            r.value:SetText(price and T:FormatMoney(price * (data.count or 0)) or "—")
            r:Show()
            y = y + 30
        end
        y = y + 4
    end
    for i = ci + 1, #catPool do catPool[i]:Hide() end
    for i = ii + 1, #itemPool do itemPool[i]:Hide() end
    lootScroll:SetContentHeight(y)
    lootScroll.bar:SetValue(0)
end

Build = function()
    local history = FarmTracker:GetProfile().sessionHistory or {}

    if #history == 0 then
        nav:Hide()
        detail:Hide()
        emptyState:Show()
        clearAllButton:Disable()
        return
    end
    nav:Show()
    detail:Show()
    emptyState:Hide()
    clearAllButton:Enable()

    -- Mais recentes primeiro
    local ordered = {}
    for i = #history, 1, -1 do
        table.insert(ordered, i)
    end
    table.sort(ordered, function(a, b)
        local ta = history[a].startTimestamp or 0
        local tb = history[b].startTimestamp or 0
        if ta == tb then return a > b end
        return ta > tb
    end)

    if not selectedIndex or not history[selectedIndex] then
        selectedIndex = ordered[1]
    end

    local y, di, ti = 4, 0, 0
    local lastDay
    local grandTotal = 0
    for _, idx in ipairs(ordered) do
        local session = history[idx]
        local ts = session.startTimestamp
        local day = DayLabel(ts)
        if day ~= lastDay then
            di = di + 1
            local d = AcquireDay(di)
            d:ClearAllPoints()
            d:SetPoint("TOPLEFT", 0, -y)
            d:SetPoint("RIGHT", navScroll.child, "RIGHT", -6, 0)
            d.label:SetText(day)
            d:Show()
            y = y + 26
            lastDay = day
        end

        local value = CalculateSessionValue(session)
        grandTotal = grandTotal + (value or 0)

        ti = ti + 1
        local b = AcquireTab(ti)
        b:ClearAllPoints()
        b:SetPoint("TOPLEFT", 8, -y)
        b:SetPoint("RIGHT", navScroll.child, "RIGHT", -12, 0)
        b.time:SetText(ts and date("%H:%M", ts) or (session.startTime or "?"):match("(%d+:%d+)") or "?")
        b.dur:SetText(ShortDuration(session.duration or 0))
        b.items:SetText(string.format(L["%d items"], CountItems(session.lootTable)))
        b.gold:SetText(value and T:FormatMoney(value) or "")
        b:SetSelected(idx == selectedIndex)
        b:SetScript("OnClick", function()
            selectedIndex = idx
            Build()
        end)
        b:Show()
        y = y + 45
    end
    for i = di + 1, #dayPool do dayPool[i]:Hide() end
    for i = ti + 1, #tabPool do tabPool[i]:Hide() end
    navScroll:SetContentHeight(y + 4)

    navCount:SetText(string.format(L["%d sessions"], #history))
    navTotal:SetText(grandTotal > 0 and T:FormatMoney(grandTotal) or "")

    ShowDetail(history[selectedIndex])
end

-- -----------------------------------------------------------------------------
-- Ações
-- -----------------------------------------------------------------------------
StaticPopupDialogs["FARMBUDDY_CLEAR_HISTORY"] = {
    text = L["Are you sure you want to clear all farm history for this character?"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
        wipe(FarmTracker:GetProfile().sessionHistory)
        selectedIndex = nil
        Build()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

StaticPopupDialogs["FARMBUDDY_DELETE_SESSION"] = {
    text = L["Delete this session from the history?"],
    button1 = L["Yes"],
    button2 = L["No"],
    OnAccept = function()
        local history = FarmTracker:GetProfile().sessionHistory
        if selectedIndex and history[selectedIndex] then
            table.remove(history, selectedIndex)
        end
        selectedIndex = nil
        Build()
    end,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
}

clearAllButton:SetScript("OnClick", function()
    StaticPopup_Show("FARMBUDDY_CLEAR_HISTORY")
end)
deleteButton:SetScript("OnClick", function()
    StaticPopup_Show("FARMBUDDY_DELETE_SESSION")
end)

T:OnChange(function()
    if frame:IsShown() then Build() end
end)

-- Uma sessão nova aparece no histórico assim que é salva
FarmTracker:OnStateChanged(function()
    if frame:IsShown() and not FarmTracker.sessionActive then
        selectedIndex = nil
        Build()
    end
end)

-- API pública
FarmBuddyHistory = {}

function FarmBuddyHistory:Toggle()
    if frame:IsShown() then
        frame:Hide()
    else
        selectedIndex = nil
        frame:Show()
        Build()
    end
end

function FarmBuddyHistory:Refresh()
    if frame:IsShown() then Build() end
end
