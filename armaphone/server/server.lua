local Tunnel = module("arma", "lib/Tunnel")
local Proxy = module("arma", "lib/Proxy")
local htmlEntities = module("lib/htmlEntities")

ARMA = Proxy.getInterface("ARMA")
ARMAclient = Tunnel.getInterface("ARMA", "gcphone")

math.randomseed(os.time()) 

function getPhoneRandomNumber()
    return '0' .. math.random(600000000,699999999)
end


--====================================================================================
--  Utils
--====================================================================================
function getSourceFromIdentifier(identifier, cb)
    return ARMA.getUserSource({identifier})
end
function getNumberPhone(identifier)
    local result = MySQL.Sync.fetchAll("SELECT arma_user_identities.phone FROM arma_user_identities WHERE arma_user_identities.user_id = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone
    end
    return nil
end
function getIdentifierByPhoneNumber(phone_number) 
    local result = MySQL.Sync.fetchAll("SELECT arma_user_identities.user_id FROM arma_user_identities WHERE arma_user_identities.phone = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].user_id
    end
    return nil
end


function getPlayerID(source)
    local player = ARMA.getUserId({source})
    return player
end
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end


function getOrGeneratePhoneNumber (sourcePlayer, identifier, cb)
    local sourcePlayer = sourcePlayer
    local identifier = identifier
    local myPhoneNumber = getNumberPhone(identifier)
    if myPhoneNumber == '0' or myPhoneNumber == nil then
        repeat
            myPhoneNumber = getPhoneRandomNumber()
            local id = getIdentifierByPhoneNumber(myPhoneNumber)
        until id == nil
        MySQL.Async.insert("UPDATE arma_user_identities SET phone = @myPhoneNumber WHERE user_id = @identifier", { 
            ['@myPhoneNumber'] = myPhoneNumber,
            ['@identifier'] = identifier
        }, function ()
            cb(myPhoneNumber)
        end)
    else
        cb(myPhoneNumber)
    end
end
--====================================================================================
--  Contacts
--====================================================================================
function getContacts(identifier)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_users_contacts WHERE phone_users_contacts.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    return result
end
function addContact(source, identifier, number, display)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("INSERT INTO phone_users_contacts (`identifier`, `number`,`display`) VALUES(@identifier, @number, @display)", {
        ['@identifier'] = identifier,
        ['@number'] = number,
        ['@display'] = display,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end
function updateContact(source, identifier, id, number, display)
    local sourcePlayer = tonumber(source)
    MySQL.Async.insert("UPDATE phone_users_contacts SET number = @number, display = @display WHERE id = @id", { 
        ['@number'] = number,
        ['@display'] = display,
        ['@id'] = id,
    },function()
        notifyContactChange(sourcePlayer, identifier)
    end)
end
function deleteContact(source, identifier, id)
    local sourcePlayer = tonumber(source)
    MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier AND `id` = @id", {
        ['@identifier'] = identifier,
        ['@id'] = id,
    })
    notifyContactChange(sourcePlayer, identifier)
end
function deleteAllContact(identifier)
    MySQL.Sync.execute("DELETE FROM phone_users_contacts WHERE `identifier` = @identifier", {
        ['@identifier'] = identifier
    })
end
function notifyContactChange(source, identifier)
    local sourcePlayer = tonumber(source)
    local identifier = identifier
    if sourcePlayer ~= nil then 
        TriggerClientEvent("ARMA:contactList", sourcePlayer, getContacts(identifier))
    end
end

RegisterServerEvent('ARMA:addContact')
AddEventHandler('ARMA:addContact', function(display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addContact(sourcePlayer, identifier, phoneNumber, display)
end)

RegisterServerEvent('ARMA:updateContact')
AddEventHandler('ARMA:updateContact', function(id, display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    updateContact(sourcePlayer, identifier, id, phoneNumber, display)
end)

RegisterServerEvent('ARMA:deleteContact')
AddEventHandler('ARMA:deleteContact', function(id)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteContact(sourcePlayer, identifier, id)
end)

--====================================================================================
--  Messages
--====================================================================================
function getMessages(identifier)
    local result = MySQL.Sync.fetchAll("SELECT phone_messages.* FROM phone_messages LEFT JOIN arma_user_identities ON arma_user_identities.user_id = @identifier WHERE phone_messages.receiver = arma_user_identities.phone", {
         ['@identifier'] = identifier
    })
    return result
    --return MySQLQueryTimeStamp("SELECT phone_messages.* FROM phone_messages LEFT JOIN users ON users.identifier = @identifier WHERE phone_messages.receiver = users.phone_number", {['@identifier'] = identifier})
end

RegisterServerEvent('ARMA:_internalAddMessage')
AddEventHandler('ARMA:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)

function _internalAddMessage(transmitter, receiver, message, owner)
    local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);"
    local Query2 = 'SELECT * from phone_messages WHERE `id` = @id;'
	local Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    }
    local id = MySQL.Sync.insert(Query, Parameters)
    return MySQL.Sync.fetchAll(Query2, {
        ['@id'] = id
    })[1]
end

function addMessage(source, identifier, phone_number, message)
    local sourcePlayer = tonumber(source)
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)
    if otherIdentifier ~= nil and ARMA.getUserSource({otherIdentifier}) ~= nil then 
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
        TriggerClientEvent("ARMA:receiveMessage", tonumber(ARMA.getUserSource({otherIdentifier})), tomess)
    end
    local memess = _internalAddMessage(phone_number, myPhone, message, 1)
    TriggerClientEvent("ARMA:receiveMessage", sourcePlayer, memess)
end

function setReadMessageNumber(identifier, num)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", { 
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
end

function deleteMessage(msgId)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
end

function deleteAllMessageFromPhoneNumber(source, identifier, phone_number)
    local source = source
    local identifier = identifier
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number})
end

