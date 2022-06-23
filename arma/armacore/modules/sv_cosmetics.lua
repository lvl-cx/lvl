
RegisterNetEvent('ARMA:BuyCosmetic')
AddEventHandler('ARMA:BuyCosmetic', function(cosmeticdata)
    local source = source
    local user_id = ARMA.getUserId(source)
 
    for i,v in pairs(cosmetics.cfg) do 
        if v.item == cosmeticdata then 
            if ARMA.hasGroup(user_id, cosmeticdata) then 
                ARMAclient.notify(source, {'~r~You already have this cosmetic.'})
                TriggerClientEvent("ARMA:PlaySound", source, 2)
            else
                if ARMA.tryBankPayment(user_id, v.price) then 
                    ARMA.addUserGroup(user_id, v.item)
                    ARMAclient.notify(source, {'~g~Bought ' .. v.item .. ' for for £' .. tostring(getMoneyStringFormatted(v.price))})
                    TriggerClientEvent("ARMA:PlaySound", source, 1)
                else 
                    ARMAclient.notify(source, {'~r~Not enough money.'})
                    TriggerClientEvent("ARMA:PlaySound", source, 2)
                end
            end
        end
    end
end) 

RegisterNetEvent('ARMA:RefundCosmetic')
AddEventHandler('ARMA:RefundCosmetic', function(cosmeticdata)
    local source = source
    local user_id = ARMA.getUserId(source)
 
    for i,v in pairs(cosmetics.cfg) do 
        if v.item == cosmeticdata then 
            if ARMA.hasGroup(user_id, v.item) then 
                ARMA.removeUserGroup(user_id, v.item)  
                ARMA.giveBankMoney(user_id, v.price * 0.25)
                ARMAclient.notify(source, {'~g~Refunded ' .. v.item .. ' Cosmetic for £' .. tostring(v.price * 0.25)})
                TriggerClientEvent('ARMA:ResetCosmetics', source, v.type)
                TriggerClientEvent("ARMA:PlaySound", source, 1)
            end
        end
    end
end) 

RegisterNetEvent('ARMA:SellCosmeticToPlayer')
AddEventHandler('ARMA:SellCosmeticToPlayer', function(cosmeticdata)
    local source = source 
    user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, cosmeticdata) then
        for i,v in pairs(cosmetics.cfg) do 
            if v.item == cosmeticdata then 
                ARMAclient.getNearestPlayers(source,{15},function(nplayers)
                    usrList = ""
                    for k,v in pairs(nplayers) do
                        usrList = usrList .. "[" .. ARMA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
                    end
                    if ARMA.hasGroup(user_id, v.item) then
                        if usrList ~= "" then
                            ARMA.prompt(source,"Type the ID you want to sell this Cosemetic too. " .. usrList,"",function(source,userid) 
                                ARMA.prompt(source,"How much do you want to sell the Cosmetic for?","",function(source,price) 
                                    local target = ARMA.getUserSource(tonumber(userid))
                                    if price == tostring(tonumber(price)) then
                                        if tonumber(price) >= 0 then 
     
                                           
                                                ARMAclient.notify(source, {'~g~Sent Request.'})
                                                ARMA.request(target,GetPlayerName(source).." wants to sell: " ..v.item.. " Cosmetic for £"..price, 10, function(target,ok)
                                                    if ok then
                                                        if ARMA.tryBankPayment(tonumber(userid), tonumber(price)) then
                                                            ARMA.giveBankMoney(user_id, tonumber(price))
                                                            ARMA.removeUserGroup(user_id, v.item)
                                                            ARMA.addUserGroup(tonumber(userid), v.item)
                                                        
                                                            ARMAclient.notify(source, {'~g~Sold ' .. v.item .. ' Cosmetic for £' .. getMoneyStringFormatted(price) .. ' to ' .. GetPlayerName(target) .. ' [ID: ' .. userid .. ']'})
                                                            TriggerClientEvent("ARMA:PlaySound", source, 1)
                                                            ARMAclient.notify(target, {'~g~Bought ' .. v.item .. ' Cosmetic for £' .. getMoneyStringFormatted(price) .. ' from ' .. GetPlayerName(source) .. ' [ID: ' .. user_id .. ']'})
                                                            TriggerClientEvent("ARMA:PlaySound", target, 1)
                                                            TriggerClientEvent('ARMA:ResetCosmetics', source, v.type)
                                                        else
                                                            ARMAclient.notify(source, {'~r~User does not have enough money.'})
                                                            ARMAclient.notify(target, {'~r~You do not have enough money.'})
                                                        end
                                                    else
                                                        ARMAclient.notify(source, {'~r~User Denied.'})
                                                        ARMAclient.notify(target, {'~r~You Denied.'})
                                                        TriggerClientEvent("ARMA:PlaySound", source, 2)
                                                    end
                                                end)
                                           
                                        else

                                            ARMAclient.notify(source, {'~r~No negative numbers.'})
                                        end
                                    else
                                        ARMAclient.notify(source, {'~r~The value you entered is not a number!'})
                                    end

                                end)
                            end)
                        else
                            ARMAclient.notify(source, {'~r~No players nearby.'})
                        end
                    else
                        ARMAclient.notify(source, {'~r~Error, You do not have this Cosmetic.'})
                    end
                end)
            end
        end
    end
