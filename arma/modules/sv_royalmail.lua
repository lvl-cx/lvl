local usersInRoyalMailJob={}
local RoyalMailDrops={
    [1]={
        dropPosition=vector3(-7.3154945373535,-574.64617919922,37.746841430664)
    },
    [2]={
        dropPosition=vector3(82.115982055664,-798.28112792969,31.461261749268)
    },
    [3]={
        dropPosition=vector3(34.906936645508,-1100.61328125,29.330247879028)
    },
    [4]={
        dropPosition=vector3(20.257566452026,-1311.3227539062,29.350305557251)
    },
    [5]={
        dropPosition=vector3(-67.687004089355,-1337.8675537109,29.25726890564)
    },
    [6]={
        dropPosition=vector3(-56.406318664551,-1117.8198242188,26.434648513794)
    },
    [7]={
        dropPosition=vector3(-96.674522399902,-862.63696289062,26.889167785645)
    },
    [8]={
        dropPosition=vector3(-304.58959960938,-622.50946044922,33.405879974365)
    },
    [9]={
        dropPosition=vector3(-514.36181640625,-603.34991455078,25.308664321899)
    },
    [10]={
        dropPosition=vector3(-657.90789794922,-436.78344726562,34.717582702637)
    },
    [11]={
        dropPosition=vector3(-774.52838134766,-194.44358825684,37.284130096436)
    },
    [12]={
        dropPosition=vector3(-530.25933837891,-325.36654663086,35.036434173584)
    },
    [13]={
        dropPosition=vector3(-207.1000213623,-562.47955322266,34.623355865479)
    },
    [14]={
        dropPosition=vector3(0.62487214803696,-702.77575683594,32.338115692139)
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
                            if v.currentJob.stopNumber==#RoyalMailDrops then
                                TriggerClientEvent("ARMA:royalMailJobEnd", ARMA.getUserSource(k))
                                v.currentJob.jobActive=false
                                usersInRoyalMailJob[user_id] = nil
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