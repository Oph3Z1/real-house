frameworkObject = nil
local DoorStatus = {}

Citizen.CreateThread(function()
    frameworkObject, Config.Framework = GetCore()
    Citizen.Wait(1500)
    LoadFramework()
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
            local rentowner = json.decode(data[1].rentowner)
            if rentowner then
                local convertdate = os.date('%d/%m/%Y', rentowner.date)
                DataTable = {
                    houseinfo = houseinfo,
                    houseprice = houseprice,
                    houserenprice = houserenprice,
                    playername = PlayerName,
                    pfp = DiscordProfilePicture,
                    playerbank = PlayerBank,
                    playercash = PlayerCash,
                    rentername = rentowner.name,
                    renterpp = rentowner.pp,
                    rentedtime = convertdate
                }
            else 
                DataTable = {
                    houseinfo = houseinfo,
                    houseprice = houseprice,
                    houserenprice = houserenprice,
                    playername = PlayerName,
                    pfp = DiscordProfilePicture,
                    playerbank = PlayerBank,
                    playercash = PlayerCash,
                    rentername = "",
                    renterpp = "",
                    rentedtime = ""
                }
            end
            cb(DataTable)
        else
            print("Data not found")
        end
    end)

    RegisterCallback('real-house:DoorStatus', function(source, cb)
        cb(DoorStatus)
    end)

    RegisterCallback('real-house:CheckVehicleOwner', function(source, cb, plate)
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            local Player = frameworkObject.Functions.GetPlayer(source)
            local PlayerVehicle = ExecuteSql("SELECT * FROM `player_vehicles` WHERE plate = '"..plate.."'")
            if #PlayerVehicle > 0 then
                if Player.PlayerData.citizenid == PlayerVehicle[1].citizenid then
                    cb(true)
                else
                    cb(false)
                end
            else
                cb(false)
            end
        else
            -- ESX codes
        end
    end)

    RegisterCallback('real-house:CheckGarageSlot', function(source, cb, house)
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            local slot = ExecuteSql("SELECT * FROM `player_vehicles` WHERE garage = '"..house.."'")
            if #slot >= Config.Houses[house].Garages.AvailableSlot then
                cb(true)
            else
                cb(false)
            end
        else
            -- ESX codes
        end
    end)

    RegisterCallback('real-house:GetGarageVehicles', function(source, cb, house)
        local src = source
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            local data = ExecuteSql("SELECT * FROM `player_vehicles` WHERE garage = '"..house.."'")
            local DiscordProfilePicture = GetDiscordAvatar(src)
            local PlayerName = GetName(src)
            local PlayerBank = GetPlayerMoneyOnline(src, 'cash')
            local PlayerCash = GetPlayerMoneyOnline(src, 'bank')
            local DataTable = {}
            if #data > 0 then
                DataTable = {
                    name = PlayerName,
                    pp = DiscordProfilePicture,
                    playerbank = PlayerBank,
                    playercash = PlayerCash,
                    data = data
                }
                cb(DataTable)
            else
                DataTable = {
                    name = PlayerName,
                    pp = DiscordProfilePicture,
                    playerbank = PlayerBank,
                    playercash = PlayerCash,
                    data = {}
                }
                cb(DataTable)
            end
        else
            -- ESX codes
        end
    end) 

    RegisterCallback('real-house:GetOutVehicle', function(source, cb, data)
        local src = source
        local identifier = GetIdentifier(src)
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            local database = ExecuteSql("SELECT * FROM `player_vehicles` WHERE `plate` = '"..data.."'")
            if #database >= 1 then
                local citizenid = json.encode(database[1].citizenid)
                if Config.CheckVehicleOwner then
                    if citizenid == identifier then
                        cb(json.decode(database[1].mods))
                    else
                        print("This is not your vehicle")
                    end
                else
                    cb(json.decode(database[1].mods))
                end
            else
                print("Data not found")
            end
        else
            -- ESX codes
        end
    end)

    RegisterCallback('real-house:GetHouseData', function(source, cb, house)
        local src = source
        local data = ExecuteSql("SELECT * FROM `real_house` WHERE id = '"..house.."'")
        local DiscordProfilePicture = GetDiscordAvatar(src)
        local PlayerName = GetName(src)
        local PlayerBank = GetPlayerMoneyOnline(src, 'cash')
        local PlayerCash = GetPlayerMoneyOnline(src, 'bank')
        local allowrent = json.decode(data[1].allowrent)
        if #data > 0 then
            local SendTable = {
                name = PlayerName,
                playerbank = PlayerBank,
                playercash = PlayerCash,
                pp = DiscordProfilePicture,
                friends = json.decode(data[1].friends),
                rentstatus = allowrent.status,
                rentprice = allowrent.price,
                renttime = allowrent.time,
            }
            cb(SendTable)
        end
    end)

    RegisterCallback('real-house:GetClosestPlayersInformation', function(source, cb, v)
        local src = v.player
        local DiscordProfilePicture = GetDiscordAvatar(src)
        local PlayerName = GetName(src)
        local Identifier = GetIdentifier(src)
        local SendData = {}
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            local data = ExecuteSql("SELECT `friends` FROM `real_house` WHERE id = '"..v.house.."'")
            if #data > 0 then
                local Player = frameworkObject.Functions.GetPlayer(src)
                if Player then
                    for k, v in pairs(data) do
                        local info = json.decode(v.friends)
                        if next(info) then
                            for a, b in pairs(info) do
                                if b.owner ~= Identifier then
                                    table.insert(SendData, {
                                        id = src,
                                        name = PlayerName,
                                        pp = DiscordProfilePicture,
                                    })
                                end
                            end
                        else
                            table.insert(SendData, {
                                id = src,
                                name = PlayerName,
                                pp = DiscordProfilePicture,
                            })
                        end
                    end                    
                    cb(SendData)
                end
            end
        else
            local data = ExecuteSql("SELECT `friends` FROM `real_house` WHERE id = '"..v.house.."'")
            if #data > 0 then
                local Player = frameworkObject.GetPlayerFromId(src)
                if Player then
                    for k, v in pairs(data) do
                        local info = json.decode(v.friends)
                        if next(info) then
                            for a, b in pairs(info) do
                                if b.owner ~= Identifier then
                                    table.insert(SendData, {
                                        id = src,
                                        name = PlayerName,
                                        pp = DiscordProfilePicture,
                                    })
                                end
                            end
                        else
                            table.insert(SendData, {
                                id = src,
                                name = PlayerName,
                                pp = DiscordProfilePicture,
                            })
                        end
                    end                    
                    cb(SendData)
                end
            end
        end
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
                                TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
                            else
                                ExecuteSql("UPDATE `real_house` SET `owner` = '"..Identifier.."' WHERE id = '"..data.."'")
                                Config.Houses[data].Owner = Identifier
                                if PlayerBank >= Config.Houses[data].PurchasePrice then
                                    Player.Functions.RemoveMoney('bank', Config.Houses[data].PurchasePrice)
                                elseif PlayerCash >= Config.Houses[data].PurchasePrice then
                                    Player.Functions.RemoveMoney('cash', Config.Houses[data].PurchasePrice)
                                end
                                TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
                            end
                        else
                            print("Not enough money")
                        end
                    end
                else
                    print("Data not found")
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
                            TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
                        else
                            ExecuteSql("UPDATE `real_house` SET `owner` = '"..Identifier.."' WHERE id = '"..data.."'")
                            Config.Houses[data].Owner = Identifier
                            if PlayerBank >= Config.Houses[data].PurchasePrice then
                                Player.Functions.RemoveMoney('bank', Config.Houses[data].PurchasePrice)
                            elseif PlayerCash >= Config.Houses[data].PurchasePrice then
                                Player.Functions.RemoveMoney('cash', Config.Houses[data].PurchasePrice)
                            end
                            TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
                        end
                    else
                        print("Not enough money")
                    end
                end
            else
                print("Data not found")
            end
        end                    
    else
        -- ESX codes
    end
end)

