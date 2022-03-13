Players = {}
Players.List = {}
setmetatable(Players, {})

function Players:AddPlayerToList(Data)
    if not Players.List[tostring(Data.Id)] then
        Players.List[tostring(Data.Id)] = Data
    else
        DropPlayer(Data.Id, "Strange thing append. Try to reconnect later")
    end
end

function Players:GetList()
    return self.List
end