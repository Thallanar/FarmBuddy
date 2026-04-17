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
local currentMapID = nil
local currentImportData = nil

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

-- Overlay para marcadores de área de spawn (hover nos pins agrupados)
local spawnOverlay = CreateFrame("Frame", nil, pinContainer)
spawnOverlay:SetAllPoints()
spawnOverlay:SetFrameLevel(pinContainer:GetFrameLevel() + 1)
local spawnMarkerPool = {}
local activeSpawnMarkers = {}

-- Overlay para renderização de rotas (acima dos spawns)
local routeOverlay = CreateFrame("Frame", nil, pinContainer)
routeOverlay:SetAllPoints()
routeOverlay:SetFrameLevel(spawnOverlay:GetFrameLevel() + 1)
local routeLinePool = {}
local routePullNumberPool = {}
local activeRouteLines = {}
local activeRoutePullNumbers = {}

-- Estado do modo de edição de rota (pulls)
local isRouteEditMode = false       -- true quando jogador está montando rota
local editingPulls = {}             -- pulls em construção: { [1] = { mob1, mob2 }, [2] = { mob3 }, ... }
local currentPullIndex = 1          -- pull ativo para adição
local viewingRoute = nil            -- rota salva sendo visualizada (nil = modo normal)

local function GetOrCreateSpawnMarker(index)
    if spawnMarkerPool[index] then
        return spawnMarkerPool[index]
    end
    local marker = spawnOverlay:CreateTexture(nil, "ARTWORK")
    marker:SetSize(10, 10)
    marker:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
    marker:SetVertexColor(1, 0.82, 0, 0.6)
    spawnMarkerPool[index] = marker
    return marker
end

local function HideSpawnArea()
    for _, marker in ipairs(activeSpawnMarkers) do
        marker:Hide()
    end
    wipe(activeSpawnMarkers)
end

local function ShowSpawnArea(spawnPoints)
    HideSpawnArea()
    if not spawnPoints then return end
    local containerW = pinContainer:GetWidth()
    local containerH = pinContainer:GetHeight()
    for i, pt in ipairs(spawnPoints) do
        local marker = GetOrCreateSpawnMarker(i)
        marker:ClearAllPoints()
        local px = (pt.x / 100) * containerW
        local py = (pt.y / 100) * containerH
        marker:SetPoint("CENTER", pinContainer, "TOPLEFT", px, -py)
        marker:Show()
        activeSpawnMarkers[i] = marker
    end
end

-- ============================
-- RENDERIZAÇÃO DE ROTAS (SISTEMA DE PULLS)
-- ============================

-- Cores para cada pull (cicla se houver mais de 8 pulls)
local PULL_COLORS = {
    { 1.0, 0.82, 0.0 },   -- dourado
    { 0.2, 0.8,  1.0 },   -- azul claro
    { 0.0, 1.0,  0.4 },   -- verde
    { 1.0, 0.4,  0.4 },   -- vermelho claro
    { 1.0, 0.6,  0.0 },   -- laranja
    { 0.8, 0.4,  1.0 },   -- roxo
    { 0.0, 1.0,  1.0 },   -- ciano
    { 1.0, 0.8,  0.6 },   -- bege
}

