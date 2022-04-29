tutorialcfg = {}

-- Master Keys
tutorialcfg.Debug = false -- Should you be able to trigger the script with "/cut2" command.
tutorialcfg.Clothes = true -- Should you start with custom set clothes or the default one.

-- Coords tutorialcfg are inside the client.lua file

-- Other tutorialcfgs
tutorialcfg.TaxaModel = "taxi" -- What model taxa should be spawn
tutorialcfg.PedModel = "a_m_y_stlat_01"
tutorialcfg.drivetolocation = vector3(-902.76495361328,-2050.8444824219,9.2991437911987)

-- Ohhh you want to trigger the event after something else have happend?
-- Use this here | Remember to comment out the "vRP:playerSpawn" function if you use this line below.
-- TriggerClientEvent("First_Spawn_Trigger:vRP", _source)