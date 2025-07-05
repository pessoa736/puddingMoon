
local Interface = {}
Interface.__interfaces = {}


function Interface.define(name, spec)
    
    assert( type(name) == "string", "Nome da interface deve ser uma string" )
    assert( type(spec) == "table", "Spec deve ser uma tabela" )
    assert( not Interface.__interfaces[name], string.format("Interface '%s' já definida", name ) )

    Interface.__interfaces[name] = spec
    return name
end

function Interface.check(name, obj)
    local spec = Interface.__interfaces[name]
  
    assert(spec, string.format("Interface '%s' não definida", name))
    assert(type(obj) == "table", "O objeto deve ser uma tabela")
  
    for key, expectedType in pairs(spec) do
        local value = obj[key]
        assert(value ~= nil, string.format("Propriedade '%s' ausente para interface '%s'", key, name))
        assert( 
            type(value) == expectedType, 
            string.format("Propriedade '%s' deve ser do tipo %s, mas é %s", key, expectedType, type(value))
        )
    end
    return true
end

function Interface.enforce(name, obj)
    Interface.check(name, obj)
    return obj
end

return Interface
