log = require("log")

local interpreter = {}

function is_var(line)
    return string.match(line, "^(%w+)%s*:%s*%w+%s*=%s*.+") ~= nil
end

function is_func(line)
    return line:match("^%w+%s*:%s*%w+%s*=%s*function%s*%b()") or
           line:match("^%w+%s*=%s*function%s*%b()")
end

function interpreter.set_var(s, line)
    local name, type_, value
    local removeR = line:gsub("\r", "")

    name, type_, value = string.match(removeR, "^(%w+)%s*:%s*(%w+)%s*=%s*(.+)")

    if not (name and type_ and value) then
        log("Erro ao interpretar a linha:", line)
        return nil
    elseif name and value and not type_ then
        log("var " .. name .. " não tem tipo definido")
    end

    local token = interpreter:varToken(name, type_, value)
    log(token)
    return token
end

function interpreter.set_funct(s, content)
    local name, type_, params, body = content:match("^(%w+)%s*:%s*(%w+)%s*=%s*function%s*(%b())%s*(.-)%s*end$")
    
    if not (name and type_ and params and body) then
        log("Erro ao interpretar a função:", content)
        return nil
    end

    local token = interpreter:functToken(name, type_, params, body)
    log(token)
    return token
end

function interpreter.getFile(s, path)
    file = io.open(path, "r+")

    if not file then
        print("File not found")
    end

    return file
end

function interpreter.closeFile(s, file)
    if file then
        file:close()
    else
        print("File is not open")
    end
end

function create_token()
    return setmetatable({}, {
        __tostring = function(self)
            local str = "Token ("
            for k, v in pairs(self) do
                str = str .. k .. ": " .. v .. ", "
            end
            return str .. ")"
        end
    })
end

function interpreter.varToken(s, name, type, value)
    local token = create_token()
    token.name = name
    token.type = type
    token.value = value 
    return token
end

function interpreter.functToken(s, name, type, params, body)
    local token = create_token()
    token.name = name
    token.type = type
    token.params = params
    token.body = body
    return token
end

function interpreter.interpret(s, content)
    local tokens = {}
    local block = {}
    local in_function = false

    for line in content:lines() do
        local trimmed = line:gsub("^%s+", ""):gsub("\r", "")

        if in_function then
            table.insert(block, trimmed)
            if trimmed == "end" then
                local func_block = table.concat(block, "\n")
                local token = interpreter:set_funct(func_block)
                if token then
                    table.insert(tokens, token)
                end
                in_function = false
                block = {}
            end
        elseif is_func(trimmed) then
            in_function = true
            table.insert(block, trimmed)
        elseif is_var(trimmed) then
            local token = interpreter:set_var(trimmed)
            if token then
                table.insert(tokens, token)
            end
        end
    end

    return tokens
end

return interpreter