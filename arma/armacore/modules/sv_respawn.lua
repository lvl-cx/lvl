RegisterServerEvent("ARMATP:Sandy")
AddEventHandler("ARMATP:Sandy",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
              print(GetPlayerName(source).." is trying to cheat")
              return
       end
       ARMAclient.teleport(source, {1841.5405273438,3668.8037109375,33.679920196533})
end)

RegisterServerEvent("ARMATP:StThomas")
AddEventHandler("ARMATP:StThomas",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       ARMAclient.teleport(source, {364.56402587891,-591.74749755859,28.686855316162})
end)

RegisterServerEvent("ARMATP:Legion")
AddEventHandler("ARMATP:Legion",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       ARMAclient.teleport(source, {281.16030883789,-992.70983886719,33.449813842773})
end)

RegisterServerEvent("ARMATP:Paleto")
AddEventHandler("ARMATP:Paleto",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       ARMAclient.teleport(source, {-246.71606445313,6330.7153320313,32.426177978516})
end)

RegisterServerEvent("ARMATP:MissionRow")
AddEventHandler("ARMATP:MissionRow",function()
       local user_id = ARMA.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if ARMA.hasPermission(user_id, "police.service") then
       ARMAclient.teleport(source, {428.19479370117,-981.58215332031,30.710285186768})
       else
       TriggerClientEvent('showNotification', source,"~g~".. "~r~You don't have permission to do that or your not on duty")
       end
end)

RegisterServerEvent("ARMATP:PaletoPD")
AddEventHandler("ARMATP:PaletoPD",function()
       local user_id = ARMA.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if ARMA.hasPermission(user_id, "police.service") then
       ARMAclient.teleport(source, {-439.23,6020.6,31.49})
       else
       TriggerClientEvent('showNotification', source,"~g~".. "~r~You don't have permission to do that or your not on duty")
       end
end)

RegisterServerEvent("ARMATP:Vespucci")
AddEventHandler("ARMATP:Vespucci",function()
       local user_id = ARMA.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if ARMA.hasPermission(user_id, "police.service") then
       ARMAclient.teleport(source, {-1061.13,-827.26,19.21})
       else
       TriggerClientEvent('showNotification', source,"~g~".. "~r~You don't have permission to do that or your not on duty")
       end
end)


RegisterServerEvent("ARMATP:Rebel")
AddEventHandler("ARMATP:Rebel",function()
       local user_id = ARMA.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if ARMA.hasPermission(user_id, "rebel.license") then
       ARMAclient.teleport(source, {3312.1791992188,5175.7817382812,19.614547729492})
       else
       TriggerClientEvent('showNotification', source,"~g~".. "~r~You don't have permission to do")
       end
end)

RegisterServerEvent("ARMA:RebelCheck")
AddEventHandler("ARMA:RebelCheck",function()
       local user_id = ARMA.getUserId(source)
       if ARMA.hasPermission(user_id, "rebel.license") then
              TriggerClientEvent('ARMA:RebelChecked', source, true)
       else
              TriggerClientEvent('ARMA:RebelChecked', source, false)
       end
end)

RegisterServerEvent("ARMA:PoliceCheck")
AddEventHandler("ARMA:PoliceCheck",function()
       local user_id = ARMA.getUserId(source)
       if ARMA.hasPermission(user_id, "police.service") then
              TriggerClientEvent('ARMA:PoliceChecked', source, true)
       else
              TriggerClientEvent('ARMA:PoliceChecked', source, false)
       end
end)