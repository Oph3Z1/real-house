function GetFrameworkObject()
    local object = nil
    if Config.Framework == "esx" then
        while object == nil do
            if Config.NewESX then
                object = exports['es_extended']:getSharedObject()
            else
                TriggerEvent('esx:getSharedObject', function(obj)object = obj end)
            end
            Citizen.Wait(0)
        end
    end
    if Config.Framework == "newqb" then
        object = exports["qb-core"]:GetCoreObject()
    end
    if Config.Framework == "oldqb" then
        while object == nil do
            TriggerEvent('QBCore:GetObject', function(obj)object = obj end)
            Citizen.Wait(200)
        end
    end
    return object
end