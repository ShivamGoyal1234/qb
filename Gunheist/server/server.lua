local QBCore = exports['qb-core']:GetCoreObject()
-- QBCore = nil 
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

local cooldown = -1;
local inProgress = false
local stopCooldown = false
local copsConnected = 0
local requiredCops = 0
local GUN = {
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_CARBINERIFLE",
    "WEAPON_ASSAULTSMG",
}


QBCore.Functions.CreateUseableItem('goldenradio', function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if CountCops() >= requiredCops then
        if not inProgress then
            inProgress = true
            TriggerClientEvent('Z3MO-Gunheist:drop', source, Config.Satellite.red.weapon, 250, 400.0)
            Player.Functions.RemoveItem("goldenradio", 1)
            startCoolDown(45)
        else
            TriggerClientEvent('QBCore:Notify', source, 'Not Able to connect to columbian Mafia')    
        end   
    else
        TriggerClientEvent('Z3MO-Gunheist:notifyOwner', source)
    end  
end)

function CountCops()
    local amount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.name == "police" or Player.PlayerData.job.name == "police1" or Player.PlayerData.job.name == "police2" or Player.PlayerData.job.name == "police3" or Player.PlayerData.job.name == "police4" or Player.PlayerData.job.name == "police5" or Player.PlayerData.job.name == "police6" or Player.PlayerData.job.name == "police7" or Player.PlayerData.job.name == "police8") and Player.PlayerData.job.onduty then
                amount = amount + 1
            end
        end
    end
    return amount
end

function startCoolDown(minutes)
    cooldown = minutes * 60 * 1000
    while cooldown > 0 do
        if stopCooldown then
            break
        end
        Citizen.Wait(1000)
        cooldown = cooldown - 1000
        if cooldown <= 0 then
            cooldown = -1
            inProgress = false
            break
        end
    end
end


RegisterNetEvent('Z3MO-Gunheist:Reward')
AddEventHandler('Z3MO-Gunheist:Reward', function()
    local rand = GUN[math.random(1, #GUN)]
	local Player = QBCore.Functions.GetPlayer(source)   
    Player.Functions.AddItem(rand, 1)
end)
