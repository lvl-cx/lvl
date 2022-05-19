local Tunnel = module("arma", "lib/Tunnel")
local Proxy = module("arma", "lib/Proxy")
ARMA = Proxy.getInterface("ARMA")
ARMAclient = Tunnel.getInterface("ARMA", "ARMA_Fuel")

if Config.UseESX then
	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local user_id = ARMA.getUserId({source})
		local fuelAmount = math.floor(price)
		if ARMA.tryFullPayment({user_id ,fuelAmount})then
		
		end
	end)
end
