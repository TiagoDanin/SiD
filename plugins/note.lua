local command = 'note [$text*]'
local file = 'note.json'
local note = load_data(file)
local doc = [[
/note - $VTxt*
/note [$text*] - $STxt*

]]
local action = function(msg)
	local input = msg.text:input()
	if not input then
		if msg.reply_to_message and msg.reply_to_message.text then
			input = msg.reply_to_message.text
		elseif msg.from.id == msg.chat.id then
			if note[msg.from.id_str] then
				sendReply(msg, note[msg.from.id_str])
				return true
			else
				sendReply(msg, sendLang(doc, lang))
				return true
			end
		else
			sendReply(msg, sendLang(doc, lang))
			return true
		end
	end

	if string.len(input) > 2250 then
		sendReply(msg, 'MAX > 2250')
		return true
	end

	if input == '-' then
		note[msg.from.id_str] = nil
		sendReply(msg, sendLang('$deleted*', lang))
	else
		note[msg.from.id_str] = input
		sendReply(msg, sendLang('$add*', lang))
	end

	save_data(file, note)
	return true

end

return {
	command = command,
	doc = doc,
	action = action,
	triggers = {
		'^/note[@'..bot.username..']*'
	}
}
