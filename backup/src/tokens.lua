local log = require("log")

local function create_token(...)
    return setmetatable({...}, {
        __tostring = function(self)
            local parts = {}
            for k, v in pairs(self) do
                table.insert(parts, k .. ": " .. tostring(v))
            end
            return "Token (" .. table.concat(parts, ", ") .. ")"
        end
    })
end

local function var(name, type_var, value)
    log.assert(name, "Variable name is required")
    local token = create_token("var", name, type_var, value)
    return token
end

local function funct(name, type_return, params, body)
    log.assert(name, "Function name is required")
    local token = create_token("function", name, type_return, params, body)
    return token
end

return {
    create_token = create_token,
    var = var,
    funct = funct,
}