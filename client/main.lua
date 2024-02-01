frameworkObject = false
MenuStatus = false

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
    while not frameworkObject do
        Citizen.Wait(0)
    end
    Citizen.Wait(1500)
    LoadDoorStatus()
    WhenReady()
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        local Player = PlayerPedId()
        local PlayerCoords = GetEntityCoords(Player)
        for k, v in pairs(Config.Houses) do
            if v.Owner == "" and v.RentOwner == "" then
                local Distance = GetDistanceBetweenCoords(PlayerCoords, v.HouseCoords.x, v.HouseCoords.y, v.HouseCoords.z, true)
                if Distance < 2 then
                    if not MenuStatus then
                        sleep = 4
                        DrawText3D('~INPUT_PICKUP~ - Open House Menu', v.HouseCoords)
                        if IsControlJustReleased(0, 38) then
                            OpenBuyMenu(k, false)
                            MenuStatus = true
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function WhenReady()
    Citizen.CreateThread(function()
        while true do
            local sleep = 2000
            local Player = PlayerPedId()
            local PlayerCoords = GetEntityCoords(Player)
            for k, v in pairs(Config.Houses) do
                for a, b in pairs(v.Garages.Coords) do
                    local Distance = GetDistanceBetweenCoords(PlayerCoords, b.OpenGarageCoords, true)
                    local playeridentity = ""
                    if v.Garages.AllowGarage then
                        if Distance < v.Garages.Distance then
                            sleep = 4
                            if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
                                playeridentity = frameworkObject.Functions.GetPlayerData().citizenid
                            else
                                playeridentity = frameworkObject.PlayerData.identifier
                            end
                            if v.Owner == playeridentity or v.RentOwner.owner == playeridentity or v.Friends.owner then
                                if IsPedInAnyVehicle(Player, false) then
                                    local PlayerVehicle = GetVehiclePedIsIn(Player, false)
                                    local VehiclePlate = GetVehicleNumberPlateText(PlayerVehicle)
                                    local GetVehicle = GetVehicleProps(PlayerVehicle)
                                    DrawText3D('~INPUT_PICKUP~ - Put car in to garage', b.OpenGarageCoords)
                                    if IsControlJustReleased(0, 38) then
                                        local CheckVehicleOwner = Callback('real-house:CheckVehicleOwner', VehiclePlate)
                                        if CheckVehicleOwner then
                                            local CheckGarageSlot = Callback('real-house:CheckGarageSlot', k)
                                            if not CheckGarageSlot then
                                                print("Successfuly parked vehicle")
                                                TriggerServerEvent('real-house:PutVehicleToGarage', GetVehicle, k)
                                                TaskLeaveVehicle(Player, PlayerVehicle, 64)
                                                Citizen.Wait(2000)
                                                DeleteVehicle(PlayerVehicle)
                                            else
                                                print("Garage is full")
                                            end
                                        else
                                            print("This is not your vehicle")
                                        end
                                    end
                                else
                                    DrawText3D('~INPUT_PICKUP~ - Open Garage Menu', b.OpenGarageCoords)
                                    if IsControlJustReleased(0, 38) then
                                        OpenGarageMenu(k)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            Citizen.Wait(sleep)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        TriggerServerEvent('real-house:CheckPayment')
    end
end)

function OpenBuyMenu(k, rentedstatus)
    local data = Callback('real-house:GetHouseAndPlayerData', k)
    SendNUIMessage({
        action = 'OpenBuyMenu',
        houseid = k,
        houseinfo = data.houseinfo,
        houseprice = data.houseprice,
        houserentprice = data.houserenprice,
        playername = data.playername,
        pfp = data.pfp,
        playerbank = data.playerbank,
        playercash = data.playercash,
    })
    SetNuiFocus(true, true)
end

function OpenGarageMenu(k)
    local data = Callback('real-house:GetGarageVehicles', k)
    SendNUIMessage({
        action = 'OpenGarage',
        name = data.name,
        pp = data.pp,
        data = data.data,
        currentslot = Config.Houses[k].Garages.AvailableSlot,
        maxslot = Config.Houses[k].Garages.MaxSlot,
        slotprice = Config.Houses[k].Garages.GarageSlotPrice,
        playerbank = data.playerbank,
        playercash = data.playercash,
        vehicleowner = data.vehicleowner,
        vehicleownerpp = data.vehicleownerpp,
        house = k
    })
    SetNuiFocus(true, true)
