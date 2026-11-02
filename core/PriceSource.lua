FarmTracker = FarmTracker or {}

-- bindTypes que NÃO podem ser vendidos na Casa de Leilões.
-- Esses itens não devem entrar no cálculo de valor do histórico.
local NON_MARKETABLE_BIND_TYPES = {
    [1] = true, -- Bind on Pickup (soulbound)
    [7] = true, -- Warbound (vinculado à conta WoW)
    [8] = true, -- Vinculado à conta Battle.net
    [9] = true, -- Warbound até equipar (vinculado à warband)
}

-- Retorna true se o item (pelo bindType) pode ser vendido no mercado.
-- Soulbound e warbound retornam false.
function FarmTracker:IsMarketable(bindType)
    return not NON_MARKETABLE_BIND_TYPES[bindType or 0]
end

function FarmTracker:IsTSMAvailable()
    return TSMAPI_ALL and TSMAPI_ALL.Item and true or false
end

function FarmTracker:IsAuctionatorAvailable()
    return Auctionator and Auctionator.API and Auctionator.API.v1 and true or false
end

function FarmTracker:GetPriceSource()
    if self:IsTSMAvailable() then
        return "TSM"
    elseif self:IsAuctionatorAvailable() then
        return "Auctionator"
    end
    return nil
end

function FarmTracker:GetItemPrice(itemID, itemLink)
    if not itemID or itemID == 0 then
        return nil
    end

    -- Tenta TSM primeiro
    if self:IsTSMAvailable() then
        local itemString = "i:" .. itemID
        local success, price = pcall(function()
            return TSMAPI_ALL.Item.GetCustomPrice(itemString, "dbminbuyout")
        end)
        if success and price and price > 0 then
            return price
        end
    end

    -- Fallback para Auctionator
    if self:IsAuctionatorAvailable() and itemLink then
        local success, price = pcall(function()
            return Auctionator.API.v1.GetAuctionPriceByItemLink("FarmBuddy", itemLink)
        end)
        if success and price and price > 0 then
            return price
        end
    end

    return nil
end

-- Congela o valor da sessão: grava o preço unitário de cada item no momento da conclusão,
-- para que novos scans da AH não alterem o valor de sessões já finalizadas.
-- Sem fonte de preço disponível, não congela (tenta novamente no próximo login).
function FarmTracker:FreezeSessionValue(session)
    if session.valueFrozen or not session.lootTable then return end

    local source = self:GetPriceSource()
    if not source then return end

    local total = 0
    for itemID, data in pairs(session.lootTable) do
        local price = 0
        if self:IsMarketable(data.bindType) then
            price = self:GetItemPrice(tonumber(itemID), data.link) or 0
        end
        data.unitPrice = price
        total = total + price * (data.count or 0)
    end

    session.totalValue = total
    session.priceSource = source
    session.valueFrozen = true
end

function FarmTracker:FormatMoney(copperAmount)
    if not copperAmount or copperAmount <= 0 then
        return "0c"
    end

    local gold = math.floor(copperAmount / 10000)
    local silver = math.floor((copperAmount % 10000) / 100)
    local copper = copperAmount % 100

    local parts = {}
    if gold > 0 then
        table.insert(parts, "|cffffd700" .. gold .. "g|r")
    end
    if silver > 0 then
        table.insert(parts, "|cffc7c7cf" .. silver .. "s|r")
    end
    if copper > 0 or #parts == 0 then
        table.insert(parts, "|cffeda55f" .. copper .. "c|r")
    end

    return table.concat(parts, " ")
end
