local triggers = {
	''
}

local action = function(msg)
    
    if not redis:get('RANK:'..msg.from.id_str) then
        redis:set('RANK:'..msg.from.id_str, 1)
        print('RANK:'..msg.from.id_str)
    else
        local set = redis:get('RANK:'..msg.from.id_str)
        set = set + 1
        redis:set('RANK:'..msg.from.id_str, set)
	end

	return true

end

return {
	action = action,
	triggers = triggers
}