
RegisterNetEvent('LVL:BuyCosmetic')
AddEventHandler('LVL:BuyCosmetic', function(cosmeticdata)
    local source = source
    local user_id = LVL.getUserId(source)
 
    for i,v in pairs(cosmetics.cfg) do 
        if v.item == cosmeticdata then 
            if LVL.hasGroup(user_id, cosmeticdata) then 
                LVLclient.notify(source, {'~r~You already have this cosmetic.'})
                TriggerClientEvent("LVL:PlaySound", source, 2)
            else
                if LVL.tryBankPayment(user_id, v.price) then 
                    LVL.addUserGroup(user_id, v.item)
                    LVLclient.notify(source, {'~g~Bought ' .. v.item .. ' for for £' .. tostring(getMoneyStringFormatted(v.price))})
                    TriggerClientEvent("LVL:PlaySound", source, 1)
                else 
                    LVLclient.notify(source, {'~r~Not enough money.'})
                    TriggerClientEvent("LVL:PlaySound", source, 2)
                end
            end
        end
    end
end) 

RegisterNetEvent('LVL:RefundCosmetic')
AddEventHandler('LVL:RefundCosmetic', function(cosmeticdata)
    local source = source
    local user_id = LVL.getUserId(source)
 
    for i,v in pairs(cosmetics.cfg) do 
        if v.item == cosmeticdata then 
            if LVL.hasGroup(user_id, v.item) then 
                LVL.removeUserGroup(user_id, v.item)  
                LVL.giveBankMoney(user_id, v.price * 0.25)
                LVLclient.notify(source, {'~g~Refunded ' .. v.item .. ' Cosmetic for £' .. tostring(v.price * 0.25)})
                TriggerClientEvent('LVL:ResetCosmetics', source, v.type)
                TriggerClientEvent("LVL:PlaySound", source, 1)
            end
        end
    end
end) 

RegisterNetEvent('LVL:SellCosmeticToPlayer')
AddEventHandler('LVL:SellCosmeticToPlayer', function(cosmeticdata)
    local source = source 
    user_id = LVL.getUserId(source)
    if LVL.hasGroup(user_id, cosmeticdata) then
        for i,v in pairs(cosmetics.cfg) do 
            if v.item == cosmeticdata then 
                LVLclient.getNearestPlayers(source,{15},function(nplayers)
                    usrList = ""
                    for k,v in pairs(nplayers) do
                        usrList = usrList .. "[" .. LVL.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
                    end
                    if LVL.hasGroup(user_id, v.item) then
                        if usrList ~= "" then
                            LVL.prompt(source,"Type the ID you want to sell this Cosemetic too. " .. usrList,"",function(source,userid) 
                                LVL.prompt(source,"How much do you want to sell the Cosmetic for?","",function(source,price) 
                                    local target = LVL.getUserSource(tonumber(userid))
                                    if price == tostring(tonumber(price)) then
                                        if tonumber(price) >= 0 then 
     
                                           
                                                LVLclient.notify(source, {'~g~Sent Request.'})
                                                LVL.request(target,GetPlayerName(source).." wants to sell: " ..v.item.. " Cosmetic for £"..price, 10, function(target,ok)
                                                    if ok then
                                                        if LVL.tryBankPayment(tonumber(userid), tonumber(price)) then
                                                            LVL.giveBankMoney(user_id, tonumber(price))
                                                            LVL.removeUserGroup(user_id, v.item)
                                                            LVL.addUserGroup(tonumber(userid), v.item)
                                                        
                                                            LVLclient.notify(source, {'~g~Sold ' .. v.item .. ' Cosmetic for £' .. getMoneyStringFormatted(price) .. ' to ' .. GetPlayerName(target) .. ' [ID: ' .. userid .. ']'})
                                                            TriggerClientEvent("LVL:PlaySound", source, 1)
                                                            LVLclient.notify(target, {'~g~Bought ' .. v.item .. ' Cosmetic for £' .. getMoneyStringFormatted(price) .. ' from ' .. GetPlayerName(source) .. ' [ID: ' .. user_id .. ']'})
                                                            TriggerClientEvent("LVL:PlaySound", target, 1)
                                                            TriggerClientEvent('LVL:ResetCosmetics', source, v.type)
                                                        else
                                                            LVLclient.notify(source, {'~r~User does not have enough money.'})
                                                            LVLclient.notify(target, {'~r~You do not have enough money.'})
                                                        end
                                                    else
                                                        LVLclient.notify(source, {'~r~User Denied.'})
                                                        LVLclient.notify(target, {'~r~You Denied.'})
                                                        TriggerClientEvent("LVL:PlaySound", source, 2)
                                                    end
                                                end)
                                           
                                        else

                                            LVLclient.notify(source, {'~r~No negative numbers.'})
                                        end
                                    else
                                        LVLclient.notify(source, {'~r~The value you entered is not a number!'})
                                    end

                                end)
                            end)
                        else
                            LVLclient.notify(source, {'~r~No players nearby.'})
                        end
                    else
                        LVLclient.notify(source, {'~r~Error, You do not have this Cosmetic.'})
                    end
                end)
            end
        end
    end
end)

RegisterNetEvent('LVL:CosmeticMarketPlace')
AddEventHandler('LVL:CosmeticMarketPlace', function(cosmeticdata, price, message)
    user_id = LVL.getUserId(source)
    if LVL.hasGroup(user_id, cosmeticdata) then
        for i,v in pairs(cosmetics.cfg) do 
            if v.item == cosmeticdata then 
                local discord  = '[Discord Not Linked]'
                for k,v in pairs(GetPlayerIdentifiers(source)) do
                  if string.sub(v, 1, string.len("discord:")) == "discord:" then
                    discord = v
                  end
                end
                url = v.url
                webhook = "https://discord.com/api/webhooks/972459190020890715/v2D0xPXtQECtTRFSYyBDnXtMyEFczOvfaksXdB77iiKL-rFMqJ1ykXVJq19lihp2VA-L"
                PerformHttpRequest(webhook, function(err, text, headers) 
                end, "POST", json.encode({username = "LVL Market", embeds = {
                    {
                        ["color"] = "7393516",
                        ["title"] = "LVL Market Place",
                        ["image"] = {
                            ["url"] = url,
                        },
                        ["description"] = 'Cosmetic Item: **' .. v.item .. '**\n\nSeller Discord: <@' .. string.gsub(discord,'discord:','') ..'> \nSeller Perm ID: **' ..  LVL.getUserId(source) .. '**\n\n Listing Price: ** £' .. getMoneyStringFormatted(price) .. '**\nStandard Price: **£' .. getMoneyStringFormatted(v.price).. '**\nCosmetic Type: **' .. v.type .. '**\nCustom Listing Message: ***' .. message .. '***',
                        ["footer"] = {
                            ["text"] = "",
                        },
                  }
                  }}), { ["Content-Type"] = "application/json" })
                  LVLclient.notify(source, {'Listed ~g~' .. v.item .. ' onto ~g~#market-place for ~g~£' .. getMoneyStringFormatted(price)})
                  TriggerClientEvent("LVL:PlaySound", source, 1)
            end
        end
    end
end)

RegisterNetEvent('LVL:GetCosmetic')
AddEventHandler('LVL:GetCosmetic', function()
    local source = source
    local user_id = LVL.getUserId(source)
    local CosmeticReturn = {}
 
    for i,v in pairs(cosmetics.cfg) do 
        if LVL.hasGroup(user_id, v.item) then
            CosmeticReturn[v.item] = true;
        end
    end
    TriggerClientEvent('LVL:ReturnCosmetic', source, CosmeticReturn)
end)

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end