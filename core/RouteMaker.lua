-- =============================================================================
-- FarmBuddy - RouteMaker
-- =============================================================================
-- Sistema de rotas baseado em pulls (estilo MDT).
-- O jogador seleciona mobs individuais e agrupa em pulls numerados.
-- Cada pull representa um grupo de mobs a ser aggado junto.
-- O algoritmo otimiza a ordem dos pulls para minimizar o percurso.
-- =============================================================================

FarmBuddyRouteMaker = {}

-- ============================
-- UTILIDADES GEOMÉTRICAS
-- ============================

local function Distance(p1, p2)
    local dx = p1.x - p2.x
    local dy = p1.y - p2.y
    return math.sqrt(dx * dx + dy * dy)
end

local function TotalRouteDistance(route, circular)
    local total = 0
    for i = 1, #route - 1 do
        total = total + Distance(route[i], route[i + 1])
    end
    if circular and #route > 2 then
        total = total + Distance(route[#route], route[1])
    end
    return total
end

-- ============================
-- NEAREST NEIGHBOR + 2-OPT
-- ============================

local function NearestNeighbor(points, startIndex)
    local n = #points
    if n == 0 then return {} end
    startIndex = startIndex or 1

    local visited = {}
    local route = {}
    local current = startIndex

    for step = 1, n do
        visited[current] = true
        table.insert(route, points[current])

        local bestDist = math.huge
        local bestIdx = nil
        for j = 1, n do
            if not visited[j] then
                local d = Distance(points[current], points[j])
                if d < bestDist then
                    bestDist = d
                    bestIdx = j
                end
            end
        end
        current = bestIdx or current
    end
    return route
end

local function BestNearestNeighbor(points, circular)
    local n = #points
    if n <= 3 then
        return NearestNeighbor(points, 1)
    end

    local maxStarts = math.min(n, 20)
    local step = math.max(1, math.floor(n / maxStarts))
    local bestRoute, bestDist = nil, math.huge

    for start = 1, n, step do
        local route = NearestNeighbor(points, start)
        local dist = TotalRouteDistance(route, circular)
        if dist < bestDist then
            bestDist = dist
            bestRoute = route
        end
    end
    return bestRoute
end

local function ReverseSegment(route, i, j)
    while i < j do
        route[i], route[j] = route[j], route[i]
        i = i + 1
        j = j - 1
    end
end

local function TwoOpt(route, circular)
    local n = #route
    if n < 4 then return route end

    local improved = true
    local maxIter = 50

    while improved and maxIter > 0 do
        improved = false
        maxIter = maxIter - 1

        for i = 1, n - 2 do
            for j = i + 2, n do
                local d1 = Distance(route[i], route[i + 1])
                local d2, d1New, d2New

                if j < n then
                    d2 = Distance(route[j], route[j + 1])
                    d1New = Distance(route[i], route[j])
                    d2New = Distance(route[i + 1], route[j + 1])
                elseif circular then
                    d2 = Distance(route[j], route[1])
                    d1New = Distance(route[i], route[j])
                    d2New = Distance(route[i + 1], route[1])
                else
                    d2, d1New, d2New = 0, Distance(route[i], route[j]), 0
                end

                if (d1 + d2) > (d1New + d2New) then
                    ReverseSegment(route, i + 1, j)
                    improved = true
                end
            end
        end
    end
    return route
end

-- ============================
-- CENTRÓIDE DE UM PULL
-- ============================

--- Calcula o centróide de um pull (média das posições dos mobs).
function FarmBuddyRouteMaker:PullCentroid(pull)
    if not pull or #pull == 0 then return { x = 0, y = 0 } end
    local sx, sy = 0, 0
    for _, mob in ipairs(pull) do
        sx = sx + mob.x
        sy = sy + mob.y
    end
    return { x = sx / #pull, y = sy / #pull }
end

-- ============================
-- OTIMIZAR ORDEM DOS PULLS
-- ============================

--- Recebe uma lista de pulls e retorna a ordem otimizada (pelo centróide).
--- Não modifica os pulls internamente, só reordena.
--- @param pulls table Lista de pulls (cada pull é uma lista de mobs)
--- @param circular boolean Se true, fecha o ciclo
--- @return table orderedPulls Pulls reordenados
--- @return number distance Distância total entre centróides
function FarmBuddyRouteMaker:OptimizePullOrder(pulls, circular)
    if not pulls or #pulls <= 2 then
        return pulls, 0
    end

    -- Cria lista de centróides com referência ao pull original
    local centroids = {}
    for i, pull in ipairs(pulls) do
        local c = self:PullCentroid(pull)
        table.insert(centroids, { x = c.x, y = c.y, pullIndex = i })
    end

    -- Nearest Neighbor + 2-opt nos centróides
    local optimized = BestNearestNeighbor(centroids, circular)
    optimized = TwoOpt(optimized, circular)

    -- Reconstrói a lista de pulls na nova ordem
    local orderedPulls = {}
    for _, centroid in ipairs(optimized) do
        table.insert(orderedPulls, pulls[centroid.pullIndex])
    end

    local distance = TotalRouteDistance(optimized, circular)
    return orderedPulls, distance
end

-- ============================
-- SALVAR / CARREGAR / DELETAR
-- ============================

--- Salva uma rota de pulls no perfil do jogador.
--- @param mapID number ID do mapa/zona
--- @param pulls table Lista de pulls (cada pull = lista de {npcID, x, y, name, displayID})
--- @param routeName string Nome da rota
--- @param filter string Filtro usado na criação
function FarmBuddyRouteMaker:SaveRoute(mapID, pulls, routeName, filter)
    local profile = FarmTracker and FarmTracker:GetProfile()
    if not profile then return false end

    if not profile.routes then profile.routes = {} end
    if not profile.routes[mapID] then profile.routes[mapID] = {} end

    local entry = {
        name = routeName or ("Rota " .. date("%d/%m %H:%M")),
        pulls = {},
        filter = filter or "all",
        circular = true,
        createdAt = date("%Y-%m-%d %H:%M:%S"),
    }

    -- Deep copy dos pulls (sem referências externas)
    for pullNum, pull in ipairs(pulls) do
        entry.pulls[pullNum] = {}
        for _, mob in ipairs(pull) do
            table.insert(entry.pulls[pullNum], {
                npcID = mob.npcID,
                x = mob.x,
                y = mob.y,
                name = mob.name,
                displayID = mob.displayID,
                creatureType = mob.creatureType,
            })
        end
    end

    table.insert(profile.routes[mapID], entry)
    return true
end

--- Carrega todas as rotas salvas para um mapa.
function FarmBuddyRouteMaker:GetRoutes(mapID)
    local profile = FarmTracker and FarmTracker:GetProfile()
    if not profile or not profile.routes then return {} end
    return profile.routes[mapID] or {}
end

--- Remove uma rota salva pelo índice.
function FarmBuddyRouteMaker:DeleteRoute(mapID, index)
    local profile = FarmTracker and FarmTracker:GetProfile()
    if not profile or not profile.routes or not profile.routes[mapID] then return end
    table.remove(profile.routes[mapID], index)
end

--- Conta total de mobs em todos os pulls de uma rota.
function FarmBuddyRouteMaker:CountMobsInRoute(route)
    if not route or not route.pulls then return 0 end
    local total = 0
    for _, pull in ipairs(route.pulls) do
        total = total + #pull
    end
    return total
end
