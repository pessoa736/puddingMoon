-- patterns.lua
-- Responsável pelos padrões de parsing

local M = {}

M.paterns = {}



function M.get_patern(nome)
    return M.paterns[nome].patern
end

-- Definição dos padrões
M.add_patern("var", "^%s*(%w*)%s*:*%s*(%w+)%s*=%s*(.+)%s*")
M.add_patern("function", "^%s*(%w+)%s*%((.-)%)%s*=>%s*{(.-)}%s*")
M.add_patern("if", "^%s*if%s*%((.-)%)%s*{(.-)}%s*$")
M.add_patern("loop", "^%s*loop%s*%((.-)%)%s*{(.-)}%s*$")


-- format_string_in_patern_to_tokem
function M.fspt(str, patern_name)
    return patern_name, str:match(M.get_patern(patern_name))
end

return M
