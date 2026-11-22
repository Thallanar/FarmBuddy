# FarmBuddy: Forever

Extension for FarmBuddy that adds the classic zone mob database for **WoW: Forever**.

FarmBuddy only shows mobs on the Mob Map when they are in its mob database. The base addon ships Retail zones only, so Retail players don't carry classic data they will never use. Install this extension to see the classic zone mobs and their spawns on the Mob Map.

## Requirements

- WoW: Forever client
- FarmBuddy **1.9.0 or newer** (**1.11.0 or newer** for the per-mob Skinning and Tailoring filters)

## Installation

Copy the `FarmBuddy_Forever` folder next to the `FarmBuddy` folder:

```
World of Warcraft/<Forever game folder>/Interface/AddOns/FarmBuddy_Forever
```

## Zones

| Continent | Zones |
|---|---|
| Kalimdor | Teldrassil, Mulgore, Durotar, Darkshore, The Barrens, Ashenvale, Stonetalon Mountains, Thousand Needles, Desolace, Dustwallow Marsh, Tanaris, Azshara, Felwood, Feralas, Silithus, Un'Goro Crater, Winterspring |
| Eastern Kingdoms | Dun Morogh, Elwynn Forest, Tirisfal Glades, Loch Modan, Westfall, Silverpine Forest, Duskwood, Hillsbrad Foothills, Redridge Mountains, Wetlands, Alterac Mountains, Arathi Highlands, Badlands, Stranglethorn Vale, Swamp of Sorrows, Blasted Lands, Burning Steppes, Deadwind Pass, Eastern Plaguelands, Searing Gorge, The Hinterlands, Western Plaguelands |
| New in Forever | Zephras Isle, Riverglades |

Only mobs worth farming are listed: each one is skinnable, drops cloth, or both.

More zones are added in each update.

## Credits

Display IDs and profession data for classic mobs come from the [cMaNGOS classic-db](https://github.com/cmangos/classic-db) (GPLv3), checked against the game's own creature cache. Mobs new to Forever are filled by hand.

## License

GPLv3, same as FarmBuddy.

## Changelog

### v1.1.1
- **All classic zones from level 21 to 60** — 22 new zones: Desolace, Dustwallow Marsh, Tanaris, Azshara, Felwood, Feralas, Silithus, Un'Goro Crater, Winterspring, Alterac Mountains, Arathi Highlands, Badlands, Stranglethorn Vale, Swamp of Sorrows, Blasted Lands, Burning Steppes, Deadwind Pass, Eastern Plaguelands, Searing Gorge, The Hinterlands, Western Plaguelands and Riverglades (41 zones, 2380 mobs)

### v1.1.0
- **All zones up to level 20** — 9 new zones: The Barrens, Ashenvale, Stonetalon Mountains, Thousand Needles, Silverpine Forest, Duskwood, Hillsbrad Foothills, Redridge Mountains and Wetlands (19 zones, 1100 mobs)
- **3D portraits** — Most mobs now show their real portrait on the Mob Map instead of a type icon
- **Accurate Skinning and Tailoring filters** — Each mob says whether it is skinnable or drops cloth, instead of guessing by creature type (needs FarmBuddy 1.11.0)
- **Only farmable mobs** — Mobs that are neither skinnable nor drop cloth were removed from the map

### v1.0.1
- **New icon** — The addon list now shows the FarmBuddy logo
