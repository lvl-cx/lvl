RegisterCommand('sw', function(player, args)
    local user_id = ARMA.getUserId(player)
    local permID =  tonumber(args[1])
    if permID ~= nil then
        if ARMA.hasPermission(user_id,"admin.tickets") then
			armawarningstables = getarmaWarnings(permID,player)
			a = exports['ghmattimysql']:executeSync("SELECT * FROM arma_bans_offenses WHERE UserID = @uid", {uid = permID})
			for k,v in pairs(a) do
				if v.UserID == permID then
					TriggerClientEvent("arma:showWarningsOfUser",player,armawarningstables,v.points)
				end
			end
        end
    end
end)
	
function getarmaWarnings(user_id,source) 
	armawarningstables = exports['ghmattimysql']:executeSync("SELECT * FROM arma_warnings WHERE user_id = @uid", {uid = user_id})
	for warningID,warningTable in pairs(armawarningstables) do
		date = warningTable["warning_date"]
		newdate = tonumber(date) / 1000
		newdate = os.date('%Y-%m-%d', newdate)
		warningTable["warning_date"] = newdate
	end
	return armawarningstables
end

RegisterServerEvent("arma:refreshWarningSystem")
AddEventHandler("arma:refreshWarningSystem",function()
	local source = source
	local user_id = ARMA.getUserId(source)	
	armawarningstables = getarmaWarnings(user_id,source)
	a = exports['ghmattimysql']:executeSync("SELECT * FROM arma_bans_offenses WHERE UserID = @uid", {uid = user_id})
	for k,v in pairs(a) do
		if v.UserID == user_id then
			TriggerClientEvent("arma:recievedRefreshedWarningData",source,armawarningstables,v.points)
		end
	end
end)

function f10Kick(target_id,adminName,warningReason)
	warning = "Kick"
	--exports['ghmattimysql']:execute("INSERT INTO arma_warnings (`user_id`, `warning_type`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, @admin, @warning_date,@reason);", {user_id = target_id, warning_type = "Kick", admin = adminName, warning_date = os.date("%Y/%m/%d"), reason = warningReason}, function() end)
end

function f10Ban(target_id,adminName,warningReason,warning_duration)
	if warning_duration == -1 then
		warning_duration = 0
	end
	warning = "Ban"
	exports['ghmattimysql']:execute("INSERT INTO arma_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, @duration, @admin, @warning_date,@reason);", {user_id = target_id, warning_type = "Ban", admin = adminName, duration = warning_duration, warning_date = os.date("%Y/%m/%d"), reason = warningReason}, function() end)
end
