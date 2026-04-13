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

### v1.4.1
- **Novos creature types** — Suporte a Aberration, Elemental, Demon, Undead e Giant no MobTracker
- **Mapeamento reverso de tipos** — Tradução automática de creature type localizado (PT-BR, ES, FR, DE) para inglês, garantindo tracking correto em qualquer idioma
- **Limpeza de DisplayIDs** — Removidos todos os mobs com displayID=0 (placeholder) de Voidstorm e Eversong Woods
- **+150 mobs com DisplayIDs reais** — Novos mobs de Zul'Aman, Harandar e Voidstorm com displayIDs corretos do Wowhead

### v1.4.0
- **Compatibilidade multi-idioma** — Categorias de loot agora usam classID/subclassID numéricos; funciona em qualquer idioma do client (PT-BR, EN, ES, etc.)
- **Fallback de APIs** — `C_AddOns.GetAddOnMetadata`, `C_Item.GetItemInfo` e `C_Item.GetItemInfoInstant` com fallback para globals, evitando crash em versões diferentes do WoW
- **+466 mobs de Voidstorm** — Beasts, Aberrations, Elementals e Humanoids extraídos do Wowhead
- **Refatoração de MobDisplayIDs** — Tabela dividida em arquivos por zona (Eversong Woods, Zul'Aman, Harandar, Voidstorm)

### v1.3.2
- **Correção: botão "Limpar seleção"** — O botão limpava a sidebar mas o mapa continuava mostrando os mobs isolados (bug de escopo de variáveis Lua)
- **Área de spawn no hover** — Ao passar o mouse em um pin agrupado, marcadores dourados aparecem nos spawn points reais do mob no mapa
