
function serialize(s)
    local r = '{'
    for k, v in pairs(s) do
        if type(k) == 'number' then
            k = ''
        else
            k = k .. ' = '
        end
        if r ~= '{' then
            r = r .. ', '
        end
        r = r .. k
        if type(v) == "string" then
            r = r .. '"'.. tostring(v) .. '"'
        elseif type(v) == "table" then
            r=r .. serialize(v)
        else
            r = r .. tostring(v)
        end
    end
    r = r .. '}'
    return r
end

return serialize