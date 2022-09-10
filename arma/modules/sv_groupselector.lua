local cfg=module("cfg/cfg_groupselector")


RegisterNetEvent("ARMA:getJobSelectors")
AddEventHandler("ARMA:getJobSelectors",function()
    local source=source
    local jobSelectors={}
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(cfg.selectors) do
        for i,j in pairs(cfg.selectorTypes) do
            if v.type == i then
                if j._config.permissions[1]~=nil then
                    if ARMA.hasPermission(ARMA.getUserId(source),j._config.permissions[1])then
                        v['_config'] = j._config
                        v['jobs'] = j.jobs
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
end)

function ARMA.removeAllJobs(user_id)
    local source = ARMA.getUserSource(user_id)
    for i,j in pairs(cfg.selectorTypes) do
        for k,v in pairs(j.jobs)do
            if i == 'default' and ARMA.hasGroup(user_id, v[1]) then
                ARMA.removeUserGroup(user_id, v[1])
                ARMAclient.notify(source, {'~o~[DEBUG] Removing group: '..v[1]}) -- remove later
            elseif i ~= 'default' and ARMA.hasGroup(user_id, v[1]..' Clocked') then
                ARMA.removeUserGroup(user_id, v[1]..' Clocked')
                ARMAclient.notify(source, {'~o~[DEBUG] Removing group: '..v[1]..' Clocked'}) -- remove later
            end
        end
    end
    ARMAclient.setPolice(source, {false})
    ARMAclient.setNHS(source, {false})
    ARMAclient.setHMP(source, {false})
    ARMAclient.setLFB(source, {false})
    TriggerClientEvent('ARMA:disableFactionBlips', source)
end

RegisterNetEvent("ARMA:jobSelector")
AddEventHandler("ARMA:jobSelector",function(a,b)
    local source = source
    local user_id = ARMA.getUserId(source)
    if #(GetEntityCoords(GetPlayerPed(source)) - cfg.selectors[a].position) > 20 then
        -- ac ban they're triggering job selections
        return
    end
    if b == "Unemployed" then
        ARMA.removeAllJobs(user_id)
        ARMAclient.notify(source, {"~g~You are now unemployed."})
    else
        if cfg.selectors[a].type == 'police' then
            if ARMA.hasPermission(user_id, string.lower(b)..'.clockon') then
                ARMA.removeAllJobs(user_id)
                ARMA.addUserGroup(user_id,b..' Clocked')
                ARMAclient.setPolice(source, {true})
                ARMAclient.notify(source, {"~g~Clocked on as "..b.."."})
            else
                ARMAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif a == 'nhs' then
            if ARMA.hasPermission(user_id, string.lower(b)..'.clockon') then
                ARMA.removeAllJobs(user_id)
                ARMA.addUserGroup(user_id,b..' Clocked')
                ARMAclient.setNHS(source, {true})
                ARMAclient.notify(source, {"~g~Clocked on as "..b.."."})
            else
                ARMAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif a == 'lfb' then
            if ARMA.hasPermission(user_id, string.lower(b)..'.clockon') then
                ARMA.removeAllJobs(user_id)
                ARMA.addUserGroup(user_id,b..' Clocked')
                ARMAclient.setLFB(source, {true})
                ARMAclient.notify(source, {"~g~Clocked on as "..b.."."})
            else
                ARMAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        elseif a == 'hmp' then
            if ARMA.hasPermission(user_id, string.lower(b)..'.clockon') then
                ARMA.removeAllJobs(user_id)
                ARMA.addUserGroup(user_id,b..' Clocked')
                ARMAclient.setHMP(source, {true})
                ARMAclient.notify(source, {"~g~Clocked on as "..b.."."})
            else
                ARMAclient.notify(source, {"~r~You do not have permission to clock on as "..b.."."})
            end
        else
            ARMA.removeAllJobs(user_id)
            ARMA.addUserGroup(user_id,b)
            ARMAclient.notify(source, {"~g~Employed as "..b.."."})
            TriggerClientEvent('ARMA:jobInstructions',source,b)
        end
    end
end)