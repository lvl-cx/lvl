local a = nil
local b = module("armacore/cfg/cfg_trader")
Citizen.CreateThread(    function()
    local k = tARMA.loadAnimDict("mini@strip_club@idles@bouncer@base")
    for l, m in pairs(b.trader) do
        tARMA.addMarker(m.position.x,m.position.y,m.position.z,0.7,0.7,0.5,m.colour.r,m.colour.g,m.colour.b,125,50,29,true,true)
        tARMA.createDynamicPed(m.dealerModel,m.dealerPos + vector3(0.0, 0.0, -1.0),m.dealerHeading,true,"mini@strip_club@idles@bouncer@base","base",100,false)
    end
end)

local firstspawn = 0
AddEventHandler('playerSpawned', function(spawn)
	if firstspawn == 0 then
		local s = function(t)
        end
        local u = function(t)
            RageUI.Visible(RMenu:Get('SellerMenu', 'main'), false)
            RageUI.ActuallyCloseAll()
        end
        local v = function(t)
            if IsControlJustPressed(1, 38) then
                a = t.traderName
                RageUI.Visible(RMenu:Get('SellerMenu', 'main'), not RageUI.Visible(RMenu:Get('SellerMenu', 'main')))
            end
            local w, x, y = table.unpack(GetFinalRenderedCamCoord())
            DrawText3D(b.trader[t.traderId].position.x,b.trader[t.traderId].position.y,b.trader[t.traderId].position.z,"Press [E] to open seller",w,x,y)
        end
        for z, m in pairs(b.trader) do
            if m.type == 'Legal' then
                tARMA.createArea("trader_" .. z, m.position, 1.5, 6, s, u, v, {traderId = z, traderName = m.type})
            end
        end
		firstspawn = 1
	end
end)
