local staffGroups = {
    ['Founder'] = true,
    --['Developer'] = true,
    ['Staff Manager'] = true,
    ['Community Manager'] = true,
    ['Head Admin'] = true,
    ['Senior Admin'] = true,
    ['Admin'] = true,
    ['Senior Moderator'] = true,
    ['Moderator'] = true,
    ['Support Team'] = true,
    ['Trial Staff'] = true,
}
local pdGroups = {
    ["Commissioner Clocked"]=true,
    ["Deputy Commissioner Clocked"] =true,
    ["Assistant Commissioner Clocked"]=true,
    ["Deputy Assistant Commissioner Clocked"] =true,
    ["Commander Clocked"]=true,
    ["Chief Superintendent Clocked"]=true,
    ["Superintendent Clocked"]=true,
    ["Chief Inspector Clocked"]=true,
    ["Inspector Clocked"]=true,
    ["Sergeant Clocked"]=true,
    ["Senior Constable Clocked"]=true,
    ["Police Constable Clocked"]=true,
    ["PCSO Clocked"]=true,
    ["Special Constable Clocked"]=true,
}
local nhsGroups = {
    ["NHS Trainee Paramedic"] = true,
    ["NHS Paramedic"] = true,
    ["NHS Critical Care"] = true,
    ["NHS Junior Doctor"] = true,
    ["NHS Doctor"] = true,
    ["NHS Senior Doctor"] = true,
    ["NHS Specialist"] = true,
    ["NHS Consultant"] = true,
    ["NHS Captain"] = true,
    ["NHS Deputy Chief"] = true,
    ["NHS Assistant Chief"] = true,
    ["NHS Head Chief"] = true
}
local lfbGroups = {
    ["Provisional Firefighter"] = true,
    ["Junior Firefighter"] = true,
    ["Firefighter"] = true,
    ["Senior Firefighter"] = true,
    ["Advanced Firefighter"] = true,
    ["Specalist Firefighter"] = true,
    ["Leading Firefighter"] = true,
    ["Sector Command"] = true,
    ["Divisional Command"] = true,
    ["Chief Fire Command"] = true
}
local hmpGroups = {
    ["Governor"] = true,
    ["Deputy Governor"] = true,
    ["Divisional Commander"] = true,
    ["Custodial Supervisor"] = true,
    ["Custodial Officer"] = true,
    ["Honourable Guard"] = true,
    ["Supervising Officer"] = true,
    ["Principal Officer"] = true,
    ["Specialist Officer"] = true,
    ["Senior Officer"] = true,
    ["Prison Officer"] = true,
    ["Trainee Prison Officer"] = true
}
local defaultGroups = {
    ["AA Mechanic"] = true,
    ["Royal Mail Driver"] = true,
    ["Bus Driver"] = true,
    ["Deliveroo"] = true,
    ["Fisherman"] = true,
    ["Scuba Diver"] = true,
    ["Pilot"] = true,
    ["G4S Driver"] = true,
    ["Lorry Driver"] = true,
    ["Taco Seller"] = true,
    ["Burger Shot Cook"] = true,
}

local function getGroupInGroups(id, type)
    if type == 'staff' then
        for k,v in pairs(ARMA.getUserGroups(id)) do
            if staffGroups[k] then 
                return k
            end 
        end
    elseif type == 'police' then
        for k,v in pairs(ARMA.getUserGroups(id)) do
            if pdGroups[k] then 
                return k
            end 
        end
    elseif type == 'nhs' then
        for k,v in pairs(ARMA.getUserGroups(id)) do
            if nhsGroups[k] then 
                return k
            end 
        end
    elseif type == 'lfb' then
        for k,v in pairs(ARMA.getUserGroups(id)) do
            if lfbGroups[k] then 
                return k
            end 
        end
    elseif type == 'hmp' then
        for k,v in pairs(ARMA.getUserGroups(id)) do
            if hmpGroups[k] then 
                return k
            end 
        end
    elseif type == 'default' then
        for k,v in pairs(ARMA.getUserGroups(id)) do
            if defaultGroups[k] then 
                return k
            end 
        end
        return "Unemployed"
    end
