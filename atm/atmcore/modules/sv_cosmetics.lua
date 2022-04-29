
RegisterNetEvent('ATM:BuyCosmetic')
AddEventHandler('ATM:BuyCosmetic', function(cosmeticdata)
    local source = source
    local user_id = ATM.getUserId(source)
 
    for i,v in pairs(cosmetics.cfg) do 
        if v.item == cosmeticdata then 
            if ATM.hasGroup(user_id, cosmeticdata) then 
                ATMclient.notify(source, {'~r~You already have this cosmetic.'})
                TriggerClientEvent("ATM:PlaySound", source, 2)
            else
                if ATM.tryBankPayment(user_id, v.price) then 
                    ATM.addUserGroup(user_id, v.item)
                    ATMclient.notify(source, {'~g~Bought ' .. v.item .. ' for for £' .. tostring(getMoneyStringFormatted(v.price))})
                    TriggerClientEvent("ATM:PlaySound", source, 1)
                else 
                    ATMclient.notify(source, {'~r~Not enough money.'})
                    TriggerClientEvent("ATM:PlaySound", source, 2)
                end
            end
        end
    end
end) 

RegisterNetEvent('ATM:RefundCosmetic')
AddEventHandler('ATM:RefundCosmetic', function(cosmeticdata)
    local source = source
    local user_id = ATM.getUserId(source)
 
    for i,v in pairs(cosmetics.cfg) do 
        if v.item == cosmeticdata then 
            if ATM.hasGroup(user_id, v.item) then 
                ATM.removeUserGroup(user_id, v.item)  
                ATM.giveBankMoney(user_id, v.price * 0.25)
                ATMclient.notify(source, {'~g~Refunded ' .. v.item .. ' Cosmetic for £' .. tostring(v.price * 0.25)})
                TriggerClientEvent('ATM:ResetCosmetics', source, v.type)
                TriggerClientEvent("ATM:PlaySound", source, 1)
            end
        end
    end
end) 

RegisterNetEvent('ATM:SellCosmeticToPlayer')
AddEventHandler('ATM:SellCosmeticToPlayer', function(cosmeticdata)
    local source = source 
    user_id = ATM.getUserId(source)
    if ATM.hasGroup(user_id, cosmeticdata) then
        for i,v in pairs(cosmetics.cfg) do 
            if v.item == cosmeticdata then 
                ATMclient.getNearestPlayers(source,{15},function(nplayers)
                    usrList = ""
                    for k,v in pairs(nplayers) do
                        usrList = usrList .. "[" .. ATM.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
                    end
                    if ATM.hasGroup(user_id, v.item) then
                        if usrList ~= "" then
                            ATM.prompt(source,"Type the ID you want to sell this Cosemetic too. " .. usrList,"",function(source,userid) 
                                ATM.prompt(source,"How much do you want to sell the Cosmetic for?","",function(source,price) 
                                    local target = ATM.getUserSource(tonumber(userid))
                                    if price == tostring(tonumber(price)) then
                                        if tonumber(price) >= 0 then 
     
                                           
                                                ATMclient.notify(source, {'~g~Sent Request.'})
                                                ATM.request(target,GetPlayerName(source).." wants to sell: " ..v.item.. " Cosmetic for £"..price, 10, function(target,ok)
                                                    if ok then
                                                        if ATM.tryBankPayment(tonumber(userid), tonumber(price)) then
                                                            ATM.giveBankMoney(user_id, tonumber(price))
                                                            ATM.removeUserGroup(user_id, v.item)
                                                            ATM.addUserGroup(tonumber(userid), v.item)
                                                        
                                                            ATMclient.notify(source, {'~g~Sold ' .. v.item .. ' Cosmetic for £' .. getMoneyStringFormatted(price) .. ' to ' .. GetPlayerName(target) .. ' ~w~[ID: ' .. userid .. ']'})
                                                            TriggerClientEvent("ATM:PlaySound", source, 1)
                                                            ATMclient.notify(target, {'~g~Bought ' .. v.item .. ' Cosmetic for £' .. getMoneyStringFormatted(price) .. ' from ' .. GetPlayerName(source) .. ' ~w~[ID: ' .. user_id .. ']'})
                                                            TriggerClientEvent("ATM:PlaySound", target, 1)
                                                            TriggerClientEvent('ATM:ResetCosmetics', source, v.type)
                                                        else
                                                            ATMclient.notify(source, {'~r~User does not have enough money.'})
                                                            ATMclient.notify(target, {'~r~You do not have enough money.'})
                                                        end
                                                    else
                                                        ATMclient.notify(source, {'~r~User Denied.'})
                                                        ATMclient.notify(target, {'~r~You Denied.'})
                                                        TriggerClientEvent("ATM:PlaySound", source, 2)
                                                    end
                                                end)
                                           
                                        else

                                            ATMclient.notify(source, {'~r~No negative numbers.'})
                                        end
                                    else
                                        ATMclient.notify(source, {'~r~The value you entered is not a number!'})
                                    end

                                end)
                            end)
                        else
                            ATMclient.notify(source, {'~r~No players nearby.'})
                        end
                    else
                        ATMclient.notify(source, {'~r~Error, You do not have this Cosmetic.'})
                    end
                end)
            end
        end
    end
end)

