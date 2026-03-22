FarmBuddyImportManager = {}

local frame = CreateFrame("Frame", "FarmBuddyImportManagerFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
frame:SetSize(450, 500)
frame:SetPoint("CENTER", -200, 0)
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:SetFrameStrata("HIGH")
frame:Hide()

-- Title Bar
local titleBar = CreateFrame("Frame", nil, frame)
titleBar:SetSize(frame:GetWidth(), 24)
titleBar:SetPoint("TOP", frame, "TOP", 0, -6)

local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("LEFT", 15, 0)
titleText:SetText("Importar GatherMate2")

-- Close Button
local closeButton = CreateFrame("Button", nil, titleBar)
closeButton:SetSize(24, 24)
closeButton:SetPoint("TOPRIGHT", -8, 0)
closeButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")

local closeIcon = closeButton:CreateTexture(nil, "ARTWORK")
closeIcon:SetAllPoints()
closeIcon:SetTexture("Interface\\AddOns\\FarmBuddy\\icon\\close.png")

closeButton:SetScript("OnClick", function()
    frame:Hide()
end)

-- Botões de importação
local btnFromDB = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
btnFromDB:SetSize(190, 24)
btnFromDB:SetPoint("TOPLEFT", 15, -35)
btnFromDB:SetText("Importar do GatherMate2")

local btnFromString = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
btnFromString:SetSize(190, 24)
btnFromString:SetPoint("TOPRIGHT", -15, -35)
btnFromString:SetText("Colar String")

-- ScrollFrame para lista de imports
local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -65)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(390, 1)
scrollFrame:SetScrollChild(scrollChild)

-- Estado
local listFrames = {}

-- ============================
-- PASTE FRAME (Colar String)
-- ============================
local pasteFrame = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
pasteFrame:SetSize(410, 250)
pasteFrame:SetPoint("CENTER", frame, "CENTER", 0, 0)
pasteFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
pasteFrame:SetFrameLevel(frame:GetFrameLevel() + 20)
pasteFrame:Hide()

local pasteTitle = pasteFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
pasteTitle:SetPoint("TOP", 0, -15)
pasteTitle:SetText("Cole a string de exportação do GatherMate2")

local pasteScrollFrame = CreateFrame("ScrollFrame", "FarmBuddyPasteScroll", pasteFrame, "UIPanelScrollFrameTemplate")
pasteScrollFrame:SetPoint("TOPLEFT", 15, -35)
pasteScrollFrame:SetPoint("BOTTOMRIGHT", -35, 60)

local pasteEditBox = CreateFrame("EditBox", "FarmBuddyPasteEditBox", pasteScrollFrame)
pasteEditBox:SetMultiLine(true)
pasteEditBox:SetAutoFocus(false)
pasteEditBox:SetFontObject("ChatFontNormal")
pasteEditBox:SetWidth(360)
pasteEditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
pasteScrollFrame:SetScrollChild(pasteEditBox)

local pasteErrorText = pasteFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
pasteErrorText:SetPoint("BOTTOMLEFT", 15, 40)
pasteErrorText:SetTextColor(1, 0.2, 0.2)
pasteErrorText:SetText("")

local btnPasteProcess = CreateFrame("Button", nil, pasteFrame, "GameMenuButtonTemplate")
btnPasteProcess:SetSize(120, 24)
btnPasteProcess:SetPoint("BOTTOMRIGHT", -50, 12)
btnPasteProcess:SetText("Processar")

local btnPasteCancel = CreateFrame("Button", nil, pasteFrame, "GameMenuButtonTemplate")
btnPasteCancel:SetSize(100, 24)
btnPasteCancel:SetPoint("RIGHT", btnPasteProcess, "LEFT", -5, 0)
btnPasteCancel:SetText("Cancelar")

btnPasteCancel:SetScript("OnClick", function()
    pasteEditBox:SetText("")
    pasteErrorText:SetText("")
    pasteFrame:Hide()
    scrollFrame:Show()
end)

-- ============================
-- NAME INPUT DIALOG
-- ============================
local nameFrame = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
nameFrame:SetSize(350, 120)
nameFrame:SetPoint("CENTER", frame, "CENTER", 0, 0)
nameFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
nameFrame:SetFrameLevel(frame:GetFrameLevel() + 30)
nameFrame:Hide()

