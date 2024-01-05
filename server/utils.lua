function StartScript()
    for k,v in pairs(Config.Houses) do
        Def = {
            HouseInformation = {
                HouseName = v.HouseInformation.HouseName,
                HouseDescription = v.HouseInformation.Description,
                AvailableSlot = v.Garages.AvailableSlot,
            },

            Owner = v.Owner,
            KeyData = v.KeyData,
            RentOwner = v.RentOwner,
            AllowRent = v.AllowRent,
            Friends = {}
        }

        if Config.Mysql == 'mysql-async' or Config.Mysql == 'oxmysql' then
            local HouseData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_housev2` WHERE id = @id', {["@id"] = k})
        else if Config.Mysql == 'ghmattimysql' then
            local HouseData = exports.ghmattimysql:executeSync('SELECT * FROM `oph3z_housev2` WHERE id = @id', {["@id"] = k})
        else
            print("There is a problem with your MySQL. Please check 'Config.Mysql'")
        end

        if #HouseData == 0 then
            if Config.Mysql == 'mysql-async' or Config.Mysql == 'oxmysql' then
                MySQL.Async.execute('INSERT INTO `oph3z_housev2` (id, houseinformation, owner, keydata, rentowner, allowrent, friends) VALUES (@id, @houseinformation, @owner, @keydata, @rentowner, @allowrent, @friends)', {
                    ["@id"] = k,
                    ["@houseinformation"] = json.encode(Def.HouseInformation),
                    ["@owner"] = Def.Owner,
                    ["@keydata"] = Def.KeyData,
                    ["@rentowner"] = Def.RentOwner,
                    ["@allowrent"] = Def.AllowRent,
                    ["@friends"] = json.encode(Def.Friends)
                })
            else if Config.Mysql == 'ghmattimysql' then
                exports.ghmattimysql:execute('INSERT INTO `oph3z_housev2` (id, houseinformation, owner, keydata, rentowner, allowrent, friends) VALUES (@id, @houseinformation, @owner, @keydata, @rentowner, @allowrent, @friends)', {
                    ["@id"] = k,
                    ["@houseinformation"] = json.encode(Def.HouseInformation),
                    ["@owner"] = Def.Owner,
                    ["@keydata"] = Def.KeyData,
                    ["@rentowner"] = Def.RentOwner,
                    ["@allowrent"] = Def.AllowRent,
                    ["@friends"] = json.encode(Def.Friends)
                })
            end
        end
        LoadAllHouses()
    end
end

function RequestNewData()
    local source = source
    LoadAllHouses()
    TriggerClientEvent('oph3z-housev2:Update', source, Config.Houses, ScriptLoaded)
end

RegisterNetEvent("oph3z-housev2:ReqData", RequestNewData)

function LoadAllHouses()
    if Config.Mysql == 'mysql-async' or Config.Mysql == 'oxmysql' then
        local HouseData = MySQL.Sync.fetchAll('SELECT * FROM `oph3z_housev2`')
    else if Config.Mysql == 'ghmattimysql' then
        local HouseData = exports.ghmattimysql:executeSync('SELECT * FROM `oph3z_housev2`')
    else
        print("There is a problem with your MySQL. Please check 'Config.Mysql'")
    end

    for k,v in pairs(HouseData) do 
        local info = json.decode(v.houseinformation)
        Config.Houses[k].Owner = v.owner
        Config.Houses[k].KeyData = v.keydata
        Config.Houses[k].RentOwner = v.rentowner
        Config.Houses[k].AllowRent = v.AllowRent
        Config.Houses[k].Friends = json.decode(v.friends)
        Config.Houses[k].HouseInformation.HouseName = info.HouseName
        Config.Houses[k].HouseInformation.Description = info.Description
        Config.Houses[k].Garages.AvailableSlot = info.AvailableSlot
    end
    ScriptLoaded = true
end

Citizen.CreateThread(StartScript)