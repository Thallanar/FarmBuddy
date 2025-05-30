TrackerSettings = TrackerSettings or {}
local expandedSections = {}
local checkboxes = {}

function TrackerSettings:BuildCheckboxes(categories)
    for _, cb in pairs(checkboxes) do 
            cb:Hide() 
    end
    wipe(checkboxes)

    local yOffset = -10

    for sectionName, categoryList in pairs(categories) do
        -- Botão de seção (cabeçalho)
        local header = CreateFrame("Button", nil, self.scrollChild)
        header:SetPoint("TOPLEFT", 10, yOffset)
        header:SetSize(260, 20)

        local label = header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetPoint("LEFT", 0, 0)
        label:SetText((expandedSections[sectionName] and "|cff00ff00[-]|r " or "|cffffaa00[+]|r ") .. sectionName)

        header:SetScript("OnClick", function()
            expandedSections[sectionName] = not expandedSections[sectionName]
            self:BuildCheckboxes(categories)
        end)

        yOffset = yOffset - 25

        if expandedSections[sectionName] then
            for _, category in ipairs(categoryList) do
                local cb = CreateFrame("CheckButton", nil, self.scrollChild, "ChatConfigCheckButtonTemplate")
                cb:SetPoint("TOPLEFT", 30, yOffset)
                cb.Text:SetText(category)
                cb:SetChecked(FarmBuddyDB.categoryFilters[category] ~= false)
                cb:SetScript("OnClick", function(self)
                    FarmBuddyDB.categoryFilters[category] = self:GetChecked()
                    if DisplayItem and DisplayItem.UpdateDisplay then
                        DisplayItem:UpdateDisplay(FarmTracker.lootTable)
                    end
                end)
                table.insert(checkboxes, cb)
                yOffset = yOffset - 30
            end
            yOffset = yOffset - 10
        end
    end

    self.scrollChild:SetHeight(-yOffset + 10)
end
