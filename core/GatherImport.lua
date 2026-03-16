FarmBuddyGatherImport = {}

-- Sufixos de expansão usados pelo GatherMate2Storage
local EXPANSION_SUFFIXES = { "", "DF", "TWW", "MN" }

-- Tipos de node e seus prefixos de global
local NODE_TYPES = {
    { prefix = "Herb",          nodeType = "Herb" },
    { prefix = "Mine",          nodeType = "Mine" },
    { prefix = "Fish",          nodeType = "Fish" },
    { prefix = "Gas",           nodeType = "Gas" },
    { prefix = "Treasure",      nodeType = "Treasure" },
    { prefix = "Archaeology",   nodeType = "Archaeology" },
    { prefix = "Logging",       nodeType = "Logging" },
}

-- Cores por tipo de node (r, g, b)
FarmBuddyGatherImport.nodeColors = {
    ["Herb"]          = { 0.0, 0.8, 0.0 },
    ["Mine"]          = { 0.6, 0.4, 0.2 },
    ["Fish"]          = { 0.2, 0.5, 1.0 },
    ["Gas"]           = { 0.7, 0.0, 0.7 },
    ["Treasure"]      = { 1.0, 0.84, 0.0 },
    ["Archaeology"]   = { 0.8, 0.6, 0.4 },
    ["Logging"]       = { 0.4, 0.3, 0.1 },
}

-- Decodifica coordenada inteira do GatherMate2 para x, y (0-100)
local function DecodeCoord(coordInt)
    local x = (math.floor(coordInt / 1000000) % 10000) / 100
    local y = (math.floor(coordInt / 100) % 10000) / 100
    return x, y
end

-- Monta nome da global: GatherMate2{Prefix}DB{Suffix}
-- Ex: GatherMate2HerbDB, GatherMate2HerbDBDF, GatherMate2HerbDBTWW
local function GetGlobalName(prefix, suffix)
    return "GatherMate2" .. prefix .. "DB" .. suffix
end

-- Processa uma tabela de nodes no formato [mapID] = { [coordInt] = nodeID }
local function ProcessNodeTable(nodeTable, nodeType, nodes, mapSet)
    local count = 0
    for mapID, coordTable in pairs(nodeTable) do
        if type(mapID) == "number" and type(coordTable) == "table" then
            if not nodes[mapID] then
                nodes[mapID] = {}
            end
            for coordInt, nodeID in pairs(coordTable) do
                if type(coordInt) == "number" then
                    local x, y = DecodeCoord(coordInt)
                    table.insert(nodes[mapID], {
                        x = x,
                        y = y,
                        nodeID = nodeID,
                        nodeType = nodeType,
                    })
                    count = count + 1
                end
            end
            mapSet[mapID] = true
        end
    end
    return count
end

-- Busca todas as globals do GatherMate2 disponíveis para um tipo de node
local function FindGlobalsForType(prefix)
    local found = {}
    for _, suffix in ipairs(EXPANSION_SUFFIXES) do
        local globalName = GetGlobalName(prefix, suffix)
        local globalTable = _G[globalName]
        if globalTable and type(globalTable) == "table" and next(globalTable) then
            table.insert(found, { name = globalName, data = globalTable, suffix = suffix })
        end
    end
    return found
end

-- Retorna tipos de node disponíveis nas globals do GatherMate2
function FarmBuddyGatherImport:GetAvailableTypes()
    local available = {}

    for _, typeDef in ipairs(NODE_TYPES) do
        local globals = FindGlobalsForType(typeDef.prefix)
        if #globals > 0 then
            -- Conta nodes totais desse tipo
            local totalForType = 0
            local sources = {}
            for _, g in ipairs(globals) do
                local count = 0
                for _, coordTable in pairs(g.data) do
                    if type(coordTable) == "table" then
                        for _ in pairs(coordTable) do
                            count = count + 1
                        end
                    end
                end
                totalForType = totalForType + count
                table.insert(sources, g.suffix == "" and "Base" or g.suffix)
            end

            table.insert(available, {
                prefix = typeDef.prefix,
                nodeType = typeDef.nodeType,
                totalNodes = totalForType,
                sources = table.concat(sources, ", "),
            })
        end
    end

    if #available == 0 then
        return nil, "Nenhum dado do GatherMate2 encontrado. Verifique se o GatherMate2 e seus pacotes de dados estão instalados e habilitados."
    end

    table.sort(available, function(a, b) return a.nodeType < b.nodeType end)
    return available
end

-- Importa direto das globals do GatherMate2
-- nodeTypeFilter: table { [prefix] = true } ou nil para todos
function FarmBuddyGatherImport:ParseFromDB(nodeTypeFilter)
    local nodes = {}
    local mapSet = {}
    local totalNodes = 0

    for _, typeDef in ipairs(NODE_TYPES) do
        if not nodeTypeFilter or nodeTypeFilter[typeDef.prefix] then
            local globals = FindGlobalsForType(typeDef.prefix)
            for _, g in ipairs(globals) do
                local ok, count = pcall(ProcessNodeTable, g.data, typeDef.nodeType, nodes, mapSet)
                if ok then
                    totalNodes = totalNodes + count
                end
            end
        end
    end

    if totalNodes == 0 then
        return nil, "Nenhum node encontrado para os tipos selecionados."
    end

    local mapList = {}
    for mapID in pairs(mapSet) do
        table.insert(mapList, mapID)
    end
    table.sort(mapList)

    return {
        nodes = nodes,
        mapList = mapList,
        totalNodes = totalNodes,
    }
