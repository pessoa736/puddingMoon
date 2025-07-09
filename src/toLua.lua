log = require("log")

function token_to_Lua(token)
    local result

    if token[1] == "function" then
        result = "function ".. token[2] .. "(".. token[3] .. ") " .. 
            token[4] .. 
        "end"
    elseif token[1]=="var" then
        if tonumber(token[2])~=nil then error("the function name can't be a number") end

        local checktype = token[3]~=nil and [[
            if type(]]..token[3]..[[) ~= type(]]..token[4]..[[) then 
                error(']] .. token[3] .. " is not " .. token[4] .. [[') 
            end
        ]] or ""

        result = token[2] .. "=" .. token[4] .. checktype
    end
    return result
end





