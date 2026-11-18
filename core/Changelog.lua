-- =============================================================================
-- FarmBuddy - Changelog exibido no jogo
-- =============================================================================
-- Mantém as mesmas 3 últimas versões do changelog do README.md (mais nova
-- primeiro). Textos em inglês; traduções em core/Locale.lua.
-- A janela aparece uma única vez depois de cada atualização.
-- =============================================================================

FarmBuddyChangelog = {
    {
        version = "1.10.2",
        notes = {
            { "New logo", "FarmBuddy's own logo on the minimap button and in the addon list (FarmBuddy: Forever too)." },
            { "New Mob Map icon", "The Mob Map button uses a gold map icon that matches the other buttons." },
            { "Tabs polish", "The Timer and Time limit tabs line up with the window edge, sit right under the frame and share their border." },
            { "Fix: minimap icon position", "The minimap button now remembers where you dragged it." },
        },
    },
    {
        version = "1.10.1",
        notes = {
            { "Fix: full gold values", "Estimated value, gold per hour, item prices and history totals now show gold, silver and copper instead of whole gold only." },
            { "Fix: GatherMate2 string import/export", "Pasting or exporting a GatherMate2 string no longer fails with a Base64 error." },
            { "Fix: main window closing by itself", "Pressing ESC or opening the world map no longer closes the main window. Use its close button or /farmbuddy." },
            { "Simpler history", "The history detail no longer shows gold per hour." },
        },
    },
    {
        version = "1.10.0",
        notes = {
            { "New look", "Every window was redesigned in a Blizzard-style frame with clearer spacing. The loot list now lives inside the main window." },
            { "Time limit and free mode", "New Timer and Time limit tabs: set a limit with an alarm and optional auto-stop, or farm in free mode. The mode is locked while a session runs." },
            { "New history", "Sessions grouped by day with a detail panel (duration, items, value, gold per hour and mode). Delete one session or clear all." },
            { "New settings", "Appearance (themes, fonts, scale, opacity), Alerts (alarm sound and channel), searchable Filters and Profiles (copy from another character, export/import string, GatherMate2 imports)." },
            { "What's new window", "This window shows up once after each update. Type /farmbuddy changelog to open it again." },
            { "Fix: main window after /reload", "The main window now stays open after a reload if it was open before." },
        },
    },
}
