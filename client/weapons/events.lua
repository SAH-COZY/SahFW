RegisterNetEvent("SahFW:AdminWeaponManagement")
AddEventHandler("SahFW:AdminWeaponManagement", function() 
    OpenWeaponAdmin()
end)

RegisterNetEvent("SahFW:ReceiveWeaponsList")
AddEventHandler("SahFW:ReceiveWeaponsList", function(weap_list)
    WeapList = weap_list
end)