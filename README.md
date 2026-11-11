# FarmBuddy

World of Warcraft addon for tracking farming sessions, automatically capturing loot and estimating profit.

## Features

- **Farming sessions** — Start, pause and stop sessions with a live timer
- **Automatic loot capture** — Items are automatically logged during the session
- **Category filters** — Accordion-style category checkboxes to filter what gets tracked
- **Profit estimation** — Integrates with TSM and Auctionator for market pricing
- **Session history** — Full history viewer with items, duration and estimated value
- **Per-character profiles** — Each character keeps its own settings and history
- **Localization** — Interface in English and Brazilian Portuguese (follows the game client language)
- **Multi-version** — Runs on Retail, WoW: Forever, MoP Classic, TBC Anniversary and Classic Era from a single package
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
- **Extensions** — Version-specific mob data ships as separate addons (like **FarmBuddy: Forever**), so each client only loads the zones it needs

## Slash Commands

- `/farmbuddy` — Toggle the main window

## Installation

Copy the `FarmBuddy` folder to:

```
World of Warcraft/<game folder>/Interface/AddOns/FarmBuddy
```

Where `<game folder>` is `_retail_`, `_classic_`, `_anniversary_`, `_classic_era_` or the WoW: Forever folder, depending on the version you play.

> The base addon ships the Retail zone mob database. On **WoW: Forever**, install the **FarmBuddy: Forever** extension as well to get the classic zones on the Mob Map.

## Credits

FarmBuddy bundles the following libraries, each under its own license:

- [LibStub](https://www.wowace.com/projects/libstub) — Public Domain
- [CallbackHandler-1.0](https://www.wowace.com/projects/callbackhandler) — Ace3 BSD-style license
- [AceSerializer-3.0](https://www.wowace.com/projects/ace3) — Ace3 BSD-style license
- [LibDataBroker-1.1](https://github.com/tekkub/libdatabroker-1-1) — Public Domain
- [LibDBIcon-1.0](https://www.curseforge.com/wow/addons/libdbicon-1-0) — by funkehdude
- [LibDeflate](https://github.com/SafeteeWoW/LibDeflate) — zlib License
- [LibBase64-1.0](https://www.wowace.com/projects/libbase64-1-0) — GPLv3, by Adirelle

Optional integrations: TradeSkillMaster, Auctionator, GatherMate2.

## License

Copyright (C) 2026 Thallanar

FarmBuddy is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. See [LICENSE](LICENSE) for the full text.

## Changelog

### v1.9.0
- **Extension support** — New public API (`FarmBuddyAPI`) that lets separate addons add mob data to FarmBuddy. Version-specific data no longer needs to ship with the base addon, keeping Retail light
- **FarmBuddy: Forever** — First extension, released as its own project: classic zone mob database for WoW: Forever

### v1.8.1
- **Fix: history values changing after AH scans** — Completed sessions now store each item's price at the moment the session ends, so new Auction House scans no longer change the gold value of past sessions. This makes it possible to compare how much was farmed between sessions. Sessions saved before this version are frozen once, using the prices at the first login after the update

### v1.8.0
- **Classic & Forever support** — FarmBuddy now loads on WoW: Forever, MoP Classic, TBC Anniversary and Classic Era, in addition to Retail, using a multi-version TOC
- **Retail interface bump** — TOC updated to the current Retail patch so the addon is no longer flagged as out of date
- **Compatibility fix** — Import Manager checkboxes now use a template available on every game version
