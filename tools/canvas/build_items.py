"""Canvas: the GBA game's own items as hg-engine items, after hg-engine's last (Canari Bread, 2684).

    python3 tools/canvas/build_items.py          (then regenerate the engine patch: engine/make_patch.sh)

The items (ids kept: saves hold them):
  - 2685 the Eviolate: Eviolite's offensive twin (Attack and Sp. Atk x1.5 for a Pokemon that can still evolve);
    the game has one, from the Pokemon Tower's ghost girl
  - 2686-2721 the mentors' type gear, a Guard and an Edge per type (the GBA's order: Normal, Fighting, Flying,
    Poison, Ground, Rock, Bug, Ghost, Steel, Fire, Water, Grass, Electric, Psychic, Ice, Dragon, Dark, Fairy).
    Guard: super-effective hits on the holder do normal damage. Edge: the holder's damaging moves do at least
    normal damage. Never used up, never tossed, never taken (Knock Off, Trick...)
  - 2722-2739 the Type Balls, the same order: 3.5x on a Pokemon of the ball's type, and a Pokemon of its type
    caught in one has its lowest base stat(s) x1.5 (the caught Pokemon's ball shows as a Poke Ball: HeartGold has
    no picture for ours; which one it was is kept beside it, engine/src/pokemon.c)
The battle code is in the engine (include/canvas_items.h says where).

Writes into engine/:
  - include/constants/item.h: the defines (plain numbers: the porter reads them), MAX_TOTAL_ITEM_NUM
  - data/itemdata/itemdata.c: their data
  - data/text/222.txt (names, a line an item id), and hg-engine's banks for items past its own, a line an item from
    2685: 221 descriptions, 223 "a X", 224 plurals, 829 the give-item line
  - data/graphics/item/<name>.png: the GBA's 24x24 icon (its own palette) in the middle of the DS's 32x32, and
    data/graphics/itemgra.mk (hg-engine's tools/source/dumptools/dump_item_gfx.py)
Safe to run again.
"""
import os, re, subprocess, sys
from PIL import Image
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import gba_map, slots

E = os.path.join(slots.ROOT, 'engine')
G = gba_map.P
FIRST = 2685
TYPES = ['Normal', 'Fighting', 'Flying', 'Poison', 'Ground', 'Rock', 'Bug', 'Ghost', 'Steel', 'Fire', 'Water', 'Grass',
         'Electric', 'Psychic', 'Ice', 'Dragon', 'Dark', 'Fairy']
# (Guard, Edge) per type, and the plural where it isn't a plain -s
GEAR = [('Fluffy Sweater', 'Third Eye'), ('Mouth Guard', 'Steroids'), ('Aviator Goggles', 'Jet Engine'),
        ('Titanium Coil', 'Corrosive Venom'), ('Granite Sarcophagus', 'Diamond Drill Bit'),
        ('Diamond Plating', 'Precision Chisel'), ('Cacoon', 'Extra Stinger'), ('Light Switch', 'Ouija Board'),
        ('Stainless Alloy', 'Knife Sharpener'), ('Heat Shield', 'Oxidizer'), ('Cistern', 'Nozzle'),
        ('Chicken Wire', 'Miracle Gro'), ('Capacitor', 'Transformer'), ('Energy Shield', 'Psionic Blade'),
        ('Cooler', 'Rock Salt'), ('Fire Shroud', 'Bionic Jaw'), ('Black Veil', 'Manifesto'),
        ('Twinkling Lights', 'Magic Wand')]
PLURAL = {'Steroids': 'Steroids', 'Aviator Goggles': 'Aviator Goggles', 'Granite Sarcophagus': 'Granite Sarcophagi',
          'Light Switch': 'Light Switches', 'Twinkling Lights': 'Twinkling Lights'}
GUARD_DESC = 'Super-effective hits on the holder\\ndo only normal damage. It is never\\nused up, and it can’t be taken.'
EDGE_DESC = 'The holder’s moves always hit for\\nat least normal damage. It is never\\nused up, and it can’t be taken.'
BALL_DESC = 'A Poké Ball for %s-type Pokémon.\\nThey’re easier to catch with it, and\\ntheir weakest stat goes up by half.'
EVIOLATE_DESC = 'Eviolite’s offensive twin. It raises\\nthe Attack and Sp. Atk of a Pokémon\\nthat can still evolve.'


def items():
    """-> [(define, name, kind, type, description)] in id order"""
    out = [('ITEM_EVIOLATE', 'Eviolate', 'eviolate', None, EVIOLATE_DESC)]
    for t, (guard, edge) in zip(TYPES, GEAR):
        out.append((define(guard), guard, 'guard', t, GUARD_DESC))
        out.append((define(edge), edge, 'edge', t, EDGE_DESC))
    for t in TYPES:
        out.append(('ITEM_%s_BALL' % t.upper(), '%s Ball' % t, 'ball', t, BALL_DESC % t))
    return out


def define(name): return 'ITEM_' + re.sub(r'\W+', '_', name.upper())


def rd(p): return open(os.path.join(E, p), encoding='utf-8', newline='').read()


def wr(p, t): open(os.path.join(E, p), 'w', encoding='utf-8', newline='').write(t)


# ---------------------------------------------------------------- the defines
BEGIN, END = '// Pokemon Canvas: the GBA game\'s items (tools/canvas/build_items.py)\n', '// (end of the GBA game\'s items)\n'


