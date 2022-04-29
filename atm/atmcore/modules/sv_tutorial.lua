RegisterNetEvent('ATM:SetBucket')
AddEventHandler('ATM:SetBucket', function(bucket2)
    local source = source
    if bucket2 == 'source' then
        SetPlayerRoutingBucket(source, source)
        ATMclient.notify(source, {'Changed Bucket'})
    elseif bucket2 == '0' then 
        SetPlayerRoutingBucket(source, 0)
        ATMclient.notify(source, {'Changed Bucket'})
    end
end)