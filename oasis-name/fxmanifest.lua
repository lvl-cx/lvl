fx_version 'bodacious'
game 'gta5'

name 'oasis-name'
author 'rlhys'
description 'oasis copyright'

server_script {
    'server/server.lua',
    'version.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua',
    'config.lua'
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/time.js"
}