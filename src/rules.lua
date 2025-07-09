
local M = {}

M.rules = {}

function  M.add(name, ...)
    M.rules[name] = {...}
end