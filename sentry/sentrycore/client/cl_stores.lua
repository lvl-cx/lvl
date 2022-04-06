local cfg = module("sentrycore/cfg/cfg_stores")

RMenu.Add('SentryStores', 'main', RageUI.CreateMenu("Shop", "~b~Sentry Shop", 1300, 50))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("SentryStores", "main")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for k, v in pairs(cfg.shopItems) do
                RageUI.Button(v.name, nil, {RightLabel = "£"..v.price}, true, function(Hovered, Active, Selected)
                    if Selected then
                        TriggerServerEvent("Sentry:BuyStoreItem", v.itemID)
                    end
                end)
            end
        end)
    end
end)

local inMenu = false
local currentShop = nil

Citizen.CreateThread(function()
    for k, v in pairs(cfg.shops) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, 52)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.5)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
	    BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Shop")
        EndTextCommandSetBlipName(blip)
    end

    while true do
        Citizen.Wait(0)
        
        for k, v in pairs(cfg.shops) do
            if isInArea(v, 100.0) then
                DrawMarker(20, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 60, true, false, 2, true)
            end

            if isInArea(v, 1.0) and inMenu == false then
                alert('Press ~INPUT_VEH_HORN~ to open the Store!')
                if IsControlJustPressed(0, 51) then 
                    inMenu = true
                    currentShop = k
                    PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1)
                    RageUI.Visible(RMenu:Get("SentryStores", "main"), true)
                end
            end

            if isInArea(v, 1.0) == false and inMenu and k == currentShop then
                inMenu = false
                currentShop = nil
                RageUI.ActuallyCloseAll()
            end
        end
    end
end)