"""Canvas: the GBA game's ten new Eeveelutions as hg-engine species (after Pecharunt, as hg-engine's fakemon).

    python3 tools/canvas/build_species.py          (then regenerate the engine patch: see CANVAS.md)

Reads the GBA game (GBA_REPO): src/data/pokemon/species_info/canvas_families.h (stats, types, abilities, dex text),
level_up_learnsets/canvas.h, all_learnables.json, and graphics/pokemon/<name>/ (front with two frames, back, icon,
normal and shiny palettes). Writes into engine/:
  - include/constants/species.h: SPECIES_ODEON.. (MAX_CANONICAL_MON_NUM + 1..), NUM_OF_FAKEMONS
  - data/Species.c and the tables beside it (base exp, hidden ability, baby, heights, icon palette, sprite
    offsets, follower properties), data/Evolutions.c (Eevee: level up holding the type's item, first in its list:
    the game takes the first that fits), data/learnsets/learnsets.json, src/field/overworld_table.c,
    tools/canvas/data/canvas_cries.h (each borrows an Eeveelution's cry, as on the GBA)
  - data/graphics/sprites/<name>/: the GBA art in the DS's shapes. Front and back are the GBA's 64x64 pictures set
    in 80x80 frames (front: both GBA frames, feet on row 64 like HeartGold's Eeveelutions; back: on the bottom
    edge, one frame twice); the back carries the shiny palette (same colour order). The icon is the GBA's on the
    nearest of the DS's three icon palettes. The overworld sprite (the follower, and Penny's plush) is the front
    and back shrunk, like the GBA game's own (its tools/gym_hack/eeveelutions/overworld.py): up, down, left, right,
    two frames each.
Safe to run again (it skips what is already there, and rewrites the pictures).
"""
import json, os, re, shutil, sys
from collections import Counter
from PIL import Image
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import gba_map, slots

E = os.path.join(slots.ROOT, 'engine')
G = gba_map.P
sys.path.insert(0, G('tools/gym_hack/eeveelutions'))
NAMES = ['Odeon', 'Assasseon', 'Hypereon', 'Poiseon', 'Subterraneon', 'Obsideon', 'Lenneon', 'Appariteon', 'Automateon', 'Valyreon']
ITEMS = {}          # species -> the item Eevee holds (from the GBA's Eevee)
SPRITES = os.path.join(E, 'data/graphics/sprites')
TEMPLATE = 'sylveon'


def rd(p): return open(os.path.join(E, p), encoding='utf-8').read()


def wr(p, t): open(os.path.join(E, p), 'w', encoding='utf-8').write(t)


def gba_species():
    """-> {Name: fields} from canvas_families.h"""
    src = open(G('src/data/pokemon/species_info/canvas_families.h'), encoding='utf-8').read()
    out = {}
    for n in NAMES:
        m = re.search(r'\[SPECIES_%s\] =\s*\{(.*?)\n    \},' % n.upper(), src, re.S)
        b = m.group(1)
        f = lambda k, d=None: (re.search(r'\.%s\s*=\s*(.*?),\n' % k, b) or [None, d])[1]
        ab = re.findall(r'ABILITY_\w+', f('abilities'))
        desc = re.search(r'\.description = COMPOUND_STRING\((.*?)\),\n', b, re.S).group(1)
        out[n] = dict(
            hp=int(f('baseHP')), atk=int(f('baseAttack')), df=int(f('baseDefense')), spe=int(f('baseSpeed')),
            spa=int(f('baseSpAttack')), spd=int(f('baseSpDefense')), type=re.search(r'TYPE_\w+', f('types')).group(0),
            catch=int(f('catchRate')), exp=int(f('expYield')),
            ev={k: int(f('evYield_' + g, 0)) for k, g in (('hp', 'HP'), ('attack', 'Attack'), ('defense', 'Defense'),
                                                         ('spAttack', 'SpAttack'), ('spDefense', 'SpDefense'), ('speed', 'Speed'))},
            cycles=int(f('eggCycles')), ability=ab[0], hidden=ab[2] if len(ab) > 2 else 'ABILITY_NONE', color=f('bodyColor'),
            cry=f('cryId').replace('CRY_', 'SPECIES_'), category=re.search(r'_\("(.*?)"\)', f('categoryName')).group(1),
            height=int(f('height')), weight=int(f('weight')),
            desc=[s.replace('\\n', '') for s in re.findall(r'"(.*?)"', desc)])
    eevee = open(G('src/data/pokemon/species_info/gen_1_families.h'), encoding='utf-8').read()
    for n in NAMES:
        ITEMS[n] = re.search(r'\{EVO_LEVEL, 0, SPECIES_%s, CONDITIONS\(\{IF_HOLD_ITEM, (ITEM_\w+)\}\)\}' % n.upper(), eevee).group(1)
    return out


