
local cfg = module("armacore/cfg/cfg_licensecentre")

local prices = {
    {group = "Weed", price = 200000},
    {group = "Gang",price = 500000},
    {group = "Cocaine", price = 500000},
    {group = "Heroin", price = 10000000},
    {group = "LSD", price = 50000000},
    {group = "Rebel",price = 30000000},
    {group = "AdvancedRebel",price = 15000000},
    {group = "Scrap", price = 100000},
    {group = "Gold", price = 1000000},
    {group = "Diamond", price = 5000000},
    {group = "DJ", price = 50000000},
    {group = "polblips", price = 5000000},
    {group = "PilotLicense", price = 1500000},
}

RegisterServerEvent("LicenseCentre:BuyGroup")
AddEventHandler('LicenseCentre:BuyGroup', function(job, name)
    local source = source
    local userid = ARMA.getUserId(source)
    local coords = cfg.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if not ARMA.hasGroup(source, "Rebel") and job == "AdvancedRebel" then
        ARMAclient.notify(source, {"~r~You need to have Rebel License."})
        return
    end
    if #(playerCoords - coords) <= 15.0 then
        if ARMA.hasGroup(userid, job) then 
            ARMAclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("arma:PlaySound", source, 2)
        else
            for k,v in pairs(prices) do
                if v.group == job then
                    if ARMA.tryFullPayment(userid, v.price) then
                        ARMA.addUserGroup(userid,job)
                        ARMAclient.notify(source, {"~g~Purchased " .. name .. " for ".. '£' ..tostring(getMoneyStringFormatted(v.price)) .. " ❤️"})
                        tARMA.sendWebhook('purchases',"ARMA License Centre Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**")
                        TriggerClientEvent("arma:PlaySound", source, 1)
                    else 
                        ARMAclient.notify(source, {"~r~You do not have enough money to purchase this license!"})
                        TriggerClientEvent("arma:PlaySound", source, 2)
                    end
                end
            end
        end
    else 
        TriggerEvent("ARMA:acBan", userid, 11, GetPlayerName(source), source, 'Trigger License Menu Purchase')
    end
end)



function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

RegisterNetEvent("ARMA:GetLicenses")
AddEventHandler("ARMA:GetLicenses", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local licenses = {}
    if user_id ~= nil then
        for k, v in pairs(cfg.licenses) do
            if ARMA.hasGroup(user_id, v.group) then
                table.insert(licenses, v.name)
            end
        end
        TriggerClientEvent("ARMA:RecievedLicenses", source, licenses)
    end
end)


RegisterNetEvent('ARMA:RefundLicense')
AddEventHandler('ARMA:RefundLicense', function(group)
    local source = source
    user_id = ARMA.getUserId(source)
    if group == 'LSD' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 5000000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £5,000,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end 
    elseif group == 'Rebel' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 2500000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £2,500,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'AdvancedRebel' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 5000000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £5,000,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Gang' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 125000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £125,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Heroin' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 2500000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £2,500,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Diamond' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 1250000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £1,250,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Gold' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 250000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £250,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Cocaine' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 125000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £125,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Weed' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 50000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £50,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    elseif group == 'Scrap' then 
        if ARMA.hasGroup(user_id, group) then
            ARMA.removeUserGroup(user_id, group)
            ARMA.giveBankMoney(user_id, 25000)
            ARMAclient.notify(source, {'~g~You have refunded ' .. group .. ' for £25,000 [25% of License Price]'})
        else
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    end
end)

RegisterNetEvent('ARMA:SellLicense')
AddEventHandler('ARMA:SellLicense', function(group)
    local source = source 
    user_id = ARMA.getUserId(source)
    ARMAclient.getNearestPlayers(source,{15},function(nplayers)
        usrList = ""
        for k,v in pairs(nplayers) do
            usrList = usrList .. "[" .. ARMA.getUserId(k) .. "]" .. GetPlayerName(k) .. " | "
        end
        if ARMA.hasGroup(user_id, group) then
            if usrList ~= "" then
                ARMA.prompt(source,"Type the ID you want to sell this License too. " .. usrList,"",function(source,userid) 
                    ARMA.prompt(source,"How much do you want to sell the License for?","",function(source,price) 
                        local target = ARMA.getUserSource(tonumber(userid))
                        if price == tostring(tonumber(price)) then
                            if tonumber(price) >= 0 then 
                                ARMAclient.notify(source, {'~g~Sent Request.'})
                                ARMA.request(target,GetPlayerName(source).." wants to sell: " ..group.. " License for £"..price, 10, function(target,ok)
                                    if ok then
                                        if ARMA.tryBankPayment(tonumber(userid), tonumber(price)) then
                                            ARMA.giveBankMoney(user_id, tonumber(price))
                                            ARMA.removeUserGroup(user_id, group)
                                            ARMA.addUserGroup(tonumber(userid), group)

                                            ARMAclient.notify(source, {'~g~Sold ' .. group .. ' License for £' .. price .. ' to ' .. GetPlayerName(target) .. ' [ID: ' .. userid .. ']'})
                                            TriggerClientEvent("arma:PlaySound", source, 1)
                                            ARMAclient.notify(target, {'~g~Bought ' .. group .. ' License for £' .. price .. ' from ' .. GetPlayerName(source) .. ' [ID: ' .. user_id .. ']'})
                                            TriggerClientEvent("arma:PlaySound", target, 1)
                                            tARMA.sendWebhook('sell-to-nearest-player',"ARMA License Sale Logs", "> Seller Name: **"..GetPlayerName(source).. "**\n> Seller ID: **"..user_id.."**\n> Buyer Name: **"..GetPlayerName(target).."**\n> Buyer ID: **"..userid.."**\n> License Sold: **"..group.."**\n> Price: **£"..price.."**")
                                        else
                                            ARMAclient.notify(source, {'~r~User does not have enough money.'})
                                            ARMAclient.notify(target, {'~r~You do not have enough money.'})
                                        end
                                    else
                                        ARMAclient.notify(source, {'~r~User Denied.'})
                                        ARMAclient.notify(target, {'~r~You Denied.'})
                                        TriggerClientEvent("arma:PlaySound", source, 2)
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
            ARMAclient.notify(source, {'~r~Error, You do not have this License.'})
        end
    end)
end)