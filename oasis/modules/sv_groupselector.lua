local cfg=module("cfg/cfg_groupselector")

function OASIS.getJobSelectors(source)
    local source=source
    local jobSelectors={}
    local user_id = OASIS.getUserId(source)
    for k,v in pairs(cfg.selectors) do
        for i,j in pairs(cfg.selectorTypes) do
            if v.type == i then
                if j._config.permissions[1]~=nil then
                    if OASIS.hasPermission(OASIS.getUserId(source),j._config.permissions[1])then
                        v['_config'] = j._config
                        v['jobs'] = {}
                        for a,b in pairs(j.jobs) do
                            if OASIS.hasGroup(user_id, b[1]) then
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
    TriggerClientEvent("OASIS:gotJobSelectors",source,jobSelectors)
end

RegisterNetEvent("OASIS:getJobSelectors")
AddEventHandler("OASIS:getJobSelectors",function()
    local source = source
    OASIS.getJobSelectors(source)
end)

function OASIS.removeAllJobs(user_id)
    local source = OASIS.getUserSource(user_id)
    for i,j in pairs(cfg.selectorTypes) do
        for k,v in pairs(j.jobs)do
            if i == 'default' and OASIS.hasGroup(user_id, v[1]) then
                OASIS.removeUserGroup(user_id, v[1])
            elseif i ~= 'default' and OASIS.hasGroup(user_id, v[1]..' Clocked') then
                OASIS.removeUserGroup(user_id, v[1]..' Clocked')
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                OASISclient.setArmour(source, {0})
                TriggerEvent('OASIS:clockedOffRemoveRadio', source)
            end
        end
    end
    -- remove all faction ranks
    OASISclient.setPolice(source, {false})
    TriggerClientEvent('OASISUI5:globalOnPoliceDuty', source, false)
    OASISclient.setNHS(source, {false})
    TriggerClientEvent('OASISUI5:globalOnNHSDuty', source, false)
    OASISclient.setHMP(source, {false})
    TriggerClientEvent('OASISUI5:globalOnPrisonDuty', source, false)
    OASISclient.setLFB(source, {false})
    TriggerClientEvent('OASIS:disableFactionBlips', source)
    TriggerClientEvent('OASIS:radiosClearAll', source)
    -- toggle all main jobs to false
    TriggerClientEvent('OASIS:toggleTacoJob', source, false)
end

RegisterNetEvent("OASIS:jobSelector")
AddEventHandler("OASIS:jobSelector",function(a,b)
    local source = source
    local user_id = OASIS.getUserId(source)
    if #(GetEntityCoords(GetPlayerPed(source)) - cfg.selectors[a].position) > 20 then
        TriggerEvent("OASIS:acBan", user_id, 11, GetPlayerName(source), source, 'Triggering job selections from too far away')
        return
    end
    if b == "Unemployed" then
        OASIS.removeAllJobs(user_id)
        OASISclient.notify(source, {"~g~You are now unemployed."})
    else
        if cfg.selectors[a].type == 'police' then
            if OASIS.hasGroup(user_id, b) then
                OASIS.removeAllJobs(user_id)
                OASIS.addUserGroup(user_id,b..' Clocked')
                OASISclient.setPolice(source, {true})
                TriggerClientEvent('OASISUI5:globalOnPoliceDuty', source, true)
                OASISclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tOASIS.sendWebhook('pd-clock', 'OASIS Police Clock On Logs',"> Officer Name: **"..GetPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                OASISclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'nhs' then
            if OASIS.hasGroup(user_id, b) then
                OASIS.removeAllJobs(user_id)
                OASIS.addUserGroup(user_id,b..' Clocked')
                OASISclient.setNHS(source, {true})
                TriggerClientEvent('OASISUI5:globalOnNHSDuty', source, true)
                OASISclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tOASIS.sendWebhook('nhs-clock', 'OASIS NHS Clock On Logs',"> Medic Name: **"..GetPlayerName(source).."**\n> Medic TempID: **"..source.."**\n> Medic PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                OASISclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'lfb' then
            if OASIS.hasGroup(user_id, b) then
                OASIS.removeAllJobs(user_id)
                OASIS.addUserGroup(user_id,b..' Clocked')
                OASISclient.setLFB(source, {true})
                OASISclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tOASIS.sendWebhook('lfb-clock', 'OASIS LFB Clock On Logs',"> Firefighter Name: **"..GetPlayerName(source).."**\n> Firefighter TempID: **"..source.."**\n> Firefighter PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                OASISclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'hmp' then
            if OASIS.hasGroup(user_id, b) then
                OASIS.removeAllJobs(user_id)
                OASIS.addUserGroup(user_id,b..' Clocked')
                OASISclient.setHMP(source, {true})
                TriggerClientEvent('OASISUI5:globalOnPrisonDuty', source, true)
                OASISclient.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                tOASIS.sendWebhook('hmp-clock', 'OASIS HMP Clock On Logs',"> Prison Officer Name: **"..GetPlayerName(source).."**\n> Prison Officer TempID: **"..source.."**\n> Prison Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                OASISclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        else
            OASIS.removeAllJobs(user_id)
            OASIS.addUserGroup(user_id,b)
            OASISclient.notify(source, {"~g~Employed as "..b.."."})
            TriggerClientEvent('OASIS:jobInstructions',source,b)
            if b == 'Taco Seller' then
                TriggerClientEvent('OASIS:toggleTacoJob', source, true)
            end
        end
        TriggerEvent('OASIS:clockedOnCreateRadio', source)
        TriggerClientEvent('OASIS:radiosClearAll', source)
        TriggerClientEvent('OASIS:refreshGunStorePermissions', source)
        OASIS.updateCurrentPlayerInfo()
    end
end)