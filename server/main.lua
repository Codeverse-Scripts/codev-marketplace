Codev = exports["codev-lib"]:CodevLibrary()
Framework = Codev.Functions.GetCoreObject()

RegisterServerCallback("codev-marketplace:server:getData", function(source, callback)
    local sellingItems = Codev.Functions.GetJsonData(GetCurrentResourceName(), "database.json")
    local playerItems = Codev.Functions.GetPlayerInventory(source)
    local filteredItems = {}

    for _, items in pairs(Config.Categories) do
        for _, item in pairs(items.Items) do
            for _, playerItem in pairs(playerItems) do
                if item.name == playerItem.name then
                    playerItem.image = item.image
                    playerItem.label = item.label
                    playerItem.category = items.name
                    table.insert(filteredItems, playerItem)
                end
            end
        end
    end

    local data = {
        sellingItems = sellingItems,
        playerItems = filteredItems,
        categories = Config.Categories
    }

    callback(data)
end)

RegisterServerCallback("codev-marketplace:server:addItem", function(source, callback, data)
    local item = data.item
    local amount = tonumber(data.amount)
    local price = tonumber(data.price)
    local category = data.category
    local file = Codev.Functions.GetJsonData(GetCurrentResourceName(), "database.json") or {}
    local identifier = _GetPlayerIdentifier(source)
    local hasItem = Codev.Functions.HasItem(source, item.name, amount)
    local name = Codev.Functions.GetPlayerName(source)

    if amount > item.count then
        callback(false)
        return
    end

    if not hasItem then
        callback(false)
        return
    else
        Codev.Functions.RemoveItem(source, item.name, amount)
    end
    
    if not DoesIdentifierExists(identifier, file) then
        table.insert(file, {
            identifier = identifier,
            items = {}
        })
    end
    
    for _, player in pairs(file) do
        if player.identifier == identifier then
            if IsItemFound(player.items, item.name) then
                for _, sitem in pairs(player.items) do
                    if sitem.name == item.name then
                        sitem.amount = sitem.amount + amount
                        sitem.price = price
                        sitem.category = category
                        sitem.sellersrc = source
                        sitem.playerName = name
                        break
                    end
                end
            else
                table.insert(player.items, {
                    label = item.label,
                    image = item.image,
                    name = item.name,
                    amount = amount,
                    price = price,
                    category = category,
                    seller = identifier,
                    sellersrc = source,
                    playerName = name
                })
                break
            end

            break
        end
    end

    Codev.Functions.SaveJsonData(GetCurrentResourceName(), "database.json", file)
    callback(true)
end)

RegisterServerCallback("codev-marketplace:server:buyItem", function(source, callback, data)
    local item = data.item
    local boughtamount = tonumber(data.amount)
    local price = tonumber(data.price) * boughtamount
    local itemAmount = tonumber(item.amount)
    local sellerlicense = item.seller
    local seller = GetPlayerPed(item.sellersrc) and Codev.Functions.GetPlayer(item.sellersrc) or Codev.Functions.GetPlayerFromLicense(sellerlicense)
    local buyer = Codev.Functions.GetPlayer(source)
    local file = Codev.Functions.GetJsonData(GetCurrentResourceName(), "database.json")

    if sellerlicense == _GetPlayerIdentifier(source) then
        TriggerClientEvent("codev-marketplace:client:notify", source, "You can't buy your own items", "Marketplace", "error", 5000)
        callback(false)
        return
    end

    if not seller then
        TriggerClientEvent("codev-marketplace:client:notify", source, "Seller not found", "Marketplace", "error", 5000)
        callback(false)
        return
    end

    if not buyer then
        TriggerClientEvent("codev-marketplace:client:notify", source, "Buyer not found", "Marketplace", "error", 5000)
        callback(false)
        return
    end

    if itemAmount < boughtamount then
        TriggerClientEvent("codev-marketplace:client:notify", source, "Not enough items", "Marketplace", "error", 5000)
        callback(false)
        return
    end

    for _, player in pairs(file) do
        if player.identifier == sellerlicense then
            for _, sitem in pairs(player.items) do
                if sitem.name == item.name then
                    if sitem.amount == boughtamount then
                        table.remove(player.items, _)
                    else
                        sitem.amount = sitem.amount - boughtamount
                    end
                end
            end
        end
    end

    if not Codev.Functions.RemoveMoney(source, "bank", price, "Bought "..boughtamount.."x"..item.label) then
        TriggerClientEvent("codev-marketplace:client:notify", source, "Not enough money", "Marketplace", "error", 5000)
        callback(false)
        return
    end

    seller.Functions.AddMoney("bank", price, "Sold "..boughtamount.."x"..item.label)
    buyer.Functions.AddItem(item.name, boughtamount)

    if GetPlayerPed(item.sellersrc) then
        TriggerClientEvent("codev-marketplace:client:notify", item.sellersrc, "Your item has been sold", "Marketplace", "success", 5000)
    end

    Codev.Functions.SaveJsonData(GetCurrentResourceName(), "database.json", file)
    callback(true)
end)