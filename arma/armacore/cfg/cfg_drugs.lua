Drugs = {}

Drugs.Weed = {
  Gather = {title="Weed Gather", x = -294.18127441406,y = -1637.3488769531,z = 31.848804473877, radius = 20.0},  
  Process = {title="Weed Processor", x = -556.49096679688,y = -2269.3442382812,z = 7.7911801338196, radius = 40.0},
  Sell = {title="Weed Seller",  x = 116.97563934326,y = -1949.9448242188,z = 20.751323699951}, 
}

Drugs.Cocaine = {
  Gather = {title="Cocaine Gather", x = 2800.5151367188,y = -714.68695068359,z = 4.6797661781311, radius = 20.0},
  Process = {title="Cocaine Processor", x = 1733.18359375,y = -1630.7513427734,z = 112.45021820068, radius = 20.0},
  Sell = {title="Cocaine Seller",  x = 132.97074890137,y = -1305.3815917969,z = 29.177225112915},
}

Drugs.Gold = {
  Gather = {title="Gold Gather", x = -597.59320068359,y = 2093.1799316406,z = 131.41255187988 , radius = 20.0}, 
  Process = {title="Gold Processor", x = 580.38751220703,y = 2928.6623535156,z = 41.437519073486, radius = 20.0}, 
  Sell = {title="Gold Seller",  x = 3587.4343261719,y = 3667.73046875,z = 33.88179397583}, 
}

Drugs.Diamond = {
  Gather = {title="Diamond Gather", x = 361.99090576172,y = 2896.5141601562,z = 41.821823120117 , radius = 20.0}, 
  Process = {title="Diamond Processor", x = 2712.5983886719,y = 1497.7113037109,z = 24.500692367554, radius = 20.0}, 
  Sell = {title="Diamond Seller",  x = 3587.4343261719,y = 3667.73046875,z = 33.88179397583}, 
}

Drugs.Heroin = {
  Gather = {title="Heroin Gather", x = 2915.0041503906,y = 4670.9638671875,z = 49.09382247924837, radius = 20.0},  
  Process = {title="Heroin Processor", x = 1575.6392822266,y = 3363.982421875,z = 34.076892852783, radius = 20.0}, 
  Sell = {title="Heroin Seller",  x = 3587.4343261719,y = 3667.73046875,z = 33.88179397583}, 
}

Drugs.LSD = {
  Gather = {title="LSD Gather", x = 2396.6384277344,y = 4214.7021484375,z = 32.1741065979, radius = 20.0},
  Process = {title="LSD Processor", x = 2184.981689453,y = 3320.5576171875,z = 46.069805145264, radius = 20.0}, 
  Sell = {title="LSD Seller",  x = 2476.5876464844,y = -404.03320312,z = 94.816436767578}, 
}

blips = {}

blips.mapblips = {
    {coords = vector3(379.64025878906,-822.19964599609,29.302747726443), type = 'Weed Collect', colour = 2, sprite = 496},
    {coords = vector3(1386.564453125,-2151.8374023438,58.038352966309), type = "Weed Process", colour = 2, sprite = 496},
    {coords = vector3(116.87475585938,-1949.3751220703,20.73709487915), type = "Weed Seller", colour = 2, sprite = 496},

    {coords = vector3(3587.712890625,3667.6076660156,33.878574371338), type = 'Heroin Seller', colour = 1, sprite = 586},
    {coords = vector3(-101.45708465576,1910.0391845703,196.92016601562), type = 'Heroin Collect', colour = 1, sprite = 586},
    {coords = vector3(57.049602508545,3715.7570800781,39.754947662354), type = 'Heroin Process', colour = 1, sprite = 586},

    {coords = vector3(2310.61328125,5132.2709960938,50.35796737670), type = 'LSD Collect', colour = 7, sprite = 51},
    {coords = vector3(1319.6623535156,4314.6567382812,38.220794677734), type = 'LSD Process', colour = 7, sprite = 51},
    {coords = vector3(2483.0139160156,-417.52142333984,93.735191345215), type = 'LSD Seller', colour = 7, sprite = 51},

    {coords = vector3(2448.0822753906,4990.8056640625,46.542667388916), type = 'Diamond Seller', colour = 3, sprite = 617},
    
    {coords = vector3(447.23001098633,-985.09289550781,30.689598083496), type = 'Police Station', colour = 3, sprite = 60},
    {coords = vector3(-1653.8188476562,-1000.8563232422,13.017389297485), type = 'Parachuting', colour = 1, sprite = 550},
    
    {coords = vector3(1482.8521728516,1168.7008056641,115.06359100342), type = 'Cocaine Collect', colour = 0, sprite = 403},
    {coords = vector3(602.50946044922,-437.46441650391,24.756786346436), type = 'Cocaine Process', colour = 0, sprite = 403},
    {coords = vector3(107.15383911133,-1303.3717041016,28.768795013428), type = 'Cocaine Seller', colour = 0, sprite = 403},
    --{coords = vector3(), type = '', colour = 0, sprite = 51},

}

return blips 