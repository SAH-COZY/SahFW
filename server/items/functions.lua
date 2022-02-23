Item = {}
Item.List = {}
setmetatable(Item, {})

function Item:Exists(item)
    if Item.List[item] then
        return true
    end
    return false
end

function Item:HaveAction(item)
    if Item.List[item].action then
        return true
    end
    return false
end

function Item:Use(src, item)
    if Item:Exists(item) then
        if Item:HaveAction(item) then
            Item.List[item].action(src, item)
        end
    end
end

function Item:AddAction(item, cb)
    if Item:Exists(item) then
        if not Item:HaveAction(item) then
            Item.List[item].action = cb
        end
    end
end

function Item:Label(item)
    if Item:Exists(item) then
        return Item.List[item].label
    end
end

function Item:Weight(item)
    if Item:Exists(item) then
        return Item.List[item].weight
    end
end

function Item:Get(item)
    if Item:Exists(item) then
        return Item.List[item]
    end
end