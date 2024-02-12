Config = {}
CodeReal = {}

Config.Framework = 'newesx' -- newesx, oldesx, newqb, oldqb
Config.MySQL = 'oxmysql' -- oxmysql, ghamattimysql, mysql-async | Don't forget to edit fxmanifest.lua
Config.Drawtext = 'qb-target' -- qb-target, drawtext

Config.AllowToBuyMoreThanOne = true
Config.GiveRentSystem = true
Config.AllowBuyHouseWhenRented = true
Config.RentTime = 7 -- Days
Config.SendMailToPlayer = false
CodeReal.Bill = 'SwedenEstate'
Config.SellHouseRatio = 2 -- 2 => 50% | Since 2 is written here, if the player sells the house, system will divide the normal price of the house by 2 and give it to the player.
Config.CopyKeyPrice = 100
Config.AddDayPrice = 100 -- If 100, when player want to extend rent time, 1 day = 100$

Config.GiveVehicleKeys = true
Config.VehicleKeySystem = 'qb-vehiclekeys' -- qb-vehiclekeys, qs-vehiclekeys, wasabi-carlock, cd_garage, custom | If you choose 'custom' you need to edit config/client_config.lua

Config.CheckVehicleOwner = true

Config.WardrobeSystem = 'qb-clothing' -- qb-clothing, fivem-appearance, illenium-appearance, esx_skin, custom | If you choose 'custom' you need to edit config/client_config.lua

Config.InventorySystem = 'ox_inventory' -- qb-inventory, ox_inventory
Config.HouseStashSlot = 50
Config.HouseStashWeight = 250

Config.CheckRentStatus = {
    Hour = 00,
    Minute = 42
}

Config.Notification = function(msg, type, server, src)
    if server then
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            TriggerClientEvent('QBCore:Notify', src, msg, type, 3000)
        else
            TriggerClientEvent('esx:showNotification', src, msg)
        end
    else
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            TriggerEvent('QBCore:Notify', msg, type, 3000)
        else
            TriggerEvent('esx:showNotification', msg)
        end
    end
end

Config.Houses = {
    [1] = {
        Owner = "",
        KeyData = "",
        Rented = false,
        RentOwner = "",
        HouseCoords = vector3(1323.5, -583.03, 73.25),
        ManagementCoords = vector3(1318.54, -585.92, 73.25),
        RentPrice = 100,
        PurchasePrice = 1000,
        AllowRent = { -- dont touch this
            status = false,
            price = 0,
            time = 0
        },
        
        HouseInformation = {
            HouseName = 'House 1',
            Description = 'Test Test',
            housemanagementimg = 'https://cdn.discordapp.com/attachments/992496697890570352/1203362685073227848/management-housebg.png?ex=65d0d1d5&is=65be5cd5&hm=a9e1c7b272b736992e1f5c6a2cd91862406c2bcf04e92c25694f3e1103d8a422&',
            housebackgroundimg = 'https://cdn.discordapp.com/attachments/992496697890570352/1203363116130377788/house-background.png?ex=65d0d23c&is=65be5d3c&hm=883891177e12e5d7aa5ab88f12858f482956de82e7ae915849dceb4ea713b8ba&',
            rentsettingsbackground = 'https://cdn.discordapp.com/attachments/992496697890570352/1203363161869131776/rent-settings-background.png?ex=65d0d247&is=65be5d47&hm=b1c8436afdb23c5110317a384c339b7a33d16da1d9554de705f8ffbe7e5d56ff&',
        },

        Friends = {},

        DoorCoords = { -- If you dont use MLO then this is not important!
            {DoorHash = 'v_ilev_fa_frontdoor', Coords = vector3(1323.41, -583.14, 73.25), LockStatus = true},
            {DoorHash = 'v_ilev_bk_door2', Coords = vector3(1316.24, -597.99, 73.25), LockStatus = true}
        },

        Stash = {
            {Coords = vector3(1320.85, -594.69, 76.63), Lock = true},
        },

        Wardrobe = {
            {Coords =  vector3(1320.18, -584.32, 76.58)}
        },
        
        Garages = {
            AllowGarage = true,
            AvailableSlot = 2,
            MaxSlot = 20,
            GarageSlotPrice = 1000,
            Distance = 4,

            Coords = {
                {SpawnCoords = vector4(1315.69, -582.98, 72.43, 333.2), OpenGarageCoords = vector3(1312.9, -589.33, 72.93)}
            }
        },
    }
}