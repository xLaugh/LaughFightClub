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
                
                if IsControlJustReleased(0, 38) then -- E pour ouvrir le menu
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

-- Fonction d'aide manquante
function DisplayHelpText(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, 0, 1, -1)
end

-- Ajout de la boucle de mise à jour de la santé
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if fightActive then
            UpdatePlayerHealth()
        end
    end
end)

-- Événements manquants
RegisterNetEvent('fightclub:startWave')
AddEventHandler('fightclub:startWave', function(wave)
    currentWave = wave
    UpdateWaveInfo(wave, 0) -- Initialiser avec 0 PNJs au début de la vague
end)

RegisterNetEvent('fightclub:updateWaveInfo')
AddEventHandler('fightclub:updateWaveInfo', function(data)
    if fightActive then
        currentWave = data.wave
        UpdateWaveInfo(data.wave, data.npcsRemaining)
    end
end)

-- Fonction pour nettoyer les PNJs morts
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

-- Modifier la boucle de mise à jour des PNJs
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
            
            -- Si tous les PNJs sont morts
            if aliveNPCs == 0 and #spawnedNPCs > 0 then
                -- Nettoyer les PNJs morts avant de passer à la vague suivante
                CleanupDeadNPCs()
                CleanupArenaArea() -- Nettoyage supplémentaire de la zone
                TriggerServerEvent('fightclub:waveComplete')
                spawnedNPCs = {} -- Réinitialiser la liste des PNJs
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
    -- Téléporter le joueur au point initial
    SetEntityCoords(PlayerPedId(), registrationPoint.x, registrationPoint.y, registrationPoint.z)
end) 

