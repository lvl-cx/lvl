SentryConfig = {} -- Global variable for easy referencing. 

SentryConfig.MoneyUiEnabled = true; -- Set to false to disable Money in the top right corner. 
SentryConfig.SurvivalUiEnabled = true; -- Controls the UI under the healthbar.
SentryConfig.EnableComa = true; -- Controls the Sentry coma on death.
SentryConfig.EnableFoodAndWater = true; -- Controls the food and water system.
SentryConfig.EnableHealthRegen = true; -- Controls the health regen. (Whether they regen health after taking damage do not disable if coma is enabled.)
SentryConfig.EnableBuyVehicles = true; -- Enables ability to buy vehicles from the RageUI Garages.  
SentryConfig.LoadPreviews = true; -- Controls the car previews with the RageUI Garages.
SentryConfig.VehicleStoreRadius = 250; -- Controls radius a vehicle can be stored from.
SentryConfig.AdminCoolDown = false; -- Enables an admin cooldown on call admin.
SentryConfig.AdminCooldownTime = 60; -- 1 minute in (seconds) duration of cooldown. 
SentryConfig.StoreWeaponsOnDeath = true; -- Stores the players weapon on death allowing them to be looted.
SentryConfig.DoNotDisplayIps = true; -- Removes all Sentry related references in the console to player ip addresses.
SentryConfig.LoseItemsOnDeath = true; -- Controls whether you lose inventory items on death.
SentryConfig.AllowMoreThenOneCar = false; -- Controls if you can have more than one car out.
SentryConfig.F10System = true; -- Logs warnings and can be accessed via F10 (Thanks to Rubbertoe98) (https://github.com/rubbertoe98/FiveM-Scripts/tree/master/vrp_punishments)
SentryConfig.ServerName = "Sentry" -- Controls the name that is displayed on warnings title etc.
SentryConfig.PlayerSavingTime = 3000 -- Time in milliseconds to update Player saving
---------------
SentryConfig.LootBags = true; -- Enables loot bags and disables looting. 
SentryConfig.DisplayNamelLootbag = true; -- Enables notification of who's lootbag you have opened
-- Thanks to JamesUK#6793 for the many options provided here.
