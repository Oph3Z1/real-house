Config = {}
CodeReal = {}

Config.Framework = 'newesx' -- newesx, oldesx, newqb, oldqb
Config.MySQL = 'oxmysql' -- oxmysql, ghamattimysql, mysql-async | Don't forget to edit fxmanifest.lua

Config.AllowToBuyMoreThanOne = true -- If true, players can buy more than 1 house.
Config.GiveRentSystem = true -- If you want to enable a system where players can rent houses to each other, set this true.
Config.RentTime = 7 -- Days | The time period initially given when the player rents the house
Config.SendMailToPlayer = false -- If true, it sends an email to the player's phone if the player's lease has expired. | If you set 'true', then you need to edit config/server_config.lua
CodeReal.Bill = 'SwedenEstate' -- You can change it however you like, but only use English characters to avoid problems!
Config.SellHouseRatio = 2 -- 2 => 50% | Since 2 is written here, if the player sells the house, system will divide the normal price of the house by 2 and give it to the player.
Config.CopyKeyPrice = 100 -- The fee for copying the key to the house.
Config.AddDayPrice = 100 -- If 100, when player want to extend rent time, 1 day = 100$

Config.GiveVehicleKeys = true -- A system of giving keys to the player after taking cars out from the garage
Config.VehicleKeySystem = 'qb-vehiclekeys' -- qb-vehiclekeys, qs-vehiclekeys, wasabi-carlock, cd_garage, custom | If you choose 'custom' you need to edit config/client_config.lua

Config.CheckVehicleOwner = true -- If there is a friend of the house and this option is true, then when a player takes the car out of the garage, system checks whether the car belongs to the person who tried to take it out. But if it is false, it takes the car out of the garage directly.

Config.WardrobeSystem = 'qb-clothing' -- qb-clothing, fivem-appearance, illenium-appearance, esx_skin, custom | If you choose 'custom' you need to edit config/client_config.lua

Config.InventorySystem = 'ox_inventory' -- qb-inventory, ox_inventory
Config.HouseStashSlot = 50 -- Stash slot amount
Config.HouseStashWeight = 250 -- Stash weight limit

Config.CheckRentStatus = { -- Check time for rented houses. For example, if you write 00:00 here, it will check every day at 00:00.
    Hour = 00,
    Minute = 42
}

Config.Notification = function(msg, type, server, src)
    if server then
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            TriggerClientEvent('QBCore:Notify', src, msg, type, 4000)
        else
            TriggerClientEvent('esx:showNotification', src, msg)
        end
    else
        if Config.Framework == 'newqb' or Config.Framework == 'oldqb' then
            TriggerEvent('QBCore:Notify', msg, type, 4000)
        else
            TriggerEvent('esx:showNotification', msg)
        end
    end
end

Config.Houses = {
    [1] = {
        Owner = "", -- dont touch this
        KeyData = "", -- dont touch this
        Rented = false, -- dont touch this
        RentOwner = "", -- dont touch this
        HouseCoords = vector3(1301.1, -574.11, 71.73), -- House Coords | E press location to buy/rent house ui
        ManagementCoords = vector3(1296.61, -577.73, 71.74), -- House management coords
        RentPrice = 300, -- Rent price
        PurchasePrice = 1500, -- Purchase price
        AllowRent = { -- dont touch this
            status = false,
            price = 0,
            time = 0
        },
        
        HouseInformation = {
            HouseName = 'House 1', -- House Name
            Description = 'Test Test', -- House description
            housemanagementimg = 'https://cdn.discordapp.com/attachments/992496697890570352/1203362685073227848/management-housebg.png?ex=65d0d1d5&is=65be5cd5&hm=a9e1c7b272b736992e1f5c6a2cd91862406c2bcf04e92c25694f3e1103d8a422&',
            housebackgroundimg = 'https://cdn.discordapp.com/attachments/992496697890570352/1203363116130377788/house-background.png?ex=65d0d23c&is=65be5d3c&hm=883891177e12e5d7aa5ab88f12858f482956de82e7ae915849dceb4ea713b8ba&',
            rentsettingsbackground = 'https://cdn.discordapp.com/attachments/992496697890570352/1203363161869131776/rent-settings-background.png?ex=65d0d247&is=65be5d47&hm=b1c8436afdb23c5110317a384c339b7a33d16da1d9554de705f8ffbe7e5d56ff&',
        },

        Friends = {},

        DoorCoords = { -- If you dont use MLO then this is not important!
            {DoorHash = 'v_ilev_fa_frontdoor', Coords = vector3(1300.3, -574.5, 71.83), LockStatus = true}, -- Dont touch LockStatus
            {DoorHash = 'v_ilev_bk_door2', Coords = vector3(1316.24, -597.99, 73.25), LockStatus = true}
        },

        Stash = {
            {Coords = vector3(1300.12, -586.03, 75.11), Lock = true}, -- Dont touch Lock
        },

        Wardrobe = {
            {Coords =  vector3(1298.09, -575.86, 75.06)}
        },
        
        Garages = {
            AllowGarage = true, -- If you want to use garage system, dont touch
            AvailableSlot = 2, -- Number of slots that will be active at startup
            MaxSlot = 20, -- Maximum slot limit
            GarageSlotPrice = 1000, -- price per slot
            Distance = 4, -- dont touch if you dont know what you are doing

            Coords = {
                {SpawnCoords = vector4(1293.35, -575.18, 71.02, 343.05), OpenGarageCoords = vector3(1291.21, -581.91, 71.74)}
            }
        },
    },

    [2] = {
        Owner = "",
        KeyData = "",
        Rented = false,
        RentOwner = "",
        HouseCoords = vector3(1323.5, -583.03, 73.25),
        ManagementCoords = vector3(1318.54, -585.92, 73.25),
        RentPrice = 100,
        PurchasePrice = 1000,
        AllowRent = {
            status = false,
            price = 0,
            time = 0
        },
        
        HouseInformation = {
            HouseName = 'House 2',
            Description = 'Test Test 2',
            housemanagementimg = 'https://cdn.discordapp.com/attachments/992496697890570352/1203362685073227848/management-housebg.png?ex=65d0d1d5&is=65be5cd5&hm=a9e1c7b272b736992e1f5c6a2cd91862406c2bcf04e92c25694f3e1103d8a422&',
            housebackgroundimg = 'https://cdn.discordapp.com/attachments/992496697890570352/1203363116130377788/house-background.png?ex=65d0d23c&is=65be5d3c&hm=883891177e12e5d7aa5ab88f12858f482956de82e7ae915849dceb4ea713b8ba&',
            rentsettingsbackground = 'https://cdn.discordapp.com/attachments/992496697890570352/1203363161869131776/rent-settings-background.png?ex=65d0d247&is=65be5d47&hm=b1c8436afdb23c5110317a384c339b7a33d16da1d9554de705f8ffbe7e5d56ff&',
        },

        Friends = {},

        DoorCoords = {
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
    },
}