local command = 'preview <link>'
local doc = [[```
/preview <link>
$doc_preview*
```]]
local action = function(msg)
	local input = msg.text:input()
	if not input then
		sendMessage(msg.chat.id, sendLang(doc, lang), true, nil, true)
		return
	end

	input = get_word(input, 1)
	if not input:match('^https?://.+') then
		input = 'http://' .. input
	end

	local res = HTTP.request(input)
	if not res then
		sendReply(msg, sendLang('$linK_valid*', lang))
		return
	end

	if res:len() == 0 then
		sendReply(msg, 'Sorry, the link you provided is not letting us make a preview.')
		return
	end
	-- Invisible zero-width, non-joiner.
	local output = '[​](' .. input .. ')'
	sendMessage(msg.chat.id, output, false, nil, true)

end

return {
	command = command,
	doc = doc,
	action = action,
	triggers = {
		'^/preview[@'..bot.username..']*',
		'^/url[@'..bot.username..']*',
		'^/hideurl[@'..bot.username..']*'
	}
}
