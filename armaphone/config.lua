Config = {}

-- Script locale (only .Lua)
Config.Locale = 'en'

Config.AutoFindFixePhones = true -- Automatically add pay phones as they are found by their models.

Config.FixePhone = {
    ['911'] = { 
        name =  'mission_row', 
        coords = { x = 441.2, y = -979.7, z = 30.58 } 
    },
    ['police'] = { 
    name =  'mission_row', 
    coords = { x = 441.2, y = -979.7, z = 30.58 } 
    },
}

Config.KeyOpenClose = 311 -- F1
Config.KeyTakeCall  = 38  -- E

Config.UseMumbleVoIP = true -- Use Frazzle's Mumble-VoIP Resource (Recomended!) https://github.com/FrazzIe/mumble-voip
Config.UseTokoVoIP   = false

Config.ShowNumberNotification = true-- Show Number or Contact Name when you receive new SMS

Config.Discord_Webhook = '' -- Set Discord Webhook (WIP)
