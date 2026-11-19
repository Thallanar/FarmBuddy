#!/usr/bin/env python3
# =============================================================================
# FarmBuddy: Forever - preenche displayIDs a partir do cache local do jogo
# =============================================================================
# O cliente guarda em Cache/WDB/<locale>/creaturecache.wdb a resposta do
# servidor para cada criatura que você já viu (nome, tipo, displayIDs...).
# Este script lê esse cache e grava o displayID real nos arquivos
# FarmBuddy_Forever/data/MobDisplayIDs_*.lua (1º argumento de MobInfo(displayID, profissão)).
#
# Fonte secundária opcional: o banco open source do cMaNGOS (classic-db, GPLv3),
# com npcID → displayID de quase todos os mobs de vanilla 1.12:
#   https://github.com/cmangos/classic-db  (Full_DB/ClassicDB_1_12_1_*.sql.gz)
#
# Uso:
#   python3 -I tools/forever_displayids.py                     # cache da pasta _forever_
#   python3 -I tools/forever_displayids.py a.wdb ...           # caches específicos
#   --cmangos <ClassicDB.sql.gz>                               # usa o cMaNGOS também
#   --dry-run                                                  # só mostra, não grava
#
# Prioridade:
#   * cache do jogo = o que o servidor do Forever manda de verdade, então VENCE:
#     preenche 0 e também corrige valor diferente (cada correção é listada).
#     Alguns mobs ganharam modelo novo no Forever que o cMaNGOS não conhece.
#   * cMaNGOS só preenche o que ainda está 0 (nunca sobrescreve).
#   * Mobs exclusivos do Forever (npcIDs novos) só vêm do cache ou à mão.
# Mobs com mais de um modelo usam o de maior probabilidade (cache) ou o 1º (cMaNGOS).
#
# Formato do registro (WDB "BOMW", versão 4, cliente 1.16 Forever):
#   header 24 bytes; registros = npcID u32, tamanho u32, dados:
#   15 bytes de bits (Title 11, TitleAlt 11, CursorName 6, 1 bit,
#   8x tamanhos de nome 11 bits), strings dos nomes, 26 bytes (flags, tipo,
#   família, classificação...), contagem u32, probabilidade total f32,
#   contagem x (displayID u32, escala f32, probabilidade f32).
# =============================================================================

import glob
import gzip
import os
import re
import struct
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.join(ROOT, 'FarmBuddy_Forever', 'data')
GAME_WDB = '/mnt/thallanar/D008CCF508CCDC1A/Arquivos de Programas (x86)/World of Warcraft/_forever_/Cache/WDB'


def readBits(data):
    for b in data:
        for i in range(7, -1, -1):
            yield (b >> i) & 1


def takeBits(it, n):
    v = 0
    for _ in range(n):
        v = (v << 1) | next(it)
    return v


def parseCache(path):
    """Retorna {npcID: (nome, displayID)} de um creaturecache.wdb."""
    d = open(path, 'rb').read()
    if d[:4] != b'BOMW':
        raise ValueError(f'{path}: não é um creaturecache.wdb')
    version = struct.unpack_from('<I', d, 16)[0]
    if version != 4:
        raise ValueError(f'{path}: versão {version} do WDB não suportada (esperado 4)')
    out = {}
    off = 24
    while off + 8 <= len(d):
        npcID, size = struct.unpack_from('<II', d, off)
        if size == 0:
            break
        rec = d[off + 8: off + 8 + size]
        off += 8 + size
        it = readBits(rec[:15])
        takeBits(it, 11); takeBits(it, 11); takeBits(it, 6); takeBits(it, 1)
        lens = [takeBits(it, 11) for _ in range(8)]
        name = rec[15: 15 + max(lens[0] - 1, 0)].decode('utf-8', 'replace')
        p = 15 + sum(lens) + 26
        count = struct.unpack_from('<I', rec, p)[0]
        if not 1 <= count <= 8 or p + 8 + 12 * count > len(rec):
            continue
        displays = [struct.unpack_from('<Iff', rec, p + 8 + 12 * i) for i in range(count)]
        best = max(displays, key=lambda x: x[2])  # maior probabilidade (empate = primeiro)
        if best[0] > 0:
            out[npcID] = (name, best[0])
    return out


