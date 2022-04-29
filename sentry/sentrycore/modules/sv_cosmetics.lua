
RegisterNetEvent('Sentry:BuyCosmetic')
AddEventHandler('Sentry:BuyCosmetic', function(cosmeticdata)
    local source = source
    local user_id = Sentry.getUserId(source)
 
    for i,v in pairs(cosmetics.cfg) do 
        if v.item == cosmeticdata then 
            if Sentry.hasGroup(user_id, cosmeticdata) then 
                Sentryclient.notify(source, {'~r~You already have this cosmetic.'})
                TriggerClientEvent("Sentry:PlaySound", source, 2)
            else
                if Sentry.tryBankPayment(user_id, v.price) then 
                    Sentry.addUserGroup(user_id, v.item)
                    Sentryclient.notify(source, {'~g~Bought ' .. v.item .. ' for for £' .. tostring(getMoneyStringFormatted(v.price))})
                    TriggerClientEvent("Sentry:PlaySound", source, 1)
                else 
                    Sentryclient.notify(source, {'~r~Not enough money.'})
                    TriggerClientEvent("Sentry:PlaySound", source, 2)
                end
            end
        end
    end
end) 

RegisterNetEvent('Sentry:RefundCosmetic')
AddEventHandler('Sentry:RefundCosmetic', function(cosmeticdata)
    local source = source
    local user_id = Sentry.getUserId(source)
 
    for i,v in pairs(cosmetics.cfg) do 
        if v.item == cosmeticdata then 
            if Sentry.hasGroup(user_id, v.item) then 
                Sentry.removeUserGroup(user_id, v.item)  
                Sentry.giveBankMoney(user_id, v.price * 0.25)
                Sentryclient.notify(source, {'~g~Refunded ' .. v.item .. ' Cosmetic for £' .. tostring(v.price * 0.25)})
                TriggerClientEvent('Sentry:ResetCosmetics', source, v.type)
                TriggerClientEvent("Sentry:PlaySound", source, 1)
            end
        end
    end
end) 

RegisterNetEvent('Sentry:SellCosmeticToPlayer')
AddEventHandler('Sentry:SellCosmeticToPlayer', function(cosmeticdata)
    local source = source 
    user_id = Sentry.getUserId(source)
    if Sentry.hasGroup(user_id, cosmeticdata) then
        for i,v in pairs(cosmetics.cfg) do 
            if v.item == cosmeticdata then 
                Sentryclient.getNearestPlayers(source,{15},function(nplayers)
                    usrList = ""
                    for k,v in pairs(nplayers) do
                        usrList = usrList .. "[" .. Sentry.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
                    end
                    if Sentry.hasGroup(user_id, v.item) then
                        if usrList ~= "" then
                            Sentry.prompt(source,"Type the ID you want to sell this Cosemetic too. " .. usrList,"",function(source,userid) 
                                Sentry.prompt(source,"How much do you want to sell the Cosmetic for?","",function(source,price) 
                                    local target = Sentry.getUserSource(tonumber(userid))
                                    if price == tostring(tonumber(price)) then
                                        if tonumber(price) >= 0 then 
     
                                           
                                                Sentryclient.notify(source, {'~g~Sent Request.'})
                                                Sentry.request(target,GetPlayerName(source).." wants to sell: " ..v.item.. " Cosmetic for £"..price, 10, function(target,ok)
                                                    if ok then
                                                        if Sentry.tryBankPayment(tonumber(userid), tonumber(price)) then
                                                            Sentry.giveBankMoney(user_id, tonumber(price))
                                                            Sentry.removeUserGroup(user_id, v.item)
                                                            Sentry.addUserGroup(tonumber(userid), v.item)
                                                        
                                                            Sentryclient.notify(source, {'~g~Sold ' .. v.item .. ' Cosmetic for £' .. getMoneyStringFormatted(price) .. ' to ' .. GetPlayerName(target) .. ' ~w~[ID: ' .. userid .. ']'})
                                                            TriggerClientEvent("Sentry:PlaySound", source, 1)
                                                            Sentryclient.notify(target, {'~g~Bought ' .. v.item .. ' Cosmetic for £' .. getMoneyStringFormatted(price) .. ' from ' .. GetPlayerName(source) .. ' ~w~[ID: ' .. user_id .. ']'})
                                                            TriggerClientEvent("Sentry:PlaySound", target, 1)
                                                            TriggerClientEvent('Sentry:ResetCosmetics', source, v.type)
                                                        else
                                                            Sentryclient.notify(source, {'~r~User does not have enough money.'})
                                                            Sentryclient.notify(target, {'~r~You do not have enough money.'})
                                                        end
                                                    else
                                                        Sentryclient.notify(source, {'~r~User Denied.'})
                                                        Sentryclient.notify(target, {'~r~You Denied.'})
                                                        TriggerClientEvent("Sentry:PlaySound", source, 2)
                                                    end
                                                end)
                                           
                                        else

                                            Sentryclient.notify(source, {'~r~No negative numbers.'})
                                        end
                                    else
                                        Sentryclient.notify(source, {'~r~The value you entered is not a number!'})
                                    end

                                end)
                            end)
                        else
                            Sentryclient.notify(source, {'~r~No players nearby.'})
                        end
                    else
                        Sentryclient.notify(source, {'~r~Error, You do not have this Cosmetic.'})
                    end
                end)
            end
        end
    end
end)

