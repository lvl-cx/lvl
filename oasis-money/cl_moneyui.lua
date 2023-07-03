local showHud = true                          -- Boolean to show / hide HUD
local moneyDisplay = 0
local bankMoneyDisplay = 0
local voiceChatProximity = 2
proximityIdToString = {
    [1] = "Whisper",
    [2] = "Talking",
    [3] = "Shouting",
}

local OASIS = {}

local function GetMinimapAnchor()
	local minimap = {}
	local resX, resY = GetActiveScreenResolution()
	local aspectRatio = GetAspectRatio()
	local scaleX = 1/resX
	local scaleY = 1/resY
	local minimapRawX, minimapRawY
	SetScriptGfxAlign(string.byte('L'), string.byte('B'))
	if IsBigmapActive() then
		minimapRawX, minimapRawY = GetScriptGfxPosition(-0.003975, 0.022 + (-0.460416666))
		minimap.width = scaleX*(resX/(2.52*aspectRatio))
		minimap.height = scaleY*(resY/(2.3374))
	else
		minimapRawX, minimapRawY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
		minimap.width = scaleX*(resX/(4*aspectRatio))
		minimap.height = scaleY*(resY/(5.674))
	end
	ResetScriptGfxAlign()
    minimap.resX = resX
    minimap.resY = resY
	minimap.leftX = minimapRawX
	minimap.rightX = minimapRawX+minimap.width
	minimap.topY = minimapRawY
	minimap.bottomY = minimapRawY+minimap.height
	minimap.X = minimapRawX+(minimap.width/2)
	minimap.Y = minimapRawY+(minimap.height/2)
    minimap.Width = minimap.rightX -  minimap.leftX
	return minimap
end

local cachedXRes, cachedYRes = GetActiveScreenResolution()
local cachedMinimapAnchor = GetMinimapAnchor()

function OASIS.getCachedMinimapAnchor()
    return cachedMinimapAnchor
end

local function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction
end

RegisterNetEvent("OASIS:showHUD")
AddEventHandler("OASIS:showHUD",function(flag)
    showhudUI(flag)
end)

AddEventHandler('pma-voice:setTalkingMode', function(newTalkingRange)
    voiceChatProximity = newTalkingRange
    local topLeftAnchor = OASIS.getCachedMinimapAnchor()
    updateMoneyUI("£" .. moneyDisplay, "£" .. bankMoneyDisplay,voiceChatProximity,topLeftAnchor.rightX * topLeftAnchor.resX)
end)

function updateMoneyUI(cash, bank, proximity, topLeftAnchor,yAnchor)
    SendNUIMessage({
        update = true,
        cash = cash,
        bank = bank,
        proximity = proximityIdToString[proximity],
        topLeftAnchor = topLeftAnchor,
        yAnchor = yAnchor,
    })
end

function showhudUI(flag)
    SendNUIMessage({
        showhud = flag
    })
end

RegisterNetEvent("OASIS:setDisplayMoney")
AddEventHandler("OASIS:setDisplayMoney",function(value)
	local moneyString = tostring(math.floor(value))
    moneyDisplay = getMoneyStringFormatted(moneyString)
    local topLeftAnchor = OASIS.getCachedMinimapAnchor()
    updateMoneyUI("£" .. moneyDisplay, "£" .. bankMoneyDisplay,voiceChatProximity,topLeftAnchor.rightX * topLeftAnchor.resX)
end)

RegisterNetEvent("OASIS:setDisplayBankMoney")
AddEventHandler("OASIS:setDisplayBankMoney",function(value)
	local moneyString = tostring(math.floor(value))
    bankMoneyDisplay = getMoneyStringFormatted(moneyString)
    local topLeftAnchor = OASIS.getCachedMinimapAnchor()
    updateMoneyUI("£" .. moneyDisplay, "£" .. bankMoneyDisplay,voiceChatProximity,topLeftAnchor.rightX * topLeftAnchor.resX)
end)

RegisterNetEvent("OASIS:initMoney")
AddEventHandler("OASIS:initMoney",function(cash,bank)
	local cashString = tostring(math.floor(cash))
    moneyDisplay = getMoneyStringFormatted(cashString)
    local moneyString = tostring(math.floor(bank))
    bankMoneyDisplay = getMoneyStringFormatted(moneyString)
    local topLeftAnchor = OASIS.getCachedMinimapAnchor()
    updateMoneyUI("£" .. moneyDisplay, "£" .. bankMoneyDisplay,voiceChatProximity,topLeftAnchor.rightX * topLeftAnchor.resX)
end)

Citizen.CreateThread(function()
    TriggerServerEvent("OASIS:requestPlayerBankBalance")

    local talking = false
    while true do
        local res_x, res_y = GetActiveScreenResolution()
        if res_x ~= cachedXRes or res_y ~= cachedYRes then
            cachedXRes, cachedYRes = GetActiveScreenResolution()
            cachedMinimapAnchor = GetMinimapAnchor()
            updateMoneyUI("£" .. moneyDisplay, "£" .. bankMoneyDisplay,voiceChatProximity,cachedMinimapAnchor.rightX * cachedMinimapAnchor.resX)
        end

        if NetworkIsPlayerTalking(PlayerId()) then
            if not talking then
                talking = true
                SendNUIMessage({
                    talking = true
                })
            end
        else
            if talking then
                talking = false
                SendNUIMessage({
                    talking = false
                })
            end
        end
		Wait(0)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		HideHudComponentThisFrame(3) -- CASH
		HideHudComponentThisFrame(4) -- MP CASH
		HideHudComponentThisFrame(9) -- STREET NAME
		HideHudComponentThisFrame(7) -- Area NAME
		HideHudComponentThisFrame(8) -- Vehicle Class
		HideHudComponentThisFrame(6) -- Vehicle Name
	end
end)