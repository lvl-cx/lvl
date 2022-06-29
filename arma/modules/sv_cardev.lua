RegisterServerEvent('ARMA:openCarDev')
AddEventHandler('ARMA:openCarDev', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and ARMA.hasPermission(user_id, "cardev.menu") then 
      TriggerClientEvent("ARMA:CarDevMenu", source)
    end
end)

RegisterServerEvent('ARMA:setCarDev')
AddEventHandler('ARMA:setCarDev', function(status)
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil and ARMA.hasPermission(user_id, "cardev.menu") then 
      if status then
        SetPlayerRoutingBucket(source, 10)
      else
        SetPlayerRoutingBucket(source, 0)
      end
    else
      local player = ARMA.getUserSource(user_id)
      Wait(500)
      reason = "Type #11"
      TriggerEvent("ARMA:acBan", user_id, reason, name, player, 'Attempted to Teleport to Car Dev Universe')
    end
end)

RegisterServerEvent('ARMA:takeCarScreenshot')
AddEventHandler('ARMA:takeCarScreenshot', function(spawncode, orientation)
    local source = source
    local user_id = ARMA.getUserId(source)
    local name = GetPlayerName(source)
    if user_id ~= nil and ARMA.hasPermission(user_id, "cardev.menu") then 
      os.execute('mkdir C:\\xampp\\htdocs\\cars\\'..spawncode)
        exports['screenshot-basic']:requestClientScreenshot(source, {
          fileName = 'C:/xampp/htdocs/cars/'..spawncode..'/'..orientation..'.jpg'
          }, function()
      end)
      if orientation == 'side' then
        local file = io.open('C:/xampp/htdocs/cars/'..spawncode..'/index.html',"w+")
        file:write('<html><style>	body {background-color: #262626;}</style><img src="front.jpg" style="max-width: 80%;height: auto; display: block; margin-left: auto;margin-right: auto;padding: 10px;margin-bottom: 10px;"><img src="rear.jpg" style="max-width: 80%;height: auto; display: block; margin-left: auto;margin-right: auto;padding: 10px;margin-bottom: 10px;"><img src="side.jpg" style="max-width: 80%;height: auto; display: block; margin-left: auto;margin-right: auto;padding: 10px;margin-bottom: 10px;"></html>')
        file:close()
        PerformHttpRequest('https://discord.com/api/webhooks/980284381761515583/2XrEHiKzr1oynLfgvejGwizRRGXHttDoqOoowGD7baexwVvbGh9EvM6QcGgi099R0_l8', function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA", embeds = {
            {
                ["color"] = "15158332",
                ["title"] = "Car Screenshots",
                ["description"] = "**Admin Name: **"..name.."\n**Admin ID: **"..user_id.."\n**Link:** http://86.141.230.253/cars/"..spawncode,
                ["footer"] = {
                    ["text"] = "Time - "..os.date("%x %X %p"),
                }
        }
        }}), { ["Content-Type"] = "application/json" })
      end
    else
        local player = ARMA.getUserSource(user_id)
        Wait(500)
        reason = "Type #11"
        TriggerEvent("ARMA:acBan", user_id, reason, name, player, 'Attempted to Take Car Screenshot')
    end   
end)