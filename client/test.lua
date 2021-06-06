
--[[AddBoxZone("PoliceDutySandyPD", vector3(149.84, -1041.2, 29.4), 0.25, 0.5, {
    name="PoliceDutySandyPD",
    heading=341,
    debugPoly=false,
    minZ=29.4,
    maxZ=29.9
}, {
    options = {
        {
            event = "matif_bankui:openUI",
            icon = "fas fa-money-check-alt",
            label = "Open Bank",
        },
    },
    job = {"all"},
    distance = 4.0
})--]]


Citizen.CreateThread(function()
    local peds = {
        `xa21`,
    }
    AddTargetModel(peds, {
        options = {
            {
                event = "veh:doors",
                fuck = 0,
                icon = "fas fa-dumpster",
                label = "Front Left",
            },
            {
                event = "veh:doors",
                fuck = 1,
                icon = "fas fa-dumpster",
                label = "Front Right",
            },
            {
                event = "veh:doors",
                fuck = 2,
                icon = "fas fa-dumpster",
                label = "Random 3",
            },
            {
                event = "veh:doors",
                fuck = 3,
                icon = "fas fa-dumpster",
                label = "Random 4",
            },
        },
        job = {"all"},
        distance = 2.5
    })
end)

RegisterNetEvent('veh:doors')
AddEventHandler('veh:doors', function(doorIndex)
    print('index'..doorIndex)
    doorIndex = tonumber(doorIndex)
    player = GetPlayerPed(-1)
    veh = XD.Functions.GetClosestVehicle()

    if veh ~= 0 then
        -- if doors are unlocked?
        -- if not GetVehicleDoorsLockedForPlayer(veh, player) then
        local lockStatus = GetVehicleDoorLockStatus(veh)
        if lockStatus == 1 or lockStatus == 0 then
            if (GetVehicleDoorAngleRatio(veh, doorIndex) == 0) then
                SetVehicleDoorOpen(veh, doorIndex, false, false)
            else
                SetVehicleDoorShut(veh, doorIndex, false)
            end
        end
    end
end)