local registrationPoint = vector3(927.19, -1811.58, 24.97)
local arenaPoint = vector3(915.30, -1814.44, 24.97)
local isInFightClub = false
local currentWave = 0
local fightActive = false
local spawnedNPCs = {}
local respawnPoint = vector3(912.61, -1803.58, 24.97)
local usedSpawnPoints = {}
local timerActive = false

function has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

RegisterNetEvent('fightclub:registerPlayer')
AddEventHandler('fightclub:registerPlayer', function(mode)
    local source = source
    if activeFight.active then
        TriggerClientEvent('fightclub:notification', source, "Un combat est déjà en cours!")
        return
    end

    activeFight.active = true
    activeFight.mode = mode
    activeFight.wave = 0
    table.insert(activeFight.players, source)

    if mode == 'coop' and #activeFight.players < 2 then
        TriggerClientEvent('fightclub:notification', source, "En attente d'un second joueur...")
        return
    end

    StartFight()
end) 

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - registrationPoint)

        if distance < 20.0 then
            DrawMarker(1, registrationPoint.x, registrationPoint.y, registrationPoint.z - 1.0, 
                0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 
                1.5, 1.5, 1.0, 255, 0, 0, 100, 
                false, true, 2, false, nil, nil, false)

            if distance < 1.5 then
                DisplayHelpText("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu")
                
                if IsControlJustReleased(0, 38) then
                    ShowRegistrationMenu()
                end
            end
        end
    end
end)

RegisterNetEvent('fightclub:startFight')
AddEventHandler('fightclub:startFight', function()
    CleanupArenaArea()
    local ped = PlayerPedId()
    SetEntityCoords(ped, arenaPoint.x, arenaPoint.y, arenaPoint.z)
    
    ShowGameUI()
    fightActive = true
    currentWave = 0
    spawnedNPCs = {}
    
    UpdateWaveInfo(0, 0)
    Citizen.Wait(3000)
    TriggerServerEvent('fightclub:readyToStart')
end)

RegisterNetEvent('fightclub:playerDied')
AddEventHandler('fightclub:playerDied', function()
    StopTimer()
    if IsPedDeadOrDying(PlayerPedId()) then
        TriggerServerEvent('fightclub:endFight')
    end
end) 

function DisplayHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if fightActive then
            UpdatePlayerHealth()
        end
    end
end)

RegisterNetEvent('fightclub:startWave')
AddEventHandler('fightclub:startWave', function(wave)
    currentWave = wave
    UpdateWaveInfo(wave, 0)
end)

RegisterNetEvent('fightclub:updateWaveInfo')
AddEventHandler('fightclub:updateWaveInfo', function(data)
    if fightActive then
        currentWave = data.wave
        UpdateWaveInfo(data.wave, data.npcsRemaining)
    end
end)

function CleanupDeadNPCs()
    for i = #spawnedNPCs, 1, -1 do
        local npc = spawnedNPCs[i]
        if DoesEntityExist(npc) then
            if IsEntityDead(npc) then
                DeleteEntity(npc)
                table.remove(spawnedNPCs, i)
            end
        else
            table.remove(spawnedNPCs, i)
        end
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if fightActive and currentWave > 0 then
            local aliveNPCs = 0
            for _, npc in ipairs(spawnedNPCs) do
                if DoesEntityExist(npc) and not IsEntityDead(npc) then
                    aliveNPCs = aliveNPCs + 1
                end
            end
            UpdateWaveInfo(currentWave, aliveNPCs)
            
            if aliveNPCs == 0 and #spawnedNPCs > 0 then
                CleanupDeadNPCs()
                CleanupArenaArea()
                TriggerServerEvent('fightclub:waveComplete')
                spawnedNPCs = {}
            end
        end
    end
end)

RegisterNetEvent('fightclub:updateNPCCount')
AddEventHandler('fightclub:updateNPCCount', function(count)
    if fightActive then
        UpdateWaveInfo(currentWave, count)
    end
end)

RegisterNetEvent('fightclub:endFight')
AddEventHandler('fightclub:endFight', function(success)
    fightActive = false
    SendNUIMessage({
        type = 'hideGame'
    })
    SetEntityCoords(PlayerPedId(), registrationPoint.x, registrationPoint.y, registrationPoint.z)
end) 

