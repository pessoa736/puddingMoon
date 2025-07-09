paterns = require("patterns")
tokens = tokens or require("tokens")
DEBUG = DEBUG or true

script = "test(a, b)=>{ ta(str)=>{aaaaa} }"

function interpreter(str) 
    local t = tokens.validate(paterns.fspt(str, "function"))
    print(t)
    print(paterns.fspt(t[4]))
end

interpreter(script)