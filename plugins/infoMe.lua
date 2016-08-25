-- Thanks to @@imandaneshi the idea
-- IF '-' sick
local command = 'me [site] [$username*]'
local doc = [[```
/me
$doc_me*

/me [site] [$username*]
$doc_me_set*

Site: Facebook, Twitter, Instagram, Youtube, Spotify, LastFM, Github, BitBucket, Steam.
```]]

local action = function(msg)
	infoMe = load_data('infoMe.json')
	local input = msg.text:input()

	if not input then
		nicks = load_data('nicknames.json')
		local name_user = msg.from.first_name
		if nicks[msg.from.id_str] then
			name_user = nicks[msg.from.id_str]
		end

		local message = name_user or ''
		if infoMe['FACEBOOK'..msg.from.id_str] then
			message = message .. '\n*Facebook:* ' .. markdown_url(get_word(infoMe['FACEBOOK'..msg.from.id_str], 2), get_word(infoMe['FACEBOOK'..msg.from.id_str], 1))
		end
		if infoMe['TWITTER'..msg.from.id_str] then
			message = message .. '\n*Twitter:* ' .. markdown_url(get_word(infoMe['TWITTER'..msg.from.id_str], 2), get_word(infoMe['TWITTER'..msg.from.id_str], 1))
		end
		if infoMe['INSTAGRAM'..msg.from.id_str] then
			message = message .. '\n*Instagram:* ' .. markdown_url(get_word(infoMe['INSTAGRAM'..msg.from.id_str], 2), get_word(infoMe['INSTAGRAM'..msg.from.id_str], 1))
		end
		if infoMe['YOUTUBE'..msg.from.id_str] then
			message = message .. '\n*Youtube:* ' .. markdown_url(get_word(infoMe['YOUTUBE'..msg.from.id_str], 2), get_word(infoMe['YOUTUBE'..msg.from.id_str], 1))
		end
		if infoMe['SPOTIFY'..msg.from.id_str] then
			message = message .. '\n*Spotify:* ' .. markdown_url(get_word(infoMe['SPOTIFY'..msg.from.id_str], 2), get_word(infoMe['SPOTIFY'..msg.from.id_str], 1))
		end
		if infoMe['LASTFM'..msg.from.id_str] then
			message = message .. '\n*LastFM:* ' .. markdown_url(get_word(infoMe['LASTFM'..msg.from.id_str], 2), get_word(infoMe['LASTFM'..msg.from.id_str], 1))
		end
		if infoMe['GITHUB'..msg.from.id_str] then
			message = message .. '\n*GitHub:* ' .. markdown_url(get_word(infoMe['GITHUB'..msg.from.id_str], 2), get_word(infoMe['GITHUB'..msg.from.id_str], 1))
		end
		if infoMe['BITBUCKET'..msg.from.id_str] then
			message = message .. '\n*BitBucket:* ' .. markdown_url(get_word(infoMe['BITBUCKET'..msg.from.id_str], 2), get_word(infoMe['BITBUCKET'..msg.from.id_str], 1))
		end
		if infoMe['STEAM'..msg.from.id_str] then
			message = message .. '\n*Steam:* ' .. markdown_url(get_word(infoMe['STEAM'..msg.from.id_str], 2), get_word(infoMe['STEAM'..msg.from.id_str], 1))
		end

		if redis:get('RANK:'..msg.from.id_str) then
			total = redis:get('RANK:'..msg.from.id_str)
		end

		message = message .. '\n*$total*:* ' .. (total or '1') .. 'MSGs'
		sendMessage(msg.chat.id, sendLang(message, lang), true, msg.message_id, true)
		return true
	end

	if string.len(input) > 80 then
		sendReply(msg, 'MAX > 80')
		return true
	end

	local info = get_word(input, 1):upper()
	local id = get_word(input, 2)
	local user = msg.from.id_str
	local bd = info..msg.from.id_str

	if info == 'FACEBOOK' then
		infoMe[bd] = 'https://www.facebook.com/'..id .. ' '..id
		sendMessage(msg.chat.id, '`OK`', true, msg.message_id, true)
	elseif info == 'INSTAGRAM' then
		infoMe[bd] = 'https://www.instagram.com/'..id .. ' '..id
		sendMessage(msg.chat.id, '`OK`', true, msg.message_id, true)
	elseif info == 'TWITTER' then
		infoMe[bd] = 'https://twitter.com/'..id .. ' '..id
		sendMessage(msg.chat.id, '`OK`', true, msg.message_id, true)
	elseif info == 'LASTFM' then
		infoMe[bd] = 'www.last.fm/user/'..id .. ' '..id
		sendMessage(msg.chat.id, '`OK`', true, msg.message_id, true)
	elseif info == 'SPOTIFY' then
		infoMe[bd] = 'https://play.spotify.com/user/'..id .. ' '..id
		sendMessage(msg.chat.id, '`OK`', true, msg.message_id, true)
	elseif info == 'GITHUB' then
		infoMe[bd] = 'https://github.com/'..id .. ' '..id
		sendMessage(msg.chat.id, '`OK`', true, msg.message_id, true)
	elseif info == 'BITBUCKET' then
		infoMe[bd] = 'https://bitbucket.org/'..id .. ' '..id
		sendMessage(msg.chat.id, '`OK`', true, msg.message_id, true)
	elseif info == 'YOUTUBE' then
		infoMe[bd] = 'https://www.youtube.com/user/'..id .. ' '..id
		sendMessage(msg.chat.id, '`OK`', true, msg.message_id, true)
	elseif info == 'STEAM' then
		infoMe[bd] = 'http://steamcommunity.com/id/'..id .. ' '..id
		sendMessage(msg.chat.id, '`OK`', true, msg.message_id, true)
	else
		sendMessage(msg.chat.id, sendLang(doc, lang))
		return true
	end

	save_data('infoMe.json', infoMe)
	return true

end

return {
	command = command,
	doc = doc,
	action = action,
	triggers = {
		'^/me[@'..bot.username..']*'
	}
}
