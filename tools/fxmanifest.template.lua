--[[
    fxmanifest.lua TEMPLATE

    Copy into a new resource folder and fill in.
    Delete the blocks the resource does not use — an empty
    ui_page or an unused script list is worse than absent.
]]

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name        'RESOURCE_NAME'
author      'REPLACE_ME'
version     '0.1.0'
description 'One line: what this resource does.'
repository  'REPLACE_ME'

-- ---------------------------------------------------------------
-- Shared: loaded on client AND server.
-- Never put a security decision or a secret here — the client can
-- read all of it.
-- ---------------------------------------------------------------
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/*.lua',
}

-- ---------------------------------------------------------------
-- Client: presentation only. Nothing here is trusted by the server.
-- ---------------------------------------------------------------
client_scripts {
    'client/*.lua',
}

-- ---------------------------------------------------------------
-- Server: all validation, all money, all inventory, all SQL.
-- ---------------------------------------------------------------
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

-- ---------------------------------------------------------------
-- NUI (delete if this resource has no UI)
-- ---------------------------------------------------------------
-- ui_page 'web/build/index.html'
-- files {
--     'web/build/index.html',
--     'web/build/**/*',
-- }

-- ---------------------------------------------------------------
-- Dependencies. Listing them makes a load-order mistake fail loudly
-- at startup instead of quietly at runtime.
-- ---------------------------------------------------------------
dependencies {
    'ox_lib',
    'qbx_core',
    -- 'ox_inventory',
    -- 'ox_target',
    -- 'oxmysql',
}
