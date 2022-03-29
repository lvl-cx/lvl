RegisterServerEvent("PoliceMenu:ClockOn")
AddEventHandler('PoliceMenu:ClockOn', function(policerank)
    local user_id = Sentry.getUserId(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(441.87026977539,-981.13433837891,30.689609527588)

    if policerank == "Commissioner Clocked" then
        policeperm = "commissioner.clockon"
        policename = "Commissioner"
    elseif policerank == "Deputy Commissioner Clocked" then
        policeperm = "depcommissioner.clockon"
        policename = "Deputy Commissioner"
    elseif policerank == "Assistant Commissioner Clocked" then
        policeperm = "asscommissioner.clockon"
        policename = "Assistant Commissioner"
    elseif policerank == "Deputy Assistant Commissioner Clocked" then
        policeperm = "depasscommissioner.clockon"
        policename = "Deputy Assistant Commissioner"
    elseif policerank == "Commander Clocked" then
        policeperm = "commander.clockon"
        policename = "Commander"
    elseif policerank == "Chief Superintendent Clocked" then
        policeperm = "chiefsupint.clockon"
        policename = "Chief Superintendent"
    elseif policerank == "Superintendent Clocked" then
        policeperm = "superint.clockon"
        policename = "Superintendent"
    elseif policerank == "Chief Inspector Clocked" then
        policeperm = "chiefinsp.clockon"
        policename = "Chief Inspector"
    elseif policerank == "Inspector Clocked" then
        policeperm = "inspector.clockon"
        policename = "Inspector"
    elseif policerank == "Sergeant Clocked" then
        policeperm = "sgt.clockon"
        policename = "Sergeant"
    elseif policerank == "Special Police Constable Clocked" then
        policeperm = "specialpc.clockon"
        policename = "Special Police Constable"
    elseif policerank == "Senior Police Constable Clocked" then
        policeperm = "srpc.clockon"
        policename = "Senior Police Constable"
    elseif policerank == "Police Constable Clocked" then
        policeperm = "pc.clockon"
        policename = "Police Constable"
    elseif policerank == "PCSO Clocked" then
        policeperm = "pcso.clockon"
        policename = "PCSO"
    end

    if user_id ~= nil and Sentry.hasPermission(user_id, policeperm) and not Sentry.hasGroup(user_id,policerank) then
        Sentry.addUserGroup(user_id,policerank)
        Sentryclient.notify(source,{"~b~You have clocked on as a "..policename})
    elseif user_id == nil then
        Sentryclient.notify(source,{"~r~You are a nil User ID, please relog."})
    elseif not Sentry.hasPermission(user_id, policeperm) then
        Sentryclient.notify(source,{"~r~Hey! You aren't allowed to clock on as that rank."})
    elseif not Sentry.hasPermission(user_id, "clockon.menu") then
        Sentryclient.notify(source,{"~r~You have been reported to admins since you are trying to clock on through a mod menu"})
    elseif Sentry.hasGroup(user_id,policerank) then
        Sentryclient.notify(source,{"~r~You are already clocked on!"})
    end
    if #(coords - comparison) > 20 then
        print(GetPlayerName(source).." is a cheating scum, he's trying to clock on as Police!")
        return
    end
end)

RegisterServerEvent("PoliceMenu:CheckPermissions")
AddEventHandler('PoliceMenu:CheckPermissions', function()
    local user_id = Sentry.getUserId(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(441.87026977539,-981.13433837891,30.689609527588)
    if #(coords - comparison) > 20 then
        print(GetPlayerName(source).." is a cheating scum, he's trying to clock on as Police!")
        return
    end
    if Sentry.hasPermission(user_id, "clockon.menu") then
        TriggerClientEvent('PoliceDuty:Allowed', source, true)
    else
        TriggerClientEvent('PoliceDuty:Allowed', source, false)
    end
end)

RegisterServerEvent("PoliceMenu:ClockOff")
AddEventHandler('PoliceMenu:ClockOff', function()
    local user_id = Sentry.getUserId(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(441.87026977539,-981.13433837891,30.689609527588)

    if user_id == nil then
        Sentryclient.notify(source,{"~r~You are a nil User ID, please relog."})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Commissioner Clocked") then
        Sentry.removeUserGroup(user_id,"Commissioner Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Deputy Commissioner Clocked") then
        Sentry.removeUserGroup(user_id,"Deputy Commissioner Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Assistant Commissioner Clocked") then
        Sentry.removeUserGroup(user_id,"Assistant Commissioner Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Deputy Assistant Commissioner Clocked") then
        Sentry.removeUserGroup(user_id,"Deputy Assistant Commissioner Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Commander Clocked") then
        Sentry.removeUserGroup(user_id,"Commander Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Chief Superintendent Clocked") then
        Sentry.removeUserGroup(user_id,"Chief Superintendent Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Superintendent Clocked") then
        Sentry.removeUserGroup(user_id,"Superintendent Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Chief Inspector Clocked") then
        Sentry.removeUserGroup(user_id,"Chief Inspector Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Inspector Clocked") then
        Sentry.removeUserGroup(user_id,"Inspector Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Sergeant Clocked") then
        Sentry.removeUserGroup(user_id,"Sergeant Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Special Police Constable Clocked") then
        Sentry.removeUserGroup(user_id,"Special Police Constable Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Senior Police Constable Clocked") then
        Sentry.removeUserGroup(user_id,"Senior Police Constable Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "Police Constable Clocked") then
        Sentry.removeUserGroup(user_id,"Police Constable Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    elseif user_id ~= nil and Sentry.hasGroup(user_id, "PCSO Clocked") then
        Sentry.removeUserGroup(user_id,"PCSO Clocked")
        Sentryclient.notify(source,{"You have clocked off"})
    end
    if #(coords - comparison) > 20 then
        print(GetPlayerName(source).." is a cheating scum, he's trying to clock off as Police!")
        return
    end
end)