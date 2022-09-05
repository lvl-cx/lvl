RegisterServerEvent('ARMA:uploadVideo')
AddEventHandler('ARMA:uploadVideo', function(videourl)
    local source = source
    local user_id = ARMA.getUserId(source)
    local command = {
        {
            ["color"] = "16448403",
            ["title"] = "ARMA Video Logs",
            ["description"] = "",
            ["text"] = "ARMA Server #1",
            ["fields"] = {
                {
                    ["name"] = "Player Name",
                    ["value"] = GetPlayerName(source),
                    ["inline"] = true
                },
                {
                    ["name"] = "Player TempID",
                    ["value"] = source,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player PermID",
                    ["value"] = user_id,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player Hours",
                    ["value"] = math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0,
                    ["inline"] = true
                },
                {
                    ["name"] = "Video URL",
                    ["value"] = videourl,
                    ["inline"] = true
                },
            }
        }
    }
    local webhook = "https://discord.com/api/webhooks/1016442174344286280/iHTemVOLFACxsOAQAUVGfAvqZEhS1waE43C1g2olt-5DaEh2Z1gT_6ohGCcRrgMYMMoY"
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('ARMA:uploadImage')
AddEventHandler('ARMA:uploadImage', function(videourl)
    local source = source
    local user_id = ARMA.getUserId(source)
    local command = {
        {
            ["color"] = "16448403",
            ["title"] = "ARMA Screenshot Logs",
            ["description"] = "",
            ["text"] = "ARMA Server #1",
            ["fields"] = {
                {
                    ["name"] = "Player Name",
                    ["value"] = GetPlayerName(source),
                    ["inline"] = true
                },
                {
                    ["name"] = "Player TempID",
                    ["value"] = source,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player PermID",
                    ["value"] = user_id,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player Hours",
                    ["value"] = math.ceil(ARMA.getUserDataTable(user_id).PlayerTime/60) or 0,
                    ["inline"] = true
                },
                {
                    ["name"] = "Video URL",
                    ["value"] = videourl,
                    ["inline"] = true
                },
            }
        }
    }
    local webhook = "https://discord.com/api/webhooks/1016442174344286280/iHTemVOLFACxsOAQAUVGfAvqZEhS1waE43C1g2olt-5DaEh2Z1gT_6ohGCcRrgMYMMoY"
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "ARMA", embeds = command}), { ['Content-Type'] = 'application/json' })
end)
