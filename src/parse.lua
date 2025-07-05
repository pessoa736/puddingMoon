-- parse.lua
-- Arquivo principal, integra os módulos

local patterns = require("patterns")
local types    = require("types")
local env      = require("env")

-- Se definido como true, habilita testes de linha de comando
local TEST_MODE = true

-- Tenta encontrar e validar um token para a string de entrada
local function decode_to_token(str)
    if type(str) ~= "string" then
        error("decode_to_token: valor deve ser string, recebeu " .. type(str))
    end
    for name, _ in pairs(patterns.paterns) do
        local raw = patterns.fspt(str, name)
        local check = types.get_check_type(name)
        if check(raw) then
            local args = {}
            for i = 2, #raw do table.insert(args, raw[i]) end
            return { type = name, args = args }
        end
    end
    return nil
end

-- Codifica um token decodificado em sintaxe Lua executável
local function encode_to_lua(token)
    if not token then error("encode_to_lua: token inválido") end
    local t, a = token.type, token.args

    if t == "var" then
        -- local x = <valor>
        return string.format("local %s = %s", a[1], a[3])

    elseif t == "function" then
        -- função normal
        return string.format("function %s(%s) %s end", a[1], a[2], a[3])

    elseif t == "function_generic" then
        -- fabrica funções genéricas: retorna um construtor parametrizado por tipo
        -- a = { nome, params, generic_type, body }
        local name, params, gen, body = a[1], a[2], a[3], a[4]
        return string.format([[
function %s_of_%s(%s)
    -- tipo genérico: %s
    return %s
end
        ]], name, gen, params, gen, body)

    elseif t == "interface" then
        -- Gera uma função construtora de tabela com metatable para registrar tipo
        local name, body = a[1], a[2]
        local fields = {}
        for entry, _ in body:gmatch("(%w+)%s+%w+") do table.insert(fields, entry) end
        local params = table.concat(fields, ", ")
        local assigns = {}
        for _, f in ipairs(fields) do table.insert(assigns, string.format("[%q] = %s", f, f)) end
        local body_tbl = table.concat(assigns, ", ")
        return string.format([[
function %s(%s)
    local obj = {%s}
    setmetatable(obj, { __type = "%s" })
    return obj
end
        ]], name, params, body_tbl, name)

    elseif t == "interface_atr" then
        -- atributo isolado
        return string.format("-- atributo %s do tipo %s", a[1], a[2])

    elseif t == "if" then
        return string.format("if %s then %s end", a[1], a[2])

    elseif t == "loop" then
        return string.format("while %s do %s end", a[1], a[2])

    else
        return string.format("-- padrão não suportado: %s", t)
    end
end

-- Processa múltiplas linhas, atualiza ambiente e retorna código Lua
local function parse_lines(lines)
    local output = {}
    for _, line in ipairs(lines) do
        local tok = decode_to_token(line)
        if tok then
            env.add_element_to_env(env.create_element(tok.type, tok.args[1], tok))
            table.insert(output, encode_to_lua(tok))
        else
            table.insert(output, string.format("-- linha não reconhecida: %s", line))
        end
    end
    return output
end

-- Modo de teste com exemplos
if TEST_MODE then
    local examples = {
        "int a = 1",
        "sum(a, b)=>{ return a+b }",
        "sum(a, b)<int>=>{ return a+b }",
        "inte User{ name string; age number }",
        "if(x>0){ print(x) }",
        "loop(i<3){ print(i) }",
    }
    for _, ex in ipairs(examples) do
        print("Input:", ex)
        local tok = decode_to_token(ex)
        print(" Token:", tok and tok.type, table.unpack(tok and tok.args or {}))
        if tok then print(" Lua:", encode_to_lua(tok)) end
        print("---")
    end
end

return {
    decode_to_token = decode_to_token,
    encode_to_lua    = encode_to_lua,
    parse_lines      = parse_lines,
}
