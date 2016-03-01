-- Spotify Plugin for bot based on otouto
-- ByTiagoDanin - Telegram.me/tiagodanin

local command = 'spotify [$type*] <$query*>'
local doc = [[```
/spotify <$query*>
$doc_spotify*
$alias*: /s, /spo
```]]

local triggers = {
    '^/spotify[@'..bot.username..']*',
    '^/spo[@'..bot.username..']*',
    --'^/s[@'..bot.username..']*'
    '^spotify:track:',
    '^https://open.spotify.com/track/'
}

local action = function(msg)

	local input = msg.text:input()

	if string.match(msg.text:lower(), '^spotify:track:') or string.match(msg.text:lower(), '^https://open.spotify.com/track/') then
		
		input = msg.text:gsub('spotify:track:', '')
		input = input:gsub('https://open.spotify.com/track/', '')
		if input == '' then
			return
		end	
		input = get_word(input, 1)
		if input == '' then
			return
		end
		
		local url = 'https://api.spotify.com/v1/tracks/' .. URL.escape(input)
		local jstr, res = HTTPS.request(url)
		if res ~= 200 then
			sendReply(msg, config.errors.connection)
			return
		end
		local spotify = JSON.decode(jstr)
		
		local duration = math.floor(((0 + spotify.duration_ms)*10^-3)/60) .. 'Min'
		local text = '[​]('..spotify.album.images[2].url..')'
		text = text ..'*Artist:* ['..spotify.artists[1].name..']('..spotify.artists[1].external_urls.spotify..') \n'
		text = text ..'*Music:* ['..spotify.name..']('..spotify.external_urls.spotify..') `('..duration..')` \n'
		text = text ..'*Album:* ['..spotify.album.name..']('..spotify.album.external_urls.spotify..') `('..spotify.album.album_type..')`'
		
		sendMessage(msg.chat.id, text, false, nil, true)
		local mp3 = download_file(spotify.preview_url, 'SPOTIFY'..spotify.id..'.mp3')
		sendAudio(msg.chat.id, mp3, nil, nil, nil, spotify.name)
		
		return	
	end
	
	if not input then
		if msg.reply_to_message and msg.reply_to_message.text then
			input = msg.reply_to_message.text
		else
			sendMessage(msg.chat.id, sendLang(doc, lang), true, msg.message_id, true)
			return
		end
	end
	
	
	local type = ''
	if get_word(input, 1) == 'tracks' then
		type = 'track'
		input = input:gsub(get_word(input, 1), '')
	elseif get_word(input, 1) == 'albums' then
		type = 'album'
		input = input:gsub(get_word(input, 1), '')
	elseif get_word(input, 1) == 'artists' then
		type = 'artist'
		input = input:gsub(get_word(input, 1), '')
	elseif get_word(input, 1) == 'playlists' then
		type = 'playlist'
		input = input:gsub(get_word(input, 1), '')
	else
		type = 'track' --Default
	end
	
    local url = 'https://api.spotify.com/v1/search?q='..(URL.escape(input) or '')..'&type='..type
    
    if msg.from.id == msg.chat.id then
		url = url .. '&limit=8'
	else
		url = url .. '&limit=4'
	end
    
    local jstr, res = HTTPS.request(url)
    if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end
	
	local spotify = JSON.decode(jstr)
	type = type..'s' -- Optimizes :)
	
	if spotify[tostring(type)].total == 0 then
	    sendReply(msg, config.errors.results)
	    return
	end
    
    local output = '*Spotify $results**_' .. input .. '('..type..')' .. '_ *:*\n'
    for i,v in ipairs(spotify[tostring(type)].items) do
    	
    	local more = ''
    	if type == 'tracks' then
    		more = ' - '..spotify.tracks.items[i].album.name
    	elseif type == 'albums' then
    		more = ' - '..spotify.albums.items[i].album_type
    	elseif type == 'playlists' then
    		more = ' - '..spotify.playlists.items[i].owner.id
    	end
    	
		local title = (spotify[tostring(type)].items[i].name .. more):gsub('%[.+%]', ''):gsub('&amp;', '&')
		if title:len() > 45 then
			title = title:sub(1, 42) .. '...'
		end
		local url = spotify[tostring(type)].items[i].external_urls.spotify
		if url:find('%)') then
			output = output .. '• ' .. title .. '\n' .. url:gsub('_', '\\_') .. '\n'
		else
			output = output .. '• [' .. title .. '](' .. url .. ')\n'
		end
	end
    
    sendMessage(msg.chat.id, sendLang(output, lang), true, nil, true)

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}
