local Proxy = module("arma", "lib/Proxy")
ARMA = Proxy.getInterface("ARMA")

function GetDefaultCache()
    return {
        staff = {},
        police = {},
        nhs = {},
        members = {}
    }
end

local cache = GetDefaultCache()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        updateList()
	end
end)

function isStaff(id)
    return ARMA.hasGroup({id, "founder"}) or ARMA.hasGroup({id, "staffmanager"}) or ARMA.hasGroup({id, "headadmin"}) or ARMA.hasGroup({id, "senioradmin"}) or ARMA.hasGroup({id, "administrator"}) or ARMA.hasGroup({id, "moderator"}) or ARMA.hasGroup({id, "support"}) or ARMA.hasGroup({id, "trialstaff"})
end

function isPolice(id)
    return ARMA.hasPermission({id, "police.menu"})
end

function isNHS(id)
    return ARMA.hasPermission({id, "ems.whitelisted"})
end

function getJob(id)
    local job = ARMA.getUserGroupByType({id, "job"})

    if job == "" then
        return "Unemployed"
    else
        return job
    end
end

function secondsToClock(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return "0s";
    else
        output = ""

        hours = math.floor(seconds/3600);
        mins = math.floor(seconds/60 - (hours*60));
        secs = math.floor(seconds - hours*3600 - mins *60);

        if seconds > 3600 then
            output = output .. hours .. "h "
        end

        if seconds > 60 then
            output = output .. mins .. "m "
        end

        return output .. secs .. "s"
    end
end

function getTimePlayed(id)
    local table = ARMA.getUserDataTable({id})
    local seconds = 0

    if table ~= nil then
        if table.timePlayed ~= nil then
            seconds = table.timePlayed
        end
    end

    return secondsToClock(seconds)
end

function updateList()
    -- update member cache
    local data = GetDefaultCache()

    for _, id in ipairs(GetPlayers()) do
        local arma_id = ARMA.getUserId({id})
        
        if arma_id ~= nil then  
            local info = {
                id = arma_id,
                name = GetPlayerName(id),
                job = getJob(arma_id),
                timePlayed = getTimePlayed(arma_id)
            }
            
            --for i=1,100 do
            -- check groups
            if isStaff(arma_id) then
                table.insert(data["staff"], info)
            elseif isPolice(arma_id) then
                table.insert(data["police"], info)
            elseif isNHS(arma_id) then
                table.insert(data["nhs"], info)
            else
                table.insert(data["members"], info)    
            end
            --end
        end
    end
    
    -- update list to all players
    cache = data
    TriggerClientEvent('playerlist:getdata', -1, cache)
end

RegisterNetEvent("playerlist:requestUpdate")
AddEventHandler("playerlist:requestUpdate", function()
    TriggerClientEvent('playerlist:getdata', source, cache)
end)