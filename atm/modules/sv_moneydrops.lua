local lang = ATM.lang
local MoneydropEntities = {}

function tATM.MoneyDrop()
    local source = source
    Wait(100) -- wait delay for death.
    local user_id = ATM.getUserId(source)
    local model = GetHashKey('prop_poly_bag_money')
    local name1 = GetPlayerName(source)
    local moneydrop = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)) + 0.4, true, true, false)
    local moneydropnetid = NetworkGetNetworkIdFromEntity(moneydrop)
    MoneydropEntities[moneydropnetid] = {moneydrop, moneydrop, false, source}
    MoneydropEntities[moneydropnetid].Money = {}
    local ndata = ATM.getUserDataTable(user_id)
    local money = ATM.getMoney(user_id)
    local stored_inventory = nil;
    if ATM.tryPayment(user_id,money) then
        MoneydropEntities[moneydropnetid].Money = money
    end
end

    RegisterNetEvent('ATM:Moneydrop')
    AddEventHandler('ATM:Moneydrop', function(netid)
        local source = source
        if MoneydropEntities[netid] and not MoneydropEntities[netid][3] and #(GetEntityCoords(MoneydropEntities[netid][1]) - GetEntityCoords(GetPlayerPed(source))) < 10.0 then
            MoneydropEntities[netid][3] = true;
            local user_id = ATM.getUserId(source)
            if user_id ~= nil then
        
                TriggerClientEvent("ATM:MoneyNotInBag",source)
                if MoneydropEntities[netid].Money ~= 0 then
                    --print("YES")
                    ATM.giveMoney(user_id,MoneydropEntities[netid].Money)
                    ATMclient.notify(source,{"~g~You have taken £"..tonumber(MoneydropEntities[netid].Money)})
                    MoneydropEntities[netid].Money = 0
                else
                    --print("NO")
                end
            else
                ATMclient.notify(source,{"~r~The money drop is already being taken"})

            end
        end
    end)

    -- Get rid of looted moneydrops
    Citizen.CreateThread(function()
        while true do 
            Wait(100)
            for i,v in pairs(MoneydropEntities) do 
                if v.Money == 0 then
                    if DoesEntityExist(v[1]) then 
                        DeleteEntity(v[1])

                        MoneydropEntities[i] = nil;
                    end
                end
            end
        end
    end)