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

-- Mapeamento classID:subclassID → nome inglês (independente de idioma do client)
-- Ref: https://warcraft.wiki.gg/wiki/ItemType
local subClassMap = {
    -- Armor (classID 4)
    ["4:0"] = "Miscellaneous", ["4:1"] = "Cloth", ["4:2"] = "Leather",
    ["4:3"] = "Mail", ["4:4"] = "Plate", ["4:6"] = "Shields",
    ["4:7"] = "Librams", ["4:8"] = "Idols", ["4:9"] = "Totems", ["4:10"] = "Sigils",
    -- Consumables (classID 0)
    ["0:0"] = "Consumable", ["0:1"] = "Potion", ["0:2"] = "Elixir", ["0:3"] = "Flask",
    ["0:5"] = "Food & Drink", ["0:7"] = "Bandage", ["0:6"] = "Item Enhancement",
    ["0:8"] = "Other", ["0:4"] = "Scroll",
    -- Containers (classID 1)
    ["1:0"] = "Bag", ["1:1"] = "Soul Bag", ["1:2"] = "Herb Bag",
    ["1:3"] = "Enchanting Bag", ["1:4"] = "Engineering Bag",
    ["1:5"] = "Gem Bag", ["1:6"] = "Mining Bag", ["1:7"] = "Leatherworking Bag",
    -- Gems (classID 3)
    ["3:0"] = "Red", ["3:1"] = "Blue", ["3:2"] = "Yellow", ["3:3"] = "Purple",
    ["3:4"] = "Green", ["3:5"] = "Orange", ["3:6"] = "Meta", ["3:7"] = "Simple",
    ["3:8"] = "Prismatic", ["3:11"] = "Artifact Relic",
    -- Keys (classID 13)
    ["13:0"] = "Key",
    -- Miscellaneous (classID 15)
    ["15:0"] = "Junk", ["15:1"] = "Reagent", ["15:2"] = "Pet",
    ["15:3"] = "Holiday", ["15:4"] = "Other", ["15:5"] = "Mount",
    -- Currency (classID 10) — não tem subclass real
    ["10:0"] = "Currency",
    -- Recipes (classID 9)
    ["9:0"] = "Book", ["9:1"] = "Leatherworking", ["9:2"] = "Tailoring",
    ["9:3"] = "Engineering", ["9:4"] = "Blacksmithing", ["9:5"] = "Cooking",
    ["9:6"] = "Alchemy", ["9:7"] = "First Aid", ["9:8"] = "Enchanting",
    ["9:10"] = "Jewelcrafting", ["9:11"] = "Inscription",
    -- Quest (classID 12)
    ["12:0"] = "Quest",
    -- Trade Goods (classID 7)
    ["7:0"] = "Trade Goods", ["7:1"] = "Parts", ["7:2"] = "Explosives",
    ["7:4"] = "Devices", ["7:5"] = "Cloth", ["7:6"] = "Leather",
    ["7:7"] = "Metal & Stone", ["7:8"] = "Meat", ["7:9"] = "Herb",
    ["7:10"] = "Elemental", ["7:11"] = "Other", ["7:12"] = "Enchanting",
    ["7:13"] = "Materials", ["7:14"] = "Armor Enchantment",
    ["7:15"] = "Weapon Enchantment", ["7:16"] = "Jewelcrafting",
    -- Weapons (classID 2)
    ["2:0"] = "One-Handed Axes", ["2:1"] = "Two-Handed Axes", ["2:2"] = "Bows",
    ["2:3"] = "Guns", ["2:4"] = "One-Handed Maces", ["2:5"] = "Two-Handed Maces",
    ["2:6"] = "Polearms", ["2:7"] = "One-Handed Swords", ["2:8"] = "Two-Handed Swords",
    ["2:10"] = "Staves", ["2:13"] = "Fist Weapons", ["2:14"] = "Miscellaneous",
    ["2:15"] = "Daggers", ["2:16"] = "Thrown", ["2:18"] = "Crossbows",
    ["2:19"] = "Wands", ["2:20"] = "Fishing Poles",
}

FarmTracker = FarmTracker or {}

FarmTracker.categoryList = groupedCategories

-- Converte classID + subclassID para o nome inglês da subcategoria
function FarmTracker:GetEnglishSubType(classID, subclassID)
    if not classID then return nil end
    return subClassMap[classID .. ":" .. (subclassID or 0)]
end

TrackerSettings = TrackerSettings or {}

