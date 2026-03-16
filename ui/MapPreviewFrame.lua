FarmBuddyMapPreview = {}

-- Tamanho parecido com o mapa do jogo
local MAP_WIDTH = 1002
local MAP_HEIGHT = 668
local FRAME_WIDTH = MAP_WIDTH + 40
local FRAME_HEIGHT = MAP_HEIGHT + 90
local PIN_SIZE = 8
local MAX_TILES = 256

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

-- Map Container
local mapContainer = CreateFrame("Frame", nil, frame)
mapContainer:SetPoint("TOPLEFT", 20, -55)
mapContainer:SetSize(MAP_WIDTH, MAP_HEIGHT)
mapContainer:SetClipsChildren(true)

local mapBg = mapContainer:CreateTexture(nil, "BACKGROUND")
mapBg:SetAllPoints()
mapBg:SetColorTexture(0.05, 0.05, 0.05, 1)

-- Map Texture Frame
local mapTextureFrame = CreateFrame("Frame", nil, mapContainer)
mapTextureFrame:SetAllPoints()

-- Pin Container
local pinContainer = CreateFrame("Frame", nil, mapContainer)
pinContainer:SetAllPoints()
pinContainer:SetFrameLevel(mapTextureFrame:GetFrameLevel() + 10)

-- Pools
local tileTextures = {}
local pinPool = {}
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
            GameTooltip:Show()
        end
    end)
    pin:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    pinPool[index] = pin
    return pin
end

local function HideAllTiles()
    for _, tex in pairs(tileTextures) do
        tex:Hide()
    end
end

local function HideAllPins()
    for _, pin in ipairs(activePins) do
        pin:Hide()
    end
    wipe(activePins)
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

    mapTextureFrame:SetSize(displayWidth, displayHeight)
    mapTextureFrame:ClearAllPoints()
    mapTextureFrame:SetPoint("CENTER", mapContainer, "CENTER")

    pinContainer:SetSize(displayWidth, displayHeight)
    pinContainer:ClearAllPoints()
    pinContainer:SetPoint("CENTER", mapContainer, "CENTER")

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
        tile:Show()
    end

    return true
end

-- Nomes em PT dos tipos de node
local nodeTypePT = {
    ["Herb"] = "Erva",
    ["Mine"] = "Minério",
    ["Fish"] = "Pesca",
    ["Gas"] = "Gás",
    ["Treasure"] = "Tesouro",
    ["Archaeology"] = "Arqueologia",
    ["Logging"] = "Madeira",
}

-- Renderiza pins
local function RenderPins(mapID, importData)
    HideAllPins()

    if not importData or not importData.nodes or not importData.nodes[mapID] then
        return
    end

    local nodes = importData.nodes[mapID]
    local containerW = pinContainer:GetWidth()
    local containerH = pinContainer:GetHeight()
    local colors = FarmBuddyGatherImport.nodeColors

    for i, node in ipairs(nodes) do
        local pin = GetOrCreatePin(i)
        local px = (node.x / 100) * containerW
        local py = (node.y / 100) * containerH

        pin:ClearAllPoints()
        pin:SetPoint("CENTER", pinContainer, "TOPLEFT", px, -py)

        local color = colors[node.nodeType] or { 1, 1, 1 }
        pin.texture:SetVertexColor(color[1], color[2], color[3])

        pin.tooltipText = nodeTypePT[node.nodeType] or node.nodeType

        pin:Show()
        table.insert(activePins, pin)
    end
end

-- Info bar
local infoBar = CreateFrame("Frame", nil, frame)
infoBar:SetSize(frame:GetWidth() - 40, 24)
infoBar:SetPoint("BOTTOM", frame, "BOTTOM", 0, 15)

local infoText = infoBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
infoText:SetPoint("LEFT", 0, 0)

