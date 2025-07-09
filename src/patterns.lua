local log = log or require("log")
local tokens = tokens or require("tokens")

DEBUG = DEBUG or false

local M = {}
M.paterns = {}

function M.add_patern(nome, ...)
    M.paterns[nome] = tokens.create(...)
    log("patern criado " .. nome ..": " .. M.paterns[nome])
end

function M.get_paterns(nome)
    return tokens.validate(M.paterns[nome])
end

-- Definição dos padrões
M.add_patern("var", "^%s*(%w*)%s*(%w+)%s*=%s*(.+)%s*;")
M.add_patern("function", "^%s*(%w+)%s*%((.-)%)%s*=>%s*(.-)%s*;")

function M.check(str, patern_name)
    local patern = M.get_paterns(patern_name)
    for _, pat in ipairs(patern) do
        if string.match(str, pat) then
            return pat
        end
    end
    return nil -- nenhum padrão casou
end



-- format_string_in_patern_to_tokem
function M.fspt(str, patern_name)
    local blockTokem = tokens.create(
        patern_name,
        string.match(
            str,
            M.check(str, patern_name)
        )
    )
    log("block tokem is created: " .. blockTokem )
    return blockTokem
end


if DEBUG then
    log()
    log("--\t\t test de verificação de tokem por patern \t\t--")
    log()
    local a = M.fspt("test(a, b)=>{ return a+b }", "function")
    log("tokem validado: "..tostring(tokens.validate(a)))
    log()
    local a = M.fspt("int a = 1", "var")
    log("tokem validado: "..tostring(tokens.validate(a)))
    log.show()
end
return M
