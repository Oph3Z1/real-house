ScriptLoaded = false

local function StartScript()
    while true do
        Wait(1000)
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent('real-house:ReqData')
            Wait(2000)
            break
        end
    end
end 

RegisterNetEvent('real-house:Update', function (table, loaded)
    Config.Houses = table
    ScriptLoaded = loaded
end)

Citizen.CreateThread(StartScript)