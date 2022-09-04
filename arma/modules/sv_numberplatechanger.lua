local forbiddenNames = {
	"%^1",
	"%^2",
	"%^3",
	"%^4",
	"%^5",
	"%^6",
	"%^7",
	"%^8",
	"%^9",
	"%^%*",
	"%^_",
	"%^=",
	"%^%~",
	"admin",
	"nigger",
	"cunt",
	"faggot",
	"fuck",
	"fucker",
	"fucking",
	"anal",
	"stupid",
	"damn",
	"cock",
	"cum",
	"dick",
	"dipshit",
	"dildo",
	"douchbag",
	"douch",
	"kys",
	"jerk",
	"jerkoff",
	"gay",
	"homosexual",
	"lesbian",
	"suicide",
	"mothafucka",
	"negro",
	"pussy",
	"queef",
	"queer",
	"weeb",
	"retard",
	"masterbate",
	"suck",
	"tard",
	"allahu akbar",
	"terrorist",
	"twat",
	"vagina",
	"wank",
	"whore",
	"wanker",
	"n1gger",
	"f4ggot",
	"n0nce",
	"d1ck",
	"h0m0",
	"n1gg3r",
	"h0m0s3xual",
	"free up mandem",
	"nazi",
	"hitler",
	"cheater",
	"cheating",
}

MySQL.createCommand("ARMA/update_numplate","UPDATE arma_user_vehicles SET vehicle_plate = @registration WHERE user_id = @user_id AND vehicle = @vehicle")

RegisterNetEvent('ARMA:getCars')
AddEventHandler('ARMA:getCars', function()
    local cars = {}
    local source = source
    local user_id = ARMA.getUserId(source)
    exports['ghmattimysql']:execute("SELECT * FROM `arma_user_vehicles` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    cars[v.vehicle] = {v.vehicle, v.vehicle_plate}
                end
            end
            TriggerClientEvent('ARMA:carsTable', source, cars)
        end
    end)
end)

RegisterNetEvent("ARMA:ChangeNumberPlate")
AddEventHandler("ARMA:ChangeNumberPlate", function(vehicle)
    local user_id = ARMA.getUserId(source)
	ARMA.prompt(source,"Plate Name:","",function(source, plateName)
		if plateName == '' then return end
		exports['ghmattimysql']:execute("SELECT * FROM `arma_user_vehicles` WHERE vehicle_plate = @plate", {plate = plateName}, function(result)
            if next(result) then 
                ARMAclient.notify(source,{"~r~This plate is already taken."})
                return
			else
				for name in pairs(forbiddenNames) do
					if plateName == forbiddenNames[name] then
						ARMAclient.notify(source,{"~r~You cannot have this plate."})
						return
					end
				end
				if ARMA.tryFullPayment(user_id,50000) then
					ARMAclient.notify(source,{"~g~Changed plate of "..vehicle.." to "..plateName})
					MySQL.execute("ARMA/update_numplate", {user_id = user_id, registration = plateName, vehicle = vehicle})
					TriggerClientEvent("ARMA:RecieveNumberPlate", source, plateName)
					TriggerClientEvent("arma:PlaySound", source, "apple")
					TriggerEvent('ARMA:getCars')
				else
					ARMAclient.notify(source,{"~r~You don't have enough money!"})
				end
            end
        end)
	end)
end)
