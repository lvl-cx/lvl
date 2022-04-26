-- a basic ATM implementation
local lang = ATM.lang
local cfg = module("cfg/atms")
local atms = cfg.atms
local onesync = GetConvar('onesync', nil)
local function play_atm_enter(player)
    ATMclient.playAnim(player, {false,
                                {{"amb@prop_human_atm@male@enter", "enter"},
                                 {"amb@prop_human_atm@male@idle_a", "idle_a"}}, false})
end

local function play_atm_exit(player)
    ATMclient.playAnim(player, {false, {{"amb@prop_human_atm@male@exit", "exit"}}, false})
end

local function atm_choice_deposit(player, choice)
    play_atm_enter(player) -- anim

    ATM.prompt(source, lang.atm.deposit.prompt(), "", function(player, v)
        play_atm_exit(player)

        v = parseInt(v)

        if v > 0 then
            local user_id = ATM.getUserId(source)
            if user_id ~= nil then
                if ATM.tryDeposit(user_id, v) then
                    ATMclient.notify(source, {lang.atm.deposit.deposited({v})})
                else
                    ATMclient.notify(source, {lang.money.not_enough()})
                end
            end
        else
            ATMclient.notify(source, {lang.common.invalid_value()})
        end
    end)
end


RegisterNetEvent('ATM:Withdraw')
AddEventHandler('ATM:Withdraw', function(amount)
    local source = source
    amount = parseInt(amount)
   
        --Onesync allows extra security behind events should enable it if it's not already.
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        for i, v in pairs(cfg.atms) do
            local coords = vec3(v[1], v[2], v[3])
            if #(playerCoords - coords) <= 5.0 then
                if amount > 0 then
                    local user_id = ATM.getUserId(source)
                    if user_id ~= nil then
                        if ATM.tryWithdraw(user_id, amount) then
                            ATMclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
                        else
                            ATMclient.notify(source, {lang.atm.withdraw.not_enough()})
                        end
                    end
                else
                    ATMclient.notify(source, {lang.common.invalid_value()})
                end
            end
        end

end)


RegisterNetEvent('ATM:Deposit')
AddEventHandler('ATM:Deposit', function(amount)
    local source = source
    amount = parseInt(amount)

        --Onesync allows extra security behind events should enable it if it's not already.
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        for i, v in pairs(cfg.atms) do
            local coords = vec3(v[1], v[2], v[3])
            if #(playerCoords - coords) <= 5.0 then
                if amount > 0 then
                    local user_id = ATM.getUserId(source)
                    if user_id ~= nil then
                        if ATM.tryDeposit(user_id, amount) then
                            ATMclient.notify(source, {lang.atm.deposit.deposited({amount})})
                        else
                            ATMclient.notify(source, {lang.money.not_enough()})
                        end
                    end
                else
                    ATMclient.notify(source, {lang.common.invalid_value()})
                end
            end
        end

end)

RegisterNetEvent('ATM:WithdrawAll')
AddEventHandler('ATM:WithdrawAll', function()
    local source = source
    userid = ATM.getUserId(source)
    amount = ATM.getBankMoney(userid)
    if onesync ~= "off" then    
        --Onesync allows extra security behind events should enable it if it's not already.
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        for i, v in pairs(cfg.atms) do
            local coords = vec3(v[1], v[2], v[3])
            if #(playerCoords - coords) <= 5.0 then
            
                    local user_id = ATM.getUserId(source)
                    if user_id ~= nil then
                        if ATM.tryWithdraw(user_id, amount) then
                            ATMclient.notify(source, {lang.atm.withdraw.withdrawn({amount})})
                        else
                            ATMclient.notify(source, {lang.atm.withdraw.not_enough()})
                        end
                    end
   
            end
        end

    end
end)


RegisterNetEvent('ATM:DepositAll')
AddEventHandler('ATM:DepositAll', function()
    local source = source
    userid = ATM.getUserId(source)
    amount = ATM.getMoney(userid)

        --Onesync allows extra security behind events should enable it if it's not already.
        local ped = GetPlayerPed(source)
        local playerCoords = GetEntityCoords(ped)
        for i, v in pairs(cfg.atms) do
            local coords = vec3(v[1], v[2], v[3])
            if #(playerCoords - coords) <= 5.0 then
                if amount > 0 then
                    local user_id = ATM.getUserId(source)
                    if user_id ~= nil then
                        if ATM.tryDeposit(user_id, amount) then
                            ATMclient.notify(source, {lang.atm.deposit.deposited({amount})})
                        else
                            ATMclient.notify(source, {lang.money.not_enough()})
                        end
                    end
                else
                    ATMclient.notify(source, {lang.common.invalid_value()})
                end
            end
        end
end)

local function atm_choice_withdraw(player, choice)
    play_atm_enter(player)

    ATM.prompt(source, lang.atm.withdraw.prompt(), "", function(player, v)
        play_atm_exit(player) -- anim

        v = parseInt(v)

        if v > 0 then
            local user_id = ATM.getUserId(source)
            if user_id ~= nil then
                if ATM.tryWithdraw(user_id, v) then
                    ATMclient.notify(source, {lang.atm.withdraw.withdrawn({v})})
                else
                    ATMclient.notify(source, {lang.atm.withdraw.not_enough()})
                end
            end
        else
            ATMclient.notify(source, {lang.common.invalid_value()})
        end
    end)
end

local atm_menu = {
    name = lang.atm.title(),
    css = {
        top = "75px",
        header_color = "rgba(0,255,125,0.75)"
    }
}

atm_menu[lang.atm.deposit.title()] = {atm_choice_deposit, lang.atm.deposit.description()}
atm_menu[lang.atm.withdraw.title()] = {atm_choice_withdraw, lang.atm.withdraw.description()}

local function atm_enter()
    local user_id = ATM.getUserId(source)
    if user_id ~= nil then
        atm_menu[lang.atm.info.title()] = {function()
        end, lang.atm.info.bank({ATM.getBankMoney(user_id)})}
        ATM.openMenu(source, atm_menu)
    end
end

local function atm_leave()
    ATM.closeMenu(source)
end

local function build_client_atms(source)
    local user_id = ATM.getUserId(source)
    if user_id ~= nil then
        for k, v in pairs(atms) do
            local x, y, z = table.unpack(v)

            ATMclient.addBlip(source, {x, y, z, 108, 4, lang.atm.title()})
            ATMclient.addMarker(source, {x, y, z - 1, 0.7, 0.7, 0.5, 0, 255, 125, 125, 150})

            ATM.setArea(source, "ATM:atm" .. k, x, y, z, 1, 1.5, atm_enter, atm_leave)
        end
    end
end

AddEventHandler("ATM:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
     --   build_client_atms(source)
     -- Old atms now deprecated.
    end
end)
