frameworkObject = false
MenuStatus = false

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
    while not frameworkObject do
        Citizen.Wait(0)
    end
    Citizen.Wait(1500)
    LoadDoorStatus()
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        local Player = PlayerPedId()
        local PlayerCoords = GetEntityCoords(Player)
        for k, v in pairs(Config.Houses) do
            if v.Owner == "" then
                local Distance = GetDistanceBetweenCoords(PlayerCoords, v.HouseCoords.x, v.HouseCoords.y, v.HouseCoords.z, true)
                if Distance < 2 then
                    if not MenuStatus then
                        sleep = 4
                        DrawText3D('~INPUT_PICKUP~ - Open House Menu', v.HouseCoords)
                        if IsControlJustReleased(0, 38) then
                            OpenBuyMenu(k)
                            MenuStatus = true
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function OpenBuyMenu(k)
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
        playercash = data.playercash
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
                        DoorStatusText = 'Closed'
                    else 
                        DoorStatusText = 'Opened'
                    end
                    if v.Owner ~= "" then
                        DrawText3D(DoorStatusText, b.Coords)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNUICallback('BuyNormalHouse', function(data)
    TriggerServerEvent('real-house:BuyHouse', data)
end)

RegisterNUICallback('CloseUI', function()
    SetNuiFocus(false, false)
    MenuStatus = false
end)

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