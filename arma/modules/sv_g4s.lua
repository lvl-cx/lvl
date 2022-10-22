local currentG4SUsersOnJob = {}
local shops = {
    [1] = {
        name = 'Bean Machine',
        coords = vector3(-628.38208007812,239.23078918457,81.894218444824),
        collected = false,
    },
    [2] = {
        name = 'Terry\'s Scrap Yard',
        --coords = vector3(-457.82553100586,-2274.5856933594,8.5158166885376),
        coords = vector3(-575.54486083984,240.8359375,82.72395324707),
        collected = false,
    }
}
local banks = {
    [1] = {
        name = 'Terry\'s Scrap Yard',
        --coords = vector3(-457.82553100586,-2274.5856933594,8.5158166885376),
        coords = vector3(-575.54486083984,240.8359375,82.72395324707),
        deposited = false,
    },
    [2] = {
        name = 'Bean Machine',
        coords = vector3(-628.38208007812,239.23078918457,81.894218444824),
        deposited = false,
    }
}

function getG4SJobs(user_id)
    local collectionLocation
    local depositLocation
    local randomShop = math.random(1, #shops)
    local randomBank = math.random(2, #banks)
    local returnedTable = {}
    for k,v in pairs(shops) do
        if k == randomShop then
            returnedTable.collected=v.collected
            returnedTable.collecting=false
            returnedTable.collectionName=v.name
            returnedTable.collectionCoords=v.coords
        end
    end
    for k,v in pairs(banks) do
        if k == randomBank then
            returnedTable.deposited=v.deposited
            returnedTable.depositing=false
            returnedTable.depositName=v.name
            returnedTable.depositCoords=v.coords
        end
    end
    returnedTable.jobActive = false
    returnedTable.totalJobs = 0
    returnedTable.moneyInVehicle = false
    returnedTable.moneyOutVehicle = false
    currentG4SUsersOnJob[user_id].currentjob = returnedTable
    return returnedTable
end

RegisterServerEvent("ARMA:toggleShiftG4S")
AddEventHandler("ARMA:toggleShiftG4S", function(shiftStatus)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'G4S Driver') then
        if shiftStatus then
            local pin = math.random(1000,9999)
            currentG4SUsersOnJob[user_id] = {currentjob = ''}
            TriggerClientEvent('ARMA:startShiftG4S', source, pin)
            Wait(10000)
            TriggerClientEvent('ARMA:updateJobInformation', source, getG4SJobs(user_id))
        else
            TriggerClientEvent('ARMA:endShiftG4S', source)
        end
    else
        ARMAclient.notify(source, {"~r~Please visit City Hall and select the G4S Job."})
    end
end)

RegisterServerEvent("ARMA:acceptJob")
AddEventHandler("ARMA:acceptJob", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'G4S Driver') then
        for k,v in pairs(currentG4SUsersOnJob)do
            if k == user_id then
                v.currentjob.jobActive = true
                v.currentjob.totalJobs = v.currentjob.totalJobs + 1
                currentG4SUsersOnJob[user_id].currentjob = v.currentjob
                TriggerClientEvent('ARMA:updateJobInformation', source, v.currentjob)
            end
        end
    end
end)

RegisterServerEvent("ARMA:updateMoneyInVehicle")
AddEventHandler("ARMA:updateMoneyInVehicle", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'G4S Driver') then
        for k,v in pairs(currentG4SUsersOnJob)do
            if k == user_id then
                v.currentjob.collected = true
                v.currentjob.moneyInVehicle = true
                v.currentjob.moneyOutVehicle = false
                currentG4SUsersOnJob[user_id].currentjob = v.currentjob
            end
        end
    end
end)

RegisterServerEvent("ARMA:updateMoneyOutVehicle")
AddEventHandler("ARMA:updateMoneyOutVehicle", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, 'G4S Driver') then
        for k,v in pairs(currentG4SUsersOnJob)do
            if k == user_id then
                v.currentjob.moneyInVehicle = false
                v.currentjob.moneyOutVehicle = true
                currentG4SUsersOnJob[user_id].currentjob = v.currentjob
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        for k,v in pairs(currentG4SUsersOnJob)do
            if v.currentjob.jobActive then
                if not v.currentjob.collected then
                    if #(GetEntityCoords(GetPlayerPed(ARMA.getUserSource(k)))-v.currentjob.collectionCoords) < 1.5 then
                        TriggerClientEvent('ARMA:requestMoneyInVehicle', ARMA.getUserSource(k))
                    end
                elseif v.currentjob.moneyInVehicle and not v.currentjob.depositing and not v.currentjob.moneyOutVehicle then
                    if #(GetEntityCoords(GetPlayerPed(ARMA.getUserSource(k)))-v.currentjob.depositCoords) < 5 then
                        v.currentjob.depositing = true
                        print('set depositing to true')
                        currentG4SUsersOnJob[k].currentjob = v.currentjob
                        TriggerClientEvent('ARMA:requestMoneyOutVehicle', ARMA.getUserSource(k))
                    end
                elseif not v.currentjob.deposited and v.currentjob.moneyOutVehicle then
                    if #(GetEntityCoords(GetPlayerPed(ARMA.getUserSource(k)))-v.currentjob.depositCoords) < 1.5 then
                        print('give new job')
                        v.currentjob.deposited = true
                        v.currentjob.depositing = false
                        ARMA.giveBankMoney(k, math.random(8000,12000))
                        TriggerClientEvent('ARMA:updateJobInformation', ARMA.getUserSource(k), getG4SJobs(k))
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand('g4s', function(source, args)
    local source = source
    local user_id = ARMA.getUserId(source)
    -- check if they're in table
    for k,v in pairs(currentG4SUsersOnJob) do
        if k == user_id then
            TriggerClientEvent("ARMA:openG4SMenu", source)
        end
    end
end)


RegisterCommand('gog4s', function(source, args)
    local source = source
    ARMAclient.teleport(source, {-697.84259033203,271.23403930664,83.108764648438})
end)