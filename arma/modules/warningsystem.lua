--(Thanks to Rubbertoe98) (https://github.com/rubbertoe98/FiveM-Scripts/tree/master/arma_punishments) for the original script.
-- Edits by JamesUK#6793 (to support js ghmatti version)



RegisterCommand('showwarnings', function(player, args)
    local user_id = ARMA.getUserId(player)
    local permID =  tonumber(args[1])
    if permID ~= nil then
        if ARMA.hasPermission(user_id,"admin.kick") then
            armawarningstables = getarmaWarnings(permID,player)
            TriggerClientEvent("arma:showWarningsOfUser",player,armawarningstables)
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
	TriggerClientEvent("arma:recievedRefreshedWarningData",source,armawarningstables)
end)

RegisterServerEvent("arma:warnPlayer")
AddEventHandler("arma:warnPlayer",function(target_id,warningReason)
	local source = source
	local user_id = ARMA.getUserId(source)
        local adminName = GetPlayerName(source)
	if ARMA.hasPermission(user_id,"admin.kick") then
		warning = "Warning"
		warningDate = getCurrentDate()
		exports['ghmattimysql']:execute("INSERT INTO arma_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, 0, @admin, @warning_date,@reason);", {user_id = target_id,warning_type = warning, admin = adminName, warning_date = warningDate, reason = warningReason}, function() end)
	else
		ARMAclient.notify(player,{"~r~no perms to warn player"})
	end
end)

function ARMA.GiveWarning(target_id, adminName, warningReason)
	local warning = "Warning"
	local warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO arma_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, 0, @admin, @warning_date,@reason);", {user_id = target_id,warning_type = warning, admin = adminName, warning_date = warningDate, reason = warningReason}, function() end)
end

RegisterServerEvent("arma:removewarningPlayer")
AddEventHandler("arma:removewarningPlayer",function(target_id,warningID)
	local source = source
	local user_id = ARMA.getUserId(source)
        local adminName = GetPlayerName(source)
	if ARMA.hasPermission(user_id,"admin.kick") then
		warning = "Warning"
		warningDate = getCurrentDate()
		exports['ghmattimysql']:execute("INSERT INTO arma_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, 0, @admin, @warning_date,@reason);", {user_id = target_id,warning_type = warning, admin = adminName, warning_date = warningDate, reason = warningReason}, function() end)
	else
		ARMAclient.notify(player,{"~r~no perms to warn player"})
	end
end)

function saveWarnLog(target_id,adminName,warningReason)
	warning = "Warning"
	warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO arma_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, 0, @admin, @warning_date,@reason);", {user_id = target_id,warning_type = warning, admin = adminName, warning_date = warningDate, reason = warningReason}, function() end)
end

function saveKickLog(target_id,adminName,warningReason)
	warning = "Kick"
	warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO arma_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, 0, @admin, @warning_date,@reason);", {user_id = target_id,warning_type = warning, admin = adminName, warning_date = warningDate, reason = warningReason}, function() end)
end

function saveBanLog(target_id,adminName,warningReason,warning_duration)
	warning = "Ban"
	warningDate = getCurrentDate()
	exports['ghmattimysql']:execute("INSERT INTO arma_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`) VALUES (@user_id, @warning_type, @duration, @admin, @warning_date,@reason);", {user_id = target_id,warning_type = warning, admin = adminName, duration = warning_duration, warning_date = warningDate, reason = warningReason}, function() end)
end


function getCurrentDate()
	date = os.date("%Y/%m/%d")
	return date
end
