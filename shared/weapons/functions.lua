WeaponShared = {}
WeaponShared.List = {}
setmetatable(WeaponShared, {})

function WeaponShared:Valid(weapon)
    if weapon then
        for k,v in pairs(self.List) do
            if type(weapon) == 'string' then
                if v.SpawnName == string.upper(weapon) then
                    return true
                end
            else
                if v.Hash == weapon then
                    return true
                end
            end
        end
        return false
    end
end

function WeaponShared:Get(weapon)
    local count = 0
    if weapon then
        for k,v in pairs(self.List) do
            if type(weapon) == 'string' then
                if v.SpawnName == string.upper(weapon) then
                    return self.List[k]
                end
            else
                if v.Hash == weapon then
                    return self.List[k]
                end
            end
        end
        return false
    end
end

function WeaponShared:Label(weapon)
    local WeaponData = WeaponShared:Get(weapon)
    return WeaponData.Name
end

function WeaponShared:GetCategory(weapon)
    local WeaponData = WeaponShared:Get(weapon)
    return WeaponData.Category
end

function WeaponShared:Hash(weapon)
    local WeaponData = WeaponShared:Get(weapon)
    return WeaponData.Hash
end

function WeaponShared:GetPlacement(weapon)
    local WeaponData = WeaponShared:Get(weapon)
    for k,v in pairs(Weapon.Placement) do
        for _, v2 in ipairs(v) do
            if WeaponData.Category == v2 then
                return k
            end
        end
    end
end

function WeaponShared:Name(weapon)
    local WeaponData = WeaponShared:Get(weapon)
    return WeaponData.SpawnName
end

function WeaponShared:Components(weapon)
    local WeaponData = WeaponShared:Get(weapon)
    return WeaponData.Components
end

function WeaponShared:GetComponentsOfWeapon(weapon)
    local components_list = {}
    for k,v in pairs(WeaponShared:Components(weapon)) do
        for k2, v2 in pairs(v) do
            table.insert(components_list, {spawnname = k2, name = v2.Key, hash = v2.Value, category = k})
        end
    end
    return components_list
end

function WeaponShared:GetComponent(weapon, component)
    if weapon and component then
        for k,v in pairs(WeaponShared:GetComponentsOfWeapon(weapon)) do
            if type(component) == 'string' then
                if v.spawnname == component then
                    return true, v
                end
            else
                if v.hash == component then
                    return true, v
                end
            end
        end
        return false, nil
    end
end

function WeaponShared:SetData(data)
    if data then
        if type(data) == 'string' then
            data = json.decode(data)
        end
        self.List = data
    end
end