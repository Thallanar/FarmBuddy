-- =============================================================================
-- FarmBuddy - Filtros de categoria (lógica)
-- =============================================================================
-- A interface fica em ui/SettingsFrame.lua (seção Filters).
-- Chave do filtro: "<Grupo>::<Categoria>"; false = escondido.
-- =============================================================================

TrackerSettings = TrackerSettings or {}

-- Grupos ordenados pelo nome exibido
function TrackerSettings:GetGroups()
    local groups = {}
    for name in pairs(FarmTracker.categoryList or {}) do
        table.insert(groups, name)
    end
    table.sort(groups, function(a, b) return FarmBuddyL[a] < FarmBuddyL[b] end)
    return groups
end

function TrackerSettings:IsShown(group, category)
    return FarmTracker:GetProfile().categoryFilters[group .. "::" .. category] ~= false
end

function TrackerSettings:SetShown(group, category, shown)
    FarmTracker:GetProfile().categoryFilters[group .. "::" .. category] = shown and true or false
end

function TrackerSettings:SetAll(shown)
    for group, categories in pairs(FarmTracker.categoryList or {}) do
        for _, category in ipairs(categories) do
            self:SetShown(group, category, shown)
        end
    end
    self:FiltersChanged()
end

function TrackerSettings:SetGroup(group, shown)
    for _, category in ipairs(FarmTracker.categoryList[group] or {}) do
        self:SetShown(group, category, shown)
    end
    self:FiltersChanged()
end

-- Quantas categorias do grupo estão visíveis
function TrackerSettings:CountShown(group)
    local list = FarmTracker.categoryList[group] or {}
    local shown = 0
    for _, category in ipairs(list) do
        if self:IsShown(group, category) then shown = shown + 1 end
    end
    return shown, #list
end

function TrackerSettings:FiltersChanged()
    if DisplayItem and DisplayItem.UpdateDisplay then
        DisplayItem:UpdateDisplay(FarmTracker.lootTable)
    end
end
