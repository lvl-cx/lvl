local staffGroups = {
    ['Founder'] = true,
    --['Developer'] = true,
    ['Staff Manager'] = true,
    ['Community Manager'] = true,
    ['Head Admin'] = true,
    ['Senior Admin'] = true,
    ['Admin'] = true,
    ['Senior Mod'] = true,
    ['Moderator'] = true,
    ['Support Team'] = true,
    ['Trial Staff'] = true,
}
local pdGroups = {
    ["Commissioner Clocked"]=true,
    ["Deputy Commissioner Clocked"] =true,
    ["Assistant Commissioner Clocked"]=true,
    ["Dep. Asst. Commissioner Clocked"] =true,
    ["Commander Clocked"]=true,
    ["Chief Superintendent Clocked"]=true,
    ["Superintendent Clocked"]=true,
    ["Chief Inspector Clocked"]=true,
    ["Inspector Clocked"]=true,
    ["Sergeant Clocked"]=true,
    ["Senior Constable Clocked"]=true,
    ["PC Clocked"]=true,
    ["PCSO Clocked"]=true,
    ["Special Constable Clocked"]=true,
    ["NPAS Clocked"]=true,
}
local nhsGroups = {
    ["NHS Trainee Paramedic Clocked"] = true,
    ["NHS Paramedic Clocked"] = true,
    ["NHS Critical Care Clocked"] = true,
    ["NHS Junior Doctor Clocked"] = true,
    ["NHS Doctor Clocked"] = true,
    ["NHS Senior Doctor Clocked"] = true,
    ["NHS Specialist Clocked"] = true,
    ["NHS Consultant Clocked"] = true,
    ["NHS Captain Clocked"] = true,
    ["NHS Deputy Chief Clocked"] = true,
    ["NHS Assistant Chief Clocked"] = true,
    ["NHS Head Chief Clocked"] = true,
    ["HEMS Clocked"]=true,
}
local lfbGroups = {
    ["Provisional Firefighter Clocked"] = true,
    ["Junior Firefighter Clocked"] = true,
    ["Firefighter Clocked"] = true,
    ["Senior Firefighter Clocked"] = true,
    ["Advanced Firefighter Clocked"] = true,
    ["Specalist Firefighter Clocked"] = true,
    ["Leading Firefighter Clocked"] = true,
    ["Sector Command Clocked"] = true,
    ["Divisional Command Clocked"] = true,
    ["Chief Fire Command Clocked"] = true
}
local hmpGroups = {
    ["Governor Clocked"] = true,
    ["Deputy Governor Clocked"] = true,
    ["Divisional Commander Clocked"] = true,
    ["Custodial Supervisor Clocked"] = true,
    ["Custodial Officer Clocked"] = true,
    ["Honourable Guard Clocked"] = true,
    ["Supervising Officer Clocked"] = true,
    ["Principal Officer Clocked"] = true,
    ["Specialist Officer Clocked"] = true,
    ["Senior Officer Clocked"] = true,
    ["Prison Officer Clocked"] = true,
    ["Trainee Prison Officer Clocked"] = true
}
local defaultGroups = {
    ["Royal Mail Driver"] = true,
    ["Bus Driver"] = true,
    ["Deliveroo"] = true,
    ["Scuba Diver"] = true,
    ["Pilot"] = true,
    ["G4S Driver"] = true,
    ["Taco Seller"] = true,
    ["Burger Shot Cook"] = true,
}
local tridentGroups = {
    ["Trident Officer Clocked"] = true,
    ["Trident Command Clocked"] = true,
}
function getGroupInGroups(id, type)
    if type == 'Staff' then
        for k,v in pairs(ARMA.getUserGroups(id)) do
            if staffGroups[k] then 
                return k
            end 
        end
    elseif type == 'Police' then
        for k,v in pairs(ARMA.getUserGroups(id)) do
            if pdGroups[k] or tridentGroups[k] then 
                return k
            end 
        end
    elseif type == 'NHS' then
        for k,v in pairs(ARMA.getUserGroups(id)) do
            if nhsGroups[k] then 
                return k
            end 
        end
    elseif type == 'LFB' then
        for k,v in pairs(ARMA.getUserGroups(id)) do
            if lfbGroups[k] then 
                return k
            end 
        end
    elseif type == 'HMP' then
        for k,v in pairs(ARMA.getUserGroups(id)) do
            if hmpGroups[k] then 
                return k
            end 
        end
    elseif type == 'Default' then
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
    return {uptimemessage, #GetPlayers(), GetConvarInt("sv_maxclients",64)}
end

Citizen.CreateThread(function()
    while true do
        uptime = uptime + 1
        TriggerClientEvent('ARMA:playerListMetaUpdate', -1, playerListMetaUpdates())
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
    local lfb = {}
    local hmp = {}
    local civillians = {}
    for k,v in pairs(ARMA.getUsers()) do
        local name = GetPlayerName(v)
        if name ~= nil then
            local minutesPlayed = ARMA.getUserDataTable(k).PlayerTime or 0
            local hours = math.floor(minutesPlayed/60)
            if ARMA.hasPermission(k, 'admin.tickets') then
                staff[k] = {name = name, rank = getGroupInGroups(k, 'Staff'), hours = hours}
            end
            if ARMA.hasPermission(k, 'police.onduty.permission') and not ARMA.hasPermission(k, 'police.undercover') then
                police[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'Police'), ' Clocked', ''), hours = hours}
            elseif ARMA.hasPermission(k, 'nhs.onduty.permission') then
                nhs[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'NHS'), ' Clocked', ''), hours = hours}
            elseif ARMA.hasPermission(k, 'lfb.onduty.permission') then
                lfb[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'LFB'), ' Clocked', ''), hours = hours}
            elseif ARMA.hasPermission(k, 'prisonguard.onduty.permission') then
                hmp[k] = {name = name, rank = string.gsub(getGroupInGroups(k, 'HMP'), ' Clocked', ''), hours = hours}
            end
            if (not ARMA.hasPermission(k, "police.onduty.permission") or ARMA.hasPermission(k, 'police.undercover')) and not ARMA.hasPermission(k, "nhs.onduty.permission") and not ARMA.hasPermission(k, "lfb.onduty.permission") and not ARMA.hasPermission(k, "prisonguard.onduty.permission") then
                civillians[k] = {name = name, rank = getGroupInGroups(k, 'Default'), hours = hours}
            end
        end
    end
    TriggerClientEvent('ARMA:gotFullPlayerListData', source, staff, police, nhs, lfb, hmp, civillians)
    TriggerClientEvent('ARMA:gotJobTypes', source, nhsGroups, pdGroups, lfbGroups, hmpGroups, tridentGroups)
end)



-- Pay checks

local paycheckscfg = module('cfg/cfg_factiongroups')

local function paycheck(tempid, permid, money)
    ARMA.giveBankMoney(permid, money)
    ARMAclient.notifyPicture(tempid, {'CHAR_BANK_MAZE', 'CHAR_BANK_MAZE', 'Payday: ~g~£'..getMoneyStringFormatted(tostring(money)), "", 'PAYE', '', 1})
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000*60*30)
        for k,v in pairs(ARMA.getUsers()) do
            if ARMA.hasPermission(k, "police.onduty.permission") then
                for a,b in pairs(paycheckscfg.metPoliceRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'Police'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif ARMA.hasPermission(k, "nhs.onduty.permission") then
                for a,b in pairs(paycheckscfg.nhsRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'NHS'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif ARMA.hasPermission(k, "lfb.onduty.permission") then
                for a,b in pairs(paycheckscfg.lfbRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'LFB'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif ARMA.hasPermission(k, "prisonguard.onduty.permission") then
                for a,b in pairs(paycheckscfg.hmpRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'HMP'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            end
        end
    end
end)