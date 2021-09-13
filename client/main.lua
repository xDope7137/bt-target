local Entities = {}
local Models = {}
local Zones = {}
local Bones = {}
local XD = nil
local isLogg = false

Citizen.CreateThread(function()
    while XD == nil do
        TriggerEvent("XD:GetObject", function(obj, two) XD = obj isLogg = two  end)    
        Citizen.Wait(200)
    end
end)

Citizen.CreateThread(function()
    RegisterKeyMapping("+playerTarget", "Player Targeting", "keyboard", "LMENU") --Removed Bind System and added standalone version
    RegisterCommand('+playerTarget', playerTargetEnable, false)
    RegisterCommand('-playerTarget', playerTargetDisable, false)
    TriggerEvent("chat:removeSuggestion", "/+playerTarget")
    TriggerEvent("chat:removeSuggestion", "/-playerTarget")

    Wait(2000)
    if isLogg then
        PlayerJob = XD.Functions.GetPlayerData().job
    end
end)

RegisterNetEvent('XD:Client:OnJobUpdate')
AddEventHandler('XD:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('XD:Client:OnPlayerLoaded')
AddEventHandler('XD:Client:OnPlayerLoaded', function()
    PlayerJob = XD.Functions.GetPlayerData().job
end)

function playerTargetEnable()
    print("playerTargetEnable ", success)
    if success then return end
    if exports["progressbar"]:isBusy() then return end
    --if IsPedArmed(PlayerPedId(), 6) then return end
    targetActive = true

    SetInterval(1, 5, function()
		DisableControlAction(0,24,true) -- disable attack
		DisableControlAction(0,25,true) -- disable aim
		DisableControlAction(0,47,true) -- disable weapon
		DisableControlAction(0,58,true) -- disable weapon
		DisableControlAction(0,263,true) -- disable melee
		DisableControlAction(0,264,true) -- disable melee
		DisableControlAction(0,257,true) -- disable melee
		DisableControlAction(0,140,true) -- disable melee
		DisableControlAction(0,141,true) -- disable melee
		DisableControlAction(0,142,true) -- disable melee
		DisableControlAction(0,143,true) -- disable melee
	end)

    SendNUIMessage({response = "openTarget"})
    while targetActive do
                
        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local hit, coords, entity = RayCastGamePlayCamera(20.0)
        local nearestVehicle = GetNearestVehicle()

        if hit == 1 then
            if GetEntityType(entity) ~= 0 then
                for _, entityData in pairs(Entities) do
					if NetworkGetEntityIsNetworked(entity) == 1 and _ == NetworkGetNetworkIdFromEntity(entity) then
						if #(plyCoords - coords) <= Entities[_]["distance"] then
							local options = Entities[_]["options"]
							local send_options = {}
							for l,b in pairs(options) do 
								--if (b.job == nil or b.job == ESX.PlayerData.job.name or b.job[ESX.PlayerData.job.name]) and (b.job == nil or b.job[ESX.PlayerData.job.name] == nil or b.job[ESX.PlayerData.job.name] <= ESX.PlayerData.job.grade) then 
									--if (b.required_item == nil) or (b.required_item and exports['linden_inventory']:CountItems(b.required_item)[b.required_item] > 0) then 
										if b.owner and b.owner == NetworkGetNetworkIdFromEntity(PlayerPedId()) then
											if b.canInteract == nil or b.canInteract() then 
												local slot = #send_options + 1
												send_options[slot] = b
												send_options[slot].entity = entity
											end
										end
									--end
								--end
							end
							success = true
							if success and #send_options > 0 then 
								SendNUIMessage({response = "validTarget", data = send_options})
								while success and targetActive do
									local plyCoords = GetEntityCoords(PlayerPedId())
									local hit, coords, entity = RayCastGamePlayCamera(20.0)
									DisablePlayerFiring(PlayerPedId(), true)
									if (IsControlJustReleased(0, 68) or IsDisabledControlJustReleased(0, 68)) then
										SetNuiFocus(true, true)
										SetCursorLocation(0.5, 0.5)
									end
									if GetEntityType(entity) == 0 or #(plyCoords - coords) > Entities[_]["distance"] then
										success = false
									end
									Citizen.Wait(1)
								end
							end
							SendNUIMessage({response = "leftTarget"})
						end
					end
				end

                for _, model in pairs(Models) do
                    if _ == GetEntityModel(entity) then
                        for k , v in ipairs(Models[_]["job"]) do 
                            if v == "all" or v == PlayerJob.name then
                                if _ == GetEntityModel(entity) then
                                    if #(plyCoords - coords) <= Models[_]["distance"] then
                                        success = true
                                        SendNUIMessage({response = "validTarget", data = Models[_]["options"]})
                                        while success and targetActive do
                                            local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                                            local hit, coords, entity = RayCastGamePlayCamera(20.0)

                                            if (IsControlJustReleased(0, 68) or IsDisabledControlJustReleased(0, 68)) then
                                                SetNuiFocus(true, true)
                                                SetCursorLocation(0.5, 0.5)
                                            end
                                            if GetEntityType(entity) == 0 or #(plyCoords - coords) > Models[_]["distance"] then
                                                success = false
                                            end
                                            Citizen.Wait(1)
                                        end
                                        SendNUIMessage({response = "leftTarget"})
                                    end
                                end
                            end
                        end
                    end
                end
            end

            if nearestVehicle then
                for _, bone in pairs(Bones) do
                    local boneIndex = GetEntityBoneIndexByName(nearestVehicle, _)
                    local bonePos = GetWorldPositionOfEntityBone(nearestVehicle, boneIndex)
                    local distanceToBone = GetDistanceBetweenCoords(bonePos, plyCoords, 1)
                    if #(bonePos - coords) <= Bones[_]["distance"] then
                        for k , v in ipairs(Bones[_]["job"]) do
                            if v == "all" or v == PlayerJob.name then
                                if #(plyCoords - coords) <= Bones[_]["distance"] then
                                    success = true
                                    newOptions = {}
                                    for i, op in ipairs(Bones[_]["options"]) do
                                        table.insert(newOptions,Bones[_]["options"][i])
                                    end
                                    SendNUIMessage({response = "validTarget", data = newOptions})

                                    while success and targetActive do
                                        local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                                        local hit, coords, entity = RayCastGamePlayCamera(7.0)
                                        local boneI = GetEntityBoneIndexByName(nearestVehicle, _)

                                        DisablePlayerFiring(PlayerPedId(), true)

                                        if (IsControlJustReleased(0, 68) or IsDisabledControlJustReleased(0, 68)) then
                                            SetNuiFocus(true, true)
                                            SetCursorLocation(0.5, 0.5)
                                        end

                                        if GetEntityType(entity) == 0 or #(plyCoords - coords) > Bones[_]["distance"] then
                                            success = false
                                        end

                                        Citizen.Wait(1)
                                    end
                                    SendNUIMessage({response = "leftTarget"})
                                end
                            end
                        end
                    end
                end
            end

            for _, zone in pairs(Zones) do
                if Zones[_]:isPointInside(coords) then
                    for k , v in ipairs(Zones[_]["targetoptions"]["job"]) do 
                        if v == "all" or v == PlayerJob.name then
                            if #(plyCoords - Zones[_].center) <= zone["targetoptions"]["distance"] then
                                success = true
                                SendNUIMessage({response = "validTarget", data = Zones[_]["targetoptions"]["options"]})
                                while success and targetActive do
                                    local plyCoords = GetEntityCoords(GetPlayerPed(-1))
                                    local hit, coords, entity = RayCastGamePlayCamera(20.0)

                                    if (IsControlJustReleased(0, 68) or IsDisabledControlJustReleased(0, 68)) then
                                        SetNuiFocus(true, true)
                                        SetCursorLocation(0.5, 0.5)
                                    elseif not Zones[_]:isPointInside(coords) or #(vector3(Zones[_].center.x, Zones[_].center.y, Zones[_].center.z) - plyCoords) > zone.targetoptions.distance then
                                    end
        
                                    if not Zones[_]:isPointInside(coords) or #(plyCoords - Zones[_].center) > zone.targetoptions.distance then
                                        success = false
                                    end
        

                                    Citizen.Wait(1)
                                end
                                SendNUIMessage({response = "leftTarget"})
                            end
                        end
                    end
                end
            end
        end
        Citizen.Wait(250)
    end
end

function playerTargetDisable()
    if success then return end
    targetActive = false
    ClearInterval(1)
    success = false
    targetActive = false
    SetNuiFocus(false, false)
    SendNUIMessage({response = "closeTarget"})
end

RegisterNUICallback('complete', function(data, cb)
    playerTargetEnable()
end)

RegisterNUICallback('selectTarget', function(data, cb)
    success = false
    targetActive = false
    SetNuiFocus(false, false)
    ClearInterval(1)
    if data.event.argument ~= nil then
        if data.event.argument1 ~= nil then
            TriggerEvent(data.event.event, data.event.argument, data.event.argument1)
        else
            TriggerEvent(data.event.event, data.event.argument)
        end
    else
        TriggerEvent(data.event.event)
    end
end)

RegisterNUICallback('closeTarget', function(data, cb)
    success = false
    targetActive = false
    ClearInterval(1)
    SetNuiFocus(false, false)
end)

function GetNearestVehicle()
    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)
    if not (playerCoords and playerPed) then
        return
    end

    local pointB = GetEntityForwardVector(playerPed) * 0.001 + playerCoords

    local shapeTest = StartShapeTestCapsule(playerCoords.x, playerCoords.y, playerCoords.z, pointB.x, pointB.y, pointB.z, 1.0, 10, playerPed, 7)
    local _, hit, _, _, entity = GetShapeTestResult(shapeTest)

    return (hit == 1 and IsEntityAVehicle(entity)) and entity or false
