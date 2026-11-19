#!/usr/bin/env python3
# =============================================================================
# FarmBuddy: Forever - gera os dados de profissão (Skinning/Tailoring) por mob
# =============================================================================
# Lê o dump do cMaNGOS classic-db (GPLv3, https://github.com/cmangos/classic-db,
# Full_DB/ClassicDB_1_12_1_*.sql.gz) e preenche a profissão (2º argumento) de
# cada [npcID] = MobInfo(displayID, profissão) em FarmBuddy_Forever/data/*.lua.
#
#   "S" = esfolável: SkinningLootId > 0 e não é herbalismo/mineração (CreatureTypeFlags 0x100/0x200)
#   "C" = dropa tecido (Linen, Wool, Silk, Mageweave, Runecloth, Felcloth) com chance >= CLOTH_MIN,
#         seguindo as referências de loot (listas genéricas de drop do mundo têm cloth a ~0,02%)
#   "SC" = os dois, "" = nenhum
#
# Prioridade: o cMaNGOS vence para os mobs que ele conhece (o valor é reescrito).
# Mobs que ele não conhece (exclusivos do Forever) não são tocados: ficam com nil
# (pendente, o core usa a regra por tipo) ou com o valor preenchido à mão.
#
# --prune: depois de preencher, remove os mobs com profissão "" (não rendem
# tecido nem couro) e os grupos de tipo ("-- Beasts") que ficarem vazios.
#
# Uso: python3 -I tools/forever_professions.py <ClassicDB.sql.gz> [--prune] [--dry-run]
# =============================================================================

import collections
import glob
import gzip
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA = os.path.join(ROOT, 'FarmBuddy_Forever', 'data')

CLOTH = {2589, 2592, 4306, 4338, 14047, 14256}
CLOTH_MIN = 0.02  # 2%
TYPEFLAGS_HERB_OR_MINING = 0x100 | 0x200

MOBINFO_RE = re.compile(r'^([ \t]*)\[(\d+)\] = MobInfo\((\d+), ("[SC]*"|nil)\),[ \t]*(--.*)$', re.M)


def tuples(line):
    """Tokeniza 'INSERT ... VALUES (...),(...);' em listas de valores (str ou None)."""
    i = line.index('VALUES') + 6
    n = len(line)
    row = None
    out = []
    while i < n:
        c = line[i]
        if row is None:
            if c == '(':
                row = []
            i += 1
            continue
        if c == "'":
            j = i + 1
            buf = []
            while line[j] != "'":
                if line[j] == '\\':
                    buf.append(line[j + 1]); j += 2
                else:
                    buf.append(line[j]); j += 1
            row.append(''.join(buf))
            i = j + 1
        elif c == ',':
            i += 1
        elif c == ')':
            out.append(row); row = None; i += 1
        else:
            j = i
            while line[j] not in ',)':
                j += 1
            v = line[i:j]
            row.append(None if v == 'NULL' else v)
            i = j
    return out


def loadCmangos(path):
    """Retorna {npcID: (nome, flags)}."""
    cols = []
    templates, creatureLoot, refLoot = [], collections.defaultdict(list), collections.defaultdict(list)
    inCreate = False
    with gzip.open(path, 'rt', encoding='utf-8', errors='replace') as f:
        for line in f:
            if line.startswith('CREATE TABLE `creature_template` '):
                inCreate = True
                continue
            if inCreate:
                m = re.match(r'\s+`(\w+)`', line)
                if m:
                    cols.append(m.group(1))
                else:
                    inCreate = False
                continue
            if line.startswith('INSERT INTO `creature_template` '):
                templates += tuples(line)
            elif line.startswith('INSERT INTO `creature_loot_template` '):
                for r in tuples(line):
                    creatureLoot[int(r[0])].append(r)
            elif line.startswith('INSERT INTO `reference_loot_template` '):
                for r in tuples(line):
                    refLoot[int(r[0])].append(r)

    # Colunas do loot: entry, item, ChanceOrQuestChance, groupid, mincountOrRef, ...
    def clothChance(rows, depth=0):
        best = 0.0
        for r in rows:
            chance = abs(float(r[2])) or 100.0  # 0 = chance igual dentro do grupo
            ref = int(r[4])
            if ref < 0:
                if depth < 4:
                    best = max(best, chance / 100 * clothChance(refLoot[-ref], depth + 1))
            elif int(r[1]) in CLOTH:
                best = max(best, chance / 100)
        return best

    out = {}
    for r in templates:
        c = dict(zip(cols, r))
        skin = int(c['SkinningLootId'] or 0) > 0 and not (int(c['CreatureTypeFlags'] or 0) & TYPEFLAGS_HERB_OR_MINING)
        lootID = int(c['LootId'] or 0)
        cloth = lootID > 0 and clothChance(creatureLoot[lootID]) >= CLOTH_MIN
        out[int(c['Entry'])] = (c['Name'], ('S' if skin else '') + ('C' if cloth else ''))
    return out


def main(args):
    dryRun = '--dry-run' in args
    prune = '--prune' in args
    paths = [a for a in args if a not in ('--dry-run', '--prune')]
    if len(paths) != 1:
        print('Uso: python3 -I tools/forever_professions.py <ClassicDB.sql.gz> [--prune] [--dry-run]')
        return 1
    db = loadCmangos(paths[0])
    print(f'{len(db)} criaturas no cMaNGOS')

    for f in sorted(glob.glob(os.path.join(DATA, 'MobDisplayIDs_*.lua'))):
        src = open(f, encoding='utf-8').read()
        stats = collections.Counter()
        changed = []

        def fill(m):
            npcID, current = int(m.group(2)), m.group(4)
            if npcID not in db:
                stats['pendente' if current == 'nil' else 'à mão'] += 1
                return m.group(0)
            value = '"%s"' % db[npcID][1]
            stats[db[npcID][1] or '-'] += 1
            if value == current:
                return m.group(0)
            if current != 'nil':
                changed.append(f'{npcID} {db[npcID][0]}: {current} → {value}')
            entry = f'[{npcID}] = MobInfo({m.group(3)}, {value}),'
            return f'{m.group(1)}{entry:<36}{m.group(5)}'

        new = MOBINFO_RE.sub(fill, src)
        pruned = []
        if prune:
            pruned = re.findall(r'^[ \t]*\[\d+\] = MobInfo\(\d+, ""\),[ \t]*-- (.*)$', new, re.M)
            new = re.sub(r'^[ \t]*\[\d+\] = MobInfo\(\d+, ""\),.*\n', '', new, flags=re.M)
            # grupos de tipo que ficaram vazios (cabeçalho seguido de linha vazia ou do fim da tabela)
            new = re.sub(r'^[ \t]*-- [A-Za-z][\w ]*\n(?=[ \t]*\n|\}\))', '', new, flags=re.M)
            new = re.sub(r'\n[ \t]*\n(?=\}\))', '\n', new)          # linha vazia antes do "})"
            new = re.sub(r'(RegisterZone\([^\n]*\{\n)[ \t]*\n', r'\1', new)  # linha vazia após o "{"
            new = re.sub(r'\n([ \t]*\n)+', '\n\n', new)
        print(f'  {os.path.basename(f)}: ' + ', '.join(f'{k} {v}' for k, v in sorted(stats.items()))
              + (f'; removidos {len(pruned)}' if prune else ''))
        for line in changed:
            print(f'      alterado {line}')
        if not dryRun and new != src:
            open(f, 'w', encoding='utf-8').write(new)
    if dryRun:
        print('(dry-run, nada gravado)')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))
