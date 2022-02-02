local QBCore = exports['qb-core']:GetCoreObject()


local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173, ["K"] = 311
}

local PlayerData
-- QBCore = nil
local pilot, aircraft, crate, pickup
local requiredModels = {"ex_prop_adv_case_sm", "cuban800", "s_m_m_pilot_02", "prop_box_wood02a_pu" }
local sessionTime = 0
local task = ''
local policeMessage = {
    "Suspiscious activity reported might be Flare Used At",
}

Citizen.CreateThread(function()
	while QBCore == nil do
		TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('Z3MO-Gunheist:notifyOwner')
AddEventHandler('Z3MO-Gunheist:notifyOwner', function()
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	TriggerEvent('chat:addMessage', {
		args = {"COLUMBIAN RADIO", "Not Able to make contact with columbian Mafia try some other time"}
	})
end)

RegisterNetEvent('Z3MO-Gunheist:drop')
AddEventHandler('Z3MO-Gunheist:drop', function(weapon, ammo, planeSpawnDistance)
	Citizen.CreateThread(function()
		local dropCoords = GetEntityCoords(PlayerPedId())
		RequestWeaponAsset(GetHashKey("weapon_flare")) -- flare won't spawn later in the script if we don't request it right now
		while not HasWeaponAssetLoaded(GetHashKey("weapon_flare")) do
			Citizen.Wait(0)
		end
		Citizen.Wait(100)
		ShootSingleBulletBetweenCoords(dropCoords, dropCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0)
		Citizen.SetTimeout(30000, function()
			QBCore.Functions.Notify('Preparing crate. Our pilot will contact you.', 'primary')
		end)
		Citizen.SetTimeout(60000, function()
			local msg = policeMessage[math.random(1, #policeMessage)]
			local s1 = Citizen.InvokeNative(0x2EB41072B4C1E4C0, dropCoords.x, dropCoords.y, dropCoords.z, Citizen.PointerValueInt(), Citizen.PointerValueInt())
			local streetName = GetStreetNameFromHashKey(s1)
			local streetLabel = streetName
			TriggerServerEvent('police:server:PoliceAlertMessage', msg .. " " .. streetLabel, dropCoords)
		end)
		Citizen.SetTimeout(300000, function()
			for i = 1, #requiredModels do
				RequestModel(GetHashKey(requiredModels[i]))
				while not HasModelLoaded(GetHashKey(requiredModels[i])) do
					Wait(0)
				end
			end
			QBCore.Functions.Notify('PILOT: On my way to the flare signal', 'primary')

			local rHeading = math.random(0, 360) + 0.0
			local planeSpawnDistance = (planeSpawnDistance and tonumber(planeSpawnDistance) + 0.0) or 400.0 -- this defines how far away the plane is spawned
			local theta = (rHeading / 180.0) * 3.14
			local rPlaneSpawn = vector3(dropCoords.x, dropCoords.y, dropCoords.z) - vector3(math.cos(theta) * planeSpawnDistance, math.sin(theta) * planeSpawnDistance, -500.0) -- the plane is spawned at

			local dx = dropCoords.x - rPlaneSpawn.x
			local dy = dropCoords.y - rPlaneSpawn.y
			local heading = GetHeadingFromVector_2d(dx, dy) -- determine plane heading from coordinates

			aircraft = CreateVehicle(GetHashKey("cuban800"), rPlaneSpawn, heading, true, true)
			SetEntityHeading(aircraft, heading)
			SetVehicleDoorsLocked(aircraft, 2)
			SetEntityDynamic(aircraft, true)
			ActivatePhysics(aircraft)
			SetVehicleForwardSpeed(aircraft, 60.0)
			SetHeliBladesFullSpeed(aircraft)
			SetVehicleEngineOn(aircraft, true, true, false)
			ControlLandingGear(aircraft, 3)
			OpenBombBayDoors(aircraft)
			SetEntityProofs(aircraft, true, false, true, false, false, false, false, false)

			pilot = CreatePedInsideVehicle(aircraft, 1, GetHashKey("s_m_m_pilot_02"), -1, true, true)
			SetBlockingOfNonTemporaryEvents(pilot, true)
			SetPedRandomComponentVariation(pilot, false)
			SetPedKeepTask(pilot, true)
			SetPlaneMinHeightAboveTerrain(aircraft, 50)

			TaskVehicleDriveToCoord(pilot, aircraft, vector3(dropCoords.x, dropCoords.y, dropCoords.z) + vector3(0.0, 0.0, 50.0), 60.0, 0, GetHashKey("cuban800"), 262144, 15.0, -1.0) -- to the dropsite, could be replaced with a task sequence

			local droparea = vector2(dropCoords.x, dropCoords.y)
			local planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
			while not IsEntityDead(pilot) and #(planeLocation - droparea) > 5.0 do
				Wait(100)
				planeLocation = vector2(GetEntityCoords(aircraft).x, GetEntityCoords(aircraft).y)
			end
			QBCore.Functions.Notify('PILOT: Keep an eye on the skies. Crate is dropping!', 'primary')
			if IsEntityDead(pilot) then
				do return end
			end

			TaskVehicleDriveToCoord(pilot, aircraft, 0.0, 0.0, 500.0, 60.0, 0, GetHashKey("cuban800"), 262144, -1.0, -1.0)
			SetEntityAsNoLongerNeeded(pilot)
			SetEntityAsNoLongerNeeded(aircraft)

			local crateSpawn = vector3(dropCoords.x, dropCoords.y, GetEntityCoords(aircraft).z - 5.0)

			crate = CreateObject(GetHashKey("prop_box_wood02a_pu"), crateSpawn, true, true, true)
			SetEntityLodDist(crate, 1000)
			ActivatePhysics(crate)
			SetDamping(crate, 2, 0.1)
			SetEntityVelocity(crate, 0.0, 0.0, -0.2)

			local dist = GetEntityHeightAboveGround(crate)
			while dist >= 1 do
				Citizen.Wait(10)
				dist = GetEntityHeightAboveGround(crate)
			end
			local crateCoords = GetEntityCoords(crate)
			QBCore.Functions.Notify('CAUTION: Crate will be autodestroyed if someone else tries to pick it!', 'primary')

			pickup = CreateAmbientPickup(GetHashKey('PICKUP_' .. weapon), crateCoords.x, crateCoords.y, crateCoords.z, 2, ammo, GetHashKey("ex_prop_adv_case_sm"), true, true) -- create the pickup itself, location isn't too important as it'll be later attached properly
			ShootSingleBulletBetweenCoords(crateCoords, crateCoords - vector3(0.0001, 0.0001, 0.0001), 0, false, GetHashKey("weapon_flare"), 0, true, false, -1.0)
			local crateBeacon = StartParticleFxLoopedOnEntity_2("scr_crate_drop_beacon", pickup, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)--1.0, false, false, false)
			SetParticleFxLoopedColour(crateBeacon, 0.8, 0.18, 0.19, false)

			while DoesEntityExist(pickup) do
				Wait(0)
			end

			while DoesObjectOfTypeExistAtCoords(crateCoords, 10.0, GetHashKey("w_am_flare"), true) do
				Wait(0)
				local prop = GetClosestObjectOfType(crateCoords, 10.0, GetHashKey("w_am_flare"), false, false, false)
				RemoveParticleFxFromEntity(prop)
				SetEntityAsMissionEntity(prop, true, true)
				local pickedupx = 0
				if pickedupx == 0 then
					TriggerServerEvent('Z3MO-Gunheist:Reward') 
					pickup = 1
					break
				end
				DeleteObject(prop)
			end

			if DoesBlipExist(blipx) then -- remove the blip, should get removed when the pickup gets picked up anyway, but isn't a bad idea to make sure of it
				RemoveBlip(blipx)
			end

			for i = 1, #requiredModels do
				Wait(0)
				SetModelAsNoLongerNeeded(GetHashKey(requiredModels[i]))
			end
			pickedupx = 0
			RemoveWeaponAsset(GetHashKey("weapon_flare"))
		end)
	end)
end)