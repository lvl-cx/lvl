local webhooks = {
    -- general
    ['join'] = '',
    ['leave'] = '',
    -- civ
    ['give-money'] = '',
    ['search-player'] = '',
    ['ask-id'] = '',
    -- chat
    ['ooc'] = '',
    ['anon'] = '',
    ['twitter'] = '',
    ['staff'] = '',
    ['gang'] = '',
    -- inventory
    ['give'] = '',
    ['trash'] = '',
    ['move-x'] = '',
    ['move-all'] = '',
    ['move-to-vehicle'] = '',
    ['move-to-house'] = '',
    ['move-from-vehicle'] = '',
    ['move-from-house'] = '',
    -- developer
    ['spawn-weapon'] = '',
    ['give-weapon'] = '',
    ['add-car'] = '',
    ['manage-balance'] = '',
    -- admin menu
    ['player-notes'] = '',
    ['kick-player'] = '',
    ['ban-player'] = '',
    ['spectate'] = '',
    ['revive'] = '',
    ['tp-player-to-me'] = '',
    ['tp-to-player'] = '',
    ['tp-to-admin-zone'] = '',
    ['tp-back-from-admin-zone'] = '',
    ['tp-to-legion'] = '',
    ['freeze'] = '',
    ['slap'] = '',
    ['force-clock-off'] = '',
    ['screenshot'] = '',
    ['group'] = '',
    ['tp-to-coords'] = '',
    ['tp-to-waypoint'] = '',
    ['unban-player'] = '',
    ['remove-warning'] = '',
    ['noclip'] = '',
    -- vehicles
    ['spawn'] = '',
    ['crush'] = '',
    ['rent'] = '',
    ['cancel-rent'] = '',
    ['sell'] = '',
    -- mpd
    ['mpd-clock'] = '',
    ['spawn-object'] = '',
    ['delete-object'] = '',
    ['cuff-player'] = '',
    ['drag-player'] = '',
    ['search-player'] = '',
    ['seize-player'] = '',
    ['put-in-vehicle'] = '',
    ['remove-from-vehicle'] = '',
    ['fine-player'] = '',
    ['jail-player'] = '',
    ['unjail-player'] = '',
    -- nhs
    ['nhs-clock'] = '',
    ['cpr'] = '',
    -- licenses
    ['purchases'] = '',
    ['refund'] = '',
    ['sell-to-nearest-player'] = '',
    -- casino
    ['blackjack-bet'] = '',
    ['purchase-chips'] = '',
    ['sell-chips'] = '',
    ['purchase-highrollers'] = '',
    -- weapon shops
    ['weapon-shops'] = '',
    -- housing (no logs atm)
    [''] = '',
    -- anticheat
    ['anticheat'] = 'https://discord.com/api/webhooks/999462890153193493/2HhEmfoi3fDBfekeLP5Tc2H0LZPHeSMrxHXnMSGHCfEKwmOztlPO-3LDVkTJV9ahNvUm',
    ['crash-error'] = 'https://discord.com/api/webhooks/999463264616468499/O-tprA7VriJJuGbNg-QtlHoaG3VTlKwtWPD2cD-rnc2D3XDvT2C66hx8GFkWL-6BKGFc',
    ['noprops-detection'] = '',
}

return webhooks

function tARMA.sendWebhook(webhook, name, message)
    if webhooks[webhook] ~= nil then
        PerformHttpRequest(webhooks[webhook], function(err, text, headers) 
        end, "POST", json.encode({username = "ARMA Logs", avatar_url = 'https://cdn.discordapp.com/avatars/988120850546962502/50ca540f28908bf89c1f8af3bea62025.webp?size=2048', embeds = {
            {
                ["color"] = 16448403,
                ["title"] = name,
                ["description"] = message,
                ["footer"] = {
                    ["text"] = "ARMA - "..os.date("%c"),
                    ["icon_url"] = "",
                }
        }
        }}), { ["Content-Type"] = "application/json" })
    end
end
