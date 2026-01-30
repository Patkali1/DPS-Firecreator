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

    -- Haupt-Feuer mit realistischer Größe
    UseParticleFxAssetNextCall('core')
    FireParticles[id] = StartParticleFxLoopedAtCoord(
        'ent_ray_meth_fires',
        coords.x, coords.y, coords.z,
        0.0, 0.0, 0.0,
        2.0, -- Größerer realistischer Feuer-Effekt
        false, false, false
    )
    SetParticleFxLoopedEvolution(FireParticles[id], 'fire', intensity / 100, false)

    -- Rauch-Effekt (dichter und realistischer)
    UseParticleFxAssetNextCall('core')
    local smoke = StartParticleFxLoopedAtCoord(
        'exp_grd_grenade_smoke',
        coords.x, coords.y, coords.z + 1.0,
        0.0, 0.0, 0.0,
        2.5, -- Mehr Rauch
        false, false, false
    )
    
    -- Zusätzlicher Glut/Funken Effekt
    UseParticleFxAssetNextCall('core')
    local sparks = StartParticleFxLoopedAtCoord(
        'exp_grd_bzgas_smoke',
        coords.x, coords.y, coords.z + 0.5,
        0.0, 0.0, 0.0,
        1.0,
        false, false, false
    )
    
    -- Speichere alle Partikel für späteres Stoppen
    if not FireParticles[id .. '_extra'] then
        FireParticles[id .. '_extra'] = {smoke, sparks}
    end
    
    -- Sound-Effekt für Feuer
    CreateThread(function()
        while FireParticles[id] do
            local playerPos = GetEntityCoords(PlayerPedId())
            local distance = #(playerPos - coords)
            
            if distance < 30.0 then
                PlaySoundFromCoord(-1, "Fire_Crackle", coords.x, coords.y, coords.z, "DLC_AW_Frontend_Sounds", false, 20.0, false)
            end
            Wait(3000)
        end
    end)
end) 


RegisterNetEvent('qb-fire:stopVisual', function(id)
    if FireParticles[id] then
        StopParticleFxLooped(FireParticles[id], false)
        FireParticles[id] = nil
    end
    
    -- Stoppe auch die extra Effekte
    if FireParticles[id .. '_extra'] then
        for _, particle in ipairs(FireParticles[id .. '_extra']) do
            StopParticleFxLooped(particle, false)
        end
        FireParticles[id .. '_extra'] = nil
    end
end)

-- Admin UI
RegisterNetEvent('qb-fire:openAdminUI', function()
    print("^2[DPS-FIRE CLIENT]^7 Event qb-fire:openAdminUI empfangen!")
    print("^2[DPS-FIRE CLIENT]^7 Fordere Locations vom Server an...")
    TriggerServerEvent('qb-fire:getLocations')
end)

RegisterNetEvent('qb-fire:receiveLocations', function(locations, settings)
    print("^2[DPS-FIRE CLIENT]^7 receiveLocations Event empfangen!")
    print("^2[DPS-FIRE CLIENT]^7 Anzahl Locations: " .. #locations)
    print("^2[DPS-FIRE CLIENT]^7 Settings: MaxFires=" .. settings.maxFires)
    
    print("^2[DPS-FIRE CLIENT]^7 Setze NUI Focus...")
    SetNuiFocus(true, true)
    adminUIOpen = true
    
    print("^2[DPS-FIRE CLIENT]^7 Sende NUI Message...")
    SendNUIMessage({
        action = 'open',
        locations = locations,
        settings = settings
    })
    
    print("^2[DPS-FIRE CLIENT]^7 Admin Panel sollte jetzt offen sein! ESC zum Schließen")
end)

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    adminUIOpen = false
    SendNUIMessage({
        action = 'close'
    })
    cb('ok')
end)

CreateThread(function()
    while true do
        Wait(0)
        if adminUIOpen then
            DisableControlAction(0, 322, true)
            if IsDisabledControlJustPressed(0, 322) then
                SetNuiFocus(false, false)
                adminUIOpen = false
                SendNUIMessage({
                    action = 'close'
                })
            end
        end
    end
end)

