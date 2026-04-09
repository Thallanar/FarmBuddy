FarmBuddyMapPreview = {}

-- Tamanho parecido com o mapa do jogo
local MAP_WIDTH = 1002
local MAP_HEIGHT = 668
local FRAME_WIDTH = MAP_WIDTH + 40
local FRAME_HEIGHT = MAP_HEIGHT + 90
local PIN_SIZE = 8
local MOB_PIN_SIZE = 12
local MOB_PORTRAIT_SIZE = 18
local MAX_TILES = 256

-- Sidebar (lista de mobs únicos)
local SIDEBAR_WIDTH = 200
local SIDEBAR_ROW_HEIGHT = 28

-- Estado do modo atual
local currentMode = "nodes"         -- "nodes" | "mobs"
local currentProfessionFilter = "skinning"
local currentDisplayMode = "icon"   -- "icon" | "portrait"
local selectedNpcIDs = {}           -- set de npcIDs isolados (npcID -> true)
local selectedCount = 0

-- Forward declare (definido mais abaixo, usado pelos handlers da sidebar)
local RenderMobPinsDispatch

local frame = CreateFrame("Frame", "FarmBuddyMapPreviewFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
frame:SetPoint("CENTER")
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
frame:SetFrameStrata("FULLSCREEN_DIALOG")
frame:SetToplevel(true)
frame:Hide()

-- Sidebar (lista de mobs únicos) — attached à direita do frame principal
local sidebar = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
sidebar:SetSize(SIDEBAR_WIDTH, FRAME_HEIGHT)
sidebar:SetPoint("TOPLEFT", frame, "TOPRIGHT", -4, 0)
sidebar:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
sidebar:Hide()

local sidebarTitle = sidebar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
sidebarTitle:SetPoint("TOP", sidebar, "TOP", 0, -14)
sidebarTitle:SetText("Mobs nesta zona")

local sidebarHelp = sidebar:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
sidebarHelp:SetPoint("TOP", sidebarTitle, "BOTTOM", 0, -2)
sidebarHelp:SetText("Clique para isolar (multi)")

-- Botão "Limpar seleção" (visível só quando há algo selecionado)
local sidebarClearBtn = CreateFrame("Button", nil, sidebar)
sidebarClearBtn:SetSize(SIDEBAR_WIDTH - 28, 18)
sidebarClearBtn:SetPoint("TOP", sidebarHelp, "BOTTOM", 0, -2)
local sidebarClearText = sidebarClearBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
sidebarClearText:SetAllPoints()
sidebarClearText:SetTextColor(1, 0.82, 0)
sidebarClearBtn:SetFontString(sidebarClearText)
sidebarClearBtn:Hide()

local sidebarScroll = CreateFrame("ScrollFrame", nil, sidebar, "UIPanelScrollFrameTemplate")
sidebarScroll:SetPoint("TOPLEFT", 14, -68)
sidebarScroll:SetPoint("BOTTOMRIGHT", -30, 14)

local sidebarContent = CreateFrame("Frame", nil, sidebarScroll)
sidebarContent:SetSize(SIDEBAR_WIDTH - 44, 1)
sidebarScroll:SetScrollChild(sidebarContent)

local sidebarRowPool = {}

-- Atualiza o texto/visibilidade do botão "Limpar seleção"
local function UpdateSidebarHeader()
    if selectedCount > 0 then
        sidebarClearText:SetText(string.format("Limpar seleção (%d)", selectedCount))
        sidebarClearBtn:Show()
    else
        sidebarClearBtn:Hide()
    end
end

sidebarClearBtn:SetScript("OnClick", function()
    wipe(selectedNpcIDs)
    selectedCount = 0
    for _, r in pairs(sidebarRowPool) do
        r.isSelected = false
        r.highlight:Hide()
    end
    UpdateSidebarHeader()
    if currentMode == "mobs" and currentMapID and currentImportData then
        RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
    end
end)

-- Title Bar
local titleBar = CreateFrame("Frame", nil, frame)
titleBar:SetSize(frame:GetWidth(), 24)
titleBar:SetPoint("TOP", frame, "TOP", 0, -6)

local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("LEFT", 15, 0)
titleText:SetText("Preview de Mapa")

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

-- Zoom / Pan state
local MIN_ZOOM = 1.0
local MAX_ZOOM = 5.0
local ZOOM_STEP = 0.2
local currentZoom = 1.0

local panOffsetX = 0
local panOffsetY = 0
local isPanning = false
local panStartX, panStartY = 0, 0
local panStartOffsetX, panStartOffsetY = 0, 0

-- Map Container (clip area)
local mapContainer = CreateFrame("Frame", nil, frame)
mapContainer:SetPoint("TOPLEFT", 20, -55)
mapContainer:SetSize(MAP_WIDTH, MAP_HEIGHT)
mapContainer:SetClipsChildren(true)

local mapBg = mapContainer:CreateTexture(nil, "BACKGROUND")
mapBg:SetAllPoints()
mapBg:SetColorTexture(0.05, 0.05, 0.05, 1)

-- ScrollChild — escala via SetScale, posição via SetPoint
local scrollChild = CreateFrame("Frame", nil, mapContainer)
scrollChild:SetSize(MAP_WIDTH, MAP_HEIGHT)
scrollChild:SetPoint("CENTER", mapContainer, "CENTER")

-- Map Texture Frame
local mapTextureFrame = CreateFrame("Frame", nil, scrollChild)
mapTextureFrame:SetAllPoints()

-- Pin Container
local pinContainer = CreateFrame("Frame", nil, scrollChild)
pinContainer:SetAllPoints()
pinContainer:SetFrameLevel(mapTextureFrame:GetFrameLevel() + 10)
pinContainer:SetClipsChildren(true)

-- Clamp pan para não ultrapassar limites do mapa
local function ClampPan()
    local scaledW = scrollChild:GetWidth() * currentZoom
    local scaledH = scrollChild:GetHeight() * currentZoom
    local containerW = mapContainer:GetWidth()
    local containerH = mapContainer:GetHeight()

    local maxPanX = math.max(0, (scaledW - containerW) / 2)
    local maxPanY = math.max(0, (scaledH - containerH) / 2)

    panOffsetX = math.max(-maxPanX, math.min(maxPanX, panOffsetX))
    panOffsetY = math.max(-maxPanY, math.min(maxPanY, panOffsetY))
end

-- Aplica zoom (SetScale) e pan (SetPoint offset)
local function ApplyZoomPan()
    scrollChild:SetScale(currentZoom)
    ClampPan()
    scrollChild:ClearAllPoints()
    scrollChild:SetPoint("CENTER", mapContainer, "CENTER",
        panOffsetX / currentZoom, panOffsetY / currentZoom)
end

-- Zoom com rodinha do mouse
mapContainer:EnableMouseWheel(true)
mapContainer:SetScript("OnMouseWheel", function(self, delta)
    local oldZoom = currentZoom

    if delta > 0 then
        currentZoom = math.min(MAX_ZOOM, currentZoom + ZOOM_STEP)
    else
        currentZoom = math.max(MIN_ZOOM, currentZoom - ZOOM_STEP)
    end

    if currentZoom == oldZoom then return end

    -- Ajustar pan proporcional ao zoom para manter foco no cursor
    if oldZoom > MIN_ZOOM then
        local ratio = currentZoom / oldZoom
        panOffsetX = panOffsetX * ratio
        panOffsetY = panOffsetY * ratio
    end

    ApplyZoomPan()
end)

-- Pan com arrastar (botão direito)
mapContainer:EnableMouse(true)
mapContainer:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" and currentZoom > MIN_ZOOM then
        isPanning = true
        local cx, cy = GetCursorPosition()
        local scale = self:GetEffectiveScale()
        panStartX = cx / scale
        panStartY = cy / scale
        panStartOffsetX = panOffsetX
        panStartOffsetY = panOffsetY
    end
end)

