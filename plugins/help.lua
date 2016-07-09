local help_text = '📌*$HAC*:*'

local n = 0
for i,v in ipairs(plugins) do
	if v.command then
		n = n + 1
		help_text = help_text .. '\n*'..n..'.* /' .. v.command:gsub('%[', '\\[')
	end
end

help_text = help_text .. '\n*'..(n + 1)..'.* /command <$set-command*> <$text*>'
help_text = help_text .. '\n\n*$total*:* ' .. n + 1
help_text = help_text .. [[

*$details*:* `/$help* <$command*>`
*$arguments*:* `<$required*> [$optional*]`
]]

local triggers = {
	'^/help[@'..bot.username..']*',
	'^/h[@'..bot.username..']*$',
	'^/ajuda[@'..bot.username..']*'
}

local action = function(msg)

	local input = msg.text_lower:input()

	-- Attempts to send the help message via PM.
	-- If msg is from a group, it tells the group whether the PM was successful.
	if not input then
		local res = sendMessage(msg.from.id, sendLang(help_text, lang), true, nil, true)
		if not res then
			sendReply(msg, sendLang('$pmp*', lang))
		elseif msg.chat.type ~= 'private' then
			sendReply(msg, sendLang('$pmh*', lang))
		end
		return
	end

	if input:match('^[%d]*%d$') then
		local n_cmd = ''
		local convert = math.abs(input)

		for i,v in ipairs(plugins) do
			if v.command then
				n_cmd = n_cmd .. get_word(v.command, 1) .. ' '
			end
		end
		input = get_word(n_cmd, convert)
		if convert > n then
			input = n
		end
	end

	for i,v in ipairs(plugins) do
		if v.command and get_word(v.command, 1) == input and v.doc then
			local output = '*$H_for** _' .. get_word(v.command, 1) .. '_ *:*\n' .. v.doc
			sendMessage(msg.chat.id, sendLang(output, lang), true, nil, true)
			return
		end
	end

	sendReply(msg, sendLang('$H404*', lang))

end

return {
	action = action,
	triggers = triggers
}
