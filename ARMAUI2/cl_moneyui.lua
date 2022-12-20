local showHud = true                          -- Boolean to show / hide HUD
local moneyDisplay = 0
local bankMoneyDisplay = 0
local voiceChatProximity = 2
proximityIdToString = {
    [1] = "Whispering",
    [2] = "Talking",
    [3] = "Shouting",
}
prox = 35.01

local ARMA = {}

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

function ARMA.getCachedMinimapAnchor()
    return cachedMinimapAnchor
end

function setProximity(vprox)
    if vprox == 1 then
        prox = 5.01
    elseif vprox == 2 then
        prox = 15.01
    elseif vprox == 3 then
        prox = 35.01
    end
end

TriggerServerEvent('ARMA:requestPlayerBankBalance')

function getMoneyStringFormatted(cashString)
	local i, j, minus, int, fraction = tostring(cashString):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1,")
	return minus .. int:reverse():gsub("^,", "") .. fraction 
end

function updateHungerThirstHUD(cash, bank, proximity, topLeftAnchor,yAnchor)
  SendNUIMessage({
    update = true,
    cash = cash,
    bank = bank,
    proximity = proximityIdToString[proximity],
    topLeftAnchor = topLeftAnchor,
    yAnchor = yAnchor,
  })
end

RegisterNetEvent("ARMAHUD:show")
AddEventHandler("ARMAHUD:show", function()
    SendNUIMessage({
        showhud = true
    })
    DisplayRadar(true)
    TriggerEvent('ARMA:showHUD', true)
end)

RegisterNetEvent("ARMAHUD:hide")
AddEventHandler("ARMAHUD:hide", function()
    SendNUIMessage({
        showhud = false
    })
    DisplayRadar(false)
    TriggerEvent('ARMA:showHUD', false)
end)

RegisterNetEvent("ARMA:setDisplayMoney")
AddEventHandler("ARMA:setDisplayMoney",function(value)
	local moneyString = tostring(math.floor(value))
	moneyDisplay = getMoneyStringFormatted(moneyString)
end)

RegisterNetEvent("ARMA:setDisplayBankMoney")
AddEventHandler("ARMA:setDisplayBankMoney",function(value)
	local moneyString = tostring(math.floor(value))
	bankMoneyDisplay = getMoneyStringFormatted(moneyString)
end)

RegisterNetEvent("ARMA:initMoney")
AddEventHandler("ARMA:initMoney",function(cash,bank)
	local cashString = tostring(math.floor(cash))
    moneyDisplay = getMoneyStringFormatted(cashString)

    local moneyString = tostring(math.floor(bank))
    bankMoneyDisplay = getMoneyStringFormatted(moneyString)

    local topLeftAnchor = ARMA.getCachedMinimapAnchor()
    updateHungerThirstHUD("£" .. moneyDisplay, "£" .. bankMoneyDisplay,voiceChatProximity,topLeftAnchor.rightX * topLeftAnchor.resX)
end)

Citizen.CreateThread(function()
    while true do
        local res_x, res_y = GetActiveScreenResolution()
        if res_x ~= cachedXRes or res_y ~= cachedYRes then
            cachedXRes, cachedYRes = GetActiveScreenResolution()
            cachedMinimapAnchor = GetMinimapAnchor()
            updateHungerThirstHUD("£" .. moneyDisplay, "£" .. bankMoneyDisplay,voiceChatProximity,cachedMinimapAnchor.rightX * cachedMinimapAnchor.resX)
        end
        NetworkSetTalkerProximity(prox)
        NetworkSetVoiceActive(true)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(7)
        if NetworkIsPlayerTalking(PlayerId()) then
            SendNUIMessage({
                talking = true
            })
        else
            SendNUIMessage({
                talking = false
            })
        end
		Wait(0)
    end
end)

Citizen.CreateThread(function()
	voiceChatProximity = 2
	while true do
		if IsControlPressed(0, 10) then
			if voiceChatProximity ~= 3 then
				voiceChatProximity = voiceChatProximity + 1
				setProximity(voiceChatProximity)
				Wait(250)
			end
		end
		if IsControlPressed(0, 11) then
			if voiceChatProximity ~= 1 then
				voiceChatProximity = voiceChatProximity - 1
				setProximity(voiceChatProximity)
				Wait(250)
			end
		end
		Wait(0)
	end	
end)