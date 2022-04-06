local currentBucketNum = 0

RegisterNetEvent("Sentry:AddLobby")
AddEventHandler("Sentry:AddLobby", function(name, coords)
    currentBucketNum = currentBucketNum + 1

    SetPlayerRoutingBucket(source, currentBucketNum)
    TriggerClientEvent("Sentry:RecieveLobbys", -1, name, coords, currentBucketNum)
    TriggerEvent("createLobbyLog", name, coords, source)
end)

RegisterNetEvent("Sentry:SetBucket")
AddEventHandler("Sentry:SetBucket", function(bucketId)
    SetPlayerRoutingBucket(source, bucketId)
end)