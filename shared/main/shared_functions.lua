SharedFunc = {}
setmetatable(SharedFunc, {})

function SharedFunc:GetTableSize(t)
    local c = 0
    for k,v in pairs(t) do
        c = c+1
    end
    return c
end