function ShowNotification(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end

RegisterNetEvent('fightclub:notification')
AddEventHandler('fightclub:notification', function(message)
    ShowNotification(message)
end) 

function TeleportToArena()
    local ped = PlayerPedId()
    SetEntityCoords(ped, arenaPoint.x, arenaPoint.y, arenaPoint.z)
end 

function GetNextSpawnPoint()
    if #usedSpawnPoints >= #Config.SpawnPoints then
        usedSpawnPoints = {}
    end
    
    for i, spawnPoint in ipairs(Config.SpawnPoints) do
        if not has_value(usedSpawnPoints, i) then
            table.insert(usedSpawnPoints, i)
            return spawnPoint
        end
    end
    
    return Config.SpawnPoints[1]
end

RegisterNetEvent('fightclub:spawnNPCs')
AddEventHandler('fightclub:spawnNPCs', function(npcsConfig)
    CleanupDeadNPCs()
    CleanupArenaArea()
    
    for _, npcConfig in ipairs(npcsConfig) do
        local spawnPoint = GetNextSpawnPoint()
        
        local hash = GetHashKey(npcConfig.model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(1)
        end
        
        local npc = CreatePed(4, hash, spawnPoint.x, spawnPoint.y, spawnPoint.z, 0.0, true, true)
        table.insert(spawnedNPCs, npc)
        
        SetPedMaxHealth(npc, npcConfig.health)
        SetEntityHealth(npc, npcConfig.health)
        
        SetPedCombatAttributes(npc, 46, true)
        SetPedCombatAttributes(npc, 0, true)
        SetPedCombatAttributes(npc, 5, true)
        SetPedCombatAttributes(npc, 2, true)
        
        SetPedRelationshipGroupHash(npc, `HATES_PLAYER`)
        SetPedAiBlip(npc, true)
        TaskCombatPed(npc, PlayerPedId(), 0, 16)
        SetPedKeepTask(npc, true)
        
        if npcConfig.weapon then
            GiveWeaponToPed(npc, GetHashKey(npcConfig.weapon), 999, false, true)
        end
        
        SetBlockingOfNonTemporaryEvents(npc, false)
        SetPedCombatRange(npc, 2)
        SetPedCombatMovement(npc, 3)
        SetPedCombatAbility(npc, 100)
        SetPedAccuracy(npc, 60)
        SetPedFiringPattern(npc, 0xC6EE6B4C)
    end
    
    TriggerServerEvent('fightclub:updateNPCCount', #spawnedNPCs)
end)

RegisterNetEvent('fightclub:cleanupNPCs')
AddEventHandler('fightclub:cleanupNPCs', function()
    for _, npc in ipairs(spawnedNPCs) do
        if DoesEntityExist(npc) then
            DeleteEntity(npc)
        end
    end
    spawnedNPCs = {}
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if fightActive then
            local ped = PlayerPedId()
            if IsEntityDead(ped) then
                fightActive = false
                TriggerServerEvent('fightclub:playerDied')
            end
        end
    end
end)

RegisterNetEvent('fightclub:respawnPlayer')
AddEventHandler('fightclub:respawnPlayer', function()
    local ped = PlayerPedId()
    
    NetworkResurrectLocalPlayer(respawnPoint.x, respawnPoint.y, respawnPoint.z, 0.0, true, false)
    SetEntityHealth(ped, 105)
    
    ExecuteCommand('huddisplay')
    
    CleanupFight()
end)

function CleanupFight()
    fightActive = false
    currentWave = 0
    
    for _, npc in ipairs(spawnedNPCs) do
        if DoesEntityExist(npc) then
            DeleteEntity(npc)
        end
    end
    spawnedNPCs = {}
    
    SendNUIMessage({
        type = 'hideGame'
    })
end

RegisterNetEvent('fightclub:waitingForPlayer')
AddEventHandler('fightclub:waitingForPlayer', function()
    SendNUIMessage({
        type = 'showWaiting'
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('cancelSearch', function(data, cb)
    SendNUIMessage({
        type = 'hideWaiting'
    })
    SetNuiFocus(false, false)
    
    TriggerServerEvent('fightclub:cancelSearch')
    cb({})
end)

RegisterNetEvent('fightclub:startFight')
AddEventHandler('fightclub:startFight', function()
    SendNUIMessage({
        type = 'hideWaiting'
    })
    SetNuiFocus(false, false)
end)

RegisterNUICallback('closeMenu', function(data, cb)
    HideRegistrationMenu()
    SetNuiFocus(false, false)
    cb({})
end)

function ShowRegistrationMenu()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'showRegistration'
    })
end

function HideRegistrationMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'closeMenu'
    })
end

function CleanupArenaArea()
    local centerPoint = vector3(915.08, -1824.06, 24.97)
    local radius = 6.0
    
    local peds = GetGamePool('CPed')
    for _, ped in ipairs(peds) do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            local pedCoords = GetEntityCoords(ped)
            local distance = #(pedCoords - centerPoint)
            
            if distance <= radius then
                DeleteEntity(ped)
            end
        end
    end
end

function StopTimer()
    timerActive = false
end
