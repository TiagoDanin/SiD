if not key.lastfm_api_key then
  print('Missing config value: lastfm_api_key.')
  print('lastfm.lua will not be enabled.')
  return
end

local lastfm = load_data('lastfm.json')
local command = 'lastfm'
local doc = [[```
/np [username]
$fm_doc_np*

/fmset <username>
$fm_doc_set*
```]]
local action = function(msg)
  local input = msg.text:input()

  if string.match(msg.text, '^/lastfm') then
    sendMessage(msg.chat.id, sendLang(doc, lang), true, msg.message_id, true)
    return
  elseif string.match(msg.text, '^/fmset') then
    if not input then
      sendMessage(msg.chat.id, sendLang(doc, lang), true, msg.message_id, true)
    elseif input == '-' then
      lastfm[msg.from.id_str] = nil
      sendReply(msg, sendLang('$deleted*', lang))
    else
      lastfm[msg.from.id_str] = input
      sendReply(msg, sendLang('$add*', lang))
    end
    save_data('lastfm.json', lastfm)
    return
  end

  local url = 'http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&format=json&limit=1&api_key=' .. key.lastfm_api_key .. '&user='

  local username
  local output = ''
  if input then
    username = input
  elseif lastfm[msg.from.id_str] then
    username = lastfm[msg.from.id_str]
  elseif msg.from.username then
    username = msg.from.username
    output = '\n\n$fm_set* ' .. username .. '.\n$fm_ch* /fmset <$username*>.'
    lastfm[msg.from.id_str] = username
    save_data('lastfm.json', lastfm)
  else
    sendReply(msg, sendLang('$fm_pls_ch*', lang))
    return
  end

  url = url .. URL.escape(username)

  jstr, res = HTTPS.request(url)
  if res ~= 200 then
    sendReply(msg, config.errors.connection)
    return
  end

  local jdat = JSON.decode(jstr)
  if jdat.error then
    sendReply(msg, sendLang('$fm_pls_ch*', lang))
    return
  end

  local jdat = jdat.recenttracks.track[1] or jdat.recenttracks.track
  if not jdat then
    sendReply(msg, sendLang('$fm_not_h* ' .. output, lang))
    return
  end

  local message = input or msg.from.first_name
  message = '🎵 ' .. message

  if jdat['@attr'] and jdat['@attr'].nowplaying then
    message = message .. ' $fm_last*:\n'
  else
    message = message .. ' $fm_last_*:\n'
  end

  local title = jdat.name or 'Unknown'
  local artist = 'Unknown'
  if jdat.artist then
    artist = jdat.artist['#text']
  end

  message = message .. title .. ' - ' .. artist .. output
  sendMessage(msg.chat.id, sendLang(message, lang))

end

return {
  command = command,
  doc = doc,
  action = action,
  triggers = {
    '^/lastfm[@'..bot.username..']*',
    '^/np[@'..bot.username..']*',
    '^/fmset[@'..bot.username..']*'
  }
}
