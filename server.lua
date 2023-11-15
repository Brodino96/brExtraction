RegisterNetEvent("brFastTravel:payItem")
AddEventHandler("brFastTravel:payItem", function ()
    exports.ox_inventory:RemoveItem(source, Config.price.item, Config.price.quantity, nil, 1)
end)

RegisterNetEvent("brFastTravel:getMoneyBack")
AddEventHandler("brFastTravel:getMoneyBack", function ()
    exports.ox_inventory:AddItem(source, Config.price.item, Config.price.quantity, nil, 1, "success")
end)