-- utilities.lua
-- Functions shared among plugins.

function get_word(s, i) -- get the indexed word in a string

	local t = {}
	for w in s:gmatch('%g+') do
		table.insert(t, w)
	end

	return t[i] or false

end

function markdown_url(title, url) -- Filter Markdown
	local markdown = '['.. HTML.decode(title:gsub('%[.+%]', ''):gsub('%(.+%)', ''):gsub('&.-;', '')) ..']('.. url .. ')'
	return markdown
end

function inline_block(title, text) -- Inline Block
	local ran = math.random(1 ,100)
	local inline = '{"type":"article", "id":"'.. ran ..'", "title":"'.. title ..'", "message_text": "'.. text ..'", "parse_mode":"Markdown"}'
	return inline
end

function sendLang(text, lang)
	lg = dofile("lang/lang.lua")
	local l = string.gsub(text, "$.-*", lg[tostring(lang)])
	return l
end

function string:input() -- Returns the string after the first space.
	if not self:find(' ') then
		return false
	end
	return self:sub(self:find(' ')+1)
end

 -- I swear, I copied this from PIL, not yago! :)
function string:trim() -- Trims whitespace from a string.
	local s = self:gsub('^%s*(.-)%s*$', '%1')
	return s
end

local lc_list = {
-- Latin = 'Cyrillic'
	['A'] = 'А',
	['B'] = 'В',
	['C'] = 'С',
	['E'] = 'Е',
	['I'] = 'І',
	['J'] = 'Ј',
	['K'] = 'К',
	['M'] = 'М',
	['H'] = 'Н',
	['O'] = 'О',
	['P'] = 'Р',
	['S'] = 'Ѕ',
	['T'] = 'Т',
	['X'] = 'Х',
	['Y'] = 'Ү',
	['a'] = 'а',
	['c'] = 'с',
	['e'] = 'е',
	['i'] = 'і',
	['j'] = 'ј',
	['o'] = 'о',
	['s'] = 'ѕ',
	['x'] = 'х',
	['y'] = 'у',
	['!'] = 'ǃ'
}

function latcyr(str) -- Replaces letters with corresponding Cyrillic characters.
	for k,v in pairs(lc_list) do
		str = string.gsub(str, k, v)
	end
	return str
end

load_data = function(filename)

	local f = io.open('data/'..filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)

	return data

end

 -- Saves a table to a JSON file.
save_data = function(filename, data, mode)

	local s = JSON.encode(data)
	if not mode then
		mode = 'w'
	end
	local f = io.open('data/'..filename, mode)
	f:write(s)
	f:close()

end

 -- Gets coordinates for a location. Used by gMaps.lua, time.lua, weather.lua.
get_coords = function(input)

	local url = 'http://maps.googleapis.com/maps/api/geocode/json?address=' .. URL.escape(input)

	local jstr, res = HTTP.request(url)
	if res ~= 200 then
		return config.errors.connection
	end

	local jdat = JSON.decode(jstr)
	if jdat.status == 'ZERO_RESULTS' then
		return config.errors.results
	end

	return {
		lat = jdat.results[1].geometry.location.lat,
		lon = jdat.results[1].geometry.location.lng
	}

end

 -- Get the number of values in a key/value table.
table_size = function(tab)

	local i = 0
	for k,v in pairs(tab) do
		i = i + 1
	end
	return i

end

resolve_username = function(target)
 -- If $target is a known username, returns associated ID.
 -- If $target is an unknown username, returns nil.
 -- If $target is a number, returns that number.
 -- Otherwise, returns false.

	local input = tostring(target):lower()
	if input:match('^@') then
		local uname = input:gsub('^@', '')
		return usernames[uname]
	else
		return tonumber(target) or false
	end

end

handle_exception = function(err, message)

	if not err then err = '' end

	local output = err .. '\n' .. message .. '\n'

	if config.debug and config.debug.chat then
		sendMessage(config.debug.chat, '*[' .. os.date('%F %T', os.time()) .. ']* ' .. bot.username .. ':', true, nil, true)
		output = '```' .. output .. '```'
		sendMessage(config.debug.chat, output, true, nil, true)
	else
		print('!!!ERRO!!! ' .. os.date('%F %T', os.time()) .. ' LOG CHAT\n'..output..'\n\n')
	end

end

 -- Okay, this one I actually did copy from yagop.
 -- https://github.com/yagop/telegram-bot/blob/master/bot/utils.lua
download_file = function(url, filename)

	local respbody = {}
	local options = {
		url = url,
		sink = ltn12.sink.table(respbody),
		redirect = true
	}

	local response = nil

	if url:match('^https') then
		options.redirect = false
		response = { HTTPS.request(options) }
	else
		response = { HTTP.request(options) }
	end

	local code = response[2]
	local headers = response[3]
	local status = response[4]

	if code ~= 200 then return false end

	filename = filename or os.time()

	local file_path = 'data/'..filename

	file = io.open(file_path, 'w+')
	file:write(table.concat(respbody))
	file:close()

	return file_path
end
