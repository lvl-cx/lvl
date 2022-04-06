local cfg = {}

cfg.items = {
  -- [Weed] 
  ["cannabis"] = {"Cannabis Sativa", "", nil, 1},
  ["weed"] = {"Weed", "", nil, 4}, 
  -- [Cocaine] 
  ["coca"] = {"Coca Leaf", "", nil, 1},
  ["cocaine"] = {"Cocaine", "", nil, 4}, 
  --[Gold]
  ["golddust"] = {"Gold Dust", "", nil, 1}, 
  ["gold"] = {"Gold", "", nil, 4},
  --[Dui]
  ["crystal"] = {"Diamond Crystal", "", nil, 1}, 
  ["diamond"] = {"Diamond", "", nil, 4},
  -- [Heroin]
  ["heroin"] = {"Heroin", "", nil, 4}, 
  ["opium"] = {"Opium", "", nil, 1},
  -- [LSD]
  ["lsd"] = {"LSD", "", nil, 4},
  ["acid"] = {"Lysergic Acid", "", nil, 1}, 
  -- [Armour Store]
  ["body_armor"] = {"Level 4 Armour Plate", "", nil, 5}, -- no choices
  ["body_armor2"] = {"Level 2 Armour Plate", "", nil, 5}, -- no choices
  ["body_armor3"] = {"Level 1 Armour Plate", "", nil, 5}, -- no choices
}

local function load_item_pack(name)
  local items = module("cfg/item/"..name)
  if items then
    for k,v in pairs(items) do
      cfg.items[k] = v
    end
  else
    print("[Sentry] item pack ["..name.."] not found")
  end
end

-- PACKS
load_item_pack("required")
load_item_pack("food")
load_item_pack("drugs")

return cfg
