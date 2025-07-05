package.path = package.path .. ";../?.lua"

local types  = require("types")
local check

-- Testes para var
check = types.get_check_type("var")
print(check(table.pack("var",    --[1] nome, --[2] tipo, --[3] valor
    "", "number", "1")))         -- nome vazio → inválido
print(check(table.pack("var", "1a", "number", "1")))  -- nome começa com número → inválido
print(check(table.pack("var", "x", "", "1")))         -- tipo vazio → inválido
print(check(table.pack("var", "x", "number", "")))    -- valor vazio → inválido
print(check(table.pack("var", "x", "number", "1")))   -- tudo OK → `true`

-- Testes para interface
check = types.get_check_type("interface")
print(check(table.pack("interface", "Foo", "{ a number }")))    -- OK
print(check(table.pack("interface", "", "{ a number }")))       -- nome vazio → inválido
print(check(table.pack("interface", "Foo", "a number")))        -- sem `{}` → inválido

-- Testes para interface_atr
check = types.get_check_type("interface_atr")
print(check(table.pack("interface_atr", "prop", "number")))     -- OK
print(check(table.pack("interface_atr", "prop", "")))           -- tipo vazio → inválido
print(check(table.pack("interface_atr", "", "number")))         -- nome vazio → inválido

-- Testes para if
check = types.get_check_type("if")
print(check(table.pack("if", "(x>0)", "{ print(x) }")))        -- OK
print(check(table.pack("if", "", "{ print(x) }")))             -- condição vazia → inválido
print(check(table.pack("if", "(x>0)", "")))                     -- corpo vazio → inválido

-- Testes para loop
check = types.get_check_type("loop")
print(check(table.pack("loop", "(i<10)", "{ i = i + 1 }")))    -- OK
print(check(table.pack("loop", "", "{ i = i + 1 }")))          -- condição vazia → inválido
print(check(table.pack("loop", "(i<10)", "")))                 -- corpo vazio → inválido
