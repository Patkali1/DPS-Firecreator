-- DPS-Fire MySQL Database Setup
-- Fire Locations Table
-- This table will be created automatically by the resource, but you can also run this manually

CREATE TABLE IF NOT EXISTS `fire_locations` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `x` FLOAT NOT NULL,
    `y` FLOAT NOT NULL,
    `z` FLOAT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Default Fire Spawn Locations
-- Diese Locations werden automatisch beim Resource-Start eingefügt wenn Config.AutoSyncLocations = true ist
-- Du kannst diese Datei aber auch manuell ausführen um die Standard-Locations direkt einzufügen

INSERT INTO `fire_locations` (x, y, z) VALUES
-- Industriegebiet am Hafen
(899.45, -3195.82, 5.9),
(1051.23, -3100.56, 5.9),

-- Mülltonnen in der Innenstadt
(287.12, -1267.45, 29.44),
(-198.34, -1308.87, 31.29),

-- Wohngebiete
(-9.83, -1441.24, 30.89),
(1405.67, -1492.33, 60.68),

-- Grove Street Gebäude
(23.45, -1896.78, 22.96),
(101.23, -1912.34, 21.04),

-- Industriegebiet El Burro Heights
(1215.78, -1389.45, 35.37),
(1198.34, -1323.12, 35.22),

-- Tankstellen (gefährlich!)
(265.05, -1261.30, 29.14),
(1181.48, -330.85, 69.31),

-- Paleto Bay Industriegebiet
(-271.34, 6064.12, 31.46),
(-107.89, 6528.45, 29.78),

-- Sandy Shores
(1961.23, 3749.89, 32.34),
(1985.67, 3053.12, 47.21),

-- Verlassene Gebäude
(-1149.45, -1521.67, 4.36),
(-1087.23, -1673.89, 4.57);
