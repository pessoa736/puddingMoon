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
            if i <= 1 then
                file:write("\n\n--\t\t" ..  os.date() .. "\t\t--\n") 
            end
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
        
        local text = "[ ".. #log._messages .." ]".. message
        
        table.insert(log._messages, text)
    end,
    assert = function (condition, ...)
        if not condition then
            local message = "Assertion failed: "
            for i, v in ipairs({...}) do
                message = message .. " " .. tostring(v)
            end
            log.add(message)
            error(message)
        end
    end,
} 

return setmetatable(log, {
    __call = function(_, ...)
        log.add(...)
    end
})