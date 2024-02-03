ScriptLoaded = false

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
            Friends = {},
            Payment = 0
        }

        local HouseData = ExecuteSql("SELECT * FROM `real_house` WHERE id = '"..k.."'")

        if #HouseData == 0 then
            ExecuteSql("INSERT INTO `real_house` (id, owner, houseinfo, keydata, rentowner, allowrent, friends, payment) VALUES ('"..k.."', '"..Def.Owner.."', '"..json.encode(Def.HouseInformation).."', '"..Def.KeyData.."', '"..Def.RentOwner.."', '"..json.encode(Def.AllowRent).."', '"..json.encode(Def.Friends).."', '"..Def.Payment.."')")
        end
        LoadAllHouses()
    end
end

function RequestNewData()
    local source = source
    LoadAllHouses()
    TriggerClientEvent('real-house:Update', source, Config.Houses, ScriptLoaded)
end

RegisterNetEvent("real-house:ReqData", RequestNewData)

function LoadAllHouses()
    local HouseData = ExecuteSql("SELECT * FROM `real_house`")

    for k,v in pairs(HouseData) do 
        local info = json.decode(v.houseinfo)
        local rentowner = json.decode(v.rentowner)
        if rentowner then
            Config.Houses[k].Owner = v.owner
            Config.Houses[k].KeyData = v.keydata
            Config.Houses[k].RentOwner = rentowner.owner
            Config.Houses[k].AllowRent = v.AllowRent
            Config.Houses[k].Friends = json.decode(v.friends)
            Config.Houses[k].HouseInformation.HouseName = info.HouseName
            Config.Houses[k].HouseInformation.Description = info.Description
            Config.Houses[k].Garages.AvailableSlot = info.AvailableSlot
        else
            Config.Houses[k].Owner = v.owner
            Config.Houses[k].KeyData = v.keydata
            Config.Houses[k].RentOwner = ""
            Config.Houses[k].AllowRent = v.AllowRent
            Config.Houses[k].Friends = json.decode(v.friends)
            Config.Houses[k].HouseInformation.HouseName = info.HouseName
            Config.Houses[k].HouseInformation.Description = info.Description
            Config.Houses[k].Garages.AvailableSlot = info.AvailableSlot
        end
    end
    ScriptLoaded = true
end

Citizen.CreateThread(StartScript)