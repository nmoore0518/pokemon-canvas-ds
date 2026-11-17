"""Canvas: build our Pallet Town into HeartGold's overworld.

Our town (tools/canvas/data/pallet_layout.json, exported from the GBA game) becomes a 2x2 block of HeartGold
land data at matrix cells (32..33, 11..12), drawn with Pallet's own texture set (area 18) and building models.
Writes, idempotently:
  files/a/0/6/5                                   land data 676..679 (collision, buildings, terrain model, heights)
  files/fielddata/mapmatrix/map_matrix/..._EVERYWHERE.bin   the four cells
  files/a/0/4/3                                   area building set 17 (+ the models our town uses)
  files/fielddata/build_model/bm_field.narc (+ matshp)      recoloured houses as models 340..342
  files/fielddata/eventdata/zone_event/046_T01.json         warps, signs and people at our positions
"""
import colorsys, json, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nitro import read_narc, write_narc, read_dict, patricia, read_tex0, tex0_of, write_btx0, u16, u32
from g3d import Mesh, build_model

ROOT = os.path.normpath(os.path.join(HERE, '..', '..'))
F = lambda p: os.path.join(ROOT, p)
LAND_NARC = F('files/a/0/6/5')
MATRIX = F('files/fielddata/mapmatrix/map_matrix/map_matrix_0000_EVERYWHERE.bin')
AREA_BUILD = F('files/a/0/4/3')
AREA_BUILD_TEX = F('files/a/0/7/0')             # per building set: the textures its models are bound to
TEXSETS = F('files/a/0/4/4')
BM_FIELD = F('files/fielddata/build_model/bm_field.narc')
BM_FIELD_FS = F('files/a/0/4/0')               # the copy the field actually loads (NARC 40)
BM_ANIM = F('files/a/1/0/7')                    # per-model door/animation info, one entry per field model
BM_MATSHP = F('files/fielddata/build_model/bm_field_matshp.dat')
EVENTS = F('files/fielddata/eventdata/zone_event/046_T01.json')

ORIG_LAND_COUNT = 676          # land data in the retail game; ours go after
ORIG_BM_COUNT = 340
CELL_X, CELL_Y = 31, 11        # our region: matrix cells (31..33, 11..12), Pallet's cell (32, 11) among them
MAP_PALLET = 49
AREA_SET = 17
TEXSET = 18
RW, RH = 96, 64                # the region in blocks (3x2 lands)
OX = 27                        # where the GBA map's column 0 sits, so its centre road (19..22) meets Route 1
BW, BH = RW // 32, RH // 32
WATERFALL_MODEL = 319          # HeartGold's "dsm_fal1", scaled to fit
STATUE_TEX = 'cv_chansey'

# ---------------------------------------------------------------- the GBA layout, with the changes made for the DS
L = json.load(open(os.path.join(HERE, 'data', 'pallet_layout.json')))
W0, H0 = L['W'], L['H']
c0 = [list(r) for r in L['cells']]
k0 = [list(r) for r in L['coll']]
trees0 = [tuple(t) for t in L['trees']]
# the road north runs straight up the middle between the two house plateaus (18..22) to Route 1
for y in (0, 1):
    for x in range(W0):
        c0[y][x], k0[y][x] = ('P', '0') if 19 <= x <= 22 else ('X', '1')
trees0 = [t for t in trees0 if not (t[1] == 0 and 17 <= t[0] <= 22)]
# one of the two signs below the gym moves to the other side of its stairs
signs0 = [tuple(s) for s in L['signs']]
signs0[signs0.index((16, 28))] = (25, 27)
c0[28][16], k0[28][16] = 'G', '0'
k0[27][25] = '1'
# more rows of grass below the berry field, so there's room to walk round it before the trees
# (HeartGold's trees lean back over about a block behind them, so this takes three)
EXTRA_ROWS = 3
for y in range(H0, H0 + EXTRA_ROWS):
    c0.append(['X'] * 2 + ['G'] * (W0 - 4) + ['X'] * 2)
    k0.append(['1'] * 2 + ['0'] * (W0 - 4) + ['1'] * 2)
    for x in range(30, 34):
        c0[-1][x] = 'W'
H1 = H0 + EXTRA_ROWS


def shift_rec(r):
    r = list(r)
    t = r[0]
    if t == 'raised': r[1] += OX; r[3] += OX; r[7] = [v + OX for v in r[7]]
    elif t == 'cliff_band': r[1] += OX; r[2] += OX; r[5] = [v + OX for v in r[5]]; r[6] = [v + OX for v in r[6]]
    elif t in ('flowers',): r[1] += OX; r[3] += OX
    elif t == 'pond': r[1] += OX; r[3] += OX; r[6] = [v + OX for v in r[6]]
    elif t == 'fence': r[1] += OX; r[2] += OX
    else: r[1] += OX
    return r


REC = [shift_rec(r) for r in L['rec']]
DOORS = {k: (v[0] + OX, v[1]) for k, v in L['doors'].items()}
SIGNS = [(x + OX, y) for x, y in signs0]
DECOR = [(x + OX, y, nm) for x, y, nm, _ in L['decor']]

# ---------------------------------------------------------------- the region: the layout pasted in, trees and water round it
cells = [['X'] * RW for _ in range(RH)]
coll = [['1'] * RW for _ in range(RH)]
for y in range(H1):
    for x in range(W0):
        cells[y][x + OX], coll[y][x + OX] = c0[y][x], k0[y][x]
trees = [(x + OX, y) for x, y in trees0]
for y in range(H1, RH):           # the channel runs on south into Route 21's sea
    for x in range(RW):
        if (OX + 30 <= x <= OX + 33) or (y >= 58 and 34 <= x <= OX + 33):
            cells[y][x], coll[y][x] = 'W', '0'
inside = lambda x, y: OX <= x < OX + W0 and y < H1
for y in range(0, RH, 2):
    for x in range(0, RW - 1, 2):
        if not inside(x, y) and not inside(x + 1, y) and all(cells[yy][xx] == 'X' for yy in (y, y + 1) for xx in (x, x + 1) if yy < RH):
            trees.append((x, y))
