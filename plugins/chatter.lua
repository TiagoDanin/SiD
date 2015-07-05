 -- shout-out to @luksi_reiku for showing me this site

local PLUGIN = {}

PLUGIN.triggers = {
	'^@' .. bot.username .. ', ',
	'^' .. bot.first_name .. ', '
}

function PLUGIN.action(msg)

	local input = get_input(msg.text)

	local url = 'http://www.simsimi.com/requestChat?lc=en&ft=1.0&req=' .. URL.escape(input)

	local jstr, res = HTTP.request(url)

	if res ~= 200 then
		return send_message(msg.chat.id, "I don't feel like talking right now.")
	end

	local jdat = JSON.decode(jstr)

	if string.match(jdat.res, '^I HAVE NO RESPONSE.') then
		jdat.res = "I don't know what to say to that."
	end

	-- Let's clean up the response a little. Capitalization & punctuation.
	local message = jdat.res:gsub('simsimi', 'clive')
	local message = message:gsub("^%l", string.upper)
	if not string.match(message, '%p$') then
		message = message .. '.'
	end

	send_message(msg.chat.id, jdat.res)

end

return PLUGIN
