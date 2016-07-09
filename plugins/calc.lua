local command = 'calc <$expression*>'
local doc = [[```
/calc <$expression*>
$doc_calc*
```]]

local triggers = {
	'^/calc[@'..bot.username..']*'
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
	elseif msg.reply_to_message and msg.reply_to_message.text then
		input = msg.reply_to_message.text .. input
	end

	local url = 'https://api.mathjs.org/v1/?expr=' .. URL.escape(input)

	local output = HTTPS.request(url)
	if not output then
		sendReply(msg, config.errors.connection)
		return
	end

	output = '`' .. output .. '`'

	sendMessage(msg.chat.id, output, true, msg.message_id, true)

end

return {
	action = action,
	triggers = triggers,
	command = command,
	doc = doc
}
