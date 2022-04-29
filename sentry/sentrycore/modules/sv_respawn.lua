RegisterServerEvent("SentryTP:Sandy")
AddEventHandler("SentryTP:Sandy",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
              print(GetPlayerName(source).." is trying to cheat")
              return
       end
       Sentryclient.teleport(source, {1841.5405273438,3668.8037109375,33.679920196533})
end)

RegisterServerEvent("SentryTP:StThomas")
AddEventHandler("SentryTP:StThomas",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       Sentryclient.teleport(source, {364.56402587891,-591.74749755859,28.686855316162})
end)

RegisterServerEvent("SentryTP:Legion")
AddEventHandler("SentryTP:Legion",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       Sentryclient.teleport(source, {281.16030883789,-992.70983886719,33.449813842773})
end)

RegisterServerEvent("SentryTP:Paleto")
AddEventHandler("SentryTP:Paleto",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       Sentryclient.teleport(source, {-246.71606445313,6330.7153320313,32.426177978516})
end)

RegisterServerEvent("SentryTP:MissionRow")
AddEventHandler("SentryTP:MissionRow",function()
       local user_id = Sentry.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if Sentry.hasPermission(user_id, "police.service") then
       Sentryclient.teleport(source, {428.19479370117,-981.58215332031,30.710285186768})
       else
       TriggerClientEvent('showNotification', source,"~b~".. "~r~You don't have permission to do that or your not on duty")
       end
end)

RegisterServerEvent("SentryTP:PaletoPD")
AddEventHandler("SentryTP:PaletoPD",function()
       local user_id = Sentry.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if Sentry.hasPermission(user_id, "police.service") then
       Sentryclient.teleport(source, {-439.23,6020.6,31.49})
       else
       TriggerClientEvent('showNotification', source,"~b~".. "~r~You don't have permission to do that or your not on duty")
       end
end)

RegisterServerEvent("SentryTP:Vespucci")
AddEventHandler("SentryTP:Vespucci",function()
       local user_id = Sentry.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if Sentry.hasPermission(user_id, "police.service") then
       Sentryclient.teleport(source, {-1061.13,-827.26,19.21})
       else
       TriggerClientEvent('showNotification', source,"~b~".. "~r~You don't have permission to do that or your not on duty")
       end
end)


RegisterServerEvent("SentryTP:Rebel")
AddEventHandler("SentryTP:Rebel",function()
       local user_id = Sentry.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if Sentry.hasPermission(user_id, "rebel.license") then
       Sentryclient.teleport(source, {3312.1791992188,5175.7817382812,19.614547729492})
       else
       TriggerClientEvent('showNotification', source,"~b~".. "~r~You don't have permission to do")
       end
end)

RegisterServerEvent("Sentry:RebelCheck")
AddEventHandler("Sentry:RebelCheck",function()
       local user_id = Sentry.getUserId(source)
       if Sentry.hasPermission(user_id, "rebel.license") then
              TriggerClientEvent('Sentry:RebelChecked', source, true)
       else
              TriggerClientEvent('Sentry:RebelChecked', source, false)
       end
end)

RegisterServerEvent("Sentry:PoliceCheck")
AddEventHandler("Sentry:PoliceCheck",function()
       local user_id = Sentry.getUserId(source)
       if Sentry.hasPermission(user_id, "police.service") then
              TriggerClientEvent('Sentry:PoliceChecked', source, true)
       else
              TriggerClientEvent('Sentry:PoliceChecked', source, false)
       end
end)