RegisterNetEvent('real-house:RentHouse', function(data)
    local src = source
    local HouseData = ExecuteSql("SELECT * FROM `real_house` WHERE `id` = '"..data.."'")
    local Identifier = GetIdentifier(src)
    local PlayerBank = GetPlayerMoneyOnline(src, 'bank')
    local PlayerCash = GetPlayerMoneyOnline(src, 'cash')
    local DiscordProfilePicture = GetDiscordAvatar(src)
    local PlayerName = GetName(src)
    local RenterTable = {}

    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(src)
        if #HouseData > 0 then
            if HouseData[1].Owner ~= nil or HouseData[1].Owner ~= "" then
                if PlayerBank >= Config.Houses[data].RentPrice or PlayerCash >= Config.Houses[data].RentPrice then
                    if Config.Metadata then
                        local key = 'key_' ..math.random(10000, 99999)
                        ExecuteSql("UPDATE `real_house` SET `keydata` = '"..key.."' WHERE id = '"..data.."'")
                        local keydata = {
                            house = data,
                            keydata = key
                        }
                        Player.Functions.AddItem('housekeys', 1, false, keydata) 
                        RenterTable = {
                            owner = Identifier,
                            date = os.time() + (Config.RentTime * 24 * 60 * 60 * 1000),
                        }
                        Config.Houses[data].RentOwner = Identifier
                        Config.Houses[data].KeyData = key
                        ExecuteSql("UPDATE `real_house` SET `rentowner` = '"..json.encode(RenterTable).."' WHERE id = '"..data.."'")
                        if PlayerBank >= Config.Houses[data].PurchasePrice then
                            Player.Functions.RemoveMoney('bank', Config.Houses[data].PurchasePrice)
                        elseif PlayerCash >= Config.Houses[data].PurchasePrice then
                            Player.Functions.RemoveMoney('cash', Config.Houses[data].PurchasePrice)
                        end
                        TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
                    else
                    end
                else
                    print("Not enough money")
                end
            end
        else
            print("Data not found")
        end
    else
        -- ESX codes
    end
end)