# the GBA map's own border trees stop where its rows did: carry the outer columns down the two new rows
trees += [(OX, y) for y in range(H0, H1, 2)] + [(OX + W0 - 2, y) for y in range(H0, H1, 2)]
kind = lambda x, y: cells[y][x] if 0 <= x < RW and 0 <= y < RH else None

# ---------------------------------------------------------------- heights (blocks), as in the 3D mock-up
LOW, RAISE, WATER_DROP = -2.0, 1.0, 0.25
topH = [[LOW if y >= 43 else 0.0 for x in range(RW)] for y in range(RH)]
ramp = [[None] * RW for _ in range(RH)]
rocky = [[False] * RW for _ in range(RH)]
for r in REC:
    if r[0] == 'cliff_band':
        _, x0, x1, y0, y1, stairs, falls = r
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                hb, hf = -0.4 * (y - y0), -0.4 * (y - y0 + 1)
                if x in stairs: ramp[y][x] = (hb, hf, 'stairs')
                elif x in falls: ramp[y][x] = (hb - WATER_DROP, hf - WATER_DROP, 'water')
                else:
                    # HeartGold's terraced cliff: level rock on top, then two tiers down to the shore, each a
                    # block high and sloped back across a square (rim faces: see slanted_face)
                    topH[y][x] = -max(0, (y - y0) - (y1 - y0 - 2)); rocky[y][x] = True
for r in REC:
    if r[0] == 'raised':
        _, x0, y0, x1, y1, interior, _, stairs, _ = r
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                if y == y1 and x in stairs: ramp[y][x] = (RAISE, 0.0, 'stairs'); continue
                topH[y][x] = RAISE
                if x in (x0, x1) or y in (y0, y1) or interior == 'rock': rocky[y][x] = True
is_water = lambda x, y: kind(x, y) == 'W' and not ramp[y][x]


def solid(x, y):
    if not (0 <= x < RW and 0 <= y < RH): return None
    r = ramp[y][x]
    if r: return min(r[0], r[1]) - (0.35 if r[2] == 'water' else 0)
    return topH[y][x] - (0.6 if is_water(x, y) else 0)


GROUND_Y = 16.0                 # HeartGold's ground sits one block up
Y = lambda h: GROUND_Y + 16.0 * h

# ---------------------------------------------------------------- textures (set 18), materials
ts_files, ts_btnf = read_narc(open(TEXSETS, 'rb').read())


STATUE_FINISH = 'gold'    # or 'gold'
STATUE_RAMPS = {   # darkest to lightest; stone is the pedestal's own stone
    'stone': [(40, 44, 64), (65, 74, 106), (90, 90, 115), (123, 123, 131), (148, 164, 180), (200, 208, 216)],
    'gold': [(72, 48, 16), (128, 88, 24), (184, 136, 32), (224, 176, 48), (248, 216, 96), (255, 244, 184)],
}


def statue_texture():
    """32x64 4bpp texture, colour 0 transparent: rows 0..31 HeartGold's own Chansey (her front-facing overworld
    frame, from hg-engine's a/0/8/1) recoloured as a statue; rows 34..47 the GBA game's stone pedestal"""
    from PIL import Image
    im = Image.open(os.path.join(HERE, 'data', 'chansey_statue.png')).convert('RGBA')
    ow = Image.open(os.path.join(HERE, 'data', 'chansey_overworld.png')).convert('RGBA')
    ramp = STATUE_RAMPS[STATUE_FINISH]
    seen = sorted({ow.getpixel((x, y))[:3] for y in range(32) for x in range(32) if ow.getpixel((x, y))[3] >= 128},
                  key=lambda c: 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2])
    lum = lambda c: 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]
    lo, hi = lum(seen[0]), lum(seen[-1])
    tone = {c: ramp[0] if c == seen[0] else ramp[1 + min(len(ramp) - 2, int((lum(c) - lo) / (hi - lo + 1e-6) * (len(ramp) - 1)))] for c in seen}
    im = im.copy()
    for y in range(34):
        for x in range(32):
            c = ow.getpixel((x, y)) if y < 32 else (0, 0, 0, 0)
            im.putpixel((x, y), tone[c[:3]] + (255,) if c[3] >= 128 else (0, 0, 0, 0))
    cols = [(0, 0, 0)]
    idx = []
    for y in range(64):
        for x in range(32):
            r, g, b, a = im.getpixel((x, y)) if y < im.height else (0, 0, 0, 0)
            if a < 128: idx.append(0); continue
            if (r, g, b) not in cols: cols.append((r, g, b))
            idx.append(cols.index((r, g, b)))
    assert len(cols) <= 16
    data = bytes(idx[i] | (idx[i + 1] << 4) for i in range(0, len(idx), 2))
    pal = b''.join(struct.pack('<H', (r >> 3) | ((g >> 3) << 5) | ((b >> 3) << 10)) for r, g, b in cols + [(0, 0, 0)] * (16 - len(cols)))
    prm = (2 << 20) | (3 << 23) | (3 << 26) | (1 << 29)
    return (STATUE_TEX.encode(), prm, 32 | (64 << 11) | 0x80000000, data, b''), ((STATUE_TEX + '_pl').encode(), 0, pal)


_t, _p = read_tex0(ts_files[TEXSET], tex0_of(ts_files[TEXSET]))
_st, _sp = statue_texture()
_t = [t for t in _t if t[0] != _st[0]] + [_st]
_p = [p for p in _p if p[0] != _sp[0]] + [_sp]
ts_files[TEXSET] = write_btx0(_t, _p)
btx = ts_files[TEXSET]
t0 = u32(btx, 0x10)
TEXDIMS = {}
for nm, e in read_dict(btx, t0 + u16(btx, t0 + 0xE)):
    prm = u32(e, 0)
    TEXDIMS[nm.decode()] = (8 << ((prm >> 20) & 7), 8 << ((prm >> 23) & 7))
