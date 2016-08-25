local command = 'sos <msg>'
local doc = [[```
/sos <msg>
$doc_sos*
```]]

local action = function(msg)
	local input = msg.text:input()
	if not input then
		sendMessage(msg.chat.id, sendLang(doc, lang), true, msg.message_id, true)
		return
	end

	local by = 'DATE: '..os.date('%F;%T', msg.date)..'\n- '..(msg.chat.title or '')
	by = by .. '\n- ' ..(msg.from.first_name or '')..(msg.from.last_name or '')
	by = by .. '\n- @' ..(msg.from.username or '')..'>>'..msg.from.id
	local sos_msg = '```💭 ' .. input .. '```'

	local output = by..'\n\n'..sos_msg
	sendMessage(msg.chat.id, 'OK', true, msg.message_id, true)
	sendMessage(config.moderation.admin_group, output, true, nil, true)

end

return {
	command = command,
	doc = doc,
	action = action,
	triggers = {
		'^/sos[@'..bot.username..']*'
	}
}
