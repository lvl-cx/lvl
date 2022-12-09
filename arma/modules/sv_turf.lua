turfData = {
    {name = 'Weed', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300}, -- weed
    {name = 'Cocaine', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300}, -- cocaine
    {name = 'Meth', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300}, -- meth
    {name = 'Heroin', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300}, -- heroin
    {name = 'LargeArms', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300}, -- large arms
    {name = 'LSDNorth', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300}, -- lsd north
    {name = 'LSDSouth', gangOwner = "N/A", commission = 0, beingCaptured = false, timeLeft = 300} -- lsd south
}


RegisterNetEvent('ARMA:refreshTurfOwnershipData')
AddEventHandler('ARMA:refreshTurfOwnershipData', function()
    local source = source
	local user_id = ARMA.getUserId(source)
	local data = turfData
	exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
		for K,V in pairs(gotGangs) do
			for I,L in pairs(json.decode(V.gangmembers)) do
				if tostring(user_id) == I then
					for a,b in pairs(data) do
						if b.gangOwner == V.gangname then
							data[a].ownership = true
						end
						TriggerClientEvent('ARMA:updateTurfOwner', source, a, b.gangOwner)
					end
					TriggerClientEvent('ARMA:gotTurfOwnershipData', source, data)
					ARMA.updateTraderInfo()
				end
			end
		end
	end)
end)

RegisterNetEvent('ARMA:checkTurfCapture')
AddEventHandler('ARMA:checkTurfCapture', function(turfid)
    local source = source
	local user_id = ARMA.getUserId(source)
	if ARMA.hasGroup(user_id, 'Gang') then
		exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
			for K,V in pairs(gotGangs) do
				local array = json.decode(V.gangmembers)
				for I,L in pairs(array) do
					if tostring(user_id) == I then
						TriggerClientEvent('ARMA:captureOwnershipReturned', source, turfid, (turfData[turfid].gangOwner == V.gangname), turfData[turfid].name)
						return
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('ARMA:gangDefenseLocationUpdate')
AddEventHandler('ARMA:gangDefenseLocationUpdate', function(turfname, atkdfnd, trueorfalse)
    local source = source
	local user_id = ARMA.getUserId(source)
	local turfID = 0
	for k,v in pairs(turfData) do
		if v.name == turfname then
			turfID = k
		end
	end
	if atkdfnd == 'Attackers' then
		if trueorfalse then
			turfData[turfID].beingCaptured = false
			turfData[turfID].timeLeft = 300
		end
	elseif atkdfnd == 'Defenders' then
		if trueorfalse then
			turfData[turfID].beingCaptured = true
			turfData[turfID].timeLeft = turfData[turfID].timeLeft - 1
			TriggerClientEvent('ARMA:setBlockedStatus', -1, turfname, true)
		else
			turfData[turfID].beingCaptured = false
			turfData[turfID].timeLeft = 300
		end
	end
	
end)

RegisterNetEvent('ARMA:failCaptureTurfOwned')
AddEventHandler('ARMA:failCaptureTurfOwned', function(x)
    local source = source
	local user_id = ARMA.getUserId(source)
	
end)

RegisterNetEvent('ARMA:initiateGangCapture')
AddEventHandler('ARMA:initiateGangCapture', function(x,y)
    local source = source
	local user_id = ARMA.getUserId(source)
	if not turfData[x].beingCaptured then
		exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
			for K,V in pairs(gotGangs) do
				for I,L in pairs(json.decode(V.gangmembers)) do
					if tostring(user_id) == I then
						TriggerClientEvent('ARMA:initiateGangCaptureCheck', source, y, true)
						turfData[x].beingCaptured = true 
						if turfData[x].gangOwner ~= 'N/A' then
							exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
								for K,V in pairs(gotGangs) do
									if V.gangname == turfData[x].gangOwner then
										for I,L in pairs(json.decode(V.gangmembers)) do
											TriggerClientEvent('ARMA:defendGangCapture', ARMA.getUserSource(I))
										end
									end
								end
							end)
						end
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('ARMA:gangCaptureSuccess')
AddEventHandler('ARMA:gangCaptureSuccess', function(turfname)
    local source = source
	local user_id = ARMA.getUserId(source)
	if ARMA.hasGroup(user_id, 'Gang') then
		for k,v in pairs(turfData) do
			if v.name == turfname then
				exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
					for K,V in pairs(gotGangs) do
						for I,L in pairs(json.decode(V.gangmembers)) do
							if tostring(user_id) == I then
								for a,b in pairs(json.decode(V.gangmembers)) do
									turfData[k].gangOwner = V.gangname
									turfData[k].commission = V.commission
									local data = turfData
									data[k].ownership = true
									TriggerClientEvent('ARMA:updateTurfOwner', -1, k, V.gangname)
									TriggerClientEvent('ARMA:gotTurfOwnershipData', ARMA.getUserSource(tonumber(a)), data)
								end
							end
						end
					end
				end)
			end
		end
	end
end)

