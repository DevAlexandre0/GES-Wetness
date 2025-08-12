fx_version 'cerulean'
game 'gta5'
name 'GES-Wetness'
description 'Standalone wetness tracker (client) with SurvCore relay'
author 'GES'
version '1.0.0'
lua54 'yes'

shared_scripts { 'config.lua' }
client_scripts { 'client.lua' }
server_scripts { 'server.lua' }

exports { 'getWetnessData' }
