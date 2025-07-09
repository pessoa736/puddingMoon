local serialize = require("serializer")

DEBUG = false

local fator_random=(((os.clock()*1000000)//1)-1500)//10

local function crypt(str)
    local res = ""
    for i=1, #str do
        local byte = str:byte(i)
        res = res .. string.char((fator_random+byte+(i*2+(i%2)))%256)
    end
    return res
end

local function descrypt(str)
    local res = ""
    for i=1, #str do
        local byte = str:byte(i)
        res = res .. string.char(((-fator_random)+byte-(i*2+(i%2)))% 256)
    end
    return res
end

function create(...)
    local args= setmetatable({...},{ __tostring = serialize })
    local str = tostring(args)

    return crypt(str)
end

function validate(token)
    local str = descrypt(token)
    return setmetatable(load("return" .. str)(), {__tostring = serialize})
end

if DEBUG then
    local T = create(2, 3, 4)
    print(T)
end

return {
    create = create,
    validate = validate
}