local function GetPullColor(pullIndex)
    local c = PULL_COLORS[((pullIndex - 1) % #PULL_COLORS) + 1]
    return c[1], c[2], c[3]
end

local function GetOrCreateRouteLine(index)
    if routeLinePool[index] then
        return routeLinePool[index]
    end
    local line = routeOverlay:CreateLine(nil, "ARTWORK")
    line:SetThickness(2.5)
    routeLinePool[index] = line
    return line
end

local function GetOrCreatePullNumber(index)
    if routePullNumberPool[index] then
        return routePullNumberPool[index]
    end
    local numFrame = CreateFrame("Frame", nil, routeOverlay)
    numFrame:SetSize(20, 20)

    -- Fundo circular
    local bg = numFrame:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
    bg:SetAllPoints()
    bg:SetVertexColor(0.1, 0.1, 0.1, 0.85)
    numFrame.bg = bg

    -- Número do pull
    local text = numFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    text:SetPoint("CENTER", 0, 0)
    text:SetFont(text:GetFont(), 11, "OUTLINE")
    numFrame.text = text

    -- Tooltip
    numFrame:EnableMouse(true)
    numFrame:SetScript("OnEnter", function(self)
        self.bg:SetVertexColor(0.3, 0.3, 0.3, 0.95)
        if self.tooltipText then
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:AddLine(self.tooltipText)
            if self.tooltipLines then
                for _, line in ipairs(self.tooltipLines) do
                    GameTooltip:AddLine(line, 0.8, 0.8, 0.8)
                end
            end
            if self.tooltipHint then
                GameTooltip:AddLine(self.tooltipHint, 0.5, 0.5, 0.5)
            end
            GameTooltip:Show()
        end
    end)
    numFrame:SetScript("OnLeave", function(self)
        self.bg:SetVertexColor(0.1, 0.1, 0.1, 0.85)
        GameTooltip:Hide()
    end)

    routePullNumberPool[index] = numFrame
    return numFrame
end

local function HideRoute()
    for _, line in ipairs(activeRouteLines) do
        line:Hide()
    end
    wipe(activeRouteLines)
    for _, num in ipairs(activeRoutePullNumbers) do
        num:Hide()
    end
    wipe(activeRoutePullNumbers)
end

-- Forward declare
local RenderPullRoute
local UpdateRouteButtons
local UpdateSidebarForPulls

--- Renderiza a rota de pulls: linhas entre centróides + número em cada centróide.
--- Funciona tanto para editingPulls (modo edição) quanto viewingRoute (modo visualização).
RenderPullRoute = function(pulls, circular)
    HideRoute()
    if not pulls or #pulls == 0 then return end

    local containerW = pinContainer:GetWidth()
    local containerH = pinContainer:GetHeight()

    -- Calcula centróide de cada pull
    local centroids = {}
    for i, pull in ipairs(pulls) do
        if #pull > 0 then
            local c = FarmBuddyRouteMaker:PullCentroid(pull)
            table.insert(centroids, { x = c.x, y = c.y, pullIndex = i, pull = pull })
        end
    end

    if #centroids == 0 then return end

    -- Desenha linhas entre centróides consecutivos
    if #centroids >= 2 then
        local lineCount = circular and #centroids or (#centroids - 1)
        for i = 1, lineCount do
            local from = centroids[i]
            local to = centroids[(i % #centroids) + 1]
            local line = GetOrCreateRouteLine(i)

            local fx = (from.x / 100) * containerW
            local fy = (from.y / 100) * containerH
            local tx = (to.x / 100) * containerW
            local ty = (to.y / 100) * containerH

            line:SetStartPoint("TOPLEFT", pinContainer, fx, -fy)
            line:SetEndPoint("TOPLEFT", pinContainer, tx, -ty)

            local r, g, b = GetPullColor(from.pullIndex)
            line:SetColorTexture(r, g, b, 0.7)
            line:Show()
            activeRouteLines[i] = line
        end
    end

    -- Desenha número do pull em cada centróide
    for idx, c in ipairs(centroids) do
        local num = GetOrCreatePullNumber(idx)
        num:ClearAllPoints()
        local px = (c.x / 100) * containerW
        local py = (c.y / 100) * containerH
        num:SetPoint("CENTER", pinContainer, "TOPLEFT", px, -py)

        local pullNum = c.pullIndex
        num.text:SetText(tostring(pullNum))
        local r, g, b = GetPullColor(pullNum)
        num.text:SetTextColor(r, g, b)

        -- Tooltip com lista de mobs do pull
        num.tooltipText = string.format("|cffffd100Pull #%d|r  (%d mobs)", pullNum, #c.pull)
        num.tooltipLines = {}
        for _, mob in ipairs(c.pull) do
            table.insert(num.tooltipLines, "  " .. (mob.name or ("NPC " .. tostring(mob.npcID))))
        end
        if isRouteEditMode then
            num.tooltipHint = "Clique direito para remover pull"
        end

        -- Right-click para remover pull (só no modo edição)
        num:SetScript("OnMouseDown", function(self, button)
            if button == "RightButton" and isRouteEditMode then
                local pi = self.pullIndex
                if pi and editingPulls[pi] then
                    table.remove(editingPulls, pi)
                    -- Ajusta currentPullIndex se necessário
                    if currentPullIndex > #editingPulls then
                        currentPullIndex = math.max(1, #editingPulls + 1)
                    end
                    RenderPullRoute(editingPulls, true)
                    if UpdateRouteButtons then UpdateRouteButtons() end
                    -- Re-renderiza os pins pra atualizar badges
                    if currentMapID and currentImportData then
                        RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
                    end
                end
            end
        end)
        num.pullIndex = pullNum

        num:Show()
        activeRoutePullNumbers[idx] = num
    end
end

--- Verifica se um mob está em algum pull (retorna pullIndex ou nil)
local function FindMobInPulls(pulls, mob)
    if not pulls then return nil end
    for pullIdx, pull in ipairs(pulls) do
        for mobIdx, m in ipairs(pull) do
            if m.npcID == mob.npcID
                and math.abs(m.x - mob.x) < 0.2
                and math.abs(m.y - mob.y) < 0.2 then
                return pullIdx, mobIdx
            end
        end
    end
    return nil
end

--- Adiciona um mob ao pull atual durante edição
local function AddMobToPull(mob)
    if not isRouteEditMode then return end

    -- Verifica se já está em algum pull
    local existingPull = FindMobInPulls(editingPulls, mob)
    if existingPull then return end

    -- Garante que o pull atual existe
    if not editingPulls[currentPullIndex] then
        editingPulls[currentPullIndex] = {}
    end

    table.insert(editingPulls[currentPullIndex], {
        npcID = mob.npcID,
        x = mob.x,
        y = mob.y,
        name = mob.name,
        displayID = mob.displayID,
        creatureType = mob.creatureType,
    })

    -- Re-renderiza rota, pins e sidebar
    RenderPullRoute(editingPulls, true)
    if currentMapID and currentImportData then
        RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
    end
    if UpdateSidebarForPulls then UpdateSidebarForPulls(editingPulls) end
    if UpdateRouteButtons then UpdateRouteButtons() end
end

--- Remove um mob de qualquer pull durante edição
local function RemoveMobFromPull(mob)
    if not isRouteEditMode then return end

    local pullIdx, mobIdx = FindMobInPulls(editingPulls, mob)
    if not pullIdx then return end

    table.remove(editingPulls[pullIdx], mobIdx)

    -- Remove pull se ficou vazio
    if #editingPulls[pullIdx] == 0 then
        table.remove(editingPulls, pullIdx)
        if currentPullIndex > #editingPulls then
            currentPullIndex = math.max(1, #editingPulls + 1)
        end
    end

    RenderPullRoute(editingPulls, true)
    if currentMapID and currentImportData then
        RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
    end
    if UpdateSidebarForPulls then UpdateSidebarForPulls(editingPulls) end
    if UpdateRouteButtons then UpdateRouteButtons() end
end

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

-- currentImportData e currentMapID declarados no topo do arquivo

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
    HideSpawnArea()
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
        if self.spawnPoints then
            ShowSpawnArea(self.spawnPoints)
        end
    end)
    pin:SetScript("OnLeave", function()
        GameTooltip:Hide()
        HideSpawnArea()
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

    -- Anel colorido de pull (cria sob demanda)
    if not pin.pullRing then
        local ring = pin:CreateTexture(nil, "BACKGROUND")
        ring:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask")
        ring:SetPoint("CENTER")
        pin.pullRing = ring
    end

    -- Número pequeno do pull (canto, discreto)
    if not pin.pullNum then
        local pnum = pin:CreateFontString(nil, "OVERLAY")
        pnum:SetFont("Fonts\\FRIZQT__.TTF", 8, "OUTLINE")
        pnum:SetPoint("BOTTOMRIGHT", pin, "BOTTOMRIGHT", 4, -4)
        pin.pullNum = pnum
    end

    -- Verifica se o mob está num pull
    local activePulls = isRouteEditMode and editingPulls or (viewingRoute and viewingRoute.pulls)
    local pullIdx = activePulls and FindMobInPulls(activePulls, mob) or nil
    if pullIdx then
        local r, g, b = GetPullColor(pullIdx)
        -- Anel: círculo maior e semitransparente ao redor do pin
        local pinW = pin:GetWidth()
        local ringSize = pinW + 10
        pin.pullRing:SetSize(ringSize, ringSize)
        pin.pullRing:SetVertexColor(r, g, b, 0.45)
        pin.pullRing:Show()
        -- Número discreto
        pin.pullNum:SetText(tostring(pullIdx))
        pin.pullNum:SetTextColor(r, g, b)
        pin.pullNum:Show()
    else
        pin.pullRing:Hide()
        pin.pullNum:Hide()
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

    if pullIdx then
        local r, g, b = GetPullColor(pullIdx)
        pin.tooltipSubText = pin.tooltipSubText ..
            string.format("\n|cff%02x%02x%02xPull #%d|r", r*255, g*255, b*255, pullIdx)
    end

    if mob.trackedAt then
        pin.tooltipSubText = pin.tooltipSubText .. "\n|cff00ff00Rastreado|r"
    end

    if isRouteEditMode then
        pin.tooltipSubText = pin.tooltipSubText ..
            "\n|cff888888Clique = add pull " .. currentPullIndex .. "  |  Direito = remover|r"
    end

    -- Guarda referência do mob no pin pra click handler
    pin.mobData = mob

    -- Click handlers para modo de edição de rota
    pin:SetScript("OnMouseDown", function(self, button)
        if not isRouteEditMode then return end
        if button == "LeftButton" and self.mobData then
            AddMobToPull(self.mobData)
        elseif button == "RightButton" and self.mobData then
            RemoveMobFromPull(self.mobData)
        end
    end)
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
-- PAINEL DE PULLS (lado esquerdo, independente da sidebar de mobs)
-- ============================

local PULL_PANEL_WIDTH = 180
local PULL_ROW_HEIGHT = 22
local PULL_MOB_ROW_HEIGHT = 18

-- Painel principal
local pullPanel = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
pullPanel:SetSize(PULL_PANEL_WIDTH, FRAME_HEIGHT)
pullPanel:SetPoint("TOPRIGHT", frame, "TOPLEFT", 4, 0)
pullPanel:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
pullPanel:Hide()

local pullPanelTitle = pullPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
pullPanelTitle:SetPoint("TOP", pullPanel, "TOP", 0, -14)
pullPanelTitle:SetText("Pulls")

local pullPanelHelp = pullPanel:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
pullPanelHelp:SetPoint("TOP", pullPanelTitle, "BOTTOM", 0, -2)
pullPanelHelp:SetText("Clique nos mobs no mapa")

local pullPanelScroll = CreateFrame("ScrollFrame", nil, pullPanel, "UIPanelScrollFrameTemplate")
pullPanelScroll:SetPoint("TOPLEFT", 14, -42)
pullPanelScroll:SetPoint("BOTTOMRIGHT", -30, 14)

local pullPanelContent = CreateFrame("Frame", nil, pullPanelScroll)
pullPanelContent:SetSize(PULL_PANEL_WIDTH - 44, 1)
pullPanelScroll:SetScrollChild(pullPanelContent)

local pullRowPool = {}
local pullMobRowPool = {}

local function GetOrCreatePullRow(index)
    if pullRowPool[index] then return pullRowPool[index] end

    local row = CreateFrame("Button", nil, pullPanelContent)
    row:SetSize(pullPanelContent:GetWidth(), PULL_ROW_HEIGHT)

    -- Barra de cor do pull (esquerda)
    local colorBar = row:CreateTexture(nil, "BACKGROUND")
    colorBar:SetSize(4, PULL_ROW_HEIGHT)
    colorBar:SetPoint("LEFT", 0, 0)
    row.colorBar = colorBar

    -- Highlight
    local hl = row:CreateTexture(nil, "BACKGROUND")
    hl:SetPoint("TOPLEFT", colorBar, "TOPRIGHT", 0, 0)
    hl:SetPoint("BOTTOMRIGHT")
    hl:SetColorTexture(1, 1, 1, 0.08)
    hl:Hide()
    row.highlight = hl

    -- Texto do pull
    local label = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    label:SetPoint("LEFT", colorBar, "RIGHT", 6, 0)
    label:SetJustifyH("LEFT")
    row.label = label

    -- Contagem de mobs
    local count = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    count:SetPoint("RIGHT", row, "RIGHT", -22, 0)
    count:SetTextColor(0.7, 0.7, 0.7)
    row.countText = count

    -- Botão X para deletar
    local delBtn = CreateFrame("Button", nil, row)
    delBtn:SetSize(14, 14)
    delBtn:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    local delText = delBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    delText:SetAllPoints()
    delText:SetText("|cffff4444x|r")
    delBtn.text = delText
    delBtn:SetScript("OnEnter", function(self) self.text:SetText("|cffff0000X|r") end)
    delBtn:SetScript("OnLeave", function(self) self.text:SetText("|cffff4444x|r") end)
    row.delBtn = delBtn

    row:SetScript("OnEnter", function(self)
        if not self.isActive then
            self.highlight:SetColorTexture(1, 1, 1, 0.08)
            self.highlight:Show()
        end
    end)
    row:SetScript("OnLeave", function(self)
        if not self.isActive then
            self.highlight:Hide()
        end
    end)

    pullRowPool[index] = row
    return row
end

local function GetOrCreatePullMobRow(index)
    if pullMobRowPool[index] then return pullMobRowPool[index] end

    local row = CreateFrame("Frame", nil, pullPanelContent)
    row:SetSize(pullPanelContent:GetWidth(), PULL_MOB_ROW_HEIGHT)

    -- Portrait pequeno
    local portrait = row:CreateTexture(nil, "ARTWORK")
    portrait:SetSize(14, 14)
    portrait:SetPoint("LEFT", 14, 0)
    row.portrait = portrait

    local pmask = row:CreateMaskTexture()
    pmask:SetTexture("Interface\\CHARACTERFRAME\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    pmask:SetAllPoints(portrait)
    portrait:AddMaskTexture(pmask)

    -- Nome do mob
    local name = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
    name:SetPoint("LEFT", portrait, "RIGHT", 4, 0)
    name:SetPoint("RIGHT", row, "RIGHT", -4, 0)
    name:SetJustifyH("LEFT")
    name:SetWordWrap(false)
    row.nameText = name

    pullMobRowPool[index] = row
    return row
end

UpdateSidebarForPulls = function(pulls)
    -- Esconde rows anteriores
    for _, row in pairs(pullRowPool) do row:Hide() end
    for _, row in pairs(pullMobRowPool) do row:Hide() end

    if not pulls or #pulls == 0 then
        pullPanelHelp:SetText("Clique nos mobs no mapa")
        pullPanelContent:SetHeight(1)
        pullPanel:Show()
        return
    end

    if isRouteEditMode then
        pullPanelHelp:SetText("Clique nos mobs no mapa")
    else
        pullPanelHelp:SetText("Visualizando rota salva")
    end

    local yOffset = 0
    local pullRowIdx = 0
    local mobRowIdx = 0

    for pullNum, pull in ipairs(pulls) do
        pullRowIdx = pullRowIdx + 1
        local pRow = GetOrCreatePullRow(pullRowIdx)
        local r, g, b = GetPullColor(pullNum)
        pRow.colorBar:SetColorTexture(r, g, b, 1)
        pRow.label:SetText(string.format("Pull #%d", pullNum))
        pRow.label:SetTextColor(r, g, b)
        pRow.countText:SetText(#pull .. " mobs")

        -- Destaque do pull ativo
        if isRouteEditMode and pullNum == currentPullIndex then
            pRow.isActive = true
            pRow.highlight:SetColorTexture(r, g, b, 0.2)
            pRow.highlight:Show()
        else
            pRow.isActive = false
            pRow.highlight:Hide()
        end

        if isRouteEditMode then
            pRow.delBtn:Show()

            -- Clique no pull = selecionar como ativo
            pRow:SetScript("OnClick", function()
                currentPullIndex = pullNum
                UpdateSidebarForPulls(editingPulls)
                if UpdateRouteButtons then UpdateRouteButtons() end
            end)

            pRow.delBtn:SetScript("OnClick", function()
                table.remove(editingPulls, pullNum)
                if currentPullIndex > #editingPulls then
                    currentPullIndex = math.max(1, #editingPulls + 1)
                end
                RenderPullRoute(editingPulls, true)
                UpdateSidebarForPulls(editingPulls)
                if currentMapID and currentImportData then
                    RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
                end
                if UpdateRouteButtons then UpdateRouteButtons() end
            end)
        else
            pRow.delBtn:Hide()
            pRow:SetScript("OnClick", nil)
        end

        pRow:ClearAllPoints()
        pRow:SetPoint("TOPLEFT", pullPanelContent, "TOPLEFT", 0, -yOffset)
        pRow:SetPoint("RIGHT", pullPanelContent, "RIGHT", 0, 0)
        pRow:Show()
        yOffset = yOffset + PULL_ROW_HEIGHT

        for _, mob in ipairs(pull) do
            mobRowIdx = mobRowIdx + 1
            local mRow = GetOrCreatePullMobRow(mobRowIdx)

            local displayID = mob.displayID
            if not displayID and mob.npcID and FarmBuddyMobTracker then
                displayID = FarmBuddyMobTracker:GetDisplayID(mob.npcID)
            end
            if displayID then
                pcall(SetPortraitTextureFromCreatureDisplayID, mRow.portrait, displayID)
                mRow.portrait:Show()
            else
                mRow.portrait:Hide()
            end

            mRow.nameText:SetText(mob.name or ("NPC " .. tostring(mob.npcID)))

            mRow:ClearAllPoints()
            mRow:SetPoint("TOPLEFT", pullPanelContent, "TOPLEFT", 0, -yOffset)
            mRow:SetPoint("RIGHT", pullPanelContent, "RIGHT", 0, 0)
            mRow:Show()
            yOffset = yOffset + PULL_MOB_ROW_HEIGHT
        end

        yOffset = yOffset + 4
    end

    pullPanelContent:SetHeight(math.max(1, yOffset))
    pullPanel:Show()
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
                grouped[key] = { mob = mob, count = 0, sx = 0, sy = 0, spawns = {} }
                table.insert(order, key)
            end
            local g = grouped[key]
            g.count = g.count + 1
            g.sx = g.sx + (mob.x / 100) * containerW
            g.sy = g.sy + (mob.y / 100) * containerH
            table.insert(g.spawns, { x = mob.x, y = mob.y })
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
        epin.spawnPoints = g.spawns

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

-- Renderiza TODOS os spawns individuais filtrados (para modo edição/visualização de rota)
local function RenderAllFilteredSpawns(mapID, mobData, filter, displayMode)
    HideAllPins()
    expandedPinIndex = 0

    if not mobData or not mobData.mobs or not mobData.mobs[mapID] then
        return
    end

    local containerW = pinContainer:GetWidth()
    local containerH = pinContainer:GetHeight()
    local pinIndex = 0

    for _, mob in ipairs(mobData.mobs[mapID]) do
        if FarmBuddyMobTracker:MatchesFilter(mob, filter) then
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

-- Dispatch: escolhe o render certo baseado no estado atual.
RenderMobPinsDispatch = function(mapID, mobData, filter, displayMode)
    if (isRouteEditMode or viewingRoute) and selectedCount > 0 then
        -- Modo rota + filtro isolado ativo: spawns individuais dos selecionados
        RenderIsolatedSpawns(mapID, mobData, displayMode, selectedNpcIDs)
    elseif isRouteEditMode or viewingRoute then
        -- Modo rota sem filtro: todos os spawns individuais
        RenderAllFilteredSpawns(mapID, mobData, filter, displayMode)
    elseif selectedCount > 0 then
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
-- BOTÕES DE ROTA — SISTEMA DE PULLS (modo Mobs)
-- ============================

-- Label que mostra o pull atual durante edição
local pullLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
pullLabel:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 20, 38)
pullLabel:SetTextColor(1, 0.82, 0)
pullLabel:Hide()

-- Botão "Editar Rota" — entra no modo edição
local btnEditRoute = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
btnEditRoute:SetSize(100, 22)
btnEditRoute:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -20, 12)
btnEditRoute:SetText("Editar Rota")
btnEditRoute:Hide()

-- Botão "Próximo Pull" — avança o pull durante edição
local btnNextPull = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
btnNextPull:SetSize(100, 22)
btnNextPull:SetPoint("RIGHT", btnEditRoute, "LEFT", -4, 0)
btnNextPull:SetText("Próximo Pull")
btnNextPull:Hide()

-- Botão "Otimizar" — reordena pulls pelo algoritmo
local btnOptimize = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
btnOptimize:SetSize(80, 22)
btnOptimize:SetPoint("RIGHT", btnNextPull, "LEFT", -4, 0)
btnOptimize:SetText("Otimizar")
btnOptimize:Hide()

-- Botão "Salvar" — salva a rota
local btnSaveRoute = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
btnSaveRoute:SetSize(70, 22)
btnSaveRoute:SetPoint("RIGHT", btnOptimize, "LEFT", -4, 0)
btnSaveRoute:SetText("Salvar")
btnSaveRoute:Hide()

-- Botão "Cancelar" / "Fechar" — sai do modo edição ou visualização
local btnCancelRoute = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
btnCancelRoute:SetSize(80, 22)
btnCancelRoute:SetPoint("RIGHT", btnSaveRoute, "LEFT", -4, 0)
btnCancelRoute:SetText("Cancelar")
btnCancelRoute:Hide()

-- Dropdown para rotas salvas
local routeDropdown = CreateFrame("Frame", "FarmBuddyRouteDropdown", frame, "UIDropDownMenuTemplate")
routeDropdown:SetPoint("RIGHT", btnEditRoute, "LEFT", 10, 0)
routeDropdown:Hide()

local function InitializeRouteDropdown(self, level)
    if level ~= 1 then return end
    if not currentMapID or not FarmBuddyRouteMaker then return end

    local routes = FarmBuddyRouteMaker:GetRoutes(currentMapID)

    if #routes == 0 then
        local info = UIDropDownMenu_CreateInfo()
        info.text = "Nenhuma rota salva"
        info.disabled = true
        info.notCheckable = true
        UIDropDownMenu_AddButton(info, level)
        return
    end

    for i, route in ipairs(routes) do
        local mobCount = FarmBuddyRouteMaker:CountMobsInRoute(route)
        local info = UIDropDownMenu_CreateInfo()
        info.text = string.format("%s (%d pulls, %d mobs)", route.name, #route.pulls, mobCount)
        info.value = i
        info.notCheckable = true
        info.func = function()
            -- Visualizar rota salva
            isRouteEditMode = false
            viewingRoute = route
            UIDropDownMenu_SetText(routeDropdown, route.name)
            CloseDropDownMenus()

            -- Renderiza só os mobs dos pulls + linhas
            RenderPullRoute(route.pulls, route.circular ~= false)
            if currentMapID and currentImportData then
                RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
            end
            if UpdateSidebarForPulls then UpdateSidebarForPulls(route.pulls) end
            if UpdateRouteButtons then UpdateRouteButtons() end
        end

        info.tooltipTitle = route.name
        info.tooltipText = string.format("Criada em %s\nFiltro: %s\n%d pulls, %d mobs\n\nShift+Clique para deletar",
            route.createdAt or "?", route.filter or "?", #route.pulls, mobCount)
        info.tooltipOnButton = true

        UIDropDownMenu_AddButton(info, level)
    end
end

UIDropDownMenu_Initialize(routeDropdown, InitializeRouteDropdown)
UIDropDownMenu_SetWidth(routeDropdown, 160)
UIDropDownMenu_SetText(routeDropdown, "Rotas salvas")

-- === Lógica dos botões ===

-- Entrar no modo edição
btnEditRoute:SetScript("OnClick", function()
    if isRouteEditMode then return end

    isRouteEditMode = true
    viewingRoute = nil
    wipe(editingPulls)
    currentPullIndex = 1

    -- Limpa seleção isolada (o dispatch agora renderiza tudo via RenderAllFilteredSpawns)
    wipe(selectedNpcIDs)
    selectedCount = 0
    UpdateSidebarHeader()

    if currentMapID and currentImportData then
        RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
    end

    UpdateSidebarForPulls(editingPulls)
    UpdateRouteButtons()
    print("|cff00ff00[FarmBuddy]|r Modo edição de rota. Clique nos mobs para adicionar ao pull atual.")
end)

-- Próximo pull
btnNextPull:SetScript("OnClick", function()
    if not isRouteEditMode then return end

    -- Só avança se o pull atual tem pelo menos 1 mob
    if editingPulls[currentPullIndex] and #editingPulls[currentPullIndex] > 0 then
        currentPullIndex = currentPullIndex + 1
        UpdateRouteButtons()
        local r, g, b = GetPullColor(currentPullIndex)
        print(string.format("|cff00ff00[FarmBuddy]|r Pull #%d ativo.", currentPullIndex))
    else
        print("|cffff6600[FarmBuddy]|r Adicione pelo menos 1 mob ao pull atual antes de avançar.")
    end
end)

-- Otimizar ordem dos pulls
btnOptimize:SetScript("OnClick", function()
    if not isRouteEditMode or #editingPulls < 2 then return end

    local optimized, distance = FarmBuddyRouteMaker:OptimizePullOrder(editingPulls, true)
    wipe(editingPulls)
    for i, pull in ipairs(optimized) do
        editingPulls[i] = pull
    end
    currentPullIndex = #editingPulls + 1

    RenderPullRoute(editingPulls, true)
    if currentMapID and currentImportData then
        RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
    end
    UpdateSidebarForPulls(editingPulls)
    UpdateRouteButtons()

    print(string.format("|cff00ff00[FarmBuddy]|r Pulls reordenados! Distância otimizada: %.1f", distance))
end)

-- Salvar rota
btnSaveRoute:SetScript("OnClick", function()
    if not isRouteEditMode or #editingPulls == 0 then return end
    if not currentMapID or not FarmBuddyRouteMaker then return end

    local mapInfo = C_Map.GetMapInfo(currentMapID)
    local zoneName = mapInfo and mapInfo.name or ("Mapa " .. currentMapID)
    local routeName = zoneName .. " — " .. date("%d/%m %H:%M")

    local ok = FarmBuddyRouteMaker:SaveRoute(currentMapID, editingPulls, routeName, currentProfessionFilter)
    if ok then
        local totalMobs = 0
        for _, pull in ipairs(editingPulls) do totalMobs = totalMobs + #pull end
        print(string.format("|cff00ff00[FarmBuddy]|r Rota \"%s\" salva! (%d pulls, %d mobs)",
            routeName, #editingPulls, totalMobs))
        UIDropDownMenu_SetText(routeDropdown, routeName)
    end

    -- Sai do modo edição
    isRouteEditMode = false
    wipe(editingPulls)
    currentPullIndex = 1
    HideRoute()
    wipe(selectedNpcIDs)
    selectedCount = 0
    UpdateSidebarHeader()
    if currentMapID and currentImportData then
        RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
    end
    pullPanel:Hide()
    UpdateRouteButtons()
end)

-- Cancelar / Fechar visualização
btnCancelRoute:SetScript("OnClick", function()
    isRouteEditMode = false
    viewingRoute = nil
    wipe(editingPulls)
    currentPullIndex = 1
    HideRoute()

    -- Reseta seleção isolada
    wipe(selectedNpcIDs)
    selectedCount = 0
    UpdateSidebarHeader()

    if currentMapID and currentImportData then
        RenderMobPinsDispatch(currentMapID, currentImportData, currentProfessionFilter, currentDisplayMode)
    end
    pullPanel:Hide()
    UpdateRouteButtons()
    UIDropDownMenu_SetText(routeDropdown, "Rotas salvas")
end)

-- Atualiza visibilidade dos botões conforme estado
UpdateRouteButtons = function()
    if currentMode ~= "mobs" then
        btnEditRoute:Hide()
        btnNextPull:Hide()
        btnOptimize:Hide()
        btnSaveRoute:Hide()
        btnCancelRoute:Hide()
        routeDropdown:Hide()
        pullLabel:Hide()
        return
    end

    if isRouteEditMode then
        -- Modo edição ativo
        btnEditRoute:Hide()
        routeDropdown:Hide()
        btnNextPull:Show()
        btnCancelRoute:Show()
        btnCancelRoute:SetText("Cancelar")

        -- Mostrar salvar/otimizar se tem pulls
        if #editingPulls > 0 then
            btnSaveRoute:Show()
            if #editingPulls >= 2 then
                btnOptimize:Show()
            else
                btnOptimize:Hide()
            end
        else
            btnSaveRoute:Hide()
            btnOptimize:Hide()
        end

        -- Label do pull atual
        local totalMobs = 0
        for _, pull in ipairs(editingPulls) do totalMobs = totalMobs + #pull end
        local r, g, b = GetPullColor(currentPullIndex)
        pullLabel:SetTextColor(r, g, b)
        pullLabel:SetText(string.format("Pull #%d  |  %d pulls  |  %d mobs",
            currentPullIndex, #editingPulls, totalMobs))
        pullLabel:Show()
    elseif viewingRoute then
        -- Visualizando rota salva
        btnEditRoute:Hide()
        btnNextPull:Hide()
        btnOptimize:Hide()
        btnSaveRoute:Hide()
        btnCancelRoute:Show()
        btnCancelRoute:SetText("Fechar Rota")
        routeDropdown:Show()
        pullLabel:Hide()
    else
        -- Estado normal
        btnEditRoute:Show()
        routeDropdown:Show()
        btnNextPull:Hide()
        btnOptimize:Hide()
        btnSaveRoute:Hide()
        btnCancelRoute:Hide()
        pullLabel:Hide()
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

        -- Limpa rota ao sair do modo mobs
        isRouteEditMode = false
        viewingRoute = nil
        wipe(editingPulls)
        currentPullIndex = 1
        HideRoute()
        pullPanel:Hide()

        btnModeNodes:SetNormalFontObject("GameFontHighlight")
        btnModeMobs:SetNormalFontObject("GameFontDisable")
    end
    UpdateRouteButtons()
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

    -- Trocar de mapa reseta a seleção isolada e a rota ativa
    wipe(selectedNpcIDs)
    selectedCount = 0
    UpdateSidebarHeader()
    isRouteEditMode = false
    viewingRoute = nil
    wipe(editingPulls)
    currentPullIndex = 1
    HideRoute()
    pullPanel:Hide()

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
    UpdateRouteButtons()
    UIDropDownMenu_SetText(routeDropdown, "Rotas salvas")
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
