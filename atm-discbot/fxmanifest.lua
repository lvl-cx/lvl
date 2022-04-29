fx_version 'cerulean'
games { 'rdr3', 'gta5' }

author 'ATM'
description 'Bot Ban LOL'
version '1.0.0'
dependency 'ghmattimysql'
dependency 'yarn'
dependency 'webpack'

server_only 'no'
server_scripts {
    "SERVER/*"
}