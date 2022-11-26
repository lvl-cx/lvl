RegisterServerEvent("ARMA:sendGangMarker")
AddEventHandler("ARMA:sendGangMarker", function(coords)
    local source = source
    local user_id = ARMA.getUserId(source)
    local peoplesids = {}
    local gangmembers = {}
    exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    isingang = true
                    for U,D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermission)
                    end
                    exports['ghmattimysql']:execute('SELECT * FROM arma_users', function(gotUser)
                        for J,G in pairs(gotUser) do
                            if peoplesids[tostring(G.id)] ~= nil then
                                local player = ARMA.getUserSource(tonumber(G.id))
                                if player ~= nil then
                                    TriggerClientEvent('ARMA:drawGangMarker', player, coords)
                                end
                            end
                        end
                    end)
                    break
                end
            end
        end
    end)
end)