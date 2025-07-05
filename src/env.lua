-- env.lua
-- Responsável pelo ambiente e elementos

local M = {}
M.env_ = {}

function M.create_element(name, type, content)
    return {
        name = name,
        type = type,
        content = content
    }
end

function M.add_element_to_env(element)
    M.env_[element.name] = element
end

return M
