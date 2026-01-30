QBCore = exports['qb-core']:GetCoreObject()
local AllFires = {}
local FireParticles = {}
local water = 100.0
local adminUIOpen = false


RegisterNetEvent('qb-fire:sync', function(data)
    AllFires = data
end)


RegisterNetEvent('qb-fire:startVisual', function(id, coords, intensity)
    RequestNamedPtfxAsset('core')
    while not HasNamedPtfxAssetLoaded('core') do
        Wait(0)
    end

    UseParticleFxAssetNextCall('core')
    FireParticles[id] = StartParticleFxLoopedAtCoord(
        'ent_ray_meth_fires',
        coords.x, coords.y, coords.z,
        0.0, 0.0, 0.0,
        intensity / 50,
        false, false, false
    )


    UseParticleFxAssetNextCall('core')
    StartParticleFxLoopedAtCoord(
        'exp_grd_grenade_smoke',
        coords.x, coords.y, coords.z + 1.5,
        0.0, 0.0, 0.0,
        1.5,
        false, false, false
    )
end) 


RegisterNetEvent('qb-fire:stopVisual', function(id)
    if FireParticles[id] then
        StopParticleFxLooped(FireParticles[id], false)
        FireParticles[id] = nil
    end
end)


CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for id, fire in pairs(AllFires) do
            if #(pos - fire.position) < 3.0 then
                local weapon = GetSelectedPedWeapon(ped)

             
                if weapon == `WEAPON_FIREEXTINGUISHER` then
                    if Config.Extinguish.extinguisher.allowed[fire.class] then
                        TriggerServerEvent(
                            'qb-fire:reduce',
                            id,
                            Config.Extinguish.extinguisher.power
                        )
                    end
                end

                if IsPedUsingScenario(ped, 'WORLD_HUMAN_FIRE_HOSE') and water > 0 then
                    TriggerServerEvent(
                        'qb-fire:reduce',
                        id,
                        Config.Extinguish.hose.power
                    )
                    water -= Config.Extinguish.hose.waterUse
                end
            end
        end
    end
end)
