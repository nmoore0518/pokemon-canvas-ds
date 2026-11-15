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
CELL_X, CELL_Y = 32, 11        # Pallet's matrix cell; we take a 2x2 from here
MAP_PALLET = 49
AREA_SET = 17
TEXSET = 18
RW, RH = 64, 64                # our region in blocks (2x2 lands)

# ---------------------------------------------------------------- the layout, extended to 64x64
L = json.load(open(os.path.join(HERE, 'data', 'pallet_layout.json')))
W0, H0 = L['W'], L['H']
cells = [list(r.ljust(RW, 'X')) for r in L['cells']] + [['X'] * RW for _ in range(RH - H0)]
coll = [list(r.ljust(RW, '1')) for r in L['coll']] + [['1'] * RW for _ in range(RH - H0)]
trees = [tuple(t) for t in L['trees']]
# the north road meets Route 1 at blocks 14..17, not our GBA 20..21
for y in (0, 1):
    for x in range(RW):
        cells[y][x], coll[y][x] = ('P', '0') if 14 <= x <= 17 else ('X', '1')
trees = [t for t in trees if not (t[1] == 0 and t[0] in (14, 16))] + [(20, 0)]
# below and right of the GBA map: trees, and the channel running on to Route 21's sea
for y in range(H0, RH):
    for x in range(RW):
        if (30 <= x <= 33) or (y >= 58 and 2 <= x <= 33):
            cells[y][x], coll[y][x] = 'W', '0'
for y in range(0, RH, 2):
    for x in range(0, RW, 2):
        if (x >= W0 or y >= H0) and all(cells[yy][xx] == 'X' for yy in (y, y + 1) for xx in (x, x + 1) if yy < RH and xx < RW):
            trees.append((x, y))
kind = lambda x, y: cells[y][x] if 0 <= x < RW and 0 <= y < RH else None

# ---------------------------------------------------------------- heights (blocks), as in the 3D mock-up
LOW, RAISE, WATER_DROP = -2.0, 1.0, 0.25
topH = [[LOW if y >= 43 else 0.0 for x in range(RW)] for y in range(RH)]
ramp = [[None] * RW for _ in range(RH)]
rocky = [[False] * RW for _ in range(RH)]
for r in L['rec']:
    if r[0] == 'cliff_band':
        _, x0, x1, y0, y1, stairs, falls = r
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                hb, hf = -0.4 * (y - y0), -0.4 * (y - y0 + 1)
                if x in stairs: ramp[y][x] = (hb, hf, 'stairs')
                elif x in falls: ramp[y][x] = (hb - WATER_DROP, hf - WATER_DROP, 'water')
                else: topH[y][x] = hf; rocky[y][x] = True
for r in L['rec']:
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
ts_files, _ = read_narc(open(TEXSETS, 'rb').read())
btx = ts_files[TEXSET]
t0 = u32(btx, 0x10)
TEXDIMS = {}
for nm, e in read_dict(btx, t0 + u16(btx, t0 + 0xE)):
    prm = u32(e, 0)
    TEXDIMS[nm.decode()] = (8 << ((prm >> 20) & 7), 8 << ((prm >> 23) & 7))
PALS = {nm.decode() for nm, _ in read_dict(btx, t0 + u32(btx, t0 + 0x34))}
pal_of = lambda t: next(p for p in (t + '_pl', t, t.replace('gs', '')) if p in PALS)
MATS = ['road01', 'road05', 'grass01gs', 'cliff01gs', 'wall01_g', 'wall01_h', 'slope', 'sea_un', 'pond_line',
        'flower01', 'flower02', 'tree01_un', 'fence_a', 'tree01gs']

# ---------------------------------------------------------------- per-land geometry
class Land:
    def __init__(self, bx, by):
        self.bx, self.by = bx, by
        self.mesh = {m: Mesh() for m in MATS}
        self.props = []

    def local(self, gx, gz):        # global block coords -> this land's units (centre origin)
        return (gx - 32 * self.bx) * 16 - 256, (gz - 32 * self.by) * 16 - 256


