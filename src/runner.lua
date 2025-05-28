
I = require("interpreter")

local content = I:getFile("../tests/Test Function.pud")
local tokens = I:interpret(content)

I:closeFile(content)
log.save("./logs")
