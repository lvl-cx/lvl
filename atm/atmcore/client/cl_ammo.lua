-- [CFG]
ammo = {}

ammo.location = vector3(-458.36862182617,-2274.5075683594,8.5158195495605)

ammo.marker = vector3(-458.36862182617,-2274.5075683594,8.5158195495605-0.98)

ammo.name = 'Ammo Trader'

ammo.banner = 'ammo'

-- [Start of RageUI]

RMenu.Add('Ammo', 'main', RageUI.CreateMenu("", "~g~ATM " .. ammo.name, 1300, 50, ammo.banner, ammo.banner))
RMenu.Add("Ammo", "confirm", RageUI.CreateSubMenu(RMenu:Get('Ammo', 'main',  1300, 50)))

ammo.types = {
    {name = "9mm Bullets", price = 500},
    {name = "12 Gauge Bullets", price = 750},
    {name = "7.62 Bullets", price = 1000},
    {name = "357 Bullets", price = 1500},
    {name = "5.56 NATO", price = 3000},
}

-- [Actual Menu]

RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get('Ammo', 'main')) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            for i , p in pairs(ammo.types) do 
                RageUI.Button(p.name , nil, { RightLabel = '~g~£' .. tostring(getMoneyStringFormatted(p.price)) }, true, function(Hovered, Active, Selected)
                    if Selected then

                        cPrice = p.price
                        cName = p.name

                    end
                end, RMenu:Get("Ammo", "confirm"))
            end

    end) 
end
end)


local AmmoNumbers = {
    '1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50',
    '51','52','53','54','55','56','57','58','59','60','61','62','63','64','65','66','67','68','69','70','71','72','73','74','75','76','77','78','79','80','81','82','83','84','85','86','87','88','89','90','91','92','93','94','95','96','97','98','99','100',
    '101','102','103','104','105','106','107','108','109','110','111','112','113','114','115','116','117','118','119','120','121','122','123','124','125','126','127','128','129','130','131','132','133','134','135','136','137','138','139','140','141','142','143','144','145','146','147','148','149','150',
    '151','152','153','154','155','156','157','158','159','160','161','162','163','164','165','166','167','168','169','170','171','172','173','174','175','176','177','178','179','180','181','182','183','184','185','186','187','188','189','190','191','192','193','194','195','196','197','198','199','200',
    '201','202','203','204','205','206','207','208','209','210','211','212','213','214','215','216','217','218','219','220','221','222','223','224','225','226','227','228','229','230','231','232','233','234','235','236','237','238','239','240','241','242','243','244','245','246','247','248','249','250',
}


local Index = 1
-- [Confirm Purchase]
RageUI.CreateWhile(1.0, true, function()
    if RageUI.Visible(RMenu:Get("Ammo", "confirm")) then
        RageUI.DrawContent({ header = true, glare = false, instructionalButton = true}, function()
            RageUI.Separator("Ammo Type: ~g~" .. cName, function() end)
            RageUI.Separator("Ammo Price: ~g~£" .. getMoneyStringFormatted(cPrice * Index), function() end)
            RageUI.Separator("Current Trader: ~g~" .. ammo.name, function() end)
        
            RageUI.List(cName, AmmoNumbers, Index, nil, {}, true, function(Hovered, Active, Selected, AIndex)
                if Hovered then
    
                end
    
                Index = AIndex
            end)
        RageUI.Button("Confirm" , nil, {RightLabel = "~g~→"}, true, function(Hovered, Active, Selected)
            if Selected then

                TriggerServerEvent('Ammo:BuyAmmo', cPrice * tonumber(Index), cName, tonumber(Index))

            end
        end, RMenu:Get("Ammo", "main"))

       

    end) 
end
end)

AmmoMenu = false
Citizen.CreateThread(function() 
    while true do
   
            local v1 = ammo.location

            if isInArea(v1, 500.0) then 
                DrawMarker(27, ammo.marker, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 2.5, 255, 0, 0, 250, 0, 0, 2, true, 0, 0, false)
            end
        
            if isInArea(v1, 0.8) then 
            
                alert('Press ~INPUT_VEH_HORN~ to access ' .. ammo.name)
                if IsControlJustPressed(0, 51) then
                    PlaySound(-1,"Hit","RESPAWN_SOUNDSET",0,0,1) 
                    RageUI.Visible(RMenu:Get("Ammo", "main"), true)
                    AmmoMenu = true

                end
            end

            if isInArea(v1, 0.8) == false and AmmoMenu then
                RageUI.ActuallyCloseAll()
                RageUI.Visible(RMenu:Get("Ammo", "main"), false)
                AmmoMenu = false
            end
     
        Citizen.Wait(1)
    end
end)


-- [Blip]
Citizen.CreateThread(function()
    blip = AddBlipForCoord(ammo.location)
    SetBlipSprite(blip, 549)
    SetBlipScale(blip, 0.6)
    SetBlipDisplay(blip, 2)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(ammo.name)
    EndTextCommandSetBlipName(blip)
end)





