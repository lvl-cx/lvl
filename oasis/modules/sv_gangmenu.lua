RegisterServerEvent("OASIS:GetGangData")
AddEventHandler("OASIS:GetGangData", function()
    local source=source
    local newarray = nil
    local peoplesids = {}
    local user_id=OASIS.getUserId(source)
    local gangmembers ={}
    local gangpermission
    exports['ghmattimysql']:execute('SELECT * FROM oasis_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    newarray={}
                    newarray["money"] = V.funds
                    isingang = true
                    newarray["id"] = V.gangname
                    gangpermission = L.gangPermission
                    for U,D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermission)
                    end
                    exports['ghmattimysql']:execute('SELECT * FROM oasis_users', function(gotUser)
                        for J,G in pairs(gotUser) do
                            if peoplesids[tostring(G.id)] ~= nil then
                                table.insert(gangmembers,{G.username,tonumber(G.id),peoplesids[tostring(G.id)]})
                            end
                        end
                        TriggerClientEvent('OASIS:GotGangData', source,newarray,gangmembers,gangpermission)
                    end)
                    break
                end
            end
        end
    end)
end)
RegisterServerEvent("OASIS:CreateGang")
AddEventHandler("OASIS:CreateGang", function(gangname)
    local source=source
    local user_id=OASIS.getUserId(source)
    local user_name = GetPlayerName(source)
    local funds = 0 
    local logs = "NOTHING"
    exports['ghmattimysql']:execute('SELECT gangname FROM oasis_gangs WHERE gangname = @gangname', {gangname = gangname}, function(gotGang)
        if not OASIS.hasGroup(user_id,"Gang") then
            OASISclient.notify(source,{"~r~You do not have a gang license."})
            return
        end
        if json.encode(gotGang) ~= "[]" and gotGang ~= nil and json.encode(gotGang) ~= nil then
            OASISclient.notify(source,{"~r~Gang name is already in use."})
            return
        end
        local gangmembers = {
            [tostring(user_id)] = {
                ["rank"] = 4,
                ["gangPermission"] = 4,
            },
        }
        gangmembers = json.encode(gangmembers)
        OASISclient.notify(source,{"~g~"..gangname.." created."})
        exports['ghmattimysql']:execute("INSERT INTO oasis_gangs (gangname,gangmembers,funds,logs) VALUES(@gangname,@gangmembers,@funds,@logs)", {gangname=gangname,gangmembers=gangmembers,funds=funds,logs=logs}, function() end)
        TriggerClientEvent('OASIS:gangNameNotTaken', source)
        TriggerClientEvent('OASIS:ForceRefreshData', -1)
    end)
end)
RegisterServerEvent("OASIS:addUserToGang")
AddEventHandler("OASIS:addUserToGang", function(ganginvite,playerid)
    local source=source
    local user_id=OASIS.getUserId(source)
    local playersource = OASIS.getUserSource(playerid)
    exports['ghmattimysql']:execute('SELECT * FROM oasis_gangs WHERE gangname = @gangname', {gangname = ganginvite}, function(G)
        if json.encode(G) == "[]" and G == nil and json.encode(G) == nil then
            OASISclient.notify(playersource,{"~r~Gang no longer exists."})
            return
        end
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            array[tostring(playerid)] = {["rank"] = 1,["gangPermission"] = 1}
            exports['ghmattimysql']:execute("UPDATE oasis_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers = json.encode(array), gangname = ganginvite}, function()
                TriggerClientEvent('OASIS:ForceRefreshData', -1)
            end)
        end
    end)
end)
RegisterServerEvent("OASIS:depositGangBalance")
AddEventHandler("OASIS:depositGangBalance", function(amount)
    local source = source
    local user_id = OASIS.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    exports['ghmattimysql']:execute('SELECT * FROM oasis_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        OASISclient.notify(source,{"~r~Invalid Amount"})
                        return
                    end
                    if tonumber(OASIS.getMoney(user_id)) < tonumber(amount) then
                        OASISclient.notify(source,{"~r~Not enough cash."})
                    else
                        OASIS.setMoney(user_id,tonumber(OASIS.getMoney(user_id))-tonumber(amount))
                        OASISclient.notify(source,{"~g~Deposited £"..getMoneyStringFormatted(amount)})
                        local newamount = tonumber(amount)+tonumber(funds)
                        local tax = tonumber(amount)*0.02
                        -- put webhook here for deposit
                        exports['ghmattimysql']:execute("UPDATE oasis_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount)-tostring(tax), gangname = gangname}, function()
                            TriggerClientEvent('OASIS:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
    TriggerClientEvent('OASIS:ForceRefreshData', source)
end)
RegisterServerEvent("OASIS:depositAllGangBalance")
AddEventHandler("OASIS:depositAllGangBalance", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    local amount = OASIS.getMoney(user_id)
    exports['ghmattimysql']:execute('SELECT * FROM oasis_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local funds = V.funds
                    local gangname = V.gangname
                    if tonumber(amount) < 0 then
                        OASISclient.notify(source,{"~r~Invalid Amount"})
                        return
                    end
                    OASIS.setMoney(user_id,tonumber(OASIS.getMoney(user_id))-tonumber(amount))
                    OASISclient.notify(source,{"~g~Deposited £"..getMoneyStringFormatted(amount)})
                    local newamount = tonumber(amount)+tonumber(funds)
                    local tax = tonumber(amount)*0.02
                    -- put webhook here for deposit all
                    exports['ghmattimysql']:execute("UPDATE oasis_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount)-tostring(tax), gangname = gangname}, function()
                        TriggerClientEvent('OASIS:ForceRefreshData', -1)
                    end)
                end
            end
        end
    end)
    TriggerClientEvent('OASIS:ForceRefreshData', source)
end)

local gangWithdraw = {}
RegisterServerEvent("OASIS:withdrawGangBalance")
AddEventHandler("OASIS:withdrawGangBalance", function(amount)
    local source = source
    local user_id = OASIS.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    if not gangWithdraw[source] then
        gangWithdraw[source] = true
        exports['ghmattimysql']:execute('SELECT * FROM oasis_gangs', function(gotGangs)
            for K,V in pairs(gotGangs) do
                local array = json.decode(V.gangmembers)
                for I,L in pairs(array) do
                    if tostring(user_id) == I then
                        local funds = V.funds
                        local gangname = V.gangname
                        if tonumber(amount) < 0 then
                            OASISclient.notify(source,{"~r~Invalid Amount"})
                            return
                        end
                        if tonumber(funds) < tonumber(amount) then
                            OASISclient.notify(source,{"~r~Invalid Amount."})
                        else
                            OASIS.setMoney(user_id,tonumber(OASIS.getMoney(user_id))+tonumber(amount))
                            OASISclient.notify(source,{"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                            local newamount = tonumber(funds)-tonumber(amount)
                            -- put webhook here for withdraw
                            exports['ghmattimysql']:execute("UPDATE oasis_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount), gangname = gangname}, function()
                                TriggerClientEvent('OASIS:ForceRefreshData', -1)
                            end)
                        end
                    end
                end
            end
            gangWithdraw[source] = nil
        end)
    end
    TriggerClientEvent('OASIS:ForceRefreshData', source)
end)
RegisterServerEvent("OASIS:withdrawAllGangBalance")
AddEventHandler("OASIS:withdrawAllGangBalance", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    local name = GetPlayerName(source)
    local date = os.date("%d/%m/%Y at %X")
    if not gangWithdraw[source] then
        gangWithdraw[source] = true
        exports['ghmattimysql']:execute('SELECT * FROM oasis_gangs', function(gotGangs)
            for K,V in pairs(gotGangs) do
                local array = json.decode(V.gangmembers)
                for I,L in pairs(array) do
                    if tostring(user_id) == I then
                        local funds = V.funds
                        local gangname = V.gangname
                        local amount = V.funds
                        if tonumber(funds) < 1 then
                            OASISclient.notify(source,{"~r~Invalid Amount."})
                        else
                            OASIS.setMoney(user_id,tonumber(OASIS.getMoney(user_id))+tonumber(amount))
                            OASISclient.notify(source,{"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                            -- put webhook here for withdraw all
                            exports['ghmattimysql']:execute("UPDATE oasis_gangs SET funds = @funds WHERE gangname=@gangname", {funds = tostring(newamount), gangname = gangname}, function()
                                TriggerClientEvent('OASIS:ForceRefreshData', -1)
                            end)
                        end
                    end
                end
            end
            gangWithdraw[source] = nil
        end)
    end
    TriggerClientEvent('OASIS:ForceRefreshData', source)
end)
RegisterServerEvent("OASIS:PromoteUser")
AddEventHandler("OASIS:PromoteUser", function(gangid,memberid)
    local source = source
    local user_id=OASIS.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM oasis_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank >= 4 then
                        local rank = array[tostring(memberid)].rank
                        local gangpermission = array[tostring(memberid)].gangPermission
                        if rank < 4 and gangpermission < 4 and tostring(user_id) ~= I then
                            OASISclient.notify(source,{"~r~Only can Leader can promote."})
                            return
                        end
                        if array[tostring(memberid)].rank == 3 and gangpermission == 3 and tostring(user_id) == I then
                            OASISclient.notify(source,{"~r~There can only be 1 leader in each gang."})
                            return
                        end
                        if tonumber(memberid) == tonumber(user_id) and rank == 4 and gangpermission == 4 then
                            OASISclient.notify(source,{"~r~You are the highest rank."})
                            return
                        end 
                        array[tostring(memberid)].gangPermission = tonumber(gangpermission)+1
                        array[tostring(memberid)].rank = tonumber(rank)+1
                        array = json.encode(array)
                        exports['ghmattimysql']:execute("UPDATE oasis_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('OASIS:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("OASIS:DemoteUser")
AddEventHandler("OASIS:DemoteUser", function(gangid,memberid)
    local source = source
    local user_id=OASIS.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM oasis_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    if L.rank >= 4 then
                        local rank = array[tostring(memberid)].rank
                        local gangpermission = array[tostring(memberid)].gangPermission
                        if rank == 4 or gangpermission == 4 then
                            OASISclient.notify(source,{"~r~Cannot demote the leader"})
                            return
                        end
                        if rank == 1 and gangpermission == 1 then
                            OASISclient.notify(source,{"~r~Member is already the lowest rank."})
                            return
                        end
                        array[tostring(memberid)].rank = tonumber(rank)-1
                        array[tostring(memberid)].gangPermission = tonumber(gangpermission)-1
                        array = json.encode(array)
                        exports['ghmattimysql']:execute("UPDATE oasis_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('OASIS:ForceRefreshData', -1)
                        end)
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("OASIS:kickMemberFromGang")
AddEventHandler("OASIS:kickMemberFromGang", function(gangid,member)
    local source = source
    local user_id = OASIS.getUserId(source)
    local membersource = OASIS.getUserSource(member)
    if membersource == nil then
        membersource = 0
    end
    local membergang = ""
    exports['ghmattimysql']:execute('SELECT * FROM oasis_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local memberrank = array[tostring(member)].rank
                    local rank = array[tostring(user_id)].rank
                    if tonumber(member) == tonumber(user_id) then
                        OASISclient.notify(source,{"~r~You cannot kick yourself."})
                        return
                    end
                    if tonumber(memberrank) >= rank then
                        OASISclient.notify(source,{"~r~You do not have permission to kick this member from the gang."})
                        return
                    end
                    array[tostring(member)] = nil
                    array = json.encode(array)
                    OASISclient.notify(source,{"~r~Successfully kicked member from gang."})
                    exports['ghmattimysql']:execute("UPDATE oasis_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                        TriggerClientEvent('OASIS:ForceRefreshData', source)
                        if tonumber(membersource) > 0 then
                            OASISclient.notify(membersource,{"~r~You have been kicked from the gang."})
                            TriggerClientEvent('OASIS:disbandedGang', membersource)
                        end
                    end)
                end
            end
        end
    end)
end)
RegisterServerEvent("OASIS:memberLeaveGang")
AddEventHandler("OASIS:memberLeaveGang", function(gangid)
    local source = source
    local user_id = OASIS.getUserId(source)
    local membersource = OASIS.getUserSource(user_id)
    if membersource == nil then
        membersource = 0
    end
    local membergang = ""
    exports['ghmattimysql']:execute('SELECT * FROM oasis_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    local memberrank = array[tostring(user_id)].rank
                    local rank = array[tostring(user_id)].rank
                    if rank == 4 then
                        OASISclient.notify(source,{"~r~You cannot leave the gang because you are the leader!"})
                        return
                    else
                        array[tostring(user_id)] = nil
                        array = json.encode(array)
                        exports['ghmattimysql']:execute("UPDATE oasis_gangs SET gangmembers = @gangmembers WHERE gangname=@gangname", {gangmembers=array, gangname = gangid}, function()
                            TriggerClientEvent('OASIS:ForceRefreshData', source)
                            if tonumber(membersource) > 0 then
                                OASISclient.notify(source,{"~g~Successfully left gang."})
                                TriggerClientEvent('OASIS:disbandedGang', membersource)
                            end
                        end)
                    end
                end
            end
        end
    end)
end)
RegisterServerEvent("OASIS:InviteUserToGang")
AddEventHandler("OASIS:InviteUserToGang", function(gangid,playerid)
    local source = source
    playerid = tonumber(playerid)
    local user_id=OASIS.getUserId(source)
    local name = GetPlayerName(source)
    local message = "~g~Gang invite recieved from "..name
    local playersource = OASIS.getUserSource(playerid)
    if playersource == nil then
        OASISclient.notify(source,{"~r~Player is not online."})
        return
    end
    local playername = GetPlayerName(playersource)
    TriggerClientEvent('OASIS:InviteRecieved', playersource,message,gangid)
end)
RegisterServerEvent("OASIS:DeleteGang")
AddEventHandler("OASIS:DeleteGang", function(gangid)
    local source=source
    local user_id=OASIS.getUserId(source)
    exports['ghmattimysql']:execute('SELECT * FROM oasis_gangs WHERE gangname = @gangname',{gangname = gangid}, function(G)
        for K,V in pairs(G) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    exports['ghmattimysql']:execute("DELETE FROM oasis_gangs WHERE gangname = @gangname", {gangname = gangid}, function() end)
                    OASISclient.notify(source,{"~g~Disbanded "..gangid})
                    TriggerClientEvent('OASIS:disbandedGang', source)
                    TriggerClientEvent('OASIS:ForceRefreshData', -1)
                end
            end
        end
    end)
end)