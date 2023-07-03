RegisterNetEvent("OASIS:mutePlayers",function(a)
    for b, c in pairs(a) do
        exports["pma-voice"]:mutePlayer(b, true)
    end
end)
RegisterNetEvent("OASIS:mutePlayer",function(b)
    exports["pma-voice"]:mutePlayer(b, true)
end)
RegisterNetEvent("OASIS:unmutePlayer",function(b)
    exports["pma-voice"]:mutePlayer(b, false)
end)