def write_defines(its):
    h = rd('include/constants/item.h')
    h = re.sub(re.escape(BEGIN) + '.*?' + re.escape(END), '', h, flags=re.S)
    for d, *_ in its:
        assert not re.search(r'#define %s\s' % d, h), d + ' is hg-engine\'s already'
    lines = [BEGIN] + ['#define %-32s %d\n' % (d, FIRST + i) for i, (d, *_) in enumerate(its)]
    lines += ['#define IS_ITEM_CANVAS_TYPE_GEAR(item) ((item) >= ITEM_FLUFFY_SWEATER && (item) <= ITEM_MAGIC_WAND)\n',
              '#define IS_ITEM_CANVAS_TYPE_BALL(item) ((item) >= ITEM_NORMAL_BALL && (item) <= ITEM_FAIRY_BALL)\n', END]
    anchor = '// #define ITEM_CUSTOM_1 (MAX_BASE_ITEM_NUM + 1)\n'
    assert anchor in h
    h = h.replace(anchor, anchor + '\n' + ''.join(lines), 1)
    h = re.sub(r'#define MAX_TOTAL_ITEM_NUM \w+', '#define MAX_TOTAL_ITEM_NUM %s' % its[-1][0], h)
    wr('include/constants/item.h', h)


# ---------------------------------------------------------------- the data
def write_data(its):
    c = rd('data/itemdata/itemdata.c')
    c = re.sub(r'\n// Pokemon Canvas: the GBA game\'s items.*?// \(end of the GBA game\'s items\)\n', '\n', c, flags=re.S)
    template = lambda name: re.search(r'\[%s\] =\n\{\n.*?\n\},\n' % name, c, re.S).group(0)
    held, ball = template('ITEM_EVIOLITE'), template('ITEM_POKE_BALL')
    out = []
    for d, name, kind, t, _ in its:
        e = (ball if kind == 'ball' else held).replace('[ITEM_EVIOLITE]', '[%s]' % d).replace('[ITEM_POKE_BALL]', '[%s]' % d)
        e = re.sub(r'ITEM_PRICE\(\d+\)', 'ITEM_PRICE(0)', e)
        if kind != 'ball':
            effect = {'eviolate': 'HOLD_EFFECT_CANVAS_EVIOLATE', 'guard': 'HOLD_EFFECT_CANVAS_TYPE_GUARD',
                      'edge': 'HOLD_EFFECT_CANVAS_TYPE_EDGE'}[kind]
            e = re.sub(r'\.holdEffect = \w+', '.holdEffect = ' + effect, e)
            e = re.sub(r'\.holdEffectParam = \w+', '.holdEffectParam = %s' % ('TYPE_' + t.upper() if t else '0'), e)
            e = re.sub(r'\.flingPower = \d+', '.flingPower = %d' % (40 if kind == 'eviolate' else 0), e)
            if kind != 'eviolate':
                e = e.replace('.prevent_toss = FALSE', '.prevent_toss = TRUE')
        out.append(e)
    block = "// Pokemon Canvas: the GBA game's items (tools/canvas/build_items.py)\n" + ''.join(out) + "// (end of the GBA game's items)\n"
    i = c.rstrip().rindex('};')
    c = c[:i] + block + '\n' + c[i:]
    wr('data/itemdata/itemdata.c', c)


# ---------------------------------------------------------------- the text
def article(name): return ('an ' if name[0] in 'AEIOU' else 'a ') + '{COLOR 255}%s{COLOR 0}' % name


def write_text(its):
    names = rd('data/text/222.txt').split('\r\n')
    names = names[:FIRST] + [n for _, n, *_ in its]
    assert names[FIRST - 1] == 'Canari Bread'
    wr('data/text/222.txt', '\r\n'.join(names))
    banks = {221: [desc for *_, desc in its], 223: [article(n) for _, n, *_ in its],
             224: ['{COLOR 255}%s{COLOR 0}' % PLURAL.get(n, n + 's') for _, n, *_ in its],
             829: [article(n) for _, n, *_ in its]}
    for b, lines in banks.items():
        wr('data/text/%d.txt' % b, '\r\n'.join(lines))


# ---------------------------------------------------------------- the icons
def gba_icon(name):
    stem = re.sub(r'\W+', '_', name.lower())
    png = G('graphics/items/icons/gym/%s.png' % stem)
    pal = G('graphics/items/icon_palettes/gym/%s.pal' % stem)
    return png, pal


def read_pal(path):
    lines = open(path).read().split('\n')
    n = int(lines[2])
    return [tuple(int(v) for v in l.split()) for l in lines[3:3 + n]]


def write_icons(its):
    for d, name, *_ in its:
        png, pal = gba_icon(name)
        im = Image.open(png)
        assert im.mode == 'P' and im.size == (24, 24), png
        colours = read_pal(pal)
        out = Image.new('P', (32, 32), 0)
        out.paste(im, (4, 4))
        flat = []
        for r, g, b in colours[:16] + [(0, 0, 0)] * (16 - len(colours)): flat += [r, g, b]
        out.putpalette(flat)
        out.save(os.path.join(E, 'data/graphics/item/%s.png' % d[5:].lower()), transparency=0)
    subprocess.run([sys.executable, 'tools/source/dumptools/dump_item_gfx.py'], cwd=E, check=True)


if __name__ == '__main__':
    its = items()
    assert len(its) == 55
    write_defines(its)
    write_data(its)
    write_text(its)
    write_icons(its)
    print('items %d-%d' % (FIRST, FIRST + len(its) - 1))
