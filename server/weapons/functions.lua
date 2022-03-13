Weapon = {}
Weapon.Placement = {
    ["Primary"] = {"Assault Rifle", "Shotgun", "Heavy Weapon", "Sniper Rifle", "Sub-Machine Gun"},
    ["Secondary"] = {"Pistol"},
    ["Melee"] = {"Melee"},
    ["Throwable"] = {"Throwable"}
}
Weapon.Categories = {"Assault Rifle", "Shotgun", "Heavy Weapon", "Sniper Rifle", "Sub-Machine Gun", "Pistol", "Melee", "Throwable"}
Weapon.List = {}
Weapon.Pickups = {}
setmetatable(Weapon, {})

function Weapon:LoadList()
    local weap_list = json.decode(LoadResourceFile(GetCurrentResourceName(), "./data/weapons.json"))
    if not weap_list then
        return {}
    else
        return weap_list
    end
end

function Weapon:CreatePickup(PlayerID, Pos, Weapondata)
    if PlayerID and Pos and Weapondata then
        local PickupID = math.random(10000, 65535)
        self.Pickups[PickupID] = {id = PickupID, coords = Pos, weaponData = Weapondata, Bucket = PlayerBucket}
        TriggerClientEvent("SahFW:AddWeaponPickup", tonumber(PlayerID), self.Pickups[PickupID])
    end
end

function Weapon:GetBucketPickups(bucket)
    local pickups_list = {}
    for k,v in pairs(self.Pickups) do
        if v.Bucket == bucket then
            table.insert(pickups_list, v)
        end
    end
    return pickups_list
end

function Weapon:AddData(weapInfos)
    if weapInfos then
        table.insert(WeaponShared.List, {
            Hash = weapInfos.HASH,
            Name = weapInfos.NAME,
            Components = weapInfos.COMPONENTS,
            SpawnName = weapInfos.SPAWNNAME,
            GetMaxAmmo = weapInfos.GETMAXAMMO,
            Accuracy = weapInfos.ACCURACY,
            Damage = weapInfos.DAMAGE,
            Range = weapInfos.RANGE,
            Speed = weapInfos.SPEED,
            Category = weapInfos.CATEGORY
        })
        Weapon:SaveData()
        Wait(50)
        Weapon:LoadList()
    end
end

function Weapon:SaveData()
    SaveResourceFile(GetCurrentResourceName(), "./data/weapons.json", json.encode(self.List), -1)
end
-- Accuracy range etc... can be found at the end of the weapons.meta file of the addon weapon (<HudDamage value="..."/> etc)