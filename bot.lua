HTTP = require('socket.http')
HTTPS = require('ssl.https')
URL = require('socket.url')
JSON = require('cjson')
HTML = require('htmlEntities')
-- Redis
redis_server = require('redis') --https://github.com/nrk/redis-lua
redis = redis_server.connect('127.0.0.1', 6379)

bot_init = function() -- The function run when the bot is started or reloaded.
	config = dofile('config.lua') -- Load configuration file.
 	key = dofile("key.lua") -- Load API KEY
	dofile('bindings.lua') -- Load Telegram bindings.
	dofile('utilities.lua') -- Load miscellaneous and cross-plugin functions.
	if key.bot_api_key == '' then
		print("Need API-Key in 'key.lua'")
		return
	end

	os.execute('clear')
	print('\n')
	print('▒█▀▀▀█ ▀█▀ ▒█▀▀▄    '..config.version)
	print('░▀▀▀▄▄ ▒█░ ▒█░▒█    Base Otoutov3.2 by topkecleon')
	print('▒█▄▄▄█ ▄█▄ ▒█▄▄▀    SiDBot V4 ByTiagoDanin')
	print('                    '..config.admin_name..' - '..config.admin)

	-- Fetch bot information. Try until it succeeds.
	repeat bot = getMe() until bot
	bot = bot.result

	print('Init Plugins')
	plugins = {} -- Load plugins.
	local n = 0
	for i,v in ipairs(config.plugins) do
		local p = dofile("plugins/"..v)
		n = n + 1 .. '  '
		local print_sh = n:sub(1, 2) ..'. '.. v:gsub('.lua', ' ...................'):sub(1, 15)
		print(print_sh)
		table.insert(plugins, p)
	end

	print(' ')
	print('Info do bot:')
	print('@'..bot.username..', Name: '..bot.first_name..' ID: '.. bot.id)
	print(' ')

	-- Generate a random seed and "pop" the first random number. :)
	math.randomseed(os.time())
	math.random()

	last_update = last_update or 0 -- Set loop variables: Update offset,
	last_cron = last_cron or os.time() -- the time of the last cron job,
	is_started = true -- whether the bot should be running or not.
	usernames = usernames or {} -- Table to cache usernames by user ID.

end

on_msg_receive = function(msg) -- The fn run whenever a message is received.

	if msg.from.username then
		usernames[msg.from.username:lower()] = msg.from.id
	end

	if msg.date < os.time() - 5 then return end -- Do not process old messages.
	if not msg.text then msg.text = msg.caption or '' end

	if msg.text:match('^/start .+') then
		msg.text = '/' .. msg.text:input()
	end

	-- LOG Chat
	local from_name = msg.from.first_name or 'NIL.'
	if msg.from.last_name then
		from_name = from_name .. ' ' .. msg.from.last_name or 'NIL.'
	end
	local msg_texto = msg.text:lower() or 'NIL.'
	local title_chat = msg.chat.title or 'NIL.'
	if msg.from.id == msg.chat.id then
		title_chat = 'Private chat'
	end

	for i,v in ipairs(plugins) do
		for k,w in pairs(v.triggers) do
			if string.match(msg.text:lower(), w) then

				-- a few shortcuts
				msg.chat.id_str = tostring(msg.chat.id)
				msg.from.id_str = tostring(msg.from.id)
				msg.text_lower = msg.text:lower()
				msg.from.name = msg.from.first_name
				if msg.from.last_name then
					msg.from.name = msg.from.first_name .. ' ' .. msg.from.last_name
				end

				--lang
				local chat_id = msg.chat.id_str
				if msg.from.id == msg.chat.id then
					chat_id = msg.from.id_str
				end
				if not redis:get('LANG:'..chat_id) then
					print('NEW USER LANG')
					redis:set('LANG:'..chat_id, config.lang)
				end
				lang = tostring(redis:get('LANG:'..chat_id))

				local success, result = pcall(function()
					return v.action(msg)
				end)
				if not success then
					sendReply(msg, '🚫 ERRO')
					handle_exception(result, msg.text)
					return
				end
				-- If the action returns a table, make that table msg.
				if type(result) == 'table' then
					msg = result
				-- If the action returns true, don't stop.
				elseif result ~= true then
					return
				end
			end
		end
	end

end

inline_msg_receive = function(inline) -- run whenever a inline query is received.
	msg = {
		id = inline.id,
		chat = {
			['id'] = inline.from.id,
			['title'] = 'inline',
			['type'] = 'inline',
			['title'] = inline.from.fisrt_name
			},
		from = inline.from,
		message_id = math.random(100, 800),
		text = '/!/inline '..inline.query,
		date = os.time() + 20
	}
	-- Convent to message
	on_msg_receive(msg)
end

bot_init() -- Actually start the script. Run the bot_init function.

while is_started do -- Start a loop while the bot should be running.

	local res = getUpdates(last_update+1) -- Get the latest updates!
	if res then
		for i,v in ipairs(res.result) do -- Go through every new message.
			last_update = v.update_id
			if v.message then
				on_msg_receive(v.message)
			elseif v.inline_query then
				inline_msg_receive (v.inline_query)
			end
		end
	else
		print("!!!ERRO!!!: BOT")
	end

	if last_cron < os.time() - 5 then -- Run cron jobs if the time has come.
		for i,v in ipairs(plugins) do
			if v.cron then -- Call each plugin's cron function, if it has one.
				local res, err = pcall(function() v.cron() end)
				if not res then
					handle_exception(err, 'CRON: ' .. i)
				end
			end
		end
		last_cron = os.time() -- And finally, update the variable.
	end

end

print('Halted.')
