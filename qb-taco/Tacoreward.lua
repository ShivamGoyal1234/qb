-- QBCore = nil
local QBCore = exports['qb-core']:GetCoreObject()


TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('qb-taco:server:start:black')
AddEventHandler('qb-taco:server:start:black', function()
    local src = source
    
    TriggerClientEvent('qb-taco:start:black:job', src)
end)

RegisterServerEvent('qb-taco:server:reward:money')
AddEventHandler('qb-taco:server:reward:money', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local MeatQuantity = 600

    if Player.Functions.AddMoney("cash", Config.PaymentTaco, "taco-reward-money") and xPlayer.Functions.GetItemByName('weed_ak47') then
        xPlayer.Functions.AddMoney("cash", MeatQuantity, "taco-reward-money")
        TriggerClientEvent('QBCore:Notify', src, 'You got extra bucks from weed_ak47', "success")
        xPlayer.Functions.RemoveItem("weed_ak47", 1)
        TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items['weed_ak47'], "remove")
    TriggerClientEvent('QBCore:Notify', src, "Taco delivered! Go back to the taco shop for a new delivery")
    end
end)

QBCore.Functions.CreateCallback('qb-tacos:server:GetConfig', function(source, cb)
    cb(Config)
end)

QBCore.Functions.CreateCallback('qb-taco:server:get:ingredient', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local lettuce = Ply.Functions.GetItemByName("lettuce")
    local meat = Ply.Functions.GetItemByName("meat")
    if lettuce ~= nil and meat ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('qb-taco:server:get:tacos', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local taco = Ply.Functions.GetItemByName('taco')
    if taco ~= nil then
        cb(true)
    else
        cb(false)
    end
end)