mapContainer:SetScript("OnMouseUp", function(self, button)
    if button == "RightButton" then
        isPanning = false
    end
end)

mapContainer:SetScript("OnUpdate", function(self)
    if not isPanning then return end

    local cx, cy = GetCursorPosition()
    local scale = self:GetEffectiveScale()
    cx, cy = cx / scale, cy / scale

    panOffsetX = panStartOffsetX + (cx - panStartX)
    panOffsetY = panStartOffsetY - (cy - panStartY)

    ClampPan()
    scrollChild:ClearAllPoints()
    scrollChild:SetPoint("CENTER", mapContainer, "CENTER",
        panOffsetX / currentZoom, panOffsetY / currentZoom)
end)

-- Pools
local overlayTextures = {}
local tileTextures = {}
local pinPool = {}
local mobPinPool = {}
local expandedPinPool = {}
local activePins = {}

local currentImportData = nil
local currentMapID = nil

local function GetOrCreateTile(index)
    if not tileTextures[index] then
        local tex = mapTextureFrame:CreateTexture(nil, "ARTWORK")
        tileTextures[index] = tex
    end
    return tileTextures[index]
end

local function GetOrCreatePin(index)
    if pinPool[index] then
        return pinPool[index]
    end

    local pin = CreateFrame("Frame", nil, pinContainer)
    pin:SetSize(PIN_SIZE, PIN_SIZE)

    local tex = pin:CreateTexture(nil, "ARTWORK")
    tex:SetAllPoints()
    tex:SetTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready")
    pin.texture = tex

    pin:EnableMouse(true)
    pin:SetScript("OnEnter", function(self)
        if self.tooltipText then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.tooltipText)
            if self.tooltipSubText then
                GameTooltip:AddLine(self.tooltipSubText, 0.5, 0.5, 0.5)
            end
            GameTooltip:Show()
        end
    end)
    pin:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    pinPool[index] = pin
    return pin
end

-- ============================
-- MOB PIN POOL (portrait + ícone)
-- ============================

-- Ícones fallback por tipo de criatura
local mobTypeIcons = {
    ["Beast"]     = "Interface\\Icons\\INV_Misc_Pelt_Bear_01",
    ["Humanoid"]  = "Interface\\Icons\\INV_Fabric_Silk_01",
    ["Dragonkin"] = "Interface\\Icons\\INV_Misc_MonsterScales_15",
}

local function GetOrCreateMobPin(index)
    if mobPinPool[index] then
        return mobPinPool[index]
    end

    local pin = CreateFrame("Frame", nil, pinContainer)
    pin:SetSize(MOB_PORTRAIT_SIZE, MOB_PORTRAIT_SIZE)

    -- Retrato (para modo portrait)
    local portrait = pin:CreateTexture(nil, "ARTWORK")
    portrait:SetAllPoints()
    pin.portrait = portrait

    -- Máscara circular para o retrato
    local mask = pin:CreateMaskTexture()
    mask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()
    portrait:AddMaskTexture(mask)
    pin.mask = mask

    -- Ícone (para modo ícone)
    local icon = pin:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    pin.icon = icon

    -- Máscara circular para o ícone também
    local iconMask = pin:CreateMaskTexture()
    iconMask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    iconMask:SetAllPoints()
    icon:AddMaskTexture(iconMask)
    pin.iconMask = iconMask

    pin:EnableMouse(true)
    pin:SetScript("OnEnter", function(self)
        if self.tooltipText then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.tooltipText)
            if self.tooltipSubText then
                GameTooltip:AddLine(self.tooltipSubText, 0.5, 0.5, 0.5)
            end
            GameTooltip:Show()
        end
    end)
    pin:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    mobPinPool[index] = pin
    return pin
end

local function HideAllOverlays()
    for _, tex in pairs(overlayTextures) do
        tex:Hide()
    end
end

local function HideAllTiles()
    for _, tex in pairs(tileTextures) do
        tex:Hide()
    end
    HideAllOverlays()
