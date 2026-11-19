"""The GBA game's script-changed squares (setmetatile) that open and close a way: Silph Co.'s card-key doors, the
Pokemon Mansion's switch barriers, Victory Road's rock walls, the Rocket Hideout's barriers, the Cinnabar Gym's quiz
doors, the Game Corner's stairs...

HeartGold has no command that changes a square of a map, so each such square is built open (the land and its
collision: build_caves.py and build_interiors.py ask `open_squares`) and closed by an object standing on it: the
barrier's own picture (the GBA metatiles, standing up, as an overworld of our own: build_barriers.py) on its front
squares, an invisible one behind. Each square has a flag of its own, set while it is open (the object's flag, so it
is hidden then); the porter turns setmetatile on these squares into that flag and HidePerson / ShowPerson.

A square is a barrier when the scripts that can run on its map make it closed (collision 1) and open (collision 0),
counting the layout's own state as one of them.
"""
import os, re, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.dirname(HERE))
import gba_map

# GBA maps whose barriers we build (built from their GBA layouts, so their squares are the GBA's). Left out: the
# Game Corner (its "barrier" is the hideout's stairs, a way out shown once the switch is found), the League's rooms
# and the Vermilion Gym (HeartGold's own rooms). Victory Road's are opened by boulders on its switches (the engine's
# canvas_boulders.c starts the switch's script)
BUILT = re.compile(r'^(SilphCo_\d+F|PokemonMansion_(\d|B\d)F|RocketHideout_B\dF|CinnabarIsland_Gym|VictoryRoad_\dF)_Frlg$')
ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
DATA = os.path.join(ROOT, 'tools/canvas/data/barriers.json')
CUSTOM = os.path.join(ROOT, 'engine/data/graphics/overworlds/custom')
TABLE = os.path.join(ROOT, 'engine/src/field/overworld_table.c')
FIRST = 1                       # our first barrier overworld (0 is the fossil); FIRST is the invisible one
TAG0 = 7000                     # (NEW_NPC_TAG_START)
# pictures the GBA draws from above that read wrong standing up: Silph Co.'s doors seen side-on are its doors seen
# from the front
SUBST = {'METATILE_SilphCo_VerticalBarrier_BottomLeft': ('METATILE_SilphCo_HorizontalBarrier_TopLeft', 'METATILE_SilphCo_HorizontalBarrier_BottomLeft'),
         'METATILE_SilphCo_VerticalBarrier_BottomRight': ('METATILE_SilphCo_HorizontalBarrier_TopRight', 'METATILE_SilphCo_HorizontalBarrier_BottomRight')}
_cache = {}


def _gba():
    if 'g' not in _cache:
        sys.path.insert(0, HERE)
        import gba as G
        _cache['g'] = G.Gba()
    return _cache['g']


def _reach(g, entries, gdir=''):
    seen, todo = set(), list(entries)
    while todo:
        l = todo.pop()
        if l in seen: continue
        seen.add(l)
        for c, a in g.labels.get(l, []):
            for x in a:
                for y in x.split():          # (call_if_not_defeated TRAINER LABEL: no comma)
                    if y in g.labels and y not in seen and not _other_floor(gdir, y): todo.append(y)
    return seen


def _other_floor(gdir, label):
    """a shared script for another floor of the same building (silphco_doors.inc's Open3FDoor1 from 2F's)"""
    m, n = re.search(r'_(B?\d+F)_', gdir + '_'), re.search(r'(?<![A-Za-z0-9])(?:Open|Close|PressSwitch_|ResetSwitch_|_)(B?\d+F)', label)
    return bool(m and n and m.group(1) != n.group(1))


def entries(g, gdir, mj):
    out = [o['script'] for o in mj.get('object_events', []) if o.get('script') not in (None, '0', '0x0')]
    out += [b['script'] for b in mj.get('bg_events', []) if b.get('script')]
    out += [c['script'] for c in mj.get('coord_events', []) if c.get('script') not in (None, '0', '0x0')]
    ms = g.labels.get(gdir.replace('_Frlg', '') + '_Frlg_MapScripts', g.labels.get(gdir + '_MapScripts', []))
    for c, a in ms:
        if c == 'map_script':
            out.append(a[1])
            for c2, a2 in g.labels.get(a[1], []):
                if c2 == 'map_script_2': out.append(a2[2])
    return out


