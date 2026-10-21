-- Localização do FarmBuddy
-- As chaves são os próprios textos em inglês (idioma padrão).
-- Chave sem tradução retorna ela mesma, então só é preciso registrar
-- os textos de outros idiomas abaixo.

local L = setmetatable({}, {
    __index = function(_, key)
        return key
    end,
})
FarmBuddyL = L

-- Chaves internas que precisam de texto diferente em inglês
L["Quest Itens"] = "Quest Items"

if GetLocale() ~= "ptBR" then
    return
end

-- ============================
-- PORTUGUÊS (BRASIL)
-- ============================

-- Geral
L["Yes"] = "Sim"
L["No"] = "Não"
L["Save"] = "Salvar"
L["Cancel"] = "Cancelar"
L["Close"] = "Fechar"
L["Unknown"] = "Desconhecido"
L["Unknown error"] = "Erro desconhecido"
L["Others"] = "Outros"
L["Map %d"] = "Mapa %d"
L["v%s loaded! Type %s to open."] = "v%s carregado! Digite %s para abrir."
L["Click to toggle the window."] = "Clique para abrir/fechar."

-- Janela principal
L["Start"] = "Iniciar"
L["Pause"] = "Pausar"
L["Resume"] = "Retomar"
L["Stop"] = "Parar"
L["Time: %02d:%02d:%02d"] = "Tempo: %02d:%02d:%02d"
L["Farm History"] = "Histórico de Farm"
L["Import GatherMate2"] = "Importar GatherMate2"
L["Mob Map"] = "Mapa de Mobs"

-- Filtros
L["Filters"] = "Filtros"
L["Select all"] = "Marcar todos"
L["Quest Itens"] = "Quest Itens"

-- Histórico
L["Clear history"] = "Limpar histórico"
L["No sessions recorded."] = "Nenhuma sessão registrada."
L["%s  %s  |  %s  |  %d items"] = "%s  %s  |  %s  |  %d itens"
L["Estimated total:"] = "Total estimado:"
L["Are you sure you want to clear all farm history for this character?"] = "Tem certeza que deseja limpar todo o histórico de farm deste personagem?"

-- Tipos de criatura
L["Beast"] = "Fera"
L["Humanoid"] = "Humanoide"
L["Dragonkin"] = "Draconiano"
L["Aberration"] = "Aberração"
L["Elemental"] = "Elemental"
L["Demon"] = "Demônio"
L["Undead"] = "Morto-vivo"
L["Giant"] = "Gigante"

-- Profissões
L["Skinning"] = "Couraria"
L["Tailoring"] = "Alfaiataria"
L["All"] = "Todos"

-- Tipos de node (singular, usado no mapa)
L["Herb"] = "Erva"
L["Ore"] = "Minério"
L["Fishing"] = "Pesca"
L["Gas"] = "Gás"
L["Treasure"] = "Tesouro"
L["Archaeology"] = "Arqueologia"
L["Wood"] = "Madeira"

-- Tipos de node (plural, usado na seleção de import)
L["Herbs"] = "Ervas"
L["Ores"] = "Minérios"
L["Fish"] = "Peixes"
L["Gases"] = "Gases"
L["Treasures"] = "Tesouros"

-- Import do GatherMate2
L["GatherMate2 (auto-detected)"] = "GatherMate2 (auto-detectado)"
L["GatherMate2 data detected! %d nodes imported automatically. Open the Import Manager to view them."] = "Dados do GatherMate2 detectados! %d nodes importados automaticamente. Abra o Import Manager para visualizar."
L["No GatherMate2 data found. Make sure GatherMate2 and its data packs are installed and enabled."] = "Nenhum dado do GatherMate2 encontrado. Verifique se o GatherMate2 e seus pacotes de dados estão instalados e habilitados."
L["No nodes found for the selected types."] = "Nenhum node encontrado para os tipos selecionados."
L["Empty import string."] = "String de import vazia."
L["%s not found."] = "%s não encontrada."
L["Error decoding Base64: "] = "Erro ao decodificar Base64: "
L["Error decompressing data: "] = "Erro ao descomprimir dados: "
L["Error deserializing data: "] = "Erro ao deserializar dados: "
L["Invalid data format."] = "Formato de dados inválido."
L["Error processing imported data: "] = "Erro ao processar dados importados: "
L["No nodes found in the imported string."] = "Nenhum node encontrado na string importada."
L["Unnamed import"] = "Import sem nome"
L["Import not found."] = "Import não encontrado."
L["Error serializing data: "] = "Erro ao serializar dados: "
L["Error compressing data: "] = "Erro ao comprimir dados: "
L["Error encoding Base64: "] = "Erro ao codificar Base64: "

