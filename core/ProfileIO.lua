-- =============================================================================
-- FarmBuddy - Export/import de perfil e cópia entre personagens
-- =============================================================================
-- Formato: "!FB1!" + Base64(Deflate(AceSerializer(payload)))
-- payload = { v = 1, settings = {...}, filters = {...}, history = {...} }
-- =============================================================================

local L = FarmBuddyL

FarmBuddyProfileIO = {}
local P = FarmBuddyProfileIO

local PREFIX = "!FB1!"

local function Libs()
    local ser = LibStub and LibStub("AceSerializer-3.0", true)
    local def = LibStub and LibStub("LibDeflate", true)
    local b64 = LibStub and LibStub("LibBase64-1.0", true)
    return ser, def, b64
end

-- Configurações que acompanham o perfil (aparência é da conta, mas também
-- vai junto em "Settings" para facilitar levar o visual pra outra máquina)
local function CollectSettings(profile)
    return {
        timer = profile.timer and CopyTable(profile.timer) or nil,
        alerts = profile.alerts and CopyTable(profile.alerts) or nil,
        appearance = FarmBuddyDB.appearance and CopyTable(FarmBuddyDB.appearance) or nil,
    }
end

function P:Export(options)
    local ser, def, b64 = Libs()
    if not (ser and def and b64) then
        return nil, L["Unknown error"]
    end

    local profile = FarmTracker:GetProfile()
    local payload = { v = 1 }
    if options.settings then payload.settings = CollectSettings(profile) end
    if options.filters then payload.filters = CopyTable(profile.categoryFilters or {}) end
    if options.history then payload.history = CopyTable(profile.sessionHistory or {}) end

    local ok, serialized = pcall(ser.Serialize, ser, payload)
    if not ok then return nil, L["Error serializing data: "] .. tostring(serialized) end
    local compressed
    ok, compressed = pcall(def.CompressDeflate, def, serialized)
    if not ok or not compressed then return nil, L["Error compressing data: "] .. tostring(compressed) end
    local encoded
    ok, encoded = pcall(b64.encode or b64.Encode, b64, compressed)
    if not ok or not encoded then return nil, L["Error encoding Base64: "] .. tostring(encoded) end
    return PREFIX .. encoded
end

function P:Decode(text)
    text = (text or ""):gsub("%s+", "")
    if text == "" then return nil, L["Empty import string."] end
    if text:sub(1, #PREFIX) ~= PREFIX then
        return nil, L["This is not a FarmBuddy profile string."]
    end
    local ser, def, b64 = Libs()
    if not (ser and def and b64) then return nil, L["Unknown error"] end

    local ok, decoded = pcall(b64.decode or b64.Decode, b64, text:sub(#PREFIX + 1))
    if not ok or not decoded then return nil, L["Error decoding Base64: "] .. tostring(decoded) end
    local decompressed
    ok, decompressed = pcall(def.DecompressDeflate, def, decoded)
    if not ok or not decompressed then return nil, L["Error decompressing data: "] .. tostring(decompressed) end
    local success, payload = ser:Deserialize(decompressed)
    if not success or type(payload) ~= "table" or payload.v ~= 1 then
        return nil, L["Invalid data format."]
    end
    return payload
end

-- Aplica as partes escolhidas do payload no perfil atual
function P:Apply(payload, options)
    local profile = FarmTracker:GetProfile()
    if options.settings and type(payload.settings) == "table" then
        local s = payload.settings
        if type(s.timer) == "table" then profile.timer = CopyTable(s.timer) end
        if type(s.alerts) == "table" then profile.alerts = CopyTable(s.alerts) end
        if type(s.appearance) == "table" then FarmBuddyDB.appearance = CopyTable(s.appearance) end
    end
    if options.filters and type(payload.filters) == "table" then
        profile.categoryFilters = CopyTable(payload.filters)
    end
    if options.history and type(payload.history) == "table" then
        -- Junta ao histórico atual, sem apagar nada
        for _, session in ipairs(payload.history) do
            if type(session) == "table" then
                table.insert(profile.sessionHistory, CopyTable(session))
            end
        end
    end
    self:AfterChange()
end

-- Outros perfis salvos nesta conta
function P:GetOtherProfiles()
    local current = FarmTracker:GetProfileKey()
    local list = {}
    for key in pairs(FarmBuddyDB.profiles or {}) do
        if key ~= current then table.insert(list, key) end
    end
    table.sort(list)
    return list
end

-- Copia filtros, timer e alertas de outro personagem
function P:CopyFrom(key)
    local source = FarmBuddyDB.profiles and FarmBuddyDB.profiles[key]
    if not source then return false end
    local profile = FarmTracker:GetProfile()
    if source.categoryFilters then profile.categoryFilters = CopyTable(source.categoryFilters) end
    if source.timer then profile.timer = CopyTable(source.timer) end
    if source.alerts then profile.alerts = CopyTable(source.alerts) end
    self:AfterChange()
    return true
end

-- Atualiza tudo que depende das configurações
function P:AfterChange()
    if FarmTracker.ReloadTimerSettings then FarmTracker:ReloadTimerSettings() end
    if DisplayItem and DisplayItem.UpdateDisplay then DisplayItem:UpdateDisplay(FarmTracker.lootTable) end
    if FarmBuddyHistory and FarmBuddyHistory.Refresh then FarmBuddyHistory:Refresh() end
    if FarmBuddyTheme then FarmBuddyTheme:Apply() end
end
