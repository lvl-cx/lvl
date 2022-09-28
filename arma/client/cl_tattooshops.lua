local a = {
	vector3(-1153.6, -1425.6, 4.9),
	vector3(322.1, 180.4, 103.5),
	vector3(-3170.0, 1075.0, 20.8),
	vector3(1864.6, 3747.7, 33.0),
	vector3(-293.7, 6200.0, 31.4)
}

AddEventHandler("ARMA:onClientSpawn",function(D, E)
    if E then
        local d = function()
        end
        local e = function()
        end
        local f = function()
        end
        for g, h in pairs(a) do
            tARMA.addMarker(h.x, h.y, h.z - 0.2, 0.5, 0.5, 0.5, 0, 50, 255, 170, 50, 20, false, false, true)
            tARMA.addBlip(h.x, h.y, h.z, 75, 1, "Tattoo Shop")
        end
    end
end)