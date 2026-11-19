-- =============================================================================
-- FarmBuddy: Forever - Inicialização da extensão
-- =============================================================================
-- Extensão com os mobs das zonas clássicas do WoW: Forever. Só carrega no
-- cliente Forever (o TOC lista apenas a Interface dele) e depende do core.
--
-- Os arquivos de zona em data/ chamam FarmBuddyForever:RegisterZone(name, mobs),
-- com cada mob no formato [npcID] = MobInfo(displayID, profissão). O RegisterZone
-- separa os dados e repassa para FarmBuddyAPI:RegisterMobDisplayIDs e
-- FarmBuddyAPI:RegisterMobProfessions no core.
-- =============================================================================

local ADDON_NAME = ...
local REQUIRED_API_VERSION = 1

-- Strings próprias da extensão: o core pode ser antigo e não ter as traduções
local L = {
    ["FarmBuddy: Forever requires FarmBuddy 1.9.0 or newer. Please update FarmBuddy."]
        = "FarmBuddy: Forever requires FarmBuddy 1.9.0 or newer. Please update FarmBuddy.",
}
if GetLocale() == "ptBR" then
    L["FarmBuddy: Forever requires FarmBuddy 1.9.0 or newer. Please update FarmBuddy."]
        = "FarmBuddy: Forever requer o FarmBuddy 1.9.0 ou mais recente. Atualize o FarmBuddy."
end

FarmBuddyForever = {
    ready = false,
    zones = {},   -- nome da zona → quantidade de mobs registrados
}

-- Core compatível? (FarmBuddyAPI só existe a partir do FarmBuddy 1.9.0)
if FarmBuddyAPI and (FarmBuddyAPI.version or 0) >= REQUIRED_API_VERSION then
    FarmBuddyForever.ready = true
    FarmBuddyAPI:RegisterExtension(ADDON_NAME, {
        title = "FarmBuddy: Forever",
        version = C_AddOns and C_AddOns.GetAddOnMetadata(ADDON_NAME, "Version"),
    })
else
    -- Avisa após o login para a mensagem não se perder na tela de carregamento
    local warnFrame = CreateFrame("Frame")
    warnFrame:RegisterEvent("PLAYER_LOGIN")
    warnFrame:SetScript("OnEvent", function(self)
        print("|cffffd100FarmBuddy|r: " .. L["FarmBuddy: Forever requires FarmBuddy 1.9.0 or newer. Please update FarmBuddy."])
        self:UnregisterAllEvents()
    end)
end

-- Dados de um mob nos arquivos de zona:
--   displayID  = modelo do retrato no mapa (0 = pendente, ícone genérico do tipo)
--   profession = "S" (esfolável), "C" (dropa tecido), "SC" (os dois), "" (nenhum)
--                ou nil (pendente: o core usa a regra por tipo)
function FarmBuddyForever.MobInfo(displayID, profession)
    return { displayID = displayID, profession = profession }
end

-- Chamado por cada data/MobDisplayIDs_<Zona>.lua
function FarmBuddyForever:RegisterZone(zoneName, mobs)
    if not self.ready then return end

    local displayIDs, professions = {}, {}
    for npcID, info in pairs(mobs) do
        displayIDs[npcID] = info.displayID
        professions[npcID] = info.profession
    end

    self.zones[zoneName] = FarmBuddyAPI:RegisterMobDisplayIDs(displayIDs)
    -- RegisterMobProfessions só existe a partir do FarmBuddy 1.11.0; em cores
    -- mais antigos o filtro continua usando a regra por tipo.
    if FarmBuddyAPI.RegisterMobProfessions then
        FarmBuddyAPI:RegisterMobProfessions(professions)
    end
end
