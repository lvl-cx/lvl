local usersInBusJob={}
local busJobStops={
    [1]={
        stopPosition=vector3(402.40344238281,-722.01306152344,29.228933334351)
    },
    [2]={
        stopPosition=vector3(403.75317382812,-788.14752197266,29.26558303833)
    },
    [3]={
        stopPosition=vector3(352.87112426758,-841.11608886719,29.112545013428)
    },
    -- need to add up to 15 stops (last one take back to bus station)
}

RegisterNetEvent("ARMA:attemptBeginBusJob")
AddEventHandler("ARMA:attemptBeginBusJob",function()
    local source=source
    local user_id=ARMA.getUserId(source)
    local BusJobTable={}
    if ARMA.hasGroup(user_id,"Bus Driver")then
        if not usersInBusJob[user_id] then
            usersInBusJob[user_id]={currentJob=""}
            BusJobTable.jobActive=true
            BusJobTable.stopNumber=1
            usersInBusJob[user_id].currentJob=BusJobTable
            TriggerClientEvent("ARMA:beginBusJob",source)
            Wait(100)
            TriggerClientEvent("ARMA:setNextBusJobBlip",source,busJobStops[BusJobTable.stopNumber].stopPosition)
        else
            ARMAclient.notify(source,{"~r~You are already a Bus Driver."})
        end
    else
        ARMAclient.notify(source,{"~r~You are not clocked on as a Bus Driver."})
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(usersInBusJob)do
            if v.currentJob.jobActive then
                for a,b in pairs(busJobStops)do
                    if ARMA.getUserSource(k)then
                        if#(GetEntityCoords(GetPlayerPed(ARMA.getUserSource(k)))-busJobStops[v.currentJob.stopNumber].stopPosition)<5.0 then
                            v.currentJob.stopNumber=v.currentJob.stopNumber+1
                            local pay = math.random(1000,1500)
                            TriggerClientEvent("ARMA:nextStopReachedBusJob",ARMA.getUserSource(k),pay)
                            ARMA.giveMoney(k,pay)
                            if busJobStops[v.currentJob.stopNumber]==15 then
                                TriggerClientEvent("ARMA:endBusJob", ARMA.getUserSource(k))
                            else
                                TriggerClientEvent("ARMA:setNextBusJobBlip",ARMA.getUserSource(k),busJobStops[v.currentJob.stopNumber].stopPosition)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end)