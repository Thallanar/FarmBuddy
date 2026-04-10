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
- **Agrupamento por espécie** — 1 pin por mob único no centróide dos spawns, com sidebar listando todos os mobs da zona
- **Seleção múltipla de mobs** — Clique na sidebar para isolar um ou vários mobs e ver todos os spawns individuais
- **Abre na zona do jogador** — Ao abrir o mapa, a zona atual do personagem é selecionada automaticamente (se registrada)
- **Overlay de exploração** — Mapas renderizados com texturas exploradas para visualização completa

## Comandos

- `/farmbuddy` — Abre/fecha a janela principal

## Instalação

Copie a pasta `FarmBuddy` para:
```
World of Warcraft/_retail_/Interface/AddOns/FarmBuddy
```

## Changelog

### v1.3.2
- **Correção: botão "Limpar seleção"** — O botão limpava a sidebar mas o mapa continuava mostrando os mobs isolados (bug de escopo de variáveis Lua)
- **Área de spawn no hover** — Ao passar o mouse em um pin agrupado, marcadores dourados aparecem nos spawn points reais do mob no mapa

### v1.3.1
- **Agrupamento por espécie** — Mapa mostra 1 pin por mob único no centróide dos spawns, reduzindo drasticamente a poluição visual
- **Sidebar de mobs** — Lista lateral com todos os mobs da zona (portrait + nome + count) ordenados por contagem
- **Seleção múltipla para isolar** — Clique em várias rows da sidebar para ver todos os spawns individuais dos mobs escolhidos; botão "Limpar seleção" para resetar
- **Abre na zona do jogador** — Ao abrir o Mob Map, a zona atual do personagem é selecionada automaticamente se estiver registrada
- **Filtro por DisplayIDs registrados** — Apenas mobs com `npcID` na tabela de DisplayIDs são exibidos no mapa
- **Remoção da borda dourada bugada** dos mob pins
- **Limpeza grande:** removidos o modo detalhado (clustering por proximidade), dispersão circular, cluster pins e lógica de re-render por zoom threshold

### v1.3.0
- **Zoom e pan no mapa** — Scroll do mouse para zoom (1x-5x), botão direito para arrastar
- **Clustering inteligente de mobs** — Mobs próximos agrupados com contador; zoom 2x+ expande em portraits únicos com quantidade
- **Overlay de exploração** — Mapas renderizam com texturas exploradas via `C_MapExplorationInfo`
- **+120 mobs** adicionados à tabela de displayIDs (Eversong Woods, Zul'Aman, Harandar, Voidstorm)
- Correção de clipping de portraits fora da área do mapa
- Correção de pins misturados entre modos ícone/portrait
- DisplayID `0` tratado como pendente (fallback para ícone genérico)