def gba_learnsets():
    lv = open(G('src/data/pokemon/level_up_learnsets/canvas.h'), encoding='utf-8').read()
    teach = json.load(open(G('src/data/pokemon/all_learnables.json')))
    known = set(re.findall(r'#define (MOVE_\w+)', rd('include/constants/moves.h')))
    eevee_eggs = json.load(open(os.path.join(E, 'data/learnsets/learnsets.json')))['SPECIES_EEVEE']['EggMoves']
    out = {}
    for n in NAMES:
        b = re.search(r's%sLevelUpLearnset\[\] = \{(.*?)LEVEL_UP_END' % n, lv, re.S).group(1)
        moves = [{'Level': int(l), 'Move': m} for l, m in re.findall(r'LEVEL_UP_MOVE\(\s*(\d+), (MOVE_\w+)\)', b)]
        assert all(m['Move'] in known for m in moves), n
        t = sorted(m for m in teach[n.upper()] if m in known)
        out['SPECIES_' + n.upper()] = {'LevelMoves': moves, 'MachineMoves': t, 'EggMoves': list(eevee_eggs), 'TutorMoves': t}
    return out


# ---------------------------------------------------------------- pictures
def pal_of(path):
    return [tuple(int(v) for v in l.split()) for l in open(path).read().split('\n')[3:19]]


def grid(im, x0, y0, w=64, h=64):
    px = im.load()
    return [[px[x0 + x, y0 + y] for x in range(w)] for y in range(h)]


def save_p(path, g, pal, transparent=True):
    h, w = len(g), len(g[0])
    im = Image.new('P', (w, h), 0)
    flat = [v for c in pal for v in c]
    im.putpalette(flat + [0] * (768 - len(flat)))
    im.putdata([v for row in g for v in row])
    if transparent: im.save(path, bits=4, transparency=0)
    else: im.save(path, bits=4)


def frame80(g, ox, oy):
    out = [[0] * 80 for _ in range(80)]
    for y in range(64):
        for x in range(64):
            if g[y][x] and 0 <= y + oy < 80: out[y + oy][x + ox] = g[y][x]
    return out


def bottom(g):
    return max(y for y, row in enumerate(g) if any(row))


def side_by_side(a, b):
    return [ra + rb for ra, rb in zip(a, b)]


_icon_pals = None


def icon_pals():
    """the DS's three icon palettes: the commonest palette among the icons hg-engine's table gives each number"""
    global _icon_pals
    if _icon_pals is None:
        table = dict(re.findall(r'\[SPECIES_(\w+)\]\s*=\s*(\d)', rd('data/IconPaletteTable.c')))
        seen = {}
        for n, p in table.items():
            f = os.path.join(SPRITES, n.lower(), 'icon.png')
            if n.title() in NAMES or not os.path.exists(f): continue
            seen.setdefault(int(p), Counter())[tuple(Image.open(f).getpalette()[:48])] += 1
        _icon_pals = {p: [c.most_common(1)[0][0][i * 3:i * 3 + 3] for i in range(16)] for p, c in seen.items()}
    return _icon_pals


