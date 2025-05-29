
I = require("interpreter")
Env = require("environment")



local content = I:getFile("../tests/Test Function.pud")
local tokens = I:interpret(content)

local Env = require("environment")
Env:addMany(tokens)


I:closeFile(content)
log.save("./logs")
