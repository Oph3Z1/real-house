fx_version 'cerulean'
game 'gta5'
description 'oph3z-houseV2'

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
	'config.lua',
	'GetFrameworkObject.lua',
}

escrow_ignore {
	'config.lua',
	'GetFrameworkObject.lua',
    'client/*.lua'
	'server/*.lua',
}

client_scripts {
	'GetFrameworkObject.lua',
	'client/*.lua',
}
server_scripts {
	'server/*.lua',
    -- '@mysql-async/lib/MySQL.lua', --⚠️PLEASE READ⚠️; Uncomment this line if you use 'mysql-async'.⚠️
    '@oxmysql/lib/MySQL.lua', --⚠️PLEASE READ⚠️; Uncomment this line if you use 'oxmysql'.⚠️
}

lua54 'yes'