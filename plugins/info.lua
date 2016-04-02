local command = 'info'
local doc = '`$doc_info*`'

local triggers = {
	''
}

local action = function(msg)

	-- Filthy hack, but here is where we'll stop forwarded messages from hitting
	-- other plugins.
	if msg.forward_from then return end

	local message = '$info_text* ' .. config.version .. '\n👤 By @TiagoDanin \n💭 $news* @SiDBot :)'
	message = message .. '\n\n Lang: \n🇧🇷-PT (`/lang pt`) \n🇱🇷-EN (`/lang en`) '
	if msg.new_chat_participant and msg.new_chat_participant.id == bot.id then
		sendMessage(msg.chat.id, sendLang(message, lang), true, nil, true)
		return
	elseif msg.new_chat_participant then
		local welcome = '$welcome* ' .. latcyr(msg.new_chat_participant.first_name)
		sendMessage(msg.chat.id, sendLang(welcome, lang), true)
		return
	elseif string.match(msg.text_lower, '^/about[@'..bot.username..']*') or string.match(msg.text_lower, '^/sobre[@'..bot.username..']*') then
		sendMessage(msg.chat.id, sendLang(message, lang), true, nil, true)
		return
	elseif string.match(msg.text_lower, '^/info[@'..bot.username..']*') or string.match(msg.text_lower, '^/start[@'..bot.username..']*') then
		sendMessage(msg.chat.id, sendLang(message, lang), true, nil, true)
		return
	elseif string.match(msg.text_lower, '^/more[@'..bot.username..']*') or string.match(msg.text_lower, '^/mais[@'..bot.username..']*') then
		sendMessage(msg.chat.id, "Based on otouto v3.2 by topkecleon.\notouto v3 is licensed under the GPLv2.\ngithub.com/topkecleon/otouto", true)
		return
	elseif string.match(msg.text_lower, '^/license[@'..bot.username..']*') then
		sendMessage(msg.chat.id, "Based on otouto v3.2 by topkecleon.\notouto v3 is licensed under the GPLv2.\ngithub.com/topkecleon/otouto", true)
		return
	end

	return true

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command
}
