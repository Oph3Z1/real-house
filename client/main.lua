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
            local playeridentity = ""
            local garagestatus = false
            for k, v in pairs(Config.Houses) do
                for a, b in pairs(v.Garages.Coords) do
                    local Distance = GetDistanceBetweenCoords(PlayerCoords, b.OpenGarageCoords, true)
                    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
                        playeridentity = frameworkObject.Functions.GetPlayerData().citizenid
                    else
                        playeridentity = frameworkObject.PlayerData.identifier
                    end
                    if v.Garages.AllowGarage then
                        if Distance < v.Garages.Distance then
                            sleep = 4
                            if type(v.RentOwner) == "table" then
                                for e, f in pairs(v.RentOwner) do
                                    if e == "owner" then
                                        if next(v.Friends) then
                                            for c, d in pairs(v.Friends) do
                                                if f == playeridentity or d.owner == playeridentity then
                                                    garagestatus = true
                                                end
                                            end
                                        else
                                            if f == playeridentity then
                                                garagestatus = true
                                            end
                                        end
                                    end
                                end
                            else
                                if next(v.Friends) then
                                    for c, d in pairs(v.Friends) do
                                        if v.Owner == playeridentity or d.owner == playeridentity then
                                            garagestatus = true
                                        end
                                    end
                                else
                                    if v.Owner == playeridentity then
                                        garagestatus = true
                                    end
                                end
                            end
                            if garagestatus then
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

    Citizen.CreateThread(function()
        while true do
            local sleep = 2000
            local Player = PlayerPedId()
            local PlayerCoords = GetEntityCoords(Player)
            for k, v in pairs(Config.Houses) do
                local Distance = #(PlayerCoords - Config.Houses[k].ManagementCoords)
                local playeridentity = ""
                if Distance < 3 then
                    sleep = 4
                    if Config.Houses[k].Owner ~= "" or Config.Houses[k].RentOwner.owner ~= "" then
                        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
                            playeridentity = frameworkObject.Functions.GetPlayerData().citizenid
                        else
                            playeridentity = frameworkObject.PlayerData.identifier
                        end
                        if type(Config.Houses[k].RentOwner) == "table" then
                            for a, b in pairs(Config.Houses[k].RentOwner) do                          
                                if a == "owner" then
                                    if tostring(b) == tostring(playeridentity) then
                                        DrawText3D("~INPUT_PICKUP~ - Open Management", Config.Houses[k].ManagementCoords)
                                        if IsControlJustReleased(0, 38) then
                                            if Config.Houses[k].Owner == "" then
                                                OpenManagementMenu(k, true)
                                            else
                                                OpenManagementMenu(k, false)
                                            end
                                        end
                                    end
                                end
                            end
                        else
                            if tostring(Config.Houses[k].Owner) == tostring(playeridentity) then
                                DrawText3D("~INPUT_PICKUP~ - Open Management", Config.Houses[k].ManagementCoords)
                                if IsControlJustReleased(0, 38) then
                                    OpenManagementMenu(k, false)
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
        houseimg = Config.Houses[k].HouseInformation.housebackgroundimg
    })
    SetNuiFocus(true, true)
end

function GetNearbyPlayers(k)
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local player, distance = frameworkObject.Functions.GetClosestPlayer()
        if player ~= -1 and distance <= 2.0 then
            local data = Callback('real-house:GetClosestPlayersInformation', {player = GetPlayerServerId(player), house = k})
            return data
        end
    else
        local player, distance = frameworkObject.Game.GetClosestPlayer()
        local data = Callback('real-house:GetClosestPlayersInformation', GetPlayerServerId(player))
        SendNUIMessage({
            action = 'LoadNearbyPlayers',
            data = data
        })
    end
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
        house = k
    })
    SetNuiFocus(true, true)
end