end

local function HideAllPins()
    for _, pin in ipairs(activePins) do
        pin:Hide()
    end
    wipe(activePins)

    -- Esconder todos os pins dos pools (garante limpeza entre modos)
    for _, pin in pairs(pinPool) do
        pin:Hide()
    end
    for _, pin in pairs(mobPinPool) do
        pin:Hide()
    end
    for _, pin in pairs(expandedPinPool) do
        pin:Hide()
    end
end

-- Texto de erro/status
local statusText = mapContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
statusText:SetPoint("CENTER")
statusText:SetText("")

-- Carrega texturas do mapa
local function LoadMapTextures(mapID)
    HideAllTiles()
    statusText:SetText("")

    local ok, artID = pcall(C_Map.GetMapArtID, mapID)
    if not ok or not artID then
        statusText:SetText("|cffff6600Mapa não disponível para visualização.|r")
        return false
    end

    local okLayers, layers = pcall(C_Map.GetMapArtLayers, mapID)
    if not okLayers or not layers or #layers == 0 then
        statusText:SetText("|cffff6600Texturas do mapa não encontradas.|r")
        return false
    end

    local layer = layers[1]
    local totalWidth = layer.layerWidth or layer.width or 0
    local totalHeight = layer.layerHeight or layer.height or 0

    if totalWidth == 0 or totalHeight == 0 then
        statusText:SetText("|cffff6600Dimensões do mapa inválidas.|r")
        return false
    end

    local aspectRatio = totalWidth / totalHeight
    local displayWidth, displayHeight

    if aspectRatio > (MAP_WIDTH / MAP_HEIGHT) then
        displayWidth = MAP_WIDTH
        displayHeight = MAP_WIDTH / aspectRatio
    else
        displayHeight = MAP_HEIGHT
        displayWidth = MAP_HEIGHT * aspectRatio
    end

    -- Reset zoom/pan e configurar scrollChild
    currentZoom = 1.0
    panOffsetX = 0
    panOffsetY = 0
    scrollChild:SetScale(1.0)
    scrollChild:SetSize(displayWidth, displayHeight)
    scrollChild:ClearAllPoints()
    scrollChild:SetPoint("CENTER", mapContainer, "CENTER")

    mapTextureFrame:SetSize(displayWidth, displayHeight)
    mapTextureFrame:ClearAllPoints()
    mapTextureFrame:SetPoint("CENTER", scrollChild, "CENTER")

    pinContainer:SetSize(displayWidth, displayHeight)
    pinContainer:ClearAllPoints()
    pinContainer:SetPoint("CENTER", scrollChild, "CENTER")

    local tilePixelW = layer.tileWidth or 256
    local tilePixelH = layer.tileHeight or 256
    local numCols = math.ceil(totalWidth / tilePixelW)
    local numRows = math.ceil(totalHeight / tilePixelH)
    local scaledTileW = displayWidth / numCols
    local scaledTileH = displayHeight / numRows

    local okTex, textures = pcall(C_Map.GetMapArtLayerTextures, mapID, 1)
    if not okTex or not textures or #textures == 0 then
        statusText:SetText("|cffff6600Texturas do mapa não carregadas.|r")
        return false
    end

    for texIndex = 1, math.min(#textures, MAX_TILES) do
        local row = math.ceil(texIndex / numCols)
        local col = texIndex - (row - 1) * numCols

        local tile = GetOrCreateTile(texIndex)
        tile:SetTexture(textures[texIndex])
        tile:ClearAllPoints()
        tile:SetPoint("TOPLEFT", mapTextureFrame, "TOPLEFT",
            (col - 1) * scaledTileW,
            -((row - 1) * scaledTileH))
        tile:SetSize(scaledTileW, scaledTileH)
        tile:SetDesaturated(false)
        tile:SetVertexColor(1, 1, 1, 1)
        tile:Show()
    end

    -- Renderiza texturas exploradas por cima dos tiles base
    local okExplored, exploredTextures = pcall(C_MapExplorationInfo.GetExploredMapTextures, mapID)
    if okExplored and exploredTextures then
        local scaleX = displayWidth / totalWidth
        local scaleY = displayHeight / totalHeight
        local overlayIndex = 0

        for _, info in ipairs(exploredTextures) do
            local texW = info.textureWidth
            local texH = info.textureHeight
            local offX = info.offsetX
            local offY = info.offsetY
            local numOverlayCols = math.ceil(texW / 256)
            local numOverlayRows = math.ceil(texH / 256)

            for tIdx, fileID in ipairs(info.fileDataIDs) do
                overlayIndex = overlayIndex + 1
                local oRow = math.ceil(tIdx / numOverlayCols)
                local oCol = tIdx - (oRow - 1) * numOverlayCols

                local pieceW = math.min(256, texW - (oCol - 1) * 256)
                local pieceH = math.min(256, texH - (oRow - 1) * 256)

                if not overlayTextures[overlayIndex] then
                    overlayTextures[overlayIndex] = mapTextureFrame:CreateTexture(nil, "ARTWORK", nil, 1)
                end
                local ot = overlayTextures[overlayIndex]
                ot:SetTexture(fileID)
                ot:ClearAllPoints()
                ot:SetPoint("TOPLEFT", mapTextureFrame, "TOPLEFT",
                    (offX + (oCol - 1) * 256) * scaleX,
                    -((offY + (oRow - 1) * 256) * scaleY))
                ot:SetSize(pieceW * scaleX, pieceH * scaleY)
                ot:Show()
            end
        end
    end

    return true
end

-- Nomes em pt-BR dos tipos de node
local nodeTypePT = {
    ["Herb"] = "Erva",
    ["Mine"] = "Minério",
    ["Fish"] = "Pesca",
    ["Gas"] = "Gás",
    ["Treasure"] = "Tesouro",
    ["Archaeology"] = "Arqueologia",
    ["Logging"] = "Madeira",
}

-- ============================
-- RENDERIZAÇÃO DE PINS (NODES)
-- ============================

local function RenderPins(mapID, importData)
    HideAllPins()

    if not importData or not importData.nodes or not importData.nodes[mapID] then
        return
    end

    local nodes = importData.nodes[mapID]
    local containerW = pinContainer:GetWidth()
    local containerH = pinContainer:GetHeight()
    local colors = FarmBuddyGatherImport and FarmBuddyGatherImport.nodeColors or {}

    for i, node in ipairs(nodes) do
        local pin = GetOrCreatePin(i)
        local px = (node.x / 100) * containerW
        local py = (node.y / 100) * containerH

        pin:ClearAllPoints()
        pin:SetPoint("CENTER", pinContainer, "TOPLEFT", px, -py)

        local color = colors[node.nodeType] or { 1, 1, 1 }
        pin.texture:SetVertexColor(color[1], color[2], color[3])

        pin.tooltipText = nodeTypePT[node.nodeType] or node.nodeType
        pin.tooltipSubText = nil

        pin:Show()
        table.insert(activePins, pin)
    end
end

-- ============================
-- RENDERIZAÇÃO DE PINS (MOBS)
-- ============================

-- Tamanho do portrait no pin agrupado
local EXPANDED_PORTRAIT_SIZE = 14

-- Pool de expanded pins (portrait + badge de quantidade)
local function GetOrCreateExpandedPin(index)
    if expandedPinPool[index] then
        return expandedPinPool[index]
    end

    local pin = CreateFrame("Frame", nil, pinContainer)
    pin:SetSize(EXPANDED_PORTRAIT_SIZE, EXPANDED_PORTRAIT_SIZE)

    -- Portrait
    local portrait = pin:CreateTexture(nil, "ARTWORK")
    portrait:SetAllPoints()
    pin.portrait = portrait

    -- Máscara circular
    local mask = pin:CreateMaskTexture()
    mask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints()
    portrait:AddMaskTexture(mask)
    pin.mask = mask

    -- Ícone fallback
    local icon = pin:CreateTexture(nil, "ARTWORK")
    icon:SetAllPoints()
    pin.icon = icon

    local iconMask = pin:CreateMaskTexture()
    iconMask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    iconMask:SetAllPoints()
    icon:AddMaskTexture(iconMask)
    pin.iconMask = iconMask

    -- Número centralizado sobre o portrait
    local badge = pin:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    badge:SetPoint("CENTER", pin, "CENTER", 0, 0)
    badge:SetTextColor(1, 1, 1)
    badge:SetFont(badge:GetFont(), 11, "OUTLINE")
    pin.badge = badge

    pin:EnableMouse(true)
    pin:SetScript("OnEnter", function(self)
        if self.tooltipText then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.tooltipText)
            if self.tooltipSubText then
                GameTooltip:AddLine(self.tooltipSubText, 0.5, 0.5, 0.5)
            end
            GameTooltip:Show()
        end
    end)
    pin:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    expandedPinPool[index] = pin
    return pin
