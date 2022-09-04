local announceTables = {
    {permission = 'admin.managecommunitypot', info = {name = "Server Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/KKkU3XQ.png' },
    {permission = 'police.announce', info = {name = "PD Announcement", desc = "Announce something to the server", price = 10000}},
}

RegisterServerEvent("ARMA:getAnnounceMenu")
AddEventHandler("ARMA:getAnnounceMenu", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local hasPermsFor = {}
    for k,v in pairs(announceTables) do
        if ARMA.hasPermission(user_id, v.permission) then
            table.insert(hasPermsFor, v.info)
        end
    end
    TriggerClientEvent('ARMA:buildAnnounceMenu', source, hasPermsFor)
end)

RegisterServerEvent("ARMA:serviceAnnounce")
AddEventHandler("ARMA:serviceAnnounce", function(announceType)
    local source = source
    local user_id = ARMA.getUserId(source)
    for k,v in pairs(announceTables) do
        if v.info.name == announceType and ARMA.hasPermission(user_id, v.permission) then
            if ARMA.tryFullPayment(user_id, v.info.price) then
                ARMA.prompt(source,"Input text to announce","",function(source,data) 
                    ARMAclient.announce(-1, {v.image, data})
                    if v.info.price > 0 then
                        ARMAclient.notify(source, {"~g~Purchased a "..v.info.name.." for £"..v.info.price.." with content ~b~"..data})
                    else
                        ARMAclient.notify(source, {"~g~Sending a "..v.info.name.." with content ~b~"..data})
                    end
                end)
            else
                ARMAclient.notify(source, "~r~You do not have enough money to do this.")
            end
        else
            -- ac ban
        end
    end
end)