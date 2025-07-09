local tokens = require("tokens")

DEBUG = false

local M = {}
M.paterns = {}

function M.add_patern(nome, patern)
    M.paterns[nome] = tokens.create(patern)
end

function M.get_patern(nome)
    return tokens.validate(M.paterns[nome])[1]
end

-- Definição dos padrões
M.add_patern("var", "^%s*(%w*)%s*(%w+)%s*=%s*(.+)%s*")
M.add_patern("function", "^%s*(%w+)%s*%((.-)%)%s*=>%s*{(.-)}%s*")


function M.fspt(str, patern_name)
    return tokens.create(
        patern_name,
        string.match(
            str,
            M.get_patern(patern_name)
        )
    )
end


if DEBUG then
    local a = M.fspt("test(a, b)=>{ return a+b }", "function")
    print(tokens.validate(a))
    local a = M.fspt("int a = 1", "var")
    print(tokens.validate(a))
end


return M
