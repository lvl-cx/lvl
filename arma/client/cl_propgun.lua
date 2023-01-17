local propGun = false
local modelText = ""

local hashes_file = LoadResourceFile(GetCurrentResourceName(), "hashes.json")
local hashes = json.decode(hashes_file)

RegisterCommand('propgun', function()
    if tARMA.getUserId() == 6 then
        propGun = not propGun
        tARMA.notify('Prop Gun: '..(propGun and "~g~Enabled" or "~r~Disabled"))
    end
end)

Citizen.CreateThread(function()                            
    while true do                                           
        local pause = 250                                  
        if propGun then                                     
            pause = 5                                       
            local player = PlayerPedId()                   
            if IsPlayerFreeAiming(PlayerId()) then         
                local entity = getEntity(PlayerId())     
                local model = GetEntityModel(entity)        

                if hashes[tostring(model)] then                 
                    modelText = hashes[tostring(model)]        
                else                
                    modelText = model                           
                end
            end                                             
            DrawInfos("Hash: " .. modelText)
        end                                                
        Citizen.Wait(pause)                                
    end                                                     
end)                                                       

function getEntity(player)                                          
    local result, entity = GetEntityPlayerIsFreeAimingAt(player)   
return entity                                                    

function DrawInfos(...)
    local args = {...}
    ypos = 0.70
    for k,v in pairs(args) do
        SetTextColour(255, 255, 255, 255)   
        SetTextFont(0)                      
        SetTextScale(0.4, 0.4)             
        SetTextWrap(0.0, 1.0)              
        SetTextCentre(false)               
        SetTextDropshadow(0, 0, 0, 0, 255)  
        SetTextEdge(50, 0, 0, 0, 255)      
        SetTextOutline()                   
        SetTextEntry("STRING")
        AddTextComponentString(v)
        DrawText(0.015, ypos)              
        ypos = ypos + 0.028
    end
end