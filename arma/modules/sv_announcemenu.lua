local announceTables = {
    {permission = 'admin.managecommunitypot', info = {name = "Server Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/FZMys0F.png'},
    {permission = 'police.announce', info = {name = "PD Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/I7c5LsN.png'},
    {permission = 'nhs.announce', info = {name = "NHS Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/SypLbMo.png'},
    {permission = 'lfb.announce', info = {name = "LFB Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/AFqPgYk.png'},
    {permission = 'hmp.announce', info = {name = "HMP Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/rPF5FgQ.png'},
}

RegisterServerEvent("ARMA:getAnnounceMenu")
AddEventHandler("ARMA:getAnnounceMenu", function()
    local source = source
    local user_id = ARMA.getUserId(source)
    local hasPermsFor = {}
    for k,v in pairs(announceTables) do
        if ARMA.hasPermission(user_id, v.permission) or ARMA.hasGroup(user_id, 'Founder') then
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
        if v.info.name == announceType and (ARMA.hasPermission(user_id, v.permission) or ARMA.hasGroup(user_id, 'Founder')) then
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
                ARMAclient.notify(source, {"~r~You do not have enough money to do this."})
            end
        else
            -- ac ban
        end
    end
end)