end

local uptime = 0
local function playerListMetaUpdates()
    local uptimemessage = ''
    if uptime < 60 then
        uptimemessage = math.floor(uptime) .. ' seconds'
    elseif uptime >= 60 and uptime < 3600 then
        uptimemessage = math.floor(uptime/60) .. ' minutes and ' .. math.floor(uptime%60) .. ' seconds'
    elseif uptime >= 3600 then
        uptimemessage = math.floor(uptime/3600) .. ' hours and ' .. math.floor((uptime%3600)/60) .. ' minutes and ' .. math.floor(uptime%60) .. ' seconds'
    end
    return {uptimemessage, #GetPlayers(), 32}
end

Citizen.CreateThread(function()
    while true do
        uptime = uptime + 1
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent('ARMA:getPlayerListData')
AddEventHandler('ARMA:getPlayerListData', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local staff = {}
    local police = {}
    local nhs = {}
    local hmp = {}
    local lfb = {}
    local civillians = {}
    for k,v in pairs(ARMA.getUsers()) do
        local minutesPlayed = ARMA.getUserDataTable(k).PlayerTime or 0
        local hours = math.ceil(minutesPlayed/60)
        if hours == 0 then
            hours = 1
        end
        if ARMA.hasPermission(k, 'admin.tickets') then
            staff[k] = {name = GetPlayerName(v), rank = getGroupInGroups(k, 'staff'), hours = hours}
        end
        if ARMA.hasPermission(k, 'police.onduty.permission') then
            police[k] = {name = GetPlayerName(v), rank = string.gsub(getGroupInGroups(k, 'police'), ' Clocked', ''), hours = hours}
        elseif ARMA.hasPermission(k, 'nhs.onduty.permission') then
            nhs[k] = {name = GetPlayerName(v), rank = string.gsub(getGroupInGroups(k, 'nhs'), ' Clocked', ''), hours = hours}
        elseif ARMA.hasPermission(k, 'prisonguard.onduty.permission') then
            hmp[k] = {name = GetPlayerName(v), rank = string.gsub(getGroupInGroups(k, 'hmp'), ' Clocked', ''), hours = hours}
        elseif ARMA.hasPermission(k, 'lfb perm') then
            lfb[k] = {name = GetPlayerName(v), rank = string.gsub(getGroupInGroups(k, 'lfb'), ' Clocked', ''), hours = hours}
        end
        if not ARMA.hasPermission(k, "police.onduty.permission") and not ARMA.hasPermission(k, "nhs perm") and not ARMA.hasPermission(k, "lfb perm") and not ARMA.hasPermission(k, "prisonguard.onduty.permission") then
            civillians[k] = {name = GetPlayerName(v), rank = getGroupInGroups(k, 'default'), hours = hours}
        end
    end
    TriggerClientEvent('ARMA:gotFullPlayerListData', source, staff, police, nhs, lfb, hmp, civillians)
    TriggerClientEvent('ARMA:playerListMetaUpdate', -1, playerListMetaUpdates())
end)



-- Pay checks

local paycheckscfg = module('cfg/cfg_factiongroups')

local function paycheck(tempid, permid, money)
    ARMA.giveMoney(permid, money)
    ARMAclient.notifyPicture(tempid, {'CHAR_BANK_MAZE', 'CHAR_BANK_MAZE', 'Payday: ~g~£'..getMoneyStringFormatted(tostring(money)), "", 'PAYE', '', 1})
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000*60*30)
        for k,v in pairs(ARMA.getUsers()) do
            if ARMA.hasPermission(k, "police.onduty.permission") then
                for a,b in pairs(paycheckscfg.metPoliceRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'police'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif ARMA.hasPermission(k, "nhs.onduty.permission") then
                for a,b in pairs(paycheckscfg.nhsRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'nhs'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif ARMA.hasPermission(k, "lfb perm") then
                for a,b in pairs(paycheckscfg.lfbRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'lfb'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif ARMA.hasPermission(k, "prisonguard.onduty.permission") then
                for a,b in pairs(paycheckscfg.hmpRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'hmp'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            end
        end
    end
end)