local webhooks = {
    -- general
    ['join'] = 'https://discord.com/api/webhooks/991556621358596117/qBE4xyOVJ__KzEWwiqhttdNPE2eiSgjHCUMuAj17JGkY5cVSHtNbTZNM8JkgMSGzDMj2',
    ['leave'] = 'https://discord.com/api/webhooks/991556666095050803/cGTvcrMqB4wmub370MCRQHwW74tzLIHsmgkqXyNBqLPExMWNnB7lTXFRrcDmSNUYhAWQ',
    -- civ
    ['give-cash'] = 'https://discord.com/api/webhooks/991455014751064104/5YHDx5686AN82SjPXGNFjdhqwY6eE46x811zFDBCcTGaoCV4azBEVnpqRplJTF5M0ZwJ',
    ['bank-transfer'] = 'https://discord.com/api/webhooks/1057150997924937760/KIrZsrRwZP-v2qI4wRjuzYjjR1NoWuvFwDkBtWoMg6nWl9CPJBh72FLxpdtm0iynaoYx',
    ['search-player'] = 'https://discord.com/api/webhooks/1050349594384551956/1zCXDtzA7SBEHpWBM7OqKY8_7XqmZb-bMK9RhkTui8yQoUDpoDuMnBwj4fGwdh1-9tJZ',
    ['ask-id'] = 'https://discord.com/api/webhooks/991453068325556264/eJpHA6UOLpkz767qNXyZDJemLtKQ3mGPsyGxmaAvxYZ5cn9kcaGI7w_R_-7RW9ZClTTi',
    -- chat
    ['ooc'] = 'https://discord.com/api/webhooks/991455740776693761/AGLdsqRCe4vLSuWOhNHsmeYHBjmjZ-hS-Nf2caTPPwSdZ4mtgG6l0KBWRN7r-WdzWl6q',
    ['twitter'] = 'https://discord.com/api/webhooks/991455851762176031/NekAg1_5wAzEVhu7qRObCRxxgCCLvpf7oHpbz3OFf7PJlpHYzLUb6I3OWbrycZq0WrZW',
    ['staff'] = 'https://discord.com/api/webhooks/991456198324916225/hMKyPEJZlhG2_ScGk6b_jLlnmU6wgd8L_a5mf5K4Gt72hEs1gp6ODaguxCwkCGRM_olj',
    ['gang'] = 'https://discord.com/api/webhooks/1050349210433757234/3U7I6KhpM2IdpsGLWITBtBJP1xF4gOe9ePSUwEQpLduRPrDWhicj_cg_KMxnOfO0In7p',
    ['anon'] = 'https://discord.com/api/webhooks/991455652524343416/S3vVK-a1pmRPVdYiF1fySi8JhL8wX-KY0OHNTEqsGV7OYeZrWmcN0V9lbQON5MMPPdnP',
    -- admin menu
    ['kick-player'] = 'https://discord.com/api/webhooks/991456860869775452/IWFxWlgQ3rC9ztzBgcRAoYaiAqfa9VP8jAyTq1HE8S2Whj4qVaG5dQDd2H9Hwwou-KJe',
    ['ban-player'] = 'https://discord.com/api/webhooks/991456906818371735/iJ6RO_B3T-pvmeSFa5M8Jck8C5Cq1WsShX057QcK7b4Gu1nllpbt8Wf81W6-zdYhFbJ2',
    ['spectate'] = 'https://discord.com/api/webhooks/991475878863327352/2AoSwK-EhL6ob7iD5T2jFduqazrxg5RA5ixMpnCAdCuEjI6r1_rXIHqHhUg9S0jvHSY9',
    ['revive'] = 'https://discord.com/api/webhooks/991476015660552252/iEMahT-rQyRIMbOjlFqyI_QpZDZ1XhnsPWUu5BtAm3BY0r1nuv-bfbhnMimmSQE7wAgQ',
    ['tp-player-to-me'] = 'https://discord.com/api/webhooks/991476085248237659/YByx_T6sIDT2OUrNS9ZrHnsQ84tkqyxhClp6f-Dni3zi4U--lIuTssKLibN9L59XdlXh',
    ['tp-to-player'] = 'https://discord.com/api/webhooks/991476057393872966/TQBcjsriIZJIxdd4BCzC5mbL4uAfW7UKxA1sYJ8iWaFBQxymAtpxWpYmV1M_MsT4CwFn',
    ['tp-to-admin-zone'] = 'https://discord.com/api/webhooks/991476114688057384/o_HHxUAEBITN7ao61sxtHReWuSb-MIiaDbbrNXVAZuxnDpztKmr-3cLxf8PthFOHVwj7',
    ['tp-back-from-admin-zone'] = 'https://discord.com/api/webhooks/991476152818483281/_hS3k7xRxfAB-C_c0vNPt6HpwezrIEeWFTXi_FktX82sBvPgsmOKx7vJOo6k4eR5mBrO',
    ['freeze'] = 'https://discord.com/api/webhooks/991476216383148122/zz1KDN5VzkIQjTFOJ1hs1NAz-Nf7tFpo65ychqF8C7zZ8EL8Gl9guOqZHxhyI9omRtTN',
    ['slap'] = 'https://discord.com/api/webhooks/991476247660073040/XNH5g7OwPFDoCA4D1wqNo_HWrZD5EWNbb6QoYc2ducFjV2cPkryg8ACyFOj_ItKSOdSC',
    ['force-clock-off'] = 'https://discord.com/api/webhooks/991476290496503818/vOqaK1KdoP1k3iK0aHRZlVBRBCXuOs4UOpK-sMcI7XTWnOFfT_7pnwhDoA_Bx-ccEub4',
    ['screenshot'] = 'https://discord.com/api/webhooks/991476361690628126/lTXMxhKvuhPic9Mc9aWM8eVBI5BZLJu_B3axgA80RtJp3LSCGqB6HqiScxiGq3mn_bum',
    ['video'] = 'https://discord.com/api/webhooks/1051212433106161805/LRRvao6bFlSK5IwDAzWbo8v9R5UxEOQRN7Yryx0snckC9s4s6skF48SHDEorZD36lRAK',
    ['group'] = 'https://discord.com/api/webhooks/991476392875274281/whNkj8tAOrjcODLqugXJEnyn6_Nd2rTLQ_ObAY3wXDljFarnwi-RCABeLJY9FXwPK2gB',
    ['unban-player'] = 'https://discord.com/api/webhooks/991476724363706418/m2aEhULB5NWG0NzS5FgGscLSeJvMDApibQ7oMmBHPctTrlXxfLCodlvFByoTCJoAmzdZ',
    ['remove-warning'] = 'https://discord.com/api/webhooks/991476754126475454/r_GpM5RUqss3v7-RSDLwaMMejgMhwB4BRvqGRRITWXUO5LRaUoiq6QBZJwlKtRUuAzjZ',
    ['add-car'] = 'https://discord.com/api/webhooks/991456728405258390/oATyn3OMl6CuiXuy1odhaM4wOFKj0qo_hCyYy7dllfIpEa1ORXKT-CyWzONSn9RVIEes',
    ['manage-balance'] = 'https://discord.com/api/webhooks/991456757740212336/ACWBj05Gz2nU8Nb8znkJphEn7xVLu2OjExlvfR7gaeait2gElyKxQzbkPAWWQZ_Ynhu9',
    -- vehicles
    ['crush-vehicle'] = 'https://discord.com/api/webhooks/1050351302015729714/h-CcvORewDCPeEZ8ED-l9M-lmk9omTw9uKWdjfFeDSfeh09YvnSJxn4yPcN4pHGWLRGs',
    ['rent-vehicle'] = 'https://discord.com/api/webhooks/1050351350455746650/kydxxOyZCEUbZMUJe4xag4fWIs26_LNWiim5579KWHnEAs5m25_0yc1hdZF8jkVt5TSs',
    ['sell-vehicle'] = 'https://discord.com/api/webhooks/1050351477450870814/aRku5v0sDcF7mvg3yAQMOu_eFGx6gCAHAmzA9RAj4-E6tWjplk1ZNXqAnRkCW2uvwyYq',
    -- mpd
    ['pd-clock'] = 'https://discord.com/api/webhooks/1056165736684474398/bWUtN88MrbTlFiPdBhMLdhvSF7s_r76Z6LAESdLf4uSPiWBVRx7NT1kL8rTGkmC4k1YA',
    ['pd-afk'] = 'https://discord.com/api/webhooks/1056165912501309480/kajjJF9qX9HpkDFJB0Wyb2u1LckDaynGtKMuF5qYbQfs6v8p8XTpqODXfNfwlHX_KIcC',
    ['pd-armoury'] = 'https://discord.com/api/webhooks/1056166199228108842/bV6w1j2aLInCEkklnJ3h9ez108TMOvWesttFwM5rntcjiYESrXJO_4c0nn4Vh5ZcH2fr',
    ['fine-player'] = 'https://discord.com/api/webhooks/1057560302444630056/fsfZiDMAXTuDFfMrQ2w9CI_RiUCLN6-2XpzqDI9Bj_roZ8yov4u66ikQFkk5A_v-arga',
    ['jail-player'] = 'https://discord.com/api/webhooks/1056166087756091462/PgygWzUleg5KWmCAxsETa9zezkP37pDLBaqtvyPxYa9YUtskSEcKW3kFU3zRaFOi4ZOS',
    ['pd-panic'] = 'https://discord.com/api/webhooks/1060733837417644122/BSuasYngBBN5H5EKHjgd2DtbfYuiEGK4wx8G7FgqZ5-jusNhOAMWz8FPjj4dNzVAIE9j',
    ['seize-boot'] = 'https://discord.com/api/webhooks/1060733884788125827/GsfykZvkmCjtgOce7_1PcyH1kTIFzIwSYa8wgGeP26BLap0C7cHpFvRS0TRZkNn4RHBL',
    ['impound'] = 'https://discord.com/api/webhooks/1060733936428384256/e3CUtdizOWD_EtgOfFYLN5xQlp-F5kZMDRYW7h4ezuVzK6eRg9SvtXTIeFKssvoNl-C7',
    ['police-k9'] = 'https://discord.com/api/webhooks/1062516761666265170/nAJ0RQzpOyCvPFwQyk2YscRgdK4aA68VP_ZaM5FVwcHNOlmGnMFY0umDcdu2FZfNaOvy',
    -- nhs
    ['nhs-clock'] = '',
    ['cpr'] = '',
    -- licenses
    ['purchases'] = 'https://discord.com/api/webhooks/1050352635095556157/0cQl-CYhatzE2v9VUx_yQKNY10cD8x-PV8oMkQJHcQizJneqeg5pdPsFlkErlV1nQ8Pc',
    ['sell-to-nearest-player'] = 'https://discord.com/api/webhooks/1050352744160034817/blvujZVCfns9W1O5BYu-PYVSSu4G0F6sGArsdvn74FBPHL2jS5UFJ82qohX6p-0-cY7a',
    -- casino
    ['blackjack-bet'] = 'https://discord.com/api/webhooks/1050352894127390740/h29WYQilD31Ism7YcOUR827S4d3G_X6lbhXmws-HkyUxHEEy5AVl49EDO4roc-QTw99G',
    ['coinflip-bet'] = 'https://discord.com/api/webhooks/1057570226801217556/mToQntSgGYtp0AjGMWj9YyhwMY-_hzdA_ocP-fpgxGmLtQoVvWx59gLpsobG-79qNQ9b',
    ['purchase-chips'] = 'https://discord.com/api/webhooks/1050352950310080532/I4iZFDHszuSxjkyWRugTQdlfZ9bq__Tx5JcABJPpi7pPsnDW8qs3qpNtv67SA8iTTCDt',
    ['sell-chips'] = 'https://discord.com/api/webhooks/1050353008887734312/nqpG1zJhxAVtlaKCYL-g69hsn5vDnpk9yJzv_X-cbk_NPr3fMUxO8iHfnltQl7VxBqYP',
    ['purchase-highrollers'] = 'https://discord.com/api/webhooks/1050353072884416575/oAp-99C1cYXZZ4RsO0q_m6x86qS8NVZrVAw1CWa2eXie86gnqff_0vFefmBAtvCmHuXD',
    -- weapon shops
    ['weapon-shops'] = 'https://discord.com/api/webhooks/1050353204052905994/XxUefKcLqtqVAO4SCN2_iXqZktCzs1mWJl1r1-2Bkrl_LqvCqnT5JXpEwcdT98O99Dxf',
    -- housing (no logs atm)
    [''] = '',
    -- anticheat
    ['anticheat'] = 'https://discord.com/api/webhooks/999462890153193493/2HhEmfoi3fDBfekeLP5Tc2H0LZPHeSMrxHXnMSGHCfEKwmOztlPO-3LDVkTJV9ahNvUm',
    ['ban-evaders'] = 'https://discord.com/api/webhooks/1053360388034547794/0xWb4TXG9CCJbybss9b5YalTSm1FMlyHgetGnGhV23KAieWUk7FmMI4_NS6Un3945tjO',
}