def make_icon(src):
    im = Image.open(src)
    rgb = im.convert('RGBA'); idx = im.load()
    W, H = im.size
    best = None
    for p, pal in sorted(icon_pals().items()):
        err, g = 0, [[0] * W for _ in range(H)]
        for y in range(H):
            for x in range(W):
                if not idx[x, y]: continue
                c = rgb.getpixel((x, y))[:3]
                k = min(range(1, 16), key=lambda i: sum((a - b) ** 2 for a, b in zip(c, pal[i])))
                err += sum((a - b) ** 2 for a, b in zip(c, pal[k])); g[y][x] = k
        if best is None or err < best[0]: best = (err, p, g, pal)
    return best[1], best[2], best[3]


def make_overworld(front, back, pal):
    """32x256: up, down, left, right, two frames each (the second a pixel lower: a step)"""
    from overworld import shrink
    def small(g):
        s = shrink(g, pal, 20)             # (hg-engine's Eeveelutions are 17-22 wide and 22-26 tall; with its outline this is 22)
        b = bottom(s)
        lift = b - 29                      # (feet on row 29, where hg-engine's followers stand)
        return [s[y + lift] if 0 <= y + lift < 32 else [0] * 32 for y in range(32)]
    down, up = small(front), small(back)
    left = down
    right = [row[::-1] for row in down]
    out = []
    for g in (up, down, left, right):
        out += g
        out += [[0] * 32] + g[:-1]
    return out


def pictures(n):
    """-> (icon palette number, heights (back, front))"""
    key = n.lower()
    src = G('graphics/pokemon', key)
    d = os.path.join(SPRITES, key)
    tpl = os.path.join(SPRITES, TEMPLATE)
    normal, shiny = pal_of(os.path.join(src, 'normal.pal')), pal_of(os.path.join(src, 'shiny.pal'))
    fr = Image.open(os.path.join(src, 'anim_front.png')); bk = Image.open(os.path.join(src, 'back.png'))
    f0, f1, b0 = grid(fr, 0, 0), grid(fr, 0, 64), grid(bk, 0, 0)
    oy = min(64 - bottom(f0), 16)
    front = side_by_side(frame80(f0, 8, oy), frame80(f1, 8, oy))
    back1 = frame80(b0, 8, 16)
    back = side_by_side(back1, back1)
    for sex in ('male', 'female'):
        os.makedirs(os.path.join(d, sex), exist_ok=True)
        save_p(os.path.join(d, sex, 'front.png'), front, normal)
        save_p(os.path.join(d, sex, 'back.png'), back, shiny)
        for k in ('front.png.key', 'back.png.key'):
            shutil.copyfile(os.path.join(tpl, sex, k), os.path.join(d, sex, k))
    pi, ig, ipal = make_icon(os.path.join(src, 'icon.png'))
    save_p(os.path.join(d, 'icon.png'), ig, ipal, transparent=False)
    save_p(os.path.join(d, 'overworld.png'), make_overworld(f0, b0, normal), normal, transparent=False)
    shutil.copyfile(os.path.join(tpl, 'overworld.json'), os.path.join(d, 'overworld.json'))
    for k, pal in ((0, normal), (1, shiny)):
        open(os.path.join(d, 'overworld-tsure_poke%d.pal' % k), 'w', newline='\r\n').write(
            'JASC-PAL\n0100\n16\n' + ''.join('%d %d %d\n' % c for c in pal))
    return pi, (79 - bottom(back1), 79 - bottom(frame80(f0, 8, oy)))


# ---------------------------------------------------------------- tables
def block_of(text, head):
    """the '    [SPECIES_X] = {' ... '    },' block starting at head"""
    i = text.index(head)
    j = text.index('\n    },\n', i) + len('\n    },\n')
    return text[i:j]


