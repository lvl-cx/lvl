dealership = {
    main = {{spawncode = "zoeesport", vehname = "Zoee Sport", vehdesc = "", price = 3000},
    {spawncode = "XADV", vehname = "XADV", vehdesc = "", price = 5000},
    {spawncode = "w115200d", vehname = "W115200D", vehdesc = "", price = 30000},
    {spawncode = "subwrx", vehname = "SubWRX", vehdesc = "", price = 15000},
    {spawncode = "sjtoyota", vehname = "SJ Toyota", vehdesc = "", price = 100000},
    {spawncode = "rs6", vehname = "RS6", vehdesc = "", price = 35000},
    {spawncode = "m13fortwo", vehname = "M13 Fortwo", vehdesc = "", price = 60000},
    {spawncode = "jcwc", vehname = "JCWC", vehdesc = "", price = 80000}, 
    {spawncode = "avalon", vehname = "Avalon", vehdesc = "", price = 5000},
    {spawncode = "al18", vehname = "AL18", vehdesc = "", price = 150000}},

    police = {{spawncode = "apex3", vehname = "VW APEX 3", vehdesc = "", price = 1},
    {spawncode = "audia4marked", vehname = "Audi A4 Marked", vehdesc = "", price = 1},
    {spawncode = "audia4unmarked", vehname = "Audi A4 Unmarked", vehdesc = "", price = 1},
    {spawncode = "polf150", vehname = "Offroad F150", vehdesc = "", price = 1},
    {spawncode = "pddirtbike", vehname = "PD Dirtbike", vehdesc = "", price = 1},
    {spawncode = "pbmw540i", vehname = "BMW 540i", vehdesc = "", price = 1},
    {spawncode = "pdbmwm5", vehname = "BMW M5", vehdesc = "", price = 1},
    {spawncode = "pdjagsuv", vehname = "Jaguar SUV", vehdesc = "", price = 1},
    {spawncode = "pdjagxfr", vehname = "Jaguar XFR", vehdesc = "", price = 1},
    {spawncode = "pdmarkedfocus", vehname = "Ford Focus", vehdesc = "", price = 1},
    {spawncode = "pdnissangtr", vehname = "Nissan GTR Unmarked", vehdesc = "", price = 1},
    {spawncode = "pdprior", vehname = "Audi Prior Unmarked", vehdesc = "", price = 1},
    {spawncode = "wf20", vehname = "Armed Van", vehdesc = "", price = 1}},

    rebel = {},
}

RegisterNetEvent('sendSimeons')
AddEventHandler('sendSimeons', function()
    user_id = ARMA.getUserId(source)
    local police = false
    local rebel = false
    if ARMA.hasPermission(user_id, 'police.menu') then 
        police = true
    end
    if ARMA.hasGroup(user_id, 'Rebel') then 
        rebel = true
    end
    TriggerClientEvent('returnSimeons', source, dealership, police, rebel)
end)


RegisterNetEvent('simeons:buy')
AddEventHandler('simeons:buy', function(vehicle, gtype)
    local correctcar = false 
    local wrongprice = false 
    local player = source
    local user_id = ARMA.getUserId(source)
    local playerName = GetPlayerName(source)   
    for k,v in pairs(dealership[gtype]) do
        if vehicle == v.spawncode then
            MySQL.query("ARMA/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
                if #pvehicle > 0 then
                    ARMAclient.notify(player,{"~r~Vehicle already owned."})
                else
                    if ARMA.tryFullPayment(user_id, v.price) then
                        ARMA.getUserIdentity(user_id, function(identity)
                            MySQL.execute("ARMA/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = "P "..identity.registration})
                        end)
                        ARMAclient.notify(player,{"You paid ~g~£"..v.price.."~w~ Check your garage for your vehicle."})
                        TriggerClientEvent("ARMA:PlaySound", player, 1)
                    else
                        ARMAclient.notify(player,{"~r~Not enough money."})
                        TriggerClientEvent("ARMA:PlaySound", player, 2)
                    end
                end
            end)
        end
    end
end)
