
log = require("log")


local interpreter = {}

function is_var(line)
    return string.match(line, "^(%w+)%s*=%s*.+") ~= nil
end


function interpreter.set_token_var(s, line)
    local name, value
    local _1 = line:gsub("\r", ""):gsub("(%w+)%s*=", function (self)   name = self;  return nil end)
    local _2 = line:gsub("\r", ""):gsub( "=%s*(.+)", function (self)   value = self;  return nil end)

    local token = interpreter:transformInTokens(name, "var", value)
    log(tostring(token))
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
            return "Token (name: ".. self.name ..",type: " .. self.type .. ", value: "..self.value..")"
        end
    })
end

function interpreter.interpret(s, content)
    local tokens = {}
    for line in content:lines() do
        if is_var(line) then
            local token = interpreter:set_token_var(line)
            if token then
                table.insert(tokens, token)
            end
        end
        
    end

    return tokens
end


return interpreter