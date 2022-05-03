local carrying = {}
--carrying[source] = targetSource, source is carrying targetSource
local carried = {}
--carried[targetSource] = source, targetSource is being carried by source

RegisterServerEvent("CarryPeople:sync")
AddEventHandler("CarryPeople:sync", function(targetSrc)
	local targetSrc = targetSrc
	local sourcePed = GetPlayerPed(source)
   	local sourceCoords = GetEntityCoords(sourcePed)
	local targetPed = GetPlayerPed(targetSrc)
    local targetCoords = GetEntityCoords(targetPed)
	if #(sourceCoords - targetCoords) <= 3.0 then 
		TriggerClientEvent("CarryPeople:syncTarget", targetSrc, source)
		carrying[source] = targetSrc
		carried[targetSrc] = source
	end
end)

RegisterServerEvent("CarryPeople:stop")
AddEventHandler("CarryPeople:stop", function(targetSrc)
	local source = source

	if carrying[source] then
		TriggerClientEvent("CarryPeople:cl_stop", targetSrc)
		carrying[source] = nil
		carried[targetSrc] = nil
	elseif carried[source] then
		TriggerClientEvent("CarryPeople:cl_stop", carried[source])			
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	if carrying[source] then
		TriggerClientEvent("CarryPeople:cl_stop", carrying[source])
		carried[carrying[source]] = nil
		carrying[source] = nil
	end

	if carried[source] then
		TriggerClientEvent("CarryPeople:cl_stop", carried[source])
		carrying[carried[source]] = nil
		carried[source] = nil
	end
end)


RegisterServerEvent("Infinite:CarryRequest")
AddEventHandler("Infinite:CarryRequest", function(targetSrc)
	local senderSrc = source
	local targetSrc = targetSrc
	local senderSrcName = GetPlayerName(senderSrc)
	userid = LVL.getUserId(senderSrc)
	if LVL.hasPermission(userid, 'staffon.perm') then 
		TriggerClientEvent("Infinite:StartCarry",senderSrc,targetSrc)
	else
		LVLclient.notify(targetSrc,{"Player: ~b~"..senderSrcName.."~w~ is trying to carry you, press ~b~=~w~ to accept or ~r~-~w~ to refuse"})
		LVLclient.notify(senderSrc,{"Sent carry request to Temp ID: "..targetSrc})
		TriggerClientEvent('Infinite:CarryTargetAsk', targetSrc, senderSrc)
	end

end)

RegisterServerEvent("Infinite:CarryAccepted")
AddEventHandler("Infinite:CarryAccepted", function(senderSrc)
	local senderSrc = senderSrc
	local targetSrc = source
	local targetSrcName = GetPlayerName(targetSrc)
	LVLclient.notify(targetSrc,{"~b~Carry request accepted."})
	LVLclient.notify(senderSrc,{"~b~Your carry request to "..targetSrcName.." has been accepted."})
	TriggerClientEvent("Infinite:StartCarry",senderSrc,targetSrc)
end)

RegisterServerEvent("Infinite:CarryDeclined")
AddEventHandler("Infinite:CarryDeclined", function(senderSrc)
	local senderSrc = senderSrc
	local targetSrc = source
	local targetSrcName = GetPlayerName(targetSrc)
	LVLclient.notify(senderSrc,{"~r~Your carry request to "..targetSrcName.." has been declined."})
	LVLclient.notify(targetSrc,{"~r~Carry request denied."})
end)