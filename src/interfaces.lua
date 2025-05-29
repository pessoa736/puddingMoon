log = require("log")


local PropsDefaVar = {
    "name",
    "type_var",
    "type_",
    "value",
}

local PropsDefaFunct = {
    "name",
    "type_return",
    "params",
    "body",
    "type_",
}

local function check(table, interface)
    for _, prop in ipairs(interface) do
        if not table[prop] then
            return false, "Missing property: " .. prop
        end
    end
    return true
end



return {
    propsDefaVar = PropsDefaVar,
    propsDefaFunct = PropsDefaFunct,
    check = check,
}