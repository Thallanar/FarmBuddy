TrackerSettings = TrackerSettings or {}
local expandedSections = {}
local checkboxes = {}
local headers = {}

function TrackerSettings:BuildCheckboxes(categories)
    for _, cb in pairs(checkboxes) do 
            cb:Hide() 
    end
    wipe(checkboxes)

    for _, h in pairs(headers) do
        h:Hide()
    end
    wipe(headers)

    local yOffset = -10

    local selectAllCB = CreateFrame("CheckButton", nil, self.scrollChild, "ChatConfigCheckButtonTemplate")
    selectAllCB:SetPoint("TOPLEFT", 10, -10)
    selectAllCB.Text:SetText("Marcar todos")

    local selecting = false -- flag para evitar loop de atualização

    selectAllCB:SetScript("OnClick", function(self)
        if selecting then return end
        selecting = true
        local check = self:GetChecked()

        for sectionName, categoryList in pairs(categories) do
            for _, category in ipairs(categoryList) do
                local key = sectionName .. "::" .. category
                FarmTracker:GetProfile().categoryFilters[key] = check
            end
        end

        -- Atualiza os checkboxes abaixo
        TrackerSettings:BuildCheckboxes(categories)

        -- Atualiza a exibição se necessário
        if DisplayItem and DisplayItem.UpdateDisplay then
            DisplayItem:UpdateDisplay(FarmTracker.lootTable)
        end

        selecting = false
    end)

    yOffset = -40 -- para dar espaço antes dos headers

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

            if DisplayItem and DisplayItem.UpdateDisplay then
                DisplayItem:UpdateDisplay(FarmTracker.lootTable)
            end
        end)

        table.insert(headers, header)

        yOffset = yOffset - 25

        if expandedSections[sectionName] then
            for _, category in ipairs(categoryList) do
                local cb = CreateFrame("CheckButton", nil, self.scrollChild, "ChatConfigCheckButtonTemplate")
                cb:SetPoint("TOPLEFT", 30, yOffset)
                cb.Text:SetText(category)

                local key = sectionName .. "::" .. category
                local isChecked = FarmTracker:GetProfile().categoryFilters[key] ~= false
                cb:SetChecked(isChecked)

                cb:SetScript("OnClick", function(self)
                    FarmTracker:GetProfile().categoryFilters[key] = self:GetChecked()
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

    self.scrollChild:SetHeight(math.abs(yOffset) + 20)
end
