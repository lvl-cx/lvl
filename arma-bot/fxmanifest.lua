fx_version 'cerulean'
games { 'gta5' }
author 'JamesUK#6793'
description 'This is a discord bot made by JamesUK#6793. Give credit where credit is due!'

server_only 'yes'

dependency 'yarn'
--dependency 'arma'

server_scripts {
    "@arma/lib/utils.lua",
    "bot.js"
}