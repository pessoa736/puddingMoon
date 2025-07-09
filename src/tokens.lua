log = log or require("log")
serialize = serialize or require("serializer")

DEBUG = DEBUG or true

local fator_random=math.random(0, 10000) + (os.clock()*10000)//10
log(fator_random)
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
    local tokem = crypt(str)
    log("tokem criado " .. tokem)

    return tokem
end

function validate(token)
    local str = descrypt(token)
    return setmetatable(load("return" .. str)(), {__tostring = serialize})
end

if DEBUG then
    log()
    log("--\t\ttest de criação de tokens\t\t-- ")
    log()
    local T = create(2, 3, 4)
    log("token apos validação: " .. tostring(validate(T)))
    log.show()
end

return {
    create = create,
    validate = validate
}