fx_version "cerulean"
game "gta5"
lua54 "yes"

version "1.0"
author "Brodino"
description "An extraction script made by me c: \n used sjpfeiffer's ped_spawner code for creating peds"

client_scripts {
    "client.lua",
    "@PolyZone/client.lua",
    "@PolyZone/CircleZone.lua",
    "@es_extended/locale.lua",
    "locales/en.lua",
    "locales/it.lua"
}

server_scripts {
    "server.lua"
}

shared_scripts {
    "config.lua",
    "@es_extended/imports.lua",
    "@ox_lib/init.lua"
}

dependencies {
    "ox_lib",
    "ox_inventory",
    "PolyZone",
    "es_extended"
}