end

function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
    local cameraCoord = GetGameplayCamCoord()
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
    return b, c, e
end

function AddCircleZone(name, center, radius, options, targetoptions)
    Zones[name] = CircleZone:Create(center, radius, options)
    Zones[name].targetoptions = targetoptions
end

function AddBoxZone(name, center, length, width, options, targetoptions)
    if not Zones[name] then
        Zones[name] = BoxZone:Create(center, length, width, options)
        Zones[name].targetoptions = targetoptions
    else
        RemoveZone(name)
        Zones[name] = BoxZone:Create(center, length, width, options)
        Zones[name].targetoptions = targetoptions
    end

    Zones[name]:onPointInOut(PolyZone.getPlayerPosition, function(isPointInside, point)
        if isPointInside then
            XD.Functions.Notify("Use your eye", "error",  5500)
        end
    end)
end

function AddPolyzone(name, points, options, targetoptions)
    Zones[name] = PolyZone:Create(points, options)
    Zones[name].targetoptions = targetoptions
end

function AddTargetModel(models, parameteres)
    for _, model in pairs(models) do
        Models[model] = parameteres
    end
end

function AddTargetBone(bones, parameteres)
    for _, bone in pairs(bones) do
        Bones[bone] = parameteres
    end
end

function AddEntityZone(name, entity, options, targetoptions)
    Zones[name] = EntityZone:Create(entity, options)
    Zones[name].targetoptions = targetoptions
