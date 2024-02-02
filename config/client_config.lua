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