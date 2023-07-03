fx_version 'cerulean'
games { 'gta5' }
author 'JamesUK#6793'
description 'This is a discord bot made by JamesUK#6793. Give credit where credit is due!'

server_only 'yes'

dependency 'yarn'
--dependency 'oasis'

server_scripts {
    "@oasis/lib/utils.lua",
    "bot.js"
}

server_exports {
    'dmUser',
}