end

function AddTargetEntity(entity, parameteres)
	Entities[entity] = parameteres
end

function RemoveZone(name)
	if not Zones[name] then return end
	if Zones[name].destroy then
		Zones[name]:destroy()
	end

	Zones[name] = nil
end

exports("AddCircleZone", AddCircleZone)

exports("AddBoxZone", AddBoxZone)

exports("AddPolyzone", AddPolyzone)

exports("AddTargetModel", AddTargetModel)

exports("AddTargetBone", AddTargetBone)

exports("AddEntityZone", AddEntityZone)

exports("RemoveZone", RemoveZone)

exports("AddTargetEntity", AddTargetEntity)

RegisterCommand("fixeye", function()
    success = false
    targetActive = false
    SetNuiFocus(false, false)
end)


---------------------------------------------
-- Internal Use
---------------------------------------------
local Intervals = {}
local CreateInterval = function(name, interval, action, clear)
	local self = {interval = interval}
	CreateThread(function()
		local name, action, clear = name, action, clear
		repeat
			action()
			Citizen.Wait(self.interval)
		until self.interval == -1
		if clear then clear() end
		Intervals[name] = nil
	end)
	return self
end

SetInterval = function(name, interval, action, clear)
	if Intervals[name] and interval then Intervals[name].interval = interval
	else
		Intervals[name] = CreateInterval(name, interval, action, clear)
	end
end

ClearInterval = function(name)
	if Intervals[name] then Intervals[name].interval = -1 end
end
---------------------------------------------