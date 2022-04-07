local Tunnel = module("sentry", "lib/Tunnel")
local Proxy = module("sentry", "lib/Proxy")
Sentry = Proxy.getInterface("Sentry")
Sentryclient = Tunnel.getInterface("Sentry", "IFN_RadialMenu")

--RegisterServerEvent("IFN:PoliceCheck")
--AddEventHandler("IFN:PoliceCheck", function()
--    local source = source
--    local user_id = Sentry.getUserId({source})
--    if Sentry.hasPermission({user_id, "cop.keycard"}) then
--        MetPD = true
--    else
--        MetPD = false
--    end
--    TriggerClientEvent("IFN:PoliceClockedOn", source, MetPD)
--end)

RegisterServerEvent("serverBoot")
AddEventHandler("serverBoot", function()
    TriggerClientEvent('openBoot', source)
end)
