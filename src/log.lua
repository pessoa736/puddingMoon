local log = {
    _messages = {},
    show = function ()
        for i, v in ipairs(log._messages) do
            print(v)
        end 
        print("Total messages: " .. #log._messages)	
    end,
    save = function ()
        local base = "./logs/log"

        local file = io.open(base, "a+")
        if not file then
            print("Error opening file for writing: ")
            return
        end

        for i, v in ipairs(log._messages) do
            file:write(v .. "\n")
        end

        file:close()
        print("Log saved")
    end,
    add = function (...)
        local message = ""

        for i, v in ipairs({...}) do
            message = message .. " " .. tostring(v)
        end
        
        local text = "[ ".. os.date() .." ]".. message
        
        table.insert(log._messages, text)
    end
} 

return setmetatable(log, {
    __call = function(_, ...)
        log.add(...)
    end
})