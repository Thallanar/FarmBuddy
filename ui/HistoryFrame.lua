local historyFrame = CreateFrame("Frame", "FarmBuddyHistoryFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
historyFrame:SetSize(420, 450)
historyFrame:SetPoint("CENTER")
historyFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
historyFrame:SetMovable(true)
historyFrame:EnableMouse(true)
historyFrame:RegisterForDrag("LeftButton")
historyFrame:SetScript("OnDragStart", historyFrame.StartMoving)
historyFrame:SetScript("OnDragStop", historyFrame.StopMovingOrSizing)
historyFrame:Hide()

-- Title Bar
local titleBar = CreateFrame("Frame", nil, historyFrame)
titleBar:SetSize(historyFrame:GetWidth(), 24)
titleBar:SetPoint("TOP", historyFrame, "TOP", 0, -6)

local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("LEFT", 15, 0)
titleText:SetText("Histórico de Farm")

-- Close Button
local closeButton = CreateFrame("Button", nil, titleBar)
closeButton:SetSize(24, 24)
closeButton:SetPoint("TOPRIGHT", -8, 0)
closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

local closeIcon = closeButton:CreateTexture(nil, "ARTWORK")
closeIcon:SetAllPoints()
closeIcon:SetTexture("Interface\\AddOns\\FarmBuddy\\icon\\close.png")

closeButton:SetScript("OnClick", function()
    historyFrame:Hide()
end)

-- Clear History Button
local clearButton = CreateFrame("Button", nil, titleBar)
clearButton:SetSize(20, 20)
clearButton:SetPoint("RIGHT", closeButton, "LEFT", -2, 0)
clearButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
clearButton:SetNormalTexture("Interface\\Buttons\\UI-RefreshButton")

clearButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine("Limpar histórico")
    GameTooltip:Show()
end)
clearButton:SetScript("OnLeave", function()
    GameTooltip:Hide()
end)

-- ScrollFrame
local scrollFrame = CreateFrame("ScrollFrame", nil, historyFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -35)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(360, 1)
scrollFrame:SetScrollChild(scrollChild)

-- State
local expandedSessions = {}
local sessionFrames = {}

