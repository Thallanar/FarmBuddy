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
            local version = C_AddOns.GetAddOnMetadata("FarmBuddy", "Version")
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

        -- Restaura visibilidade do frame principal
        if profile.frameVisible and FarmTracker.frame then
            FarmTracker.frame:Show()
        end

        self:UnregisterEvent("ADDON_LOADED")

        -- Auto-detecção do GatherMate2 após todos os addons carregarem
        self:RegisterEvent("PLAYER_LOGIN")
    elseif event == "PLAYER_LOGIN" then
        self:UnregisterEvent("PLAYER_LOGIN")

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