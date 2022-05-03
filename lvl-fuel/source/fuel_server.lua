local Tunnel = module("lvl", "lib/Tunnel")
local Proxy = module("lvl", "lib/Proxy")
LVL = Proxy.getInterface("LVL")
LVLclient = Tunnel.getInterface("LVL", "LVL_Fuel")

if Config.UseESX then
	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local user_id = LVL.getUserId({source})
		local fuelAmount = math.floor(price)
		if LVL.tryFullPayment({user_id ,fuelAmount})then
		
		end
	end)
end