-- Fonction de gestion des erreurs
function ShowNotification(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(false, false)
end

RegisterNetEvent('fightclub:notification')
AddEventHandler('fightclub:notification', function(message)
    ShowNotification(message)
end) 

-- Ajouter la fonction de téléportation manquante
function TeleportToArena()
    local ped = PlayerPedId()
    SetEntityCoords(ped, arenaPoint.x, arenaPoint.y, arenaPoint.z)
end 

function GetNextSpawnPoint()
    -- Réinitialiser si tous les points ont été utilisés
    if #usedSpawnPoints >= #Config.SpawnPoints then
        usedSpawnPoints = {}
    end
    
    -- Trouver un point non utilisé
    for i, spawnPoint in ipairs(Config.SpawnPoints) do
        if not has_value(usedSpawnPoints, i) then
            table.insert(usedSpawnPoints, i)
            return spawnPoint
        end
    end
    
    -- Fallback au cas où
    return Config.SpawnPoints[1]
end

RegisterNetEvent('fightclub:spawnNPCs')
AddEventHandler('fightclub:spawnNPCs', function(npcsConfig)
    -- Nettoyer les PNJs existants et morts
    CleanupDeadNPCs()
    CleanupArenaArea()
    
    -- Spawn les nouveaux PNJs
    for _, npcConfig in ipairs(npcsConfig) do
        local spawnPoint = GetNextSpawnPoint()
        
        -- Charger le modèle
        local hash = GetHashKey(npcConfig.model)
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Wait(1)
        end
        
        -- Créer le PNJ
        local npc = CreatePed(4, hash, spawnPoint.x, spawnPoint.y, spawnPoint.z, 0.0, true, true)
        table.insert(spawnedNPCs, npc)
        
        -- Configuration de base
        SetPedMaxHealth(npc, npcConfig.health)
        SetEntityHealth(npc, npcConfig.health)
        
        -- Configuration du combat
        SetPedCombatAttributes(npc, 46, true)
        SetPedCombatAttributes(npc, 0, true)
        SetPedCombatAttributes(npc, 5, true)
        SetPedCombatAttributes(npc, 2, true)
        
        -- Comportement agressif
        SetPedRelationshipGroupHash(npc, `HATES_PLAYER`)
        SetPedAiBlip(npc, true)
        TaskCombatPed(npc, PlayerPedId(), 0, 16)
        SetPedKeepTask(npc, true)
        
        -- Armes
        if npcConfig.weapon then
            GiveWeaponToPed(npc, GetHashKey(npcConfig.weapon), 999, false, true)
        end
        
        -- Rendre le PNJ agressif
        SetBlockingOfNonTemporaryEvents(npc, false)
        SetPedCombatRange(npc, 2)
        SetPedCombatMovement(npc, 3)
        SetPedCombatAbility(npc, 100)
        SetPedAccuracy(npc, 60)
        SetPedFiringPattern(npc, 0xC6EE6B4C)
    end
    
    -- Mettre à jour le compteur de PNJs
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

-- Ajouter la boucle de vérification de la mort
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

-- Ajouter l'événement de respawn
RegisterNetEvent('fightclub:respawnPlayer')
AddEventHandler('fightclub:respawnPlayer', function()
    local ped = PlayerPedId()
    
    -- Réanimer le joueur
    NetworkResurrectLocalPlayer(respawnPoint.x, respawnPoint.y, respawnPoint.z, 0.0, true, false)
    SetEntityHealth(ped, 105) -- Donner très peu de vie (5 HP)
    
    -- Réactiver le HUD
    ExecuteCommand('huddisplay')
    
    -- Nettoyer l'UI et les PNJs
    CleanupFight()
end)

-- Ajouter une fonction de nettoyage
function CleanupFight()
    fightActive = false
    currentWave = 0
    
    -- Nettoyer les PNJs
    for _, npc in ipairs(spawnedNPCs) do
        if DoesEntityExist(npc) then
            DeleteEntity(npc)
        end
    end
    spawnedNPCs = {}
    
    -- Cacher l'UI
    SendNUIMessage({
        type = 'hideGame'
    })
end

RegisterNetEvent('fightclub:waitingForPlayer')
AddEventHandler('fightclub:waitingForPlayer', function()
    -- Afficher le message d'attente
    SendNUIMessage({
        type = 'showWaiting'
    })
    -- Activer la souris
    SetNuiFocus(true, true)
end)

RegisterNUICallback('cancelSearch', function(data, cb)
    -- Cacher le message d'attente
    SendNUIMessage({
        type = 'hideWaiting'
    })
    -- Désactiver la souris
    SetNuiFocus(false, false)
    
    -- Informer le serveur
    TriggerServerEvent('fightclub:cancelSearch')
    cb({})
end)

-- S'assurer que la souris est désactivée quand le combat commence
RegisterNetEvent('fightclub:startFight')
AddEventHandler('fightclub:startFight', function()
    SendNUIMessage({
        type = 'hideWaiting'
    })
    SetNuiFocus(false, false)
    -- ... reste du code ...
end)

-- Ajouter la fonction pour fermer le menu
RegisterNUICallback('closeMenu', function(data, cb)
    HideRegistrationMenu()
    SetNuiFocus(false, false)
    cb({})
end)

-- Modifier la fonction ShowRegistrationMenu pour gérer l'échap
function ShowRegistrationMenu()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'showRegistration'
    })
end

-- Modifier la fonction HideRegistrationMenu
function HideRegistrationMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'closeMenu'
    })
end

-- Fonction pour nettoyer la zone
function CleanupArenaArea()
    local centerPoint = vector3(915.08, -1824.06, 24.97)
    local radius = 6.0
    
    -- Récupérer tous les peds dans la zone
    local peds = GetGamePool('CPed')
    for _, ped in ipairs(peds) do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            local pedCoords = GetEntityCoords(ped)
            local distance = #(pedCoords - centerPoint)
            
            -- Si le ped est dans le rayon
            if distance <= radius then
                -- Supprimer le ped
                DeleteEntity(ped)
            end
        end
    end
end

-- Ajouter une fonction pour arrêter le timer
function StopTimer()
    timerActive = false
end