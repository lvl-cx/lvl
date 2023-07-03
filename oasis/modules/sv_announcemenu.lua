local announceTables = {
    {permission = 'admin.managecommunitypot', info = {name = "Server Announcement", desc = "Announce something to the server", price = 0}, image = 'https://i.imgur.com/FZMys0F.png'},
    {permission = 'police.announce', info = {name = "PD Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/I7c5LsN.png'},
    {permission = 'nhs.announce', info = {name = "NHS Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/SypLbMo.png'},
    {permission = 'lfb.announce', info = {name = "LFB Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/AFqPgYk.png'},
    {permission = 'hmp.announce', info = {name = "HMP Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://i.imgur.com/rPF5FgQ.png'},
}

RegisterServerEvent("OASIS:getAnnounceMenu")
AddEventHandler("OASIS:getAnnounceMenu", function()
    local source = source
    local user_id = OASIS.getUserId(source)
    local hasPermsFor = {}
    for k,v in pairs(announceTables) do
        if OASIS.hasPermission(user_id, v.permission) or OASIS.hasGroup(user_id, 'Founder') then
            table.insert(hasPermsFor, v.info)
        end
    end
    if #hasPermsFor > 0 then
        TriggerClientEvent("OASIS:buildAnnounceMenu", source, hasPermsFor)
    end
end)

RegisterServerEvent("OASIS:serviceAnnounce")
AddEventHandler("OASIS:serviceAnnounce", function(announceType)
    local source = source
    local user_id = OASIS.getUserId(source)
    for k,v in pairs(announceTables) do
        if v.info.name == announceType then
            if OASIS.hasPermission(user_id, v.permission) or OASIS.hasGroup(user_id, 'Founder') then
                if OASIS.tryFullPayment(user_id, v.info.price) then
                    OASIS.prompt(source,"Input text to announce","",function(source,data) 
                        TriggerClientEvent('OASIS:serviceAnnounceCl', -1, v.image, data)
                        if v.info.price > 0 then
                            OASISclient.notify(source, {"~g~Purchased a "..v.info.name.." for £"..v.info.price.." with content ~b~"..data})
                        else
                            OASISclient.notify(source, {"~g~Sending a "..v.info.name.." with content ~b~"..data})
                        end
                    end)
                else
                    OASISclient.notify(source, {"~r~You do not have enough money to do this."})
                end
            else
                TriggerEvent("OASIS:acBan", user_id, 11, GetPlayerName(source), source, 'Attempted to Trigger an announcement')
            end
        end
    end
end)