RegisterNetEvent('real-house:ChangeDoorStatus', function(housevalue, status, number)
    DoorStatus[housevalue] = {status = status}
    TriggerClientEvent('real-house:Client:ChangeDoorStatus', -1, housevalue, DoorStatus[housevalue], number)
    if status == 1 then
        DoorStatus[housevalue] = nil
    end
end)

function CheckRentStatus()
    local GetPlayerBill = ExecuteSql("SELECT * FROM `phone_invoices` WHERE society = '"..CodeReal.Bill.."'")
    if #GetPlayerBill > 0 then
        local PlayerHouse = ExecuteSql("SELECT * FROM `real_house` WHERE id = '"..GetPlayerBill[1].sendercitizenid.."'")
        if #PlayerHouse > 0 then
            local Owner = PlayerHouse[1].owner
            local RentOwner = PlayerHouse[1].rentowner.owner
            if Config.SendMailToPlayer then
                TriggerEvent('real-house:SendMailToPlayerHouseExpired', RentOwner)
            end
            if Owner then
                if Config.SendMailToPlayer then
                    TriggerEvent('real-house:SendMailToRealOwner', Owner)
                end
                ExecuteSql("UPDATE `real_house` SET `keydata` = '', `rentowner` = '', `payment` = '"..tonumber(0).."', `friends` = '{}' WHERE id = '"..GetPlayerBill[1].sendercitizenid.."'")
                local House = tonumber(GetPlayerBill[1].sendercitizenid)
                Config.Houses[House].KeyData = ""
                Config.Houses[House].RentOwner = ""
                Config.Houses[House].Friends = {}
                TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
            else
                local allowrenttable = {
                    status = false,
                    price = 0,
                    time = 0
                }
                ExecuteSql("UPDATE `real_house` SET `owner` = '', `keydata` = '', `payment` = '"..tonumber(0).."', `rentowner` = '', `allowrent` = '"..json.encode(allowrenttable).."', `friends` = '{}' WHERE id = '"..GetPlayerBill[1].sendercitizenid.."'")
                local House = tonumber(GetPlayerBill[1].sendercitizenid)
                Config.Houses[House].Owner = ""
                Config.Houses[House].KeyData = ""
                Config.Houses[House].RentOwner = ""
                Config.Houses[House].Friends = {}
                TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded) 
            end
        end
    else
        print("Data not found")
    end
