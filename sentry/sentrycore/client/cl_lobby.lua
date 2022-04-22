local inLobby = false
local currentLobbyCoords = nil
local lobbys = {}

RMenu.Add("SentryGulag", "main", RageUI.CreateMenu("", "Sentry Gulag Menu", 1300, 50)) 

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("SentryGulag", "main")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        
        for k,v in pairs(lobbys) do
            RageUI.Button(k, nil, "", true, function(Hovered, Active, Selected)
                if (Selected) then
                        notify("~g~Joined Gulag Session!")
                        SetEntityCoords(PlayerPedId(), v.coords)
                        inLobby = true
                        currentLobbyCoords = v.coords
                        TriggerServerEvent("Sentry:SetBucket", v.bucket)
                        lobbys['Lobby ID:'] = nil
                end
            end)
        end

        if inLobby then
            RageUI.Button("~r~[Leave Current Lobby]", nil, "", true, function(Hovered, Active, Selected)
                if (Selected) then
                    inLobby = false
                    currentLobbyCoords = nil
                    TriggerServerEvent("Sentry:SetBucket", 0)
                end
            end)
        end

    end) 
end
end)

RegisterNetEvent("Sentry:RecieveLobbys")
AddEventHandler("Sentry:RecieveLobbys", function(name, coords, bucket)
    lobbys[name] = {
        coords = coords,
        bucket = bucket
    }
end)

RegisterCommand("lobbys", function()
    RageUI.Visible(RMenu:Get("SentryGulag", "main"), true)
end)

function notify(string)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(string)
    DrawNotification(true, false)
end

RegisterCommand('gulag', function()
    TriggerServerEvent("Sentry:AddLobby", 'Lobby ID:', vector3(-935.75769042969,-781.9248046875,15.921172142029))
end)

RegisterCommand('enter', function()

end)