-- patterns.lua
-- Responsável pelos padrões de parsing

local M = {}

M.paterns = {}

function M.add_patern(nome, patern)
    M.paterns[nome] = {
        patern = patern
    }
end

function M.get_patern(nome)
    return M.paterns[nome].patern
end

-- Definição dos padrões
M.add_patern("var", "^%s*(%w*)%s*:*%s*(%w+)%s*=%s*(.+)%s*")
M.add_patern("function", "^%s*(%w+)%s*%((.-)%)%s*=>%s*{(.-)}%s*")
M.add_patern("function_generic", "^%s*(%w+)%s*%((.-)%)%s*<([^>]*)>%s*=>%s*{(.-)}%s*")
M.add_patern("interface", "^inte (%w+)%s*({%s*.+%s*})%s*")
M.add_patern("interface_atr", "^%s*{%s*(%w+)%s*(%w+)%s*}%s*")
M.add_patern("if", "^%s*if%s*%((.-)%)%s*{(.-)}%s*$")
M.add_patern("loop", "^%s*loop%s*%((.-)%)%s*{(.-)}%s*$")


function M.fspt(str, patern_name)
    return table.pack(
        patern_name,
        str:match(
            M.get_patern(patern_name)
        )
    )
end

return M
