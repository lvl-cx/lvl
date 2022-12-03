local a = {}
Citizen.CreateThread(function()
    print("[ARMA] Loading cached user data.")
    a = json.decode(GetResourceKvpString("ARMA_userdata") or "{}")
    if type(a) ~= "table" then
        a = {}
        print("[ARMA] Loading cached user data - failed to load setting to default.")
    else
        print("[ARMA] Loading cached user data - loaded.")
    end
end)
function tARMA.updateCustomization(b)
    local c = tARMA.getCustomization()
    if c.modelhash ~= 0 and IsModelValid(c.modelhash) then
        a.customisation = c
        if b then
            SetResourceKvp("ARMA_userdata", json.encode(a))
        end
    end
end
local d = vector3(0.0, 0.0, 0.0)
function tARMA.updatePos(b)
    local e = GetEntityCoords(PlayerPedId())
    if e.z > -150.0 and #(e - d) > 15.0 then
        a.position = e
        if b then
            SetResourceKvp("ARMA_userdata", json.encode(a))
        end
    end
end
function tARMA.updateHealth(b)
    a.health = GetEntityHealth(PlayerPedId())
    if b then
        SetResourceKvp("ARMA_userdata", json.encode(a))
    end
end
Citizen.CreateThread(function()
    Wait(30000)
    while true do
        Wait(5000)
        --if not tARMA.isInHouse() and not inOrganHeist and not tARMA.isPlayerInRedZone() and not tARMA.isInPaintball() and not tARMA.isInSpectate() then
        if not tARMA.isInHouse() and not inOrganHeist and not tARMA.isPlayerInRedZone() and not tARMA.isInSpectate() then
            tARMA.updatePos()
        end
        --if not globalInPrison and not tARMA.isStaffedOn() and not tARMA.isPlayerInAnimalForm() and not tARMA.isInPaintball()
        if not tARMA.isStaffedOn() and not customizationSaveDisabled and not spawning then
            tARMA.updateCustomization()
        end
        tARMA.updateHealth()
        SetResourceKvp("ARMA_userdata", json.encode(a))
    end
end)
local f
local g
local function h()
    local c = a.customisation
    if c == nil or c.modelhash == 0 or not IsModelValid(c.modelhash) then
        tARMA.setCustomization(getDefaultCustomization(), true, true)
    else
        tARMA.setCustomization(c, true, true)
    end
end

function tARMA.checkCustomization()
    h()
end

function getDefaultCustomization()
    local s = {}
    s = {}
    s.model = "mp_m_freemode_01"
    for t = 0, 19 do
        s[t] = {0, 0}
    end
    s[0] = {0, 0}
    s[1] = {0, 0}
    s[2] = {47, 0}
    s[3] = {5, 0}
    s[4] = {4, 0}
    s[5] = {0, 0}
    s[6] = {7, 0}
    s[7] = {51, 0}
    s[8] = {0, 240}
    s[9] = {0, 1}
    s[10] = {0, 0}
    s[11] = {5, 0}
    s[12] = {4, 0}
    s[15] = {0, 2}
    return s
end
AddEventHandler("ARMA:playGTAIntro",function()
    if not tARMA.isDevMode() then
        SendNUIMessage({transactionType = "gtaloadin"})
    end
end)
