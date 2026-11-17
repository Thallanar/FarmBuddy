-- =============================================================================
-- FarmBuddy - Lista de loot da sessão (dentro da janela principal)
-- =============================================================================
-- Agrupa os itens por categoria (recolhível), respeita os filtros do perfil
-- e calcula os totais (itens e valor estimado) usados nos blocos do topo.
-- =============================================================================

local L = FarmBuddyL
local T = FarmBuddyTheme

DisplayItem = DisplayItem or {}
DisplayItem.totalItems = 0
DisplayItem.totalValue = 0

local scroll
local headerPool, rowPool = {}, {}
local collapsed = {}
local emptyText
local lastLootTable

local HEADER_H = 26
local ROW_H = 34
local ARROW = "Interface\\ChatFrame\\ChatFrameExpandArrow"

local function AcquireHeader(i)
    local h = headerPool[i]
    if h then return h end
    local child = scroll.child
    h = CreateFrame("Button", nil, child)
    h:SetHeight(HEADER_H)
    h.arrow = h:CreateTexture(nil, "OVERLAY")
    h.arrow:SetSize(12, 12)
    h.arrow:SetPoint("LEFT", 8, 0)
    h.arrow:SetTexture(ARROW)
    T:Register(h.arrow, function(a) a:SetVertexColor(T:Color("accent")) end)
    h.label = T:CreateText(h, 13, "accent")
    h.label:SetPoint("LEFT", h.arrow, "RIGHT", 4, 0)
    h.count = T:CreateText(h, 12, "muted")
    h.count:SetPoint("RIGHT", -10, 0)
    h.line = T:CreateColorTexture(h, "borderDim", "BORDER")
    h.line:SetPoint("BOTTOMLEFT", 6, 0)
    h.line:SetPoint("BOTTOMRIGHT", -6, 0)
    h.line:SetHeight(1)
    headerPool[i] = h
    return h
end

local function AcquireRow(i)
    local r = rowPool[i]
    if r then return r end
    local child = scroll.child
    r = CreateFrame("Button", nil, child)
    r:SetHeight(ROW_H)

    r.hl = T:CreateColorTexture(r, "hover", "BACKGROUND")
    r.hl:SetAllPoints()
    r.hl:Hide()

    r.iconFrame = CreateFrame("Frame", nil, r, BackdropTemplateMixin and "BackdropTemplate")
    r.iconFrame:SetSize(28, 28)
    r.iconFrame:SetPoint("LEFT", 10, 0)
    r.icon = r.iconFrame:CreateTexture(nil, "ARTWORK")
    r.icon:SetPoint("TOPLEFT", 1, -1)
    r.icon:SetPoint("BOTTOMRIGHT", -1, 1)
    r.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)

    r.count = T:CreateText(r, 14, "white")
    r.count:SetPoint("RIGHT", -12, 0)
    r.count:SetJustifyH("RIGHT")

    r.name = T:CreateText(r, 13, nil)
    r.name:SetPoint("TOPLEFT", r.iconFrame, "TOPRIGHT", 9, -1)
    r.name:SetPoint("RIGHT", r.count, "LEFT", -8, 0)
    r.name:SetWordWrap(false)

    r.price = T:CreateText(r, 11, "muted")
    r.price:SetPoint("BOTTOMLEFT", r.iconFrame, "BOTTOMRIGHT", 9, 1)

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
    -- Shift+clique linka o item no chat
    r:SetScript("OnClick", function(self)
        if self.link and IsModifiedClick("CHATLINK") then
            ChatEdit_InsertLink(self.link)
        end
    end)
    rowPool[i] = r
    return r
end

function DisplayItem:Init(parent)
    scroll = T:CreateScrollArea(parent)
    scroll:SetPoint("TOPLEFT", 1, -3)
    scroll:SetPoint("BOTTOMRIGHT", -3, 3)

    emptyText = T:CreateText(parent, 12, "muted")
    emptyText:SetPoint("CENTER")
    emptyText:SetJustifyH("CENTER")
    emptyText:SetWidth(260)
    emptyText:SetText(L["Loot you pick up during a session shows up here."])

    T:OnChange(function()
        if lastLootTable then DisplayItem:UpdateDisplay(lastLootTable) end
    end)
end

local function ItemPrice(itemID, data)
    if not FarmTracker:IsMarketable(data.bindType) then return nil end
    return FarmTracker:GetItemPrice(tonumber(itemID), data.link)
end

function DisplayItem:UpdateDisplay(lootTable)
    lastLootTable = lootTable or {}
    if not scroll then return end

    local filters = FarmTracker:GetProfile().categoryFilters or {}
    local groups = {}
    local order = {}
    local totalItems, totalValue = 0, 0

    for itemID, data in pairs(lastLootTable) do
        local price = ItemPrice(itemID, data)
        totalItems = totalItems + (data.count or 0)
        if price then totalValue = totalValue + price * (data.count or 0) end

        local category = data.category or L["Others"]
        local key = (data.group or "Others") .. "::" .. category
        if filters[key] ~= false then
            if not groups[category] then
                groups[category] = { label = category, items = {}, count = 0 }
                table.insert(order, category)
            end
            local g = groups[category]
            g.count = g.count + (data.count or 0)
            table.insert(g.items, { data = data, price = price })
        end
    end

    self.totalItems = totalItems
    self.totalValue = totalValue

    table.sort(order)
    local y = 2
    local hIndex, rIndex = 0, 0

    for _, category in ipairs(order) do
        local g = groups[category]
        hIndex = hIndex + 1
        local h = AcquireHeader(hIndex)
        h:ClearAllPoints()
        h:SetPoint("TOPLEFT", 0, -y)
        h:SetPoint("RIGHT", scroll.child, "RIGHT", -8, 0)
        h.label:SetText(L[g.label])
        h.count:SetText(g.count)
        local isCollapsed = collapsed[category]
        h.arrow:SetRotation(isCollapsed and 0 or math.rad(-90))
        h:SetScript("OnClick", function()
            collapsed[category] = not collapsed[category]
            DisplayItem:UpdateDisplay(lastLootTable)
        end)
        h:Show()
        y = y + HEADER_H + 2

        if not isCollapsed then
            table.sort(g.items, function(a, b) return (a.data.label or "") < (b.data.label or "") end)
            for _, entry in ipairs(g.items) do
                local data = entry.data
                rIndex = rIndex + 1
                local r = AcquireRow(rIndex)
                r:ClearAllPoints()
                r:SetPoint("TOPLEFT", 0, -y)
                r:SetPoint("RIGHT", scroll.child, "RIGHT", -8, 0)
                r.link = data.link
                r.icon:SetTexture(data.icon ~= "" and data.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
                local qr, qg, qb = T:QualityColor(data.quality)
                r.name:SetText(data.label or data.link or "?")
                r.name:SetTextColor(qr, qg, qb)
                T:ApplyEdge(r.iconFrame, 1, false)
                r.iconFrame:SetBackdropBorderColor(qr, qg, qb, 0.9)
                r.count:SetText("x" .. (data.count or 0))
                if entry.price then
                    r.price:SetText(string.format(L["%s each"], string.format("%.2f", entry.price / 10000) .. T.COIN))
                else
                    r.price:SetText(L["No price"])
                end
                r:Show()
                y = y + ROW_H
            end
        end
        y = y + 4
    end

    for i = hIndex + 1, #headerPool do headerPool[i]:Hide() end
    for i = rIndex + 1, #rowPool do rowPool[i]:Hide() end

    emptyText:SetShown(hIndex == 0)
    scroll:SetContentHeight(y)
end