end

RegisterNetEvent('real-house:CheckPayment', function()
    local Houses = ExecuteSql("SELECT * FROM `real_house`")
    if #Houses > 0 then
        for k, v in pairs(Houses) do
            local rentowner = v.rentowner
            if rentowner ~= "" then
                local jsonknk = json.decode(rentowner)
                if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
                    local Renter = frameworkObject.Functions.GetPlayerByCitizenId(tostring(jsonknk.owner))
                    if v.payment == 0 then
                        local todayStart = os.time({year=os.date("%Y"), month=os.date("%m"), day=os.date("%d")})
                        if tonumber(jsonknk.date) >= todayStart then
                            ExecuteSql("UPDATE `real_house` SET payment = '"..tonumber(1).."' WHERE id = '"..v.id.."'")
                            ExecuteSql("INSERT INTO `phone_invoices` (citizenid, amount, society, sender, sendercitizenid) VALUES ('"..Renter.PlayerData.citizenid.."', '"..Config.Houses[v.id].RentPrice.."', '"..CodeReal.Bill.."', '"..CodeReal.Bill.."', '"..v.id.."')")
                            TriggerEvent('real-house:RefreshPhone', Renter.PlayerData.source)
                        end
                    end
                else
                    local Renter = frameworkObject.GetPlayerFromIdentifier(tostring(jsonknk.owner))
                    if v.payment == 0 then
                        if (os.time() - tonumber(jsonknk.date)) > (Config.RentTime * 24 * 60 * 60) then
                            ExecuteSql("UPDATE `real_house` SET payment = '"..tonumber(1).."' WHERE id = '"..v.id.."'")
                            ExecuteSql("INSERT INTO `billing` (identifier, sender, target_type, target, label, amount) VALUES ('"..Renter.getIdentifier().."', '"..CodeReal.Bill.."', 'player', '"..Renter.getIdentifier().."', 'HouseBill', '"..Config.Houses[v.id].RentPrice.."')")
                        end
                    end
                end
            end
        end
    else
        print("Data not found")
    end
end)

RegisterNetEvent('real-house:PutVehicleToGarage', function(vehicle, house)
    local src = source
    local PlayerName = GetName(src)
    local pfp = GetDiscordAvatar(src)
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local data = ExecuteSql("SELECT * FROM `real_house` WHERE `id` = '"..house.."'")
        if #data > 0 then
            ExecuteSql("UPDATE `player_vehicles` SET `garage` = '"..house.."', `mods` = '"..json.encode(vehicle).."', `state` = '"..tonumber(1).."', `ownername` = '"..PlayerName.."', `ownerpfp` = '"..pfp.."' WHERE plate = '"..vehicle.plate.."'")
        else
            print("Data not found")
        end
    else
        -- ESX codes
    end
end)

RegisterNetEvent('real-house:UpdatePlayerGarage', function(index, plate)
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        ExecuteSql("UPDATE `player_vehicles` SET `state` = '"..tonumber(index).."', garage = 'null' WHERE plate = '"..plate.."'")
    else
        -- ESX codes
    end
end)

