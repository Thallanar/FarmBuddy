-- =============================================================================
-- FarmBuddy - Tabela de DisplayIDs de Mobs
-- =============================================================================
-- Lookup rápido: npcID → displayID para renderizar portraits no mapa.
-- Dados extraídos do Wowhead. Quando o npcID não está nesta tabela,
-- o addon usa ícone genérico por tipo de criatura (Beast/Humanoid/Dragonkin).
--
-- Cada zona tem seu próprio arquivo em data/MobDisplayIDs_<Zona>.lua
-- que adiciona entries nesta tabela global.
--
-- Para adicionar novos mobs:
--   1. Abra wowhead.com/npc=NPCID
--   2. No model viewer, encontre o displayID
--   3. Adicione a entrada no arquivo da zona correspondente
-- =============================================================================

FarmBuddyMobDisplayIDs = {}
