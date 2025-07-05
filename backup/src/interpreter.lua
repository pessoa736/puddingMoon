log = require("log")
local Tokens = require("tokens")

local interpreter = {}

local function is_var(line)
    return line:match("^(%w+)%s*:%s*%w+%s*=%s*.+") ~= nil
end

local function is_func(line)
    return line:match("^%w+%s*:%s*%w+%s*=%s*function%s*%b()") or
           line:match("^%w+%s*=%s*function%s*%b()")
end

function interpreter.set_var(line)
    local name, type_var, value = line:gsub("\r", ""):match("^(%w+)%s*:%s*(%w+)%s*=%s*(.+)")
    if not (name and type_var and value) then
        log("Erro ao interpretar a linha:", line)
        return nil
    end
    local token = Tokens.var(name, type_var, value)
    log(token)
    return token
end

function interpreter.set_funct(content)
    local name, type_return, params, body = content:match("^(%w+)%s*:%s*(%w+)%s*=%s*function%s*(%b())%s*(.-)%s*end$")
    if not (name and type_return and params and body) then
        log("Erro ao interpretar a função:", content)
        return nil
    end
    local token = Tokens.funct(name, type_return, params, body)
    log(token)
    return token
end

function interpreter.getFile(path)
    local file = io.open(path, "r")
    if not file then
        log("File not found: " .. path)
        return nil
    end
    return file
end

function interpreter.closeFile(file)
    if file then file:close() end
end

function interpreter.interpret(content)
    local tokens, block, in_function = {}, {}, false
    for line in content:lines() do
        local trimmed = line:gsub("^%s+", ""):gsub("\r", "")
        if in_function then
            table.insert(block, trimmed)
            if trimmed == "end" then
                local func_block = table.concat(block, "\n")
                local token = interpreter.set_funct(func_block)
                if token then table.insert(tokens, token) end
                in_function, block = false, {}
            end
        elseif is_func(trimmed) then
            in_function = true
            table.insert(block, trimmed)
        elseif is_var(trimmed) then
            local token = interpreter.set_var(trimmed)
            if token then table.insert(tokens, token) end
        end
    end
    return tokens
end

return interpreter