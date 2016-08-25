local command = 'who'
local doc = [[```
$doc_who*
$alias*: /who
```]]

local action = function(msg)
	if msg.reply_to_message then
		msg = msg.reply_to_message
	end

	local from_name = msg.from.first_name
	if msg.from.last_name then
		from_name = from_name .. ' ' .. msg.from.last_name
	end
	if msg.from.username then
		from_name = '@' .. msg.from.username .. ' - ' .. from_name
	end
	from_name = from_name .. ' (' .. msg.from.id .. ')'

	local to_name
	if msg.chat.title then
		to_name = msg.chat.title .. ' (' .. math.abs(msg.chat.id) .. ').'
	else
		to_name = '@' .. bot.username .. ' - ' .. bot.first_name .. ' (' .. bot.id .. ').'
	end

	local message = '👤 ' .. from_name .. ';\n👥 ' .. to_name

	local nicks = load_data('nicknames.json')
	if nicks[msg.from.id_str] then
		message = message .. '\n✏️ ' .. nicks[msg.from.id_str] .. '.'
	end
	if redis:get('RANK:'..msg.from.id) then
		message = message .. '\n💭 ' .. redis:get('RANK:'..msg.from.id) .. 'MSGs'
	end
	sendReply(msg, message)

end

return {
	command = command,
	doc = doc,
	action = action,
	triggers = {
		'^/whoami[@'..bot.username..']*$',
		'^/who[@'..bot.username..']*$'
	},
}