function deleteAllMessage(identifier)
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
end

RegisterServerEvent('ARMA:sendMessage')
AddEventHandler('ARMA:sendMessage', function(phoneNumber, message)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addMessage(sourcePlayer, identifier, phoneNumber, message)
end)

RegisterServerEvent('ARMA:deleteMessage')
AddEventHandler('ARMA:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('ARMA:deleteMessageNumber')
AddEventHandler('ARMA:deleteMessageNumber', function(number)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessageFromPhoneNumber(sourcePlayer,identifier, number)
    -- TriggerClientEvent("ARMA:allMessage", sourcePlayer, getMessages(identifier))
end)

RegisterServerEvent('ARMA:deleteAllMessage')
AddEventHandler('ARMA:deleteAllMessage', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
end)

RegisterServerEvent('ARMA:setReadMessageNumber')
AddEventHandler('ARMA:setReadMessageNumber', function(num)
    local identifier = getPlayerID(source)
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('ARMA:deleteALL')
AddEventHandler('ARMA:deleteALL', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
    deleteAllContact(identifier)
    appelsDeleteAllHistorique(identifier)
    TriggerClientEvent("ARMA:contactList", sourcePlayer, {})
    TriggerClientEvent("ARMA:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

AddEventHandler('ARMA:deleteALLARMAIdentity', function(src,user_id,num)
    deleteAllMessage(user_id)
    deleteAllContact(user_id)
    appelsDeleteAllHistorique(user_id)
    TriggerClientEvent("ARMA:contactList", src, {})
    TriggerClientEvent("ARMA:allMessage", src, {})
    TriggerClientEvent("appelsDeleteAllHistorique", src, {})
    TriggerClientEvent("ARMA:myPhoneNumber", src, num) -- update phonenumber
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall (num)
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
        ['@num'] = num
    })
    return result
end

function sendHistoriqueCall (src, num) 
    local histo = getHistoriqueCall(num)
    TriggerClientEvent('ARMA:historiqueCall', src, histo)
end

function saveAppels (appelInfo)
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.transmitter_num,
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            mun = "###-####"
        end
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('ARMA:getHistoriqueCall')
AddEventHandler('ARMA:getHistoriqueCall', function()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    sendHistoriqueCall(sourcePlayer, num)
end)


RegisterServerEvent('ARMA:internal_startCall')
AddEventHandler('ARMA:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    if FixePhone[phone_number] ~= nil then
        onCallFixePhone(source, phone_number, rtcOffer, extraData)
        return
    end
    
    local rtcOffer = rtcOffer
    if phone_number == nil or phone_number == '' then 
        print('BAD CALL NUMBER IS NIL')
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end
    local destPlayer = getIdentifierByPhoneNumber(phone_number)
    local is_valid = destPlayer ~= nil and destPlayer ~= srcIdentifier
    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = destPlayer ~= nil,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData
    }
    

    if is_valid == true then
        -- getSourceFromIdentifier(destPlayer, function (srcTo)
        if ARMA.getUserSource({destPlayer}) ~= nil then
            srcTo = tonumber(ARMA.getUserSource({destPlayer}))

            if srcTo ~= nil then
                AppelsEnCours[indexCall].receiver_src = srcTo
                -- TriggerEvent('ARMA:addCall', AppelsEnCours[indexCall])
                TriggerClientEvent('ARMA:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                TriggerClientEvent('ARMA:waitingCall', srcTo, AppelsEnCours[indexCall], false)
            else
                -- TriggerEvent('ARMA:addCall', AppelsEnCours[indexCall])
                TriggerClientEvent('ARMA:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
            end
        end
    else
        TriggerEvent('ARMA:addCall', AppelsEnCours[indexCall])
        TriggerClientEvent('ARMA:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
    end

end)

RegisterServerEvent('ARMA:startCall')
AddEventHandler('ARMA:startCall', function(phone_number, rtcOffer, extraData)
    TriggerEvent('ARMA:internal_startCall',source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('ARMA:candidates')
AddEventHandler('ARMA:candidates', function (callId, candidates)
    -- print('send cadidate', callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then 
            to = AppelsEnCours[callId].receiver_src
        end
        -- print('TO', to)
        TriggerClientEvent('ARMA:candidates', to, candidates)
    end
end)


RegisterServerEvent('ARMA:acceptCall')
AddEventHandler('ARMA:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('ARMA:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	    SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('ARMA:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	    end)
            saveAppels(AppelsEnCours[id])
        end
    end
end)




RegisterServerEvent('ARMA:rejectCall')
AddEventHandler('ARMA:rejectCall', function (infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('ARMA:rejectCall', AppelsEnCours[id].transmitter_src)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('ARMA:rejectCall', AppelsEnCours[id].receiver_src)
        end

        if AppelsEnCours[id].is_accepts == false then 
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('ARMA:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('ARMA:appelsDeleteHistorique')
AddEventHandler('ARMA:appelsDeleteHistorique', function (numero)
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
end)

function appelsDeleteAllHistorique(srcIdentifier)
    local srcPhone = getNumberPhone(srcIdentifier)
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
end

RegisterServerEvent('ARMA:appelsDeleteAllHistorique')
AddEventHandler('ARMA:appelsDeleteAllHistorique', function ()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    appelsDeleteAllHistorique(srcIdentifier)
end)










































--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler("ARMA:playerSpawn",function(user_id, source, first_spawn)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
        TriggerClientEvent("ARMA:myPhoneNumber", sourcePlayer, myPhoneNumber)
        TriggerClientEvent("ARMA:contactList", sourcePlayer, getContacts(identifier))
        TriggerClientEvent("ARMA:allMessage", sourcePlayer, getMessages(identifier))
    end)
    local bankM = ARMA.getBankMoney({user_id})
    TriggerClientEvent('ARMA:setAccountMoney',source,bankM)
end)

-- Just For reload
RegisterServerEvent('ARMA:allUpdate')
AddEventHandler('ARMA:allUpdate', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    local num = getNumberPhone(identifier)
    TriggerClientEvent("ARMA:myPhoneNumber", sourcePlayer, num)
    TriggerClientEvent("ARMA:contactList", sourcePlayer, getContacts(identifier))
    TriggerClientEvent("ARMA:allMessage", sourcePlayer, getMessages(identifier))
    sendHistoriqueCall(sourcePlayer, num)
end)


AddEventHandler('onMySQLReady', function ()
    -- MySQL.Async.fetchAll("DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)")
end)

--====================================================================================
--  App ... WIP
--====================================================================================


-- SendNUIMessage('ongcPhoneRTC_receive_offer')
-- SendNUIMessage('ongcPhoneRTC_receive_answer')

-- RegisterNUICallback('gcPhoneRTC_send_offer', function (data)


-- end)


-- RegisterNUICallback('gcPhoneRTC_send_answer', function (data)


-- end)



function onCallFixePhone (source, phone_number, rtcOffer, extraData)
    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        srcPhone = getNumberPhone(srcIdentifier)
    end

    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = false,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData,
        coords = FixePhone[phone_number].coords
    }
    
    PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

    TriggerClientEvent('ARMA:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('ARMA:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end



function onAcceptFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    
    AppelsEnCours[id].receiver_src = source
    if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
        AppelsEnCours[id].is_accepts = true
        AppelsEnCours[id].forceSaveAfter = true
        AppelsEnCours[id].rtcAnswer = rtcAnswer
        PhoneFixeInfo[id] = nil
        TriggerClientEvent('ARMA:notifyFixePhoneChange', -1, PhoneFixeInfo)
        TriggerClientEvent('ARMA:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
	SetTimeout(1000, function() -- change to +1000, if necessary.
       		TriggerClientEvent('ARMA:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
	end)
        saveAppels(AppelsEnCours[id])
    end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    PhoneFixeInfo[id] = nil
    TriggerClientEvent('ARMA:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('ARMA:rejectCall', AppelsEnCours[id].transmitter_src)
    if AppelsEnCours[id].is_accepts == false then
        saveAppels(AppelsEnCours[id])
    end
    AppelsEnCours[id] = nil
    
end