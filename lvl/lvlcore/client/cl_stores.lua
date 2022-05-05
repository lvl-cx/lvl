local cfg = module("lvlcore/cfg/cfg_stores")

RMenu.Add('LVLStores', 'main', RageUI.CreateMenu("", "~g~LVL Shop", 1300, 50, 'shop', 'shop'))
RMenu.Add("LVLStores", "confirm", RageUI.CreateSubMenu(RMenu:Get('LVLStores', 'main',  1300, 50)))

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("LVLStores", "main")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for k, v in pairs(cfg.shopItems) do
                RageUI.Button(v.name, nil, {RightLabel = "~g~£".. getMoneyStringFormatted(v.price)}, true, function(Hovered, Active, Selected)
                    if Selected then
                        cPrice = v.price
                        cHash = v.itemID
                        cName = v.name
                        cDescription = v.description
                    end
                end, RMenu:Get("LVLStores", "confirm"))
            end
        end)
    end
end)

local ShopAMT = {
    '1','2','3','4','5','6','7','8','9','10'
}

local Index = 1
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("LVLStores", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
        RageUI.Separator("Item Name: ~g~" .. cName, function() end)
        RageUI.Separator("Item Price: ~g~£" .. getMoneyStringFormatted(cPrice * Index), function() end)
        RageUI.Separator("Item Description: ~g~" .. cDescription, function() end)
        --RageUI.Separator("Are you sure you want to purchase this Item?", function() end)
        RageUI.List(cName, ShopAMT, Index, nil, {}, true, function(Hovered, Active, Selected, AIndex)
            if Hovered then

            end

            Index = AIndex
        end)
        RageUI.Button("Confirm Purchase" , nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent("LVL:BuyStoreItem", cHash, cPrice * Index, tonumber(Index), cLoaction)

            end
        end, RMenu:Get("LVLStores", "main"))

       

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
                --DrawMarker(20, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 60, true, false, 2, true)
                DrawMarker(29, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.4, 14, 212, 0, 250, true, true, false, false, nil, nil, false)
            end

            if isInArea(v, 1.0) and inMenu == false then
                alert('Press ~INPUT_VEH_HORN~ to open the Store')
                if IsControlJustPressed(0, 51) then 
                    inMenu = true
                    currentShop = k
                    PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1)
                    RageUI.Visible(RMenu:Get("LVLStores", "main"), true)
                    cLoaction = v
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