# CurseForge project page (copy/paste)

## Name
FarmBuddy

## Summary
Track your farming sessions: automatic loot capture, profit estimates, session history, mob spawn maps and route planning.

## Description

**FarmBuddy** tracks your farming sessions from start to finish. Start a session, go farm, and FarmBuddy logs everything you loot, estimates how much it is worth and keeps a history of every session so you can compare spots and routes.

### Farming sessions
- Start, pause and stop sessions with a live timer
- Every item you loot is captured automatically during the session
- Live side panel showing collected items and quantities
- Category filters (accordion-style checkboxes) to choose what gets tracked

### Profit estimation
- Market prices from **TradeSkillMaster** (primary) or **Auctionator** (fallback)
- Estimated total value per session

### Session history
- Full history viewer with items, duration and estimated value
- Separate settings and history per character

### Mob map and route planning
- Map of farmable mobs per zone, filterable by profession (Skinning / Tailoring)
- 3D mob portraits on the map, with type icons as fallback
- Mobs are logged automatically from nameplates and mouseover
- Zoom with the mouse wheel and pan with right-click
- **Route Maker**: group mobs into numbered pulls, optimize the pull order and save routes per zone

### GatherMate2 import / export
- Import GatherMate2 node data with a map preview
- Export gathering data as a compressed string

### Usage
- `/farmbuddy` toggles the main window
- Minimap button for quick access

### Languages
Works on any client language. The interface is available in English and Brazilian Portuguese.

### Optional addons
TradeSkillMaster, Auctionator, GatherMate2. None are required.

### Credits
Bundled libraries: LibStub, CallbackHandler-1.0, AceSerializer-3.0, LibDataBroker-1.1, LibDBIcon-1.0, LibDeflate (zlib), LibBase64-1.0 (GPLv3). All credit to their authors.

### License
FarmBuddy is licensed under the GNU GPLv3.

---

**Português (BR):** O FarmBuddy rastreia suas sessões de farm: captura de loot automática, estimativa de lucro (TSM/Auctionator), histórico de sessões, mapa de mobs e planejamento de rotas. Use `/farmbuddy` para abrir.

## Upload checklist
- [ ] Avatar: `media/curseforge-avatar.png` (400x400)
- [ ] Project license: select **GNU General Public License version 3 (GPLv3)**
- [ ] Game version set to the current retail patch
- [ ] Release type and changelog filled in on the file upload (copy from README)
- [ ] At least 2–3 in-game screenshots in the gallery (main window, history, mob map)
- [ ] Zip built with the command from CLAUDE.md (root folder `FarmBuddy/`)
