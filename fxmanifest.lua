fx_version 'cerulean'

game 'gta5'

author 'Hennu´s'

description 'Hennu´s Multijob'

version '0.1.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

ui_page 'nui/index.html'

files {
    'nui/index.html',
    'nui/app.js',
    'nui/style.css',
}



lua54 'yes'