def barriers(gdir, g=None):
    """GBA map dir -> {(x, y): dict(base=0/1, closed=metatile, closer=label, open=metatile)} (GBA squares)"""
    key = ('b', gdir)
    if key in _cache: return _cache[key]
    g = g or _gba()
    import gba as G
    mj = G.map_json(gdir)
    lay = gba_map.Layout(mj['layout'], raw=True)
    sets = {}           # (x, y) -> [(label, metatile, collision)]
    for l in sorted(_reach(g, entries(g, gdir, mj), gdir)):
        for c, a in g.labels.get(l, []):
            if c != 'setmetatile' or len(a) < 4: continue
            x, y, mt = g.value(a[0]), g.value(a[1]), g.value(a[2])
            col = 1 if a[3] in ('1', 'TRUE') else 0 if a[3] in ('0', 'FALSE') else g.value(a[3])
            if None in (x, y, mt, col) or not (0 <= x < lay.w and 0 <= y < lay.h): continue
            sets.setdefault((x, y), []).append((l, mt & 0x3FF, col))
    out = {}
    for (x, y), ss in sets.items():
        base = 1 if lay.collision(x, y) else 0
        cols = {base} | {c for _, _, c in ss}
        if cols != {0, 1}: continue
        closed = next(((l, m) for l, m, c in ss if c == 1), None)
        opened = next((m for l, m, c in ss if c == 0), None)
        out[(x, y)] = dict(base=base, closed=closed[1] if closed else lay.metatile(x, y), closer=closed[0] if closed else None,
                           open=opened if opened is not None else lay.metatile(x, y))
    _cache[key] = out
    return out


def open_squares(gdir):
    """the barrier squares of a GBA map that its layout has closed: built open (an object closes them)"""
    try:
        return {sq: b['open'] for sq, b in barriers(gdir).items() if b['base'] == 1}
    except Exception:
        return {}


def picture(gdir, sq, g=None):
    """the barrier's look at a front square: the metatiles its closing script puts there and on the square above
    (top, bottom; None for nothing)"""
    g = g or _gba()
    b = barriers(gdir)[sq]
    x, y = sq
    top = None
    if b['closer']:
        for c, a in g.labels.get(b['closer'], []):
            if c == 'setmetatile' and g.value(a[0]) == x and g.value(a[1]) == y - 1:
                top = g.value(a[2]) & 0x3FF
    else:
        import gba as G
        lay = gba_map.Layout(G.map_json(gdir)['layout'], raw=True)
        if y > 0 and (x, y - 1) in barriers(gdir): top = lay.metatile(x, y - 1)
    if top is None and (x, y - 1) in barriers(gdir): top = barriers(gdir)[(x, y - 1)]['closed']
    for k, (t, b_) in SUBST.items():
        if g.value(k) == b['closed']: return g.value(t), g.value(b_)
    return top, b['closed']


def fronts(gdir):
    """the barrier squares that show the picture (nothing closed in front of them, to the south)"""
    bs = barriers(gdir)
    return {sq for sq in bs if (sq[0], sq[1] + 1) not in bs}


def image(gdir, sq):
    """the standing picture for a front square: 32x32, the column of two metatiles in its middle"""
    from PIL import Image
    import gba as G
    lay = gba_map.Layout(G.map_json(gdir)['layout'], raw=True)
    top, bot = picture(gdir, sq)
    im = Image.new('RGBA', (32, 32), (0, 0, 0, 0))
    if top is not None: im.alpha_composite(lay.render_metatile(top), (8, 0))
    im.alpha_composite(lay.render_metatile(bot), (8, 16))
    return im