RegisterNetEvent('real-house:AddGarageSlot', function(data)
    local src = source
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(src)
        local PlayerCash = Player.PlayerData.money.cash
        local PlayerBank = Player.PlayerData.money.bank
        if Config.Houses[data.house].Garages.AvailableSlot <= Config.Houses[data.house].Garages.MaxSlot and tonumber(data.slot) > 0 then
            local database = ExecuteSql("SELECT `houseinfo` FROM `real_house` WHERE id = '"..tonumber(data.house).."'")
            if #database > 0 then
                if data.type == 'cash' then
                    if tonumber(PlayerCash) >= tonumber(data.price) then
                        local slot = json.decode(database[1].houseinfo)
                        Config.Houses[data.house].Garages.AvailableSlot += data.slot
                        slot.AvailableSlot += tonumber(data.slot)
                        ExecuteSql("UPDATE `real_house` SET `houseinfo` = '"..json.encode(slot).."' WHERE id = '"..tonumber(data.house).."'")
                        TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
                        Player.Functions.RemoveMoney('cash', tonumber(data.price))
                    else
                        print("Not enough money")
                    end
                else
                    if tonumber(PlayerBank) >= tonumber(data.price) then
                        local slot = json.decode(database[1].houseinfo)
                        Config.Houses[data.house].Garages.AvailableSlot += data.slot
                        slot.AvailableSlot += tonumber(data.slot)
                        ExecuteSql("UPDATE `real_house` SET `houseinfo` = '"..json.encode(slot).."' WHERE id = '"..tonumber(data.house).."'")
                        TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
                        Player.Functions.RemoveMoney('bank', tonumber(data.price))
                    else
                        print("Not enough money")
                    end
                end
            else
                print("Data not found")
            end
        else
            print("You'r slot is max")
        end
    else
        local Player = frameworkObject.GetPlayerFromId(src)
        local PlayerCash = Player.getMoney()
        local PlayerBank = Player.getAccount("bank").amount
        if Config.Houses[data.house].Garages.AvailableSlot <= Config.Houses[data.house].Garages.MaxSlot and tonumber(data.slot) > 0 then
            local database = ExecuteSql("SELECT `houseinfo` FROM `real_house` WHERE id = '"..tonumber(data.house).."'")
            if #database > 0 then
                if data.type == 'cash' then
                    if tonumber(PlayerCash) >= tonumber(data.price) then
                        local slot = json.decode(database[1].houseinfo)
                        Config.Houses[data.house].Garages.AvailableSlot += data.slot
                        slot.AvailableSlot += tonumber(data.slot)
                        ExecuteSql("UPDATE `real_house` SET `houseinfo` = '"..json.encode(slot).."' WHERE id = '"..tonumber(data.house).."'")
                        TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
                        Player.RemoveMoney(tonumber(data.price))
                    else
                        print("Not enough money")
                    end
                else
                    if tonumber(PlayerBank) >= tonumber(data.price) then
                        local slot = json.decode(database[1].houseinfo)
                        Config.Houses[data.house].Garages.AvailableSlot += data.slot
                        slot.AvailableSlot += tonumber(data.slot)
                        ExecuteSql("UPDATE `real_house` SET `houseinfo` = '"..json.encode(slot).."' WHERE id = '"..tonumber(data.house).."'")
                        TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
                        Player.removeAccountMoney("bank", tonumber(data.price))
                    else
                        print("Not enough money")
                    end
                end
            else
                print("Data not found")
            end
        else
            print("You'r slot is max")
        end
    end
end)

RegisterNetEvent('real-house:SaveAllowrentSettings', function(cb)
    local data = ExecuteSql("SELECT `allowrent` FROM `real_house` WHERE id = '"..tonumber(cb.house).."'")
    if #data > 0 then
        local allowrent = json.decode(data[1].allowrent)
        allowrent.status = cb.status
        allowrent.price = cb.price
        allowrent.time = cb.time
        ExecuteSql("UPDATE `real_house` SET `allowrent` = '"..json.encode(allowrent).."' WHERE id = '"..tonumber(cb.house).."'")
    end
end)

