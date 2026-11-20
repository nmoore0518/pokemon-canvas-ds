"""Read maps out of the GBA game (nmoore0518/gym-trainer-hack): layouts, metatiles, behaviours, events; render to PNG.

    python3 tools/canvas/gba_map.py MAP_DIR_NAME out.png      (e.g. PalletTown_PlayersHouse_1F_Frlg)
Set GBA_REPO to the GBA checkout (default /home/claude/gym-trainer-hack).
"""
import json, os, re, struct, sys
from functools import lru_cache
from PIL import Image

GBA = os.environ.get('GBA_REPO', '/home/claude/gym-trainer-hack')
P = lambda *a: os.path.join(GBA, *a)


@lru_cache(None)
def _sources():
    return (open(P('src/data/tilesets/headers.h')).read(), open(P('src/data/tilesets/graphics.h')).read(),
            open(P('src/data/tilesets/metatiles.h')).read())


@lru_cache(None)
def layouts():
    return {l['id']: l for l in json.load(open(P('data/layouts/layouts.json')))['layouts'] if 'id' in l}


@lru_cache(None)
def tileset(name):
    """-> dict(tiles=[8x8 index lists], pals=[[rgb]*16]*n, metatiles=[[8 entries]], attrs=[u32])"""
    hdr, gfx, mt = _sources()
    m = re.search(r'const struct Tileset %s =\s*\{(.*?)\};' % re.escape(name), hdr, re.S)
    body = m.group(1)
    sym = lambda k: re.search(r'\.%s = (\w+)' % k, body).group(1)
    tiles_png = re.search(r'%s\[\] = INCGFX_U32\("([^"]+)"' % sym('tiles'), gfx).group(1)
    pal_block = re.search(r'%s\[\]\[16\] =\s*\{(.*?)\};' % sym('palettes'), gfx, re.S).group(1)
    pal_files = re.findall(r'"([^"]+\.pal)"', pal_block)
    m1 = re.search(r'%s\[\] = INCBIN_U16\("([^"]+)"' % sym('metatiles'), mt)
    d = os.path.dirname(tiles_png)       # (some are put together at run time: use the tileset folder's files)
    mt_bin = m1.group(1) if m1 else d + '/metatiles.bin'
    m2 = re.search(r'\.metatileAttributes = (?:\([^)]*\))?\s*(\w+)', body)
    m2 = m2 and re.search(r'%s\[\] = INCBIN_U(?:16|32)\("([^"]+)"' % m2.group(1), mt)
    at_bin = m2.group(1) if m2 else d + '/metatile_attributes.bin'
    im = Image.open(P(tiles_png))
    w, h = im.size
    px = im.load()
    tiles = []
    for ty in range(h // 8):
        for tx in range(w // 8):
            tiles.append([px[tx * 8 + x, ty * 8 + y] & 15 for y in range(8) for x in range(8)])
    pals = []
    for f in pal_files:
        lines = open(P(f)).read().split('\n')
        cols = [tuple(int(v) for v in l.split()) for l in lines[3:19] if l.strip()]
        pals.append(cols + [(0, 0, 0)] * (16 - len(cols)))
    raw = open(P(mt_bin), 'rb').read()
    metas = [list(struct.unpack_from('<8H', raw, i)) for i in range(0, len(raw), 16)]
    ar = open(P(at_bin), 'rb').read()
    asz = len(ar) // max(1, len(metas))
    attrs = [struct.unpack_from('<I' if asz == 4 else '<H', ar, i)[0] for i in range(0, len(ar), asz)]
    return {'tiles': tiles, 'pals': pals, 'metatiles': metas, 'attrs': attrs, 'attr_size': asz}


class Layout:
    def __init__(self, layout_id, raw=False):
        L = layouts()[layout_id]
        self.id, self.w, self.h = layout_id, L['width'], L['height']
        frlg = L.get('layout_version') == 'frlg'
        self.n_prim = 640 if frlg else 512
        self.t_prim = 640 if frlg else 512
        self.p_prim = 7 if frlg else 6
        self.prim, self.sec = tileset(L['primary_tileset']), tileset(L['secondary_tileset'])
        data = open(P(L['blockdata_filepath']), 'rb').read()
        b = struct.unpack('<%dH' % (len(data) // 2), data)
        self.blocks = [[b[y * self.w + x] for x in range(self.w)] for y in range(self.h)]
        import scrapped        # (squares of what the port leaves out, drawn as the ground round them)
        for x, y, mt, coll in scrapped.LAYOUT_EDITS.get(layout_id, ()):
            self.blocks[y][x] = (self.blocks[y][x] & 0xF000) | mt | (coll << 10)
        if not raw:         # (squares a script opens and closes are built open: port/barriers.py)
            for sq in _barriers().get(layout_id, []):
                if sq['base']: self.blocks[sq['y']][sq['x']] = sq['open'] | (self.blocks[sq['y']][sq['x']] & 0xF000)
        import reshape         # (a town laid out anew inside its map: reshape.py)
        self.blocks = reshape.blocks(layout_id, self.blocks)

    def metatile(self, x, y): return self.blocks[y][x] & 0x3FF
    def collision(self, x, y): return (self.blocks[y][x] >> 10) & 3
    def elevation(self, x, y): return self.blocks[y][x] >> 12

    def _meta(self, mid):
        return self.prim['metatiles'][mid] if mid < self.n_prim else self.sec['metatiles'][mid - self.n_prim]

    def attr(self, mid):
        ts = self.prim if mid < self.n_prim else self.sec
        i = mid if mid < self.n_prim else mid - self.n_prim
        return ts['attrs'][i] if i < len(ts['attrs']) else 0

    def behavior(self, mid):
        a = self.attr(mid)
        return a & 0x1FF if self.prim['attr_size'] == 4 else a & 0xFF

    def pal(self, i):
        return (self.prim['pals'] + [[(0, 0, 0)] * 16] * 16)[i] if i < self.p_prim else (self.sec['pals'])[i] if i < len(self.sec['pals']) else [(255, 0, 255)] * 16

    def render_metatile(self, mid, layers=(0, 1)):
        im = Image.new('RGBA', (16, 16), (0, 0, 0, 0))
        px = im.load()
        ents = self._meta(mid)
        for layer in layers:
            for k in range(4):
                e = ents[layer * 4 + k]
                t, hf, vf, pal = e & 0x3FF, (e >> 10) & 1, (e >> 11) & 1, e >> 12
                tile = (self.prim['tiles'] + [[0] * 64] * 1024)[t] if t < self.t_prim else \
                    (self.sec['tiles'][t - self.t_prim] if t - self.t_prim < len(self.sec['tiles']) else [0] * 64)
                cols = self.pal(pal)
                ox, oy = (k & 1) * 8, (k >> 1) * 8
                for yy in range(8):
                    for xx in range(8):
                        c = tile[yy * 8 + xx]
                        if c == 0 and layer == 1:
                            continue
                        sx = 7 - xx if hf else xx
                        sy = 7 - yy if vf else yy
                        px[ox + sx, oy + sy] = cols[c] + (255,)
        return im

    def render(self, grid=False):
        im = Image.new('RGBA', (self.w * 16, self.h * 16))
        cache = {}
        for y in range(self.h):
            for x in range(self.w):
                m = self.metatile(x, y)
                if m not in cache: cache[m] = self.render_metatile(m)
                im.alpha_composite(cache[m], (x * 16, y * 16))
        return im


_BARRIERS = {}


def _barriers():
    """layout -> the squares built open (tools/canvas/data/barriers.json, written by port/barriers.py)"""
    if not _BARRIERS:
        f = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'barriers.json')
        _BARRIERS[None] = None
        if os.path.exists(f):
            for v in json.load(open(f)).values():
                _BARRIERS.setdefault(v['layout'], []).extend(v['squares'])
    return _BARRIERS


def map_json(map_dir):
    import scrapped        # (without what the port leaves out: scrapped.py)
    import reshape         # (its events moved with a reshaped layout: reshape.py)
    mj = scrapped.clean(json.load(open(P('data/maps', map_dir, 'map.json'))))
    L = layouts().get(mj.get('layout'), {})
    return reshape.events(mj, L.get('width', 0), L.get('height', 0))


if __name__ == '__main__':
    mj = map_json(sys.argv[1])
    lay = Layout(mj['layout'])
    lay.render().save(sys.argv[2])
    print(lay.id, lay.w, lay.h)


def metatile_sheet(layout_id, out, first=0, count=None, cols=16, scale=2):
    """Every metatile of a layout's tilesets, numbered, for building conversion tables"""
    from PIL import ImageDraw
    lay = Layout(layout_id)
    total = lay.n_prim + len(lay.sec['metatiles'])
    ids = [i for i in range(first, total if count is None else min(total, first + count))
           if i < len(lay.prim['metatiles']) or i >= lay.n_prim]
    rows = (len(ids) + cols - 1) // cols
    cw, ch = 16 * scale + 8, 16 * scale + 14
    S = Image.new('RGB', (cols * cw, rows * ch), (40, 40, 40))
    d = ImageDraw.Draw(S)
    for n, i in enumerate(ids):
        x, y = (n % cols) * cw, (n // cols) * ch
        S.paste(lay.render_metatile(i).resize((16 * scale, 16 * scale), Image.NEAREST), (x + 4, y))
        d.text((x + 4, y + 16 * scale), '%X' % i, fill=(255, 255, 0))
    S.save(out)


def render_labeled(map_dir, out, scale=3):
    """A map at `scale`, with each square's metatile id, for writing conversion tables"""
    from PIL import ImageDraw
    lay = Layout(map_json(map_dir)['layout'])
    im = lay.render().resize((lay.w * 16 * scale, lay.h * 16 * scale), Image.NEAREST).convert('RGB')
    d = ImageDraw.Draw(im)
    for y in range(lay.h):
        for x in range(lay.w):
            s = '%X' % lay.metatile(x, y)
            d.text((x * 16 * scale + 2, y * 16 * scale + 2), s, fill=(0, 0, 0))
            d.text((x * 16 * scale + 1, y * 16 * scale + 1), s, fill=(255, 255, 0) if not lay.collision(x, y) else (255, 80, 80))
    im.save(out)
