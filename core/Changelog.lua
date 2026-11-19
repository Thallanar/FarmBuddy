-- =============================================================================
-- FarmBuddy - Changelog exibido no jogo
-- =============================================================================
-- Mantém as mesmas 3 últimas versões do changelog do README.md (mais nova
-- primeiro). Textos em inglês; traduções em core/Locale.lua.
-- A janela aparece uma única vez depois de cada atualização.
-- =============================================================================

FarmBuddyChangelog = {
    {
        version = "1.11.0",
        notes = {
            { "Accurate Skinning and Tailoring filters", "On the Mob Map, mobs can now be marked as skinnable or as dropping cloth, one by one, instead of by creature type. FarmBuddy: Forever 1.1.0 uses this for its zones." },
            { "Both professions in the tooltip", "Mobs that are skinnable and also drop cloth show both professions in the map tooltip." },
        },
    },
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
}
