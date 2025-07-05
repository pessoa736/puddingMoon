I = require("interpreter")
Env = require("environment")
log = require("log")

local content = I.getFile("../tests/Test Function.pud")
if content then
    local tokens = I.interpret(content)
    Env.addMany(tokens)
    I.closeFile(content)
    log.save("./logs")
else
    print("Erro ao abrir arquivo de teste.")
end