function FarmTracker:GetProfileKey()
    return UnitName("player") .. "-" .. GetRealmName()
end

function FarmTracker:GetProfile()
    local key = self:GetProfileKey()
    FarmBuddyDB.profiles = FarmBuddyDB.profiles or {}
    if not FarmBuddyDB.profiles[key] then
        FarmBuddyDB.profiles[key] = {
            categoryFilters = {},
            sessionHistory = {},
            frameVisible = false,
        }
    end
    return FarmBuddyDB.profiles[key]
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
        C_Timer.After(3, function()
            local version = (C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata)("FarmBuddy", "Version")
            print("|cff00ff00[FarmBuddy]|r v" .. (version or "?") .. " carregado! Digite |cff00ff00/farmbuddy|r para abrir.")
        end)

        local profile = FarmTracker:GetProfile()

        -- Migração: se existir categoryFilters no formato antigo, mover para o profile
        if FarmBuddyDB.categoryFilters then
            for k, v in pairs(FarmBuddyDB.categoryFilters) do
                if profile.categoryFilters[k] == nil then
                    profile.categoryFilters[k] = v
                end
            end
            FarmBuddyDB.categoryFilters = nil
        end

        -- Inicializa filtros padrão se não existirem
        for sectionName, categoryList in pairs(FarmTracker.categoryList) do
            for _, category in ipairs(categoryList) do
                local key = sectionName .. "::" .. category
                if profile.categoryFilters[key] == nil then
                    profile.categoryFilters[key] = true
                end
            end
        end

        if TrackerSettings and TrackerSettings.frame then
            TrackerSettings:BuildCheckboxes(FarmTracker.categoryList or {})
        end

        -- Migração: inicializa gatherImports se não existir
        if not profile.gatherImports then
            profile.gatherImports = {}
        end

        -- Migração: inicializa mobTracking se não existir
        if FarmBuddyMobTracker then
            FarmBuddyMobTracker:InitProfile(profile)
        end

        -- Restaura visibilidade do frame principal
        if profile.frameVisible and FarmTracker.frame then
            FarmTracker.frame:Show()
        end

        self:UnregisterEvent("ADDON_LOADED")

        -- Auto-detecção do GatherMate2 após todos os addons carregarem
        self:RegisterEvent("PLAYER_LOGIN")
    elseif event == "PLAYER_LOGIN" then
        self:UnregisterEvent("PLAYER_LOGIN")

        -- Inicia tracking de mobs se habilitado
        if FarmBuddyMobTracker then
            local profile = FarmTracker:GetProfile()
            if profile.mobTracking and profile.mobTracking.settings.trackingEnabled then
                FarmBuddyMobTracker:StartTracking()
            end
        end

        if not FarmBuddyGatherImport then
            return
        end

        -- Verifica se existe alguma global do GatherMate2 com dados
        local hasGM2Data = false
        local gm2Prefixes = { "Herb", "Mine", "Fish", "Gas", "Treasure", "Archaeology", "Logging" }
        local gm2Suffixes = { "", "DF", "TWW", "MN" }
        for _, prefix in ipairs(gm2Prefixes) do
            for _, suffix in ipairs(gm2Suffixes) do
                local globalName = "GatherMate2" .. prefix .. "DB" .. suffix
                if _G[globalName] and type(_G[globalName]) == "table" and next(_G[globalName]) then
                    hasGM2Data = true
                    break
                end
            end
            if hasGM2Data then break end
        end

        if not hasGM2Data then
            return
        end

        local profile = FarmTracker:GetProfile()
        profile.gatherImports = profile.gatherImports or {}

        -- Verifica se já existe um import automático
        local hasAutoImport = false
        for _, entry in ipairs(profile.gatherImports) do
            if entry.source == "gathermate2db_auto" then
                hasAutoImport = true
                break
            end
        end

        if not hasAutoImport then
            local parsedData, err = FarmBuddyGatherImport:ParseFromDB(nil)
            if parsedData and parsedData.totalNodes > 0 then
                FarmBuddyGatherImport:SaveImport(
                    "GatherMate2 (auto-detectado)",
                    parsedData,
                    "gathermate2db_auto"
                )
                C_Timer.After(4, function()
                    print("|cff00ff00[FarmBuddy]|r Dados do GatherMate2 detectados! "
                        .. parsedData.totalNodes .. " nodes importados automaticamente. "
                        .. "Abra o Import Manager para visualizar.")
                end)
            end
        end
    end
end)