local webhookQueue = {}
Citizen.CreateThread(function()
    while true do
        if next(webhookQueue) then
            for k,v in pairs(webhookQueue) do
                Citizen.Wait(100)
                if webhooks[v.webhook] ~= nil then
                    PerformHttpRequest(webhooks[v.webhook], function(err, text, headers) 
                    end, "POST", json.encode({username = "ARMA Logs", avatar_url = 'https://cdn.discordapp.com/avatars/988120850546962502/50ca540f28908bf89c1f8af3bea62025.webp?size=2048', embeds = {
                        {
                            ["color"] = 16448403,
                            ["title"] = v.name,
                            ["description"] = v.message,
                            ["footer"] = {
                                ["text"] = "ARMA - "..v.time,
                                ["icon_url"] = "",
                            }
                    }
                    }}), { ["Content-Type"] = "application/json" })
                end
                webhookQueue[k] = nil
            end
        end
        Citizen.Wait(0)
    end
end)
local webhookID = 1
function tARMA.sendWebhook(webhook, name, message)
    webhookID = webhookID + 1
    webhookQueue[webhookID] = {webhook = webhook, name = name, message = message, time = os.date("%c")}
end

function ARMA.sendWebhook(webhook, name, message) -- used for other resources to send through webhook logs 
   tARMA.sendWebhook(webhook, name, message)
end

function tARMA.getWebhook(webhook)
    if webhooks[webhook] ~= nil then
        return webhooks[webhook]
    end
end