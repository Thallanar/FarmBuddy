-- =============================================================================
-- FarmBuddy - MobTracker
-- =============================================================================
-- Módulo core para gerenciamento de dados de mobs no mapa.
-- Filtra por profissão (Skinning/Tailoring).
-- Tracking em tempo real via eventos de nameplate e mouseover.
-- =============================================================================

FarmBuddyMobTracker = {}

-- Constantes
local DEDUP_DISTANCE = 2.0 -- distância mínima (coords normalizadas) para considerar mob "novo"

-- Filtros de profissão
FarmBuddyMobTracker.FILTER_SKINNING = "skinning"
FarmBuddyMobTracker.FILTER_TAILORING = "tailoring"
FarmBuddyMobTracker.FILTER_ALL = "all"

-- Cores por tipo de mob
FarmBuddyMobTracker.mobColors = {
    ["Beast"]     = { 0.8, 0.4, 0.1 },   -- laranja/couro
    ["Humanoid"]  = { 0.6, 0.2, 0.8 },   -- roxo/tecido
    ["Dragonkin"] = { 0.9, 0.1, 0.1 },   -- vermelho
}

-- Nomes em pt-BR dos tipos
FarmBuddyMobTracker.creatureTypePT = {
    ["Beast"]     = "Fera",
    ["Humanoid"]  = "Humanoide",
    ["Dragonkin"] = "Draconiano",
}

-- Nomes das profissões em pt-BR
FarmBuddyMobTracker.professionNamePT = {
    ["skinning"]  = "Couraria",
    ["tailoring"] = "Alfaiataria",
    ["all"]       = "Todos",
}

-- Frame de eventos para tracking
local eventFrame = CreateFrame("Frame")
local trackingActive = false

-- Lookup de displayID por npcID (carregado de data/MobDisplayIDs.lua)
local displayIDLookup = FarmBuddyMobDisplayIDs or {}

-- ============================
-- INICIALIZAÇÃO DE PERFIL
-- ============================

function FarmBuddyMobTracker:InitProfile(profile)
    if not profile.mobTracking then
        profile.mobTracking = {
            settings = {
                trackingEnabled = true,
                professionFilter = "skinning",
                displayMode = "icon",
            },
            tracked = {},
        }
    end

    -- Garante que settings tem todos os campos
    local settings = profile.mobTracking.settings
    if settings.trackingEnabled == nil then settings.trackingEnabled = true end
    if not settings.professionFilter then settings.professionFilter = "skinning" end
    if not settings.displayMode then settings.displayMode = "icon" end
    if not profile.mobTracking.tracked then profile.mobTracking.tracked = {} end
end

-- ============================
-- FILTRO DE PROFISSÃO
-- ============================

function FarmBuddyMobTracker:MatchesFilter(mobEntry, filter)
    if not filter or filter == "all" then
        return true
    end

    if filter == "skinning" then
        -- Skinnable explícito, ou Beast por padrão (se skinnable ~= false)
        if mobEntry.skinnable == true then
            return true
        end
        if mobEntry.skinnable == nil and mobEntry.creatureType == "Beast" then
            return true
        end
        return false
    end

    if filter == "tailoring" then
        -- clothDropper explícito, ou Humanoid por padrão (se clothDropper ~= false)
        if mobEntry.clothDropper == true then
            return true
        end
        if mobEntry.clothDropper == nil and mobEntry.creatureType == "Humanoid" then
            return true
        end
        return false
    end

    return true
end

-- ============================
-- DADOS TRACKED
-- ============================

function FarmBuddyMobTracker:GetMobData(filter)
    local merged = {
        mobs = {},
        mapList = {},
        totalMobs = 0,
        name = "Mobs",
    }

    local mapSet = {}

    -- Carregar dados tracked do perfil
    local profile = FarmTracker and FarmTracker:GetProfile()
    if profile and profile.mobTracking and profile.mobTracking.tracked then
        for mapID, mobs in pairs(profile.mobTracking.tracked) do
            if not merged.mobs[mapID] then
                merged.mobs[mapID] = {}
            end
            for _, mob in ipairs(mobs) do
                table.insert(merged.mobs[mapID], mob)
            end
            mapSet[mapID] = true
        end
    end

    -- 3. Construir mapList e contar mobs (respeitando filtro)
    for mapID, mobs in pairs(merged.mobs) do
        table.insert(merged.mapList, mapID)
        for _, mob in ipairs(mobs) do
            if self:MatchesFilter(mob, filter) then
                merged.totalMobs = merged.totalMobs + 1
            end
        end
    end

    table.sort(merged.mapList)

    return merged
end

-- ============================
-- TRACKING EM TEMPO REAL
-- ============================

-- Extrai NPC ID do GUID
local function GetNpcIDFromGUID(guid)
    if not guid then return nil end
    local npcID = select(6, strsplit("-", guid))
    return npcID and tonumber(npcID) or nil
end

