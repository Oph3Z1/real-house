ScriptLoaded = false

local function StartScript()
    while true do
        Wait(1000)
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent('oph3z-housev2:ReqData')
            Wait(2000)
            break
        end
    end
end 

RegisterNetEvent('oph3z-housev2:Update', function (table, loaded, table2)
    Config.Houses = table
    ScriptLoaded = loaded
    if not table2 then 
        return
    end
end)

Citizen.CreateThread(StartScript)