end

-- Mapeamento de chaves antigas (para strings do GatherMate2_ImportExport)
local IMPORT_KEY_MAP = {
    ["Herb Gathering"] = "Herb",
    ["Mining"]         = "Mine",
    ["Fishing"]        = "Fish",
    ["Gas Extraction"] = "Gas",
    ["Treasure"]       = "Treasure",
    ["Archaeology"]    = "Archaeology",
    ["Logging"]        = "Logging",
}

-- Processa tabela raw de import string (estrutura diferente: nodeTypeName -> mapID -> coord -> nodeID)
local function ProcessImportStringData(rawData)
    local nodes = {}
    local mapSet = {}
    local totalNodes = 0

    for key, mapTable in pairs(rawData) do
        local nodeType = IMPORT_KEY_MAP[key]
        if nodeType and type(mapTable) == "table" then
            for mapID, coordTable in pairs(mapTable) do
                if type(mapID) == "number" and type(coordTable) == "table" then
                    if not nodes[mapID] then
                        nodes[mapID] = {}
                    end
                    for coordInt, nodeID in pairs(coordTable) do
                        if type(coordInt) == "number" then
                            local x, y = DecodeCoord(coordInt)
                            table.insert(nodes[mapID], {
                                x = x,
                                y = y,
                                nodeID = nodeID,
                                nodeType = nodeType,
                            })
                            totalNodes = totalNodes + 1
                        end
                    end
                    mapSet[mapID] = true
                end
            end
        end
    end

    local mapList = {}
    for mapID in pairs(mapSet) do
        table.insert(mapList, mapID)
    end
    table.sort(mapList)

    return nodes, mapList, totalNodes
end

-- Importa de string exportada (Base64 -> LibDeflate -> AceSerializer)
function FarmBuddyGatherImport:ParseFromString(inputString)
    if not inputString or inputString == "" then
        return nil, "String de import vazia."
    end

    -- Remove espaços e quebras de linha
    inputString = inputString:gsub("%s+", "")

    -- Base64 decode
    local LibBase64 = LibStub and LibStub("LibBase64-1.0", true)
    if not LibBase64 then
        return nil, "LibBase64-1.0 não encontrada."
    end

    local ok, decoded = pcall(LibBase64.Decode, LibBase64, inputString)
    if not ok or not decoded then
        return nil, "Erro ao decodificar Base64: " .. tostring(decoded)
    end

    -- LibDeflate decompress
    local LibDeflate = LibStub and LibStub("LibDeflate", true)
    if not LibDeflate then
        return nil, "LibDeflate não encontrada."
    end

    local decompressed
    ok, decompressed = pcall(LibDeflate.DecompressDeflate, LibDeflate, decoded)
    if not ok or not decompressed then
        return nil, "Erro ao descomprimir dados: " .. tostring(decompressed)
    end

    -- AceSerializer deserialize
    local AceSerializer = LibStub and LibStub("AceSerializer-3.0", true)
    if not AceSerializer then
        return nil, "AceSerializer-3.0 não encontrada."
    end

    local success, rawData = AceSerializer:Deserialize(decompressed)
    if not success then
        return nil, "Erro ao deserializar dados: " .. tostring(rawData)
    end

    if type(rawData) ~= "table" then
        return nil, "Formato de dados inválido."
    end

    local okProcess, nodes, mapList, totalNodes = pcall(ProcessImportStringData, rawData)
    if not okProcess then
        return nil, "Erro ao processar dados importados: " .. tostring(nodes)
    end

    if totalNodes == 0 then
        return nil, "Nenhum node encontrado na string importada."
    end

    return {
        nodes = nodes,
        mapList = mapList,
        totalNodes = totalNodes,
    }
end

-- Salva import no profile
function FarmBuddyGatherImport:SaveImport(name, parsedData, source)
    local profile = FarmTracker:GetProfile()
    if not profile.gatherImports then
        profile.gatherImports = {}
    end

    local entry = {
        name = name or "Import sem nome",
        createdAt = date("%Y-%m-%d %H:%M:%S"),
        source = source or "unknown",
        nodes = parsedData.nodes,
        mapList = parsedData.mapList,
        totalNodes = parsedData.totalNodes,
    }

    table.insert(profile.gatherImports, entry)
    return #profile.gatherImports
end

-- Remove import por índice
function FarmBuddyGatherImport:DeleteImport(index)
    local profile = FarmTracker:GetProfile()
    if profile.gatherImports and profile.gatherImports[index] then
        table.remove(profile.gatherImports, index)
        return true
    end
    return false
end

-- Renomeia import
function FarmBuddyGatherImport:RenameImport(index, newName)
    local profile = FarmTracker:GetProfile()
    if profile.gatherImports and profile.gatherImports[index] then
        profile.gatherImports[index].name = newName
        return true
    end
    return false
end