def write_overworld(n, im, name):
    """an overworld of our own (engine custom/NNNN): a still 32x32 picture, 15 colours and see-through"""
    from PIL import Image
    import json as J
    q = im.convert('RGB').quantize(15, method=Image.Quantize.MEDIANCUT) if im.getbbox() else None
    qp = (q.getpalette() if q else []) + [0] * 45
    pal = [(255, 0, 255)] + [tuple(qp[i * 3:i * 3 + 3]) for i in range(15)]
    px = Image.new('P', (32, 32), 0)
    px.putpalette([c for rgb in pal for c in rgb])
    a = im.split()[3]
    if q:
        qd, ad, out = q.load(), a.load(), px.load()
        for y in range(32):
            for x in range(32):
                if ad[x, y] >= 128: out[x, y] = qd[x, y] + 1
    for f in os.listdir(CUSTOM):
        if f.startswith('%04d' % n): os.remove(os.path.join(CUSTOM, f))
    px.save(os.path.join(CUSTOM, '%04d.png' % n), bits=4)
    open(os.path.join(CUSTOM, '%04d-%s.pal' % (n, name)), 'w').write(
        'JASC-PAL\r\n0100\r\n16\r\n' + ''.join('%d %d %d\r\n' % c for c in pal))
    fr = dict(frame=0, coordTrans=0, color0=1, format=3, height=32, width=32, flipY=0, flipX=0, repeatY=0, repeatX=0,
              unkBlockUnk0=46, unkBlockUnk1=1, unk0=0, unk1=1, unk2=128)
    J.dump({'frames': {name: fr}, 'palettes': {name: dict(offset=0, unk0=70, unk1=1, fileName=name + '.pal')}},
           open(os.path.join(CUSTOM, '%04d.json' % n), 'w'), indent='\t')


# people of the GBA's that HeartGold has no one like (Nick: the right sprite for every person): the GBA's own
# pictures (graphics/object_events/pics/people), each 16x32 frame stood in a 32x32 one, in HeartGold's order for a
# person (its waiter's: the same 16 frame names, so its walking works as theirs). GBA graphics id -> picture
PEOPLE = {'CHEF': 'chef.png'}
PEOPLE_DATA = os.path.join(ROOT, 'tools/canvas/data/custom_people.json')
# a person's frames in HeartGold (12 pictures): up, left x3 (walk, stand, walk), right x3 (stand, walk, walk), up walk
# x2, down, down walk x2 -> the GBA's (0 down, 1 up, 2 left, 3-4 down walking, 5-6 up walking, 7-8 left walking;
# right is left turned over)
HG_FRAMES = [(1, 0), (7, 0), (2, 0), (8, 0), (2, 1), (7, 1), (8, 1), (5, 0), (6, 0), (0, 0), (3, 0), (4, 0)]


def write_person(n, png, name):
    from PIL import Image
    import json as J, gba as G
    src = Image.open(G.P('graphics/object_events/pics/people', png))
    src.info['transparency'] = 0
    src = src.convert('RGBA')
    sheet = Image.new('RGBA', (32, 32 * len(HG_FRAMES)))
    for i, (f, flip) in enumerate(HG_FRAMES):
        fr = src.crop((f * 16, 0, f * 16 + 16, 32))
        if flip: fr = fr.transpose(Image.FLIP_LEFT_RIGHT)
        sheet.paste(fr, (8, i * 32), fr)
    q = sheet.convert('RGB').quantize(15, method=Image.Quantize.MEDIANCUT)
    qp = q.getpalette() + [0] * 45
    pal = [(255, 0, 255)] + [tuple(qp[i * 3:i * 3 + 3]) for i in range(15)]
    px = Image.new('P', sheet.size, 0)
    px.putpalette([c for rgb in pal for c in rgb])
    qd, ad, out = q.load(), sheet.split()[3].load(), px.load()
    for y in range(sheet.height):
        for x in range(32):
            if ad[x, y] >= 128: out[x, y] = qd[x, y] + 1
    for f in os.listdir(CUSTOM):
        if f.startswith('%04d' % n): os.remove(os.path.join(CUSTOM, f))
    px.save(os.path.join(CUSTOM, '%04d.png' % n), bits=4)
    open(os.path.join(CUSTOM, '%04d-%s.pal' % (n, name)), 'w').write(
        'JASC-PAL\r\n0100\r\n16\r\n' + ''.join('%d %d %d\r\n' % c for c in pal))
    tmpl = J.load(open(os.path.join(os.path.dirname(CUSTOM), '0029.json')))       # (HeartGold's waiter)
    frames = {k.replace('waiter', name): v for k, v in tmpl['frames'].items()}
    J.dump({'frames': frames, 'palettes': {name: dict(tmpl['palettes']['waiter'], fileName=name + '.pal')}},
           open(os.path.join(CUSTOM, '%04d.json' % n), 'w'), indent='\t')


