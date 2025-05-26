TrackerSettings = {}
local settingsFrame
local checkboxes = {}
local defaultCategories = {}

function TrackerSettings:Init(parent)
    settingsFrame = CreateFrame("Frame", "SettingsFrame", parent, "BasicFrameTemplateWithInset")
    settingsFrame:SetSize(300, 400)
    settingsFrame:SetPoint("CENTER")
    settingsFrame:SetBackdrop(
    {
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    settingsFrame:SetBackdropBorderColor(1, 1, 1, 1)
    settingsFrame:Hide()

    settingsFrame.title = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
    settingsFrame.title:SetPoint("TOP", 0, -10)
    settingsFrame.title:SetText("Settings")

    -- Botão fechar
    local closeButton = CreateFrame("Button", nil, settingsFrame, "UIPanelCloseButton")
    closeButton:SetPoint("TOPRIGHT", -6, -6)

    -- Inicializa checkboxes mais tarde via :BuildCheckboxes
end

function TrackerSettings(categories)
    for _, cb in pairs(checkboxes) do cb:Hide() end
    wipe(checkboxes)

    local yOffset = -40
    for _, category in ipairs(categories) do
        local checkbox = CreateFrame("CheckButton", nil, settingsFrame, "ChatConfigCheckButtonTemplate")
        checkbox:SetPoint("TOPLEFT", 20, yOffset)
        checkbox.Text:SetText(category)
        checkbox:SetChecked(FarmBuddyDB.categoryFilters == nil or FarmBuddyDB.categoryFilters[category] ~= false)

        checkbox:SetScript("OnClick", function(self)
            local checked = self:GetChecked()
            FarmBuddyDB.categoryFilters[category] = checked
            if DisplayItem and DisplayItem.UpdateDisplay then
                DisplayItem:UpdateDisplay(FarmTracker.lootTable)
            end
        end)

        checkboxes[#checkboxes+1] = checkbox
        yOffset = yOffset - 30
    end
end

-- Retorna a categoria do item
function TrackerSettings:GetCategory(link)
    local _, _, _, _, _, itemType, itemSubType = GetItemInfo(link)
    return itemSubType or itemType or "Outros"
end

-- Alterna a exibição do frame
function TrackerSettings:Toggle()
    if settingsFrame:IsShown() then
        settingsFrame:Hide()
    else
        settingsFrame:Show()
    end
end