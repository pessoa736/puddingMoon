-- types.lua
-- Responsável pelos tipos e validação

local M = {}
M.types = {}

function M.add_type(name, CheckFunc)
    M.types[name] = table.pack(name, CheckFunc)
end

function M.get_check_type(name)
    return M.types[name] and M.types[name][2]
end

-- number: verifica se o valor é numérico
M.add_type("number", function(t)
    return tonumber(t[2]) ~= nil
end)

-- function: nome válido + args + corpo
M.add_type("function", function(t)
    local nome, args, corpo = t[2], t[3], t[4]
    return nome ~= nil and nome:match("^[a-zA-Z_][%w_]*$") ~= nil
        and args ~= nil and corpo ~= nil
end)

-- function_generic: nome + args + tipo genérico + corpo
M.add_type("function_generic", function(t)
    local nome, args, tipo, corpo = t[2], t[3], t[4], t[5]
    return nome ~= nil and nome:match("^[a-zA-Z_][%w_]*$") ~= nil
        and args ~= nil and tipo ~= nil and corpo ~= nil
end)

-- string: deve estar entre aspas simples ou duplas
M.add_type("string", function(t)
    local val = t[2]
    return val ~= nil and (val:match('^".*"$') or val:match("^'.*'$")) ~= nil
end)

-- boolean: true ou false
M.add_type("boolean", function(t)
    return t[2] == "true" or t[2] == "false"
end)

-- identifier: nome válido
M.add_type("identifier", function(t)
    return t[2] ~= nil and t[2]:match("^[a-zA-Z_][a-zA-Z0-9_]*$") ~= nil
end)

-- list: precisa estar entre colchetes
M.add_type("list", function(t)
    local val = t[2]
    return val ~= nil and val:match("^%[.*%]$") ~= nil
end)

-- nil: valor literal nil
M.add_type("nil", function(t)
    return t[2] == "nil"
end)

-- operator: operadores válidos
M.add_type("operator", function(t)
    local op = t[2]
    return ({
        ["+"] = true, ["-"] = true, ["*"] = true, ["/"] = true,
        ["%"] = true, ["=="] = true, ["~="] = true,
        [">"] = true, ["<"] = true, [">="] = true, ["<="] = true
    })[op] or false
end)

-- table: conteúdo entre chaves
M.add_type("table", function(t)
    local val = t[2]
    return val ~= nil and val:match("^%b{}$") ~= nil
end)

-- var: nome válido + tipo + valor
M.add_type("var", function(t)
    return t[2] ~= nil and t[2]:match("^[a-zA-Z_][%w_]*$") ~= nil
        and t[3] ~= nil and t[4] ~= nil
end)

-- interface: nome válido + estrutura em chaves
M.add_type("interface", function(t)
    return t[2] ~= nil and t[2]:match("^[a-zA-Z_][%w_]*$") ~= nil
        and t[3] ~= nil and t[3]:match("^%b{}$") ~= nil
end)

-- interface_atr: nome do atributo + tipo
M.add_type("interface_atr", function(t)
    return t[2] ~= nil and t[2]:match("^[a-zA-Z_][%w_]*$") ~= nil
        and t[3] ~= nil
end)

-- if: condição + corpo
M.add_type("if", function(t)
    return t[2] ~= nil and t[3] ~= nil
end)

-- loop: condição + corpo
M.add_type("loop", function(t)
    return t[2] ~= nil and t[3] ~= nil
end)

return M
