local QBCore = exports['qb-core']:GetCoreObject()
-- QBCore = nil
local Busy = false

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(5)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
    QBCore.Functions.TriggerCallback('qb-tacos:server:GetConfig', function(config)
        Config = config
    end)
end)

-- Code
Citizen.CreateThread(function()
	while true do 
		local sleep = 2500
		 	for k,v in pairs(Config.JobData['locations']) do
		  	local Positie = GetEntityCoords(PlayerPedId(), false)
		  	local Area = GetDistanceBetweenCoords(Positie.x, Positie.y, Positie.z, Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z, true)
		   	if Area <= 2.5 then
				if Config.JobData['locations'][k]['name'] == 'Shell' then
					DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Prepare Taco')
				elseif Config.JobData['locations'][k]['name'] == 'GiveTaco' then
					DrawText3D(Config.JobData['locations'][k].x, Config.JobData['locations'][k].y, Config.JobData['locations'][k].z + 0.15, '~g~E~s~ - Deliver Taco')
				end	
				if IsControlJustPressed(0, 38) then
				  	if not Busy then
						if Config.JobData['locations'][k]['name'] == 'Shell' then
							QBCore.Functions.TriggerCallback('qb-taco:server:get:ingredient', function(HasItems)  
                        	if HasItems then
								FinishTaco()
							else
								QBCore.Functions.Notify("You don\'t have all the Ingredients yet..", "error")
							end
							end)
						elseif Config.JobData['locations'][k]['name'] == 'GiveTaco' then
							GiveTacoToShop()
						 	end
					 	else
						QBCore.Functions.Notify("You're still working on something man bro..", "error")
					end
				end
				sleep = 5
			end
		end
		Citizen.Wait(sleep)
	end
end)

-- functions

function FinishTaco()
	Busy = true
	TriggerEvent('inventory:client:busy:status', true)
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "wave", 3.2)
	QBCore.Functions.Progressbar("pickup_sla", "Making taco..", 3500, false, true, {
		disableMovement = true,
		disableCarMovement = false,
		disableMouse = false,
		disableCombat = false,
	}, {
		animDict = "mp_common",
		anim = "givetake1_a",
		flags = 8,
	}, {}, {}, function() -- Done
		Busy = false
		TriggerEvent('inventory:client:busy:status', false)
		TriggerServerEvent('QBCore:Server:RemoveItem', "meat", 1)
		TriggerServerEvent('QBCore:Server:RemoveItem', "lettuce", 1)
		TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["meat"], "remove")
		TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["lettuce"], "remove")
		TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["taco"], "add")
		TriggerServerEvent('QBCore:Server:AddItem', "taco", 1)
		TriggerServerEvent("InteractSound_SV:PlayOnSource", "micro", 0.2)
	end, function()
		TriggerEvent('inventory:client:busy:status', false)
		QBCore.Functions.Notify("Canceled..", "error")
		Busy = false
	end)
end

function GiveTacoToShop()
	QBCore.Functions.TriggerCallback('qb-taco:server:get:tacos', function(HasItem, type)
		if HasItem then
		  	if not IsPedInAnyVehicle(PlayerPedId(), false) then
				if Config.JobData['tacos'] <= 9 then	
					QBCore.Functions.Notify("Taco delivered!", "success")
					Config.JobData['tacos'] = Config.JobData['tacos'] + 1
					TriggerServerEvent('QBCore:Server:RemoveItem', "taco", 1)
					TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items["taco"], "remove")
				else
					QBCore.Functions.Notify("There are still 10 taco\'s that have to be sold. We dont waste food here..", "error")
				end
			end
	    else
			QBCore.Functions.Notify("You dont even have a taco..", "error")
	 	end
	end)
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

Citizen.CreateThread(function()
	local blip = AddBlipForCoord(8.00,-1604.92,29.37)
	SetBlipSprite(blip, 52)
	SetBlipScale(blip, 0.6)
	SetBlipColour(blip, 73)  
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Taco Shop")
    EndTextCommandSetBlipName(blip)
end)