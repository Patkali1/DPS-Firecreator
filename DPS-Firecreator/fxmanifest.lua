fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'DPS by Patkali01'
description 'Advanced Fire System (QBCore) with Admin UI and MySQL'
version '2.1.0'

shared_script 'config.lua'
client_script 'client.lua'
server_script '@oxmysql/lib/MySQL.lua'
server_script 'server.lua'

ui_page 'html/admin.html'

files {
    'html/admin.html'
}

dependency 'oxmysql'