PALS = {nm.decode() for nm, _ in read_dict(btx, t0 + u32(btx, t0 + 0x34))}
pal_of = lambda t: next(p for p in (t + '_pl', t, t.replace('gs', '')) if p in PALS)
# HeartGold animates Pallet's map materials by index (area animation 0: pond_on, swave_p, pond_edge, sea_line02,
# sea_un, sea_on, river, river_r), so those eight slots come first and only sea_un's is used; anything else put
# there would scroll.
ANIM_SLOTS = ['pond_on', 'swave_p', 'pond_edge', 'sea_line02', 'sea_un', 'sea_on', 'river', 'river_r']
MATS = ['sea_un', 'road01', 'road05', 'grass01gs', 'cliff01gs', 'wall01_g', 'wall01_h', 'slope', 'pond_line',
        'flower01', 'flower02', 'tree01_un', 'fence_a', 'tree01gs', STATUE_TEX]

# ---------------------------------------------------------------- per-land geometry
class Land:
    def __init__(self, bx, by):
        self.bx, self.by = bx, by
        self.mesh = {m: Mesh() for m in MATS}
        self.props = []

    def local(self, gx, gz):        # global block coords -> this land's units (centre origin)
        return (gx - 32 * self.bx) * 16 - 256, (gz - 32 * self.by) * 16 - 256


