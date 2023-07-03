Citizen.CreateThread(function()
    AddTextEntry('FE_THDR_GTAO','OASIS British RP - discord.gg/oasisv')
    AddTextEntry("PM_PANE_CFX","OASIS")
end)
RegisterCommand("discord",function()
    TriggerEvent("chatMessage","^1[OASIS]^1  ",{ 128, 128, 128 },"^0Discord: discord.gg/oasisv","ooc")
    tOASIS.notify("~g~discord Copied to Clipboard.")
    tOASIS.CopyToClipBoard("https://discord.gg/OASIS")
end)
RegisterCommand("ts",function()
    TriggerEvent("chatMessage","^1[OASIS]^1  ",{ 128, 128, 128 },"^0TS: ts.oasisforums.net","ooc")
    tOASIS.notify("~g~ts Copied to Clipboard.")
    tOASIS.CopyToClipBoard("ts.oasisforums.net")
end)
RegisterCommand("website",function()
    TriggerEvent("chatMessage","^1[OASIS]^1  ",{ 128, 128, 128 },"^0Forums: www.oasisforums.net","ooc")
    tOASIS.notify("~g~Website Copied to Clipboard.")
    tOASIS.CopyToClipBoard("www.oasisforums.net")
end)

RegisterCommand('getid', function(source, args)
    if args and args[1] then 
        if tOASIS.clientGetUserIdFromSource(tonumber(args[1])) ~= nil then
            if tOASIS.clientGetUserIdFromSource(tonumber(args[1])) ~= tOASIS.getUserId() then
                TriggerEvent("chatMessage","^1[OASIS]^1  ",{ 128, 128, 128 }, "This Users Perm ID is: " .. tOASIS.clientGetUserIdFromSource(tonumber(args[1])), "alert")
            else
                TriggerEvent("chatMessage","^1[OASIS]^1  ",{ 128, 128, 128 }, "This Users Perm ID is: " .. tOASIS.getUserId(), "alert")
            end
        else
            TriggerEvent("chatMessage","^1[OASIS]^1  ",{ 128, 128, 128 }, "Invalid Temp ID", "alert")
        end
    else 
        TriggerEvent("chatMessage","^1[OASIS]^1  ",{ 128, 128, 128 }, "Please specify a user eg: /getid [tempid]", "alert")
    end
end)
