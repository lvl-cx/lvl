RegisterServerEvent("LVLTP:Sandy")
AddEventHandler("LVLTP:Sandy",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
              print(GetPlayerName(source).." is trying to cheat")
              return
       end
       LVLclient.teleport(source, {1841.5405273438,3668.8037109375,33.679920196533})
end)

RegisterServerEvent("LVLTP:StThomas")
AddEventHandler("LVLTP:StThomas",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       LVLclient.teleport(source, {364.56402587891,-591.74749755859,28.686855316162})
end)

RegisterServerEvent("LVLTP:Legion")
AddEventHandler("LVLTP:Legion",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       LVLclient.teleport(source, {281.16030883789,-992.70983886719,33.449813842773})
end)

RegisterServerEvent("LVLTP:Paleto")
AddEventHandler("LVLTP:Paleto",function()
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       LVLclient.teleport(source, {-246.71606445313,6330.7153320313,32.426177978516})
end)

RegisterServerEvent("LVLTP:MissionRow")
AddEventHandler("LVLTP:MissionRow",function()
       local user_id = LVL.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if LVL.hasPermission(user_id, "police.service") then
       LVLclient.teleport(source, {428.19479370117,-981.58215332031,30.710285186768})
       else
       TriggerClientEvent('showNotification', source,"~g~".. "~r~You don't have permission to do that or your not on duty")
       end
end)

RegisterServerEvent("LVLTP:PaletoPD")
AddEventHandler("LVLTP:PaletoPD",function()
       local user_id = LVL.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if LVL.hasPermission(user_id, "police.service") then
       LVLclient.teleport(source, {-439.23,6020.6,31.49})
       else
       TriggerClientEvent('showNotification', source,"~g~".. "~r~You don't have permission to do that or your not on duty")
       end
end)

RegisterServerEvent("LVLTP:Vespucci")
AddEventHandler("LVLTP:Vespucci",function()
       local user_id = LVL.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if LVL.hasPermission(user_id, "police.service") then
       LVLclient.teleport(source, {-1061.13,-827.26,19.21})
       else
       TriggerClientEvent('showNotification', source,"~g~".. "~r~You don't have permission to do that or your not on duty")
       end
end)


RegisterServerEvent("LVLTP:Rebel")
AddEventHandler("LVLTP:Rebel",function()
       local user_id = LVL.getUserId(source)
       local coords = GetEntityCoords(GetPlayerPed(source))
       local comparison = vector3(340.05987548828,-1388.4616699219,32.509250640869)
       if #(coords - comparison) > 20 then 
       print(GetPlayerName(source).." is trying to cheat")
       return
       end
       if LVL.hasPermission(user_id, "rebel.license") then
       LVLclient.teleport(source, {3312.1791992188,5175.7817382812,19.614547729492})
       else
       TriggerClientEvent('showNotification', source,"~g~".. "~r~You don't have permission to do")
       end
end)

RegisterServerEvent("LVL:RebelCheck")
AddEventHandler("LVL:RebelCheck",function()
       local user_id = LVL.getUserId(source)
       if LVL.hasPermission(user_id, "rebel.license") then
              TriggerClientEvent('LVL:RebelChecked', source, true)
       else
              TriggerClientEvent('LVL:RebelChecked', source, false)
       end
end)

RegisterServerEvent("LVL:PoliceCheck")
AddEventHandler("LVL:PoliceCheck",function()
       local user_id = LVL.getUserId(source)
       if LVL.hasPermission(user_id, "police.service") then
              TriggerClientEvent('LVL:PoliceChecked', source, true)
       else
              TriggerClientEvent('LVL:PoliceChecked', source, false)
       end
end)