end

-- Configura um mob pin individual (portrait ou ícone)
local function SetupMobPin(pin, mob, displayMode)
    local displayID = mob.displayID
    if not displayID and mob.npcID and FarmBuddyMobTracker then
        displayID = FarmBuddyMobTracker:GetDisplayID(mob.npcID)
    end

    local showPortrait = false
    if displayMode == "portrait" and displayID then
        local retOk = pcall(SetPortraitTextureFromCreatureDisplayID, pin.portrait, displayID)
        if retOk then
            pin:SetSize(MOB_PORTRAIT_SIZE, MOB_PORTRAIT_SIZE)
            pin.portrait:Show()
            pin.icon:Hide()
            showPortrait = true
        end
    end

    if not showPortrait then
        pin:SetSize(MOB_PIN_SIZE, MOB_PIN_SIZE)
        pin.portrait:Hide()
        pin.icon:Show()

        local iconTexture = mobTypeIcons[mob.creatureType] or mobTypeIcons["Beast"]
        pin.icon:SetTexture(iconTexture)
        pin.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    end

    -- Tooltip
    local typePT = FarmBuddyMobTracker.creatureTypePT[mob.creatureType] or mob.creatureType
    local profLabel = ""
    if mob.skinnable then
        profLabel = "|cffcc6600Couraria|r"
    elseif mob.clothDropper then
        profLabel = "|cff9933ccAlfaiataria|r"
    end

    pin.tooltipText = mob.name or "Mob"
    pin.tooltipSubText = typePT .. (profLabel ~= "" and ("  -  " .. profLabel) or "")

    if mob.trackedAt then
        pin.tooltipSubText = pin.tooltipSubText .. "\n|cff00ff00Rastreado|r"
    end
end

local expandedPinIndex = 0

-- ============================
-- SIDEBAR DE MOBS ÚNICOS
-- ============================