RegisterNetEvent('real-house:AddFriend', function(cb)
    local src = source
    local data = ExecuteSql("SELECT * FROM `real_house` WHERE id = '"..tonumber(cb.house).."'")
    if #data > 0 then
        local friendstable = json.decode(data[1].friends)
        local ExecuteTable = {
            owner = GetIdentifier(cb.playerid),
            name = cb.playername,
            pp = cb.playerpp
        }
        table.insert(friendstable, ExecuteTable)
        table.insert(Config.Houses[tonumber(cb.house)].Friends, {
            owner = GetIdentifier(cb.playerid),
            name = cb.playername,
            pp = cb.playerpp
        })
        ExecuteSql("UPDATE `real_house` SET `friends` = '"..json.encode(friendstable).."' WHERE id = '"..tonumber(cb.house).."'")
        TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
        TriggerClientEvent('real-house:Event:OpenManagementMenu', src, tonumber(cb.house))
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            local Player = frameworkObject.Functions.GetPlayer(cb.playerid)
            local keydata = {
                house = tonumber(cb.house),
                keydata = Config.Houses[tonumber(cb.house)].KeyData
            }
            Player.Functions.AddItem('housekeys', 1, false, keydata) 
        else
            -- ESX codes
        end
    end
end)

RegisterNetEvent('real-house:RemoveFriend', function(cb)
    local src = source
    local data = ExecuteSql("SELECT * FROM `real_house` WHERE id = '"..tonumber(cb.house).."'")
    if #data > 0 then
        local friendstable = json.decode(data[1].friends)
        local kickedfriends = ""

        for k, v in pairs(friendstable) do
            if v.name == cb.player then
                table.remove(friendstable, k)
                table.remove(Config.Houses[tonumber(cb.house)].Friends, k)
                kickedfriends = v.owner
                break
            end
        end

        ExecuteSql("UPDATE `player_vehicles` SET `garage` = 'pillboxgarage', `state` = '"..tonumber(1).."', `ownername` = '', `ownerpfp` = '' WHERE citizenid = '"..kickedfriends.."'")
        ExecuteSql("UPDATE `real_house` SET `friends` = '"..json.encode(friendstable).."' WHERE id = '"..tonumber(cb.house).."'")
        TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
        TriggerClientEvent('real-house:Event:OpenManagementMenu', src, tonumber(cb.house))
    end
end)

RegisterNetEvent('real-house:SendSellRequest', function(data)
    local src = source
    local targetsrc = data.targetplayer
    local database = ExecuteSql("SELECT `houseinfo`, `owner` FROM `real_house` WHERE id = '"..tonumber(data.house).."'")
    if #database > 0 then
        local houseinfo = json.decode(database[1].houseinfo)
        local houseowner = database[1].owner
        if houseowner == GetIdentifier(src) then
            local SendData = {
                house = tonumber(data.house),
                housename = houseinfo.HouseName,
                player = src,
                playername = GetName(src),
                playerpp = GetDiscordAvatar(src),
                targetplayer = targetsrc,
                targetplayername = data.targetname,
                targetpp = data.targetpp,
                price = tonumber(data.price)
            }
            TriggerClientEvent('real-house:Client:SendSellRequest', targetsrc, SendData)
        else
            print("You are not owner of this house")
        end
    end
end)

