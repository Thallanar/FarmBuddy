local settingsMainUI = CreateFrame("Frame")

TrackerSettings = {}
local checkboxes = {}

function TrackerSettings:BuildCheckboxes(categories)
    for _, cb in pairs(checkboxes) do 
            cb:Hide() 
        end
    wipe(checkboxes)

    local yOffset = -40
    for _, category in ipairs(categories) do
        local cb = CreateFrame("CheckButton", nil, settingsFrame, "ChatConfigCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", settingsFrame, 20, yOffset)
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
end

-- settingsMainUI:SetScript("IsShown", )