function GetCore()
    local object = nil
    local Framework = Config.Framework

    if Config.Framework == "oldesx" then
        local counter = 0
        while not object  do
            TriggerEvent('esx:getSharedObject', function(obj) object = obj end)
            counter = counter + 1
            if counter == 3 then
                break
            end
            Citizen.Wait(1000)
        end
        if not object then
            print("Framework is not selected in the config correctly if you're sure it's correct please check your events to get framework object")
        end
    end
    
    if Config.Framework == "newesx" then
        local counter = 0
        local status = pcall(function ()
            exports['es_extended']:getSharedObject()
        end)
        if status then        
            while not object do
                object = exports['es_extended']:getSharedObject()
                counter = counter + 1
                if counter == 3 then
                    break
                end
                Citizen.Wait(1000)
            end
        end
        if not object then
            print("Framework is not selected in the config correctly if you're sure it's correct please check your events to get framework object")
        end
    end

    if Config.Framework == "newqb" then
        local counter = 0
        local status = pcall(function ()
            exports["qb-core"]:GetCoreObject()
        end)
        if status then
            while not object  do
                object = exports["qb-core"]:GetCoreObject()
                counter = counter + 1
                if counter == 3 then
                    break
                end
                Citizen.Wait(1000)
            end
        end
        if not object then
            print("Framework is not selected in the config correctly if you're sure it's correct please check your events to get framework object")
        end
    end

    if Config.Framework == "oldqb" then
        local counter = 0

        while  not object do
            counter = counter + 1
            TriggerEvent('QBCore:GetObject', function(obj) object = obj end)
            if counter == 3 then
                break
            end
            Citizen.Wait(1000)
        end
        if not object then
            print("Framework is not selected in the config correctly if you're sure it's correct please check your events to get framework object")
        end
    end
    return object, Framework
end