local a={}
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
    a.customisation=tARMA.getCustomization()
    if b then 
        SetResourceKvp("ARMA_userdata",json.encode(a))
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
local function e()
    if a.customisation==nil then 
        tARMA.setCustomization(getDefaultCustomization(),true,true)
    else 
        tARMA.setCustomization(a.customisation,true,true)
    end 
end
