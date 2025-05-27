
I = require("interpreter")

local content = I:getFile("/tests/varTest.pud")
local tokens = I:interpret(content)

I:closeFile(content)
log.save("./logs")
