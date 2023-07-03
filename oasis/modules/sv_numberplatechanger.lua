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

MySQL.createCommand("OASIS/update_numplate","UPDATE oasis_user_vehicles SET vehicle_plate = @registration WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("OASIS/check_numplate","SELECT * FROM oasis_user_vehicles WHERE vehicle_plate = @plate")

RegisterNetEvent('OASIS:getCars')
AddEventHandler('OASIS:getCars', function()
    local cars = {}
    local source = source
    local user_id = OASIS.getUserId(source)
    exports['ghmattimysql']:execute("SELECT * FROM `oasis_user_vehicles` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    cars[v.vehicle] = {v.vehicle, v.vehicle_plate}
                end
            end
            TriggerClientEvent('OASIS:carsTable', source, cars)
        end
    end)
end)

RegisterNetEvent("OASIS:ChangeNumberPlate")
AddEventHandler("OASIS:ChangeNumberPlate", function(vehicle)
	local source = source
    local user_id = OASIS.getUserId(source)
	OASIS.prompt(source,"Plate Name:","",function(source, plateName)
		if plateName == '' then return end
		exports['ghmattimysql']:execute("SELECT * FROM `oasis_user_vehicles` WHERE vehicle_plate = @plate", {plate = plateName}, function(result)
            if next(result) then 
                OASISclient.notify(source,{"~r~This plate is already taken."})
                return
			else
				for name in pairs(forbiddenNames) do
					if plateName == forbiddenNames[name] then
						OASISclient.notify(source,{"~r~You cannot have this plate."})
						return
					end
				end
				if OASIS.tryFullPayment(user_id,50000) then
					OASISclient.notify(source,{"~g~Changed plate of "..vehicle.." to "..plateName})
					MySQL.execute("OASIS/update_numplate", {user_id = user_id, registration = plateName, vehicle = vehicle})
					TriggerClientEvent("OASIS:RecieveNumberPlate", source, plateName)
					TriggerClientEvent("oasis:PlaySound", source, "apple")
					TriggerEvent('OASIS:getCars')
				else
					OASISclient.notify(source,{"~r~You don't have enough money!"})
				end
            end
        end)
	end)
end)

RegisterNetEvent("OASIS:checkPlateAvailability")
AddEventHandler("OASIS:checkPlateAvailability", function(plate)
	local source = source
    local user_id = OASIS.getUserId(source)
	MySQL.query("OASIS/check_numplate", {plate = plate}, function(result)
		if #result > 0 then 
			OASISclient.notify(source, {"~r~The plate "..plate.." is already taken."})
		else
			OASISclient.notify(source, {"~g~The plate "..plate.." is available."})
		end
	end)
end)