local function GetOrCreateSidebarRow(index)
    if sidebarRowPool[index] then
        return sidebarRowPool[index]
    end

    local row = CreateFrame("Button", nil, sidebarContent)
    row:SetSize(sidebarContent:GetWidth(), SIDEBAR_ROW_HEIGHT - 2)

    local hl = row:CreateTexture(nil, "BACKGROUND")
    hl:SetAllPoints()
    hl:SetColorTexture(1, 0.82, 0, 0.18)
    hl:Hide()
    row.highlight = hl

    local portrait = row:CreateTexture(nil, "ARTWORK")
    portrait:SetSize(22, 22)
    portrait:SetPoint("LEFT", 2, 0)
    row.portrait = portrait

    local pmask = row:CreateMaskTexture()
    pmask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    pmask:SetAllPoints(portrait)
    portrait:AddMaskTexture(pmask)

    local name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    name:SetPoint("LEFT", portrait, "RIGHT", 4, 0)
    name:SetPoint("RIGHT", row, "RIGHT", -28, 0)
    name:SetJustifyH("LEFT")
    name:SetWordWrap(false)
    row.nameText = name

    local count = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    count:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    count:SetTextColor(1, 0.82, 0)
    row.countText = count

    row:SetScript("OnEnter", function(self)
        if not self.isSelected then
            self.highlight:SetColorTexture(1, 1, 1, 0.1)
            self.highlight:Show()
        end
    end)
    row:SetScript("OnLeave", function(self)
        if not self.isSelected then
            self.highlight:Hide()
        end
    end)

    row:SetScript("OnClick", function(self)
        if not self.npcID then return end
        if selectedNpcIDs[self.npcID] then
            selectedNpcIDs[self.npcID] = nil
            selectedCount = selectedCount - 1
        else
            selectedNpcIDs[self.npcID] = true
            selectedCount = selectedCount + 1
        end
        -- Re-render pins e re-aplica highlights
        if currentMode == "mobs" and currentMapID and currentImportData then
            RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
        end
        for _, r in pairs(sidebarRowPool) do
            r.isSelected = (r.npcID ~= nil and selectedNpcIDs[r.npcID] == true)
            if r.isSelected then
                r.highlight:SetColorTexture(1, 0.82, 0, 0.28)
                r.highlight:Show()
            else
                r.highlight:Hide()
            end
        end
        UpdateSidebarHeader()
    end)

    sidebarRowPool[index] = row
    return row
end