RegisterNetEvent('real-house:AcceptedSellRequest', function(data)
    local database = ExecuteSql("SELECT * FROM `real_house` WHERE id = '"..tonumber(data.house).."'")
    if #database > 0 then
        local friends = json.decode(database[1].friends)
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            local Player = frameworkObject.Functions.GetPlayer(tonumber(data.player))
            local TargetPlayer = frameworkObject.Functions.GetPlayer(tonumber(data.targetplayer))
            local TargetPlayerMoney = GetPlayerMoneyOnline(tonumber(data.targetplayer), 'bank')
            if tonumber(TargetPlayerMoney) >= tonumber(data.price) then
                TargetPlayer.Functions.RemoveMoney('bank', tonumber(data.price))
                Player.Functions.AddMoney('bank', tonumber(data.price))
                local NewKey = 'key_' ..math.random(10000, 99999)
                if Player ~= nil and TargetPlayer ~= nil then
                    for k, v in pairs(friends) do
                        ExecuteSql("UPDATE `player_vehicles` SET `garage` = 'pillboxgarage', `state` = '"..tonumber(1).."', `ownername` = '', `ownerpfp` = '' WHERE citizenid = '"..v.owner.."'")
                    end
                    ExecuteSql("UPDATE `player_vehicles` SET `garage` = 'pillboxgarage', `state` = '"..tonumber(1).."', `ownername` = '', `ownerpfp` = '' WHERE citizenid = '"..GetIdentifier(tonumber(data.player)).."'")
                    ExecuteSql("UPDATE `real_house` SET `owner` = '"..GetIdentifier(tonumber(data.targetplayer)).."', `keydata` = '"..NewKey.."', `friends` = '{}' WHERE id = '"..tonumber(data.house).."'")
                    Config.Houses[tonumber(data.house)].Owner = GetIdentifier(tonumber(data.targetplayer))
                    Config.Houses[tonumber(data.house)].KeyData = NewKey
                    Config.Houses[tonumber(data.house)].Friends = {}
                    local keydata = {
                        house = tonumber(data.house),
                        keydata = NewKey
                    }
                    TargetPlayer.Functions.AddItem('housekeys', 1, false, keydata) 
                    TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
                    print("You are the new owner of this house")
                    print("Player accepted your request and you got the money. You are no longer owner of this house")
                end
            else
                print("Not enough money")
                print("Target player had no money")
            end
        else
            -- ESX codes
        end
    end
end)

RegisterNetEvent('real-house:RequestRejected', function(data)
    local sendersrc = tonumber(data.player)
    print("Send notify to sender about rejected request")
end)

function GetOfflinePlayerName(identifier)
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local data = ExecuteSql("SELECT `charinfo` FROM `players` WHERE `citizenid` = '"..identifier.."'")
        if data then
            local player = json.decode(data[1].charinfo)
            return player.firstname .. ' ' .. player.lastname
        else
            print("Data not found")
        end
    else
        local data = ExecuteSql("SELECT * FROM `users` WHERE `identifier` = '"..identifier.."'")
        if data then
            return data.firstname .. ' ' .. data.lastname
        else
            print("Data not found")
        end
    end
end

function GetName(source)
    if Config.Framework == "newesx" or Config.Framework == "oldesx" then
        local xPlayer = frameworkObject.GetPlayerFromId(tonumber(source))
        if xPlayer then
            return xPlayer.getName()
        else
            return "0"
        end
    else
        local Player = frameworkObject.Functions.GetPlayer(tonumber(source))
        if Player then
            return Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        else
            return "0"
        end
    end
end

function GetPlayerMoneyOnline(source, type)
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        local Player = frameworkObject.Functions.GetPlayer(tonumber(source))
        if type == 'bank' then
            return tonumber(Player.PlayerData.money.bank)
        elseif type == 'cash' then
            return tonumber(Player.PlayerData.money.cash)
        end
    elseif Config.Framework == 'newesx' or Config.Framework == 'oldesx' then
        local Player = frameworkObject.GetPlayerFromId(tonumber(source))
        if type == 'bank' then
            return tonumber(Player.getAccount('bank').money)
        elseif type == 'cash' then
            return tonumber(Player.getMoney())
        end
    end
end

function LoadFramework()
    if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
        frameworkObject.Functions.CreateUseableItem('housekeys', function(source, itemData)
            TriggerClientEvent('real-house:OpenHouseDoors', source, itemData.info.house, itemData.info.keydata)
            TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
        end)
    else
        -- ESX codes
    end
end

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

TriggerEvent('cron:runAt', Config.CheckRentStatus.Hour, Config.CheckRentStatus.Minute, CheckRentStatus)