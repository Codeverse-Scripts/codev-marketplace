fx_version 'cerulean'
game 'common'
author 'atiysu'
lua54 'yes'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/utils.lua',
    'client/main.lua'
}

server_scripts {
    'server/utils.lua',
    'server/main.lua'
}

ui_page 'ui/index.html'

files {
    'database.json',
    'ui/**/*.*',
    'ui/*.*',
}

escrow_ignore {
    'config.lua',
    'client/*.lua',
    'server/*.lua',
}
dependency '/assetpacks'