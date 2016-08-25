-- Actually the simplest plugin ever!
local action = function(msg)
	local input = msg.text:input()
	if input == 'redis' then
		if not config.moderation.admins[msg.from.id_str] then
			return
		end
		if redis:ping() then
			sendMessage(msg.chat.id, "REDIS:OK")
		else
			sendMessage(msg.chat.id, "REDIS:OFF")
		end
	elseif input == 'server' then
		if not config.moderation.admins[msg.from.id_str] then
			return
		end
		sendMessage(msg.chat.id, 'MSG-Date: '.. os.date('%F-:-%T', msg.date) .. '\nServer-Date: ' .. io.popen('date +%F-:-%T'):read('*all'))
	elseif input == 'pong' then
		sendMessage(msg.chat.id, '🎾P🎾I🎾N🎾G🎾')
	else
		sendMessage(msg.chat.id, 'Pong! 🎾')
	end

end

return {
	action = action,
	triggers = {
		'^/ping[@'..bot.username..']*'
	}
}
