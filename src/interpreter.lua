
log = require("log")


local interpreter = {}

function is_var(line)
    return string.match(line, "^(%w+)%s*:%s*%w+%s*=%s*.+") ~= nil
end

function interpreter.set_token_var(s, line)
    local name, type_, value
    local removeR = line:gsub("\r", "")

    -- Extrai nome, tipo e valor com pattern correto
    name, type_, value = string.match(removeR, "^(%w+)%s*:%s*(%w+)%s*=%s*(.+)")

    if not (name and type_ and value) then
     log("Erro ao interpretar a linha:", line)
      return nil
    elseif name and value and not type_ then
      log("var " .. name .." não tem typo definido")
    end

    local token = interpreter:transformInTokens(name, type_, value)
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

function interpreter.transformInTokens(s, name, type, value)
    local token = {
        name = name,
        type = type,
        value = value
    }
    return setmetatable(token, {
        __tostring = function(self)
            return "Token (name: ".. tostring(self.name) ..",type: " .. tostring(self.type) .. ", value: "..tostring(self.value)..")"
        end
    })
end

function interpreter.interpret(s, content)
    local tokens = {}
    for line in content:lines() do
     local token = interpreter:set_token_var(line)
     if token then
        table.insert(tokens, token)
      end
    end

    return tokens
end


return interpreter