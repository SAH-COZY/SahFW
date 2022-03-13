function OpenWeaponAdmin()
    local MainMenu = RageUI.CreateMenu("", "ADD WEAPONS")
    local ComponentsMenu = RageUI.CreateSubMenu(MainMenu, "", "MANAGE COMPONENTS")
    local ComponentsModifyMenu = RageUI.CreateSubMenu(ComponentsMenu, "", "ADD/MODIFY COMPONENTS")
    
    local CACHE = {}
    local TOREPEAT = 0
    local CATLISTINDEX = 1
    local ISCHECKED = false
    local DATA = {
        HASH = "",
        NAME = "",
        COMPONENTS = {},
        SPAWNNAME = "",
        GETMAXAMMO = "",
        ACCURACY = "",
        DAMAGE = "",
        RANGE = "",
        SPEED = "",
        CATEGORY = ""
    }
    local COMPCATRUILIST = {}
    local LISTINDEX = 1
    local DATA2 = {
        NAME = "",
        SPAWNNAME = "",
        HASH = ""
    }

    RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))
    while MainMenu do
        RageUI.IsVisible(MainMenu, function() 
            if #DATA.SPAWNNAME > 0 then
                RageUI.Separator("Hash: ~b~"..DATA.HASH)
            end
            RageUI.Button("Name", nil, {RightLabel = DATA.NAME}, true, {
                onSelected = function()
                    local weapName = KeyboardInput("_weaponName", "Enter weapon name", "", 30)
                    if weapName ~= nil then
                        DATA.NAME = weapName
                    end
                end
            })
            RageUI.Button("Spawn Name", nil, {RightLabel = DATA.SPAWNNAME}, true, {
                onSelected = function()
                    local weapSpawnName = KeyboardInput("_weaponSpawnName", "Enter weapon spawn name", "", 30)
                    if IsWeaponValid(GetHashKey(weapSpawnName)) then
                        if weapSpawnName ~= nil then
                            DATA.SPAWNNAME = weapSpawnName
                            DATA.HASH = GetHashKey(weapSpawnName)
                        end
                    else
                        print("Weapon doesn't exists")
                    end
                end
            })
            RageUI.Button("Components", nil, {RightLabel = "→"}, true, {}, ComponentsMenu)
            RageUI.Button("Accuracy", nil, {RightLabel = DATA.ACCURACY}, true, {
                onSelected = function()
                    local weapSpawnName = KeyboardInput("_weaponSpawnName", "Enter weapon accuracy", "", 30)
                    if weapSpawnName then
                        DATA.ACCURACY = weapSpawnName
                    end
                end
            })
            RageUI.Button("Range", nil, {RightLabel = DATA.RANGE}, true, {
                onSelected = function()
                    local weapSpawnName = KeyboardInput("_weaponSpawnName", "Enter weapon range", "", 30)
                    if weapSpawnName then
                        DATA.RANGE = weapSpawnName
                    end
                end
            })
            RageUI.Button("Speed", nil, {RightLabel = DATA.SPEED}, true, {
                onSelected = function()
                    local weapSpawnName = KeyboardInput("_weaponSpawnName", "Enter weapon speed", "", 30)
                    if weapSpawnName then
                        DATA.SPEED = weapSpawnName
                    end
                end
            })
            RageUI.Button("Damage", nil, {RightLabel = DATA.DAMAGE}, true, {
                onSelected = function()
                    local weapSpawnName = KeyboardInput("_weaponSpawnName", "Enter weapon damage", "", 30)
                    if weapSpawnName then
                        DATA.DAMAGE = weapSpawnName
                    end
                end
            })
            RageUI.List("Category", WeaponCategories, CATLISTINDEX, nil, {}, true, {
                onListChange = function(Index)
                    CATLISTINDEX = Index
                    DATA.CATEGORY = WeaponCategories[CATLISTINDEX]
                end
            })
            RageUI.Button("Validate", nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    TriggerServerEvent("SahFW:AddWeaponToList", DATA)
                    RageUI.CloseAll()
                end
            })
        end, function()
            if #DATA.ACCURACY > 0 then
                RageUI.StatisticPanel((tonumber(DATA.ACCURACY)/100), "Accuracy", 4)
            end
            if #DATA.RANGE > 0 then
                RageUI.StatisticPanel((tonumber(DATA.RANGE)/100), "Range", 4)
            end
            if #DATA.SPEED > 0 then
                RageUI.StatisticPanel((tonumber(DATA.SPEED)/100), "Speed", 4)
            end
            if #DATA.DAMAGE > 0 then
                RageUI.StatisticPanel((tonumber(DATA.DAMAGE)/100), "Damage", 10)
            end
            
        end)

        RageUI.IsVisible(ComponentsMenu, function()
            RageUI.Button("Add Component category", nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    local weapComponentCategory = KeyboardInput("_weaponCategoryName", "Enter weapon component category name", "", 30)
                    if weapComponentCategory ~= nil then
                        DATA.COMPONENTS[weapComponentCategory] = {}
                    end
                end
            })
            RageUI.Separator("↓ Components categories List ↓")
            for k,v in pairs(DATA.COMPONENTS) do
                RageUI.Button(k, "~r~Pressing ENTER will delete this category !", {}, true, {
                    onSelected = function()
                        DATA.COMPONENTS[k] = nil
                    end
                })
            end
            if SharedFunc:GetTableSize(DATA.COMPONENTS) > 0 then
                RageUI.Separator("→ Components ←")
                RageUI.Button("Add Component", nil, {RightLabel = "→"}, true, {
                    onSelected = function()
                        COMPCATRUILIST = {}
                        for k,v in pairs(DATA.COMPONENTS) do
                            table.insert(COMPCATRUILIST, {Name = k, Value = k})
                        end
                        CACHE.LockCategory = false
                    end
                }, ComponentsModifyMenu)
                RageUI.Separator("↓ Components List ↓")
                for k,v in pairs(DATA.COMPONENTS) do
                    RageUI.Separator("↓ "..k.." ↓")
                    for k2, v2 in pairs(v) do
                        RageUI.Button(k2, v2.Key.." | Hash: ~b~"..v2.Value, {RightLabel = "→"}, true, {
                            onSelected = function()
                                DATA2.SPAWNNAME = k2
                                DATA2.NAME = v2.Key
                                DATA2.HASH = v2.Value
                                CACHE.LockCategory = true
                            end
                        }, ComponentsModifyMenu)
                    end
                end
            end
        end, function() end)

        RageUI.IsVisible(ComponentsModifyMenu, function() 
            if #DATA2.SPAWNNAME > 0 then
                RageUI.Separator("Hash: ~b~"..DATA2.HASH)
            end
            RageUI.Button("Name", nil, {RightLabel = DATA2.NAME}, true, {
                onSelected = function()
                    local weapComponentName = KeyboardInput("_weaponName", "Enter weapon component name", "", 30)
                    if weapComponentName ~= nil then
                        DATA2.NAME = weapComponentName
                    end
                end
            })
            RageUI.Button("Spawn Name", nil, {RightLabel = DATA2.SPAWNNAME}, true, {
                onSelected = function()
                    local weapCompSpawnName = KeyboardInput("_weaponCompSpawnName", "Enter component spawn name", DATA2.SPAWNNAME, 30)
                    if not ISCHECKED then
                        if DoesWeaponTakeWeaponComponent(DATA.HASH, GetHashKey(weapCompSpawnName)) then
                            if weapCompSpawnName ~= nil then
                                DATA2.SPAWNNAME = weapCompSpawnName
                                DATA2.HASH = GetHashKey(weapCompSpawnName)
                            end
                        else
                            print("Weapon component doesn't exists")
                        end
                    else
                        if weapCompSpawnName ~= nil then
                            DATA2.SPAWNNAME = weapCompSpawnName
                            DATA2.HASH = GetHashKey(weapCompSpawnName)
                        end
                    end
                end
            })

            RageUI.List("Category", COMPCATRUILIST, LISTINDEX, nil, {}, not CACHE.LockCategory, {
                onListChange = function(Index)
                    LISTINDEX = Index
                end
            })

            RageUI.Checkbox("Iterate", nil, ISCHECKED, {}, {
                onChecked = function()
                    ISCHECKED = true
                end,
                onUnChecked = function()
                    ISCHECKED = false
                end
            })

            if ISCHECKED then
                RageUI.Button("Amount to repeat", nil, {RightLabel = TOREPEAT}, true, {
                    onSelected = function()
                        local amToAdd = KeyboardInput("_addToAdd", "Enter the amount you want to repeat", "", 3)
                        if amToAdd then
                            TOREPEAT = tonumber(amToAdd)
                        end
                    end
                })
            end

            RageUI.Button("Validate", nil, {RightLabel = "→"}, true, {
                onSelected = function()
                    if ISCHECKED then
                        for i = 1, TOREPEAT do
                            if i < 10 then i = "0"..tostring(i) end
                            DATA.COMPONENTS[COMPCATRUILIST[LISTINDEX].Value][DATA2.SPAWNNAME..i] = {
                                Key = DATA2.NAME.." "..i,
                                Value = GetHashKey(DATA2.SPAWNNAME..i)
                            }
                        end
                    else
                        DATA.COMPONENTS[COMPCATRUILIST[LISTINDEX].Value][DATA2.SPAWNNAME] = {
                            Key = DATA2.NAME,
                            Value = DATA2.HASH
                        }
                    end
                    RageUI.GoBack()
                end
            })
        end, function() end)


        if not RageUI.Visible(MainMenu) and not RageUI.Visible(ComponentsMenu) and not RageUI.Visible(ComponentsModifyMenu) then
            MainMenu = RMenu:DeleteType('MainMenu', true)
            ComponentsMenu = RMenu:DeleteType('ComponentsMenu', true)
            ComponentsModifyMenu = RMenu:DeleteType('ComponentsModifyMenu', true)
        end
        Wait(1)
    end