RegisterNetEvent('ARMA:gangDefenseSuccess')
AddEventHandler('ARMA:gangDefenseSuccess', function(turfname)
    local source = source
	local user_id = ARMA.getUserId(source)
	if ARMA.hasGroup(user_id, 'Gang') then
		exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
			for K,V in pairs(gotGangs) do
				for I,L in pairs(json.decode(V.gangmembers)) do
					if tostring(user_id) == I then
						for a,b in pairs(turfData) do
							if b.name == turfname then
								turfData[a] = {ownership = true, gangOwner = V.gangname, commission = b.commission}
								TriggerClientEvent('ARMA:gotTurfOwnershipData', -1, turfData)
								return
							end
						end
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('ARMA:setNewWeedPrice')
AddEventHandler('ARMA:setNewWeedPrice', function(price)
    local source = source
	local user_id = ARMA.getUserId(source)
	if ARMA.hasGroup(user_id, 'Gang') then
		exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
			for K,V in pairs(gotGangs) do
				for I,L in pairs(json.decode(V.gangmembers)) do
					if tostring(user_id) == I and V.gangname == turfData[1].gangOwner then
						turfData[1].commission = price
						ARMA.updateTraderInfo()
						TriggerClientEvent('ARMA:gotTurfOwnershipData', -1, turfData)
						return
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('ARMA:setNewCocainePrice')
AddEventHandler('ARMA:setNewCocainePrice', function(price)
    local source = source
	local user_id = ARMA.getUserId(source)
	if ARMA.hasGroup(user_id, 'Gang') then
		exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
			for K,V in pairs(gotGangs) do
				for I,L in pairs(json.decode(V.gangmembers)) do
					if tostring(user_id) == I and V.gangname == turfData[2].gangOwner then
						turfData[2].commission = price
						ARMA.updateTraderInfo()
						TriggerClientEvent('ARMA:gotTurfOwnershipData', -1, turfData)
						return
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('ARMA:setNewMethPrice')
AddEventHandler('ARMA:setNewMethPrice', function(price)
    local source = source
	local user_id = ARMA.getUserId(source)
	if ARMA.hasGroup(user_id, 'Gang') then
		exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
			for K,V in pairs(gotGangs) do
				for I,L in pairs(json.decode(V.gangmembers)) do
					if tostring(user_id) == I and V.gangname == turfData[3].gangOwner then
						turfData[3].commission = price
						ARMA.updateTraderInfo()
						TriggerClientEvent('ARMA:gotTurfOwnershipData', -1, turfData)
						return
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('ARMA:setNewHeroinPrice')
AddEventHandler('ARMA:setNewHeroinPrice', function(price)
    local source = source
	local user_id = ARMA.getUserId(source)
	if ARMA.hasGroup(user_id, 'Gang') then
		exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
			for K,V in pairs(gotGangs) do
				for I,L in pairs(json.decode(V.gangmembers)) do
					if tostring(user_id) == I and V.gangname == turfData[4].gangOwner then
						turfData[4].commission = price
						ARMA.updateTraderInfo()
						TriggerClientEvent('ARMA:gotTurfOwnershipData', -1, turfData)
						return
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('ARMA:setNewLargeArmsCommission')
AddEventHandler('ARMA:setNewLargeArmsCommission', function(price)
    local source = source
	local user_id = ARMA.getUserId(source)
	if ARMA.hasGroup(user_id, 'Gang') then
		exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
			for K,V in pairs(gotGangs) do
				for I,L in pairs(json.decode(V.gangmembers)) do
					if tostring(user_id) == I and V.gangname == turfData[5].gangOwner then
						turfData[5].commission = price
						ARMA.updateTraderInfo()
						TriggerClientEvent('ARMA:gotTurfOwnershipData', -1, turfData)
						TriggerClientEvent('ARMA:recalculateLargeArms', -1, price)
						return
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('ARMA:setNewLSDNorthPrice')
AddEventHandler('ARMA:setNewLSDNorthPrice', function(price)
    local source = source
	local user_id = ARMA.getUserId(source)
	if ARMA.hasGroup(user_id, 'Gang') then
		exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
			for K,V in pairs(gotGangs) do
				for I,L in pairs(json.decode(V.gangmembers)) do
					if tostring(user_id) == I and V.gangname == turfData[6].gangOwner then
						turfData[6].commission = price
						ARMA.updateTraderInfo()
						TriggerClientEvent('ARMA:gotTurfOwnershipData', -1, turfData)
						return
					end
				end
			end
		end)
	end
end)

RegisterNetEvent('ARMA:setNewLSDSouthPrice')
AddEventHandler('ARMA:setNewLSDSouthPrice', function(price)
    local source = source
	local user_id = ARMA.getUserId(source)
	if ARMA.hasGroup(user_id, 'Gang') then
		exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
			for K,V in pairs(gotGangs) do
				for I,L in pairs(json.decode(V.gangmembers)) do
					if tostring(user_id) == I and V.gangname == turfData[7].gangOwner then
						turfData[6].commission = price
						ARMA.updateTraderInfo()
						TriggerClientEvent('ARMA:gotTurfOwnershipData', -1, turfData)
						return
					end
				end
			end
		end)
	end
end)

function ARMA.turfSaleToGangFunds(amount, drugtype)
	for k,v in pairs(turfData) do
		if v.name == drugtype then
			exports['ghmattimysql']:execute('SELECT * FROM arma_gangs', function(gotGangs)
				for a,b in pairs(gotGangs) do
					if v.gangOwner == b.gangname then
						if drugtype ~= 'LargeArms' then
							amount = amount*(v.commission/100)/(1-v.commission/100)
						else
							amount = amount/(1+v.commission)
						end
						exports['ghmattimysql']:execute('UPDATE arma_gangs SET funds = funds+@funds WHERE gangname = @gangname', {funds = amount, gangname = b.gangname})
					end
				end
			end)
		end
	end
end

RegisterCommand('largearms', function(source, args)
	local source = source
	local user_id = ARMA.getUserId(source)
	if user_id == 1 then
		turfData[5].commission = tonumber(args[1])
		ARMA.updateTraderInfo()
		TriggerClientEvent('ARMA:gotTurfOwnershipData', -1, turfData)
		TriggerClientEvent('ARMA:recalculateLargeArms', -1, tonumber(args[1]))
	end
end)