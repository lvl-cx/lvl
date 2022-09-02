RMenu.Add("armaannouncements","main",RageUI.CreateMenu("","~b~Announcement Menu",tARMA.getRageUIMenuWidth(),tARMA.getRageUIMenuHeight(),"cmg_announceui","cmg_announceui"))
local a = {}
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('armaannouncements', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for b, c in pairs(a) do
                RageUI.Button(c.name, string.format("%s Price: £%s", c.desc, getMoneyStringFormatted(c.price)), {RightLabel = "→→→"}, true, function(d, e, f)
                    if f then
                        TriggerServerEvent("ARMA:serviceAnnounce", c.name)
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent("ARMA:buildAnnounceMenu",function(g)
    a = g
    RageUI.Visible(RMenu:Get("armaannouncements", "main"), not RageUI.Visible(RMenu:Get("armaannouncements", "main")))
end)

RegisterCommand("announcemenu",function()
    TriggerServerEvent('ARMA:getAnnounceMenu')
end)
