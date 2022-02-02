Framework = nil
Outfits = {}
TriggerEvent(Config.TriggerPrefix .. ':GetObject', function(obj) Framework = obj end)

CreateThread(function()
    Wait(500)
    local fetch = json.decode(LoadResourceFile(GetCurrentResourceName(), "./database.json"))
    if fetch then
        Outfits = fetch
    end
end)

RegisterServerEvent("qb-outfits:server:create")
AddEventHandler("qb-outfits:server:create", function(slot, name, data)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData.citizenid
    local slot = tonumber(slot)
    local char = xPlayer.PlayerData.citizenid

    if not slot then
        return
    end

    if not Outfits[citizenid] then
        print("[Outfits] " .. citizenid .. ' just created.')
        Outfits[citizenid] = {}
    end

    

    if not Outfits[citizenid][slot] then
        Outfits[citizenid][slot] = { name = name, outfit = data }
        TriggerClientEvent("qb-outfits:client:updateUI", src, Outfits[citizenid])
    end

    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Outfits), -1)
end)

RegisterServerEvent("qb-outfits:server:delete")
AddEventHandler("qb-outfits:server:delete", function(slot)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData.citizenid
    local slot = tonumber(slot)

    if not slot then
        return
    end
    
    if not Outfits[citizenid] then
        print("[Outfits] " .. citizenid .. ' just created.')
        Outfits[citizenid] = {}
    end

    if Outfits[citizenid][slot] then
        Outfits[citizenid][slot] = nil
    end

    TriggerClientEvent("qb-outfits:client:updateUI", src, Outfits[citizenid])
    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Outfits), -1)
end)

RegisterServerEvent("qb-outfits:server:use")
AddEventHandler("qb-outfits:server:use", function(slot)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData.citizenid
    local slot = tonumber(slot)

    if not slot then
        return
    end
    
    if not Outfits[citizenid] then
        print("[Outfits] " .. citizenid .. ' just created.')
        Outfits[citizenid] = {}
        TriggerClientEvent("qb-outfits:client:updateUI", src, Outfits[citizenid])
    end

    if Outfits[citizenid][slot] then
        local outfit = Outfits[citizenid][slot]['outfit']
        TriggerClientEvent("qb-outfits:client:SetClothing", src, outfit)
    end

    SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Outfits), -1)
end)

Framework.Commands.Add("outfits", "Outfits Menu", {}, false, function(source, args)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData.citizenid

    if not Outfits[citizenid] then
        print("[Outfits] " .. citizenid .. ' just created.')
        Outfits[citizenid] = {}
        SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Outfits), -1)
    end

    TriggerClientEvent("qb-outfits:client:tryUI", src, Outfits[citizenid])
end)

RegisterNetEvent("qb-outfits:server:openUI")
AddEventHandler("qb-outfits:server:openUI", function(s)
    local src = source
    local xPlayer = Framework.Functions.GetPlayer(src)
    local citizenid = xPlayer.PlayerData.citizenid

    if not Outfits[citizenid] then
        print("[Outfits] " .. citizenid .. ' just created.')
        Outfits[citizenid] = {}
        SaveResourceFile(GetCurrentResourceName(), "./database.json", json.encode(Outfits), -1)
    end

    TriggerClientEvent("qb-outfits:client:tryUI", src, Outfits[citizenid], s)
end)