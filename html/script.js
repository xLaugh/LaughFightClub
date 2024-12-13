let currentHealth = 100;
let isGameActive = false;
let timerInterval = null;
let seconds = 0;

document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeMenu();
    }
});

document.getElementById('close-btn').addEventListener('click', function() {
    closeMenu();
});

function closeMenu() {
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}

window.addEventListener('message', function(event) {
    let data = event.data;

    switch(data.type) {
        case 'showRegistration':
            document.getElementById('registration-menu').classList.remove('hidden');
            break;
        
        case 'hideRegistration':
            document.getElementById('registration-menu').classList.add('hidden');
            break;
            
        case 'showGame':
            document.getElementById('fightclub-container').classList.remove('hidden');
            isGameActive = true;
            startTimer();
            break;
            
        case 'hideGame':
            document.getElementById('fightclub-container').classList.add('hidden');
            isGameActive = false;
            stopTimer();
            break;
            
        case 'updateWave':
            document.getElementById('current-wave').textContent = data.wave;
            document.getElementById('npcs-remaining').textContent = data.npcsRemaining;
            break;
            
        case 'updateHealth':
            updateHealth(data.health);
            break;
            
        case 'showWaiting':
            document.getElementById('waiting-message').classList.remove('hidden');
            break;
            
        case 'hideWaiting':
            document.getElementById('waiting-message').classList.add('hidden');
            break;
            
        case 'closeMenu':
            document.getElementById('registration-menu').classList.add('hidden');
            break;
    }
});

function updateHealth(health) {
    currentHealth = health;
    const healthFill = document.querySelector('.health-fill');
    const healthText = document.querySelector('.health-text');
    
    healthFill.style.width = `${health}%`;
    healthText.textContent = `${Math.round(health)}%`;
    
    // Changer la couleur en fonction de la santé
    if (health > 60) {
        healthFill.style.background = 'linear-gradient(90deg, #2ecc71, #27ae60)';
    } else if (health > 30) {
        healthFill.style.background = 'linear-gradient(90deg, #f1c40f, #f39c12)';
    } else {
        healthFill.style.background = 'linear-gradient(90deg, #e74c3c, #c0392b)';
    }
}

// Gestionnaires d'événements pour les boutons
document.getElementById('solo-btn').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/startSolo`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
});

document.getElementById('coop-btn').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/startCoop`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
});

function startTimer() {
    if (timerInterval) {
        clearInterval(timerInterval);
    }
    seconds = 0;
    updateTimerDisplay();
    timerInterval = setInterval(updateTimer, 1000);
}

function stopTimer() {
    if (timerInterval) {
        clearInterval(timerInterval);
        timerInterval = null;
    }
}

function updateTimer() {
    seconds++;
    updateTimerDisplay();
}

function updateTimerDisplay() {
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    document.getElementById('timer').textContent = 
        `${minutes.toString().padStart(2, '0')}:${remainingSeconds.toString().padStart(2, '0')}`;
}

document.getElementById('cancel-search').addEventListener('click', function() {
    fetch(`https://${GetParentResourceName()}/cancelSearch`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}); 