RegisterNUICallback('addLocation', function(data, cb)
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('qb-fire:addLocation', vector3(coords.x, coords.y, coords.z))
    Wait(100)
    TriggerServerEvent('qb-fire:getLocations')
    cb('ok')
end)

RegisterNUICallback('deleteLocation', function(data, cb)
    TriggerServerEvent('qb-fire:deleteLocation', data.index)
    Wait(100)
    TriggerServerEvent('qb-fire:getLocations')
    cb('ok')
end)

RegisterNUICallback('testFire', function(data, cb)
    TriggerServerEvent('qb-fire:testFire', data.index)
    cb('ok')
end)

RegisterNUICallback('teleportTo', function(data, cb)
    cb('ok')
end)

RegisterNUICallback('saveSettings', function(data, cb)
    TriggerServerEvent('qb-fire:saveSettings', data)
    cb('ok')
end)

RegisterNetEvent('qb-fire:fireAlert', function(data)
    PlaySoundFrontend(-1, "CHECKPOINT_PERFECT", "HUD_MINI_GAME_SOUNDSET", 1)
    
    QBCore.Functions.Notify('🔥 ' .. data.title, 'error', 10000)
    QBCore.Functions.Notify(data.description, 'error', 10000)
    
    SetNewWaypoint(data.coords.x, data.coords.y)
    
    local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipSprite(blip, 436)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("🔥 FEUER")
    EndTextCommandSetBlipName(blip)
    
    SetBlipFlashes(blip, true)
    
    CreateThread(function()
        Wait(300000)
        RemoveBlip(blip)
    end)
end)

local isExtinguishing = false
local lastExtinguish = 0

CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local nearFire = false

        for id, fire in pairs(AllFires) do
            local distance = #(pos - fire.position)
            
            if distance < 10.0 then
                nearFire = true
                
                if distance < 5.0 then
                    SetPedSweat(ped, 100.0)
                end
                
                if distance < 2.0 then
                    ApplyDamageToPed(ped, 1, false)
                end
                
                if distance < 5.0 then
                    local onScreen, _x, _y = World3dToScreen2d(fire.position.x, fire.position.y, fire.position.z + 1.0)
                    if onScreen then
                        SetTextScale(0.35, 0.35)
                        SetTextFont(4)
                        SetTextProportional(1)
                        SetTextColour(255, 100, 0, 215)
                        SetTextEntry("STRING")
                        SetTextCentre(1)
                        AddTextComponentString("🔥 FEUER - " .. math.floor(fire.intensity) .. "%")
                        DrawText(_x, _y)
                    end
                end
            end
            
            if distance < 5.0 then
                local weapon = GetSelectedPedWeapon(ped)
                local currentTime = GetGameTimer()

                if weapon == `WEAPON_FIREEXTINGUISHER` then
                    if distance < 4.0 then
                        SetTextComponentFormat("STRING")
                        AddTextComponentString("~r~Feuer löschen~w~ [~g~Halten~w~]")
                        DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    end
                    
                    if IsPedShooting(ped) and distance < 4.0 then
                        if not isExtinguishing then
                            isExtinguishing = true
                            lastExtinguish = currentTime
                        end
                        
                        if currentTime - lastExtinguish >= 500 then
                            TriggerServerEvent('qb-fire:reduce', id, Config.Extinguish.extinguisher.power)
                            lastExtinguish = currentTime
                            QBCore.Functions.Notify('Feuer wird gelöscht... ' .. math.floor(fire.intensity) .. '%', 'primary', 1000)
                        end
                    else
                        isExtinguishing = false
                    end
                end

                if IsPedUsingScenario(ped, 'WORLD_HUMAN_FIRE_HOSE') and water > 0 and distance < 6.0 then
                    if currentTime - lastExtinguish >= 500 then
                        TriggerServerEvent('qb-fire:reduce', id, Config.Extinguish.hose.power)
                        water = water - Config.Extinguish.hose.waterUse
                        lastExtinguish = currentTime
                        QBCore.Functions.Notify('Feuer wird gelöscht... ' .. math.floor(fire.intensity) .. '% | Wasser: ' .. math.floor(water) .. '%', 'primary', 1000)
                    end
                end
            end
        end
        
        if not nearFire then
            Wait(500)
        end
    end
end)
