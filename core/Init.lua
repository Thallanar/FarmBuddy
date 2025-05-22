local ADDON_NAME, _ = ...

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