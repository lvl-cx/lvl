------------------------------------------------------------------
--                          Variables
------------------------------------------------------------------

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

function getMinimapAnchor()
    SetScriptGfxAlign(string.byte('L'), string.byte('B'))
    local minimapTopX, minimapTopY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
    ResetScriptGfxAlign()
    local w, h = GetActiveScreenResolution()
    local aspect_ratio = GetAspectRatio(0)
    local xscale = 1.0 / w
    local yscale = 1.0 / h
    local Minimap = {}
    local width = xscale * (w / (4 * aspect_ratio))
    return { w * 2 * minimapTopX, (h * minimapTopY)+((width*0.61)*h), width * w}
end

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

    local topLeftAnchor = getMinimapAnchor()
    updateHungerThirstHUD("£" .. moneyDisplay, "£" .. bankMoneyDisplay,voiceChatProximity,topLeftAnchor[1]+topLeftAnchor[3],topLeftAnchor[2])
end)

Citizen.CreateThread(function()
    while true do
        NetworkSetTalkerProximity(prox)
        NetworkSetVoiceActive(true)
        HideHudComponentThisFrame(9)
        HideHudComponentThisFrame(7)
        if NetworkIsPlayerTalking(PlayerId()) then
            SendNUIMessage({
                talking = true
            })
        end
		Wait(60)
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



local function drawRct(x,y,Width,height,r,g,b,a)
    DrawRect(x+Width/2,y+height/2,Width,height,r,g,b,a,0)
end

local function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.Width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.Left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.Bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.Left_x + Minimap.Width
    Minimap.top_y = Minimap.Bottom_y - Minimap.height
    Minimap.x = Minimap.Left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end
