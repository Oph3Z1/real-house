Config.DiscordBotToken = 'OTMwODI3Mzg1MzI5MzA3NzMx.GQPatL.q0qjstbgFANq6d21rMjZK7A4v__UmNNxF0dti8' -- Discord bot token
Config.PhoneMail = "qb-phone:server:sendNewMailToOffline" -- Send mail event

RegisterNetEvent('real-house:SendMailToPlayerHouseExpired', function(player)
    TriggerEvent(Config.PhoneMail, player, {
        sender = "Sweden Real Estate",
        subject = "House contract with Sweden Real Estate",
        Message = "According to the contract we have made, you must pay the rent of the house every month without delay. And because you broke this important rule, the contract is canceled. You were kicked out of the house."
    })
end)

RegisterNetEvent('real-house:SendMailToRealOwner', function(player)
    TriggerEvent(Config.PhoneMail, player, {
        sender = "Sweden Real Estate",
        subject = "House contract with Sweden Real Estate",
        Message = "The house you bought is now empty. You can go to the door and use the /gethousekeys command to get the house keys."
    })
end)

RegisterNetEvent('real-house:RefreshPhone', function(player) -- Refresh players phone
    TriggerClientEvent('qb-phone:RefreshPhone', player)
end)