local function UpdateSidebar(mapID, mobData, filter)
    -- Esconde todas as rows primeiro
    for _, row in pairs(sidebarRowPool) do
        row:Hide()
        row.isSelected = false
        row.highlight:Hide()
    end

    if not mobData or not mobData.mobs or not mobData.mobs[mapID] then
        sidebarContent:SetHeight(1)
        return
    end

    -- Agrupa por npcID
    local unique = {}
    local order = {}
    for _, mob in ipairs(mobData.mobs[mapID]) do
        if FarmBuddyMobTracker:MatchesFilter(mob, filter) then
            local key = mob.npcID or mob.name or "?"
            if not unique[key] then
                unique[key] = { mob = mob, count = 0, npcID = mob.npcID }
                table.insert(order, key)
            end
            unique[key].count = unique[key].count + 1
        end
    end

    -- Ordena por contagem desc, depois por nome
    table.sort(order, function(a, b)
        local ca, cb = unique[a].count, unique[b].count
        if ca ~= cb then return ca > cb end
        return (unique[a].mob.name or "") < (unique[b].mob.name or "")
    end)

    for idx, key in ipairs(order) do
        local u = unique[key]
        local row = GetOrCreateSidebarRow(idx)
        row.npcID = u.npcID
        row.nameText:SetText(u.mob.name or ("npc " .. tostring(u.npcID)))
        row.countText:SetText("x" .. u.count)

        local displayID = u.mob.displayID
        if not displayID and u.npcID and FarmBuddyMobTracker then
            displayID = FarmBuddyMobTracker:GetDisplayID(u.npcID)
        end
        if displayID then
            pcall(SetPortraitTextureFromCreatureDisplayID, row.portrait, displayID)
            row.portrait:Show()
        else
            row.portrait:Hide()
        end

        if row.npcID and selectedNpcIDs[row.npcID] then
            row.isSelected = true
            row.highlight:SetColorTexture(1, 0.82, 0, 0.28)
            row.highlight:Show()
        end

        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", sidebarContent, "TOPLEFT", 0, -((idx - 1) * SIDEBAR_ROW_HEIGHT))
        row:SetPoint("RIGHT", sidebarContent, "RIGHT", 0, 0)
        row:Show()
    end

    sidebarContent:SetHeight(math.max(1, #order * SIDEBAR_ROW_HEIGHT + 4))
end

-- ============================
-- RENDER AGRUPADO (1 pin por npcID no centróide)
-- ============================

local function RenderGroupedMobPins(mapID, mobData, filter, displayMode)
    HideAllPins()
    expandedPinIndex = 0

    if not mobData or not mobData.mobs or not mobData.mobs[mapID] then
        return
    end

    local mobs = mobData.mobs[mapID]
    local containerW = pinContainer:GetWidth()
    local containerH = pinContainer:GetHeight()

    -- Agrupa por npcID, somando coordenadas para centróide
    local grouped = {}
    local order = {}
    for _, mob in ipairs(mobs) do
        if FarmBuddyMobTracker:MatchesFilter(mob, filter) then
            local key = mob.npcID or mob.name or "?"
            if not grouped[key] then
                grouped[key] = { mob = mob, count = 0, sx = 0, sy = 0 }
                table.insert(order, key)
            end
            local g = grouped[key]
            g.count = g.count + 1
            g.sx = g.sx + (mob.x / 100) * containerW
            g.sy = g.sy + (mob.y / 100) * containerH
        end
    end

    for _, key in ipairs(order) do
        local g = grouped[key]
        local cx = g.sx / g.count
        local cy = g.sy / g.count

        expandedPinIndex = expandedPinIndex + 1
        local epin = GetOrCreateExpandedPin(expandedPinIndex)
        epin:ClearAllPoints()
        epin:SetPoint("CENTER", pinContainer, "TOPLEFT", cx, -cy)

        local displayID = g.mob.displayID
        if not displayID and g.mob.npcID and FarmBuddyMobTracker then
            displayID = FarmBuddyMobTracker:GetDisplayID(g.mob.npcID)
        end

        local showPortrait = false
        if displayID then
            local retOk = pcall(SetPortraitTextureFromCreatureDisplayID, epin.portrait, displayID)
            if retOk then
                epin.portrait:Show()
                epin.icon:Hide()
                showPortrait = true
            end
        end

        if not showPortrait then
            epin.portrait:Hide()
            epin.icon:Show()
            local iconTexture = mobTypeIcons[g.mob.creatureType] or mobTypeIcons["Beast"]
            epin.icon:SetTexture(iconTexture)
            epin.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
        end

        epin.badge:SetText(tostring(g.count))
        epin.badge:Show()

        local typePT = FarmBuddyMobTracker.creatureTypePT[g.mob.creatureType] or g.mob.creatureType
        epin.tooltipText = string.format("%s  x%d", g.mob.name or "Mob", g.count)
        epin.tooltipSubText = typePT

        epin:Show()
        table.insert(activePins, epin)
    end
end

-- Render todas as spawns individuais dos npcIDs selecionados (isolados pela sidebar)
local function RenderIsolatedSpawns(mapID, mobData, displayMode, npcIDSet)
    HideAllPins()
    expandedPinIndex = 0

    if not mobData or not mobData.mobs or not mobData.mobs[mapID] then
        return
    end

    local containerW = pinContainer:GetWidth()
    local containerH = pinContainer:GetHeight()
    local pinIndex = 0

    for _, mob in ipairs(mobData.mobs[mapID]) do
        if mob.npcID and npcIDSet[mob.npcID] then
            pinIndex = pinIndex + 1
            local pin = GetOrCreateMobPin(pinIndex)
            local px = (mob.x / 100) * containerW
            local py = (mob.y / 100) * containerH
            pin:ClearAllPoints()
            pin:SetPoint("CENTER", pinContainer, "TOPLEFT", px, -py)
            SetupMobPin(pin, mob, displayMode)
            pin:Show()
            table.insert(activePins, pin)
        end
    end
end

-- Dispatch: se há mobs isolados, renderiza spawns individuais deles;
-- caso contrário, render agrupado (1 pin por npcID no centróide).
RenderMobPinsDispatch = function(mapID, mobData, filter, displayMode)
    if selectedCount > 0 then
        RenderIsolatedSpawns(mapID, mobData, displayMode, selectedNpcIDs)
    else
        RenderGroupedMobPins(mapID, mobData, filter, displayMode)
    end
end

-- Info bar
local infoBar = CreateFrame("Frame", nil, frame)
infoBar:SetSize(frame:GetWidth() - 40, 24)
infoBar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 15)

local infoText = infoBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
infoText:SetPoint("LEFT", 0, 0)

local function UpdateInfoBar(data, mapID)
    if not data then
        infoText:SetText("")
        return
    end

    if currentMode == "mobs" then
        -- Contar mobs filtrados neste mapa
        local filteredCount = 0
        if data.mobs and data.mobs[mapID] then
            for _, mob in ipairs(data.mobs[mapID]) do
                if FarmBuddyMobTracker:MatchesFilter(mob, currentProfessionFilter) then
                    filteredCount = filteredCount + 1
                end
            end
        end

        local mapCount = data.mapList and #data.mapList or 0
        local profName = FarmBuddyMobTracker.professionNamePT[currentProfessionFilter] or currentProfessionFilter
        infoText:SetText(string.format("%d mobs neste mapa  |  %d mapas no total  |  Filtro: %s",
            filteredCount, mapCount, profName))
    else
        local nodeCount = 0
        if data.nodes and data.nodes[mapID] then
            nodeCount = #data.nodes[mapID]
        end

        local mapCount = data.mapList and #data.mapList or 0
        infoText:SetText(string.format("%d nodes neste mapa  |  %d mapas no total  |  %d nodes total",
            nodeCount, mapCount, data.totalNodes or 0))
    end
end

-- ============================
-- AGRUPAMENTO POR CONTINENTE/EXPANSÃO
-- ============================

-- Descobre o continente pai de um mapID subindo a hierarquia
local function GetContinentForMap(mapID)
    local visited = {}
    local currentID = mapID

    while currentID and not visited[currentID] do
        visited[currentID] = true
        local info = C_Map.GetMapInfo(currentID)
        if not info then
            return nil, nil
        end

        -- mapType 2 = Continent
        if info.mapType == Enum.UIMapType.Continent then
            return currentID, info.name
        end

        currentID = info.parentMapID
    end

    return nil, nil
end

-- Agrupa mapIDs por continente, retorna lista ordenada de grupos
-- countKey: "nodes" para modo nodes, "mobs" para modo mobs
local function GroupMapsByContinent(mapList, data)
    local continentGroups = {}
    local continentOrder = {}
    local noContinent = {}

    local isMobMode = (currentMode == "mobs")

    for _, mapID in ipairs(mapList) do
        local mapInfo = C_Map.GetMapInfo(mapID)
        local zoneName = mapInfo and mapInfo.name or ("Mapa " .. mapID)

        local count = 0
        if isMobMode then
            if data.mobs and data.mobs[mapID] then
                for _, mob in ipairs(data.mobs[mapID]) do
                    if FarmBuddyMobTracker:MatchesFilter(mob, currentProfessionFilter) then
                        count = count + 1
                    end
                end
            end
        else
            if data.nodes and data.nodes[mapID] then
                count = #data.nodes[mapID]
            end
        end

        local continentID, continentName = GetContinentForMap(mapID)

        if continentName then
            if not continentGroups[continentName] then
                continentGroups[continentName] = {
                    continentID = continentID,
                    maps = {},
                }
                table.insert(continentOrder, continentName)
            end
            table.insert(continentGroups[continentName].maps, {
                mapID = mapID,
                name = zoneName,
                count = count,
            })
        else
            table.insert(noContinent, {
                mapID = mapID,
                name = zoneName,
                count = count,
            })
        end
    end

    table.sort(continentOrder)

    for _, continentName in ipairs(continentOrder) do
        table.sort(continentGroups[continentName].maps, function(a, b)
            return a.name < b.name
        end)
    end

    table.sort(noContinent, function(a, b) return a.name < b.name end)

    return continentGroups, continentOrder, noContinent
end

-- Zone Dropdown com submenus por continente
local dropdownFrame = CreateFrame("Frame", "FarmBuddyMapDropdown", frame, "UIDropDownMenuTemplate")
dropdownFrame:SetPoint("TOPLEFT", 5, -28)

-- Forward declare
local LoadMap

-- ============================
-- CONTROLES DE MODO (NODES / MOBS)
-- ============================

local function UpdateModeUI()
    -- será implementado após criar os botões
end

-- Botão toggle "Nodes" (canto superior direito)
local btnModeNodes = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
btnModeNodes:SetSize(70, 22)
btnModeNodes:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -90, -30)
btnModeNodes:SetText("Nodes")

