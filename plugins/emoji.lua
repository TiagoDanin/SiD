local command = 'emoji'
local doc = '`$doc_emoji*`'

local triggers = {
  ['( ͡° ͜ʖ ͡°)'] = '/lenny',
  ['ಠ_ಠ'] = '/look',
  ['ʘ‿ʘ'] = '/happy',
  ['¯\\_(ツ)_/¯'] = '/shrug',
  ['ಥ_ಥ'] = '/sad',
  ['༼ つ ◕_◕ ༽つ'] = '/donger',
  ['(╯°□°）╯︵ ┻━┻'] = '/flip',
  ['( ◡́.◡̀)\\(^◡^ )'] = '/friend',
  ['¯\\_( ͡° ͜ʖ ͡°)_/¯'] = '/reaction'

}

-- Generate a "help" message triggered by "/reactions".
local help = ''
for k,v in pairs(triggers) do
  help = help .. v:gsub('?', '') .. ': ' .. k .. '\n'
  v = v .. '[@'..bot.username..']*'
end
triggers[help] = '^/emoji[@'..bot.username..']*'
triggers['┈▁┈┈┈┈▁▁▁┈┈▁ ╱╱▏┈┈╱╱╱╱▏╱╱▏ \n ▇╱▏┈┈▇▇▇╱▏▇╱▏ \n ▇╱▏▁┈▇╱▇╱▏▇╱▏▁ \n ▇╱╱╱▏▇╱▇╱▏▇╱╱╱▏\n ▇▇▇╱┈▇▇▇╱┈▇▇▇╱ '] = '^/lol'
triggers['▒█▀▀▀█ ▀█▀ ▒█▀▀▄ \n░▀▀▀▄▄ ▒█░ ▒█░▒█ \n▒█▄▄▄█ ▄█▄ ▒█▄▄▀ '] = '^/sid' -- '-' <3

local action = function(msg)

  for k,v in pairs(triggers) do
    if string.match(msg.text_lower, v..'$') then
      sendMessage(msg.chat.id, k)
      return
    end
  end

end

return {
  command = command,
  doc = doc,
  action = action,
  triggers = triggers
}
