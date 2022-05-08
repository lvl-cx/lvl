
local cfg = {}

cfg.inventory_weight = 30 -- weight for an user inventory per strength level (no unit, but thinking in "kg" is a good norm)

-- default chest weight for vehicle trunks
cfg.default_vehicle_chest_weight = 30

cfg.vehicle_chest_weights = {
    ["canamassault"] = 400,
    ["hycadem8"] = 400,
    ["300kg"] = 200,
    ["m977hl"] = 200,
    ["m9395"] = 200,
    ["mtfft"] = 200,
    ["MH6"] = 150,
    ["al18"] = 150,
    ["sjtoyota"] = 50,

}

return cfg
