Players = {}
Players.List = {}
setmetatable(Players, {})

function Players:GetList()
    return self.List
end

function Players:GetOne(ID)
    if self.List[ID] then
        return true
    end
    return false
end