# FarmBuddy

World of Warcraft addon for tracking farming sessions, automatically capturing loot and estimating profit.

## Features

- **Farming sessions** — Start, pause and stop sessions with a live timer, item count, estimated value and gold per hour in one window
- **Time limit or free mode** — Set a time limit (hours, minutes, seconds or quick presets) with an alarm and optional auto-stop, or farm in free mode with no limit; elapsed time is always recorded
- **Automatic loot capture** — Items are automatically logged during the session, grouped by category
- **Category filters** — Searchable filters by item type to choose what shows up in the loot list
- **Profit estimation** — Integrates with TSM and Auctionator for market pricing
- **Session history** — Sessions grouped by day, each with duration, items, estimated value and the mode used
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

### v1.11.0

- **Accurate Skinning and Tailoring filters** — On the Mob Map, mobs can now be marked as skinnable or as dropping cloth, one by one, instead of by creature type; FarmBuddy: Forever 1.1.0 uses this for its zones
- **Both professions in the tooltip** — Mobs that are skinnable and also drop cloth show both professions in the map tooltip

### v1.10.2

- **New logo** — FarmBuddy's own logo on the minimap button and in the addon list (FarmBuddy: Forever too)
- **New Mob Map icon** — The Mob Map button uses a gold map icon that matches the other buttons
- **Tabs polish** — The Timer and Time limit tabs line up with the window edge, sit right under the frame and share their border
- **Fix: minimap icon position** — The minimap button now remembers where you dragged it

### v1.10.1

- **Fix: full gold values** — Estimated value, gold per hour, item prices and history totals now show gold, silver and copper instead of whole gold only
- **Fix: GatherMate2 string import/export** — Pasting or exporting a GatherMate2 string no longer fails with a Base64 error
- **Fix: main window closing by itself** — Pressing ESC or opening the world map no longer closes the main window; use its close button or `/farmbuddy`
- **Simpler history** — The history detail no longer shows gold per hour
