Config = {}
CodeReal = {}

Config.Framework = 'newqb' -- newesx, oldesx, newqb, oldqb
Config.MySQL = 'oxmysql' -- oxmysql, ghamattimysql, mysql-async | Don't forget to edit fxmanifest.lua
Config.Drawtext = 'qb-target' -- qb-target, drawtext

Config.Metadata = true -- If 'true', system will use metadata
Config.AllowToBuyMoreThanOne = true
Config.GiveRentSystem = true
Config.AllowBuyHouseWhenRented = true
Config.RentTime = 7 -- Days
Config.SendMailToPlayer = false
CodeReal.Bill = 'SwedenEstate'

Config.CheckRentStatus = {
    Hour = 22,
    Minute = 37
}

Config.Houses = {
    [1] = {
        Owner = "",
        KeyData = "",
        MLO = false,
        Rented = false,
        RentOwner = "",
        HouseCoords = vector3(1323.5, -583.03, 73.25),
        ManagementCoords = vector3(1323.5, -583.03, 73.25),
        RentPrice = 100,
        PurchasePrice = 1000,
        AllowRent = false,
        
        HouseInformation = {
            HouseName = 'House 1',
            Description = 'Test Test',
        },

        Friends = {},

        Teleport = { -- Works if 'MLO = false'
            In = vector3(1, 1, 1),
            Out = vector3(1, 1, 1),
        },

        DoorCoords = { -- If you dont use MLO then this is not important!
            {DoorHash = 'v_ilev_fa_frontdoor', Coords = vector3(1323.41, -583.14, 73.25), LockStatus = true},
            {DoorHash = 'v_ilev_bk_door2', Coords = vector3(1316.24, -597.99, 73.25), LockStatus = true}
        },

        Stash = {
            {Coords = vector3(1, 1, 1), Lock = true}
        },

        Wardrobe = {
            {Coords =  vector3(1, 1, 1)}
        },
        
        Garages = {
            AllowGarage = true,
            AvailableSlot = 2,
            MaxSlot = 20,
            GarageSlotPrice = 1000,
            Distance = 10.0,

            Coords = {
                {SpawnCoords = vector3(1, 1, 1), OpenGarageCoords = vector3(1, 1, 1)}
            }
        },
    }
}