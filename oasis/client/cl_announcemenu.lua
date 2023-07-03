RMenu.Add("oasisannouncements","main",RageUI.CreateMenu("","~b~Announcement Menu",tOASIS.getRageUIMenuWidth(),tOASIS.getRageUIMenuHeight(),"banners","announcement"))
local a = {}
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('oasisannouncements', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = false}, function()
            for b, c in pairs(a) do
                RageUI.Button(c.name, string.format("%s Price: £%s", c.desc, getMoneyStringFormatted(c.price)), {RightLabel = "→→→"}, true, function(d, e, f)
                    if f then
                        TriggerServerEvent("OASIS:serviceAnnounce", c.name)
                    end
                end)
            end
        end)
    end
end)

RegisterNetEvent("OASIS:serviceAnnounceCl",function(h, i)
    tOASIS.announce(h, i)
end)

RegisterNetEvent("OASIS:buildAnnounceMenu",function(g)
    a = g
    RageUI.Visible(RMenu:Get("oasisannouncements", "main"), not RageUI.Visible(RMenu:Get("oasisannouncements", "main")))
end)

RegisterCommand("announcemenu",function()
    TriggerServerEvent('OASIS:getAnnounceMenu')
end)
