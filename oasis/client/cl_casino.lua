insideDiamondCasino = false
AddEventHandler("OASIS:onClientSpawn",function(a, b)
    if b then
        local c = vector3(1121.7922363281, 239.42251586914, -50.440742492676)
        local d = function(e)
            insideDiamondCasino = true
            tOASIS.setCanAnim(false)
            tOASIS.overrideTime(12, 0, 0)
            TriggerEvent("OASIS:enteredDiamondCasino")
            TriggerServerEvent('OASIS:getChips')
        end
        local f = function(e)
            insideDiamondCasino = false
            tOASIS.setCanAnim(true)
            tOASIS.cancelOverrideTimeWeather()
            TriggerEvent("OASIS:exitedDiamondCasino")
        end
        local g = function(e)
        end
        tOASIS.createArea("diamondcasino", c, 100.0, 20, d, f, g, {})
    end
end)
