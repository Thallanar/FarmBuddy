local ADDON_NAME, _ = ...

local defaultCategories = {
    "Miscellaneous","Cloth","Leather","Mail","Plate","Shields","Librams","Idols","Totems","Sigils",
    "Food & Drink","Potion","Elixir","Flask","Bandage","Item Enhancement","Scroll","Other","Consumable",
    "Bag","Enchanting Bag","Engineering Bag","Gem Bag","Herb Bag","Leatherworking Bag","Mining Bag",
    "Soul Bag","Blue","Green","Orange","Meta","Prismatic","Purple","Red","Simple","Yellow",
    "Artifact Relic","Key","Junk","Reagent","Pet","Holiday","Mount","Other","Currency",
    "Alchemy","Blacksmithing","Book","Cooking","Enchanting","Engineering","First Aid",
    "Inscription","Leatherworking","Tailoring","Quest","Armor Enchantment","Cloth","Devices",
    "Elemental","Enchanting","Explosives","Herb","Jewelcrafting","Leather","Materials","Meat",
    "Metal & Stone","Other","Parts","Trade Goods","Weapon Enchantment","Bows","Crossbows",
    "Daggers","Guns","Fishing Poles","Fist Weapons","Miscellaneous","One-Handed Axes",
    "One-Handed Maces","One-Handed Swords","Polearms","Staves","Thrown","Two-Handed Axes",
    "Two-Handed Maces","Two-Handed Swords","Wands","One-Hand","Two-Hand",
}

if not FarmBuddyDB then FarmBuddyDB = {} end

if not FarmBuddyDB.categoryFilters then
    FarmBuddyDB.categoryFilters = {}
    -- marca todas as categorias como ativas por padrão
    for _, cat in ipairs(defaultCategories) do
        FarmBuddyDB.categoryFilters[cat] = true
    end
end

TrackerSettings = TrackerSettings or {}

FarmTracker = FarmTracker or {}
FarmTracker.name = "FarmBuddy"
FarmTracker.version = "0.1"
FarmTracker.CategoriesList = FarmBuddyDB.categoryFilters

-- -- Mensagem de carregamento
-- local eventFrame = CreateFrame("Frame")
-- eventFrame:RegisterEvent("ADDON_LOADED")
-- eventFrame:SetScript("OnEvent", function(self, event, addonName)
--     if addonName == ADDON_NAME then
--         print("|cff00ff00" .. FarmTracker.name .. " v" .. FarmTracker.version .. " carregado com sucesso!|r")
--         print("Digite |cffffff00/farmbuddy|r para abrir a interface.")
--         TrackerSettings:Init(UIParent)
--         self:UnregisterEvent("ADDON_LOADED")
--     end
-- end)