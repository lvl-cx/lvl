OASISTips= {
    "Watch out, there is more recoil than usual in this city",
    "Support OASIS @store.oasisv.co.uk for some cool VIP perks!",
    "Support OASIS @store.oasisv.co.uk for some cool VIP perks!",
    "Support OASIS @store.oasisv.co.uk for some cool VIP perks!",
    "Support OASIS @store.oasisv.co.uk for some cool VIP perks!",
    "Press L to open your inventory",
    "KOS is only allowed at redzones!",
    "You can point with B",
    "You can make your minimap bigger with Z",
    "You can perform CPR on your dead friends, with a small chance of resuscitation",
    "You sell all legal goods (Copper,Gold etc..) at the Trader which is south of the map near the docks",
    "You can get your GP to take a look at you and restore your health at any Hospital",
    "Check out our Website for whitelisted faction applications, https://www.oasisv.co.uk",
    "Want to join the PD? Apply at https://www.oasisv.co.uk",
    "Use /ooc or // to ask out of character questions",
    "To call an admin, type /calladmin",
    "To report a player you can create a player report at https://www.oasisv.co.uk/forums/",
    "You can lock your car with the comma key [,]",
    "If you are experiencing texture loss set your Texture Quality to Normal in graphics settings!",
    "F6 to see your licenses",
    "F5 to see your gang menu",
    "F10 to see your past warnings/kicks/bans",
    "M for vehicle functions/control",
    "Join our discord for discussion & development news https://discord.gg/oasisv",
    "Join our discord for discussion & development news https://discord.gg/oasisv",
    "Join our discord for discussion & development news https://discord.gg/oasisv",
    "Join our discord for discussion & development news https://discord.gg/oasisv",
    "Register on our website for discussion and whitelisting applications https://www.oasisv.co.uk",
    "Press F1 for help on getting started, controls & rules",
    "Press F1 for help on getting started, controls & rules",
    "Press F1 for help on getting started, controls & rules",
    "Press F1 for help on getting started, controls & rules",
    "Remember, selling or advertising the sale of anything in out of character chat is not allowed!",
    "Remember, selling or advertising the sale of anything in out of character chat is not allowed!",
    "Remember, selling or advertising the sale of anything in out of character chat is not allowed!",
    "Remember, selling or advertising the sale of anything in out of character chat is not allowed!",
    "Remember, selling or advertising the sale of anything in out of character chat is not allowed!",
    "CURRENT SALE: 20% OFF @ store.oasisv.co.uk",
    "CURRENT SALE: 20% OFF @ store.oasisv.co.uk",
    "CURRENT SALE: 20% OFF @ store.oasisv.co.uk",
    "CURRENT SALE: 20% OFF @ store.oasisv.co.uk",
    "CURRENT SALE: 20% OFF @ store.oasisv.co.uk",
    "CURRENT SALE: 20% OFF @ store.oasisv.co.uk",
    "CURRENT SALE: 20% OFF @ store.oasisv.co.uk",
    "Check out the #starter-guide channel in our discord for a quick guide on getting ahead in the city!",
    "Check out the #starter-guide channel in our discord for a quick guide on getting ahead in the city!",
    "Check out the #starter-guide channel in our discord for a quick guide on getting ahead in the city!",
}


Citizen.CreateThread(function()
    Wait(100000)
    while true do
        math.randomseed(GetGameTimer())
        num = math.random(1,#OASISTips)
        TriggerEvent("chatMessage", "", {255, 0, 0}, "^1[OASIS Tips]^1  " .. "^5" .. OASISTips[num], "ooc")
        Wait(600000)
    end
end)