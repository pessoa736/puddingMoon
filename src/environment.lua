log = require("log")

local env = {}	

env._G_ = {}

function env.add(s, var)
    s._G_[var.name] = var
    log("adicionado ao ambiente global:", var.name)
end

function env.addMany(s, ...)
    local vars = {...}
    if #vars == 1 and type(vars[1]) == "table" then
        vars = vars[1]  -- Unpack the table if a single table is passed
    end
    for _, var in ipairs(vars) do
        s:add(var)
    end
end




return env