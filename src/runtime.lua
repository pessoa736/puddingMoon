
runtime={}
local t=0

-- transformLua
function runtime:add(func)
    self[#self+1] = function(s) 
        load(func)()
    end   
end

function runtime:update()
    if #runtime<=t then t=0 end 
    if #runtime>t then t=t+1 end
    
    local l = runtime[t]
    l()
end


return runtime