local nameTitle = nameFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
nameTitle:SetPoint("TOP", 0, -15)
nameTitle:SetText("Nome do Import")

local nameEditBox = CreateFrame("EditBox", nil, nameFrame, "InputBoxTemplate")
nameEditBox:SetSize(280, 22)
nameEditBox:SetPoint("CENTER", 0, 0)
nameEditBox:SetAutoFocus(true)

local nameInfoText = nameFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
nameInfoText:SetPoint("TOP", nameTitle, "BOTTOM", 0, -5)

local pendingData = nil
local pendingSource = nil

local btnNameConfirm = CreateFrame("Button", nil, nameFrame, "GameMenuButtonTemplate")
btnNameConfirm:SetSize(100, 24)
btnNameConfirm:SetPoint("BOTTOMRIGHT", -30, 12)
btnNameConfirm:SetText("Salvar")

local btnNameCancel = CreateFrame("Button", nil, nameFrame, "GameMenuButtonTemplate")
btnNameCancel:SetSize(100, 24)
btnNameCancel:SetPoint("RIGHT", btnNameConfirm, "LEFT", -5, 0)
btnNameCancel:SetText("Cancelar")

btnNameCancel:SetScript("OnClick", function()
    nameEditBox:SetText("")
    nameFrame:Hide()
    pendingData = nil
    pendingSource = nil
end)

-- ============================
-- TYPE SELECTION (Import do DB)
-- ============================
local typeFrame = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
typeFrame:SetSize(300, 50)
typeFrame:SetPoint("CENTER", frame, "CENTER", 0, 0)
typeFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
typeFrame:SetFrameLevel(frame:GetFrameLevel() + 25)
typeFrame:Hide()

local typeTitle = typeFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
typeTitle:SetPoint("TOP", 0, -15)
typeTitle:SetText("Selecione os tipos de node")

local typeCheckboxes = {}
local typeSelectedKeys = {}

local btnTypeConfirm = CreateFrame("Button", nil, typeFrame, "GameMenuButtonTemplate")
btnTypeConfirm:SetSize(100, 24)
btnTypeConfirm:SetText("Importar")

local btnTypeCancel = CreateFrame("Button", nil, typeFrame, "GameMenuButtonTemplate")
btnTypeCancel:SetSize(100, 24)
btnTypeCancel:SetText("Cancelar")

btnTypeCancel:SetScript("OnClick", function()
    typeFrame:Hide()
    wipe(typeSelectedKeys)
end)

local typeErrorText = typeFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
typeErrorText:SetTextColor(1, 0.2, 0.2)

-- Forward declaration
local BuildImportList

