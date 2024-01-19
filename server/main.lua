frameworkObject = nil
local DoorStatus = {}

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
end)

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    RegisterCallback('real-house:GetHouseAndPlayerData', function(source, cb, k)
        local src = source
        local DiscordProfilePicture = GetDiscordAvatar(src)
        local PlayerName = GetName(src)
        local PlayerBank = GetPlayerMoneyOnline(src, 'cash')
        local PlayerCash = GetPlayerMoneyOnline(src, 'bank')
        local data = ExecuteSql("SELECT * FROM `real_house` WHERE `id` = '"..k.."'")
        local DataTable = {}
        if data then
            local houseinfo = json.decode(data[1].houseinfo)
            local houseprice = Config.Houses[k].PurchasePrice
            local houserenprice = Config.Houses[k].RentPrice
            DataTable = {
                houseinfo = houseinfo,
                houseprice = houseprice,
                houserenprice = houserenprice,
                playername = PlayerName,
                pfp = DiscordProfilePicture,
                playerbank = PlayerBank,
                playercash = PlayerCash,
            }
            cb(DataTable)
        else
            print("Data not found")
        end
    end)

    RegisterCallback('real-house:DoorStatus', function(source, cb)
        cb(DoorStatus)
    end)
end)

RegisterNetEvent('real-house:BuyHouse', function(data)
    local src = source
    local HouseData = ExecuteSql("SELECT * FROM `real_house` WHERE `id` = '"..data.."'")
    local Identifier = GetIdentifier(src)
    local PlayerBank = GetPlayerMoneyOnline(src, 'bank')
    local PlayerCash = GetPlayerMoneyOnline(src, 'cash')

    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(src)
        if not Config.AllowToBuyMoreThanOne then
            local CheckPlayerData = ExecuteSql("SELECT `owner` FROM `real_house` WHERE `owner` = '"..Identifier.."'")
            if #CheckPlayerData < 1 then
                if #HouseData > 0 then
                    if HouseData[1].Owner ~= nil or HouseData[1].Owner ~= "" then
                        if PlayerBank >= Config.Houses[data].PurchasePrice or PlayerCash >= Config.Houses[data].PurchasePrice then
                            if Config.Metadata then
                                local key = 'key_' ..math.random(10000, 99999)
                                ExecuteSql("UPDATE `real_house` SET `owner` = '"..Identifier.."', `keydata` = '"..key.."' WHERE id = '"..data.."'")
                                local keydata = {
                                    house = data,
                                    keydata = key
                                }
                                Player.Functions.AddItem('housekeys', 1, false, keydata) 
                                Config.Houses[data].Owner = Identifier
                                Config.Houses[data].KeyData = key
                                if PlayerBank >= Config.Houses[data].PurchasePrice then
                                    Player.Functions.RemoveMoney('bank', Config.Houses[data].PurchasePrice)
                                elseif PlayerCash >= Config.Houses[data].PurchasePrice then
                                    Player.Functions.RemoveMoney('cash', Config.Houses[data].PurchasePrice)
                                end
                                TriggerEvent('real-house:RefreshHouses')
                            else
                                ExecuteSql("UPDATE `real_house` SET `owner` = '"..Identifier.."' WHERE id = '"..data.."'")
                                Config.Houses[data].Owner = Identifier
                                if PlayerBank >= Config.Houses[data].PurchasePrice then
                                    Player.Functions.RemoveMoney('bank', Config.Houses[data].PurchasePrice)
                                elseif PlayerCash >= Config.Houses[data].PurchasePrice then
                                    Player.Functions.RemoveMoney('cash', Config.Houses[data].PurchasePrice)
                                end
                                TriggerEvent('real-house:RefreshHouses')
                            end
                        else
                            print("Not enough money")
                        end
                    end
                end
            end
        else
            if #HouseData > 0 then
                if HouseData[1].Owner ~= nil or HouseData[1].Owner ~= "" then
                    if PlayerBank >= Config.Houses[data].PurchasePrice or PlayerCash >= Config.Houses[data].PurchasePrice then
                        if Config.Metadata then
                            local key = 'key_' ..math.random(10000, 99999)
                            ExecuteSql("UPDATE `real_house` SET `owner` = '"..Identifier.."', `keydata` = '"..key.."' WHERE id = '"..data.."'")
                            local keydata = {
                                house = data,
                                keydata = key
                            }
                            Player.Functions.AddItem('housekeys', 1, false, keydata) 
                            Config.Houses[data].Owner = Identifier
                            Config.Houses[data].KeyData = key
                            if PlayerBank >= Config.Houses[data].PurchasePrice then
                                Player.Functions.RemoveMoney('bank', Config.Houses[data].PurchasePrice)
                            elseif PlayerCash >= Config.Houses[data].PurchasePrice then
                                Player.Functions.RemoveMoney('cash', Config.Houses[data].PurchasePrice)
                            end
                        else
                            ExecuteSql("UPDATE `real_house` SET `owner` = '"..Identifier.."' WHERE id = '"..data.."'")
                            Config.Houses[data].Owner = Identifier
                            if PlayerBank >= Config.Houses[data].PurchasePrice then
                                Player.Functions.RemoveMoney('bank', Config.Houses[data].PurchasePrice)
                            elseif PlayerCash >= Config.Houses[data].PurchasePrice then
                                Player.Functions.RemoveMoney('cash', Config.Houses[data].PurchasePrice)
                            end
                        end
                    else
                        print("Not enough money")
                    end
                end
            end
        end                    
    else
        -- ESX codes
    end
end)

function RegisterCallback(name, cbFunc, data)
    while not frameworkObject do
        Citizen.Wait(0)
    end
    if Config.Framework == 'newesx' or Config.Framework == 'oldesx' then
        frameworkObject.RegisterServerCallback(name, function(source, cb, data)
            cbFunc(source, cb, data)
        end)
    else
        frameworkObject.Functions.CreateCallback(name, function(source, cb, data)
            cbFunc(source, cb, data)
        end)
    end
end

function GetIdentifier(source)
    if Config.Framework == "newesx" or Config.Framework == "oldesx" then
        local xPlayer = frameworkObject.GetPlayerFromId(tonumber(source))

        if xPlayer then
            return xPlayer.getIdentifier()
        else
            return "0"
        end
    else
        local Player = frameworkObject.Functions.GetPlayer(tonumber(source))
        if Player then
            return Player.PlayerData.citizenid
        else
            return "0"
        end
    end
end

function ExecuteSql(query)
    local IsBusy = true
    local result = nil
    if Config.MySQL == "oxmysql" then
        if MySQL == nil then
            exports.oxmysql:execute(
                query,
                function(data)
                    result = data
                    IsBusy = false
                end
            )
        else
            MySQL.query(
                query,
                {},
                function(data)
                    result = data
                    IsBusy = false
                end
            )
        end
    elseif Config.MySQL == "ghmattimysql" then
        exports.ghmattimysql:execute(
            query,
            {},
            function(data)
                result = data
                IsBusy = false
            end
        )
    elseif Config.MySQL == "mysql-async" then
        MySQL.Async.fetchAll(
            query,
            {},
            function(data)
                result = data
                IsBusy = false
            end
        )
    end
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end