RegisterNetEvent('Sentry:CosmeticMarketPlace')
AddEventHandler('Sentry:CosmeticMarketPlace', function(cosmeticdata, price, message)
    user_id = Sentry.getUserId(source)
    if Sentry.hasGroup(user_id, cosmeticdata) then
        for i,v in pairs(cosmetics.cfg) do 
            if v.item == cosmeticdata then 
                local discord  = '[Discord Not Linked]'
                for k,v in pairs(GetPlayerIdentifiers(source)) do
                  if string.sub(v, 1, string.len("discord:")) == "discord:" then
                    discord = v
                  end
                end
                url = v.url
                webhook = "https://discord.com/api/webhooks/967472206756069376/rWpnwVTJTKl3Udz2FELcdhVEtUM_apdAAEQ99sqO_psDpjQusgY_XDZnMTItogd0gXSH"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "Sentry Market", embeds = {
                    {
                        ["color"] = "3319890",
                        ["title"] = "Sentry Market Place",
                        ["image"] = {
                            ["url"] = url,
                        },
                        ["description"] = 'Cosmetic Item: **' .. v.item .. '**\n\nSeller Discord: <@' .. string.gsub(discord,'discord:','') ..'> \nSeller Perm ID: **' ..  Sentry.getUserId(source) .. '**\n\n Listing Price: ** £' .. getMoneyStringFormatted(price) .. '**\nStandard Price: **£' .. getMoneyStringFormatted(v.price).. '**\nCosmetic Type: **' .. v.type .. '**\nCustom Listing Message: ***' .. message .. '***',
                        ["footer"] = {
                            ["text"] = "",
                        },
                  }
                  }}), { ["Content-Type"] = "application/json" })
                  Sentryclient.notify(source, {'Listed ~g~' .. v.item .. ' ~w~onto ~g~#market-place ~w~for ~g~£' .. getMoneyStringFormatted(price)})
                  TriggerClientEvent("Sentry:PlaySound", source, 1)
            end
        end
    end
end)

RegisterNetEvent('Sentry:GetCosmetic')
AddEventHandler('Sentry:GetCosmetic', function()
    local source = source
    local user_id = Sentry.getUserId(source)
    local CosmeticReturn = {}
 
    for i,v in pairs(cosmetics.cfg) do 
        if Sentry.hasGroup(user_id, v.item) then
            CosmeticReturn[v.item] = true;
        end
    end
    TriggerClientEvent('Sentry:ReturnCosmetic', source, CosmeticReturn)
end)

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end