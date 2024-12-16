local activeFight = {
    active = false,
    players = {},
    npcs = {},
    wave = 0,
    mode = nil,
    waitingForPlayer = false
}

RegisterNetEvent('fightclub:registerPlayer')
AddEventHandler('fightclub:registerPlayer', function(mode)
    local source = source
    
    if has_value(activeFight.players, source) then
        return
    end
    
    if activeFight.active and not activeFight.waitingForPlayer then
        TriggerClientEvent('fightclub:notification', source, "Un combat est déjà en cours!")
        return
    end
    
    if not activeFight.active then
        activeFight.active = true
        activeFight.mode = mode
        activeFight.wave = 0
        activeFight.players = {}
        table.insert(activeFight.players, source)
        
        if mode == 'coop' then
            activeFight.waitingForPlayer = true
            TriggerClientEvent('fightclub:notification', source, "En attente d'un second joueur...")
            TriggerClientEvent('fightclub:waitingForPlayer', source)
        else
            StartFight()
        end
    
    elseif activeFight.waitingForPlayer and mode == 'coop' then
        table.insert(activeFight.players, source)
        activeFight.waitingForPlayer = false
        
        for _, playerId in ipairs(activeFight.players) do
            TriggerClientEvent('fightclub:notification', playerId, "Le second joueur a rejoint! Le combat commence!")
        end
        StartFight()
    end
end)

function SpawnWaveNPCs(wave)
    if wave <= #Config.WaveConfig then
        local config = Config.WaveConfig[wave]
        if #activeFight.players > 0 then
            TriggerClientEvent('fightclub:spawnNPCs', activeFight.players[1], config.npcs)
        end
    end
end

RegisterNetEvent('fightclub:npcSpawned')
AddEventHandler('fightclub:npcSpawned', function(npcNetId)
    table.insert(activeFight.npcs, npcNetId)
end)

function CheckWaveComplete()
    if #activeFight.npcs == 0 then return end
    
    local allDead = true
    for _, npcNetId in ipairs(activeFight.npcs) do
        local npc = NetworkGetEntityFromNetworkId(npcNetId)
        if DoesEntityExist(npc) then
            allDead = false
            break
        end
    end
    
    if allDead then
        CleanupWave()
        activeFight.wave = activeFight.wave + 1
        if activeFight.wave <= #Config.WaveConfig then
            SpawnWaveNPCs(activeFight.wave)
        else
            EndFight(true)
        end
    end
end

function CleanupWave()
    for _, playerId in ipairs(activeFight.players) do
        TriggerClientEvent('fightclub:cleanupNPCs', playerId)
    end
    activeFight.npcs = {}
end

function EndFight(success)
    CleanupWave()
    for _, playerId in ipairs(activeFight.players) do
        TriggerClientEvent('fightclub:endFight', playerId, success)
    end
    activeFight.active = false
    activeFight.players = {}
    activeFight.wave = 0
end

function StartFight()
    if not activeFight.active then return end
    
    activeFight.wave = 0
    activeFight.npcs = {}
    
    for _, playerId in ipairs(activeFight.players) do
        TriggerClientEvent('fightclub:startFight', playerId)
    end
end

function BroadcastToPlayers(eventName, ...)
    for _, playerId in ipairs(activeFight.players) do
        TriggerClientEvent(eventName, playerId, ...)
    end
end

function StartNextWave()
    if not activeFight.active then return end
    
    activeFight.wave = activeFight.wave + 1
    if activeFight.wave <= #Config.WaveConfig then
        BroadcastToPlayers('fightclub:startWave', activeFight.wave)
        
        local config = Config.WaveConfig[activeFight.wave]
        if #activeFight.players > 0 then
            Citizen.Wait(1000)
            TriggerClientEvent('fightclub:spawnNPCs', activeFight.players[1], config.npcs)
            BroadcastToPlayers('fightclub:updateWaveInfo', {
                wave = activeFight.wave,
                npcsRemaining = #config.npcs
            })
        end
    else
        EndFight(true)
    end
end

RegisterNetEvent('fightclub:readyToStart')
AddEventHandler('fightclub:readyToStart', function()
    local source = source
    if activeFight.active and has_value(activeFight.players, source) then
        StartNextWave()
    end
end)

function has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if activeFight.active then
            CheckWaveComplete()
        end
    end
end)

RegisterNetEvent('fightclub:updateNPCCount')
AddEventHandler('fightclub:updateNPCCount', function(count)
    if activeFight.active then
        BroadcastToPlayers('fightclub:updateNPCCount', count)
    end
end)

RegisterNetEvent('fightclub:playerDied')
AddEventHandler('fightclub:playerDied', function()
    local source = source
    if activeFight.active and has_value(activeFight.players, source) then
        EndFight(false)
        TriggerClientEvent('fightclub:respawnPlayer', source)
    end
end)

RegisterNetEvent('fightclub:waveComplete')
AddEventHandler('fightclub:waveComplete', function()
    local source = source
    if activeFight.active and has_value(activeFight.players, source) then
        Citizen.Wait(3000)
        StartNextWave()
    end
end)

AddEventHandler('playerDropped', function()
    local source = source
    if activeFight.active and has_value(activeFight.players, source) then
        if activeFight.mode == 'coop' then
            for _, playerId in ipairs(activeFight.players) do
                if playerId ~= source then
                    TriggerClientEvent('fightclub:notification', playerId, "Votre partenaire s'est déconnecté!")
                end
            end
            EndFight(false)
        end
    end
end)

RegisterNetEvent('fightclub:cancelSearch')
AddEventHandler('fightclub:cancelSearch', function()
    local source = source
    
    if activeFight.waitingForPlayer and has_value(activeFight.players, source) then
        activeFight.active = false
        activeFight.players = {}
        activeFight.wave = 0
        activeFight.mode = nil
        activeFight.waitingForPlayer = false
            
        TriggerClientEvent('fightclub:notification', source, "Recherche annulée!")
    end
end) 
