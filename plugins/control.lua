local action = function(msg)
  if not config.moderation.admins[msg.from.id_str] then
    return
  end

  if msg.text:match('^/reload') then
    bot_init()
    sendReply(msg, 'Bot reloaded!')

  elseif msg.text:match('^/ccbot') then
    sendClean()
    sendMessage(config.debug.chat, '*Clean Lag*', true, nil, true)

  elseif msg.text:match('^/halt') then
    is_started = false
    sendReply(msg, 'Stopping bot!')

  elseif msg.text:match('^/send') then
    local input = msg.text:input()
    local to = get_word(input, 1)
    local text = input:gsub(to, '')
    sendMessage(to, text, true, nil, true)

  elseif msg.text:match('^/lua') then
    local input = msg.text:input()
    if not input then
      sendReply(msg, 'Please enter a string to load.')
      return
    end

    local output = loadstring(input)()
    if output == nil then
      output = 'Done!'
    elseif type(output) == 'table' then
      output = 'Done! Table returned.'
    else
      output = '```\n' .. tostring(output) .. '\n```'
    end
    sendMessage(msg.chat.id, output, true, msg.message_id, true)

  elseif msg.text:match('^/sh') then
    local input = msg.text:input()
    if not input then
      sendReply(msg, 'Please specify a command to run.')
      return
    end

    input = input:gsub('—', '--')

    local output = io.popen(input):read('*all')
    if output:len() == 0 then
      output = 'Done!'
    else
      output = '```\n' .. output .. '\n```'
    end
    sendMessage(msg.chat.id, output, true, msg.message_id, true)

  end
end

return {
  action = action,
  triggers = {
    '^/reload[@'..bot.username..']*',
    '^/ccbot[@'..bot.username..']*',
    '^/halt[@'..bot.username..']*',
    '^/send[@'..bot.username..']*',
    '^/lua[@'..bot.username..']*',
    '^/sh[@'..bot.username..']*'
  }
}
