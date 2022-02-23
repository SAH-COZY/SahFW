Inventory = {}
setmetatable(Inventory, {})

function Inventory:TotalWeight(inventory)
    local inventory_total_weight = 0
    for k,v in pairs(inventory) do
        inventory_total_weight = inventory_total_weight+v.weight
    end
    return inventory_total_weight
end