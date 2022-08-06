local currenttests = {}
local dvsamodule = module("cfg/cfg_dvsa")
function dvsaUpdate(user_id)
    local source = ARMA.getUserSource(user_id)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM arma_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    local licence = {}
    local date = 0
    if data.date == nil then date = 0 end
    if data.date ~= nil then
        date = tonumber(data.date) / 1000
        date = os.date('%Y-%m-%d', date)
    end
    if data ~= nil then
        licence = {
            ["banned"] = data.licence == "banned",
            ["full"] = data.licence == "full",
            ["active"] = data.licence == "active",
            ["points"] = data.points or 0,
            ["id"] = data.id or "No Licence",
            ["date"] = date or os.date("%d/%m/%Y")
        }
    end
    TriggerClientEvent('ARMA:updateDvsaData',source,licence,{},data.testsaves,nil)
end
RegisterServerEvent("ARMA:dvsaBucket")
AddEventHandler("ARMA:dvsaBucket", function(bool)
    local source = source
    local user_id = ARMA.getUserId(source)
    if bool then
        if currenttests[user_id] ~= nil then
            ARMAclient.notify(source,{'~r~You already have a test in progress.'})
            return
        end
        local bucket = math.random(21,300)
        local highestcount = 21
        if table.count(currenttests) > 0 then
            for k,v in pairs(currenttests) do
                if v.bucket == bucket then
                    repeat highestcount = math.random(21,300) until highestcount ~= bucket
                end
            end
        end
        currenttests[user_id] = {
            ["bucket"] = highestcount
        }
        SetPlayerRoutingBucket(source,21)
    elseif not bool then
        if currenttests[user_id] ~= nil then
            currenttests[user_id] = nil
        else
            ARMAclient.notify(source,{'~r~You do not have a test in progress.'})
            return
        end
        SetPlayerRoutingBucket(source,0)
    end
end)
RegisterServerEvent("ARMA:candidatePassed")
AddEventHandler("ARMA:candidatePassed", function(seriousissues,minorissues,U)
    local licencetype = {
        ["banned"] = false,
        ["active"] = false,
        ["full"] = false
    }
    local testsaves = {
        ["Result"] = "Passed",
        ["Date"] = os.date("%A (%d/%m/%Y) at %X"),
        ["Serious Issues"] = seriousissues,
        ["Minor Issues"] = minorissues
    }
    local source = source
    local newlicence = "active"
    local licence
    local user_id = ARMA.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM arma_dvsa WHERE user_id = @user_id', {user_id = user_id}, function(GotLicence)
        licence = GotLicence[1].licence
        if licence == "active" then
            exports['ghmattimysql']:execute("INSERT INTO arma_dvsa (user_id,licence,testsaves) VALUES(@user_id,@licence,@testsaves)", {user_id = user_id,licence = "full",testsaves=testsaves}, function() end)
            licence = "full"
            if licence == "full" then
                licencetype.banned = false
                licencetype.active = false
                licencetype.full = true
            end
            if licence == "active" then
                licencetype.banned = false
                licencetype.active = true
                licencetype.full = false
            end
            if licence == "banned" then
                licencetype.banned = true
                licencetype.active = false
                licencetype.full = false
            end
            TriggerClientEvent('ARMA:updateDvsaData', source,licencetype,nil,nil,nil)
        else
            ARMAclient.notify(source,{"~r~You already have a licence."})
        end
    end)
