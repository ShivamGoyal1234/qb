local QBCore = exports['qb-core']:GetCoreObject()

-- GUI Functions

function MenuOwnedHouses()
    exports['qb-menu']:openMenu({
        {
            header = "Already set houses",
            isMenuHeader = true
        },
        {
            header = "List of houses",
            txt = "Here you can see all houses that are already set",
            params = {
                event = "qb-realestate:client:HouseList"
            }
        },
        {
            header = "Remove Current Blips",
            txt = "",
            params = {
                event = "qb-realestate:client:RemoveBlip"
            }
        },
        {
            header = "Close[x]",
            txt = "",
            params = {
                event = "qb-menu:closeMenu"
            }
        },
    })
end

-- Events

RegisterNetEvent('qb-realestate:client:OpenHouseListMenu', function()
    MenuOwnedHouses()
end)

RegisterNetEvent('qb-realestate:client:RemoveBlip', function()
    RemoveBlip(houseblip)
    ClearGpsPlayerWaypoint()
end)

RegisterNetEvent("qb-realestate:client:HouseList", function()
    QBCore.Functions.TriggerCallback("qb-realestate:server:GetHouses", function(result)
        if result == nil then
            QBCore.Functions.Notify("No houses set", "error", 5000)
        else
            local MenuHouseList = {
                {
                    header = "House list",
                    isMenuHeader = true
                },
            }
            for k, v in pairs(result) do
                label = v.label
                tier = v.tier
                owned = tostring(v.owned)
                price = v.price
                if not tier then
                    tier = "Tier is not set yet"
                end
                if not price then
                    price = "Price is not set yet"
                end
                table.insert(MenuHouseList, {
                    header = label,
                    txt = "Label:"..label.." <br>Owned: "..owned.." | Tier: "..tier.." <br>Price: "..price,
                    params = {
                        event = "qb-realestate:client:HouseOptions",
                        args = v
                    }
                })
            end
            table.insert(MenuHouseList, {
                header = "[<-]Back",
                txt = "",
                params = {
                    event = 'qb-realestate:client:OpenHouseListMenu',
                }
            })
            table.insert(MenuHouseList, {
                header = "Close[x]",
                txt = "",
                params = {
                    event = "qb-menu:closeMenu",
                }
            })
            exports['qb-menu']:openMenu(MenuHouseList)
            
        end
    end)
end)

RegisterNetEvent("qb-realestate:client:HouseOptions", function(data)
    local MenuHouseOptions = {
        {
            header = "House: "..data.label,
            isMenuHeader = true
        },
    }
    table.insert(MenuHouseOptions, {
        header = "Location",
        txt = "Show location of house",
        params = {
            event = "qb-realestate:client:toHouse",
            args = data
        }
    })
    table.insert(MenuHouseOptions, {
        header = "Change tier",
        txt = "Change tier of selected house",
        params = {
            event = "qb-realestate:client:changetier",
            args = data
        }
    })
    table.insert(MenuHouseOptions, {
        header = "Change price",
        txt = "Change price of selected house",
        params = {
            event = "qb-realestate:client:changeprice",
            args = data
        }
    })
    table.insert(MenuHouseOptions, {
        header = "[<-]Back",
        txt = "",
        params = {
            event = 'qb-realestate:client:HouseList',
        }
    })
    table.insert(MenuHouseOptions, {
        header = "Close",
        txt = "",
        params = {
            event = "qb-menu:closeMenu",
        }
    })
    exports['qb-menu']:openMenu(MenuHouseOptions)
end)

RegisterNetEvent('qb-realestate:client:changetier', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = 'Tier change',
        submitText = "Change tier",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'tier',
                text = 'Max. ' ..Config.MaxTier
            }
        }
    })
    if dialog then
        local tier = tonumber(dialog.tier)
        if tier <= Config.MaxTier and tier >= 1 then
            if not dialog.tier then return end
            TriggerServerEvent('qb-realestate:server:changetier', dialog.tier, data.name, data.owned)
            TriggerEvent('qb-realestate:client:HouseOptions', data)
            
        else
            if not dialog.tier then return end
            TriggerEvent('qb-realestate:client:changetier', data)
            QBCore.Functions.Notify('Please enter number smaller then ' ..Config.MaxTier, 'error')
        end
    end
end)

RegisterNetEvent('qb-realestate:client:changeprice', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = 'Price change',
        submitText = "Change price",
        inputs = {
            {
                type = 'number',
                isRequired = true,
                name = 'price',
                text = 'Price'
            }
        }
    })
    if dialog then
        if not dialog.price then return end
        TriggerServerEvent('qb-realestate:server:changeprice', dialog.price, data.name, data.owned)
        TriggerEvent('qb-realestate:client:HouseOptions', data)
    end
end)

RegisterNetEvent('qb-realestate:client:toHouse', function(coords)
    position = json.decode(coords.coords)
    x = position.enter.x
    y = position.enter.y
    z= position.enter.z
    SetNewWaypoint(x, y)
    local coords1 = vector3(x,y,z)
    houseblip = AddBlipForCoord(coords1)
    SetBlipSprite (houseblip, 40)
    SetBlipDisplay(houseblip, 4)
    SetBlipScale  (houseblip, 0.65)
    SetBlipAsShortRange(houseblip, true)
    SetBlipColour(houseblip, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Selected house")
    EndTextCommandSetBlipName(houseblip)
    
end)

