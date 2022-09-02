
licensecentre = {}

licensecentre.location = vector3(-547.06958007812,-199.6887512207,47.414916992188)

licensecentre.prices = {
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
}

RegisterServerEvent("LicenseCentre:BuyGroup")
AddEventHandler('LicenseCentre:BuyGroup', function(job, name)
    local source = source
    local userid = ARMA.getUserId(source)
    local coords = licensecentre.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)

    if #(playerCoords - coords) <= 15.0 then
        if ARMA.hasGroup(userid, job) then 
            ARMAclient.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("arma:PlaySound", source, 2)
        else
            for k,v in pairs(licensecentre.prices) do
                if v.group == job then
                    if ARMA.tryFullPayment(userid, v.price) then
                        ARMA.addUserGroup(userid,job)
                        ARMAclient.notify(source, {"~g~Purchased " .. name .. " for ".. '£' ..tostring(getMoneyStringFormatted(v.price)) .. " ❤️"})
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
