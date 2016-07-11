local name_plugin = 'tv <$query*>'
local help = [[```
/tv <$query*>
$doc_tv*
```]]
local action = function(msg)

	local input = msg.text:input()
	if not input then
		if msg.reply_to_message and msg.reply_to_message.text then
			input = msg.reply_to_message.text
		else
			sendMessage(msg.chat.id, sendLang(doc, lang), true, msg.message_id, true)
			return
		end
	end

	local url = 'http://www.omdbapi.com/?t=' .. URL.escape(input)

	local jstr, res = HTTP.request(url)
	if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end

	local jdat = JSON.decode(jstr)

	if jdat.Response ~= 'True' then
		sendReply(msg, config.errors.results)
		return
	end

	local output = '*Movie Name:* 🎬 [' .. jdat.Title .. '](http://imdb.com/title/' .. jdat.imdbID .. ')'
			 ..'\n*Movie release:* `'.. jdat.Released:gsub("N/A", "Não divulgado")
			:gsub("Jan", "January")
			:gsub("Feb", "February")
			:gsub("Mar", "March")
			:gsub("Apr", "April")
			:gsub("May", "May")
			:gsub("Jun", "June")
			:gsub("Jul", "July")
			:gsub("Aug", "August")
			:gsub("Sep", "September")
			:gsub("Oct", "October")
			:gsub("Nov", "November")
			:gsub("Dec", "December") ..'`\n'
			 .. '*Evaluation:* '.. jdat.imdbVotes:gsub("N/A", "Não divulgado")..' '..jdat.imdbRating
			 :gsub("1.0", "⭐")
			:gsub("1.1", "⭐")
			:gsub("1.2", "⭐")
			:gsub("1.3", "⭐")
			:gsub("1.4", "⭐")
			:gsub("1.5", "⭐")
			:gsub("1.6", "⭐")
			:gsub("1.7", "⭐")
			:gsub("1.8", "⭐")
			:gsub("1.9", "⭐")
			:gsub("2.1", "⭐")
			:gsub("2.2", "⭐")
			:gsub("2.3", "⭐")
			:gsub("2.4", "⭐")
			:gsub("2.5", "⭐")
			:gsub("2.6", "⭐")
			:gsub("2.7", "⭐")
			:gsub("2.8", "⭐")
			:gsub("2.9", "⭐")
			:gsub("3.1", "⭐⭐")
			:gsub("3.2", "⭐⭐")
			:gsub("3.3", "⭐⭐")
			:gsub("3.4", "⭐⭐")
			:gsub("3.5", "⭐⭐")
			:gsub("3.6", "⭐⭐")
			:gsub("3.7", "⭐⭐")
			:gsub("3.8", "⭐⭐")
			:gsub("3.9", "⭐⭐")
			:gsub("4.1", "⭐⭐")
			:gsub("4.2", "⭐⭐")
			:gsub("4.3", "⭐⭐")
			:gsub("4.4", "⭐⭐")
			:gsub("4.5", "⭐⭐")
			:gsub("4.6", "⭐⭐")
			:gsub("4.7", "⭐⭐")
			:gsub("4.8", "⭐⭐")
			:gsub("4.9", "⭐⭐")
			:gsub("5.0", "⭐⭐⭐")
			:gsub("5.1", "⭐⭐⭐")
			:gsub("5.2", "⭐⭐⭐")
			:gsub("5.3", "⭐⭐⭐")
			:gsub("5.4", "⭐⭐⭐")
			:gsub("5.5", "⭐⭐⭐")
			:gsub("5.6", "⭐⭐⭐")
			:gsub("5.7", "⭐⭐⭐")
			:gsub("5.8", "⭐⭐⭐")
			:gsub("5.9", "⭐⭐⭐")
			:gsub("6.0", "⭐⭐⭐")
			:gsub("6.1", "⭐⭐⭐")
			:gsub("6.2", "⭐⭐⭐")
			:gsub("6.3", "⭐⭐⭐")
			:gsub("6.4", "⭐⭐⭐")
			:gsub("6.5", "⭐⭐⭐")
			:gsub("6.6", "⭐⭐⭐")
			:gsub("6.7", "⭐⭐⭐")
			:gsub("6.8", "⭐⭐⭐")
			:gsub("6.9", "⭐⭐⭐")
			:gsub("7.0", "⭐⭐⭐⭐")
			:gsub("7.1", "⭐⭐⭐⭐")
			:gsub("7.2", "⭐⭐⭐⭐")
			:gsub("7.3", "⭐⭐⭐⭐")
			:gsub("7.4", "⭐⭐⭐⭐")
			:gsub("7.5", "⭐⭐⭐⭐")
			:gsub("7.6", "⭐⭐⭐⭐")
			:gsub("7.7", "⭐⭐⭐⭐")
			:gsub("7.8", "⭐⭐⭐⭐")
			:gsub("7.9", "⭐⭐⭐⭐")
			:gsub("8.0", "⭐⭐⭐⭐")
			:gsub("8.1", "⭐⭐⭐⭐")
			:gsub("8.2", "⭐⭐⭐⭐")
			:gsub("8.3", "⭐⭐⭐⭐")
			:gsub("8.4", "⭐⭐⭐⭐")
			:gsub("8.5", "⭐⭐⭐⭐")
			:gsub("8.6", "⭐⭐⭐⭐")
			:gsub("8.7", "⭐⭐⭐⭐")
			:gsub("8.8", "⭐⭐⭐⭐")
			:gsub("8.9", "⭐⭐⭐⭐")
			:gsub("9.0", "⭐⭐⭐⭐⭐")
			:gsub("9.1", "⭐⭐⭐⭐⭐")
			:gsub("9.2", "⭐⭐⭐⭐⭐")
			:gsub("9.3", "⭐⭐⭐⭐⭐")
			:gsub("9.4", "⭐⭐⭐⭐⭐")
			:gsub("9.5", "⭐⭐⭐⭐⭐")
			:gsub("9.6", "⭐⭐⭐⭐⭐")
			:gsub("9.7", "⭐⭐⭐⭐⭐")
			:gsub("9.9", "⭐⭐⭐⭐⭐")
			:gsub("10.0", "⭐⭐⭐⭐⭐")
			:gsub("10.1", "⭐⭐⭐⭐⭐")
			:gsub("10.2", "⭐⭐⭐⭐⭐")
			:gsub("10.3", "⭐⭐⭐⭐⭐")
			:gsub("10.4", "⭐⭐⭐⭐⭐")
			:gsub("10.5", "⭐⭐⭐⭐⭐")
			:gsub("10.6", "⭐⭐⭐⭐⭐")
			:gsub("10.7", "⭐⭐⭐⭐⭐")
			:gsub("10.8", "⭐⭐⭐⭐⭐")
			:gsub("10.9", "⭐⭐⭐⭐⭐")..'\n'
			 ..'*Genre:* '.. jdat.Genre:gsub("N/A", "It was not disclosed") ..'\n'
			..'*Movie language:* '..jdat.Language:gsub("N/A", "Unknown!")
			 .. '\n*________________________*\n'
			 ..'⏱ |*Duration* `'.. jdat.Runtime
			 :gsub("N/A", "Duration Unknown")..'`\n'
			 .. '👤 |*$director:* ' .. jdat.Director:gsub("N/A", "It was not disclosed") ..'\n'
			 .. '👥 | *$actor*:' .. jdat.Actors:gsub("N/A", "It was not disclosed")..'.\n'
	api.sendMessage(msg.chat.id, output, true, nil, true)

end

return {
	action = action,
	triggers = triggers,
	doc = help,
	command = name_plugin,
	triggers = {
	'^/tv[@'..bot.username..']*',
	'^/imdb[@'..bot.username..']*'
	}
}
