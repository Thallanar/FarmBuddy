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

## Slash Commands

- `/farmbuddy` — Toggle the main window

## Installation

Copy the `FarmBuddy` folder to:

```
World of Warcraft/<game folder>/Interface/AddOns/FarmBuddy
```

Where `<game folder>` is `_retail_`, `_classic_`, `_anniversary_`, `_classic_era_` or the WoW: Forever folder, depending on the version you play.

> Zone mob data (Mob Map portraits and spawns) currently targets Retail zones; on other versions the map is filled by real-time tracking.

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

### v1.8.0
- **Classic & Forever support** — FarmBuddy now loads on WoW: Forever, MoP Classic, TBC Anniversary and Classic Era, in addition to Retail, using a multi-version TOC
- **Retail interface bump** — TOC updated to the current Retail patch so the addon is no longer flagged as out of date
- **Compatibility fix** — Import Manager checkboxes now use a template available on every game version

### v1.7.0
- **The Coiled Isle** — New zone in the mob database with 343 hostile mobs and real DisplayIDs for 3D portraits on the map (Beasts, Humanoids, Undead, Aberrations, Giants, Elemental and Demon)

### v1.6.0
- **English interface** — All UI text is now in English by default, with a full Brazilian Portuguese translation for ptBR clients
- **Localization system** — New `core/Locale.lua` with automatic fallback to English for untranslated text
- **GPLv3 license** — Project is now licensed under the GNU GPLv3, with credits for all bundled libraries
- **Lighter package** — Icons resized to 256x256, reducing the download from ~3 MB to ~200 KB
- **CurseForge packaging** — English TOC notes, `ptBR` notes and cleaner release zip
