local command = 'echo <$text*>'
local doc = [[```
/echo <$text*>
$doc_echo*
```]]

local action = function(msg)

	local input = msg.text:input()
	if input then
		sendMessage(msg.chat.id, latcyr(input:gsub('^!+','¡'):gsub([[^/+]], [[\]]))) -- Thanks Wesley
	else
		sendMessage(msg.chat.id, sendLang(doc, lang), true, msg.message_id, true)
	end

end

return {
	command = command,
	doc = doc,
	action = action,
	triggers = {
		'^/echo[@'..bot.username..']*',
		--'^/e[@'..bot.username..']*'
	}
}