def main():
    import json as J, glob
    import gba as G
    g = _gba()
    maps = sorted(os.path.basename(os.path.dirname(f)) for f in glob.glob(G.P('data/maps/*/map.json')))
    pics, out = {}, {}
    for d in maps:
        if not BUILT.match(d): continue
        bs = barriers(d, g)
        if not bs: continue
        fr = fronts(d)
        sq_out = []
        for sq in sorted(bs, key=lambda s: (s[1], s[0])):
            b = bs[sq]
            sprite = FIRST
            if sq in fr:
                im = image(d, sq)
                k = im.tobytes()
                if k not in pics: pics[k] = (FIRST + 1 + len(pics), im)
                sprite = pics[k][0]
            sq_out.append(dict(x=sq[0], y=sq[1], base=b['base'], open=b['open'], sprite=TAG0 + sprite))
        out[d] = dict(layout=G.map_json(d)['layout'], squares=sq_out)
    J.dump(out, open(DATA, 'w'), indent=1)
    from PIL import Image
    write_overworld(FIRST, Image.new('RGBA', (32, 32)), 'cv_none')
    for n, im in sorted(pics.values(), key=lambda t: t[0]):
        write_overworld(n, im, 'cv_bar%d' % n)
    last = FIRST + len(pics)
    # people HeartGold has no sprite for (PEOPLE): after the barriers
    people = {}
    for k, (key, png) in enumerate(sorted(PEOPLE.items())):
        n = last + 1 + k
        write_person(n, png, 'cv_' + key.lower())
        people[key] = TAG0 + n
    J.dump(people, open(PEOPLE_DATA, 'w'), indent=1, sort_keys=True)
    last_bar, last = last, last + len(people)
    for f in os.listdir(CUSTOM):         # (pictures no longer used)
        m = re.match(r'(\d{4})', f)
        if m and int(m.group(1)) > last: os.remove(os.path.join(CUSTOM, f))
    # the engine's overworld table: the fossil, then ours (still pictures, no shadow: a scroll's settings)
    src = open(TABLE).read()
    src = re.sub(r'#define MON_OVERWORLD_GFX_START \(\d+\)[^\n]*',
                 '#define MON_OVERWORLD_GFX_START (%d)   // Pokemon Canvas: our own overworlds (the fossil, the barriers, people)' % (297 + last + 1), src)
    src = re.sub(r'\n {8}\{ \.tag = NEW_NPC_TAG_START \+ (?!0,)\d+,[^\n]*', '', src)
    entries = ''.join('\n        { .tag = NEW_NPC_TAG_START + %d, .gfx = NEW_NPC_GFX_START + %d, .callback_params = 0x0024 },   // %s'
                      % (n, n, 'a barrier: nothing to see (barriers.py)' if n == FIRST else 'a barrier (barriers.py)')
                      for n in range(FIRST, last_bar + 1))
    entries += ''.join('\n        { .tag = NEW_NPC_TAG_START + %d, .gfx = NEW_NPC_GFX_START + %d, .callback_params = 0x0000 },   // a person: %s (barriers.py PEOPLE)'
                       % (t - TAG0, t - TAG0, k) for k, t in sorted(people.items(), key=lambda kv: kv[1]))
    src = re.sub(r'(\{ \.tag = NEW_NPC_TAG_START \+ 0,[^\n]*)', lambda m: m.group(1) + entries, src, count=1)
    open(TABLE, 'w').write(src)
    print('%d maps, %d squares, %d pictures; now run tools/canvas/engine/make_patch.sh' %
          (len(out), sum(len(v['squares']) for v in out.values()), len(pics)))


if __name__ == '__main__':
    main()
