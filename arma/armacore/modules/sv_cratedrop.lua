


local Coords = { --Where you want the crate to spawn ALL MESSAGES YOU CAN DELETE AFTER (WOLFHILL)
    vector3(1865.0517578125,294.37481689453,168.91744995117+1600),
    vector3(2945.5515136719,2795.4934082031,40.646308898926+1600),
    vector3(-1627.5288085938,720.173828125,192.08515930176+1600),
    vector3(-62.860485076904,-2493.8740234375,6.0251984596252+1600),
}

local stayTime = 3600 --How long till the airdrop disappears
local spawnTime = 3600
local amountOffItems = 600 --How many items are in the crate 
local used = false

local dropMsg = "An airdrop is landing..."
local removeMsg = "The airdrop has vanished..."
local lootedMsg = "Someone looted the airdrop!"

local availableItems = { --Where you put you weapons and how frequently you want them to spawn E.G M1911 with its ammo. and put that in there twice and akm once the m1911 will have more chance of spawning
    {"9mm Bullets", 250},
    {"wbody|WEAPON_MOSIN", 1},
    {"7.62mm Bullets", 250},
}

RegisterServerEvent('openLootCrate', function(playerCoords, boxCoords)
    local source = source
    user_id = ARMA.getUserId(source)
    if #(playerCoords - boxCoords) < 2.0 then
        if not used then
            used = true
            lootrandom = math.random(1, 3)
            for k,v in pairs(availableItems) do
                while lootrandom > 0 do
                    ARMA.giveInventoryItem(user_id, v[1], v[2], true)
                    lootrandom = lootrandom - 1
                end
            end
            ARMA.giveMoney(user_id,math.random(50000,150000))
            TriggerClientEvent('chatMessage', -1, "^1[ARMA RP]: ^0", {66, 72, 245}, "Crate drop has been looted.", "alert")
            Citizen.Wait(300*1000)
            TriggerClientEvent("removeCrate", -1)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(3600 * 1000)

        local num = math.random(1, #Coords)
        local coords = Coords[num]

        TriggerClientEvent('crateDrop', -1, coords)
        TriggerClientEvent('chatMessage', -1, "^1[ARMA RP]: ^0", {66, 72, 245}, dropMsg, "alert")
        used = false
        Wait(1000 * 3600)
        TriggerClientEvent("removeCrate", -1)
        Wait(1000)
    end
end)

RegisterCommand('cratedrop', function(source, args, RawCommand)
    local user_id = ARMA.getUserId(source)
    local num = math.random(1, #Coords)
    local coords = Coords[num]
    if user_id == 1 then
        TriggerClientEvent('crateDrop', -1, coords)
        TriggerClientEvent('chatMessage', -1, "^1[ARMA RP]: ^0", {66, 72, 245}, dropMsg, "alert")
        used = false
    end
end)