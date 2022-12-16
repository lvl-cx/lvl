local usersInRoyalMailJob={}
local RoyalMailDrops={
    [1]={
        dropPosition=vector3(396.8274230957,-993.54077148438,29.404117584229)
    },
    [2]={
        dropPosition=vector3(146.29943847656,-1002.9825439453,29.345203399658)
    },
    [3]={
        dropPosition=vector3(-45.810665130615,-1129.7127685547,26.039571762085)
    },
    [4]={
        dropPosition=vector3(-230.99066162109,-979.03881835938,29.242504119873)
    },
    [5]={
        dropPosition=vector3(62.544189453125,-728.20678710938,44.133487701416)
    },
    [6]={
        dropPosition=vector3(-349.51934814453,-1.5412160158157,47.257663726807)
    },
    [7]={
        dropPosition=vector3(-459.90826416016,-366.56008911133,33.858005523682)
    },
    [8]={
        dropPosition=vector3(153.43214416504,-1029.8165283203,29.21466255188)
    },
    [9]={
        dropPosition=vector3(399.83349609375,-995.69421386719,29.457012176514)
    },
    [10]={
        dropPosition=vector3(-12.371451377869,-692.36560058594,32.33810043335)
    }
}

RegisterNetEvent("ARMA:attemptBeginRoyalMailJob")
AddEventHandler("ARMA:attemptBeginRoyalMailJob",function()
    local source=source
    local user_id=ARMA.getUserId(source)
    local RoyalMailJobTable={}
    if ARMA.hasGroup(user_id,"Royal Mail Driver")then
        if not usersInRoyalMailJob[user_id] then
            usersInRoyalMailJob[user_id]={currentJob=""}
            RoyalMailJobTable.jobActive=true
            RoyalMailJobTable.stopNumber=1
            usersInRoyalMailJob[user_id].currentJob=RoyalMailJobTable
            TriggerClientEvent("ARMA:beginRoyalMailJob",source)
            Wait(100)
            TriggerClientEvent("ARMA:royalMailJobSetNextBlip",source,RoyalMailDrops[RoyalMailJobTable.stopNumber].dropPosition)
        else
            ARMAclient.notify(source,{"~r~You are already a Royal Mail Driver."})
        end
    else
        ARMAclient.notify(source,{"~r~You are not clocked on as a Royal Mail Driver."})
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(usersInRoyalMailJob)do
            if v.currentJob.jobActive then
                for a,b in pairs(RoyalMailDrops)do
                    if ARMA.getUserSource(k)then
                        if#(GetEntityCoords(GetPlayerPed(ARMA.getUserSource(k)))-RoyalMailDrops[v.currentJob.stopNumber].dropPosition)<5.0 then
                            local pay = math.random(1000,1500)
                            ARMA.giveBankMoney(k,pay)
                            TriggerClientEvent("ARMA:royalMailReachedNextStop",ARMA.getUserSource(k),RoyalMailDrops[v.currentJob.stopNumber].dropPosition,pay)
                            if v.currentJob.stopNumber==10 then
                                TriggerClientEvent("ARMA:royalMailJobEnd", ARMA.getUserSource(k))
                                v.currentJob.jobActive=false
                            else
                                v.currentJob.stopNumber=v.currentJob.stopNumber+1
                                TriggerClientEvent("ARMA:royalMailJobSetNextBlip",ARMA.getUserSource(k),RoyalMailDrops[v.currentJob.stopNumber].dropPosition)
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end)