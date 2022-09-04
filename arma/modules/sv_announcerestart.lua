local restartTime = 0 -- 0-23 (24 hour format)
RegisterCommand('restartserver', function(source, args)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'founder') or ARMA.hasGroup(user_id, 'dev') then
        ARMA.prompt(source,"Input time till restart","",function(source,timeLeft) 
            TriggerClientEvent('ARMA:announceRestart', -1, tonumber(timeLeft), false)
            TriggerEvent('ARMA:restartTime', timeLeft)
        end)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t")
        if tonumber(time["hour"]) == restartTime and tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
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