end




function OpenSimpleWeapon()
    local MainMenu = RageUI.CreateMenu("", "WEAPONS")
    local WeaponOptions = RageUI.CreateSubMenu(MainMenu, "", "WEAPONS")

    local ACTUALWEAPON = nil

    TriggerServerEvent("SahFW:RequestWeaponsList")

    RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))

    while not WeapList do
        Wait(1)
    end

    while MainMenu do
        RageUI.IsVisible(MainMenu, function() 
            for k,v in pairs(WeapList) do
                RageUI.Button(v.Name, nil, {RightLabel = "→"}, true, {
                    onSelected = function()
                        ACTUALWEAPON = v
                        GiveWeaponToPed(GetPlayerPed(-1), v.Hash, 250, false, true)
                        RageUI.Visible(WeaponOptions, true)
                    end
                })
            end
        end, function() end)

        RageUI.IsVisible(WeaponOptions, function() 
            for k,v in pairs(ACTUALWEAPON.Components) do
                RageUI.Separator("→ "..k.." ←")
                for k2, v2 in pairs(v) do
                    RageUI.Button(v2.Key, nil, {}, true, {
                        onSelected = function()
                            GiveWeaponComponentToPed(GetPlayerPed(-1), GetSelectedPedWeapon(GetPlayerPed(-1)), v2.Value)
                        end
                    })
                end
            end
        end, function() end)


        -- if not RageUI.Visible(MainMenu) and not RageUI.Visible(WeaponOptions) then
        --     MainMenu = RMenu:DeleteType('MainMenu', true)
        --     WeaponOptions = RMenu:DeleteType('WeaponOptions', true)
        -- end
        Wait(1)
    end
end

RegisterCommand("player:openweapon", function()
    OpenSimpleWeapon()
end, false)