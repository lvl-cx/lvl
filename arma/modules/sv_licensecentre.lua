
local cfg = module("cfg/cfg_licensecentre")

RegisterServerEvent("LicenseCentre:BuyGroup")
AddEventHandler('LicenseCentre:BuyGroup', function(job, name)
    local source = source
    local user_id = ARMA.getUserId(source)
    local coords = cfg.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if not ARMA.hasGroup(user_id, "Rebel") and job == "AdvancedRebel" then
        ARMAclient.notify(source, {"~r~You need to have Rebel License."})
        return
    end
    if #(playerCoords - coords) <= 15.0 then
        if ARMA.hasGroup(user_id, job) then 
            ARMAclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("arma:PlaySound", source, 2)
        else
            for k,v in pairs(cfg.licenses) do
                if v.group == job then
                    if ARMA.tryFullPayment(user_id, v.price) then
                        ARMA.addUserGroup(user_id,job)
                        ARMAclient.notify(source, {"~g~Purchased " .. name .. " for ".. '£' ..tostring(getMoneyStringFormatted(v.price)) .. " ❤️"})
                        tARMA.sendWebhook('purchases',"ARMA License Centre Logs", "> Player Name: **"..GetPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**")
                        TriggerClientEvent("arma:PlaySound", source, 1)
                        TriggerClientEvent("ARMA:gotOwnedLicenses", source, getLicenses(user_id))
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

function getLicenses(user_id)
    local licenses = {}
    if user_id ~= nil then
        for k, v in pairs(cfg.licenses) do
            if ARMA.hasGroup(user_id, v.group) then
                table.insert(licenses, v.name)
            end
        end
        return licenses
    end
end

RegisterNetEvent("ARMA:GetLicenses")
AddEventHandler("ARMA:GetLicenses", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("ARMA:RecievedLicenses", source, getLicenses(user_id))
    end
end)

RegisterNetEvent("ARMA:getOwnedLicenses")
AddEventHandler("ARMA:getOwnedLicenses", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("ARMA:gotOwnedLicenses", source, getLicenses(user_id))
    end
end)