# FarmBuddy

World of Warcraft addon for tracking farming sessions, automatically capturing loot and estimating profit.

## Features

- **Farming sessions** — Start, pause and stop sessions with a live timer
- **Automatic loot capture** — Items are automatically logged during the session
- **Category filters** — Accordion-style category checkboxes to filter what gets tracked
- **Profit estimation** — Integrates with TSM and Auctionator for market pricing
- **Session history** — Full history viewer with items, duration and estimated value
- **Per-character profiles** — Each character keeps its own settings and history
- **Minimap button** — Quick access via LibDataBroker + LibDBIcon
- **Import Manager** — Import GatherMate2 data with a map preview
- **Data export** — Export gathering data in a compressed format
- **Mob Map** — Visual map of farmable mobs per zone with filters by profession (Skinning/Tailoring)
- **Mob portraits** — Real 3D mob portraits on the map via displayID tables, with icon fallback by type
- **Real-time tracking** — Automatic mob logging via nameplate and mouseover events
- **Zoom and Pan** — Mouse scroll zoom and right-click pan on the map
- **Species grouping** — One pin per unique mob at the spawn centroid, with a sidebar listing all mobs in the zone
- **Multi-select isolation** — Click sidebar rows to isolate one or more mobs and see all individual spawns
- **Opens on player zone** — The map automatically selects the player's current zone when opened (if registered)
- **Exploration overlay** — Maps rendered with explored textures for full visualization
- **Route Maker (pulls)** — MDT-style route planning: group mobs into numbered pulls, optimize order, save and load routes per zone

## Slash Commands

- `/farmbuddy` — Toggle the main window

## Installation

Copy the `FarmBuddy` folder to:

```
World of Warcraft/_retail_/Interface/AddOns/FarmBuddy
```

## Changelog

### v1.5.0
- **Route Maker** — New MDT-style route planning system for farming routes
- **Pull system** — Group mobs into numbered pulls by clicking individual spawns on the map
- **Pull panel** — Dedicated left-side panel showing all pulls with color-coded bars, mob portraits and delete buttons
- **Pull navigation** — Click any pull in the panel to re-select it for editing
- **Route optimization** — One-click pull order optimization using Nearest Neighbor + 2-opt algorithm
- **Route persistence** — Save, load and delete routes per zone via dropdown
- **Visual feedback** — Colored rings around mobs indicating their pull, lines connecting pull centroids on the map
- **Filter compatibility** — Sidebar mob filtering works during route editing for isolating specific mobs

### v1.4.1
- **New creature types** — Added Aberration, Elemental, Demon, Undead and Giant support to MobTracker
- **Reverse type mapping** — Automatic translation of localized creature types (PT-BR, ES, FR, DE) to English, ensuring correct tracking on any client language
- **DisplayID cleanup** — Removed all mobs with placeholder displayID=0 from Voidstorm and Eversong Woods
- **+150 mobs with real DisplayIDs** — New mobs from Zul'Aman, Harandar and Voidstorm with correct Wowhead displayIDs

### v1.4.0
- **Multi-language support** — Loot categories now use numeric classID/subclassID; works on any WoW client language (PT-BR, EN, ES, etc.)
- **API fallbacks** — `C_AddOns.GetAddOnMetadata`, `C_Item.GetItemInfo` and `C_Item.GetItemInfoInstant` with fallback to globals, preventing crashes across different WoW versions
- **+466 Voidstorm mobs** — Beasts, Aberrations, Elementals and Humanoids extracted from Wowhead
- **MobDisplayIDs refactor** — Table split into per-zone files (Eversong Woods, Zul'Aman, Harandar, Voidstorm)
