-- Trash Google
-- Use Bing or DuckDuckGo <3
local command = 'google <$query*>'
local doc = [[```
/google <$query*>
$doc_google*
$alias*: /g
```]]

local triggers = {
	'^/g[@'..bot.username..']*$',
	'^/g[@'..bot.username..']* ',
	'^/google[@'..bot.username..']*',
	'^/gnsfw[@'..bot.username..']*'
}

local action = function(msg)

	local input = msg.text:input()
	if not input then
		if msg.reply_to_message and msg.reply_to_message.text then
			input = msg.reply_to_message.text
		else
			sendMessage(msg.chat.id, sendLang(doc, lang), true, msg.message_id, true)
			return
		end
	end

	local url = 'https://ajax.googleapis.com/ajax/services/search/web?v=1.0'

	if msg.from.id == msg.chat.id then
		url = url .. '&rsz=8'
	else
		url = url .. '&rsz=4'
	end

	if not string.match(msg.text, '^/g[oogle]*nsfw') then
		url = url .. '&safe=active'
	end

	url = url .. '&q=' .. URL.escape(input)

	local jstr, res = HTTPS.request(url)
	if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end

	local jdat = JSON.decode(jstr)
	if not jdat.responseData then
		sendReply(msg, config.errors.connection)
		return
	end
	if not jdat.responseData.results[1] then
		sendReply(msg, config.errors.results)
		return
	end

	local output = '*Google $results** _' .. input .. '_ *:*\n'
	for i,v in ipairs(jdat.responseData.results) do
		local title = HTML.decode(jdat.responseData.results[i].titleNoFormatting:gsub('%[.+%]', ''):gsub('&amp;', '&'))
		if title:len() > 45 then
			title = title:sub(1, 42) .. '...'
		end
		local url = jdat.responseData.results[i].unescapedUrl
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
