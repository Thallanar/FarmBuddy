-- =============================================================================
-- FarmBuddy - Diálogos de import do GatherMate2
-- =============================================================================
-- A lista de imports agora fica em Settings > Profiles. Este arquivo só
-- mantém os diálogos (tipos de node, colar string, nome, renomear, exportar).
-- =============================================================================

local L = FarmBuddyL
local T = FarmBuddyTheme

FarmBuddyImportManager = {}
local M = FarmBuddyImportManager

local onChange
function M:SetOnChange(callback)
    onChange = callback
end

local function Changed()
    if onChange then onChange() end
end

local function CreateDialog(name, width, height, title)
    local d = T:CreateWindow(name, width, height, title)
    d:SetFrameStrata("DIALOG")
    return d
end

-- -----------------------------------------------------------------------------
-- Nome do import
-- -----------------------------------------------------------------------------
local nameDialog = CreateDialog("FarmBuddyImportNameDialog", 340, 150, L["Import Name"])
local nameInfo = T:CreateText(nameDialog.body, 12, "muted")
nameInfo:SetPoint("TOPLEFT", 14, -12)
local nameBox = T:CreateEditBox(nameDialog.body, 312, 26)
nameBox:SetPoint("TOPLEFT", 14, -32)
local nameSave = T:CreateButton(nameDialog.body, L["Save"], 90, 26, "primary")
nameSave:SetPoint("BOTTOMRIGHT", -14, 12)
local nameCancel = T:CreateButton(nameDialog.body, L["Cancel"], 90, 26, "secondary")
nameCancel:SetPoint("RIGHT", nameSave, "LEFT", -6, 0)

local pendingData, pendingSource

