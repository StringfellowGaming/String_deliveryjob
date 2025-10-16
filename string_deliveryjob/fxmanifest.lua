fx_version 'cerulean'
game 'gta5'

name 'string_deliveryjob'
description 'Delivery job for Qbox'
author 'Stringfellow_Gaming'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

dependencies {
    'qbx_core',
    'ox_lib',
    'ox_target',
}

lua54 'yes'