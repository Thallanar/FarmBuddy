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

-- Registra o que cada mob rende para profissões (adicionado no FarmBuddy 1.11.0,
-- sem mudar a versão da API: extensões checam se a função existe).
-- flags = { [npcID] = "S" | "C" | "SC" | "" }
--   S = esfolável (Skinning), C = dropa tecido (Tailoring), "" = nenhum dos dois.
-- Mobs com flags registradas ignoram a regra por tipo (Fera = esfolável,
-- Humanoide = tecido) no filtro do Mapa de Mobs. Retorna quantas entradas valeram.
function FarmBuddyAPI:RegisterMobProfessions(flags)
    if type(flags) ~= "table" or not FarmBuddyMobProfessions then return 0 end

    local count = 0
    for npcID, value in pairs(flags) do
        if type(npcID) == "number" and type(value) == "string" then
            FarmBuddyMobProfessions[npcID] = {
                skinnable = value:find("S", 1, true) ~= nil,
                clothDropper = value:find("C", 1, true) ~= nil,
            }
            count = count + 1
        end
    end
    return count
end