-- Import Manager
L["Import from GatherMate2"] = "Importar do GatherMate2"
L["Paste String"] = "Colar String"
L["Paste the GatherMate2 export string"] = "Cole a string de exportação do GatherMate2"
L["Process"] = "Processar"
L["Import Name"] = "Nome do Import"
L["Select node types"] = "Selecione os tipos de node"
L["Import"] = "Importar"
L["%d nodes in %d maps"] = "%d nodes em %d mapas"
L["Import '%s' saved successfully!"] = "Import '%s' salvo com sucesso!"
L["Select at least one type."] = "Selecione pelo menos um tipo."
L["Error importing"] = "Erro ao importar"
L["Error processing string"] = "Erro ao processar string"
L["Rename Import"] = "Renomear Import"
L["Export Import"] = "Exportar Import"
L["Error exporting"] = "Erro ao exportar"
L["No saved imports.\nUse the buttons above to import GatherMate2 data."] = "Nenhum import salvo.\nUse os botões acima para importar dados do GatherMate2."
L["Unnamed"] = "Sem nome"
L["%d nodes  |  %d maps  |  %s  |  %s"] = "%d nodes  |  %d mapas  |  %s  |  %s"
L["View Map"] = "Ver Mapa"
L["Rename"] = "Renomear"
L["Export"] = "Exportar"
L["Delete"] = "Excluir"
L["Delete import '%s'?"] = "Excluir import '%s'?"

-- Mapa
L["Map Preview"] = "Preview de Mapa"
L["Mobs in this zone"] = "Mobs nesta zona"
L["Click to isolate (multi)"] = "Clique para isolar (multi)"
L["Clear selection (%d)"] = "Limpar seleção (%d)"
L["Map not available for preview."] = "Mapa não disponível para visualização."
L["Map textures not found."] = "Texturas do mapa não encontradas."
L["Invalid map dimensions."] = "Dimensões do mapa inválidas."
L["Map textures not loaded."] = "Texturas do mapa não carregadas."
L["Tracked"] = "Rastreado"
L["Click = add pull %d  |  Right-click = remove"] = "Clique = add pull %d  |  Direito = remover"
L["Right-click to remove pull"] = "Clique direito para remover pull"
L["%d mobs on this map  |  %d maps total  |  Filter: %s"] = "%d mobs neste mapa  |  %d mapas no total  |  Filtro: %s"
L["%d nodes on this map  |  %d maps total  |  %d nodes total"] = "%d nodes neste mapa  |  %d mapas no total  |  %d nodes total"
L["Use Portraits"] = "Usar Retratos"
L["No mobs available to display."] = "Nenhum mob disponível para exibição."
L["No node data loaded. Use the Import Manager."] = "Nenhum dado de nodes carregado. Use o Import Manager."
L["No maps available for preview."] = "Nenhum mapa disponível para preview."

-- Rotas
L["Route"] = "Rota"
L["Click mobs on the map"] = "Clique nos mobs no mapa"
L["Viewing saved route"] = "Visualizando rota salva"
L["Edit Route"] = "Editar Rota"
L["Next Pull"] = "Próximo Pull"
L["Optimize"] = "Otimizar"
L["Close Route"] = "Fechar Rota"
L["Saved routes"] = "Rotas salvas"
L["No saved routes"] = "Nenhuma rota salva"
L["Created on %s\nFilter: %s\n%d pulls, %d mobs\n\nShift+Click to delete"] = "Criada em %s\nFiltro: %s\n%d pulls, %d mobs\n\nShift+Clique para deletar"
L["Route edit mode. Click mobs to add them to the current pull."] = "Modo edição de rota. Clique nos mobs para adicionar ao pull atual."
L["Pull #%d active."] = "Pull #%d ativo."
L["Add at least 1 mob to the current pull before moving on."] = "Adicione pelo menos 1 mob ao pull atual antes de avançar."
L["Pulls reordered! Optimized distance: %.1f"] = "Pulls reordenados! Distância otimizada: %.1f"
L["Route \"%s\" saved! (%d pulls, %d mobs)"] = "Rota \"%s\" salva! (%d pulls, %d mobs)"
