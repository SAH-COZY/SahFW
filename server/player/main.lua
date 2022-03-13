RegisterCommand("addweapon", function(src, args) 
    Player:AddWeapon(src, args[1], tonumber(args[2]), true)
end, false)

RegisterCommand("addweaponcomp", function(src, args)
    Player:AddWeaponComponent(src, args[1], args[2])
    print(args[1], args[2])
end)