local function FormatDuration(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60
    return string.format("%02d:%02d:%02d", h, m, s)
end

local function CountItems(lootTable)
    local total = 0
    for _, data in pairs(lootTable) do
        total = total + (data.count or 0)
    end
    return total
end

local function CalculateSessionValue(lootTable)
    if not FarmTracker:GetPriceSource() then
        return nil
    end

    local totalValue = 0
    for itemID, data in pairs(lootTable) do
        local price = FarmTracker:GetItemPrice(tonumber(itemID), data.link)
        if price then
            totalValue = totalValue + (price * data.count)
        end
    end

    return totalValue > 0 and totalValue or nil
end

local function BuildHistory()
    -- Limpa frames anteriores
    for _, frame in ipairs(sessionFrames) do
        frame:Hide()
    end
    wipe(sessionFrames)

    local profile = FarmTracker:GetProfile()
    local history = profile.sessionHistory

    if not history or #history == 0 then
        local emptyText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        emptyText:SetPoint("CENTER", scrollChild, "CENTER", 0, 0)
        emptyText:SetText("Nenhuma sessão registrada.")

        local wrapper = CreateFrame("Frame", nil, scrollChild)
        wrapper:SetSize(360, 40)
        wrapper:SetPoint("TOPLEFT", 0, 0)
        table.insert(sessionFrames, wrapper)

        scrollChild:SetHeight(40)
        return
    end

    local yOffset = 0

    -- Itera de trás pra frente (mais recentes primeiro)
    for i = #history, 1, -1 do
        local session = history[i]
        local itemCount = CountItems(session.lootTable or {})
        local sessionValue = CalculateSessionValue(session.lootTable or {})
        local isExpanded = expandedSessions[i]

        -- Header da sessão
        local header = CreateFrame("Button", nil, scrollChild)
        header:SetSize(360, 22)
        header:SetPoint("TOPLEFT", 0, -yOffset)

        local headerBg = header:CreateTexture(nil, "BACKGROUND")
        headerBg:SetAllPoints()
        headerBg:SetColorTexture(0.2, 0.2, 0.2, 0.6)

        local arrow = isExpanded and "|cff00ff00[-]|r" or "|cffffaa00[+]|r"
        local headerLabel = header:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        headerLabel:SetPoint("LEFT", 5, 0)

        local headerString = string.format("%s  %s  |  %s  |  %d itens",
            arrow,
            session.startTime or "?",
            FormatDuration(session.duration or 0),
            itemCount
        )

        if sessionValue then
            headerString = headerString .. "  |  " .. FarmTracker:FormatMoney(sessionValue)
        end

        headerLabel:SetText(headerString)

        header:SetScript("OnClick", function()
            expandedSessions[i] = not expandedSessions[i]
            BuildHistory()
        end)

        table.insert(sessionFrames, header)
        yOffset = yOffset + 24

        -- Itens da sessão (se expandida)
        if isExpanded and session.lootTable then
            local sessionTotal = 0

            -- Ordena itens por nome
            local sortedItems = {}
            for itemID, data in pairs(session.lootTable) do
                data.itemID = itemID
                table.insert(sortedItems, data)
            end
            table.sort(sortedItems, function(a, b)
                return (a.label or "") < (b.label or "")
            end)

            for _, data in ipairs(sortedItems) do
                local itemFrame = CreateFrame("Frame", nil, scrollChild)
                itemFrame:SetSize(350, 22)
                itemFrame:SetPoint("TOPLEFT", 15, -yOffset)
                itemFrame:EnableMouse(true)

                -- Ícone
                local icon = itemFrame:CreateTexture(nil, "ARTWORK")
                icon:SetSize(18, 18)
                icon:SetPoint("LEFT", 0, 0)
                icon:SetTexture(data.icon or "")

                -- Nome + quantidade
                local text = itemFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                text:SetPoint("LEFT", icon, "RIGHT", 5, 0)

                local itemText = (data.link or data.label or "?") .. " x" .. (data.count or 0)
                local price = FarmTracker:GetItemPrice(tonumber(data.itemID), data.link)
                if price then
                    local totalItemPrice = price * (data.count or 0)
                    sessionTotal = sessionTotal + totalItemPrice
                    itemText = itemText .. "  " .. FarmTracker:FormatMoney(totalItemPrice)
                end

                text:SetText(itemText)

                -- Tooltip
                if data.link then
                    itemFrame:SetScript("OnEnter", function()
                        GameTooltip:SetOwner(itemFrame, "ANCHOR_RIGHT")
                        GameTooltip:SetHyperlink(data.link)
                        GameTooltip:Show()
                    end)
                    itemFrame:SetScript("OnLeave", function()
                        GameTooltip:Hide()
                    end)
                end

                table.insert(sessionFrames, itemFrame)
                yOffset = yOffset + 24
            end

            -- Total estimado da sessão
            if sessionTotal > 0 then
                local totalFrame = CreateFrame("Frame", nil, scrollChild)
                totalFrame:SetSize(350, 22)
                totalFrame:SetPoint("TOPLEFT", 15, -yOffset)

                local totalText = totalFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                totalText:SetPoint("LEFT", 0, 0)
                totalText:SetText("|cffffffffTotal estimado:|r  " .. FarmTracker:FormatMoney(sessionTotal))

                table.insert(sessionFrames, totalFrame)
                yOffset = yOffset + 24
            end

            yOffset = yOffset + 5
        end
    end

    scrollChild:SetHeight(math.max(yOffset + 10, 1))
end

-- Confirmação de limpeza
clearButton:SetScript("OnClick", function()
    StaticPopupDialogs["FARMBUDDY_CLEAR_HISTORY"] = {
        text = "Tem certeza que deseja limpar todo o histórico de farm deste personagem?",
        button1 = "Sim",
        button2 = "Não",
        OnAccept = function()
            local profile = FarmTracker:GetProfile()
            wipe(profile.sessionHistory)
            expandedSessions = {}
            BuildHistory()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }
    StaticPopup_Show("FARMBUDDY_CLEAR_HISTORY")
end)

-- API pública
FarmBuddyHistory = {}

function FarmBuddyHistory:Toggle()
    if historyFrame:IsShown() then
        historyFrame:Hide()
    else
        BuildHistory()
        historyFrame:Show()
    end
end
