function DrawText3D(msg, coords)
    AddTextEntry('esxFloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function GiveVehicleKeys(plate, vehicle)
    if Config.VehicleKeySystem == 'qb-vehiclekeys' then
        TriggerServerEvent("qb-vehiclekeys:server:AcquireVehicleKeys", plate)
    elseif Config.VehicleKeySystem == 'qs-vehiclekeys' then
        exports["qs-vehiclekeys"]:GiveKeys(plate, model)
    elseif Config.VehicleKeySystem == 'wasabi-carlock' then
        exports.wasabi_carlock:GiveKey(plate)
    elseif Config.VehicleKeySystem == 'cd_garage' then
        TriggerEvent("cd_garage:AddKeys", plate)
    elseif Config.VehicleKeySystem == 'custom' then
        -- Your code
    end
end

function OpenStash(house)
    if Config.InventorySystem == 'qb-inventory' then
        TriggerServerEvent("inventory:server:OpenInventory", "stash", 'HouseStash_' ..house, {
            maxweight = Config.HouseStashWeight,
            slots = Config.HouseStashSlot
        })
        TriggerEvent("inventory:client:SetCurrentStash", 'HouseStash_' ..house)
    elseif Config.InventorySystem == 'ox_inventory' then
        if exports.ox_inventory:openInventory('stash', "house_"..house) == false then
            TriggerServerEvent('ox:loadStashes')
            exports.ox_inventory:openInventory('stash', "house_"..house)
        end
    end
end

function OpenWardrobe()
    if Config.WardrobeSystem == 'qb-clothing' then
        TriggerEvent('qb-clothing:client:openOutfitMenu')
    elseif Config.WardrobeSystem == 'fivem-appearance' then
        exports['fivem-appearance']:startPlayerCustomization()
    elseif Config.WardrobeSystem == 'illenium-appearance' then
        TriggerEvent('illenium-appearance:client:openOutfitMenu')
    elseif Config.WardrobeSystem == 'esx_skin' then
        TriggerEvent('esx_skin:openSaveableMenu')
    elseif Config.WardrobeSystem == 'custom' then
        -- Your code
    end
end