lands = {(bx, by): Land(bx, by) for by in range(BH) for bx in range(BW)}
land_at = lambda gx, gy: lands[(min(BW - 1, max(0, int(gx) // 32)), min(BH - 1, max(0, int(gy) // 32)))]
UP = (0, 1, 0)


def quad(tex, pts, uvs, n=UP, owner=None):
    """pts: 4 global (x blocks, y units, z blocks); uvs in texels"""
    ld = owner or land_at(pts[0][0] + 0.01, pts[0][2] + 0.01)
    verts = []
    for (x, y, z), uv in zip(pts, uvs):
        lx, lz = ld.local(x, z)
        verts.append(((lx, y, lz), uv))
    ld.mesh[tex].quad(verts, n)


FLAT = {}          # (land, tex, height) -> set of local (x, y): flat tops, merged into rectangles later


def top_quad(tex, x, y, hb, hf):
    if hb == hf:
        FLAT.setdefault(((x // 32, y // 32), tex, hb), set()).add((x % 32, y % 32))
        return
    owner = lands[(x // 32, y // 32)]
    lx, ly = x % 32, y % 32
    u0, u1, v0, v1 = lx * 16, (lx + 1) * 16, ly * 16, (ly + 1) * 16
    quad(tex, [(x, Y(hf), y + 1), (x + 1, Y(hf), y + 1), (x + 1, Y(hb), y), (x, Y(hb), y)],
         [(u0, v1), (u1, v1), (u1, v0), (u0, v0)], owner=owner)


def wall_z(tex, x, z, y0, y1, vscale=16, normal=(0, 0, 1)):
    owner = lands[(x // 32, min(RH - 1, z) // 32)]
    u0, u1 = (x % 32) * 16, (x % 32 + 1) * 16
    quad(tex, [(x, Y(y0), z), (x + 1, Y(y0), z), (x + 1, Y(y1), z), (x, Y(y1), z)],
         [(u0, (y1 - y0) * vscale), (u1, (y1 - y0) * vscale), (u1, 0), (u0, 0)], normal, owner)


def wall_x(tex, x, z, y0, y1, vscale=16, normal=(1, 0, 0)):
    owner = lands[(min(RW - 1, x) // 32, z // 32)]
    u0, u1 = (z % 32) * 16, (z % 32 + 1) * 16
    quad(tex, [(x, Y(y0), z + 1), (x, Y(y0), z), (x, Y(y1), z), (x, Y(y1), z + 1)],
         [(u1, (y1 - y0) * vscale), (u0, (y1 - y0) * vscale), (u0, 0), (u1, 0)], normal, owner)


def rim(x, y):
    """a plateau's edge square, one tier above the ground beside it and not walkable: HeartGold slopes its cliff
    face back across such a square (the face rises two thirds of a block back, then a lip to the whole block)"""
    if not (0 <= x < RW and 0 <= y < RH) or coll[y][x] != '1' or ramp[y][x]: return False
    return any(lower_by_tier(x, y, x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))


def lower_by_tier(x, y, x2, y2):
    s2 = solid(x2, y2)
    return s2 is not None and not ramp[y2][x2] and abs(topH[y][x] - s2 - 1.0) < 0.01


def ground_tex(x, y):
    k = kind(x, y)
    if rocky[y][x]: return 'cliff01gs'
    if k == 'P': return 'road01'
    if k == 'S': return 'road05'
    return 'grass01gs'


for y in range(RH):
    for x in range(RW):
        r = ramp[y][x]
        if r and r[2] == 'water':                   # the waterfall model is the surface; this is the pool behind it
            top_quad('sea_un', x, y, r[0] - 1.0, r[1] - 1.0); continue
        if r:
            owner = lands[(x // 32, y // 32)]
            v = 24 * (r[0] - r[1])            # three steps to a block of height, as HeartGold's stairs have
            quad('slope', [(x, Y(r[1]), y + 1), (x + 1, Y(r[1]), y + 1), (x + 1, Y(r[0]), y), (x, Y(r[0]), y)],
                 [(0, v), (32, v), (32, 0), (0, 0)], (0, 0.7, 0.7), owner)
            continue
        if is_water(x, y): top_quad('sea_un', x, y, topH[y][x] - WATER_DROP, topH[y][x] - WATER_DROP); continue
        if rim(x, y): continue                     # (its slope is the face: see below)
        top_quad(ground_tex(x, y), x, y, topH[y][x], topH[y][x])


def emit_flat():
    for (key, tex, h), tiles in FLAT.items():
        owner = lands[key]
        left = set(tiles)
        for ly in range(32):
            for lx in range(32):
                if (lx, ly) not in left: continue
                w = 1
                while (lx + w, ly) in left: w += 1
                d = 1
                while all((lx + i, ly + d) in left for i in range(w)): d += 1
                for j in range(d):
                    for i in range(w): left.discard((lx + i, ly + j))
                gx, gy = 32 * key[0] + lx, 32 * key[1] + ly
                u0, u1, v0, v1 = lx * 16, (lx + w) * 16, ly * 16, (ly + d) * 16
                quad(tex, [(gx, Y(h), gy + d), (gx + w, Y(h), gy + d), (gx + w, Y(h), gy), (gx, Y(h), gy)],
                     [(u0, v1), (u1, v1), (u1, v0), (u0, v0)], owner=owner)


emit_flat()


def face(hi, lo):
    if is_water(*lo) and not is_water(*hi): return 'pond_line', 25.6
    return ('wall01_h' if rocky[hi[1]][hi[0]] else 'wall01_g'), 16


# HeartGold's cliff profile (read off its own maps: the same in caves and outside): (back in blocks, height up, row)
CLIFF = [(0, 0, 15.75), (0.21, 0.1, 13), (0.67, 1.0, 4), (1.0, 1.0, 0.25)]
SLANTED = set()


def slanted_face(lo, n):
    """the face from ground square lo up into the rim square lo+n, leaning back across it; corners mitred"""
    (x, y) = lo
    hi = (x + n[0], y + n[1])
    t = (1, 0) if n[0] == 0 else (0, 1)
    top = topH[hi[1]][hi[0]]
    # (the plateau goes on there: its own ground, or stairs that climb to it - the face runs straight up to them)
    same = lambda xx, yy: 0 <= xx < RW and 0 <= yy < RH and (max(ramp[yy][xx][:2]) >= top - 0.01 if ramp[yy][xx] else topH[yy][xx] >= top - 0.01)
    ex, ey = x + (1 if n[0] > 0 else 0), y + (1 if n[1] > 0 else 0)
    ends, dirs = [], []
    for j, sgn in ((0, -1), (1, 1)):
        side, diag = (x + sgn * t[0], y + sgn * t[1]), (x + sgn * t[0] + n[0], y + sgn * t[1] + n[1])
        on_ramp = lambda xx, yy: 0 <= xx < RW and 0 <= yy < RH and ramp[yy][xx]
        if same(*side): d = (n[0] + sgn * t[0], n[1] + sgn * t[1])          # (an inside corner)
        elif same(*diag) or on_ramp(*diag): d = n                            # (straight on: stairs or falls beside
                                                                             # it have their own side wall)
        else: d = (n[0] - sgn * t[0], n[1] - sgn * t[1])                     # (an outside corner)
        ends.append((ex + t[0] * j, ey + t[1] * j)); dirs.append(d)
    tex = 'wall01_h' if rocky[hi[1]][hi[0]] else 'wall01_g'
    base = solid(x, y)
    u = [(e[0] if n[0] == 0 else e[1]) * 16 for e in ends]
    nrm = (-n[0] * 0.6, 0.8, -n[1] * 0.6)
    P = lambda k, d, h: (ends[k][0] + dirs[k][0] * d, Y(base + h), ends[k][1] + dirs[k][1] * d)
    # where the face ends against walkable ground of the plateau, close the end of its slope (or the dark
    # beneath shows through as a triangle)
    for k, sgn in ((0, -1), (1, 1)):
        diag = (x + sgn * t[0] + n[0], y + sgn * t[1] + n[1])
        if dirs[k] == n and 0 <= diag[0] < RW and 0 <= diag[1] < RH and not ramp[diag[1]][diag[0]] and not rim(*diag) \
                and topH[diag[1]][diag[0]] >= top - 0.01:
            quad(tex, [P(k, 0, 0), P(k, 0, 1.0), P(k, 1.0, 1.0), P(k, 0.67, 1.0)], [(u[k], 15.75), (u[k] + 16, 0.25), (u[k] + 16, 0.25), (u[k] + 8, 4)],
                 (t[0] * sgn, 0, t[1] * sgn), lands[(hi[0] // 32, hi[1] // 32)])
    for (d0, h0, v0), (d1, h1, v1) in zip(CLIFF, CLIFF[1:]):
        quad(tex, [P(0, d0, h0), P(1, d0, h0), P(1, d1, h1), P(0, d1, h1)], [(u[0], v0), (u[1], v0), (u[1], v1), (u[0], v1)],
             nrm, lands[(hi[0] // 32, hi[1] // 32)])


for y in range(RH):
    for x in range(RW):
        for n in ((0, -1), (0, 1), (-1, 0), (1, 0)):
            if rim(x + n[0], y + n[1]) and lower_by_tier(x + n[0], y + n[1], x, y) and coll[y][x] is not None:
                slanted_face((x, y), n)
                SLANTED.add(((x, y), (x + n[0], y + n[1])))

for y in range(RH):
    for x in range(RW):
        a, right, down = solid(x, y), solid(x + 1, y), solid(x, y + 1)
        slanted = lambda p, q: (p, q) in SLANTED or (q, p) in SLANTED
        if right is not None and abs(a - right) > 0.01 and not slanted((x, y), (x + 1, y)):
            hi, lo = ((x, y), (x + 1, y)) if a > right else ((x + 1, y), (x, y))
            t, vs = face(hi, lo)
            wall_x(t, x + 1, y, min(a, right), max(a, right), vs, (1 if a > right else -1, 0, 0))
        falls = lambda xx, yy: 0 <= yy < RH and ramp[yy][xx] and ramp[yy][xx][2] == 'water'
        if down is not None and abs(a - down) > 0.01 and not (falls(x, y) and falls(x, y + 1)) and not slanted((x, y), (x, y + 1)):
            hi, lo = ((x, y), (x, y + 1)) if a > down else ((x, y + 1), (x, y))
            t, vs = face(hi, lo)
            wall_z(t, x, y + 1, min(a, down), max(a, down), vs, (0, 0, 1 if a > down else -1))

# flowers: HeartGold's decals, one to a block
for y in range(RH):
    for x in range(RW):
        if kind(x, y) == 'F' and not ramp[y][x]:
            h = Y(topH[y][x]) + 1
            t = 'flower02' if (x + y) % 2 else 'flower01'
            quad(t, [(x, h, y + 1), (x + 1, h, y + 1), (x + 1, h, y), (x, h, y)], [(0, 16), (16, 16), (16, 0), (0, 0)],
                 owner=lands[(x // 32, y // 32)])

# trees: a shadow under each 2x2 and HeartGold's leaning card
for (x, y) in sorted(trees, key=lambda t: (t[1], t[0])):
    base = min(v for v in (solid(x, y + 1), solid(x + 1, y + 1)) if v is not None)
    owner = lands[(x // 32, y // 32)]
    h = Y(base) + 1
    quad('tree01_un', [(x, h, y + 2), (x + 2, h, y + 2), (x + 2, h, y), (x, h, y)], [(0, 32), (32, 32), (32, 0), (0, 0)], owner=owner)
    cx, z = x + 1, y + 1.625
    quad('tree01gs', [(cx - 2, Y(base), z), (cx + 2, Y(base), z), (cx + 2, Y(base) + 49.3, z - 2.548), (cx - 2, Y(base) + 49.3, z - 2.548)],
         [(0, 64), (64, 64), (64, 0), (0, 0)], (0, 0.6, 0.8), owner)

for r in REC:
    if r[0] == 'fence':
        _, x0, x1, yy = r[:4]
        for fx in range(x0, x1 + 1):
            h = Y(solid(fx, yy)) + 0.35
            z = yy + 0.85
            quad('fence_a', [(fx, h, z), (fx + 1, h, z), (fx + 1, h + 11.3, z - 0.708), (fx, h + 11.3, z - 0.708)],
                 [(fx * 16, 16), ((fx + 1) * 16, 16), ((fx + 1) * 16, 0), (fx * 16, 0)], (0, 0.7, 0.7), lands[(fx // 32, yy // 32)])

# stair rails: a low wall down each side of every flight, from the brown end of the slope texture
RAIL_UV = [(2, 30), (10, 30), (10, 26), (2, 26)]
for y in range(RH):
    x = 0
    while x < RW:
        r = ramp[y][x]
        if not (r and r[2] == 'stairs'): x += 1; continue
        x1 = x
        while x1 + 1 < RW and ramp[y][x1 + 1] == r: x1 += 1
        owner = lands[(x // 32, y // 32)]
        for ex in (x - 0.15, x1 + 1 - 0.1):
            a, b = ex, ex + 0.25
            yb, yf = Y(r[0]) + 6, Y(r[1]) + 6
            lb, lf = Y(r[0]) - 2, Y(r[1]) - 2
            quad('slope', [(a, yf, y + 1), (b, yf, y + 1), (b, yb, y), (a, yb, y)], RAIL_UV, (0, 0.7, 0.7), owner)   # top
            quad('slope', [(a, lf, y + 1), (a, yf, y + 1), (a, yb, y), (a, lb, y)], RAIL_UV, (-1, 0, 0), owner)      # sides
            quad('slope', [(b, lb, y), (b, yb, y), (b, yf, y + 1), (b, lf, y + 1)], RAIL_UV, (1, 0, 0), owner)
            if not (y + 1 < RH and ramp[y + 1][x] and ramp[y + 1][x][2] == 'stairs'):                          # end post
                quad('slope', [(a, lf, y + 1), (b, lf, y + 1), (b, yf, y + 1), (a, yf, y + 1)], RAIL_UV, (0, 0, 1), owner)
        x = x1 + 1

# the Chansey statue: a stone pedestal and the GBA game's Chansey, standing up like HeartGold's trees
for dx, dy, nm in DECOR:
    if nm != 'chansey': continue
    owner = lands[(dx // 32, dy // 32)]
    x0, x1, z0, z1 = dx + 0.1, dx + 1.9, dy + 1.15, dy + 2.85
    yb = Y(solid(dx, dy + 1)); yt = yb + 12
    T = STATUE_TEX
    quad(T, [(x0, yb, z1), (x1, yb, z1), (x1, yt, z1), (x0, yt, z1)], [(3, 47), (29, 47), (29, 34), (3, 34)], (0, 0, 1), owner)
    quad(T, [(x0, yt, z1), (x1, yt, z1), (x1, yt, z0), (x0, yt, z0)], [(5, 37), (26, 37), (26, 35), (5, 35)], UP, owner)
    side = [(7, 43), (12, 43), (12, 38), (7, 38)]
    quad(T, [(x0, yb, z0), (x0, yb, z1), (x0, yt, z1), (x0, yt, z0)], side, (-1, 0, 0), owner)
    quad(T, [(x1, yb, z1), (x1, yb, z0), (x1, yt, z0), (x1, yt, z1)], side, (1, 0, 0), owner)
    quad(T, [(x1, yb, z0), (x0, yb, z0), (x0, yt, z0), (x1, yt, z0)], side, (0, 0, -1), owner)
    # Chansey herself: HeartGold's own Chansey sprite in stone, enlarged, stood up facing the camera like
    # HeartGold's people (bounding box of her front frame: x 6..25, y 13..30 of the texture)
    SC = 1.7                                  # units per pixel (her real sprite is 1)
    u0, u1, v0, v1 = 6, 25, 13, 30
    w = (u1 - u0) * SC / 16
    xc, zc = dx + 1, (z0 + z1) / 2 + 0.25
    hgt = (v1 - v0) * SC
    back = hgt * 0.6 / 16                     # leaning back as far as the camera looks down
    quad(T, [(xc - w / 2, yt, zc), (xc + w / 2, yt, zc), (xc + w / 2, yt + hgt * 0.8, zc - back), (xc - w / 2, yt + hgt * 0.8, zc - back)],
         [(u0, v1), (u1, v1), (u1, v0), (u0, v0)], (0, 0.6, 0.8), owner)

# ---------------------------------------------------------------- buildings (HeartGold models), lined up on our doors
BM_HOUSE = {'red': 313, 'blue': 340, 'green': 341, 'purple': 342}
BUILDINGS = {   # model, door model, door offset from the model's origin (units), door model's centre x
    'house': (None, 310, (-6.0, 2.64, 19.52), -10.0),
    'lab': (314, 311, (10.0, 2.64, 19.52), -10.0),
    'pokemon_center': (40, 15, (0, 0, 25.73), 0),
    'mart': (39, 15, (-8.93, 0, 12.11), 0),
    'gym': (318, 16, (0, 0, 22.48), 0),
}
DOOR_OF = {'lab': 'LAB_DOOR', 'pokemon_center': 'PC_DOOR', 'mart': 'MART_DOOR', 'gym': 'GYM_DOOR'}
door_tiles = set()


def prop(model, gx, y, gz, scale=(1, 1, 1)):
    ld = land_at(gx, gz)
    lx, lz = ld.local(gx, gz)
    ld.props.append((model, lx, y, lz, scale))


for r in REC:
    t, x, y = r[0], r[1], r[2]
    if t in BUILDINGS:
        model, door, off, cx = BUILDINGS[t]
        dx, dy = (x + 1, y + 4) if t == 'house' else DOORS[DOOR_OF[t]]
        door_tiles.add((dx, dy))
        base = Y(topH[dy][dx])
        ox, oz = (dx + 0.5) * 16 - off[0] - cx, (dy + 1) * 16 - off[2]
        prop(BM_HOUSE[r[3]] if t == 'house' else model, ox / 16, base, oz / 16)
        prop(door, (ox + off[0]) / 16, base + off[1], (oz + off[2]) / 16)
    elif t == 'mailbox':
        prop(30, x + 0.5, Y(solid(x, y + 1)), y + 1.35)
for sx, sy in SIGNS:
    prop(29, sx + 0.5, Y(solid(sx, sy)), sy + 0.35)
# the waterfall: HeartGold's model (10 wide, 4.15 high, 4.17 deep, top at the back) stretched over our falls
for r in REC:
    if r[0] == 'cliff_band' and r[6]:
        _, bx0, bx1, y0, y1, stairs, falls = r
        top, bottom = Y(0.0), Y(LOW - WATER_DROP)
        sx, sy, sz = len(falls) / 10.0, (top - bottom) / 16 / 4.15, (y1 + 1 - y0) / 4.17
        prop(WATERFALL_MODEL, min(falls) + len(falls) / 2, top - 3.65 * 16 * sy, y0 + 0.4 * sz, (sx, sy, sz))
for dx, dy, nm in DECOR:
    if nm == 'lamp': prop(95, dx + 0.4, Y(solid(dx, dy + 1)), dy + 1.4)
    elif nm == 'bench': prop(178, dx + 0.9, Y(solid(dx, dy)), dy + 0.4)


def building_entries(ld):
    out = b''
    for model, x, y, z, sc in ld.props:
        f = lambda v: int(round(v * 4096))
        out += struct.pack('<I3i3i3i8x', model, f(x), f(y), f(z), 0, 0, 0, *[f(v) for v in sc])
    assert len(ld.props) <= 32, ('too many props in a land', len(ld.props))
    return out

# ---------------------------------------------------------------- collision and behaviours
TREE_TILES = {(x + i, y + j) for x, y in trees for i in (0, 1) for j in (0, 1)}


def perm(ld):
    out = []
    for ly in range(32):
        for lx in range(32):
            gx, gy = 32 * ld.bx + lx, 32 * ld.by + ly
            k = kind(gx, gy)
            if (gx, gy) in door_tiles: v = 0x8069
            elif k == 'W': v = 0x0015 if coll[gy][gx] == '0' or is_water(gx, gy) else 0x8000
            elif coll[gy][gx] == '1': v = 0x8006 if (gx, gy) in TREE_TILES else 0x8000
            else: v = 0x0400 if k != 'P' else 0x0000
            if ramp[gy][gx] and ramp[gy][gx][2] == 'water': v = 0x8000
            out.append(v)
    return struct.pack('<1024H', *out)

# ---------------------------------------------------------------- the way down to Route 21
# HeartGold's Route 21 is below us with its sea at 7 (and a clear layer over it at 8); our shore, under the cliffs, has its own at -20. The last
# rows of the region (the channel between the trees and the bay it opens into: nothing but sea and forest) lean up
# to meet it: everything in them, sea, ground, trees and the heights walked on, is lifted by how far down the rows
# it is. From above a sea leaning ten degrees is still a sea, and someone surfing down it comes out level with
# Route 21's instead of under it.
TILT_ROW, TILT_BY = 55, 27.0
tilt_at = lambda ld, z: max(0.0, z - ((TILT_ROW - 32 * ld.by) * 16 - 256)) * TILT_BY / ((RH - TILT_ROW) * 16) if ld.by == BH - 1 else 0.0


def _cut(verts, z0, keep_far):
    """the part of a face on one side of z = z0 (each vertex ((x, y, z), (s, t)))"""
    out = []
    inside = lambda v: (v[0][2] >= z0) == keep_far or abs(v[0][2] - z0) < 1e-6
    for a, b in zip(verts, verts[1:] + verts[:1]):
        if inside(a): out.append(a)
        if (a[0][2] - z0) * (b[0][2] - z0) < -1e-9:
            t = (z0 - a[0][2]) / (b[0][2] - a[0][2])
            out.append((tuple(a[0][k] + t * (b[0][k] - a[0][k]) for k in range(3)), tuple(a[1][k] + t * (b[1][k] - a[1][k]) for k in range(2))))
    return out


def tilt(ld):
    if ld.by != BH - 1: return
    z0 = (TILT_ROW - 32 * ld.by) * 16 - 256
    lift = lambda verts: [((x, y + tilt_at(ld, z), z), uv) for (x, y, z), uv in verts]
    for mesh in ld.mesh.values():
        quads, tris = [], []
        for verts, n in mesh.quads + mesh.tris:
            zs = [v[0][2] for v in verts]
            # (a level face lying across the first tilted row's edge is cut along it, so that it bends there)
            parts = [verts] if not (min(zs) < z0 - 0.01 and max(zs) > z0 + 0.01 and abs(n[1]) > 0.99) else \
                [_cut(verts, z0, False), _cut(verts, z0, True)]
            for q in parts:
                assert len(q) in (3, 4), q
                (quads if len(q) == 4 else tris).append((lift(q), n))
        mesh.quads, mesh.tris = quads, tris
    ld.props = [(model, x, y + tilt_at(ld, z), z, sc) for model, x, y, z, sc in ld.props]
    # (a strip of sea just under the bottom edge and out past it, for the single pixels that show through where
    # the corners of our squares fall along the edge of Route 21's bigger ones)
    h = Y(LOW - WATER_DROP) + TILT_BY - 0.3
    ld.mesh['sea_un'].quad([((-256, h, 264), (0, 520)), ((256, h, 264), (512, 520)), ((256, h, 250), (512, 506)), ((-256, h, 250), (0, 506))], (0, 1, 0))


# ---------------------------------------------------------------- heights: one plate per run of equal flat blocks in a row
def bdhc(ld):
    pts, nrm, cst, plates, strips, access = [], [], [], [], [], []
    idx = lambda lst, v: lst.index(v) if v in lst else (lst.append(v) or len(lst) - 1)
    fx = lambda v: int(round(v * 4096))
    for ly in range(32):
        row = []
        lx = 0
        while lx < 32:
            gx, gy = 32 * ld.bx + lx, 32 * ld.by + ly
            r = ramp[gy][gx]
            if r and r[2] == 'stairs':
                key = ('ramp', r[0], r[1]); end = lx + 1
                while end < 32 and ramp[gy][32 * ld.bx + end] == r: end += 1
            else:
                h = topH[gy][gx] - (WATER_DROP if is_water(gx, gy) or (r and r[2] == 'water') else 0)
                key = ('flat', h); end = lx + 1
                while end < 32:
                    g2 = 32 * ld.bx + end
                    r2 = ramp[gy][g2]
                    h2 = topH[gy][g2] - (WATER_DROP if is_water(g2, gy) or (r2 and r2[2] == 'water') else 0)
                    if (r2 and r2[2] == 'stairs') or h2 != h: break
                    end += 1
            x0, x1 = lx * 16 - 256, end * 16 - 256
            z0, z1 = ly * 16 - 256, (ly + 1) * 16 - 256
            if key[0] == 'flat' and tilt_at(ld, z1) > 0:
                s = TILT_BY / ((RH - TILT_ROW) * 16.0)
                ln = (1 + s * s) ** 0.5
                n = (0, fx(1 / ln), fx(-s / ln))
                d = fx(-(Y(key[1]) + tilt_at(ld, z0) - s * z0) / ln)
            elif key[0] == 'flat':
                n, d = (0, 4096, 0), -fx(Y(key[1]))
            else:
                yb, yf = Y(key[1]), Y(key[2])
                s = (yf - yb) / 16.0                     # dy/dz
                ln = (1 + s * s) ** 0.5
                n = (0, fx(1 / ln), fx(-s / ln))
                d = fx(-(yb - s * z0) / ln)
            p0, p1 = idx(pts, (fx(x0), fx(z0))), idx(pts, (fx(x1), fx(z1)))
            plates.append((p0, p1, idx(nrm, n), idx(cst, d)))
            row.append(len(plates) - 1)
            lx = end
        strips.append((fx((ly + 1) * 16 - 256), len(row), len(access)))
        access += row
    body = struct.pack('<4s6H', b'BDHC', len(pts), len(nrm), len(cst), len(plates), len(strips), len(access))
    body += b''.join(struct.pack('<2i', *p) for p in pts) + b''.join(struct.pack('<3i', *v) for v in nrm)
    body += b''.join(struct.pack('<i', c) for c in cst) + b''.join(struct.pack('<4H', *p) for p in plates)
    body += b''.join(struct.pack('<iHH', *s) for s in strips) + b''.join(struct.pack('<H', a) for a in access)
    return body


def land_file(ld):
    tilt(ld)
    groups = []
    for i, slot in enumerate(ANIM_SLOTS):
        mesh = ld.mesh['sea_un'] if slot == 'sea_un' else Mesh()
        groups.append((slot, 'sea_un', pal_of('sea_un'), mesh, {'repeat': 3, 'flip': 0, 'size': TEXDIMS['sea_un']}))
    for m in MATS[1:]:
        opts = {'repeat': 3, 'flip': 0, 'size': TEXDIMS[m]}
        if m in ('tree01gs', 'tree01_un', 'flower01', 'flower02', STATUE_TEX): opts['repeat'] = 0
        groups.append((m, m, pal_of(m), ld.mesh[m], opts))
    model = build_model('canvas_pallet_%d%d' % (ld.bx, ld.by), groups)
    model += b'\0' * (-len(model) % 4)
    p, b, h = perm(ld), building_entries(ld), bdhc(ld)
    return struct.pack('<4I2H', len(p), len(b), len(model), len(h), 0x1234, 0) + p + b + model + h


# ---------------------------------------------------------------- recoloured houses: copies of Kanto's red house
def rename_in_dict(d, o, mapping):
    n = d[o + 1]
    p = o + u16(d, o + 6)
    unit = u16(d, p)
    nb = p + 4 + n * unit
    names = [bytes(d[nb + 16 * i:nb + 16 * i + 16]).rstrip(b'\0') for i in range(n)]
    names = [mapping.get(x, x) for x in names]
    for i, x in enumerate(names):
        d[nb + 16 * i:nb + 16 * i + 16] = x.ljust(16, b'\0')
    for i, nd in enumerate(patricia(names)):
        d[o + 8 + 4 * i:o + 12 + 4 * i] = bytes(nd)


def rename_textures(d, mapping):
    """Building textures share VRAM by name, so a recoloured copy needs names of its own"""
    t = u32(d, 0x10 + 4 * (u16(d, 0xE) - 1))
    rename_in_dict(d, t + u16(d, t + 0xE), mapping)
    rename_in_dict(d, t + u32(d, t + 0x34), mapping)
    m0 = u32(d, 0x10)
    mo = m0 + u32(d, m0 + 8 + u16(d, m0 + 8 + 6) + 4)
    mb = mo + u32(d, mo + 8)
    rename_in_dict(d, mb + u16(d, mb), mapping)
    rename_in_dict(d, mb + u16(d, mb + 2), mapping)


def recolor_model(data, hue, ks, kv, tag):
    d = bytearray(data)
    rename_textures(d, {b'mt_rdh01': b'cv_rdh01' + tag, b'mt_rdh01_pl': b'cv_rdh01_pl' + tag,
                        b'mt_rdh02': b'cv_rdh02' + tag, b'mt_rdh02_pl': b'cv_rdh02_pl' + tag})
    t = u32(d, 0x10 + 4 * (u16(d, 0xE) - 1))
    assert d[t:t + 4] == b'TEX0'
    pal_data = t + u32(d, t + 0x38)
    pal_size = u16(d, t + 0x30) << 3
    for i in range(pal_size // 2):
        c = u16(d, pal_data + 2 * i)
        r, g, b = (c & 31) / 31, ((c >> 5) & 31) / 31, ((c >> 10) & 31) / 31
        hh, s, v = colorsys.rgb_to_hsv(r, g, b)
        if s > 0.3 and (hh < 0.1 or hh > 0.93):
            r, g, b = colorsys.hsv_to_rgb((hh + hue) % 1, s * ks, v * kv)
            c = (c & 0x8000) | round(r * 31) | (round(g * 31) << 5) | (round(b * 31) << 10)
            struct.pack_into('<H', d, pal_data + 2 * i, c)
    return bytes(d)


def main():
    # buildings archive
    bm, bm_btnf = read_narc(open(BM_FIELD, 'rb').read())
    bm = bm[:ORIG_BM_COUNT]
    for hue, ks, kv, tag in ((0.6, 0.85, 0.95, b'b'), (0.3, 0.6, 0.78, b'g'), (0.77, 0.6, 0.85, b'p')):
        bm.append(recolor_model(bm[313], hue, ks, kv, tag))
    for path in (BM_FIELD, BM_FIELD_FS):
        open(path, 'wb').write(write_narc(bm, bm_btnf))
    an, an_btnf = read_narc(open(BM_ANIM, 'rb').read())
    an = an[:ORIG_BM_COUNT] + [an[313]] * (len(bm) - ORIG_BM_COUNT)
    open(BM_ANIM, 'wb').write(write_narc(an, an_btnf))
    ms = open(BM_MATSHP, 'rb').read()
    n0, tot = struct.unpack_from('<HH', ms, 0)
    heads = [struct.unpack_from('<2H', ms, 4 + 4 * i) for i in range(n0)][:ORIG_BM_COUNT]
    ents = [ms[4 + 4 * n0 + 4 * i:4 + 4 * n0 + 4 * i + 4] for i in range(tot)]
    cnt, start = heads[313]
    ents = ents[:max(s + c for c, s in heads if s != 0xFFFF)]
    for _ in range(3):
        heads.append((cnt, len(ents))); ents += ents[start:start + cnt]
    open(BM_MATSHP, 'wb').write(struct.pack('<HH', len(heads), len(ents)) + b''.join(struct.pack('<2H', *h) for h in heads) +
                                b''.join(ents) + ms[4 + 4 * n0 + 4 * tot:])
    # area building set
    sets, sets_btnf = read_narc(open(AREA_BUILD, 'rb').read())
    used = sorted({p[0] for ld in lands.values() for p in ld.props})
    base = list(struct.unpack_from('<%dH' % u16(sets[AREA_SET], 0), sets[AREA_SET], 2))
    ids = base[:16] + [m for m in used if m not in base[:16]]
    sets[AREA_SET] = struct.pack('<H%dH' % len(ids), len(ids), *ids)
    open(AREA_BUILD, 'wb').write(write_narc(sets, sets_btnf))
    # the set's textures live in one file the models are bound to; add what the new models bring
    atex, atex_btnf = read_narc(open(AREA_BUILD_TEX, 'rb').read())
    orig = atex[AREA_SET]          # (names are unique, so a rerun adds nothing twice)
    texs, pals = read_tex0(orig, tex0_of(orig))
    have_t, have_p = {t[0] for t in texs}, {p[0] for p in pals}
    for mid in ids:
        t0 = tex0_of(bm[mid])
        if t0 is None: continue
        mt, mp = read_tex0(bm[mid], t0)
        texs += [t for t in mt if t[0] not in have_t]; have_t |= {t[0] for t in mt}
        pals += [p for p in mp if p[0] not in have_p]; have_p |= {p[0] for p in mp}
    atex[AREA_SET] = write_btx0(texs, pals)
    open(AREA_BUILD_TEX, 'wb').write(write_narc(atex, atex_btnf))
    # lands
    land, land_btnf = read_narc(open(LAND_NARC, 'rb').read())
    ids = {}
    for i, key in enumerate(sorted(lands, key=lambda k: (k[1], k[0]))):
        ids[key] = ORIG_LAND_COUNT + i
        while len(land) <= ids[key]: land.append(land[209])
        land[ids[key]] = land_file(lands[key])        # (other tools' lands after ours are left alone)
    open(LAND_NARC, 'wb').write(write_narc(land, land_btnf))
    open(TEXSETS, 'wb').write(write_narc(ts_files, ts_btnf))
    # matrix
    m = bytearray(open(MATRIX, 'rb').read())
    w, h, has_hdr, has_alt, nl = m[0], m[1], m[2], m[3], m[4]
    p_hdr = 5 + nl
    p_alt = p_hdr + 2 * w * h
    p_land = p_alt + w * h
    for (bx, by), lid in ids.items():
        c = (CELL_Y + by) * w + CELL_X + bx
        struct.pack_into('<H', m, p_hdr + 2 * c, MAP_PALLET)
        m[p_alt + c] = m[p_alt + 11 * w + 32]          # (Pallet's own cell)
        struct.pack_into('<H', m, p_land + 2 * c, lid)
    open(MATRIX, 'wb').write(bytes(m))
    write_events()
    print('lands', ids, 'props', {k: len(v.props) for k, v in lands.items()}, 'area set', ids and len(sets[AREA_SET]) // 2 - 1)


def write_events():
    ev = json.load(open(EVENTS))
    gx = lambda x: 32 * CELL_X + x
    gz = lambda y: 32 * CELL_Y + y
    # warps: the GBA town's, in its order (so the rooms' dest_warp_ids land on the right door)
    sys.path.insert(0, HERE)
    from slots import gba_warps
    import gba_map
    ev['warps'] = []
    for w in gba_warps(gba_map.map_json('PalletTown_Frlg'), shift=(OX, 0)):
        if '_dead' not in w: w['x'], w['z'] = gx(w['x']), gz(w['z'])
        ev['warps'].append({k: v for k, v in w.items() if not k.startswith('_')})
    for bg, (sx, sy) in zip(ev['bgs'], SIGNS):
        bg['x'], bg['z'] = gx(sx), gz(sy)
    spots = [(OX + 31, 14), (OX + 40, 31), (OX + 12, 31)]
    for obj, (ox, oy) in zip(ev['objects'], spots):
        obj['x'], obj['z'] = gx(ox), gz(oy)
    json.dump(ev, open(EVENTS, 'w'), indent=4)
    open(EVENTS, 'a').write('\n')


if __name__ == '__main__':
    main()
