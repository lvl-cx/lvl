RMenu.Add('CivMenu', 'main', RageUI.CreateMenu("", "~g~Sentry CIV Menu",1300, 50))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('CivMenu', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()

            RageUI.Button("Ask ID", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('Sentry:AskID')
                end
            end)

			RageUI.Button("Give Money", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('Sentry:GiveMoney')
                end
            end)

			RageUI.Button("Search Player", nil, { RightLabel = "~g~→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('Sentry:SearchPlr')
                end
            end)


       end)
    end
end)


Citizen.CreateThread(function()
	while (true) do
		Citizen.Wait(0)
	  	if IsControlJustPressed(1, 311) then
			if not RageUI.Visible(RMenu:Get("CivMenu", "main"), true) then
				RageUI.Visible(RMenu:Get("CivMenu", "main"), true)
			else
                RageUI.ActuallyCloseAll()
				RageUI.Visible(RMenu:Get("CivMenu", "main"), false)
			end
	  	end
	end
end)
