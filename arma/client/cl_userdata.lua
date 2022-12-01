local a={}
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

Citizen.CreateThread(function()
    print("[ARMA] Loading cached user data.")
    a=json.decode(GetResourceKvpString("ARMA_userdata")or"{}")
    if type(a)~="table"then 
        a={}
        print("[ARMA] Loading cached user data - failed to load setting to default.")
    else 
        print("[ARMA] Loading cached user data - loaded.")
    end 
end)
function tARMA.updateCustomization(b)
    local c = tARMA.getCustomization()
    if c.modelhash ~= 0 and IsModelValid(c.modelhash) then
        a.customisation=c
        if b then 
            SetResourceKvp("ARMA_userdata",json.encode(a))
        end 
    end
end
function tARMA.updatePos(b)
    a.position=GetEntityCoords(PlayerPedId())
    if b then 
        SetResourceKvp("ARMA_userdata",json.encode(a))
    end 
end
function tARMA.updateHealth(b)
    a.health=GetEntityHealth(PlayerPedId())
    if b then 
        SetResourceKvp("ARMA_userdata",json.encode(a))
    end 
end
function tARMA.updateArmour(b)
    a.armour=GetPedArmour(PlayerPedId())
    if b then 
        SetResourceKvp("ARMA_userdata",json.encode(a))
    end 
end
local c
local d
function tARMA.checkCustomization()
    if a.customisation==nil then 
        tARMA.setCustomization(getDefaultCustomization(),true,true)
    else 
        tARMA.setCustomization(a.customisation,true,true)
    end 
end
