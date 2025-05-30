local settingsFrame = CreateFrame("Frame", "SettingsFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
settingsFrame:SetSize(300, 400)
settingsFrame:SetPoint("CENTER")
settingsFrame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true, tileSize = 32, edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
settingsFrame:SetMovable(true)
settingsFrame:EnableMouse(true)
settingsFrame:RegisterForDrag("LeftButton")
settingsFrame:SetScript("OnDragStart", settingsFrame.StartMoving)
settingsFrame:SetScript("OnDragStop", settingsFrame.StopMovingOrSizing)


-- TítleBar
local titleBar = CreateFrame("Frame", nil, settingsFrame)
titleBar:SetSize(settingsFrame:GetWidth(), 24)
titleBar:SetPoint("TOP", settingsFrame, "TOP", 0, -6)

local titleText = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
titleText:SetPoint("LEFT", 15, 0)
titleText:SetText("Filters")

-- Close Button
local closeButton = CreateFrame("Button", nil, titleBar)
closeButton:SetSize(24, 24)
closeButton:SetPoint("TOPRIGHT", -8, 0)

local closeIcon = closeButton:CreateTexture(nil, "ARTWORK")
closeIcon:SetAllPoints()
closeIcon:SetTexture("Interface\\AddOns\\FarmBuddy\\icon\\close.png")

closeButton:SetScript("OnClick", function() 
    settingsFrame:Hide() 
end)

-- ScrollFrame para as categorias
local scrollFrame = CreateFrame("ScrollFrame", nil, settingsFrame, "UIPanelScrollFrameTemplate")
scrollFrame:SetPoint("TOPLEFT", 10, -40)
scrollFrame:SetPoint("BOTTOMRIGHT", -30, 10)

local scrollChild = CreateFrame("Frame", nil, scrollFrame)
scrollChild:SetSize(240, 10000) -- será ajustado conforme necessário
scrollFrame:SetScrollChild(scrollChild)

TrackerSettings.scrollChild = scrollChild
TrackerSettings.frame = settingsFrame
print("Abrindo painel de filtros...")
print("FarmTracker.CategoriesList:", FarmTracker.CategoriesList and #FarmTracker.CategoriesList or "nil")

function TrackerSettings:Toggle()
    if settingsFrame:IsShown() then
        self.frame:Hide()
    else
        self:BuildCheckboxes(FarmTracker.CategoriesList or {})
        self.frame:Show()
    end
end

settingsFrame:Hide()
SLASH_FBSETTINGS1 = "/fbstts"
SlashCmdList["FBSETTINGS"] = function()
    TrackerSettings:Toggle()
end