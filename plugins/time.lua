local command = 'time <$location*>'
local doc = [[*Utilize os seguite comandos citados abaixo:*
*________________________*
`/horas [`*local*`]` - Para o bot informar que horas são em sua cidade ou local mencionado.]]

local action = function(msg)
	local input = msg.text:input()
	if not input then
		if msg.reply_to_message and msg.reply_to_message.text then
			input = msg.reply_to_message.text
		else
			sendMessage(msg.chat.id, [[
*Utilize os seguite comandos citados abaixo:*
*________________________*
`/horas [`*local*`]` - Para o bot informar que horas são em sua cidade ou local mencionado.
]], true, msg.message_id, true)
			return
		end
	end

	local coords = get_coords(input)
	if type(coords) == 'string' then
		api.sendReply(msg, coords)
		return
	end

	local url = 'https://maps.googleapis.com/maps/api/timezone/json?location=' .. coords.lat ..','.. coords.lon .. '&timestamp='..os.time()

	local jstr, res = HTTPS.request(url)
	if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end

	local jdat = JSON.decode(jstr)
	local timestamp = os.time(os.date("!*t"))
    local localTime = timestamp + jdat.rawOffset + jdat.dstOffset
	sendReply(msg, os.date('Pelo meu relogio em '..input..' agora são: %H:%M:%S %p', localTime))

end

return {
	action = action,
	doc = doc,
	command = command,
	triggers = {
	'^/time[@'..bot.username..']*',
	'^/data[@'..bot.username..']*',
	'^/hora[@'..bot.username..']*'
	}
}

