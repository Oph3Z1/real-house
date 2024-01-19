ScriptLoaded = false

function StartScript()
    for k,v in pairs(Config.Houses) do
        Def = {
            HouseInformation = {
                HouseName = v.HouseInformation.HouseName,
                HouseDescription = v.HouseInformation.Description,
                AvailableSlot = v.Garages.AvailableSlot,
                AllowGarage = v.Garages.AllowGarage,
            },

            Owner = v.Owner,
            KeyData = v.KeyData,
            RentOwner = v.RentOwner,
            AllowRent = v.AllowRent,
            Friends = {}
        }

        local HouseData = ExecuteSql("SELECT * FROM `real_house` WHERE id = '"..k.."'")

        if #HouseData == 0 then
            ExecuteSql("INSERT INTO `real_house` (id, owner, houseinfo, keydata, rentowner, allowrent, friends) VALUES ('"..k.."', '"..Def.Owner.."', '"..json.encode(Def.HouseInformation).."', '"..Def.KeyData.."', '"..Def.RentOwner.."', '"..tostring(Def.AllowRent).."', '"..json.encode(Def.Friends).."')")
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

RegisterNetEvent('real-house:RefreshHouses', function()
    TriggerClientEvent('real-house:Update', -1, Config.Houses, ScriptLoaded)
end)

function LoadAllHouses()
    local HouseData = ExecuteSql("SELECT * FROM `real_house`")

    for k,v in pairs(HouseData) do 
        local info = json.decode(v.houseinfo)
        Config.Houses[k].Owner = v.owner
        Config.Houses[k].KeyData = v.keydata
        Config.Houses[k].RentOwner = v.rentowner
        Config.Houses[k].AllowRent = v.AllowRent
        Config.Houses[k].Friends = json.decode(v.friends)
        Config.Houses[k].HouseInformation.HouseName = info.HouseName
        Config.Houses[k].HouseInformation.Description = info.Description
        Config.Houses[k].Garages.AvailableSlot = info.AvailableSlot
        Config.Houses[k].Garages.AllowGarage = info.AllowGarage
    end
    ScriptLoaded = true
end

Citizen.CreateThread(StartScript)