end)
RegisterServerEvent("ARMA:candidateFailed")
AddEventHandler("ARMA:candidateFailed", function(seriousissues,minorissues,V,U)    
    local localday = os.date("%A (%d/%m/%Y) at %X")
    local licencetype = {
        ["banned"] = false,
        ["active"] = true,
        ["full"] = false
    }
    local testsaves = {
        ["Result"] = "Passed",
        ["Date"] = localday,
        ["Serious Issues"] = seriousissues,
        ["Minor Issues"] = minorissues
    }
    local source = source
    local licence
    local user_id = ARMA.getUserId(source)
    exports['ghmattimysql']:execute("INSERT INTO arma_dvsa (user_id,testsaves) VALUES(@user_id,@testsaves)", {user_id = user_id,testsaves=testsaves}, function() end)
end)
RegisterServerEvent("ARMA:beginTest")
AddEventHandler("ARMA:beginTest", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM arma_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data.licence == ("full" or "banned") then
        TriggerClientEvent('ARMA:beginTestClient', source, false)
        return
    end
    if data.licence == "active" then
        TriggerClientEvent('ARMA:beginTestClient', source,true,math.random(1,3))
    else
        --ac ban
    end
end)
RegisterServerEvent("ARMA:surrenderLicence")
AddEventHandler("ARMA:surrenderLicence", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local uuid = math.random(1,9999999999)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM arma_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data.licence == "banned" then
        ARMAclient.notify(source,{'~r~You are already banned from driving.'})
        --ac ban
        return
    end
    if data.licence == ("active" or "full" or "none") then
        exports['ghmattimysql']:execute("UPDATE arma_dvsa SET licence = @licence WHERE user_id = @user_id", {licence = "none", user_id = user_id})
        exports['ghmattimysql']:execute("UPDATE arma_dvsa SET id = @id WHERE user_id = @user_id", {id = uuid, user_id = user_id})
    end
    Wait(100)
    dvsaUpdate(user_id)
end)
RegisterServerEvent("ARMA:activateLicence")
AddEventHandler("ARMA:activateLicence", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local uuid = math.random(1,9999999999)
    local data = exports['ghmattimysql']:executeSync("SELECT * FROM arma_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data == nil then return end
    if data.licence == "none" then
        exports['ghmattimysql']:execute("UPDATE arma_dvsa SET licence = @licence WHERE user_id = @user_id", {licence = "active", user_id = user_id})
        exports['ghmattimysql']:execute("UPDATE arma_dvsa SET id = @id WHERE user_id = @user_id", {id = uuid, user_id = user_id})
        Wait(100)
        dvsaUpdate(user_id)
    end
end)
RegisterServerEvent("ARMA:speedCameraFlashServer",function(speed)
    local source = source
    local user_id = ARMA.getUserId(source)
    local name = GetPlayerName(source)
    local bank = ARMA.getBankMoney(user_id)
    local speed = tonumber(speed)
    local overspeed = speed-180
    local fine = 5000
    if ARMA.hasPermission(user_id,"police.menu") then
        return
    end
    if tonumber(bank) > 5000 then
        ARMA.setBankMoney(user_id,bank-5000)
        TriggerClientEvent('ARMA:dvsaMessage', source,"DVSA","UK Government","You were fined £"..fine.." for going "..overspeed.."MPH over the speed limit.")
        return
    else
        ARMAclient.notify(source,{'~r~You could not afford the fine. Benefits paid.'})
        return
    end
end)

RegisterServerEvent("ARMA:gettingDVSAData")
AddEventHandler("ARMA:gettingDVSAData", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    exports['ghmattimysql']:execute("SELECT * FROM arma_dvsa WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    local data1 = {}
                    local licence = {}
                    local date = 0
                    local updateddata = exports['ghmattimysql']:executeSync("SELECT * FROM arma_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
                    if updateddata.date == nil then date = 0 end
                    if updateddata.date ~= nil then
                        date = tonumber(updateddata.date) / 1000
                        date = os.date('%Y-%m-%d', date)
                    end
                    if updateddata ~= nil then
                        licence = {
                            ["banned"] = updateddata.licence == "banned",
                            ["full"] = updateddata.licence == "full",
                            ["active"] = updateddata.licence == "active",
                            ["points"] = updateddata.points or 0,
                            ["id"] = updateddata.id or "No Licence",
                            ["date"] = date or os.date("%d/%m/%Y")
                        }
                    end
                    TriggerClientEvent('ARMA:dvsaData',source,licence,data1,updateddata.testsaves,nil)
                    return
                end
            end
            exports['ghmattimysql']:execute("INSERT INTO arma_dvsa (user_id,licence,datelicence) VALUES (@user_id, 'none',"..os.date("%d/%m/%Y")..")", {user_id = user_id})
            local data1 = {}
            local licence = {}
            local date = 0
            local updateddata = exports['ghmattimysql']:executeSync("SELECT * FROM arma_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
            if updateddata.date == nil then date = 0 end
            if updateddata.date ~= nil then
                date = tonumber(updateddata.date) / 1000
                date = os.date('%Y-%m-%d', date)
            end
            if updateddata ~= nil then
                licence = {
                    ["banned"] = updateddata.licence == "banned",
                    ["full"] = updateddata.licence == "full",
                    ["active"] = updateddata.licence == "active",
                    ["points"] = updateddata.points or 0,
                    ["id"] = updateddata.id or "No Licence",
                    ["date"] = date or os.date("%d/%m/%Y")
                }
            end
            TriggerClientEvent('ARMA:dvsaData',source,licence,data1,updateddata.testsaves,nil)
        end
    end)
end)