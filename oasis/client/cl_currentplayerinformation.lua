local currentPlayerInfo = {}

RegisterNetEvent("OASIS:receiveCurrentPlayerInfo")
AddEventHandler("OASIS:receiveCurrentPlayerInfo",function(playerInfo)
    currentPlayerInfo = playerInfo
end)

function tOASIS.getCurrentPlayerInfo(z)
    for k,v in pairs(currentPlayerInfo) do
        if k == z then
            return v
        end
    end
end