# DPS-Fire Admin UI & Emergency Dispatch Integration

## 🔥 Features

### Admin UI System
- **Feuer-Spawn-Punkte verwalten**: Füge neue Spawn-Punkte hinzu, lösche sie oder teleportiere dich zu ihnen
- **Test-Feuer starten**: Teste jeden Spawn-Punkt ohne auf das automatische System zu warten
- **Einstellungen anpassen**: Ändere Max-Feuer, Spawn-Intervall, Ausbreitungs-Rate und Windstärke
- **Echtzeit-Updates**: Alle Änderungen werden sofort übernommen

### Emergency Dispatch Integration
- **Automatische Benachrichtigungen**: Feuerwehrleute erhalten automatisch Alarmierungen wenn ein Feuer ausbricht
- **GPS-Markierung**: Automatische Wegpunkt-Setzung zum Feuer-Standort
- **Blip-System**: Feuer werden mit blinkenden Blips auf der Karte markiert
- **Job-Filter**: Nur Spieler mit Feuerwehr-Jobs erhalten die Alarmierungen

## 📋 Installation

### 1. Dateien überprüfen
Die folgenden Dateien wurden erstellt/aktualisiert:
- `[mods]/DPS-Fire/html/admin.html` (NEU)
- `[mods]/DPS-Fire/client.lua` (AKTUALISIERT)
- `[mods]/DPS-Fire/server.lua` (AKTUALISIERT)
- `[mods]/DPS-Fire/config.lua` (AKTUALISIERT)
- `[mods]/DPS-Fire/fxmanifest.lua` (AKTUALISIERT)

### 2. Server neu starten
```bash
restart DPS-Fire
```

## 🎮 Verwendung

### Admin-Befehle

#### Fire Admin Panel öffnen
```
/fireadmin
```
**Berechtigung:** Admin, Superadmin oder God

### Admin UI Funktionen

#### 1. Spawn-Punkt hinzufügen
1. Gehe zur gewünschten Position
2. Öffne `/fireadmin`
3. Klicke auf "➕ Aktuelle Position als Spawn-Punkt hinzufügen"

#### 2. Spawn-Punkt testen
- Klicke auf "🔥 Test" beim gewünschten Spawn-Punkt
- Ein Feuer wird sofort gestartet (ohne Emergency Dispatch Benachrichtigung)

#### 3. Zu Spawn-Punkt teleportieren
- Klicke auf "📍 TP" um dich zum Spawn-Punkt zu teleportieren

#### 4. Spawn-Punkt löschen
- Klicke auf "🗑️" um den Spawn-Punkt zu entfernen

#### 5. Einstellungen ändern
- **Max. Feuer gleichzeitig**: 1-20 (Standard: 5)
- **Spawn-Intervall**: 1-60 Minuten (Standard: 10)
- **Ausbreitungs-Intervall**: 10-120 Sekunden (Standard: 30)
- **Windstärke**: 0.5-2.0 (Standard: 1.0)
  - 0.5 = Ruhig, langsame Ausbreitung
  - 1.0 = Normal
  - 2.0 = Sturm, schnelle Ausbreitung

Klicke auf "💾 Einstellungen speichern" um die Änderungen zu übernehmen.

## 🚒 Feuerwehr-Integration

### Emergency Dispatch
Wenn ein Feuer ausbricht, erhalten alle Feuerwehrleute automatisch:

1. **Sound-Alarm**: Checkpoint-Sound wird abgespielt
2. **Benachrichtigungen**: 
   - Titel: "🔥 FEUERALARM"
   - Beschreibung: Details zur Feuer-Klasse
3. **GPS-Wegpunkt**: Automatische Route zum Feuer
4. **Blip auf der Karte**: 
   - Roter, blinkender Blip
   - Beschriftung: "🔥 FEUER"
   - Verschwindet nach 5 Minuten

### Feuer-Klassen
- **Klasse A**: Gebäudebrand (Holz/Papier)
- **Klasse B**: Flüssigkeitsbrand (Benzin/Öl)
- **Klasse C**: Gasbrand

### Feuerwehr-Jobs konfigurieren
In `config.lua`:
```lua
Config.FirefighterJobs = { 'fire', 'firefighter', 'feuerwehr' }
```

## ⚙️ Konfiguration

### config.lua

