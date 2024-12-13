Config = {}

Config.SpawnPoints = {
    vector3(922.52, -1812.75, 24.97),
    vector3(913.00, -1807.36, 24.97),
    vector3(907.39, -1816.83, 24.97),
    vector3(917.07, -1822.24, 24.97),
    vector3(911.96, -1819.03, 24.97),
    vector3(920.94, -1816.83, 24.97),
    vector3(917.60, -1811.03, 24.97),
    vector3(910.68, -1812.61, 24.97),
}

Config.WaveConfig = {
    -- Vague 1: 4 PNJs sans armes, vie basique
    {
        npcs = {
            {model = "s_m_y_dealer_01", health = 150, weapon = nil},
            {model = "s_m_y_dealer_01", health = 150, weapon = nil},
            {model = "s_m_y_robber_01", health = 150, weapon = nil},
            {model = "s_m_y_robber_01", health = 150, weapon = nil}
        }
    },
    -- Vague 2: 5 PNJs sans armes
    {
        npcs = {
            {model = "s_m_y_dealer_01", health = 150, weapon = nil},
            {model = "s_m_y_dealer_01", health = 150, weapon = nil},
            {model = "s_m_y_robber_01", health = 150, weapon = nil},
            {model = "s_m_y_robber_01", health = 150, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 150, weapon = nil}
        }
    },
    -- Vague 3: 5 PNJs, 2 avec couteaux
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 120, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 120, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 120, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 130, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 130, weapon = "WEAPON_KNIFE"}
        }
    },
    -- Vague 4: 6 PNJs, 2 avec battes
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 130, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 130, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 130, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 130, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 140, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 140, weapon = "WEAPON_BAT"}
        }
    },
    -- Vague 5: 6 PNJs, mélange d'armes
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 140, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 140, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 140, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 150, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 150, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 150, weapon = "WEAPON_CROWBAR"}
        }
    },
    -- Vague 6: 7 PNJs
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 150, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 150, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 150, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 160, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 160, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 160, weapon = "WEAPON_CROWBAR"},
            {model = "g_m_y_ballaorig_01", health = 160, weapon = "WEAPON_WRENCH"}
        }
    },
    -- Vague 7: 7 PNJs plus résistants
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 160, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 160, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 160, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 170, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 170, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 170, weapon = "WEAPON_CROWBAR"},
            {model = "g_m_y_ballaorig_01", health = 170, weapon = "WEAPON_POOLCUE"}
        }
    },
    -- Vague 8: 8 PNJs
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 170, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 170, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 170, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 170, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 180, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 180, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 180, weapon = "WEAPON_CROWBAR"},
            {model = "g_m_y_ballaorig_01", health = 180, weapon = "WEAPON_POOLCUE"}
        }
    },
    -- Vagues 9-15 avec difficulté croissante...
    -- Vague 9: 8 PNJs encore plus résistants
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 180, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 180, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 180, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 180, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 190, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 190, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 190, weapon = "WEAPON_CROWBAR"},
            {model = "g_m_y_ballaorig_01", health = 190, weapon = "WEAPON_BATTLEAXE"}
        }
    },
    -- Vague 10: 9 PNJs
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 190, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 190, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 190, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 190, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 200, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 200, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 200, weapon = "WEAPON_CROWBAR"},
            {model = "g_m_y_ballaorig_01", health = 200, weapon = "WEAPON_BATTLEAXE"},
            {model = "g_m_y_ballaorig_01", health = 200, weapon = "WEAPON_POOLCUE"}
        }
    },
    -- Vague 11: 9 PNJs plus forts
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 200, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 200, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 200, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 200, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 210, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 210, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 210, weapon = "WEAPON_CROWBAR"},
            {model = "g_m_y_ballaorig_01", health = 210, weapon = "WEAPON_BATTLEAXE"},
            {model = "g_m_y_ballaorig_01", health = 210, weapon = "WEAPON_GOLFCLUB"}
        }
    },
    -- Vague 12: 10 PNJs
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 210, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 210, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 210, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 210, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 220, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 220, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 220, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 220, weapon = "WEAPON_CROWBAR"},
            {model = "g_m_y_ballaorig_01", health = 220, weapon = "WEAPON_BATTLEAXE"},
            {model = "g_m_y_ballaorig_01", health = 220, weapon = "WEAPON_GOLFCLUB"}
        }
    },
    -- Vague 13: 10 PNJs plus résistants
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 220, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 220, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 220, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 220, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 230, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 230, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 230, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 230, weapon = "WEAPON_CROWBAR"},
            {model = "g_m_y_ballaorig_01", health = 230, weapon = "WEAPON_BATTLEAXE"},
            {model = "g_m_y_ballaorig_01", health = 230, weapon = "WEAPON_GOLFCLUB"}
        }
    },
    -- Vague 14: 11 PNJs
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 230, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 230, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 230, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 230, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 240, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 240, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 240, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 240, weapon = "WEAPON_CROWBAR"},
            {model = "g_m_y_ballaorig_01", health = 240, weapon = "WEAPON_BATTLEAXE"},
            {model = "g_m_y_ballaorig_01", health = 240, weapon = "WEAPON_GOLFCLUB"},
            {model = "g_m_y_ballaorig_01", health = 240, weapon = "WEAPON_POOLCUE"}
        }
    },
    -- Vague 15: Vague finale, 12 PNJs très résistants
    {
        npcs = {
            {model = "g_m_y_ballasout_01", health = 240, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 240, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 240, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 240, weapon = nil},
            {model = "g_m_y_ballasout_01", health = 250, weapon = nil},
            {model = "g_m_y_ballaeast_01", health = 250, weapon = "WEAPON_KNIFE"},
            {model = "g_m_y_ballaeast_01", health = 250, weapon = "WEAPON_BAT"},
            {model = "g_m_y_ballaeast_01", health = 250, weapon = "WEAPON_CROWBAR"},
            {model = "g_m_y_ballaorig_01", health = 250, weapon = "WEAPON_BATTLEAXE"},
            {model = "g_m_y_ballaorig_01", health = 250, weapon = "WEAPON_GOLFCLUB"},
            {model = "g_m_y_ballaorig_01", health = 250, weapon = "WEAPON_POOLCUE"},
            {model = "g_m_y_ballaorig_01", health = 250, weapon = "WEAPON_KNIFE"}
        }
    }
} 