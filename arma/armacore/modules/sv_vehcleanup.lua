local CheckTime = 1
deleteTime = 30 --Seconds

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(600000)
        VehCleanup()
	end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(3600000)
        entityCleanup()
	end
end)


function VehCleanup()
    TriggerClientEvent("ARMA:VehicleCleanup", -1)
end

function entityCleanup()
    TriggerClientEvent("ARMA:EntityCleanup", -1)
end

RegisterNetEvent('ARMA:CleanAllAuto')
AddEventHandler('ARMA:CleanAllAuto', function()
        for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
            print(v)
        end
        for i,v in pairs(GetAllPeds()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllObjects()) do
            DeleteEntity(v)
    end
end)