-- Botão toggle "Mobs"
local btnModeMobs = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
btnModeMobs:SetSize(70, 22)
btnModeMobs:SetPoint("LEFT", btnModeNodes, "RIGHT", 2, 0)
btnModeMobs:SetText("Mobs")

-- Dropdown de profissão (entre zone dropdown e botões de modo, visível só no modo Mobs)
local professionDropdown = CreateFrame("Frame", "FarmBuddyProfDropdown", frame, "UIDropDownMenuTemplate")
professionDropdown:SetPoint("TOPLEFT", dropdownFrame, "TOPRIGHT", -15, 0)

local function InitializeProfessionDropdown(self, level)
    if level ~= 1 then return end

    local filters = {
        { key = "skinning",  label = "Couraria (Skinning)" },
        { key = "tailoring", label = "Alfaiataria (Tailoring)" },
        { key = "all",       label = "Todos" },
    }

    for _, f in ipairs(filters) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = f.label
        info.value = f.key
        info.checked = (currentProfessionFilter == f.key)
        info.func = function()
            currentProfessionFilter = f.key
            UIDropDownMenu_SetText(professionDropdown, f.label)

            -- Salvar no perfil
            if FarmBuddyMobTracker then
                FarmBuddyMobTracker:SetSetting("professionFilter", f.key)
            end

            -- Recarregar dados e mapa
            if currentMode == "mobs" and FarmBuddyMobTracker then
                currentImportData = FarmBuddyMobTracker:GetMobData(currentProfessionFilter)
                if currentMapID then
                    LoadMap(currentMapID, currentImportData)
                end
            end
        end
        UIDropDownMenu_AddButton(info, level)
    end
end

UIDropDownMenu_Initialize(professionDropdown, InitializeProfessionDropdown)
UIDropDownMenu_SetWidth(professionDropdown, 160)
UIDropDownMenu_SetText(professionDropdown, "Couraria (Skinning)")
professionDropdown:Hide()

-- Toggle de modo visual (portrait / ícone) — mesmo estilo dos filtros (verdinho)
local displayToggle = CreateFrame("CheckButton", "FarmBuddyDisplayToggle", frame, "ChatConfigCheckButtonTemplate")
displayToggle:SetPoint("LEFT", professionDropdown, "RIGHT", 10, 0)
displayToggle.Text:SetText("Usar Retratos")

displayToggle:SetScript("OnClick", function(self)
    if self:GetChecked() then
        currentDisplayMode = "portrait"
    else
        currentDisplayMode = "icon"
    end

    -- Salvar no perfil
    if FarmBuddyMobTracker then
        FarmBuddyMobTracker:SetSetting("displayMode", currentDisplayMode)
    end

    -- Re-renderizar pins
    if currentMode == "mobs" and currentMapID and currentImportData then
        RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
    end
end)

displayToggle:Hide()

-- Atualiza visibilidade dos controles conforme o modo
UpdateModeUI = function()
    if currentMode == "mobs" then
        professionDropdown:Show()
        displayToggle:Show()
        sidebar:Show()

        -- Visual dos botões de modo
        btnModeNodes:SetNormalFontObject("GameFontDisable")
        btnModeMobs:SetNormalFontObject("GameFontHighlight")
    else
        professionDropdown:Hide()
        displayToggle:Hide()
        sidebar:Hide()

        btnModeNodes:SetNormalFontObject("GameFontHighlight")
        btnModeMobs:SetNormalFontObject("GameFontDisable")
    end
end

-- Função para trocar de modo
local function SetMode(mode)
    currentMode = mode
    UpdateModeUI()

    if mode == "mobs" and FarmBuddyMobTracker then
        -- Carregar settings do perfil
        local settings = FarmBuddyMobTracker:GetSettings()
        if settings then
            currentProfessionFilter = settings.professionFilter or "skinning"
            currentDisplayMode = settings.displayMode or "icon"
            displayToggle:SetChecked(currentDisplayMode == "portrait")

            -- Atualizar texto do dropdown de profissão
            local labels = {
                skinning = "Couraria (Skinning)",
                tailoring = "Alfaiataria (Tailoring)",
                all = "Todos",
            }
            UIDropDownMenu_SetText(professionDropdown, labels[currentProfessionFilter] or "Todos")
        end

        currentImportData = FarmBuddyMobTracker:GetMobData(currentProfessionFilter)
        if currentImportData and currentImportData.mapList and #currentImportData.mapList > 0 then
            LoadMap(currentImportData.mapList[1], currentImportData)
        else
            HideAllPins()
            HideAllTiles()
            statusText:SetText("|cffff6600Nenhum mob disponível para exibição.|r")
            UpdateInfoBar(nil, nil)
        end
    elseif mode == "nodes" then
        -- Se não tem dados de nodes, limpa
        if not currentImportData or not currentImportData.nodes then
            HideAllPins()
            HideAllTiles()
            statusText:SetText("|cffff6600Nenhum dado de nodes carregado. Use o Import Manager.|r")
            UpdateInfoBar(nil, nil)
        end
    end
end

btnModeNodes:SetScript("OnClick", function()
    if currentMode ~= "nodes" then
        SetMode("nodes")
    end
end)

btnModeMobs:SetScript("OnClick", function()
    if currentMode ~= "mobs" then
        SetMode("mobs")
    end
end)

-- Inicializar visual
UpdateModeUI()

-- ============================
-- CARREGAMENTO DE MAPA (MODE-AWARE)
-- ============================