def after_line(text, marker, add):
    i = text.index(marker)
    j = text.index('\n', i) + 1
    return text[:j] + add + text[j:]


def imperial(dm, hg):
    inches = round(dm * 3.937)
    return '%d’%02d”' % (inches // 12, inches % 12), '%.1f lbs.' % (hg * 0.2204623)


def main():
    sp = gba_species()
    U = [n.upper() for n in NAMES]
    done = 'SPECIES_%s ' % U[0] in rd('include/constants/species.h')

    pics = {n: pictures(n) for n in NAMES}
    # (kept with our other engine data, tools/canvas/data/: build_rom.sh copies it into engine/data/)
    cries = ('// Pokemon Canvas: written by tools/canvas/build_species.py. The cry each of our species borrows.\n'
             'static const u16 sCanvasCries[NUM_OF_FAKEMONS] = {\n' + ''.join('    %s, // %s\n' % (sp[n]['cry'], n) for n in NAMES) + '};\n')
    open(os.path.join(HERE, 'data', 'canvas_cries.h'), 'w').write(cries)
    wr('data/canvas_cries.h', cries)
    if done:
        print('species already in the tables: pictures rewritten'); return

    t = rd('include/constants/species.h')
    old = '#define NUM_OF_FAKEMONS 0'
    assert old in t
    wr('include/constants/species.h', t.replace(old, '// Pokemon Canvas: the GBA game\'s new Eeveelutions (tools/canvas/build_species.py)\n' + ''.join(
        '#define SPECIES_%s (MAX_CANONICAL_MON_NUM + %d)\n' % (u, i + 1) for i, u in enumerate(U)) + '\n#define NUM_OF_FAKEMONS %d' % len(U)))

    # Species.c: Sylveon's entry with the GBA's numbers
    t = rd('data/Species.c')
    tpl = block_of(t, '    [SPECIES_SYLVEON] = {')
    add = ''
    for n in NAMES:
        s = sp[n]; b = tpl.replace('[SPECIES_SYLVEON]', '[SPECIES_%s]' % n.upper())
        h, w = imperial(s['height'], s['weight'])
        reps = [
            (r'\.name = ".*?"', '.name = "%s"' % n),
            (r'\.pokedexEntry = ".*?",\n', '.pokedexEntry = "%s",\n' % '\\\\n'.join(s['desc'])),
            (r'\.classification = ".*?"', '.classification = "%s Pokémon"' % s['category']),
            (r'\.height = ".*?"', '.height = "%s"' % h), (r'\.weight = ".*?"', '.weight = "%s"' % w),
            (r'\.types = \{.*?\}', '.types = { %s, %s }' % (s['type'], s['type'])),
            (r'\.catchRate = \d+', '.catchRate = %d' % s['catch']),
            (r'\.hatchCycles = \d+', '.hatchCycles = %d' % s['cycles']),
            (r'\.abilities = \{.*?\}', '.abilities = { %s, ABILITY_NONE }' % s['ability']),
            (r'\.bodyColor = \w+', '.bodyColor = %s' % s['color']),
            (r'\.heightDecimetres = \d+', '.heightDecimetres = %d' % s['height']),
            (r'\.weightHectograms = \d+', '.weightHectograms = %d' % s['weight']),
        ]
        for pat, val in reps:
            b, k = re.subn(pat, lambda m, v=val: v, b, count=1, flags=re.S)
            assert k == 1, pat
        # base stats, then EV yields (the same six names, in that order)
        stats = dict(hp=s['hp'], attack=s['atk'], defense=s['df'], spAttack=s['spa'], spDefense=s['spd'], speed=s['spe'])
        i0 = b.index('.baseStats'); i1 = b.index('.evYields'); i2 = b.index('.wildHeldItems')
        fix = lambda part, vals: re.sub(r'\.(\w+) = \d+', lambda m: '.%s = %d' % (m.group(1), vals[m.group(1)]) if m.group(1) in vals else m.group(0), part)
        b = b[:i0] + fix(b[i0:i1], stats) + fix(b[i1:i2], s['ev']) + b[i2:]
        add += b + '\n'
    wr('data/Species.c', t.replace('    [SPECIES_MEGA_VENUSAUR] = {', add + '    [SPECIES_MEGA_VENUSAUR] = {', 1))

    def table(path, marker, line):
        wr(path, after_line(rd(path), marker, '    // Pokemon Canvas\n' + ''.join(line(n) for n in NAMES)))
    table('data/BaseExperienceTable.c', '[SPECIES_PECHARUNT ', lambda n: '    [SPECIES_%-28s] = %d,\n' % (n.upper(), sp[n]['exp']))
    table('data/HiddenAbilityTable.c', '[SPECIES_PECHARUNT ', lambda n: '    [SPECIES_%-28s] = %s,\n' % (n.upper(), sp[n]['hidden']))
    table('data/BabyMons.c', '[SPECIES_PECHARUNT]', lambda n: '    [SPECIES_%s] = SPECIES_EEVEE,\n' % n.upper())
    table('data/SpeciesToOWFormFemale.c', '[SPECIES_PECHARUNT]', lambda n: '    [SPECIES_%s] = FALSE,\n' % n.upper())
    table('data/FollowerProperties.c', '[SPECIES_PECHARUNT]',
          lambda n: '    [SPECIES_%s] = {.size = OVERWORLD_CAN_ENTER, .bounce = OVERWORLD_BOUNCE_FAST},\n' % n.upper())
    table('data/HeightTable.c', '[SPECIES_PECHARUNT]',
          lambda n: '    [SPECIES_%s] = { %d, %d, %d, %d },\n' % (n.upper(), pics[n][1][0], pics[n][1][0], pics[n][1][1], pics[n][1][1]))
    table('data/IconPaletteTable.c', '[SPECIES_PECHARUNT]', lambda n: '    [SPECIES_%s] = %d,\n' % (n.upper(), pics[n][0]))
    table('src/field/overworld_table.c', 'MON_FOLLOWER_ENTRY(SPECIES_PECHARUNT,',
          lambda n: '        MON_FOLLOWER_ENTRY(SPECIES_%s, OVERWORLD_SIZE_SMALL)\n' % n.upper())

    # sprite offsets: Umbreon's (a sprite that sits where ours do, with the table's height doing the lifting)
    t = rd('data/SpriteOffsets.c')
    tpl = block_of(t, '    [SPECIES_UMBREON] = {')
    wr('data/SpriteOffsets.c', t.replace('    [SPECIES_MEGA_VENUSAUR] = {', ''.join(
        tpl.replace('[SPECIES_UMBREON]', '[SPECIES_%s]' % u) for u in U) + '    [SPECIES_MEGA_VENUSAUR] = {', 1))

    # Eevee: the new ones first
    t = rd('data/Evolutions.c')
    head = '    [SPECIES_EEVEE] = {\n        .entries = {\n'
    assert head in t
    wr('data/Evolutions.c', t.replace(head, head + '            // Pokemon Canvas: level up holding the type\'s item\n' + ''.join(
        '            { EVO_LEVEL_HOLD_ITEM, %s, SPECIES_%s },\n' % (ITEMS[n], n.upper()) for n in NAMES)))

    # learnsets (appended in the file's own layout)
    p = 'data/learnsets/learnsets.json'
    t = rd(p)
    assert t.endswith('\n}')
    extra = json.dumps(gba_learnsets(), indent=2)
    wr(p, t[:-2] + ',' + extra[1:])
    print('added', ', '.join(NAMES))
    for n in NAMES: print('  %-13s icon palette %d, heights back %d front %d' % (n, pics[n][0], *pics[n][1]))


if __name__ == '__main__':
    main()
