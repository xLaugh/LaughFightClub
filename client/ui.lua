function ShowRegistrationMenu()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'showRegistration'
    })
end

function HideRegistrationMenu()
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'hideRegistration'
    })
end

function ShowGameUI()
    SendNUIMessage({
        type = 'showGame'
    })
end

function UpdateWaveInfo(wave, npcsRemaining)
    SendNUIMessage({
        type = 'updateWave',
        wave = wave,
        npcsRemaining = npcsRemaining
    })
end

function UpdatePlayerHealth()
    local health = GetEntityHealth(PlayerPedId()) - 100
    SendNUIMessage({
        type = 'updateHealth',
        health = health
    })
end

RegisterNUICallback('startSolo', function(data, cb)
    HideRegistrationMenu()
    TriggerServerEvent('fightclub:registerPlayer', 'solo')
    cb({})
end)

RegisterNUICallback('startCoop', function(data, cb)
    HideRegistrationMenu()
    TriggerServerEvent('fightclub:registerPlayer', 'coop')
    cb({})
end) 