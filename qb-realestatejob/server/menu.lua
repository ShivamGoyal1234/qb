local QBCore = exports['qb-core']:GetCoreObject()

--Events

RegisterNetEvent('qb-realestate:server:changetier', function(tier, name, hasOwner)
    local src = source
    if hasOwner then
        
        TriggerClientEvent('QBCore:Notify', src, "This house is owned by somebody. Tier cannot be changed")  
    else 
        exports.oxmysql:execute('UPDATE houselocations SET tier = ? WHERE name = ?', {tier, name})
        TriggerClientEvent('QBCore:Notify', src, "Tier updated to: " ..tier)
        TriggerEvent('qb-houses:server:updateTier')
          
    end 
end)

RegisterNetEvent('qb-realestate:server:changeprice', function(price, name, hasOwner)
    local src = source
    if hasOwner then
        TriggerClientEvent('QBCore:Notify', src, "This house is already bought. Why would you change price?")  
    else 
        exports.oxmysql:execute('UPDATE houselocations SET price = ? WHERE name = ?', {price, name})
        TriggerClientEvent('QBCore:Notify', src, "Price updated to: " ..price)
        TriggerEvent('qb-houses:server:updatePrice', price)
        
    end 
end)

-- Callbacks

QBCore.Functions.CreateCallback("qb-realestate:server:GetHouses", function(source, cb)
    exports.oxmysql:execute('SELECT * FROM houselocations' , {}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)