Config = {}
Config.Framework = 'newqb' -- esx - oldqb - newqb
Config.NewESX = true -- true - false
Config.Mysql = 'oxmysql' -- mysql-async, ghmattimysql, oxmysql

Config.Metadata = true
Config.AllowRentWhenOwnerExist = true

Config.Houses = {
    [1] = {
        Owner = nil,
        KeyData = nil,
        MLO = false,
        Rented = false,
        RentOwner = nil,
        HouseCoords = vector3(),
        ManagementCoords = vector3(),
        RentPrice = 100,
        PurchasePrice = 1000,
        AllowRent = false,
        
        HouseInformation = {
            HouseName = 'House 1',
            Description = 'Test Test',
        }
        Friends = {},
        Teleport = { -- Works if 'MLO = false'
            In = vector3(),
            Out = vector3(),
        },
        DoorCords = { -- If you dont use MLO then this is not important!
            {DoorHash = 'v_ilev_fa_frontdoor', DoorCoords = vector3(1301.01, -574.51, 71.73)},
        },
        Stash = {
            {Coords = vector3(), Lock = true}
        },
        Wardrobe = {
            {Coords =  vector3()}
        },
        Garages = {
            AllowGarage = true,
            AvailableSlot = 2,
            MaxSlot = 20,
            GarageSlotPrice = 1000,
            Distance = 10.0,

            Coords = {
                {SpawnCoords = vector3(), OpenGarageCoords = vector3()}
            }
        },
    }
}

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.3, 0.3)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 90)
end