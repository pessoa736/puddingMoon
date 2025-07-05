log = require("log")
local env = {}
env._G_ = {}

function env.add(var)
    env._G_[var[2]] = var
    log("adicionado ao ambiente global:", var[2])
end

function env.addMany(...)
    local vars = {...}
    if #vars == 1 and type(vars[1]) == "table" then
        vars = vars[1]
    end
    for _, var in ipairs(vars) do
        env.add(var)
    end
end

return env