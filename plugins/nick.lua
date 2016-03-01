local command = 'nick <$nickname*>'
local doc = [[```
/nick <$nickname*>
$doc_nick*
```]]

local triggers = {
	'^/nick[@'..bot.username..']*'
}

local action = function(msg)

	local input = msg.text:input()
	if not input then
		sendMessage(msg.chat.id, sendLang(doc, lang), true, msg.message_id, true)
		return true
	end

	if string.len(input) > 32 then
		sendReply(msg, sendLang('$limit_32*', lang))
		return true
	end

	nicks = load_data('nicknames.json')

	if input == '-' then
		nicks[msg.from.id_str] = nil
		sendReply(msg, sendLang('$deleted*', lang))
	else
		nicks[msg.from.id_str] = input
		sendReply(msg, sendLang('$add_nick* ' .. input .. '.', lang))
	end

	save_data('nicknames.json', nicks)
	return true

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}
