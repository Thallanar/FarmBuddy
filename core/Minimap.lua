local LDB = LibStub("LibDataBroker-1.1"):NewDataObject("Farm Buddy", 
{
    type = "data source",
    text = "Farm Buddy",
    icon = "Interface\\Icons\\inv_misc_herb_felblossom",
    OnClick = function(_, button)
        if FarmTracker.frame:IsShown() then
            FarmTracker.frame:Hide()
        else
            FarmTracker.frame:Show()
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("Farm Buddy")
        tooltip:AddLine("Clique para abrir/fechar.", 1, 1, 1)
    end,
})

local icon = LibStub("LibDBIcon-1.0")
FarmBuddyDB = FarmBuddyDB or {}
icon:Register("Farm Buddy", LDB, FarmBuddyDB)