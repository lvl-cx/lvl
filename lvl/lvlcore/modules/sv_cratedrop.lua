


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

local avaliableItems = { --Where you put you weapons and how frequently you want them to spawn E.G M1911 with its ammo. and put that in there twice and akm once the m1911 will have more chance of spawning
    {"wammo|WEAPON_m1911", "9 mm Bullets", 250, 0.01},
    {"wbody|WEAPON_m1911", "Weapon_m1911 body", 1, 2.5},
    {"wammo|WEAPON_ak74", "7.62 mm Bullets", 250, 0.01},
}

local currentLoot = {}

RegisterServerEvent('openLootCrate', function(playerCoords, boxCoords)
    local source = source
    user_id = LVL.getUserId(source)
    if #(playerCoords - boxCoords) < 2.0 then
        if not used then
                used = true
                lootrandom = math.random(1, 3)

                if lootrandom == 1 then -- [Legendary]
                    -- [Legendary]
                    LVL.giveInventoryItem(user_id, "wbody|" .. 'WEAPON_MOSIN', 1, true)
                    LVL.giveInventoryItem({user_id, '7.62 Bullets', 250, true})

                    LVL.giveInventoryItem(user_id, "wbody|" .. 'WEAPON_HK45', 1, true)
                    LVL.giveInventoryItem(user_id, '9mm Bullets', 250, true)
                    LVL.giveInventoryItem(user_id, "body_armor", 3, true)
                    LVLclient.notify(source,{'Received ~g~£200,000 ~w~Cash.'})
                    LVL.giveMoney(user_id,200000)

                    TriggerClientEvent('chat:addMessage', -1, {
                        template = ' Supply Drops^7: ' .. 'The Drop has been Looted. [Rarity: ^3Legendary]' .. '</div>',
                        args = { playerName, msg }
                    })
                elseif lootrandom == 2 then 
                    -- [Epic]
                    TriggerClientEvent('chat:addMessage', -1, {
                        template = ' Supply Drops^7: ' .. 'The Drop has been Looted. [Rarity: ^6Epic]' .. '</div>',
                        args = { playerName, msg }
                    })

                elseif lootrandom == 3 then 
                    -- [Uncommon]
                    TriggerClientEvent('chat:addMessage', -1, {
                        template = ' Supply Drops^7: ' .. 'The Drop has been Looted. [Rarity: ^5Uncommon]' .. '</div>',
                        args = { playerName, msg }
                    })
                elseif lootrandom == 4 then 
                    -- [Common]
                    TriggerClientEvent('chat:addMessage', -1, {
                        template = ' Supply Drops^7: ' .. 'The Drop has been Looted. [Rarity: ^9Common]' .. '</div>',
                        args = { playerName, msg }
                    })
                end
                
          Citizen.Wait(300*1000)
          TriggerClientEvent("removeCrate", -1)
        end
    end
end)

RegisterServerEvent('updateLoot', function(source, item, amount)
    local i = currentLoot[item]
    local j = i[2] - amount
    if (j > 0) then
        currentLoot[item] = {i[1], j, i[3]}
    else
        currentLoot[item] = nil
    end

    if #currentLoot == 0 then
        if not used then
            used = true
            TriggerClientEvent('chatMessage', -1, "^1[LVL]: ^0 ", {66, 72, 245}, lootedMsg, "alert")
        end
    end

            TriggerClientEvent('LVL:SendSecondaryInventoryData', source, currentLoot, LVL.computeItemsWeight({currentLoot}), 30)
end) 

Citizen.CreateThread(function()
    while (true) do
        Wait(1000 * 3600)

            local num = math.random(1, #Coords)
            local coords = Coords[num]

            for i = 1, amountOffItems do
                local secondNum = math.random(1, #avaliableItems)
                local k = avaliableItems[secondNum]
                currentLoot[k[1]] = {k[2], k[3], k[4]}
            end 

            TriggerClientEvent('crateDrop', -1, coords)
            --TriggerClientEvent('chatMessage', -1, "^1[Infinite RP]: ^0", {66, 72, 245}, dropMsg, "alert")
            TriggerClientEvent('chat:addMessage', -1, {
                template = 'Supply Drops^7: ' .. dropMsg .. '</div>',
                args = { playerName, msg }
              })
            used = false
        end
        -- Citizen.SetTimeout(stayTime * 1000, function()
        --     TriggerClientEvent("removeCrate", -1)
        --     TriggerClientEvent('chatMessage', -1, "^1[Infinite RP]: ^0 ", {66, 72, 245}, removeMsg, "alert")
        -- end)

        -- Wait(stayTime * 1000 + 500)
        Wait(1000 * 3600)
        TriggerClientEvent("removeCrate", -1)
        Wait(1000)
  
end)


