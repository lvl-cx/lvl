RegisterCommand('restartserver', function(source, args)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'Founder') or ARMA.hasGroup(user_id, 'Developer') then
        if args[1] ~= nil then
            timeLeft = args[1]
            TriggerClientEvent('ARMA:announceRestart', -1, tonumber(timeLeft), false)
            TriggerEvent('ARMA:restartTime', timeLeft)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t")
        if tonumber(time["hour"]) == 0 and tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then -- 0-23 (24 hour format)
            TriggerClientEvent('ARMA:announceRestart', -1, 60, true)
            TriggerEvent('ARMA:restartTime', 60)
        end
    end
end)

RegisterServerEvent("ARMA:restartTime")
AddEventHandler("ARMA:restartTime", function(time)
    time = tonumber(time)
    if source ~= '' then return end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            time = time - 1
            if time == 0 then
                for k,v in pairs(ARMA.getUsers({})) do
                    DropPlayer(v, "Server restarting, please join back in a few minutes.")
                end
                os.exit()
            end
        end
    end)
end)
