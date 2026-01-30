Config = {}

-- Admin Permissions
-- Du kannst auch einfach hasPermission = true in server.lua setzen um JEDEM Zugriff zu geben
Config.AdminGroups = {
    'admin',
    'superadmin',
    'god'
}

-- Für ACE Permissions füge in server.cfg hinzu:
-- add_ace group.admin command.fireadmin allow
-- add_principal identifier.steam:STEAMID group.admin

Config.MaxFires = 5
Config.SpawnInterval = 10 * 60000 -- alle 10 Minuten
Config.SpreadInterval = 30        -- Sekunden
Config.WindStrength = 1.0         -- 0.5 ruhig | 2.0 Sturm
Config.AutoSyncLocations = true   -- Automatisch Config-Locations zur Datenbank hinzufügen beim Start


Config.FireClasses = {
    A = { spread = 1.0 }, -- Holz, Müll
    B = { spread = 1.5 }, -- Benzin, Öl
    C = { spread = 2.0 }  -- Gas
}

Config.Extinguish = {
    extinguisher = {
        power = 1.0,
        allowed = { A = true }
    },
    hose = {
        power = 3.0,
        allowed = { A = true, B = true, C = true },
        waterUse = 0.3
    }
}

-- Emergency Dispatch Integration
Config.UseEmergencyDispatch = true
Config.FirefighterJobs = { 'fire', 'firefighter', 'feuerwehr' }
Config.AutoSpawnFires = true -- Automatisches Feuer-Spawning aktivieren/deaktivieren

Config.FireLocations = {
    -- Industriegebiet am Hafen
    vector3(899.45, -3195.82, 5.9),
    vector3(1051.23, -3100.56, 5.9),
    
    -- Mülltonnen in der Innenstadt
    vector3(287.12, -1267.45, 29.44),
    vector3(-198.34, -1308.87, 31.29),
    
    -- Wohngebiete
    vector3(-9.83, -1441.24, 30.89),
    vector3(1405.67, -1492.33, 60.68),
    
    -- Grove Street Gebäude
    vector3(23.45, -1896.78, 22.96),
    vector3(101.23, -1912.34, 21.04),
    
    -- Industriegebiet El Burro Heights
    vector3(1215.78, -1389.45, 35.37),
    vector3(1198.34, -1323.12, 35.22),
    
    -- Tankstellen (gefährlich!)
    vector3(265.05, -1261.30, 29.14),
    vector3(1181.48, -330.85, 69.31),
    
    -- Paleto Bay Industriegebiet
    vector3(-271.34, 6064.12, 31.46),
    vector3(-107.89, 6528.45, 29.78),
    
    -- Sandy Shores
    vector3(1961.23, 3749.89, 32.34),
    vector3(1985.67, 3053.12, 47.21),
    
    -- Verlassene Gebäude
    vector3(-1149.45, -1521.67, 4.36),
    vector3(-1087.23, -1673.89, 4.57)
}