end

function LoadDoorStatus()
    Citizen.CreateThread(function()
        local data = Callback('real-house:DoorStatus')
        for k, v in pairs(Config.Houses) do
            for a, b in pairs(Config.Houses[k].DoorCoords) do
                local value = k * 1000
                local newvalue = a + value
                if b.LockStatus == nil then
                    b.LockStatus = true
                end
                if not IsDoorRegisteredWithSystem(newvalue) then
                    AddDoorToSystem(newvalue, b.DoorHash, b.Coords, true, true, true)
                    if data[a] then
                        DoorStatus = data[a].Status
                    else
                        DoorStatus = (b.LockStatus == true and 1 or 0)
                    end
                    DoorSystemSetDoorState(newvalue, DoorStatus, 0, 1)
                    SetStateOfClosestDoorOfType(newvalue, b.Coords, 1, 0.0, true)
                end
            end
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        local PlayerCoords = GetEntityCoords(PlayerPedId())
        for k, v in pairs(Config.Houses) do
            for a, b in pairs(v.DoorCoords) do
                local Distance = #(PlayerCoords - b.Coords)
                if Distance < 2 then
                    sleep = 4
                    local value = k * 1000
                    local newvalue = a + value
                    local DoorStatusText = ''
                    DoorStatus = DoorSystemGetDoorState(newvalue) == 0 and 1 or 0
                    if DoorStatus == 0 then
                        DoorStatusText = 'Locked'
                    else 
                        DoorStatusText = 'Unlocked'
                    end
                    if v.Owner ~= "" then
                        DrawText3D(DoorStatusText, b.Coords)
                    elseif v.RentOwner ~= "" then
                        DrawText3D(DoorStatusText, b.Coords)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent('real-house:OpenHouseDoors', function(house, keydata)
    local PlayerCoords = GetEntityCoords(PlayerPedId())

    for k, v in pairs(Config.Houses) do
        for a, b in pairs(v.DoorCoords) do
            local Distance = #(PlayerCoords - b.Coords)
            local value = k * 1000
            local newvalue = a + value
            if Distance < 1 then
                if k == house and v.KeyData == keydata then
                    UnlockAnim()
                    DoorStatus = DoorSystemGetDoorState(newvalue) == 0 and 1 or 0
                    if DoorStatus == 1 then
                        DoorStatusText = 'Locked'
                        print('Door locked')
                    else
                        DoorStatusText = 'Unlocked'
                        print('Door unlocked')
                    end
                    TriggerServerEvent('real-house:ChangeDoorStatus', b, DoorStatus, newvalue)
                else
                    print("Wrong keys")
                end
            end
        end
    end
end)

RegisterNetEvent('real-house:Client:ChangeDoorStatus', function(house, status, number)
    DoorSystemSetDoorState(number, status.status, 0, 1)
    SetStateOfClosestDoorOfType(number, house.DoorCoords, 1, 0.0, true)
end)

RegisterNUICallback('BuyNormalHouse', function(data)
    TriggerServerEvent('real-house:BuyHouse', data)
end)

RegisterNUICallback('RentHouse', function(data)
    TriggerServerEvent('real-house:RentHouse', data)
end)

RegisterNUICallback('BuyRentedHouse', function(data)
    TriggerServerEvent('real-house:BuyRentedHouse', data)
end)

RegisterNUICallback('CloseUI', function()
    SetNuiFocus(false, false)
    MenuStatus = false
end)

function UnlockAnim()
    RequestAnimDict("anim@mp_player_intmenu@key_fob@")
    while not HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@") do
        Citizen.Wait(1)
    end
    TaskPlayAnim(PlayerPedId(), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, 8.0, 1000, 1, 1, 0, 0, 0)
    Citizen.Wait(500)
    ClearPedTasks(PlayerPedId())
end

function Callback(name, payload)
    if Config.Framework == "newesx" or Config.Framework == "oldesx" then
        local data = nil
        if frameworkObject then
            frameworkObject.TriggerServerCallback(name, function(returndata)
                data = returndata
            end, payload)
            while data == nil do
                Citizen.Wait(0)
            end
        end
        return data
    else
        local data = nil
        if frameworkObject then
            frameworkObject.Functions.TriggerCallback(name, function(returndata)
                data = returndata
            end, payload)
            while data == nil do
                Citizen.Wait(0)
            end
        end
        return data
    end
end