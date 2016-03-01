local command = 'lang'
local doc = [[```
/lang -- All Lang
/lang [Set] - Set lang```
]]

local triggers = {
    '^/lang[@'..bot.username..']*',
    '^/settings[@'..bot.username..']*'
}

local action = function(msg)
    local input = msg.text:input()
    if not input then
        sendMessage(msg.chat.id, 'Lang: \n🇧🇷-PT (`/lang pt`) \n🇱🇷-EN (`/lang en`)', true, nil, true)
        return false
    end

    local lang_sent = input:sub(1,2)
    if string.match(lang_sent, '^br[asil]*') then
        lang_sent = 'pt'
    elseif string.match(lang_sent, '^u[nited]*s[tates]*') or string.match(lang_sent, '^usa') or string.match(lang_sent, '^en') then
        lang_sent = 'en'
    else
        sendMessage(msg.chat.id, doc, true, msg.message_id, true)
        return
    end

    local chat = msg.chat.id_str
    if msg.from.id == msg.chat.id then
        chat = msg.from.id_str
    end

    redis:set('LANG:'..chat, lang_sent)
    sendMessage(msg.chat.id, "OK")
end

return {
    action = action,
    triggers = triggers,
    doc = doc,
    command = command
}
