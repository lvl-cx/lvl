ATMConfig = {} -- Global variable for easy referencing. 

ATMConfig.MoneyUiEnabled = true; -- Set to false to disable Money in the top right corner. 
ATMConfig.SurvivalUiEnabled = true; -- Controls the UI under the healthbar.
ATMConfig.EnableComa = true; -- Controls the ATM coma on death.
ATMConfig.EnableFoodAndWater = true; -- Controls the food and water system.
ATMConfig.EnableHealthRegen = true; -- Controls the health regen. (Whether they regen health after taking damage do not disable if coma is enabled.)
ATMConfig.EnableBuyVehicles = true; -- Enables ability to buy vehicles from the RageUI Garages.  
ATMConfig.LoadPreviews = true; -- Controls the car previews with the RageUI Garages.
ATMConfig.VehicleStoreRadius = 250; -- Controls radius a vehicle can be stored from.
ATMConfig.AdminCoolDown = false; -- Enables an admin cooldown on call admin.
ATMConfig.AdminCooldownTime = 60; -- 1 minute in (seconds) duration of cooldown. 
ATMConfig.StoreWeaponsOnDeath = true; -- Stores the players weapon on death allowing them to be looted.
ATMConfig.DoNotDisplayIps = true; -- Removes all ATM related references in the console to player ip addresses.
ATMConfig.LoseItemsOnDeath = true; -- Controls whether you lose inventory items on death.
ATMConfig.AllowMoreThenOneCar = false; -- Controls if you can have more than one car out.
ATMConfig.F10System = true; -- Logs warnings and can be accessed via F10 (Thanks to Rubbertoe98) (https://github.com/rubbertoe98/FiveM-Scripts/tree/master/atm_punishments)
ATMConfig.ServerName = "ATM" -- Controls the name that is displayed on warnings title etc.
ATMConfig.PlayerSavingTime = 3000 -- Time in milliseconds to update Player saving
---------------
ATMConfig.LootBags = true; -- Enables loot bags and disables looting. 
ATMConfig.DisplayNamelLootbag = false; -- Enables notification of who's lootbag you have opened
-- Thanks to JamesUK#6793 for the many options provided here.