local function UpdateInfoBar(importData, mapID)
    if not importData then
        infoText:SetText("")
        return
    end

    local nodeCount = 0
    if importData.nodes and importData.nodes[mapID] then
        nodeCount = #importData.nodes[mapID]
    end

    local mapCount = importData.mapList and #importData.mapList or 0
    infoText:SetText(string.format("%d nodes neste mapa  |  %d mapas no total  |  %d nodes total",
        nodeCount, mapCount, importData.totalNodes or 0))
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
local function GroupMapsByContinent(mapList, importData)
    local continentGroups = {}   -- [continentName] = { continentID, maps = { {mapID, name, nodeCount} } }
    local continentOrder = {}    -- para manter ordem
    local noContinent = {}       -- mapas sem continente identificado

    for _, mapID in ipairs(mapList) do
        local mapInfo = C_Map.GetMapInfo(mapID)
        local zoneName = mapInfo and mapInfo.name or ("Mapa " .. mapID)

        local nodeCount = 0
        if importData.nodes and importData.nodes[mapID] then
            nodeCount = #importData.nodes[mapID]
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
                nodeCount = nodeCount,
            })
        else
            table.insert(noContinent, {
                mapID = mapID,
                name = zoneName,
                nodeCount = nodeCount,
            })
        end
    end

    -- Ordena continentes alfabeticamente
    table.sort(continentOrder)

    -- Ordena zonas dentro de cada continente
    for _, continentName in ipairs(continentOrder) do
        table.sort(continentGroups[continentName].maps, function(a, b)
            return a.name < b.name
        end)
    end

    -- Ordena mapas sem continente
    table.sort(noContinent, function(a, b) return a.name < b.name end)

    return continentGroups, continentOrder, noContinent
end

-- Zone Dropdown com submenus por continente
local dropdownFrame = CreateFrame("Frame", "FarmBuddyMapDropdown", frame, "UIDropDownMenuTemplate")
dropdownFrame:SetPoint("TOPLEFT", 5, -28)

local function LoadMap(mapID, importData)
    currentMapID = mapID

    local mapInfo = C_Map.GetMapInfo(mapID)
    local zoneName = mapInfo and mapInfo.name or ("Mapa " .. mapID)
    titleText:SetText("Preview: " .. (importData.name or "Import"))

    UIDropDownMenu_SetText(dropdownFrame, zoneName)

    local success = LoadMapTextures(mapID)
    if success then
        RenderPins(mapID, importData)
    else
        HideAllPins()
    end

    UpdateInfoBar(importData, mapID)
end

local function InitializeDropdown(self, level, menuList)
    if not currentImportData or not currentImportData.mapList then
        return
    end

    if level == 1 then
        local groups, order, noContinent = GroupMapsByContinent(currentImportData.mapList, currentImportData)

        for _, continentName in ipairs(order) do
            local group = groups[continentName]

            -- Total de nodes no continente
            local totalNodes = 0
            for _, mapEntry in ipairs(group.maps) do
                totalNodes = totalNodes + mapEntry.nodeCount
            end

            local info = UIDropDownMenu_CreateInfo()
            info.text = string.format("%s  |cff888888(%d nodes)|r", continentName, totalNodes)
            info.notCheckable = true
            info.hasArrow = true
            info.menuList = continentName
            UIDropDownMenu_AddButton(info, level)
        end

        -- Mapas sem continente
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
                info.text = string.format("%s (%d nodes)", mapEntry.name, mapEntry.nodeCount)
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

-- API Pública
function FarmBuddyMapPreview:Show(importData)
    if not importData or not importData.mapList or #importData.mapList == 0 then
        print("|cffff0000[FarmBuddy]|r Nenhum mapa disponível para preview.")
        return
    end

    currentImportData = importData
    LoadMap(importData.mapList[1], importData)
    frame:Show()
end

function FarmBuddyMapPreview:Hide()
    frame:Hide()
    HideAllPins()
    HideAllTiles()
    currentImportData = nil
    currentMapID = nil
end