RegisterNetEvent('ATM:CosmeticMarketPlace')
AddEventHandler('ATM:CosmeticMarketPlace', function(cosmeticdata, price, message)
    user_id = ATM.getUserId(source)
    if ATM.hasGroup(user_id, cosmeticdata) then
        for i,v in pairs(cosmetics.cfg) do 
            if v.item == cosmeticdata then 
                local discord  = '[Discord Not Linked]'
                for k,v in pairs(GetPlayerIdentifiers(source)) do
                  if string.sub(v, 1, string.len("discord:")) == "discord:" then
                    discord = v
                  end
                end
                url = v.url
                webhook = "https://discord.com/api/webhooks/968950102217601154/ASdwAPKtP1lrNy3jBw7eu_We3mUxLBVJ1zfOYo8Yew-nGss7c08skbn0PJUDdKtmUd5W"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "ATM Market", embeds = {
                    {
                        ["color"] = "3319890",
                        ["title"] = "ATM Market Place",
                        ["image"] = {
                            ["url"] = url,
                        },
                        ["description"] = 'Cosmetic Item: **' .. v.item .. '**\n\nSeller Discord: <@' .. string.gsub(discord,'discord:','') ..'> \nSeller Perm ID: **' ..  ATM.getUserId(source) .. '**\n\n Listing Price: ** £' .. getMoneyStringFormatted(price) .. '**\nStandard Price: **£' .. getMoneyStringFormatted(v.price).. '**\nCosmetic Type: **' .. v.type .. '**\nCustom Listing Message: ***' .. message .. '***',
                        ["footer"] = {
                            ["text"] = "",
                        },
                  }
                  }}), { ["Content-Type"] = "application/json" })
                  ATMclient.notify(source, {'Listed ~g~' .. v.item .. ' ~w~onto ~g~#market-place ~w~for ~g~£' .. getMoneyStringFormatted(price)})
                  TriggerClientEvent("ATM:PlaySound", source, 1)
            end
        end
    end
end)

RegisterNetEvent('ATM:GetCosmetic')
AddEventHandler('ATM:GetCosmetic', function()
    local source = source
    local user_id = ATM.getUserId(source)
    local CosmeticReturn = {}
 
    for i,v in pairs(cosmetics.cfg) do 
        if ATM.hasGroup(user_id, v.item) then
            CosmeticReturn[v.item] = true;
        end
    end
    TriggerClientEvent('ATM:ReturnCosmetic', source, CosmeticReturn)
end)

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end