def parseCmangos(path):
    """Retorna {npcID: (nome, displayID)} da creature_template do dump do cMaNGOS."""
    tup = re.compile(r"\((\d+),'((?:[^'\\]|\\.)*)',(?:NULL|'(?:[^'\\]|\\.)*'),\d+,\d+,(\d+),(\d+),(\d+),(\d+),")
    out = {}
    with gzip.open(path, 'rt', encoding='utf-8', errors='replace') as f:
        for line in f:
            if not line.startswith('INSERT INTO `creature_template` '):
                continue
            for m in tup.finditer(line):
                models = [int(m.group(i)) for i in range(3, 7) if m.group(i) != '0']
                if models:
                    out[int(m.group(1))] = (re.sub(r'\\(.)', r'\1', m.group(2)), models[0])
    return out


def main(args):
    dryRun = '--dry-run' in args
    cmangosPath = None
    paths = []
    it = iter(args)
    for a in it:
        if a == '--dry-run':
            continue
        if a == '--cmangos':
            cmangosPath = next(it, None)
            continue
        paths.append(a)
    paths = paths or glob.glob(os.path.join(GAME_WDB, '*', 'creaturecache.wdb'))
    if not paths and not cmangosPath:
        print('Nenhum creaturecache.wdb encontrado (a partição do jogo está montada?)')
        return 1

    cache = {}
    for path in paths:
        cache.update(parseCache(path))
    print(f'{len(cache)} criaturas no cache do jogo')
    cmangos = parseCmangos(cmangosPath) if cmangosPath else {}
    if cmangosPath:
        print(f'{len(cmangos)} criaturas no cMaNGOS')

    totals = {'cache': 0, 'cmangos': 0, 'fixed': 0}
    pending = 0
    for f in sorted(glob.glob(os.path.join(DATA, 'MobDisplayIDs_*.lua'))):
        src = open(f, encoding='utf-8').read()
        counts = {'cache': 0, 'cmangos': 0, 'fixed': 0}
        fixes = []

        def fill(m):
            nonlocal pending
            npcID, current = int(m.group(2)), int(m.group(3))
            if npcID in cache and cache[npcID][1] != current:
                newID = cache[npcID][1]
                if current:
                    counts['fixed'] += 1
                    fixes.append(f'{npcID} {cache[npcID][0]}: {current} → {newID}')
                else:
                    counts['cache'] += 1
            elif current == 0 and npcID in cmangos:
                newID = cmangos[npcID][1]
                counts['cmangos'] += 1
            else:
                if current == 0:
                    pending += 1
                return m.group(0)
            entry = f'[{npcID}] = MobInfo({newID}, {m.group(4)}),'
            return f'{m.group(1)}{entry:<36}{m.group(5)}'

        # "    [3236] = MobInfo(0, "S"),       -- Nome"
        new = re.sub(r'^([ \t]*)\[(\d+)\] = MobInfo\((\d+), ("[SC]*"|nil)\),[ \t]*(--.*)$', fill, src, flags=re.M)
        if any(counts.values()):
            print(f'  {os.path.basename(f)}: cache {counts["cache"]}, cMaNGOS {counts["cmangos"]}, corrigidos {counts["fixed"]}')
            for line in fixes:
                print(f'      corrigido {line}')
            for k in totals:
                totals[k] += counts[k]
            if not dryRun:
                open(f, 'w', encoding='utf-8').write(new)

    print(f'Total: cache {totals["cache"]}, cMaNGOS {totals["cmangos"]}, corrigidos {totals["fixed"]}; '
          f'ainda pendentes: {pending}{" (dry-run, nada gravado)" if dryRun else ""}')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
