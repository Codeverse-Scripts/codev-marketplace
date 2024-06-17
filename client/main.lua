Codev = exports["codev-lib"]:CodevLibrary()
Framework = Codev.Functions.GetCoreObject()

RegisterNuiCallback("getData", function (_, cb)
    TriggerCallback("codev-marketplace:server:getData", function(callback)
        cb(callback)
    end)
end)

RegisterNuiCallback("closeMenu", function ()
    SetNuiFocus(false, false)
end)

RegisterNuiCallback("addItem", function (data, cb)
    TriggerCallback("codev-marketplace:server:addItem", function(callback)
        cb(callback)
        if callback then
            SetNuiFocus(false, false)
            Config.Notify("Added item", "Marketplace", "success", 5000)
        else
            Config.Notify("Couldn't add item", "Marketplace", "error", 5000)
        end
    end, data)
end)

RegisterNuiCallback("buyItem", function (data,cb)
    TriggerCallback("codev-marketplace:server:buyItem", function(callback)
        cb(callback)
        if callback then
            SetNuiFocus(false, false)
        end
    end, data)
end)

RegisterCommand("marketplace", function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openMenu"
    })
end, false)

RegisterNetEvent("codev-marketplace:client:notify", function (message, title, type, length)
    Config.Notify(message, title, type, length)
end)