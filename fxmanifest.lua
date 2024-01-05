fx_version 'cerulean'
game 'gta5'
author 'oph3z'
description 'Advanced house system | Made by codeReal'

ui_page {
	'html/index.html',
}

files {
	'html/*.css',
	'html/*.js',
	'html/*.html',
	'html/img/*.png',
    'html/img/*.jpg',
}

shared_script{
	'config/config.lua',
	'GetFrameworkObject.lua',
}

client_scripts {
	'config/client_config.lua',
	'client/*.lua',
}
server_scripts {
	'config/server_config.lua',
	'server/*.lua',
    -- '@mysql-async/lib/MySQL.lua', --⚠️PLEASE READ⚠️; Uncomment this line if you use 'mysql-async'.⚠️
    '@oxmysql/lib/MySQL.lua', --⚠️PLEASE READ⚠️; Uncomment this line if you use 'oxmysql'.⚠️
}

lua54 'yes'