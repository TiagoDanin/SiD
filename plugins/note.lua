local command = 'note [$text*]'
local doc = [[
/note - $VTxt*
/note [$text*] - $STxt*

]]

local triggers = {
	'^/note[@'..bot.username..']*'
}

local action = function(msg)
    note = load_data('note.json')
    
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

	save_data('note.json', note)
	return true

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}
