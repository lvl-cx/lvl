local Tunnel = module("sentry", "lib/Tunnel")
local Proxy = module("sentry", "lib/Proxy")
Sentry = Proxy.getInterface("Sentry")
Sentryclient = Tunnel.getInterface("Sentry", "Sentry_Fuel")

if Config.UseESX then
	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local user_id = Sentry.getUserId({source})
		local fuelAmount = math.floor(price)
		if Sentry.tryFullPayment({user_id ,fuelAmount})then
		
		end
	end)
end
