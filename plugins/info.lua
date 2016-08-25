local command = 'info'
local doc = '`$doc_info*`'
local action = function(msg)
	-- Filthy hack, but here is where we'll stop forwarded messages from hitting
	-- other plugins.
	if msg.forward_from then return end

	local message = '$info_text* ' .. config.version .. '\n👤 By @TiagoDanin :)'
	message = message .. '\n\n Lang: \n🇱🇷-EN (`/lang en`) '
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
		sendMessage(msg.chat.id, "Based on Otouto v3.2 by topkecleon.\nOtouto is licensed under the AGLPv3.\nhttp://otou.to", true)
		return
	elseif string.match(msg.text_lower, '^/license[@'..bot.username..']*') then
		sendMessage(msg.chat.id, "Based on Otouto v3.2 by topkecleon.\nOtouto is licensed under the AGLPv3.\nghttp://otou.to", true)
		return
	end

	return true

end

return {
	command = command,
	doc = doc,
	action = action,
	triggers = {
		''
	}
}