-- Mostra diálogo de nome e salva ao confirmar
local function ShowNameDialog(parsedData, source)
    pendingData = parsedData
    pendingSource = source
    nameInfoText:SetText(string.format("%d nodes em %d mapas", parsedData.totalNodes, #parsedData.mapList))
    nameEditBox:SetText("")
    nameFrame:Show()
    nameEditBox:SetFocus()
end

btnNameConfirm:SetScript("OnClick", function()
    local name = nameEditBox:GetText()
    if name == "" then
        name = "Import " .. date("%d/%m/%Y %H:%M")
    end

    if pendingData then
        FarmBuddyGatherImport:SaveImport(name, pendingData, pendingSource)
        pendingData = nil
        pendingSource = nil
        nameEditBox:SetText("")
        nameFrame:Hide()
        BuildImportList()
        print("|cff00ff00[FarmBuddy]|r Import '" .. name .. "' salvo com sucesso!")
    end
end)

nameEditBox:SetScript("OnEnterPressed", function()
    btnNameConfirm:Click()
end)

-- ============================
-- IMPORT FROM DB FLOW
-- ============================
local function ShowTypeSelection()
    local available, err = FarmBuddyGatherImport:GetAvailableTypes()
    if not available then
        print("|cffff0000[FarmBuddy]|r " .. (err or "Erro desconhecido"))
        return
    end

    -- Limpa checkboxes anteriores
    for _, cb in ipairs(typeCheckboxes) do
        cb:Hide()
    end
    wipe(typeCheckboxes)
    wipe(typeSelectedKeys)

    local nodeTypePT = {
        ["Herb"] = "Ervas",
        ["Mine"] = "Minérios",
        ["Fish"] = "Peixes",
        ["Gas"] = "Gases",
        ["Treasure"] = "Tesouros",
        ["Archaeology"] = "Arqueologia",
        ["Logging"] = "Madeira",
    }

    local yOffset = -35
    for i, typeInfo in ipairs(available) do
        local cb = CreateFrame("CheckButton", "FBTypeCheck" .. i, typeFrame, "InterfaceOptionsCheckButtonTemplate")
        cb:SetPoint("TOPLEFT", 20, yOffset)
        cb:SetChecked(true)
        typeSelectedKeys[typeInfo.prefix] = true

        local labelText = nodeTypePT[typeInfo.nodeType] or typeInfo.nodeType
        if typeInfo.totalNodes then
            labelText = labelText .. "  |cff888888(" .. typeInfo.totalNodes .. " nodes)|r"
        end
        if typeInfo.sources then
            labelText = labelText .. "  |cff666666[" .. typeInfo.sources .. "]|r"
        end
        local cbText = _G["FBTypeCheck" .. i .. "Text"]
        cbText:SetText(labelText)
        cbText:ClearAllPoints()
        cbText:SetPoint("LEFT", cb, "RIGHT", 4, 0)

        cb:SetScript("OnClick", function(self)
            typeSelectedKeys[typeInfo.prefix] = self:GetChecked()
        end)

        table.insert(typeCheckboxes, cb)
        yOffset = yOffset - 26
    end

    -- Ajusta tamanho do frame
    local totalHeight = math.abs(yOffset) + 60
    typeFrame:SetSize(300, totalHeight)

    -- Reposiciona botões
    typeErrorText:SetPoint("BOTTOMLEFT", 20, 15)
    btnTypeConfirm:SetPoint("BOTTOMRIGHT", -20, 10)
    btnTypeCancel:SetPoint("RIGHT", btnTypeConfirm, "LEFT", -5, 0)

    typeErrorText:SetText("")
    typeFrame:Show()
end

btnTypeConfirm:SetScript("OnClick", function()
    -- Verifica se pelo menos um tipo foi selecionado
    local hasSelection = false
    for _, selected in pairs(typeSelectedKeys) do
        if selected then
            hasSelection = true
            break
        end
    end

    if not hasSelection then
        typeErrorText:SetText("Selecione pelo menos um tipo.")
        return
    end

    local filter = {}
    for dbKey, selected in pairs(typeSelectedKeys) do
        if selected then
            filter[dbKey] = true
        end
    end

    local parsedData, err = FarmBuddyGatherImport:ParseFromDB(filter)
    if not parsedData then
        typeErrorText:SetText(err or "Erro ao importar")
        return
    end

    typeFrame:Hide()
    ShowNameDialog(parsedData, "gathermate2db")
end)

btnFromDB:SetScript("OnClick", function()
    ShowTypeSelection()
end)

-- ============================
-- IMPORT FROM STRING FLOW
-- ============================
btnFromString:SetScript("OnClick", function()
    pasteEditBox:SetText("")
    pasteErrorText:SetText("")
    scrollFrame:Hide()
    pasteFrame:Show()
    pasteEditBox:SetFocus()
end)

btnPasteProcess:SetScript("OnClick", function()
    local inputText = pasteEditBox:GetText()
    local parsedData, err = FarmBuddyGatherImport:ParseFromString(inputText)

    if not parsedData then
        pasteErrorText:SetText(err or "Erro ao processar string")
        return
    end

    pasteEditBox:SetText("")
    pasteErrorText:SetText("")
    pasteFrame:Hide()
    scrollFrame:Show()
    ShowNameDialog(parsedData, "string")
end)

-- ============================
-- RENAME DIALOG
-- ============================
local renameFrame = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
renameFrame:SetSize(300, 100)
renameFrame:SetPoint("CENTER", frame, "CENTER", 0, 0)
renameFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
renameFrame:SetFrameLevel(frame:GetFrameLevel() + 30)
renameFrame:Hide()

local renameTitle = renameFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
renameTitle:SetPoint("TOP", 0, -15)
renameTitle:SetText("Renomear Import")

local renameEditBox = CreateFrame("EditBox", nil, renameFrame, "InputBoxTemplate")
renameEditBox:SetSize(240, 22)
renameEditBox:SetPoint("CENTER", 0, 0)
renameEditBox:SetAutoFocus(true)

local renameIndex = nil

local btnRenameConfirm = CreateFrame("Button", nil, renameFrame, "GameMenuButtonTemplate")
btnRenameConfirm:SetSize(100, 24)
btnRenameConfirm:SetPoint("BOTTOMRIGHT", -20, 10)
btnRenameConfirm:SetText("Salvar")

local btnRenameCancel = CreateFrame("Button", nil, renameFrame, "GameMenuButtonTemplate")
btnRenameCancel:SetSize(100, 24)
btnRenameCancel:SetPoint("RIGHT", btnRenameConfirm, "LEFT", -5, 0)
btnRenameCancel:SetText("Cancelar")

btnRenameCancel:SetScript("OnClick", function()
    renameFrame:Hide()
    renameIndex = nil
end)

btnRenameConfirm:SetScript("OnClick", function()
    local newName = renameEditBox:GetText()
    if newName ~= "" and renameIndex then
        FarmBuddyGatherImport:RenameImport(renameIndex, newName)
        renameFrame:Hide()
        renameIndex = nil
        BuildImportList()
    end
end)

renameEditBox:SetScript("OnEnterPressed", function()
    btnRenameConfirm:Click()
end)

-- ============================
-- EXPORT DIALOG
-- ============================
local exportFrame = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
exportFrame:SetSize(410, 250)
exportFrame:SetPoint("CENTER", frame, "CENTER", 0, 0)
exportFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
exportFrame:SetFrameLevel(frame:GetFrameLevel() + 20)
exportFrame:Hide()

local exportTitle = exportFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
exportTitle:SetPoint("TOP", 0, -15)
exportTitle:SetText("Exportar Import")

local exportScrollFrame = CreateFrame("ScrollFrame", "FarmBuddyExportScroll", exportFrame, "UIPanelScrollFrameTemplate")
exportScrollFrame:SetPoint("TOPLEFT", 15, -35)
exportScrollFrame:SetPoint("BOTTOMRIGHT", -35, 45)

local exportEditBox = CreateFrame("EditBox", "FarmBuddyExportEditBox", exportScrollFrame)
exportEditBox:SetMultiLine(true)
exportEditBox:SetAutoFocus(false)
exportEditBox:SetFontObject("ChatFontNormal")
exportEditBox:SetWidth(360)
exportEditBox:SetScript("OnEscapePressed", function(self) self:ClearFocus() end)
exportScrollFrame:SetScrollChild(exportEditBox)

local btnExportClose = CreateFrame("Button", nil, exportFrame, "GameMenuButtonTemplate")
btnExportClose:SetSize(100, 24)
btnExportClose:SetPoint("BOTTOM", 0, 12)
btnExportClose:SetText("Fechar")
btnExportClose:SetScript("OnClick", function()
    exportEditBox:SetText("")
    exportFrame:Hide()
    scrollFrame:Show()
end)

local function ShowExportDialog(index)
    local exportString, err = FarmBuddyGatherImport:ExportToString(index)
    if not exportString then
        print("|cffff0000[FarmBuddy]|r " .. (err or "Erro ao exportar"))
        return
    end

    scrollFrame:Hide()
    exportEditBox:SetText(exportString)
    exportFrame:Show()
    exportEditBox:SetFocus()
    exportEditBox:HighlightText()
end

-- ============================
-- IMPORT LIST
-- ============================
BuildImportList = function()
    for _, f in ipairs(listFrames) do
        f:Hide()
    end
    wipe(listFrames)

    local profile = FarmTracker:GetProfile()
    local imports = profile.gatherImports or {}

    if #imports == 0 then
        local emptyText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        emptyText:SetPoint("CENTER", scrollChild, "TOP", 0, -60)
        emptyText:SetText("Nenhum import salvo.\nUse os botões acima para importar dados do GatherMate2.")

        local wrapper = CreateFrame("Frame", nil, scrollChild)
        wrapper:SetSize(390, 120)
        wrapper:SetPoint("TOPLEFT", 0, 0)
        table.insert(listFrames, wrapper)

        scrollChild:SetHeight(120)
        return
    end

    local yOffset = 0

    for i, importData in ipairs(imports) do
        -- Container da entrada
        local row = CreateFrame("Frame", nil, scrollChild)
        row:SetSize(390, 70)
        row:SetPoint("TOPLEFT", 0, -yOffset)

        local rowBg = row:CreateTexture(nil, "BACKGROUND")
        rowBg:SetAllPoints()
        rowBg:SetColorTexture(0.15, 0.15, 0.15, 0.5)

        -- Nome
        local nameLabel = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        nameLabel:SetPoint("TOPLEFT", 10, -5)
        nameLabel:SetText("|cff00ff00" .. (importData.name or "Sem nome") .. "|r")

        -- Info
        local infoLabel = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        infoLabel:SetPoint("TOPLEFT", 10, -22)

        local mapCount = importData.mapList and #importData.mapList or 0
        local sourceLabel = importData.source == "gathermate2db" and "GatherMate2" or "String"
        infoLabel:SetText(string.format("%d nodes  |  %d mapas  |  %s  |  %s",
            importData.totalNodes or 0,
            mapCount,
            sourceLabel,
            importData.createdAt or "?"
        ))

        -- Botão Ver Mapa
        local btnView = CreateFrame("Button", nil, row, "GameMenuButtonTemplate")
        btnView:SetSize(80, 20)
        btnView:SetPoint("BOTTOMLEFT", 10, 5)
        btnView:SetText("Ver Mapa")
        btnView:SetScript("OnClick", function()
            if FarmBuddyMapPreview then
                FarmBuddyMapPreview:Show(importData)
            end
        end)

        -- Botão Renomear
        local btnRename = CreateFrame("Button", nil, row, "GameMenuButtonTemplate")
        btnRename:SetSize(80, 20)
        btnRename:SetPoint("LEFT", btnView, "RIGHT", 5, 0)
        btnRename:SetText("Renomear")
        btnRename:SetScript("OnClick", function()
            renameIndex = i
            renameEditBox:SetText(importData.name or "")
            renameFrame:Show()
            renameEditBox:SetFocus()
        end)

        -- Botão Exportar
        local btnExport = CreateFrame("Button", nil, row, "GameMenuButtonTemplate")
        btnExport:SetSize(70, 20)
        btnExport:SetPoint("LEFT", btnRename, "RIGHT", 5, 0)
        btnExport:SetText("Exportar")
        btnExport:SetScript("OnClick", function()
            ShowExportDialog(i)
        end)

        -- Botão Excluir
        local btnDelete = CreateFrame("Button", nil, row, "GameMenuButtonTemplate")
        btnDelete:SetSize(70, 20)
        btnDelete:SetPoint("LEFT", btnExport, "RIGHT", 5, 0)
        btnDelete:SetText("Excluir")
        btnDelete:SetScript("OnClick", function()
            StaticPopupDialogs["FARMBUDDY_DELETE_IMPORT"] = {
                text = "Excluir import '" .. (importData.name or "") .. "'?",
                button1 = "Sim",
                button2 = "Não",
                OnAccept = function()
                    FarmBuddyGatherImport:DeleteImport(i)
                    BuildImportList()
                end,
                timeout = 0,
                whileDead = true,
                hideOnEscape = true,
            }
            StaticPopup_Show("FARMBUDDY_DELETE_IMPORT")
        end)

        table.insert(listFrames, row)
        yOffset = yOffset + 75
    end

    scrollChild:SetHeight(math.max(yOffset + 10, 1))
end

-- API Pública
function FarmBuddyImportManager:Toggle()
    if frame:IsShown() then
        frame:Hide()
    else
        -- Esconde sub-frames
        pasteFrame:Hide()
        nameFrame:Hide()
        typeFrame:Hide()
        renameFrame:Hide()
        exportFrame:Hide()
        scrollFrame:Show()
        BuildImportList()
        frame:Show()
    end
end