function OpenManagementMenu(k, status)
    local data = Callback('real-house:GetHouseData', k)
    SendNUIMessage({
        action = 'OpenManagement',
        name = data.name,
        playerbank = data.playerbank,
        playercash = data.playercash,
        pp = data.pp,
        friends = data.friends,
        allowrent = data.rentstatus,
        rentprice = data.rentprice,
        renttime = data.renttime,
        nearbyplayers = GetNearbyPlayers(k),
        house = k,
        houseimg = Config.Houses[k].HouseInformation.housemanagementimg,
        housesecondimg = Config.Houses[k].HouseInformation.rentsettingsbackground,
        sellhouseprice = Config.Houses[k].PurchasePrice / Config.SellHouseRatio,
        copykeyprice = Config.CopyKeyPrice,
        rented = status,
        rentedtime = data.rentdate,
        adddayprice = Config.AddDayPrice,
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
            if Distance < 2 then
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

RegisterCommand("CreateKey", function()
    local Player = PlayerPedId()
    local PlayerCoords = GetEntityCoords(Player)
    local playeridentity = ""
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        playeridentity = frameworkObject.Functions.GetPlayerData().citizenid
    else
        playeridentity = frameworkObject.PlayerData.identifier
    end
    for k, v in pairs(Config.Houses) do
        for a, b in pairs(v.DoorCoords) do
            local Distance = #(PlayerCoords - b.Coords)
            if Distance < 2 then
                if type(v.RentOwner) ~= "table" then
                    if v.Owner == playeridentity then
                        TriggerServerEvent('real-house:GetHouseKeys', k)
                    else
                        print("You are not owner of this house!")
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('real-house:Client:ChangeDoorStatus', function(house, status, number)
    DoorSystemSetDoorState(number, status.status, 0, 1)
    SetStateOfClosestDoorOfType(number, house.DoorCoords, 1, 0.0, true)
end)

RegisterNetEvent('real-house:Event:OpenManagementMenu', function(k)
    OpenManagementMenu(k, false)
end)

RegisterNetEvent('real-house:Client:SendSellRequest', function(data)
    SendNUIMessage({
        action = 'SellRequest',
        data = data
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('real-house:Client:SendRentRequest', function(data)
    SendNUIMessage({
        action = 'RentRequest',
        data = data
    })
    SetNuiFocus(true, true)
end)

RegisterNetEvent('real-house:TeleportPlayerOutside', function(house)
    local Coords = Config.Houses[house].HouseCoords
    SetEntityCoords(PlayerPedId(), Coords.x, Coords.y, Coords.z, true, false, true, false)
end)

RegisterNUICallback('BuyNormalHouse', function(data)
    TriggerServerEvent('real-house:BuyHouse', data)
end)

RegisterNUICallback('RentHouse', function(data)
    TriggerServerEvent('real-house:RentHouse', data)
end)

RegisterNUICallback('SaveAllowrentSettings', function(data)
    TriggerServerEvent('real-house:SaveAllowrentSettings', data)
end)

RegisterNUICallback('AddFriend', function(data)
    TriggerServerEvent('real-house:AddFriend', data)
end)

RegisterNUICallback('RemoveFriend', function(data)
    TriggerServerEvent('real-house:RemoveFriend', data)
end)

RegisterNUICallback('BuyRentedHouse', function(data)
    TriggerServerEvent('real-house:BuyRentedHouse', data)
end)

RegisterNUICallback('SendSellRequest', function(data)
    TriggerServerEvent('real-house:SendSellRequest', data)
end)

RegisterNUICallback('AcceptedSellRequest', function(data)
    TriggerServerEvent('real-house:AcceptedSellRequest', data)
end)

RegisterNUICallback('RequestRejected', function(data)
    TriggerServerEvent('real-house:RequestRejected', data)
end)

RegisterNUICallback('SendRentRequest', function(data)
    TriggerServerEvent('real-house:SendRentRequest', data)
end)

RegisterNUICallback('AcceptedRentRequest', function(data)
    TriggerServerEvent('real-house:AcceptedRentRequest', data)
end)

RegisterNUICallback('GetOutVehicle', function(data)
    local cb = Callback('real-house:GetOutVehicle', data.plate)
    if cb then
        RequestModel(cb.model)
        while not HasModelLoaded(cb.model) do
            Wait(1000)
        end
        for a, b in pairs(Config.Houses[data.house].Garages.Coords) do
            local Car = CreateVehicle(cb.model, b.SpawnCoords, true, true)
            SetVehicleLivery(Car, cb.livery)
            SetVehicleProps(Car, cb)
            if cb.tint then
                SetVehicleModKit(Car, 0)
                SetVehicleWindowTint(Car, cb.tint)
            end
            SetPedIntoVehicle(PlayerPedId(), Car, -1)
            TriggerServerEvent('real-house:UpdatePlayerGarage', 0, data.plate)
            print("Successfully got the car")
            if Config.GiveVehicleKeys then
                GiveVehicleKeys(data.plate, Car)
            end
        end
    end
    SetNuiFocus(false, false)
end)

RegisterNUICallback('AddSlot', function(data)
    TriggerServerEvent('real-house:AddGarageSlot', data)
end)

RegisterNUICallback('SellHouse', function(data)
    TriggerServerEvent('real-house:SellHouse', data)
end)

RegisterNUICallback('CopyHouseKeys', function(data)
    TriggerServerEvent('real-house:CopyHouseKeys', tonumber(data))
end)

RegisterNUICallback('ExtendTime', function(data)
    -- Extend time codes
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

function GetLocalTime()
    local time = GetGameTimer()
    local year = GetClockYear()
    local month = GetClockMonth()
    local day = GetClockDayOfMonth()
    return year, month, day
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