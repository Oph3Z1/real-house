frameworkObject = nil

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