-- Calcula distância entre dois pontos (coords normalizadas 0-100)
local function DistanceBetween(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return math.sqrt(dx * dx + dy * dy)
end

-- Verifica se um mob já existe nos dados (dedup)
local function IsDuplicate(mapID, x, y, npcID, trackedData)
    if not trackedData[mapID] then
        return false
    end

    for _, mob in ipairs(trackedData[mapID]) do
        if mob.npcID == npcID and DistanceBetween(mob.x, mob.y, x, y) < DEDUP_DISTANCE then
            return true
        end
    end

    return false
end

-- Extrai informações de um mob a partir de um unit token
local function ExtractMobInfo(unitToken)
    if not UnitExists(unitToken) then return nil end

    -- Ignorar jogadores, pets e unidades mortas
    if UnitIsPlayer(unitToken) then return nil end
    if UnitIsFriend("player", unitToken) then return nil end

    local guid = UnitGUID(unitToken)
    local npcID = GetNpcIDFromGUID(guid)
    if not npcID then return nil end

    local name = UnitName(unitToken)
    local creatureType = UnitCreatureType(unitToken)

    -- Só nos interessa Beast, Humanoid e Dragonkin
    if creatureType ~= "Beast" and creatureType ~= "Humanoid" and creatureType ~= "Dragonkin" then
        return nil
    end

    -- Posição do jogador (aproximação da posição do mob)
    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then return nil end

    local pos = C_Map.GetPlayerMapPosition(mapID, "player")
    if not pos then return nil end

    local x = pos.x * 100 -- normalizar para 0-100
    local y = pos.y * 100

    -- Determinar flags baseado no tipo
    local skinnable = (creatureType == "Beast") or (creatureType == "Dragonkin")
    local clothDropper = (creatureType == "Humanoid")

    -- Buscar displayID na tabela de lookup (0 = pendente, tratar como nil)
    local displayID = displayIDLookup[npcID]
    if displayID == 0 then displayID = nil end

    return {
        npcID = npcID,
        name = name or "Unknown",
        x = math.floor(x * 10 + 0.5) / 10, -- 1 casa decimal
        y = math.floor(y * 10 + 0.5) / 10,
        creatureType = creatureType,
        displayID = displayID,
        skinnable = skinnable,
        clothDropper = clothDropper,
        trackedAt = date("%Y-%m-%d %H:%M:%S"),
    }
end

-- Registra um mob encontrado
function FarmBuddyMobTracker:TrackMob(unitToken)
    local mobInfo = ExtractMobInfo(unitToken)
    if not mobInfo then return end

    local profile = FarmTracker and FarmTracker:GetProfile()
    if not profile or not profile.mobTracking then return end

    local mapID = C_Map.GetBestMapForUnit("player")
    if not mapID then return end

    local tracked = profile.mobTracking.tracked

    -- Verificar duplicata nos dados tracked
    if IsDuplicate(mapID, mobInfo.x, mobInfo.y, mobInfo.npcID, tracked) then
        return
    end

    -- Salvar
    if not tracked[mapID] then
        tracked[mapID] = {}
    end
    table.insert(tracked[mapID], mobInfo)
end

-- Handler de eventos
local function OnEvent(self, event, ...)
    if event == "NAME_PLATE_UNIT_ADDED" then
        local unitToken = ...
        FarmBuddyMobTracker:TrackMob(unitToken)
    elseif event == "UPDATE_MOUSEOVER_UNIT" then
        FarmBuddyMobTracker:TrackMob("mouseover")
    end
end

eventFrame:SetScript("OnEvent", OnEvent)

-- Inicia tracking
function FarmBuddyMobTracker:StartTracking()
    if trackingActive then return end

    eventFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
    eventFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
    trackingActive = true
end

-- Para tracking
function FarmBuddyMobTracker:StopTracking()
    if not trackingActive then return end

    eventFrame:UnregisterEvent("NAME_PLATE_UNIT_ADDED")
    eventFrame:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
    trackingActive = false
end

-- Retorna se tracking está ativo
function FarmBuddyMobTracker:IsTracking()
    return trackingActive
end

-- ============================
-- UTILIDADES
-- ============================

-- Retorna contagem de mobs tracked pelo jogador
function FarmBuddyMobTracker:GetTrackedCount()
    local profile = FarmTracker and FarmTracker:GetProfile()
    if not profile or not profile.mobTracking or not profile.mobTracking.tracked then
        return 0
    end

    local count = 0
    for _, mobs in pairs(profile.mobTracking.tracked) do
        count = count + #mobs
    end
    return count
end

-- Limpa todos os dados tracked
function FarmBuddyMobTracker:ClearTrackedData()
    local profile = FarmTracker and FarmTracker:GetProfile()
    if not profile or not profile.mobTracking then return end

    wipe(profile.mobTracking.tracked)
end

-- Retorna as settings do perfil atual
function FarmBuddyMobTracker:GetSettings()
    local profile = FarmTracker and FarmTracker:GetProfile()
    if not profile or not profile.mobTracking then return nil end
    return profile.mobTracking.settings
end

-- Salva uma setting
function FarmBuddyMobTracker:SetSetting(key, value)
    local settings = self:GetSettings()
    if settings then
        settings[key] = value
    end
end

-- Consulta displayID pela tabela de lookup (para mobs já tracked sem displayID)
function FarmBuddyMobTracker:GetDisplayID(npcID)
    local id = displayIDLookup[npcID]
    if id == 0 then return nil end
    return id
end
