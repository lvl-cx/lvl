local Tunnel = module("atm", "lib/Tunnel")
local Proxy = module("atm", "lib/Proxy")
ATM = Proxy.getInterface("ATM")
ATMclient = Tunnel.getInterface("ATM", "ATM_Fuel")

if Config.UseESX then
	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local user_id = ATM.getUserId({source})
		local fuelAmount = math.floor(price)
		if ATM.tryFullPayment({user_id ,fuelAmount})then
		
		end
	end)
end