LoadMap = function(mapID, data)
    currentMapID = mapID

    local mapInfo = C_Map.GetMapInfo(mapID)
    local zoneName = mapInfo and mapInfo.name or ("Mapa " .. mapID)

    if currentMode == "mobs" then
        titleText:SetText("Mob Map: " .. zoneName)
    else
        titleText:SetText("Preview: " .. (data.name or "Import"))
    end

    UIDropDownMenu_SetText(dropdownFrame, zoneName)

    -- Trocar de mapa reseta a seleção isolada
    wipe(selectedNpcIDs)
    selectedCount = 0
    UpdateSidebarHeader()

    local success = LoadMapTextures(mapID)
    if success then
        if currentMode == "mobs" then
            UpdateSidebar(mapID, data, currentProfessionFilter)
            sidebar:Show()
            RenderMobPinsDispatch(mapID, data, currentProfessionFilter, currentDisplayMode)
        else
            sidebar:Hide()
            RenderPins(mapID, data)
        end
    else
        HideAllPins()
    end

    UpdateInfoBar(data, mapID)
end

-- ============================
-- DROPDOWN DE ZONAS (MODE-AWARE)
-- ============================

local function InitializeDropdown(self, level, menuList)
    if not currentImportData or not currentImportData.mapList then
        return
    end

    local isMobMode = (currentMode == "mobs")
    local countLabel = isMobMode and "mobs" or "nodes"

    if level == 1 then
        local groups, order, noContinent = GroupMapsByContinent(currentImportData.mapList, currentImportData)

        for _, continentName in ipairs(order) do
            local group = groups[continentName]

            local totalCount = 0
            for _, mapEntry in ipairs(group.maps) do
                totalCount = totalCount + mapEntry.count
            end

            local info = UIDropDownMenu_CreateInfo()
            info.text = string.format("%s  |cff888888(%d %s)|r", continentName, totalCount, countLabel)
            info.notCheckable = true
            info.hasArrow = true
            info.menuList = continentName
            UIDropDownMenu_AddButton(info, level)
        end

        if #noContinent > 0 then
            local info = UIDropDownMenu_CreateInfo()
            info.text = "Outros"
            info.notCheckable = true
            info.hasArrow = true
            info.menuList = "__other__"
            UIDropDownMenu_AddButton(info, level)
        end

    elseif level == 2 and menuList then
        local groups, order, noContinent = GroupMapsByContinent(currentImportData.mapList, currentImportData)

        local maps
        if menuList == "__other__" then
            maps = noContinent
        elseif groups[menuList] then
            maps = groups[menuList].maps
        end

        if maps then
            for _, mapEntry in ipairs(maps) do
                local info = UIDropDownMenu_CreateInfo()
                info.text = string.format("%s (%d %s)", mapEntry.name, mapEntry.count, countLabel)
                info.value = mapEntry.mapID
                info.notCheckable = true
                if mapEntry.mapID == currentMapID then
                    info.text = "|cff00ff00> " .. info.text .. "|r"
                end
                info.func = function()
                    LoadMap(mapEntry.mapID, currentImportData)
                    CloseDropDownMenus()
                end
                UIDropDownMenu_AddButton(info, level)
            end
        end
    end
end

UIDropDownMenu_Initialize(dropdownFrame, InitializeDropdown)
UIDropDownMenu_SetWidth(dropdownFrame, 350)

-- ============================
-- API PÚBLICA
-- ============================

-- Retorna o mapID inicial a ser exibido: o mapa atual do jogador (se estiver
-- registrado no mapList) ou o primeiro mapa da lista como fallback.
local function GetInitialMapID(mapList)
    if not mapList or #mapList == 0 then
        return nil
    end

    local playerMapID = nil
    if C_Map and C_Map.GetBestMapForUnit then
        local ok, id = pcall(C_Map.GetBestMapForUnit, "player")
        if ok then
            playerMapID = id
        end
    end

    if playerMapID then
        for _, mapID in ipairs(mapList) do
            if mapID == playerMapID then
                return playerMapID
            end
        end
    end

    return mapList[1]
end

function FarmBuddyMapPreview:Show(importData, mode)
    mode = mode or "nodes"

    if mode == "mobs" then
        currentMode = "mobs"
        UpdateModeUI()

        -- Carregar settings do perfil
        if FarmBuddyMobTracker then
            local settings = FarmBuddyMobTracker:GetSettings()
            if settings then
                currentProfessionFilter = settings.professionFilter or "skinning"
                currentDisplayMode = settings.displayMode or "icon"
                displayToggle:SetChecked(currentDisplayMode == "portrait")

                local labels = {
                    skinning = "Couraria (Skinning)",
                    tailoring = "Alfaiataria (Tailoring)",
                    all = "Todos",
                }
                UIDropDownMenu_SetText(professionDropdown, labels[currentProfessionFilter] or "Todos")
            end

            currentImportData = FarmBuddyMobTracker:GetMobData(currentProfessionFilter)
        end

        if not currentImportData or not currentImportData.mapList or #currentImportData.mapList == 0 then
            frame:Show()
            HideAllPins()
            HideAllTiles()
            statusText:SetText("|cffff6600Nenhum mob disponível para exibição.|r")
            return
        end

        LoadMap(GetInitialMapID(currentImportData.mapList), currentImportData)
        frame:Show()
    else
        -- Modo nodes (comportamento original)
        if not importData or not importData.mapList or #importData.mapList == 0 then
            print("|cffff0000[FarmBuddy]|r Nenhum mapa disponível para preview.")
            return
        end

        currentMode = "nodes"
        UpdateModeUI()
        currentImportData = importData
        LoadMap(GetInitialMapID(importData.mapList), importData)
        frame:Show()
    end
end

function FarmBuddyMapPreview:Hide()
    frame:Hide()
    HideAllPins()
    HideAllTiles()
    currentImportData = nil
    currentMapID = nil
end
