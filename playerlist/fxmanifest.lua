fx_version 'bodacious'
games { 'gta5' }

author 'Arma'
description 'PlayerList'
version '1.0.0'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/css/*.css',
    'html/js/*.js',

    'html/fonts/Lato/*.ttf',
    'html/fonts/pricedown/*.ttf',

    'html/vendor/jquery/*.js',
    'html/vendor/bootstrap/js/*.js',
    'html/vendor/bootstrap/css/*.css',
    'html/vendor/perfect-scrollbar/*.js',
    'html/vendor/perfect-scrollbar/*.css',
    'html/vendor/animate/animate.css',
}

client_scripts {
    'client.lua',
    'lib/Proxy.lua',
    'lib/Tunnel.lua',
}

server_scripts {
    '@arma/lib/utils.lua',
    'server.lua',
}