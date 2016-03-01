local command = 'command'
local doc = [[```
/command <$set-command*> <$text*>
$doc_command*
$ex_command*
$use_command*

$del_command*

$alias*: /cmd```
]]

local triggers = {
    ''
}

local action = function(msg)
    
    if string.match(msg.text_lower, '^/command[@'..bot.username..']*') or string.match(msg.text_lower, '^/cmd') then
        
        local input = msg.text:input()
        if not input then
            sendMessage(msg.chat.id, sendLang(doc, lang), true, nil, true)
            return false
        end
        
        local chat_id = msg.chat.id_str
        local set_command = get_word(input, 1):gsub('%p', '')
        local msg_text = input:gsub(get_word(input, 1)..' ', ''):gsub('%[.+%]', ''):gsub('%(.+%)', '')
        
        if string.len(input) > 500 then
            sendReply(msg, 'MAX > 500')
		    return true
	    end
        
        if msg_text == '-' then
            if not redis:get('CMD:'..chat_id..':'..set_command) then
                sendMessage(msg.chat.id, sendLang('$not_exist*' ,lang), true, nil, true)
                return
            end
            redis:del('CMD:'..chat_id..':'..set_command)
            r = redis:get('CMD:'..chat_id)
            redis:set('CMD:'..chat_id, r - 1)
            sendMessage(msg.chat.id, sendLang('$deleted*', lang), true, nil, true)
            return true
        end
        
        if not redis:get('CMD:'..chat_id) then 
            redis:set('CMD:'..chat_id, 1)
        else
            if not set_command == redis:get('CMD:'..chat_id..':'..set_command) then
                r = redis:get('CMD:'..chat_id)
                if math.abs(r) > config.max_command then
                    sendMessage(msg.chat.id, sendLang('$max_command*', lang), true, nil, true)
                    return true
                end
                redis:set('CMD:'..chat_id, r + 1)
            end
        end
        
        redis:set('CMD:'..chat_id..':'..set_command, msg_text:lower())
        
        local output = '*$created_command**: '..set_command..'\n*$text**:```'..msg_text..'```'
        sendMessage(msg.chat.id, sendLang(output, lang), true, nil, true)
        return true
        
    elseif string.match(msg.text_lower, '^/cmdbysid[@'..bot.username..']*') then
        
        local output = '$BySiD*'
        sendMessage(msg.chat.id, sendLang(output, lang), true, nil, true)
        return true
        
    elseif string.match(msg.text_lower, '^/') then
        
        local input = msg.text:gsub('/', '')
        local chat_id = msg.chat.id_str
        if redis:get('CMD:'..chat_id..':'..input) then
            cmd = input:lower()
        else 
            return true
        end
        
        if string.match(msg.text_lower, '^/'..cmd..'[@'..bot.username..']*') then
            local output = redis:get('CMD:'..chat_id..':'..input)
            output = output .. '\n                                                      _By_[SiDBot](https://telegram.me/sidbot?start=cmdbysid)'
            sendMessage(msg.chat.id, output, true, nil, true)
            return true
        end
        
        return true
    
    end
    
    return true
    
end

return {
    action = action,
    triggers = triggers,
    doc = doc,
    command = command
}