lands = {(bx, by): Land(bx, by) for by in range(2) for bx in range(2)}
land_at = lambda gx, gy: lands[(min(1, max(0, int(gx) // 32)), min(1, max(0, int(gy) // 32)))]
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


def ground_tex(x, y):
    k = kind(x, y)
    if rocky[y][x]: return 'cliff01gs'
    if k == 'P': return 'road01'
    if k == 'S': return 'road05'
    return 'grass01gs'


for y in range(RH):
    for x in range(RW):
        r = ramp[y][x]
        if r and r[2] == 'water': top_quad('sea_un', x, y, r[0], r[1]); continue
        if r:
            owner = lands[(x // 32, y // 32)]
            quad('slope', [(x, Y(r[1]), y + 1), (x + 1, Y(r[1]), y + 1), (x + 1, Y(r[0]), y), (x, Y(r[0]), y)],
                 [(0, 24), (32, 24), (32, 0), (0, 0)], (0, 0.7, 0.7), owner)
            continue
        if is_water(x, y): top_quad('sea_un', x, y, topH[y][x] - WATER_DROP, topH[y][x] - WATER_DROP); continue
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


for y in range(RH):
    for x in range(RW):
        a, right, down = solid(x, y), solid(x + 1, y), solid(x, y + 1)
        if right is not None and abs(a - right) > 0.01:
            hi, lo = ((x, y), (x + 1, y)) if a > right else ((x + 1, y), (x, y))
            t, vs = face(hi, lo)
            wall_x(t, x + 1, y, min(a, right), max(a, right), vs, (1 if a > right else -1, 0, 0))
        if down is not None and abs(a - down) > 0.01:
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

for r in L['rec']:
    if r[0] == 'fence':
        _, x0, x1, yy = r[:4]
        for fx in range(x0, x1 + 1):
            h = Y(solid(fx, yy)) + 0.35
            z = yy + 0.85
            quad('fence_a', [(fx, h, z), (fx + 1, h, z), (fx + 1, h + 11.3, z - 0.708), (fx, h + 11.3, z - 0.708)],
                 [(fx * 16, 16), ((fx + 1) * 16, 16), ((fx + 1) * 16, 0), (fx * 16, 0)], (0, 0.7, 0.7), lands[(fx // 32, yy // 32)])

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


def prop(model, gx, y, gz):
    ld = land_at(gx, gz)
    lx, lz = ld.local(gx, gz)
    ld.props.append((model, lx, y, lz))


for r in L['rec']:
    t, x, y = r[0], r[1], r[2]
    if t in BUILDINGS:
        model, door, off, cx = BUILDINGS[t]
        dx, dy = (x + 1, y + 4) if t == 'house' else L['doors'][DOOR_OF[t]]
        door_tiles.add((dx, dy))
        base = Y(topH[dy][dx])
        ox, oz = (dx + 0.5) * 16 - off[0] - cx, (dy + 1) * 16 - off[2]
        prop(BM_HOUSE[r[3]] if t == 'house' else model, ox / 16, base, oz / 16)
        prop(door, (ox + off[0]) / 16, base + off[1], (oz + off[2]) / 16)
    elif t == 'mailbox':
        prop(30, x + 0.5, Y(solid(x, y + 1)), y + 1.35)
for sx, sy in L['signs']:
    prop(29, sx + 0.5, Y(solid(sx, sy)), sy + 0.35)
for dx, dy, nm, _ in L['decor']:
    if nm == 'lamp': prop(95, dx + 0.4, Y(solid(dx, dy + 1)), dy + 1.4)
    elif nm == 'bench': prop(178, dx + 0.9, Y(solid(dx, dy)), dy + 0.4)
    elif nm == 'chansey': prop(180, dx + 1, Y(solid(dx, dy + 1)), dy + 1.4)


def building_entries(ld):
    out = b''
    for model, x, y, z in ld.props:
        f = lambda v: int(round(v * 4096))
        out += struct.pack('<I3i3i3i8x', model, f(x), f(y), f(z), 0, 0, 0, 4096, 4096, 4096)
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
            if key[0] == 'flat':
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
    groups = []
    for m in MATS:
        opts = {'repeat': 3, 'flip': 0, 'size': TEXDIMS[m]}
        if m in ('tree01gs', 'tree01_un', 'flower01', 'flower02'): opts['repeat'] = 0
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
    used = sorted({m for ld in lands.values() for m, *_ in ld.props})
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
    land = land[:ORIG_LAND_COUNT]
    ids = {}
    for key in ((0, 0), (1, 0), (0, 1), (1, 1)):
        ids[key] = len(land)
        land.append(land_file(lands[key]))
    open(LAND_NARC, 'wb').write(write_narc(land, land_btnf))
    # matrix
    m = bytearray(open(MATRIX, 'rb').read())
    w, h, has_hdr, has_alt, nl = m[0], m[1], m[2], m[3], m[4]
    p_hdr = 5 + nl
    p_alt = p_hdr + 2 * w * h
    p_land = p_alt + w * h
    for (bx, by), lid in ids.items():
        c = (CELL_Y + by) * w + CELL_X + bx
        struct.pack_into('<H', m, p_hdr + 2 * c, MAP_PALLET)
        m[p_alt + c] = m[p_alt + CELL_Y * w + CELL_X]
        struct.pack_into('<H', m, p_land + 2 * c, lid)
    open(MATRIX, 'wb').write(bytes(m))
    write_events()
    print('lands', ids, 'props', {k: len(v.props) for k, v in lands.items()}, 'area set', ids and len(sets[AREA_SET]) // 2 - 1)


def write_events():
    ev = json.load(open(EVENTS))
    gx = lambda x: 32 * CELL_X + x
    gz = lambda y: 32 * CELL_Y + y
    D = L['doors']
    # warps 0..2 keep their interiors (their exits come back to these indices)
    for i, nm in enumerate(('PLAYER_DOOR', 'RIVAL_DOOR', 'LAB_DOOR')):
        ev['warps'][i]['x'], ev['warps'][i]['z'] = gx(D[nm][0]), gz(D[nm][1])
    for bg, (sx, sy) in zip(ev['bgs'], L['signs']):
        bg['x'], bg['z'] = gx(sx), gz(sy)
    spots = [(24, 14), (40, 31), (12, 31)]
    for obj, (ox, oy) in zip(ev['objects'], spots):
        obj['x'], obj['z'] = gx(ox), gz(oy)
    json.dump(ev, open(EVENTS, 'w'), indent=4)
    open(EVENTS, 'a').write('\n')


if __name__ == '__main__':
    main()
