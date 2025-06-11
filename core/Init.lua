FarmBuddyDB = FarmBuddyDB or {}

local groupedCategories = {
    ["Armor"] = {"Miscellaneous","Cloth","Leather","Mail","Plate","Shields","Librams","Idols","Totems","Sigils"},
    ["Consumables"] = {"Food & Drink","Potion","Elixir","Flask","Bandage","Item Enhancement","Scroll","Other","Consumable"},
    ["Containers"] = {"Bag","Enchanting Bag","Engineering Bag","Gem Bag","Herb Bag","Leatherworking Bag","Mining Bag","Soul Bag"},
    ["Gems"] = {"Blue","Green","Orange","Meta","Prismatic","Purple","Red","Simple","Yellow","Artifact Relic"},
    ["Keys"] = {"Key"},
    ["Miscellaneous"] = {"Junk","Reagent","Pet","Holiday","Mount","Other"},
    ["Money"] = {"Currency"},
    ["Recipes"] = {"Alchemy","Blacksmithing","Book","Cooking","Enchanting","Engineering","First Aid", "Inscription","Leatherworking","Tailoring"},
    ["Quest Itens"] = {"Quest"},
    ["Goods"] = {"Armor Enchantment","Cloth","Devices",
    "Elemental","Enchanting","Explosives","Herb","Jewelcrafting","Leather","Materials","Meat",
    "Metal & Stone","Other","Parts","Trade Goods","Weapon Enchantment"},
    ["Weapons"] = {"Bows","Crossbows",
    "Daggers","Guns","Fishing Poles","Fist Weapons","Miscellaneous","One-Handed Axes",
    "One-Handed Maces","One-Handed Swords","Polearms","Staves","Thrown","Two-Handed Axes",
    "Two-Handed Maces","Two-Handed Swords","Wands","One-Hand","Two-Hand"}
}

FarmTracker = FarmTracker or {}

FarmTracker.categoryList = groupedCategories

TrackerSettings = TrackerSettings or {}

local count = 0
for _ in pairs(FarmTracker.categoryList) do
    count = count + 1
end

function FarmTracker:GetCategoryGroup(subType)
    if not self.categoryList then 
        return nil 
    end
    for sectionName, categories in pairs(self.categoryList) do
        for _, cat in ipairs(categories) do
            if cat == subType then
                return sectionName
            end
        end
    end
    return nil
end


-- Mensagem de carregamento
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "FarmBuddy" then
        print("|cff00ff00", addonName)
        
        FarmBuddyDB.categoryFilters = FarmBuddyDB.categoryFilters or {}

        -- Inicializa filtros padrão se não existirem
        for sectionName, categoryList in pairs(FarmTracker.categoryList) do
            for _, category in ipairs(categoryList) do
                local key = sectionName .. "::" .. category
                if FarmBuddyDB.categoryFilters[key] == nil then
                    FarmBuddyDB.categoryFilters[key] = true
                end
            end
        end

        if TrackerSettings and TrackerSettings.frame then
            TrackerSettings:BuildCheckboxes(FarmTracker.categoryList or {})
        end

        self:UnregisterEvent("ADDON_LOADED")
    end
end)