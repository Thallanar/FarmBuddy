FarmTracker = FarmTracker or {}

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
