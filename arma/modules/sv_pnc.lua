RegisterServerEvent('ARMA:checkForPolicewhitelist')
AddEventHandler('ARMA:checkForPolicewhitelist', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
        if ARMA.hasPermission(user_id, 'police.announce') then
            TriggerClientEvent('ARMA:openPNC', source, true, {}, {})
        else
            TriggerClientEvent('ARMA:openPNC', source, false, {}, {})
        end
    end
end)

RegisterServerEvent('ARMA:searchPerson')
AddEventHandler('ARMA:searchPerson', function(firstname, lastname)
    local source = source
    local user_id = ARMA.getUserId(source)
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
        exports['ghmattimysql']:execute("SELECT * FROM arma_user_identities WHERE firstname = @firstname AND name = @lastname", {firstname = firstname, lastname = lastname}, function(result) 
            if result ~= nil then
                local returnedUsers = {}
                for k,v in pairs(result) do
                    local user_id = result[k].user_id
                    local firstname = result[k].firstname
                    local lastname = result[k].name
                    local age = result[k].age
                    local phone = result[k].phone
                    local data = exports['ghmattimysql']:executeSync("SELECT * FROM arma_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
                    local licence = data.licence
                    local points = data.points
                    local ownedVehicles = exports['ghmattimysql']:executeSync("SELECT * FROM arma_user_vehicles WHERE user_id = @user_id", {user_id = user_id})
                    local actualVehicles = {}
                    for a,b in pairs(ownedVehicles) do 
                        table.insert(actualVehicles, b.vehicle)
                    end
                    local ownedProperties = exports['ghmattimysql']:executeSync("SELECT * FROM arma_user_homes WHERE user_id = @user_id", {user_id = user_id})
                    local actualHouses = {}
                    for a,b in pairs(ownedProperties) do 
                        table.insert(actualHouses, b.home)
                    end
                    table.insert(returnedUsers, {user_id = user_id, firstname = firstname, lastname = lastname, age = age, phone = phone, licence = licence, points = points, vehicles = actualVehicles, playerhome = actualHouses, warrants = {}, warning_markers = {}})
                end
                if next(returnedUsers) then
                    TriggerClientEvent('ARMA:sendSearcheduser', source, returnedUsers)
                else
                    TriggerClientEvent('ARMA:noPersonsFound', source)
                end
            end
        end)
    end
end)

RegisterServerEvent('ARMA:finePlayer')
AddEventHandler('ARMA:finePlayer', function(id, charges, amount, notes)
    local source = source
    local user_id = ARMA.getUserId(source)
    local amount = tonumber(amount)
    if amount > 250000 then
        amount = 250000
    end
    if ARMA.hasPermission(user_id, 'police.onduty.permission') then
        if ARMA.tryBankPayment(id, amount) then
            ARMA.giveBankMoney(user_id, amount*0.1)
            ARMAclient.notify(ARMA.getUserSource(id), {'~r~You have been fined £'..getMoneyStringFormatted(amount)..'.'})
            ARMAclient.notify(source, {'~g~You have received £'..getMoneyStringFormatted(math.floor(amount*0.1))..' for fining '..GetPlayerName(ARMA.getUserSource(id))..'.'})
            TriggerEvent('ARMA:addToCommunityPot', tonumber(amount))
            TriggerClientEvent('ARMA:verifyFineSent', true)
            -- add webhook for pd cord
            -- do notes later
        else
            TriggerClientEvent('ARMA:verifyFineSent', false, 'The player does not have enough money.')
        end
    end
end)


RegisterCommand('testad', function(source)
    for k,v in pairs(ARMA.getUsers()) do
        if ARMA.hasPermission(k, 'police.onduty.permission') then
            TriggerClientEvent('ARMA:notifyAD', v, 'Phase 3 Firearms', 'Red Vauxhall Corsa')
        end
    end
end)