```lua
-- Admin-Berechtigungen
Config.AdminGroups = {
    'admin',
    'superadmin',
    'god'
}

-- Emergency Dispatch
Config.UseEmergencyDispatch = true
Config.FirefighterJobs = { 'fire', 'firefighter', 'feuerwehr' }

-- Feuer-Einstellungen
Config.MaxFires = 5
Config.SpawnInterval = 10 * 60000  -- Millisekunden
Config.SpreadInterval = 30         -- Sekunden
Config.WindStrength = 1.0

-- Feuer-Spawn-Punkte
Config.FireLocations = {
    vector3(215.7, -1643.5, 29.8),
    vector3(1200.3, -1460.2, 34.8),
    -- Weitere Punkte über Admin UI hinzufügen
}
```

## 🔧 Troubleshooting

### Admin UI öffnet sich nicht
1. Prüfe ob du die richtige Berechtigung hast (Admin/Superadmin/God)
2. Stelle sicher, dass `html/admin.html` existiert
3. Prüfe F8 Console auf Fehler
4. `restart DPS-Fire`

### Keine Benachrichtigungen für Feuerwehrleute
1. Prüfe ob `Config.UseEmergencyDispatch = true` ist
2. Stelle sicher, dass der Job-Name in `Config.FirefighterJobs` eingetragen ist
3. Prüfe ob emergencydispatch läuft: `ensure emergencydispatch`

### Feuer erscheinen nicht
1. Prüfe ob Spawn-Punkte konfiguriert sind (`/fireadmin`)
2. Stelle sicher, dass `Config.MaxFires > 0` ist
3. Prüfe das Spawn-Intervall
4. Schaue in die F8 Console nach Fehlern

### Blips werden nicht angezeigt
Das ist normal! Wenn du den `blip-deactivator` aktiviert hast, werden Job-Blips deaktiviert.
Die Feuer-Blips für Feuerwehrleute sollten trotzdem funktionieren, da sie direkt mit `AddBlipForCoord` erstellt werden.

## 📊 Event-Dokumentation

### Server Events

#### emergencydispatch:server:fireAlert
Wird ausgelöst wenn ein Feuer startet
```lua
TriggerEvent('emergencydispatch:server:fireAlert', {
    coords = vector3(x, y, z),
    title = '🔥 FEUERALARM',
    description = 'Beschreibung',
    class = 'A/B/C',
    jobs = {'fire', 'firefighter'}
})
```

#### emergencydispatch:server:fireExtinguished
Wird ausgelöst wenn ein Feuer gelöscht wurde
```lua
TriggerEvent('emergencydispatch:server:fireExtinguished', {
    title = '✅ FEUER GELÖSCHT',
    description = 'Beschreibung',
    jobs = {'fire', 'firefighter'}
})
```

### Client Events

#### qb-fire:fireAlert
Empfängt Feuer-Alarm für Feuerwehrleute
```lua
RegisterNetEvent('qb-fire:fireAlert', function(data)
    -- data.coords, data.title, data.description, data.class
end)
```

## 🎯 Best Practices

1. **Spawn-Punkte**: Setze 5-10 realistische Spawn-Punkte in verschiedenen Stadt-Bereichen
2. **Spawn-Intervall**: 10-15 Minuten sind ein guter Startwert
3. **Max-Feuer**: Beginne mit 3-5 gleichzeitigen Feuern
4. **Windstärke**: Passe dies je nach gewünschtem Schwierigkeitsgrad an

## 📝 Changelog

### Version 2.0.0
- ✅ Admin UI System implementiert
- ✅ Emergency Dispatch Integration hinzugefügt
- ✅ Automatische Benachrichtigungen für Feuerwehrleute
- ✅ GPS-Wegpunkte und Blips für Feuer
- ✅ Spawn-Punkt Management über UI
- ✅ Echtzeit-Einstellungsänderungen
- ✅ Test-Feuer Funktion
- ✅ Teleport-zu-Spawn-Punkt Funktion

## 🆘 Support

Bei Problemen oder Fragen:
1. Prüfe diese Dokumentation
2. Schaue in die F8 Console nach Fehlern
3. Prüfe die Server-Console
4. Stelle sicher, dass alle Dependencies laufen (qb-core, emergencydispatch)

---

**Viel Erfolg beim Brände bekämpfen! 🚒🔥**
