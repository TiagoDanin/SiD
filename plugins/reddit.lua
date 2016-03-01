local command = 'reddit [r/subreddit | $query*]'
local doc = [[```
/reddit [r/subreddit | $query*]
$doc_reddit*
$alias*: /r, /r/[subreddit]
```]]

local triggers = {
	'^/reddit[@'..bot.username..']*',
	'^/r@'..bot.username..'$',
	'^/r$',
	'^/r[@'..bot.username..']* ',
	'^/r/'
}

local action = function(msg)
	print(bot.username)

	msg.text_lower = msg.text_lower:gsub('/r/', '/r r/')
	local input = msg.text_lower:input()
	local url

	local limit = 4
	if msg.chat.id == msg.from.id then
		limit = 8
	end

	local source
	if input then
		if input:match('^r/.') then
			url = 'http://www.reddit.com/' .. URL.escape(get_word(input, 1)) .. '/.json?limit=' .. limit
			source = '*/r/' .. input:match('^r/(.+)') .. '*\n'
		else
			url = 'http://www.reddit.com/search.json?q=' .. URL.escape(input) .. '&limit=' .. limit
			source = '*reddit $results** _' .. input .. '_ *:*\n'
		end
	else
		url = 'http://www.reddit.com/.json?limit=' .. limit
		source = '*/r/all*\n'
	end

	local jstr, res = HTTP.request(url)
	if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end

	local jdat = JSON.decode(jstr)
	if #jdat.data.children == 0 then
		sendReply(msg, config.errors.results)
		return
	end

	local output = ''
	for i,v in ipairs(jdat.data.children) do
		local title = v.data.title:gsub('%[.+%]', ''):gsub('&amp;', '&')
		if title:len() > 48 then
			title = title:sub(1,45) .. '...'
		end
		if v.data.over_18 then
			v.data.is_self = true
		end
		local short_url = 'redd.it/' .. v.data.id
		output = output .. '• [' .. title .. '](' .. short_url .. ')\n'
		--if not v.data.is_self then
			--output = output .. v.data.url:gsub('_', '\\_') .. '\n'
		--end
	end

	output = source .. output

	sendMessage(msg.chat.id, sendLang(output, lang), true, nil, true)

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}
