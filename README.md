# FarmBuddy

World of Warcraft addon for tracking farming sessions, automatically capturing loot and estimating profit.

## Features

- **Farming sessions** — Start, pause and stop sessions with a live timer, item count, estimated value and gold per hour in one window
- **Time limit or free mode** — Set a time limit (hours, minutes, seconds or quick presets) with an alarm and optional auto-stop, or farm in free mode with no limit; elapsed time is always recorded
- **Automatic loot capture** — Items are automatically logged during the session, grouped by category
- **Category filters** — Searchable filters by item type to choose what shows up in the loot list
- **Profit estimation** — Integrates with TSM and Auctionator for market pricing
- **Session history** — Sessions grouped by day, each with duration, items, estimated value, gold per hour and the mode used
- **Themes and fonts** — Blizzard, Dark and Parchment themes, game fonts (plus LibSharedMedia fonts), font size, window scale and background opacity
- **Alarm sounds** — Choose the alarm sound and channel, with a 5-minute warning, on-screen message and taskbar flash
- **Per-character profiles** — Each character keeps its own settings and history; copy settings from another character or move them with an export string
- **Localization** — Interface in English and Brazilian Portuguese (follows the game client language)
- **Multi-version** — Runs on Retail, WoW: Forever, MoP Classic, TBC Anniversary and Classic Era from a single package
- **Minimap button** — Quick access via LibDataBroker + LibDBIcon
- **GatherMate2 import** — Import GatherMate2 data (from its database or an export string) in Settings > Profiles, with a map preview
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
- `/farmbuddy changelog` — Show what's new in this version

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

### v1.10.0

- **New look** — Every window was redesigned in a Blizzard-style frame with clearer spacing; the loot list now lives inside the main window
- **Time limit and free mode** — New Timer and Time limit tabs: set a limit with an alarm and optional auto-stop, or farm in free mode. The mode is locked while a session runs
- **New history** — Sessions grouped by day with a detail panel (duration, items, value, gold per hour, mode); delete one session or clear all
- **New settings** — Appearance (themes, fonts, scale, opacity), Alerts (alarm sound and channel), searchable Filters and Profiles (copy from another character, export/import string, GatherMate2 imports)
- **What's new window** — The changelog shows up once after each update; type `/farmbuddy changelog` to open it again
- **Fix: main window after /reload** — The main window now stays open after a reload if it was open before

### v1.9.0

- **Extension support** — New public API (`FarmBuddyAPI`) that lets separate addons add mob data to FarmBuddy. Version-specific data no longer needs to ship with the base addon, keeping Retail light
- **FarmBuddy: Forever** — First extension, released as its own project: classic zone mob database for WoW: Forever

### v1.8.1

- **Fix: history values changing after AH scans** — Completed sessions now store each item's price at the moment the session ends, so new Auction House scans no longer change the gold value of past sessions. This makes it possible to compare how much was farmed between sessions. Sessions saved before this version are frozen once, using the prices at the first login after the update
