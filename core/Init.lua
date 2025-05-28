local ADDON_NAME, _ = ...

if not FarmBuddyDB then FarmBuddyDB = {} end
if not FarmBuddyDB.categoryFilters then
    FarmBuddyDB.categoryFilters = {}
end

-- Preenche categorias padrão se ainda não existirem
local defaultCategories = {
    ["Ervas"] = true,
    ["Minério"] = true,
    ["Couro"] = true,
    ["Tecidos"] = true,
    ["Pele"] = true,
    ["Outros"] = true
}

for cat, val in pairs(defaultCategories) do
    if FarmBuddyDB.categoryFilters[cat] == nil then
        FarmBuddyDB.categoryFilters[cat] = val
    end
end

FarmTracker = FarmTracker or {}
FarmTracker.name = "Farm Buddy"
FarmTracker.version = "0.1"

-- Mensagem de carregamento
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(_, event, addonName)
    if addonName == "FarmBuddy" then
        print("|cff00ff00" .. FarmTracker.name .. " v" .. FarmTracker.version .. " carregado com sucesso!|r")
        print("Digite |cffffff00/farmbuddy|r para abrir a interface.")
    end
end)