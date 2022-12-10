local webhooks = {
    -- general
    ['join'] = 'https://discord.com/api/webhooks/991556621358596117/qBE4xyOVJ__KzEWwiqhttdNPE2eiSgjHCUMuAj17JGkY5cVSHtNbTZNM8JkgMSGzDMj2',
    ['leave'] = 'https://discord.com/api/webhooks/991556666095050803/cGTvcrMqB4wmub370MCRQHwW74tzLIHsmgkqXyNBqLPExMWNnB7lTXFRrcDmSNUYhAWQ',
    -- civ
    ['give-money'] = 'https://discord.com/api/webhooks/991455014751064104/5YHDx5686AN82SjPXGNFjdhqwY6eE46x811zFDBCcTGaoCV4azBEVnpqRplJTF5M0ZwJ',
    ['search-player'] = 'https://discord.com/api/webhooks/1050349594384551956/1zCXDtzA7SBEHpWBM7OqKY8_7XqmZb-bMK9RhkTui8yQoUDpoDuMnBwj4fGwdh1-9tJZ',
    ['ask-id'] = 'https://discord.com/api/webhooks/991453068325556264/eJpHA6UOLpkz767qNXyZDJemLtKQ3mGPsyGxmaAvxYZ5cn9kcaGI7w_R_-7RW9ZClTTi',
    -- chat
    ['ooc'] = 'https://discord.com/api/webhooks/991455740776693761/AGLdsqRCe4vLSuWOhNHsmeYHBjmjZ-hS-Nf2caTPPwSdZ4mtgG6l0KBWRN7r-WdzWl6q',
    ['twitter'] = 'https://discord.com/api/webhooks/991455851762176031/NekAg1_5wAzEVhu7qRObCRxxgCCLvpf7oHpbz3OFf7PJlpHYzLUb6I3OWbrycZq0WrZW',
    ['staff'] = 'https://discord.com/api/webhooks/991456198324916225/hMKyPEJZlhG2_ScGk6b_jLlnmU6wgd8L_a5mf5K4Gt72hEs1gp6ODaguxCwkCGRM_olj',
    ['gang'] = 'https://discord.com/api/webhooks/1050349210433757234/3U7I6KhpM2IdpsGLWITBtBJP1xF4gOe9ePSUwEQpLduRPrDWhicj_cg_KMxnOfO0In7p',
    ['anon'] = 'https://discord.com/api/webhooks/991455652524343416/S3vVK-a1pmRPVdYiF1fySi8JhL8wX-KY0OHNTEqsGV7OYeZrWmcN0V9lbQON5MMPPdnP',
    -- inventory
    ['give'] = 'https://discord.com/api/webhooks/991456286950559864/_-iG1kM7ZHybYpn8XfOznSz8VDrxJdakAoSWFBcbEqyGDpnr3JfzlckhUHzlt3YzE27a',
    ['trash'] = 'https://discord.com/api/webhooks/991456316646236170/fjNOCbxBTKf2jjRQO5E4b37V0YbLf9RgJhB3fGn1t_pCEuINOqmuNoY5K0PmNo7CWl1A',
    ['move-x'] = 'https://discord.com/api/webhooks/991456348548112524/VagESjovq2X810PRJ4ZlxhIozGyg-IaO20gqbbzVUv8kG2495P1jNFU2rN_p7Th4n6u6',
    ['move-all'] = 'https://discord.com/api/webhooks/991456387324448789/_ZAqd2wM35esCRbUlEIiG0gQg0lxzd11ErWE3pvSeBTO8PpJRbJhEPYDS4UevNxzEKUY',
    ['move-to-vehicle'] = 'https://discord.com/api/webhooks/991456419494764625/R1mTY9eVFXEJv2pvHVGZGwUO1D-3f8LkYmuXmkBhUKf6DRzzp-djSwDJ2_2ooJprHmmz',
    ['move-to-house'] = 'https://discord.com/api/webhooks/991456454127132774/PHBmQEG1JAE-rKIPcCuictDdi98cFWuRb4Su2AvBKycRyqTkufRs_8SLWgg7Frxj0IeH',
    ['move-from-vehicle'] = 'https://discord.com/api/webhooks/991456581562683434/BdOs9ThFs-JHtHH8FvMkce4watcUBeL57RYsRE9472Ucqq8kxxd3rmlR3xTLUAXd2KoH',
    ['move-from-house'] = 'https://discord.com/api/webhooks/991456616354422954/vQbgVJkokcJ0UYdKr4Z37iZ-fVRYZjhNbq4mNWLPXMhWRMKATLDsWanh0t8uH0EpkH8J',
    -- developer
    ['spawn-weapon'] = 'https://discord.com/api/webhooks/991456674038681680/2MLwDbdHTr_wOtJZHn5bZuO8ZK-C9LnigXBanDzSc-GnDEgfTWj_KYK8HWBOXzQU4wWn',
    ['give-weapon'] = 'https://discord.com/api/webhooks/991456700362137620/OXE6qxXf2dUAAFFlNsVH716-LT4tP6bR6Xim3PWyyv5vKrJ50nlNTh0h5iM9qNDUfjDY',
    ['add-car'] = 'https://discord.com/api/webhooks/991456728405258390/oATyn3OMl6CuiXuy1odhaM4wOFKj0qo_hCyYy7dllfIpEa1ORXKT-CyWzONSn9RVIEes',
    ['manage-balance'] = 'https://discord.com/api/webhooks/991456757740212336/ACWBj05Gz2nU8Nb8znkJphEn7xVLu2OjExlvfR7gaeait2gElyKxQzbkPAWWQZ_Ynhu9',
    -- admin menu
    ['player-notes'] = 'https://discord.com/api/webhooks/991456823884398623/EqKL4NW4qvjjWQ46_exR-2l51CrkviiTqK959DoSJmbvfQGBdbFdYmodMoWLemwBpH_c',
    ['kick-player'] = 'https://discord.com/api/webhooks/991456860869775452/IWFxWlgQ3rC9ztzBgcRAoYaiAqfa9VP8jAyTq1HE8S2Whj4qVaG5dQDd2H9Hwwou-KJe',
    ['ban-player'] = 'https://discord.com/api/webhooks/991456906818371735/iJ6RO_B3T-pvmeSFa5M8Jck8C5Cq1WsShX057QcK7b4Gu1nllpbt8Wf81W6-zdYhFbJ2',
    ['spectate'] = 'https://discord.com/api/webhooks/991475878863327352/2AoSwK-EhL6ob7iD5T2jFduqazrxg5RA5ixMpnCAdCuEjI6r1_rXIHqHhUg9S0jvHSY9',
    ['revive'] = 'https://discord.com/api/webhooks/991476015660552252/iEMahT-rQyRIMbOjlFqyI_QpZDZ1XhnsPWUu5BtAm3BY0r1nuv-bfbhnMimmSQE7wAgQ',
    ['tp-player-to-me'] = 'https://discord.com/api/webhooks/991476085248237659/YByx_T6sIDT2OUrNS9ZrHnsQ84tkqyxhClp6f-Dni3zi4U--lIuTssKLibN9L59XdlXh',
    ['tp-to-player'] = 'https://discord.com/api/webhooks/991476057393872966/TQBcjsriIZJIxdd4BCzC5mbL4uAfW7UKxA1sYJ8iWaFBQxymAtpxWpYmV1M_MsT4CwFn',
    ['tp-to-admin-zone'] = 'https://discord.com/api/webhooks/991476114688057384/o_HHxUAEBITN7ao61sxtHReWuSb-MIiaDbbrNXVAZuxnDpztKmr-3cLxf8PthFOHVwj7',
    ['tp-back-from-admin-zone'] = 'https://discord.com/api/webhooks/991476152818483281/_hS3k7xRxfAB-C_c0vNPt6HpwezrIEeWFTXi_FktX82sBvPgsmOKx7vJOo6k4eR5mBrO',
    ['tp-to-legion'] = 'https://discord.com/api/webhooks/991476182266695741/5GBbb5CIfk7Y0OgGh7DQZ6VvYxov5WWIzzCManNfMbY8RwfrfP_fEOYQdi3tcu1hvUDY',
    ['freeze'] = 'https://discord.com/api/webhooks/991476216383148122/zz1KDN5VzkIQjTFOJ1hs1NAz-Nf7tFpo65ychqF8C7zZ8EL8Gl9guOqZHxhyI9omRtTN',
    ['slap'] = 'https://discord.com/api/webhooks/991476247660073040/XNH5g7OwPFDoCA4D1wqNo_HWrZD5EWNbb6QoYc2ducFjV2cPkryg8ACyFOj_ItKSOdSC',
    ['force-clock-off'] = 'https://discord.com/api/webhooks/991476290496503818/vOqaK1KdoP1k3iK0aHRZlVBRBCXuOs4UOpK-sMcI7XTWnOFfT_7pnwhDoA_Bx-ccEub4',
    ['video'] = 'https://discord.com/api/webhooks/1051212433106161805/LRRvao6bFlSK5IwDAzWbo8v9R5UxEOQRN7Yryx0snckC9s4s6skF48SHDEorZD36lRAK',
    ['screenshot'] = 'https://discord.com/api/webhooks/991476361690628126/lTXMxhKvuhPic9Mc9aWM8eVBI5BZLJu_B3axgA80RtJp3LSCGqB6HqiScxiGq3mn_bum',
    ['group'] = 'https://discord.com/api/webhooks/991476392875274281/whNkj8tAOrjcODLqugXJEnyn6_Nd2rTLQ_ObAY3wXDljFarnwi-RCABeLJY9FXwPK2gB',
    ['tp-to-coords'] = 'https://discord.com/api/webhooks/991476622295306410/ZHl2CO1GiytVu-oJfcnNEEiKTvSGR6Yt1u1Zkdm6EOdqmWECcoWt1OTb9edu1oWlVkQD',
    ['tp-to-waypoint'] = 'https://discord.com/api/webhooks/991476693170659398/9-9T2TIHBP2hqvZOwq8FfLMQl0wI_PSP28WjTT9axmoMoXzxrvruTMaUHf0-DpG4ibVc',
    ['unban-player'] = 'https://discord.com/api/webhooks/991476724363706418/m2aEhULB5NWG0NzS5FgGscLSeJvMDApibQ7oMmBHPctTrlXxfLCodlvFByoTCJoAmzdZ',
    ['remove-warning'] = 'https://discord.com/api/webhooks/991476754126475454/r_GpM5RUqss3v7-RSDLwaMMejgMhwB4BRvqGRRITWXUO5LRaUoiq6QBZJwlKtRUuAzjZ',
    ['noclip'] = 'https://discord.com/api/webhooks/1050351167034626119/Ii4eYrC_rw3RXc_YOHrcjacIq0mLgF7J00ScD1kMpMnLq4_NH8XXVd50hi29khIuI34r',
    -- vehicles
    ['spawn'] = 'https://discord.com/api/webhooks/1050351249440129056/DPnHZ_T-10ULTC24-EYc-jjvmBi0BKHELjFOnZ-z-HWhXyGkUViKagK_oo1vaZHoVsXd',
    ['crush'] = 'https://discord.com/api/webhooks/1050351302015729714/h-CcvORewDCPeEZ8ED-l9M-lmk9omTw9uKWdjfFeDSfeh09YvnSJxn4yPcN4pHGWLRGs',
    ['rent'] = 'https://discord.com/api/webhooks/1050351350455746650/kydxxOyZCEUbZMUJe4xag4fWIs26_LNWiim5579KWHnEAs5m25_0yc1hdZF8jkVt5TSs',
    ['cancel-rent'] = 'https://discord.com/api/webhooks/1050351430642446346/tsDqIlxntaguV94ukIvC6jvl8RMm_n-t-3vZOuy2Wwb-J5ErIwwHe1Bc7yGB3hxGOThb',
    ['sell'] = 'https://discord.com/api/webhooks/1050351477450870814/aRku5v0sDcF7mvg3yAQMOu_eFGx6gCAHAmzA9RAj4-E6tWjplk1ZNXqAnRkCW2uvwyYq',
    -- mpd
    ['mpd-clock'] = 'https://discord.com/api/webhooks/1050351541070086175/o_NIG53u2BbeKn2E_KGKLdnu_e2pggaeBPFWgZaIGBrpRatYS5TwlXywL9TJWIZqP8F8',
    ['cuff-player'] = 'https://discord.com/api/webhooks/1050351590013419601/2cr3RK-AGcJuf5WL_1YRdoNMLv2aUsLEGrHbNrMesPdIWzx5knIAxk1xaIQbIuNDcv4g',
    ['drag-player'] = 'https://discord.com/api/webhooks/1050351644761657434/4sJpe0e3V4ejbS9foPC1FDl8hZUAmuxzBd-BXw2_7Zcegbbgo-qg8par8RJBxCe08Zbu',
    ['search-player'] = 'https://discord.com/api/webhooks/1050352491000242206/49SyuLytzBWGBwJvciBa3QlaS1B2XdAmM0FarrkEpppo5EjUc5ZfORCEEVAM5lu67PPp',
    ['seize-player'] = 'https://discord.com/api/webhooks/1050352434532331540/HHoyERGz7fb6LXxD0jJrV1uU7iie422sLRwdcwU9A6EuNsRY4WhpTQjj6beKuSETqmdQ',
    ['put-in-vehicle'] = 'https://discord.com/api/webhooks/1050352369784856606/kGSKe6lSpzVVKNneNfqSn1OTWPl2Czu9xzJ_M3JyiIy2EpMTFG0CadMDbYty_xikJxu6',
    ['remove-from-vehicle'] = 'https://discord.com/api/webhooks/1050352547984052275/ELAqZYcrUT3CSZGBlHheCkjFxbQtuQN8-L8jsqlcLHUGHSZtFuIFA8-thheRXBaQw8Zc',
    ['fine-player'] = 'https://discord.com/api/webhooks/1050352030671175700/h8iZjYxpi3WLECPPk6evN8TXQDHd0OJrst0Qv0fUApjnUpuoBzbnqDaiqeC9U9beg8Jq',
    ['jail-player'] = 'https://discord.com/api/webhooks/1050352087181054003/Hu6ttGthroSQL4g3ULyAcFJRzz3iBkLYvMJTuH_bS4lVQeaqwtUTnhTEdagomR8UHOvq',
    ['unjail-player'] = 'https://discord.com/api/webhooks/1050352137080676462/nQvD7SjYE8mZ2oFyuWLxXCmfPhPx49Avu0NwN5g6HeMPiQy_A2nZml3pSGbaKvQl58Qi',
    -- nhs
    ['nhs-clock'] = 'https://discord.com/api/webhooks/1050352190474174504/NsCjZxKjUFhk71elZfqRW274Gpx50sKYE54czeyByzptLOgCV8RypC-fErON-_bHYm_U',
    ['cpr'] = 'https://discord.com/api/webhooks/1050352244945592390/4JUf7XUfzvToblvGounvolDC1l_qre6U6BgUG7nyZPYEQs-7Ht0gZYzpBCyr6b5nAiAA',
    -- licenses
    ['purchases'] = 'https://discord.com/api/webhooks/1050352635095556157/0cQl-CYhatzE2v9VUx_yQKNY10cD8x-PV8oMkQJHcQizJneqeg5pdPsFlkErlV1nQ8Pc',
    ['refund'] = 'https://discord.com/api/webhooks/1050352679710367844/l8kXJ0Z0xB0Jc5aY7_O-R0snTwipb6PMPP8L_YRR_yv9EKTAFmfEgqtiXkFhudVA0fkq',
    ['sell-to-nearest-player'] = 'https://discord.com/api/webhooks/1050352744160034817/blvujZVCfns9W1O5BYu-PYVSSu4G0F6sGArsdvn74FBPHL2jS5UFJ82qohX6p-0-cY7a',
    -- casino
    ['blackjack-bet'] = 'https://discord.com/api/webhooks/1050352894127390740/h29WYQilD31Ism7YcOUR827S4d3G_X6lbhXmws-HkyUxHEEy5AVl49EDO4roc-QTw99G',
    ['purchase-chips'] = 'https://discord.com/api/webhooks/1050352950310080532/I4iZFDHszuSxjkyWRugTQdlfZ9bq__Tx5JcABJPpi7pPsnDW8qs3qpNtv67SA8iTTCDt',
    ['sell-chips'] = 'https://discord.com/api/webhooks/1050353008887734312/nqpG1zJhxAVtlaKCYL-g69hsn5vDnpk9yJzv_X-cbk_NPr3fMUxO8iHfnltQl7VxBqYP',
    ['purchase-highrollers'] = 'https://discord.com/api/webhooks/1050353072884416575/oAp-99C1cYXZZ4RsO0q_m6x86qS8NVZrVAw1CWa2eXie86gnqff_0vFefmBAtvCmHuXD',
    -- weapon shops
    ['weapon-shops'] = 'https://discord.com/api/webhooks/1050353204052905994/XxUefKcLqtqVAO4SCN2_iXqZktCzs1mWJl1r1-2Bkrl_LqvCqnT5JXpEwcdT98O99Dxf',
    -- housing (no logs atm)
    [''] = '',
    -- anticheat
    ['anticheat'] = 'https://discord.com/api/webhooks/999462890153193493/2HhEmfoi3fDBfekeLP5Tc2H0LZPHeSMrxHXnMSGHCfEKwmOztlPO-3LDVkTJV9ahNvUm',
    ['crash-error'] = 'https://discord.com/api/webhooks/999463264616468499/O-tprA7VriJJuGbNg-QtlHoaG3VTlKwtWPD2cD-rnc2D3XDvT2C66hx8GFkWL-6BKGFc',
    ['noprops-detection'] = 'https://discord.com/api/webhooks/1047298764974588026/IZIqbvTBgtUOLaVikrnUH-4pwqt211SS29w6_XkVdf5kmWQnEd1t-u1qONTFKfwBWrtd',
}

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

function tARMA.getWebhook(webhook)
    if webhooks[webhook] ~= nil then
        return webhooks[webhook]
    end
end