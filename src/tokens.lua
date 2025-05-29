

local function create_token(type_)
    return setmetatable({type_ = type_}, {
        __tostring = function(self)
            local str = "Token ("
            for k, v in pairs(self) do
                str = str .. k .. ": " .. v .. ", "
            end
            return str .. ")"
        end
    })
end

local function var(s, name, type_var, value)
    local token = create_token("var")
    token.name = name
    token.type_var = type_var
    token.value = value 
    return token
end

local function funct(s, name, type_return, params, body)
    local token = create_token("function")
    token.name = name
    token.type_return = type_return
    token.params = params
    token.body = body
    return token
end

return {
    create_token = create_token,
    var = var,
    funct = funct,
}