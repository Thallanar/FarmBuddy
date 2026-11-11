-- =============================================================================
-- FarmBuddy - API pública para extensões
-- =============================================================================
-- Extensões (ex: FarmBuddy_Forever) são addons separados que declaram
-- "## Dependencies: FarmBuddy" no TOC e usam esta API para injetar dados
-- no core, sem depender da estrutura interna das tabelas globais.
--
-- Versionamento: incrementar FarmBuddyAPI.version sempre que a API mudar
-- de forma incompatível. Extensões checam esse número antes de registrar.
-- =============================================================================

FarmBuddyAPI = {
    version = 1,
}

-- Extensões registradas (nome → info), útil para debug e para a UI no futuro
local extensions = {}

-- Registra uma extensão. info = { version = "1.0.0", title = "..." }
function FarmBuddyAPI:RegisterExtension(name, info)
    if type(name) ~= "string" then return false end
    extensions[name] = info or {}
    return true
end

function FarmBuddyAPI:GetExtensions()
    return extensions
end

-- Mescla uma tabela npcID → displayID na lookup global de mobs.
-- Escreve na MESMA tabela referenciada pelo MobTracker (nunca substituir),
-- então os mobs passam a valer imediatamente no gate de MatchesFilter.
-- Retorna quantas entradas foram adicionadas.
function FarmBuddyAPI:RegisterMobDisplayIDs(ids)
    if type(ids) ~= "table" or not FarmBuddyMobDisplayIDs then return 0 end

    local count = 0
    for npcID, displayID in pairs(ids) do
        if type(npcID) == "number" and type(displayID) == "number" then
            FarmBuddyMobDisplayIDs[npcID] = displayID
            count = count + 1
        end
    end
    return count
end
