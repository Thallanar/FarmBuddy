-- =============================================================================
-- FarmBuddy - Botão do minimapa (LibDataBroker + LibDBIcon)
-- =============================================================================

local LOGO = "Interface\\AddOns\\FarmBuddy\\icon\\logo.png"

local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Farm Buddy", {
    type = "data source",
    text = "Farm Buddy",
    icon = LOGO,
    OnClick = function()
        if FarmTracker.frame:IsShown() then
            FarmTracker.frame:Hide()
        else
            FarmTracker.frame:Show()
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("Farm Buddy")
        tooltip:AddLine(FarmBuddyL["Click to toggle the window."], 1, 1, 1)
    end,
})

-- Registra só depois das SavedVariables carregarem: o LibDBIcon grava a
-- posição do ícone na tabela recebida, que precisa ser a salva
-- (antes era uma tabela local e a posição se perdia a cada reload).
local loader = CreateFrame("Frame")
loader:RegisterEvent("ADDON_LOADED")
loader:SetScript("OnEvent", function(self, _, addonName)
    if addonName ~= "FarmBuddy" then return end
    self:UnregisterEvent("ADDON_LOADED")
    FarmBuddyDB.minimap = FarmBuddyDB.minimap or {}
    LibStub("LibDBIcon-1.0"):Register("Farm Buddy", LDB, FarmBuddyDB.minimap)
end)
