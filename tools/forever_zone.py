#!/usr/bin/env python3
# =============================================================================
# FarmBuddy: Forever - Gerador de arquivos de zona
# =============================================================================
# Lê páginas de zona do Wowhead Forever salvas como HTML
# (https://www.wowhead.com/forever/zone=<id>, Ctrl+S "somente HTML") e gera
# FarmBuddy_Forever/data/MobDisplayIDs_<Zona>.lua para cada uma.
#
# Uso (na raiz do repo):
#   python3 -I tools/forever_zone.py *.html
#
# Nome e ID da zona vêm do próprio HTML (<title> e og:url). O continente vem
# da tabela CONTINENTS abaixo; zona desconhecida cai em "Forever".
# A lista de NPCs do Wowhead não traz displayID, então todos saem com 0
# (pendente): o mob passa no gate do MobTracker e usa ícone genérico do tipo.
# Arquivo de zona já existente NÃO é sobrescrito (use --force), para não
# perder displayIDs preenchidos à mão.
# =============================================================================

import json
import os
import re
import sys

REPO = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT_DIR = os.path.join(REPO, 'FarmBuddy_Forever', 'data')

# zoneID (Wowhead) → continente
EASTERN_KINGDOMS = {1, 3, 4, 8, 10, 11, 12, 28, 33, 36, 38, 40, 41, 44, 45, 46, 47, 51, 85, 130, 139, 267}
KALIMDOR = {14, 15, 16, 17, 141, 148, 215, 331, 357, 361, 400, 405, 406, 440, 490, 493, 618, 1377}

def continentOf(zoneID):
    if zoneID in EASTERN_KINGDOMS: return 'Eastern Kingdoms'
    if zoneID in KALIMDOR: return 'Kalimdor'
    return 'Forever'

# Tipos do Wowhead que entram (critter 8, totem 11, pet 12 e uncategorized 10 ficam de fora)
TYPES = {1: 'Beasts', 2: 'Dragonkin', 3: 'Demons', 4: 'Elementals', 5: 'Giants',
         6: 'Undead', 7: 'Humanoids', 9: 'Mechanicals', 15: 'Aberrations'}
ORDER = [1, 7, 3, 4, 5, 6, 2, 9, 15]
CLASSIFICATION = {1: 'Elite', 2: 'Rare-Elite', 3: 'Boss', 4: 'Rare'}
EXCLUDE = {8017}  # Sen'jin Guardian (guarda, reação desconhecida p/ Horda)


def extractListview(html):
    """Extrai o array data da Listview id 'npcs' (casando colchetes, respeitando strings)."""
    i = html.find("id: 'npcs'")
    if i < 0:
        raise ValueError("Listview 'npcs' não encontrada (salvou a página da zona?)")
    j = html.find('data: [', i) + len('data: ')
    depth, k, inString, escape = 0, j, False, False
    while True:
        c = html[k]
        if inString:
            if escape: escape = False
            elif c == '\\': escape = True
            elif c == '"': inString = False
        else:
            if c == '"': inString = True
            elif c == '[': depth += 1
            elif c == ']':
                depth -= 1
                if depth == 0: break
        k += 1
    return json.loads(html[j:k + 1])


def zoneInfo(html):
    title = re.search(r'<title>([^<]+?) - Zone - Forever', html)
    url = re.search(r'wowhead\.com/forever/zone=(\d+)', html)
    if not title or not url:
        raise ValueError('não é uma página de zona do Wowhead Forever')
    return title.group(1).strip(), int(url.group(1))


def keep(npc, zoneID):
    loc = npc.get('location') or []
    if zoneID not in loc or -1 in loc: return False      # fora da zona / evento / pet de classe
    if npc.get('type') not in TYPES: return False
    react = [r for r in (npc.get('react') or []) if r is not None]
    if not react or any(r > 0 for r in react): return False  # amigável a alguma facção
    if npc.get('type') == 7 and 0 in react: return False   # humanoide neutro = NPC de quest/vendor
    return npc['id'] not in EXCLUDE


def render(zone, zoneID, continent, mobs):
    lines = [
        '-- =============================================================================',
        f'-- FarmBuddy: Forever - DisplayIDs: {zone} ({continent})',
        '-- =============================================================================',
        '-- Formato: [npcID] = displayID,  -- Nome do mob[, Rare/Elite]',
        f'-- Fonte: Wowhead Forever (zone={zoneID}). displayID 0 = pendente: o mob aparece',
        '-- no mapa com ícone genérico do tipo até o displayID real ser preenchido.',
        '-- =============================================================================',
        '',
        f'FarmBuddyForever:RegisterZone("{zone}", {{',
    ]
    first = True
    for t in ORDER:
        group = sorted((m for m in mobs if m['type'] == t), key=lambda m: m['name'])
        if not group: continue
        if not first: lines.append('')
        first = False
        lines.append(f'    -- {TYPES[t]}')
        for m in group:
            name = m['name']
            if m.get('classification') in CLASSIFICATION:
                name += ', ' + CLASSIFICATION[m['classification']]
            entry = f"    [{m['id']}] = 0,"
            lines.append(f'{entry:<22}-- {name}')
    lines.append('})')
    return '\n'.join(lines) + '\n'


def main(args):
    force = '--force' in args
    files = [a for a in args if a != '--force']
    if not files:
        print(__doc__ or 'uso: forever_zone.py [--force] arquivo.html ...')
        return 1
    tocLines = {}
    for path in files:
        html = open(path, encoding='utf-8').read()
        zone, zoneID = zoneInfo(html)
        continent = continentOf(zoneID)
        mobs = [n for n in extractListview(html) if keep(n, zoneID)]
        fileName = 'MobDisplayIDs_' + re.sub(r"[^A-Za-z0-9]", '', zone) + '.lua'
        out = os.path.join(OUT_DIR, fileName)
        if os.path.exists(out) and not force:
            print(f'PULADO  {zone}: {fileName} já existe (use --force para sobrescrever)')
            continue
        open(out, 'w', encoding='utf-8').write(render(zone, zoneID, continent, mobs))
        print(f'OK      {zone} (zone={zoneID}, {continent}): {len(mobs)} mobs → {fileName}')
        tocLines.setdefault(continent, []).append('data/' + fileName)
    if tocLines:
        print('\nLinhas para o FarmBuddy_Forever.toc:')
        for continent, lines in tocLines.items():
            print(f'  [{continent}]')
            for l in lines: print('  ' + l)
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
