RegisterServerEvent("PoliceMenu:ClockOn")
AddEventHandler('PoliceMenu:ClockOn', function(policerank)
    local user_id = LVL.getUserId(source)
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

    if user_id ~= nil and LVL.hasPermission(user_id, policeperm) and not LVL.hasGroup(user_id,policerank) then
        LVL.addUserGroup(user_id,policerank)
        LVLclient.notify(source,{"~g~You have clocked on as a "..policename})
    elseif user_id == nil then
        LVLclient.notify(source,{"~r~You are a nil User ID, please relog."})
    elseif not LVL.hasPermission(user_id, policeperm) then
        LVLclient.notify(source,{"~r~Hey! You aren't allowed to clock on as that rank."})
    elseif not LVL.hasPermission(user_id, "clockon.menu") then
        LVLclient.notify(source,{"~r~You have been reported to admins since you are trying to clock on through a mod menu"})
    elseif LVL.hasGroup(user_id,policerank) then
        LVLclient.notify(source,{"~r~You are already clocked on!"})
    end
    if #(coords - comparison) > 20 then
        print(GetPlayerName(source).." is a cheating scum, he's trying to clock on as Police!")
        return
    end
end)

RegisterServerEvent("PoliceMenu:CheckPermissions")
AddEventHandler('PoliceMenu:CheckPermissions', function()
    local user_id = LVL.getUserId(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(441.87026977539,-981.13433837891,30.689609527588)
    if #(coords - comparison) > 20 then
        print(GetPlayerName(source).." is a cheating scum, he's trying to clock on as Police!")
        return
    end
    if LVL.hasPermission(user_id, "clockon.menu") then
        TriggerClientEvent('PoliceDuty:Allowed', source, true)
    else
        TriggerClientEvent('PoliceDuty:Allowed', source, false)
    end
end)

RegisterServerEvent("PoliceMenu:ClockOff")
AddEventHandler('PoliceMenu:ClockOff', function()
    local user_id = LVL.getUserId(source)
    local coords = GetEntityCoords(GetPlayerPed(source))
    local comparison = vector3(441.87026977539,-981.13433837891,30.689609527588)

    if user_id == nil then
        LVLclient.notify(source,{"~r~You are a nil User ID, please relog."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Commissioner Clocked") then
        LVL.removeUserGroup(user_id,"Commissioner Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Deputy Commissioner Clocked") then
        LVL.removeUserGroup(user_id,"Deputy Commissioner Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Assistant Commissioner Clocked") then
        LVL.removeUserGroup(user_id,"Assistant Commissioner Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Deputy Assistant Commissioner Clocked") then
        LVL.removeUserGroup(user_id,"Deputy Assistant Commissioner Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Commander Clocked") then
        LVL.removeUserGroup(user_id,"Commander Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Chief Superintendent Clocked") then
        LVL.removeUserGroup(user_id,"Chief Superintendent Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Superintendent Clocked") then
        LVL.removeUserGroup(user_id,"Superintendent Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Chief Inspector Clocked") then
        LVL.removeUserGroup(user_id,"Chief Inspector Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Inspector Clocked") then
        LVL.removeUserGroup(user_id,"Inspector Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Sergeant Clocked") then
        LVL.removeUserGroup(user_id,"Sergeant Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Special Police Constable Clocked") then
        LVL.removeUserGroup(user_id,"Special Police Constable Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Senior Police Constable Clocked") then
        LVL.removeUserGroup(user_id,"Senior Police Constable Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "Police Constable Clocked") then
        LVL.removeUserGroup(user_id,"Police Constable Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    elseif user_id ~= nil and LVL.hasGroup(user_id, "PCSO Clocked") then
        LVL.removeUserGroup(user_id,"PCSO Clocked")
        LVLclient.notify(source,{"~r~You clocked off."})
    end
    if #(coords - comparison) > 20 then
        print(GetPlayerName(source).." is a cheating scum, he's trying to clock off as Police!")
        return
    end
end)