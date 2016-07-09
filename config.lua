return {
	time_offset = 5,
	lang = 'en',
	antisquig = false,
	cli_port = 4567,

	max_command = 4,

	version = 'V4.2.4FG', --B = Beta, S = Slable, L = Lang, F = FIX -- G = GitHub
	debug = false,  -- True enable
	debug = {
		chat = -123456789
	},

	admin = 89198119,
	bot_test = 00000000,
	admin_name = 'Tiago Danin',
	moderation = {
		admins = {
			['89198119'] = 'Tiago Danin'
		},
		admin_group = -000000000,
		realm_name = 'SIDx'
	},

	errors = {
		erro = '🚫 ERRO',
		connection = '🚫 404:Connection',
		results = 'No results found.',
		argument = '🚫 Invalid argument.',
		syntax = 'Invalid syntax.',
		antisquig = '🚫 ERRO',
		moderation = '🚫 MOD',
		not_mod = '🚫 Super MOD',
		not_admin = '🚫 ADMIN',
		chatter_connection = '🚫 ',
		chatter_response = '🚫 '
	},

	plugins = {
		'control.lua',
		'blacklist.lua',
		'info.lua',
		'lang.lua',
		'ping.lua',
		'whoami.lua',
		'emoji.lua',
		'nick.lua',
		'echo.lua',
		'search.lua',
		'youtube.lua',
		'spotify.lua',
		'lastfm.lua',
		'wikipedia.lua',
		'tv.lua',
		'calc.lua',
		'time.lua',
		'infoMe.lua',
		'note.lua',
		'reddit.lua',
		'preview.lua',
		-- INLINE
		'inline.lua',
		-- + Plugins
		'sos.lua',
		'help.lua',
		'rank.lua',
		'command.lua'
	}
}
