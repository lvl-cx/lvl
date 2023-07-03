RegisterCommand('restartserver', function(source, args)
    local source = source
    local user_id = OASIS.getUserId(source)
    if OASIS.hasGroup(user_id, 'Founder') then
        if args[1] ~= nil then
            timeLeft = args[1]
            TriggerClientEvent('OASIS:announceRestart', -1, tonumber(timeLeft), false)
            TriggerEvent('OASIS:restartTime', timeLeft)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t") -- 0-23 (24 hour format)
        local hour = tonumber(time["hour"])
        if hour == 0 or hour == 12 then
            if tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
                TriggerClientEvent('OASIS:announceRestart', -1, 60, true)
                TriggerEvent('OASIS:restartTime', 60)
            end
        end
    end
end)

RegisterServerEvent("OASIS:restartTime")
AddEventHandler("OASIS:restartTime", function(time)
    time = tonumber(time)
    if source ~= '' then return end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            time = time - 1
            if time == 0 then
                for k,v in pairs(OASIS.getUsers({})) do
                    DropPlayer(v, "Server restarting, please join back in a few minutes.")
                end
                os.exit()
            end
        end
    end)
end)
