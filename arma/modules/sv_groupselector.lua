local cfg=module("cfg/cfg_groupselector")

function ARMA.getJobSelectors(source)
    local source=source
    local jobSelectors={}
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(cfg.selectors) do
        for i,j in pairs(cfg.selectorTypes) do
            if v.type == i then
                if j._config.permissions[1]~=nil then
                    if ARMA.hasPermission(ARMA.getUserId(source),j._config.permissions[1])then
                        v['_config'] = j._config
                        v['jobs'] = {}
                        for a,b in pairs(j.jobs) do
                            if ARMA.hasGroup(user_id, b[1]) then
                                table.insert(v['jobs'], b)
                            end
                        end
                        jobSelectors[k] = v
                    end
                else
                    v['_config'] = j._config
                    v['jobs'] = j.jobs
                    jobSelectors[k] = v
                end
            end
        end
    end
    TriggerClientEvent("ARMA:gotJobSelectors",source,jobSelectors)
end

RegisterNetEvent("ARMA:getJobSelectors")
AddEventHandler("ARMA:getJobSelectors",function()
    local source = source
    ARMA.getJobSelectors(source)
end)


function ARMA.removeAllJobs(user_id)
    local source = ARMA.getUserSource(user_id)
    for i,j in pairs(cfg.selectorTypes) do
        for k,v in pairs(j.jobs)do
            if i == 'default' and ARMA.hasGroup(user_id, v[1]) then
                ARMA.removeUserGroup(user_id, v[1])
            elseif i ~= 'default' and ARMA.hasGroup(user_id, v[1]..' Clocked') then
                ARMA.removeUserGroup(user_id, v[1]..' Clocked')
                RemoveAllPedWeapons(GetPlayerPed(source), true)
            end
        end
    end
    -- remove all faction ranks
    ARMAclient.setPolice(source, {false})
    TriggerClientEvent('ARMAUI5:globalOnPoliceDuty', source, false)
    ARMAclient.setNHS(source, {false})
    TriggerClientEvent('ARMAUI5:globalOnNHSDuty', source, false)
    ARMAclient.setHMP(source, {false})
    TriggerClientEvent('ARMAUI5:globalOnPrisonDuty', source, false)
    ARMAclient.setLFB(source, {false})
    TriggerClientEvent('ARMA:disableFactionBlips', source)
    TriggerClientEvent('ARMA:radiosClearAll', source)
    -- toggle all main jobs to false
    TriggerClientEvent('ARMA:toggleTacoJob', source, false)
    TriggerClientEvent('ARMA:setOnPilotDuty', source, false)
end

RegisterNetEvent("ARMA:jobSelector")
AddEventHandler("ARMA:jobSelector",function(a,b)
    local source = source
    local user_id = ARMA.getUserId(source)
    if #(GetEntityCoords(GetPlayerPed(source)) - cfg.selectors[a].position) > 20 then
        TriggerEvent("ARMA:acBan", user_id, 11, GetPlayerName(source), source, 'Triggering job selections from too far away')
        return
    end
    if b == "Unemployed" then
        ARMA.removeAllJobs(user_id)
        ARMAclient.notify(source, {"~g~You are now unemployed."})
    else
        if cfg.selectors[a].type == 'police' then
            if ARMA.hasGroup(user_id, b) then
                ARMA.removeAllJobs(user_id)
                ARMA.addUserGroup(user_id,b..' Clocked')
                ARMAclient.setPolice(source, {true})
                TriggerClientEvent('ARMAUI5:globalOnPoliceDuty', source, true)
                ARMAclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tARMA.sendWebhook('pd-clock', 'ARMA Police Clock On Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                ARMAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'nhs' then
            if ARMA.hasGroup(user_id, b) then
                ARMA.removeAllJobs(user_id)
                ARMA.addUserGroup(user_id,b..' Clocked')
                ARMAclient.setNHS(source, {true})
                TriggerClientEvent('ARMAUI5:globalOnNHSDuty', source, true)
                ARMAclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tARMA.sendWebhook('nhs-clock', 'ARMA NHS Clock On Logs',"> Medic Name: **"..GetPlayerName(source).."**\n> Medic TempID: **"..source.."**\n> Medic PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                ARMAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'lfb' then
            if ARMA.hasGroup(user_id, b) then
                ARMA.removeAllJobs(user_id)
                ARMA.addUserGroup(user_id,b..' Clocked')
                ARMAclient.setLFB(source, {true})
                ARMAclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tARMA.sendWebhook('lfb-clock', 'ARMA LFB Clock On Logs',"> Firefighter Name: **"..GetPlayerName(source).."**\n> Firefighter TempID: **"..source.."**\n> Firefighter PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                ARMAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'hmp' then
            if ARMA.hasGroup(user_id, b) then
                ARMA.removeAllJobs(user_id)
                ARMA.addUserGroup(user_id,b..' Clocked')
                ARMAclient.setHMP(source, {true})
                TriggerClientEvent('ARMAUI5:globalOnPrisonDuty', source, true)
                ARMAclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tARMA.sendWebhook('hmp-clock', 'ARMA HMP Clock On Logs',"> Prison Officer Name: **"..GetPlayerName(source).."**\n> Prison Officer TempID: **"..source.."**\n> Prison Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                ARMAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        else
            ARMA.removeAllJobs(user_id)
            ARMA.addUserGroup(user_id,b)
            ARMAclient.notify(source, {"~g~Employed as "..b.."."})
            TriggerClientEvent('ARMA:jobInstructions',source,b)
            if b == 'Taco Seller' then
                TriggerClientEvent('ARMA:toggleTacoJob', source, true)
            end
            if b == 'Pilot' then
                TriggerClientEvent('ARMA:setOnPilotDuty', source, true)
            end
        end
        ARMA.updateCurrentPlayerInfo()
    end
end)