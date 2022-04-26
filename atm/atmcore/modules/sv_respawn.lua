RegisterServerEvent("ATMTP:Sandy")
AddEventHandler("ATMTP:Sandy",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
              print(GetPlayerName(source).." is trying to cheat")
              return
       end
       ATMclient.teleport(source, {1841.5405273438,3668.8037109375,33.679920196533})
end)

RegisterServerEvent("ATMTP:StThomas")
AddEventHandler("ATMTP:StThomas",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       ATMclient.teleport(source, {364.56402587891,-591.74749755859,28.686855316162})
end)

RegisterServerEvent("ATMTP:Legion")
AddEventHandler("ATMTP:Legion",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       ATMclient.teleport(source, {281.16030883789,-992.70983886719,33.449813842773})
end)

RegisterServerEvent("ATMTP:Paleto")
AddEventHandler("ATMTP:Paleto",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       ATMclient.teleport(source, {-246.71606445313,6330.7153320313,32.426177978516})
end)

RegisterServerEvent("ATMTP:MissionRow")
AddEventHandler("ATMTP:MissionRow",function()
       local user_id = ATM.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if ATM.hasPermission(user_id, "police.service") then
       ATMclient.teleport(source, {428.19479370117,-981.58215332031,30.710285186768})
       else
       TriggerClientEvent('showNotification', source,"~b~".. "~r~You don't have permission to do that or your not on duty")
       end
end)

RegisterServerEvent("ATMTP:PaletoPD")
AddEventHandler("ATMTP:PaletoPD",function()
       local user_id = ATM.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if ATM.hasPermission(user_id, "police.service") then
       ATMclient.teleport(source, {-439.23,6020.6,31.49})
       else
       TriggerClientEvent('showNotification', source,"~b~".. "~r~You don't have permission to do that or your not on duty")
       end
end)

RegisterServerEvent("ATMTP:Vespucci")
AddEventHandler("ATMTP:Vespucci",function()
       local user_id = ATM.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if ATM.hasPermission(user_id, "police.service") then
       ATMclient.teleport(source, {-1061.13,-827.26,19.21})
       else
       TriggerClientEvent('showNotification', source,"~b~".. "~r~You don't have permission to do that or your not on duty")
       end
end)


RegisterServerEvent("ATMTP:Rebel")
AddEventHandler("ATMTP:Rebel",function()
       local user_id = ATM.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if ATM.hasPermission(user_id, "rebel.license") then
       ATMclient.teleport(source, {3312.1791992188,5175.7817382812,19.614547729492})
       else
       TriggerClientEvent('showNotification', source,"~b~".. "~r~You don't have permission to do")
       end
end)

RegisterServerEvent("ATM:RebelCheck")
AddEventHandler("ATM:RebelCheck",function()
       local user_id = ATM.getUserId(source)
       if ATM.hasPermission(user_id, "rebel.license") then
              TriggerClientEvent('ATM:RebelChecked', source, true)
       else
              TriggerClientEvent('ATM:RebelChecked', source, false)
       end
end)

RegisterServerEvent("ATM:PoliceCheck")
AddEventHandler("ATM:PoliceCheck",function()
       local user_id = ATM.getUserId(source)
       if ATM.hasPermission(user_id, "police.service") then
              TriggerClientEvent('ATM:PoliceChecked', source, true)
       else
              TriggerClientEvent('ATM:PoliceChecked', source, false)
       end
end)