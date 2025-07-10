local log = log or require("log")
local tokens = tokens or require("tokens")

DEBUG = DEBUG or true

local M = {}
M.paterns = {}

function find_block(str, open_sym, close_sym, start_pos)
    local depth = 0
    local i = start_pos or 1
    local block_start = nil

    while i <= #str do
        local char = str:sub(i, i)
        if char == open_sym then
            if depth == 0 then
                block_start = i
            end
            depth = depth + 1
        elseif char == close_sym then
            depth = depth - 1
            if depth == 0 and block_start then
                return str:sub(block_start, i), block_start, i
            end
        end
        i = i + 1
    end

    return nil -- não achou bloco completo
end


function M.add_patern(nome, ...)
    M.paterns[nome] = tokens.create(...)
    log("patern criado " .. nome ..": " .. M.paterns[nome])
end

function M.get_paterns(nome)
    return tokens.validate(M.paterns[nome])
end

-- Definição dos padrões
M.add_patern("var", "^%s*(%w*)%s*(%w+)%s*=%s*")
M.add_patern("function", "^%s*(%w+)%((.-)%)%s*=>%s*{")
M.add_patern("call_function", "^(%w+)%((.-)%)")

function M.check(str, patern_name)
    if type(str) ~= "string" then
        error("M.check: esperado string, recebido " .. tostring(str))
    end
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
    local pattern = M.check(str, patern_name)
    local head = { string.match(str, pattern) }

    if patern_name == "function" then
        local block_code = select(3, string.find(str, pattern))
        local body, _, body_end = find_block(str, "{", "}", #block_code + 1)

        table.insert(head, body and body:sub(2, -2) or "") -- remove as { }
    end

    local blockTokem = tokens.create(patern_name, table.unpack(head))
    log("block tokem is created: " .. blockTokem )
    return blockTokem
end

function M.extract_blocks(script)
    local results = {}
    local i = 1

    while i <= #script do
        local sub = script:sub(i)
        local found = false

        for name, _ in pairs(M.paterns) do
            local pattern = M.check(sub, name)
            if pattern then
                local s, e = string.find(script, pattern, i)
                if s then
                    local block_code = script:sub(s)
                    local success, token = pcall(M.fspt, block_code, name)

                    if success then
                        table.insert(results, {
                            name = name,
                            token = token,
                            raw = block_code
                        })

                        -- avança corretamente (funções têm blocos maiores)
                        if name == "function" then
                            local _, pat_end = string.find(block_code, pattern)
                            local _, _, block_end = find_block(block_code, "{", "}", (pat_end or 0) + 1)
                            i = s + (block_end or #block_code)
                        else
                            i = e + 1
                        end

                        found = true
                        break
                    else
                        log("Erro ao extrair bloco: " .. tostring(token))
                    end
                end
            end
        end

        if not found then
            i = i + 1
        end
    end

    return results
end


if DEBUG then
    log()
    log("--\t\t test de verificação de tokem por patern \t\t--")
    log()
    local script = "sum(a, b)=>{ print(a) return a+b} sum(3,4)"
    local blocos = M.extract_blocks(script)
    for _, bloco in ipairs(blocos) do
        log("Tipo:", bloco.name)
        log("Token:", tokens.validate(bloco.token))
    end
    log.show()
end
return M
