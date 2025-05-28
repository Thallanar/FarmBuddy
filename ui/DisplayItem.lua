DisplayItem = {}
local displayFrame
local scrollFrame
local contentFrame
local toggleButton
local itemFrames = {}
local isVisible = true

local FRAME_WIDTH = 240
local FRAME_HEIGHT = 400

function DisplayItem:Init(parent)
    displayFrame = CreateFrame("Frame", nil, parent)
    displayFrame:SetPoint("TOPLEFT", parent, "TOPRIGHT", 10, 0)
    displayFrame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)

    local bg = displayFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints(true)
    bg:SetColorTexture(0, 0, 0, 0.4) -- fundo preto com 40% de opacidade

    local border = CreateFrame("Frame", nil, displayFrame, "BackdropTemplate")
    border:SetAllPoints()
    border:SetBackdrop({
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
    })
    border:SetBackdropBorderColor(1, 1, 1, 1)

    -- ScrollFrame
    scrollFrame = CreateFrame("ScrollFrame", nil, displayFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 5, -5)
    scrollFrame:SetPoint("BOTTOMRIGHT", -25, 5)

    --ScrollFrame Content
    contentFrame = CreateFrame("Frame", nil, scrollFrame)
    contentFrame:SetSize(FRAME_WIDTH - 30, 1)
    scrollFrame:SetScrollChild(contentFrame)

    -- Botão lateral
    toggleButton = CreateFrame("Button", nil, parent)
    toggleButton:SetSize(24, 48)
    toggleButton:SetPoint("LEFT", displayFrame, "RIGHT", 0, 0)

    local arrow = toggleButton:CreateTexture(nil, "ARTWORK")
    arrow:SetAllPoints()
    arrow:SetTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")

    toggleButton:SetScript("OnClick", function()
        isVisible = not isVisible
        if isVisible then
            displayFrame:Show()
            toggleButton:SetPoint("LEFT", displayFrame, "RIGHT", 0, 0)
            arrow:SetTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up") -- →
        else
            displayFrame:Hide()
            toggleButton:SetPoint("LEFT", parent, "RIGHT", 0, 0)
            arrow:SetTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up") -- ←
        end
    end)
end

-- Agrupa os itens por tipo (ex: "Minério", "Couro", etc.)
local function CategorizeItem(link)
    local _, _, _, _, _, itemType, itemSubType = GetItemInfo(link)
    return itemSubType or itemType or "Outros"
end

function DisplayItem:UpdateDisplay(lootTable)
    -- Limpa a exibição anterior
    for _, frame in ipairs(itemFrames) do
        frame:Hide()
    end
    wipe(itemFrames)

    -- Organiza os itens por categoria
    local categorized = {}
    for link, data in pairs(lootTable) do
        local category = CategorizeItem(data.link)
        categorized[category] = categorized[category] or {}
        table.insert(categorized[category], data)
    end

     -- Ordena categorias alfabeticamente
    local sortedCategories = {}
    for cat in pairs(categorized) do
        table.insert(sortedCategories, cat)
    end
    table.sort(sortedCategories)

    local yOffset = 0

    for _, category in ipairs(sortedCategories) do
        local showCategory = not FarmBuddyDB.EnabledCategories or FarmBuddyDB.EnabledCategories[category] ~= false
        if showCategory then
            local items = categorized[category]

            -- Título da categoria
            local titleFrame = CreateFrame("Frame", nil, contentFrame)
            titleFrame:SetSize(200, 20)
            titleFrame:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 0, -yOffset)

            local titleText = titleFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            titleText:SetPoint("LEFT", titleFrame, "LEFT", 0, 0)
            titleText:SetText("|cffffff00" .. category .. "|r")

            table.insert(itemFrames, titleFrame)
            yOffset = yOffset + 22

            for _, data in ipairs(items) do
                local frame = CreateFrame("Frame", nil, contentFrame)
                frame:SetSize(200, 24)
                frame:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 0, -yOffset)

                -- Ícone
                local icon = frame:CreateTexture(nil, "ARTWORK")
                icon:SetSize(20, 20)
                icon:SetPoint("LEFT", frame, "LEFT", 0, 0)
                icon:SetTexture(data.icon or "")

                -- Tooltip
                frame:SetScript("OnEnter", function()
                    GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
                    GameTooltip:SetHyperlink(data.link)
                    GameTooltip:Show()
                end)
                frame:SetScript("OnLeave", function()
                    GameTooltip:Hide()
                end)

                -- Nome formatado com qualidade (link)
                local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                text:SetPoint("LEFT", icon, "RIGHT", 6, 0)
                text:SetText(data.link .. " x" .. data.count)

                table.insert(itemFrames, frame)
                yOffset = yOffset + 26
            end
        end
    end

    contentFrame:SetHeight(yOffset + 10)
end