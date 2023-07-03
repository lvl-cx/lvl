local takingHostage = {}
--takingHostage[source] = targetSource, source is takingHostage targetSource
local takenHostage = {}
--takenHostage[targetSource] = source, targetSource is being takenHostage by source

RegisterServerEvent("OASIS:takeHostageSync")
AddEventHandler("OASIS:takeHostageSync", function(targetSrc)
	local source = source
	TriggerClientEvent("OASIS:takeHostageSyncTarget", targetSrc, source)
	takingHostage[source] = targetSrc
	takenHostage[targetSrc] = source
end)

RegisterServerEvent("OASIS:takeHostageReleaseHostage")
AddEventHandler("OASIS:takeHostageReleaseHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("OASIS:takeHostageReleaseHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("OASIS:takeHostageKillHostage")
AddEventHandler("OASIS:takeHostageKillHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("OASIS:takeHostageKillHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("OASIS:takeHostageStop")
AddEventHandler("OASIS:takeHostageStop", function(targetSrc)
	local source = source
	if takingHostage[source] then
		TriggerClientEvent("OASIS:takeHostageCl_stop", targetSrc)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	elseif takenHostage[source] then
		TriggerClientEvent("OASIS:takeHostageCl_stop", targetSrc)
		takenHostage[source] = nil
		takingHostage[targetSrc] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	if takingHostage[source] then
		TriggerClientEvent("OASIS:takeHostageCl_stop", takingHostage[source])
		takenHostage[takingHostage[source]] = nil
		takingHostage[source] = nil
	end
	if takenHostage[source] then
		TriggerClientEvent("OASIS:takeHostageCl_stop", takenHostage[source])
		takingHostage[takenHostage[source]] = nil
		takenHostage[source] = nil
	end
end)