end)

RegisterNetEvent('ARMA:CosmeticMarketPlace')
AddEventHandler('ARMA:CosmeticMarketPlace', function(cosmeticdata, price, message)
    user_id = ARMA.getUserId(source)
    if ARMA.hasGroup(user_id, cosmeticdata) then
        for i,v in pairs(cosmetics.cfg) do 
            if v.item == cosmeticdata then 
                local discord  = '[Discord Not Linked]'
                for k,v in pairs(GetPlayerIdentifiers(source)) do
                  if string.sub(v, 1, string.len("discord:")) == "discord:" then
                    discord = v
                  end
                end
                url = v.url
                webhook = "https://discord.com/api/webhooks/989539362075189319/Fj3qpkFyfIQdQbh5JdFfIYJ05zn8Wk_fFJROhdnC0a74eigkqU_ZARZKF7SNqhTDFZeA"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "ARMA Market", embeds = {
                    {
                        ["color"] = "16448403",
                        ["title"] = "ARMA Market Place",
                        ["image"] = {
                            ["url"] = url,
                        },
                        ["description"] = 'Cosmetic Item: **' .. v.item .. '**\n\nSeller Discord: <@' .. string.gsub(discord,'discord:','') ..'> \nSeller Perm ID: **' ..  ARMA.getUserId(source) .. '**\n\n Listing Price: ** £' .. getMoneyStringFormatted(price) .. '**\nStandard Price: **£' .. getMoneyStringFormatted(v.price).. '**\nCosmetic Type: **' .. v.type .. '**\nCustom Listing Message: ***' .. message .. '***',
                        ["footer"] = {
                            ["text"] = "",
                        },
                  }
                  }}), { ["Content-Type"] = "application/json" })
                  ARMAclient.notify(source, {'Listed ~g~' .. v.item .. ' onto ~g~#market-place for ~g~£' .. getMoneyStringFormatted(price)})
                  TriggerClientEvent("ARMA:PlaySound", source, 1)
            end
        end
    end
end)

RegisterNetEvent('ARMA:GetCosmetic')
AddEventHandler('ARMA:GetCosmetic', function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local CosmeticReturn = {}
 
    for i,v in pairs(cosmetics.cfg) do 
        if ARMA.hasGroup(user_id, v.item) then
            CosmeticReturn[v.item] = true;
        end
    end
    TriggerClientEvent('ARMA:ReturnCosmetic', source, CosmeticReturn)
end)

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end