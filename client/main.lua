frameworkObject = false

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
    while not frameworkObject do
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        local Player = PlayerPedId()
        local PlayerCoords = GetEntityCoords(Player)
        for k, v in pairs(Config.Houses) do
            if v.Owner == nil then
                local Distance = GetDistanceBetweenCoords(PlayerCoords, v.HouseCoords.x, v.HouseCoords.y, v.HouseCoords.z, true)
                if Distance < 2 then
                    sleep = 4
                    DrawText3D('Open House Menu', v.HouseCoords)
                    if IsControlJustReleased(0, 38) then
                        OpenBuyMenu(k)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function OpenBuyMenu(k)
    local data

    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        data = Callback('real-house:GetHouseAndPlayerData', k)
    else
        data = Callback('real-house:ESX:GetHouseAndPlayerData', k)
    end
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