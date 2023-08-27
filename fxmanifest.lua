fx_version 'bodacious'
lua54 'yes' 
game 'gta5' 

author 'R1CKY®#2220'
description 'Job Center - Tech Development'
version '1.0'


client_scripts {
    'client.lua'
}

shared_scripts {
    'config.lua',
}
server_scripts {
    'server.lua',
    'server_config.lua'
}

ui_page 'web/index.html'

files {
    'web/*.html',
    'web/css/*.css',
    'web/js/*.js',
    'web/fonts/*.otf',
    'web/img/*.png',
}
