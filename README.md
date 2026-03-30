# FarmBuddy

Addon de World of Warcraft para rastrear sessões de farm, capturar loot automaticamente e estimar lucro.

## Features

- **Sessões de farm** — Iniciar, pausar e parar sessões com timer em tempo real
- **Captura automática de loot** — Itens coletados são registrados automaticamente durante a sessão
- **Filtros por categoria** — Accordion de categorias com checkboxes para filtrar o que é rastreado
- **Estimativa de lucro** — Integração com TSM e Auctionator para preços de mercado
- **Histórico de sessões** — Visualizador completo com itens, duração e valor estimado
- **Profiles por personagem** — Cada personagem mantém suas configurações e histórico
- **Ícone no minimapa** — Acesso rápido via LibDataBroker + LibDBIcon
- **Import Manager** — Importação de dados do GatherMate2 com preview no mapa
- **Exportação de dados** — Exportar dados de gathering em formato comprimido
- **Mapa de Mobs** — Visualização de mobs farmáveis no mapa com filtros por profissão (Skinning/Tailoring)
- **Portraits de mobs** — Retrato real dos mobs no mapa via tabela de displayIDs, com fallback de ícone por tipo
- **Tracking em tempo real** — Registro automático de mobs via nameplate e mouseover
- **Zoom e Pan** — Zoom com scroll do mouse e pan com botão direito no mapa
- **Clustering inteligente** — Mobs próximos agrupados com contador; ao dar zoom, expandem em portraits com quantidade
- **Overlay de exploração** — Mapas renderizados com texturas exploradas para visualização completa

## Comandos

- `/farmbuddy` — Abre/fecha a janela principal

## Instalação

Copie a pasta `FarmBuddy` para:
```
World of Warcraft/_retail_/Interface/AddOns/FarmBuddy
```

## Changelog

### v1.3.0
- **Zoom e pan no mapa** — Scroll do mouse para zoom (1x-5x), botão direito para arrastar
- **Clustering inteligente de mobs** — Mobs próximos agrupados com contador; zoom 2x+ expande em portraits únicos com quantidade
- **Overlay de exploração** — Mapas renderizam com texturas exploradas via `C_MapExplorationInfo`
- **+120 mobs** adicionados à tabela de displayIDs (Eversong Woods, Zul'Aman, Harandar, Voidstorm)
- Correção de clipping de portraits fora da área do mapa
- Correção de pins misturados entre modos ícone/portrait
- DisplayID `0` tratado como pendente (fallback para ícone genérico)

### v1.2.0
- Novo sistema de **mob tracking** em tempo real (nameplate + mouseover)
- **Mapa de mobs** com filtros por profissão (Couraria / Alfaiataria)
- **Portraits** de mobs no mapa usando tabela de displayIDs do Wowhead
- Fallback inteligente: ícone por tipo de criatura quando portrait não disponível
- Toggle portrait/ícone no mapa
- Botão de acesso ao mapa de mobs na janela principal
- Agrupamento de mapas por continente no dropdown de zonas

### v1.1.0
- **Import Manager** para dados do GatherMate2
- **Preview de mapa** com texturas reais do jogo e pins de nodes
- **Exportação** de dados de gathering em formato comprimido
- Auto-detecção do GatherMate2 instalado
- Dropdown de zonas agrupado por continente