local function ShowNameDialog(parsedData, source)
    pendingData, pendingSource = parsedData, source
    nameInfo:SetText(string.format(L["%d nodes in %d maps"], parsedData.totalNodes, #parsedData.mapList))
    nameBox:SetText("")
    nameDialog:Show()
    nameBox:SetFocus()
end

nameSave:SetScript("OnClick", function()
    local name = nameBox:GetText()
    if name == "" then
        name = "Import " .. date("%d/%m/%Y %H:%M")
    end
    if pendingData then
        FarmBuddyGatherImport:SaveImport(name, pendingData, pendingSource)
        print("|cff00ff00[FarmBuddy]|r " .. string.format(L["Import '%s' saved successfully!"], name))
    end
    pendingData, pendingSource = nil, nil
    nameDialog:Hide()
    Changed()
end)
nameBox:SetScript("OnEnterPressed", function() nameSave:Click() end)
nameCancel:SetScript("OnClick", function()
    pendingData, pendingSource = nil, nil
    nameDialog:Hide()
end)

-- -----------------------------------------------------------------------------
-- Tipos de node (import do banco do GatherMate2)
-- -----------------------------------------------------------------------------
local typeDialog = CreateDialog("FarmBuddyImportTypeDialog", 320, 200, L["Select node types"])
local typeChecks = {}
local typeSelected = {}
local typeError = T:CreateText(typeDialog.body, 11, "warn")
typeError:SetPoint("BOTTOMLEFT", 14, 46)
local typeImport = T:CreateButton(typeDialog.body, L["Import"], 90, 26, "primary")
typeImport:SetPoint("BOTTOMRIGHT", -14, 12)
local typeCancel = T:CreateButton(typeDialog.body, L["Cancel"], 90, 26, "secondary")
typeCancel:SetPoint("RIGHT", typeImport, "LEFT", -6, 0)
typeCancel:SetScript("OnClick", function() typeDialog:Hide() end)

local NODE_LABELS = {
    Herb = "Herbs", Mine = "Ores", Fish = "Fish", Gas = "Gases",
    Treasure = "Treasures", Archaeology = "Archaeology", Logging = "Wood",
}

function M:ImportFromDatabase()
    local available, err = FarmBuddyGatherImport:GetAvailableTypes()
    if not available then
        print("|cffff0000[FarmBuddy]|r " .. (err or L["Unknown error"]))
        return
    end
    wipe(typeSelected)
    for _, cb in ipairs(typeChecks) do cb:Hide() end
    for i, info in ipairs(available) do
        local cb = typeChecks[i]
        if not cb then
            cb = T:CreateCheckbox(typeDialog.body, "")
            cb:SetPoint("TOPLEFT", 14, -14 - (i - 1) * 24)
            typeChecks[i] = cb
        end
        local label = L[NODE_LABELS[info.nodeType] or info.nodeType]
        if info.totalNodes then
            label = label .. "  |cff888888(" .. info.totalNodes .. " nodes)|r"
        end
        cb:SetLabel(label)
        cb:SetChecked(true)
        typeSelected[info.prefix] = true
        cb:SetScript("OnClick", function(self) typeSelected[info.prefix] = self:GetChecked() and true or nil end)
        cb:Show()
    end
    typeDialog:SetHeight(36 + 14 + #available * 24 + 70)
    typeError:SetText("")
    typeDialog:Show()
end

typeImport:SetScript("OnClick", function()
    if not next(typeSelected) then
        typeError:SetText(L["Select at least one type."])
        return
    end
    local parsedData, err = FarmBuddyGatherImport:ParseFromDB(typeSelected)
    if not parsedData then
        typeError:SetText(err or L["Error importing"])
        return
    end
    typeDialog:Hide()
    ShowNameDialog(parsedData, "gathermate2db")
end)

-- -----------------------------------------------------------------------------
-- Colar string
-- -----------------------------------------------------------------------------
local pasteDialog = CreateDialog("FarmBuddyImportPasteDialog", 420, 260, L["Paste the GatherMate2 export string"])
local pasteArea = T:CreateTextArea(pasteDialog.body, 392, 140)
pasteArea:SetPoint("TOPLEFT", 14, -12)
local pasteError = T:CreateText(pasteDialog.body, 11, "warn")
pasteError:SetPoint("TOPLEFT", pasteArea, "BOTTOMLEFT", 0, -6)
pasteError:SetPoint("RIGHT", -14, 0)
local pasteProcess = T:CreateButton(pasteDialog.body, L["Process"], 90, 26, "primary")
pasteProcess:SetPoint("BOTTOMRIGHT", -14, 12)
local pasteCancel = T:CreateButton(pasteDialog.body, L["Cancel"], 90, 26, "secondary")
pasteCancel:SetPoint("RIGHT", pasteProcess, "LEFT", -6, 0)
pasteCancel:SetScript("OnClick", function() pasteDialog:Hide() end)

function M:PasteString()
    pasteArea.editBox:SetText("")
    pasteError:SetText("")
    pasteDialog:Show()
    pasteArea.editBox:SetFocus()
end

pasteProcess:SetScript("OnClick", function()
    local parsedData, err = FarmBuddyGatherImport:ParseFromString(pasteArea.editBox:GetText())
    if not parsedData then
        pasteError:SetText(err or L["Error processing string"])
        return
    end
    pasteDialog:Hide()
    ShowNameDialog(parsedData, "string")
end)

-- -----------------------------------------------------------------------------
-- Renomear
-- -----------------------------------------------------------------------------
local renameDialog = CreateDialog("FarmBuddyImportRenameDialog", 320, 130, L["Rename Import"])
local renameBox = T:CreateEditBox(renameDialog.body, 292, 26)
renameBox:SetPoint("TOPLEFT", 14, -14)
local renameSave = T:CreateButton(renameDialog.body, L["Save"], 90, 26, "primary")
renameSave:SetPoint("BOTTOMRIGHT", -14, 12)
local renameCancel = T:CreateButton(renameDialog.body, L["Cancel"], 90, 26, "secondary")
renameCancel:SetPoint("RIGHT", renameSave, "LEFT", -6, 0)
renameCancel:SetScript("OnClick", function() renameDialog:Hide() end)
local renameIndex

function M:Rename(index)
    local entry = FarmTracker:GetProfile().gatherImports[index]
    if not entry then return end
    renameIndex = index
    renameBox:SetText(entry.name or "")
    renameDialog:Show()
    renameBox:SetFocus()
    renameBox:HighlightText()
end

renameSave:SetScript("OnClick", function()
    local newName = renameBox:GetText()
    if newName ~= "" and renameIndex then
        FarmBuddyGatherImport:RenameImport(renameIndex, newName)
        renameDialog:Hide()
        Changed()
    end
end)
renameBox:SetScript("OnEnterPressed", function() renameSave:Click() end)

-- -----------------------------------------------------------------------------
-- Exportar
-- -----------------------------------------------------------------------------
local exportDialog = CreateDialog("FarmBuddyImportExportDialog", 420, 250, L["Export Import"])
local exportHint = T:CreateText(exportDialog.body, 11, "muted")
exportHint:SetPoint("TOPLEFT", 14, -10)
exportHint:SetText(L["Press Ctrl+C to copy."])
local exportArea = T:CreateTextArea(exportDialog.body, 392, 140)
exportArea:SetPoint("TOPLEFT", 14, -28)
local exportClose = T:CreateButton(exportDialog.body, L["Close"], 90, 26, "secondary")
exportClose:SetPoint("BOTTOMRIGHT", -14, 12)
exportClose:SetScript("OnClick", function() exportDialog:Hide() end)

function M:Export(index)
    local text, err = FarmBuddyGatherImport:ExportToString(index)
    if not text then
        print("|cffff0000[FarmBuddy]|r " .. (err or L["Error exporting"]))
        return
    end
    exportArea.editBox:SetText(text)
    exportDialog:Show()
    exportArea.editBox:SetFocus()
    exportArea.editBox:HighlightText()
end

-- -----------------------------------------------------------------------------
-- Excluir / ver mapa
-- -----------------------------------------------------------------------------
function M:Delete(index)
    local entry = FarmTracker:GetProfile().gatherImports[index]
    if not entry then return end
    StaticPopupDialogs["FARMBUDDY_DELETE_IMPORT"] = {
        text = string.format(L["Delete import '%s'?"], entry.name or ""),
        button1 = L["Yes"],
        button2 = L["No"],
        OnAccept = function()
            FarmBuddyGatherImport:DeleteImport(index)
            Changed()
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
    }
    StaticPopup_Show("FARMBUDDY_DELETE_IMPORT")
end

function M:ViewMap(index)
    local entry = FarmTracker:GetProfile().gatherImports[index]
    if entry and FarmBuddyMapPreview then
        FarmBuddyMapPreview:Show(entry)
    end
end

-- Compatibilidade: abre Settings direto na seção de perfis
function M:Toggle()
    if TrackerSettings and TrackerSettings.Open then
        TrackerSettings:Open("profiles")
    end
end
