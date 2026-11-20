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
import colorsys, json, math, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nitro import read_narc, write_narc, read_dict, patricia, read_tex0, tex0_of, write_btx0, u16, u32
from g3d import Mesh, build_model
import cave_kit as K
import route_kit as R
import build_safari as BS

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
# the stone bridge between the two north gardens, over the road: the GBA's (elevation 15, walked over and under).
# HeartGold has no bridge you walk both over and under (a square has one height), so the road keeps its way
# under it and the bridge stands over it; its ends are the gardens' walls, closed
BRIDGE = (17 + OX, 23 + OX, 7, 8)          # (its end columns, its rows)
for _y in (BRIDGE[2], BRIDGE[3]):
    for _x in (BRIDGE[0] - 1, BRIDGE[0], BRIDGE[1], BRIDGE[1] + 1):     # (its ends, and its steps in the gardens)
        coll[_y][_x] = '1'

# ---------------------------------------------------------------- heights (blocks), as in the 3D mock-up
LOW, RAISE, WATER_DROP = -2.0, 1.0, 0.5      # (the sea's clear top half a block down, its water a unit under that, as HeartGold's)
SEA_UN = 1 / 16
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


def statue_texture(name=STATUE_TEX, overworld='chansey_overworld.png'):
    """32x64 4bpp texture, colour 0 transparent: rows 0..31 HeartGold's own Pokemon (its front-facing overworld
    frame, from hg-engine's a/0/8/1) recoloured as a statue; rows 34..47 the GBA game's stone pedestal (Chansey's
    here; the Leader Academy's Roserade, data/roserade_overworld.png, for build_overworld.py)"""
    from PIL import Image
    im = Image.open(os.path.join(HERE, 'data', 'chansey_statue.png')).convert('RGBA')
    ow = Image.open(os.path.join(HERE, 'data', overworld)).convert('RGBA')
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
    return (name.encode(), prm, 32 | (64 << 11) | 0x80000000, data, b''), ((name + '_pl').encode(), 0, pal)


def sand_edge_texture(texs, pals):
    """HeartGold has no edge between its beach sand (beach01) and grass: its road's edge (road01_r: grass, a dark
    rim, then the road's yellow sand) with the beach's own sand in place of the road's (cv_sand_r, 256 colours)"""
    from texview import decode
    tex = lambda n: next(t for t in texs if t[0] == n.encode())
    pal = lambda n: next(q for q in pals if q[0] == n.encode())[2]
    road = decode(tex('road01_r')[1], tex('road01_r')[3], tex('road01_r')[4], pal('road01_r')).convert('RGB')
    beach = decode(tex('beach01')[1], tex('beach01')[3], tex('beach01')[4], pal('beach01_pl')).convert('RGB')
    lum = lambda c: 0.3 * c[0] + 0.59 * c[1] + 0.11 * c[2]
    sandy = lambda c: c[0] > c[2] + 30 and c[0] >= c[1] - 12 and lum(c) > 150      # (the road's sand, not its rim)
    green = lambda c: c[1] > c[0] + 10 and c[1] > c[2]
    # (the rim between them: the beach's own shadow, halfway to the road's rim)
    dark = min((beach.getpixel((x, y)) for x in range(beach.width) for y in range(beach.height)), key=lum)
    rim = lambda c: tuple((a + 2 * b) // 3 for a, b in zip(c, dark))
    w, h = road.size
    cols, idx = [], bytearray()
    for y in range(h):
        for x in range(w):
            c = road.getpixel((x, y))
            if sandy(c): c = beach.getpixel((x % beach.width, y % beach.height))
            elif not green(c): c = rim(c)
            v = (c[0] >> 3) | (c[1] >> 3) << 5 | (c[2] >> 3) << 10
            if v not in cols: cols.append(v)
            idx.append(cols.index(v))
    assert len(cols) <= 256
    prm = tex('road01_r')[1] & ~(7 << 26) & ~(1 << 29) | (4 << 26)       # (8 bits a texel)
    return (b'cv_sand_r', prm, tex('road01_r')[2], bytes(idx), b''), \
        (b'cv_sand_r_pl', 0, b''.join(struct.pack('<H', c) for c in cols) + b'\0' * (-2 * len(cols) % 16))


def imported(names, from_set):
    """textures of another of HeartGold's sets, with their palettes (the stone bridge's: Fuchsia's stonework)"""
    t, p = read_tex0(ts_files[from_set], tex0_of(ts_files[from_set]))
    tt = [e for e in t if e[0].decode() in names]
    pp = [q for q in p if q[0].decode() in {n + '_pl' for n in names} | set(names)]
    return tt, pp


_t, _p = read_tex0(ts_files[TEXSET], tex0_of(ts_files[TEXSET]))
_st, _sp = statue_texture()
_et, _ep = sand_edge_texture(_t, _p)
_it, _ip = imported(('sek_fe01', 'sek_fe02'), 16)
_it2, _ip2 = imported(('nib_stone',), 17)       # (the stone lanterns' globes on the bridge's piers)
_it, _ip = _it + _it2, _ip + _ip2
# (the bridge's deck: the paving in a warm grey, darker than its dressed stone trim, cv_deck)
_src = next(t for t in _it if t[0] == b'sek_fe02'); _srcp = next(q for q in _ip if q[0] in (b'sek_fe02_pl', b'sek_fe02'))


def _warm(c):
    r, g, b = c & 31, (c >> 5) & 31, (c >> 10) & 31
    l = (r * 30 + g * 59 + b * 11) / 100
    r, g, b = [max(0, min(31, int(round(v)))) for v in (l * 0.80 + 2.2, l * 0.76 + 1.6, l * 0.70 + 0.8)]
    return r | g << 5 | b << 10


_it.append((b'cv_deck',) + tuple(_src[1:]))
_ip.append((b'cv_deck_pl', _srcp[1], b''.join(struct.pack('<H', _warm(struct.unpack_from('<H', _srcp[2], i)[0])) for i in range(0, len(_srcp[2]) - 1, 2))))
_rt, _rp = statue_texture('cv_roserade', 'roserade_overworld.png')       # (the Leader Academy's statue)
_new_t, _new_p = [_st, _et, _rt] + _it, [_sp, _ep, _rp] + _ip
_t = [t for t in _t if t[0] not in {e[0] for e in _new_t}] + _new_t
_p = [p for p in _p if p[0] not in {e[0] for e in _new_p}] + _new_p
ts_files[TEXSET] = write_btx0(_t, _p)
btx = ts_files[TEXSET]
t0 = u32(btx, 0x10)
TEXDIMS = {}
for nm, e in read_dict(btx, t0 + u16(btx, t0 + 0xE)):
    prm = u32(e, 0)
    TEXDIMS[nm.decode()] = (8 << ((prm >> 20) & 7), 8 << ((prm >> 23) & 7))
PALS = {nm.decode() for nm, _ in read_dict(btx, t0 + u32(btx, t0 + 0x34))}
PAL_NAME = {'sea_on': 'sea_f02_pl'}      # (HeartGold's own pairing)
pal_of = lambda t: PAL_NAME.get(t) or next(p for p in (t + '_pl', t, t.replace('gs', '')) if p in PALS)
# HeartGold animates Pallet's map materials by index (area animation 0: pond_on, swave_p, pond_edge, sea_line02,
# sea_un, sea_on, river, river_r), so those eight slots come first and only sea_un's is used; anything else put
# there would scroll.
ANIM_SLOTS = ['pond_on', 'swave_p', 'pond_edge', 'sea_line02', 'sea_un', 'sea_on', 'river', 'river_r']
MATS = ['sea_un', 'sea_on', 'sea_line02', 'road01_r', 'road01', 'road05', 'grass01gs', 'cliff01gs', 'wall01_g', 'wall01_h', 'wall01_d',
        'slope', 'pond_line', 'sek_fe01', 'sek_fe02', 'cv_deck', 'nib_stone', 'cv_sand_r', 'flower01', 'flower02', 'tree01_un', 'fence_a', 'tree01gs', STATUE_TEX]

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


def rimsq(x, y):
    """a square of cliff: not walkable, a tier above a square round it (the 8): one of HeartGold's pieces"""
    return bool(lower_of(x, y))


def lower_of(x, y):
    """the squares round a closed square (dx, dz) a tier below it (the ground under the sea, for the sea)"""
    if not (0 <= x < RW and 0 <= y < RH) or coll[y][x] != '1' or ramp[y][x] or kind(x, y) == 'W': return []
    out = []
    for dx in (-1, 0, 1):
        for dz in (-1, 0, 1):
            x2, y2 = x + dx, y + dz
            if (dx or dz) and 0 <= x2 < RW and 0 <= y2 < RH and not (ramp[y2][x2] and ramp[y2][x2][2] == 'stairs') \
                    and abs(topH[y][x] - topH[y2][x2] - 1.0) < 0.01:
                out.append((dx, dz))
    return out


def road_nb(x, y):
    """the road squares round a square of grass level with it (its edge lies in the grass)"""
    if kind(x, y) in ('P', 'W', 'S') or ramp[y][x] or rimsq(x, y) or rocky[y][x]: return []
    return [(dx, dz) for dx in (-1, 0, 1) for dz in (-1, 0, 1) if (dx or dz) and kind(x + dx, y + dz) == 'P'
            and not ramp[y + dz][x + dx] and abs(topH[y + dz][x + dx] - topH[y][x]) < 0.01 and not rimsq(x + dx, y + dz)]


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
        if is_water(x, y):
            top_quad('sea_on', x, y, topH[y][x] - WATER_DROP, topH[y][x] - WATER_DROP)
            top_quad('sea_un', x, y, topH[y][x] - WATER_DROP - SEA_UN, topH[y][x] - WATER_DROP - SEA_UN); continue
        if rimsq(x, y): continue                   # (a piece of cliff: see below)
        if road_nb(x, y): continue                 # (the road's edge: see below)
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


def poly(tex, pts):
    """a polygon in the region: pts [((x, y, z) in blocks, units, blocks, (s, t))]; owned by the land its middle is in"""
    cx, cz = sum(p[0][0] for p in pts) / len(pts), sum(p[0][2] for p in pts) / len(pts)
    ld = lands[(min(BW - 1, max(0, int(cx) // 32)), min(BH - 1, max(0, int(cz) // 32)))]
    vs = [((ld.local(x, z)[0], y, ld.local(x, z)[1]), st) for (x, y, z), st in pts]
    if len(vs) == 4: ld.mesh[tex].quad(vs, UP)
    elif len(vs) == 3: ld.mesh[tex].tri(vs, UP)
    else:
        for i in range(1, len(vs) - 1): ld.mesh[tex].tri([vs[0], vs[i], vs[i + 1]], UP)


# ---- cliffs: a piece of HeartGold's to every square of cliff, chosen by which squares round it are lower
# (route_kit: its straight face, its own rounded outside corner and wall01_d inside corner, odd squares laid by
# distance). A plateau's face is wall01_g, its lip on top the rock's (wall01_h); its foot the ground's
for y in range(RH):
    for x in range(RW):
        low = lower_of(x, y)
        if not low: continue
        n0 = next((n for n in R.SIDE if n in low), low[0])
        foot_k = kind(x + n0[0], y + n0[1])
        look = dict(foot='wall01_h' if foot_k == 'P' else 'wall01_g', face='wall01_g', lip='wall01_h')
        foot = topH[y][x] - 1.0
        under = 'road01' if foot_k == 'P' else 'grass01gs'
        for tex, pts in R.rock_piece(low, x, y, LAND_NARC, look):
            if tex == 'ground':
                poly(under, [((x + u / 16, Y(foot) + h, y + v / 16), (x * 16 + u, y * 16 + v)) for u, v, h, s, t in pts])
            elif tex == 'top':
                poly(ground_tex(x, y), [((x + u / 16, Y(topH[y][x]), y + v / 16), (x * 16 + u, y * 16 + v)) for u, v, h, s, t in pts])
            else:
                poly(tex, [((x + u / 16, Y(foot) + h, y + v / 16), (s, t)) for u, v, h, s, t in pts])
        # (a straight face stopping against what stands at its top's height - stairs, the end of the bridge -
        # shows its end: the profile, closed down to its foot)
        kd = K.classify(low)
        if kd[0] == 'straight':
            n = kd[1]
            tdir = (1, 0) if n[0] == 0 else (0, 1)
            for sg in (-1, 1):
                ax, ay = x + sg * tdir[0], y + sg * tdir[1]
                if not (0 <= ax < RW and 0 <= ay < RH) or rimsq(ax, ay) or topH[ay][ax] < topH[y][x] - 0.01 and not ramp[ay][ax]: continue
                pts = []
                # (beside stairs the face's own end shows, above the ramp: its profile down to the foot. Beside
                # ground at the top's height - the end of the bridge - that ground's side shows above the profile)
                prof = R.PROFILE + [(1.0, 0.0, 15.6)] if ramp[ay][ax] else R.PROFILE + [(0.0, 16.0, 0.5)]
                for d, h, t in prof:
                    # d across from the lower side, at the end sg along
                    cx_ = (x + (0.5 + sg * 0.5) if n[0] == 0 else x + (d if n[0] < 0 else 1 - d))
                    cz_ = (y + (d if n[1] < 0 else 1 - d) if n[0] == 0 else y + (0.5 + sg * 0.5))
                    pts.append(((cx_, Y(foot) + h, cz_), (d * 16, t)))
                poly('wall01_g', pts)

# ---- the road's edge, in the grass beside it (HeartGold's road01_r: build_safari's sand edge)
for y in range(RH):
    for x in range(RW):
        nb = road_nb(x, y)
        if not nb: continue
        h = Y(topH[y][x])
        BS._sand_edge(lambda tex, pts: poly('grass01gs' if tex == BS.GROUND else tex, [((X / 16, h, Z / 16), st) for (X, _, Z), st in pts]), nb, x, y)

# ---- the sea's shore: HeartGold's (its Pallet and Route 21): the bank (pond_line) inside the water's squares from
# the land, the water's edge (sea_line02) sloping under, laid by distance from the land round it (straight sides
# in runs); the sea's two layers lie under all of it
SEA_EDGE = [(0.16, -1.5, 40.0), (0.22, -6.2, 47.6), (0.55, -9.6, 64.0)]
water_like = lambda x, y: not (0 <= x < RW and 0 <= y < RH) or is_water(x, y) or (ramp[y][x] and ramp[y][x][2] == 'water')
shore_runs = {}
for y in range(RH):
    for x in range(RW):
        if not is_water(x, y): continue
        land = [(dx, dz) for dx in (-1, 0, 1) for dz in (-1, 0, 1) if (dx or dz) and not water_like(x + dx, y + dz)]
        if not land: continue
        g = Y(topH[y][x])
        kd = K.classify(land)
        if kd[0] == 'straight':
            n = kd[1]
            shore_runs.setdefault((n, y if n[0] == 0 else x, g), set()).add(x if n[0] == 0 else y)
            continue
        along = lambda part, u, v: (y * 16 + v * 16) if part[0] == 'x' else (x * 16 + u * 16)
        for tex, prof in (('pond_line', R.BANK), ('sea_line02', SEA_EDGE)):
            for part, rng, f, pl in K.laid(land, prof):
                poly(tex, [((x + u, g + K.along_profile(prof, f(u, v))[0], y + v), (along(part, u, v), K.along_profile(prof, f(u, v))[1])) for u, v in pl])
for (n, line, g), al in shore_runs.items():
    dx, dz = n
    for a, b in BS._runs(sorted(al)):
        def P(d, at, h):
            if dz: return (at, g + h, line + (d if dz < 0 else 1 - d))
            return (line + (d if dx < 0 else 1 - d), g + h, at)
        for tex, prof in (('pond_line', R.BANK), ('sea_line02', SEA_EDGE)):
            for (d0, h0, t0), (d1, h1, t1) in zip(prof, prof[1:]):
                poly(tex, [(P(d0, a, h0), (a * 16, t0)), (P(d0, b, h0), (b * 16, t0)), (P(d1, b, h1), (b * 16, t1)), (P(d1, a, h1), (a * 16, t1))])

# ---- what the pieces leave: a face beside stairs or the falls (their sides), and a drop of more than a tier
for y in range(RH):
    for x in range(RW):
        a, right, down = solid(x, y), solid(x + 1, y), solid(x, y + 1)
        for (x2, y2), other in (((x + 1, y), right), ((x, y + 1), down)):
            if other is None or abs(a - other) < 0.01: continue
            hi, lo = ((x, y), (x2, y2)) if a > other else ((x2, y2), (x, y))
            rp = lambda q: ramp[q[1]][q[0]]
            if not rp(hi) and not rp(lo):
                if water_like(*lo) and water_like(*hi): continue
                if water_like(*lo) and abs(topH[lo[1]][lo[0]] - topH[hi[1]][hi[0]]) < 0.01: continue     # (the shore)
                if abs(topH[hi[1]][hi[0]] - topH[lo[1]][lo[0]] - 1.0) < 0.01 and rimsq(*hi): continue      # (a piece)
            if rp(hi) and rp(lo) and rp(hi)[2] == 'water' and rp(lo)[2] == 'water': continue
            tex = 'wall01_h' if rocky[hi[1]][hi[0]] else 'wall01_g'
            if x2 == x + 1: wall_x(tex, x + 1, y, min(a, other), max(a, other), 16, (1 if a > other else -1, 0, 0))
            else: wall_z(tex, x, y + 1, min(a, other), max(a, other), 16, (0, 0, 1 if a > other else -1))

# ---- the stone bridge, the town's gateway between its two north gardens: brick (Fuchsia's, sek_fe01) and dressed
# stone (its paving, sek_fe02, a slab to a block). Its deck a block above the gardens (under one at their height
# someone walking the road would stand through it), a flight of steps down to each garden; each face an arch over
# the road - a ring of voussoirs with a keystone, proud of the brickwork, springing from the piers high enough to
# clear someone walking under it -, a string course along the deck, a parapet with a coping and posts; a pier at
# each end on the walls' line, standing above the parapet, capped, with a stone lantern's globe (nib_stone)
def bridge():
    a, b = BRIDGE[0] + 1, BRIDGE[1]                 # (the walls' faces: the piers stand on them)
    z0, z1 = BRIDGE[2], BRIDGE[3] + 1
    garden, top, road = Y(RAISE), Y(RAISE + 1), Y(0.0)
    pw = 0.5                                        # (the piers' width, squares)
    sa, sb = a + pw / 2, b - pw / 2                 # (the opening, between the piers)
    spring, rise, ring = road + 27, 6.0, 3.5         # (the arch: where it springs, its rise; the ring's depth, units)
    cx, rx = (sa + sb) / 2, (sb - sa) / 2
    course = (top - 2.5, top + 0.5)                 # (the string course)
    par, cope = top + 8, top + 10                   # (the parapet, its coping)
    pier_top, cap_top = top + 14, top + 16.5
    run = 1.33                                      # (the steps' run, squares)
    U16 = lambda v: v * 16

    def both(tex, vs): poly(tex, vs); poly(tex, vs[::-1])

    def box(tex, x0, x1, y0, y1, za, zb):
        """a block: its top and four sides (s, t in units), each seen from either side"""
        both(tex, [((x0, y1, zb), (U16(x0), U16(zb))), ((x1, y1, zb), (U16(x1), U16(zb))), ((x1, y1, za), (U16(x1), U16(za))), ((x0, y1, za), (U16(x0), U16(za)))])
        for z in (zb, za):
            both(tex, [((x0, y0, z), (U16(x0), 64 - y0)), ((x1, y0, z), (U16(x1), 64 - y0)), ((x1, y1, z), (U16(x1), 64 - y1)), ((x0, y1, z), (U16(x0), 64 - y1))])
        for x in (x1, x0):
            both(tex, [((x, y0, zb), (U16(zb), 64 - y0)), ((x, y0, za), (U16(za), 64 - y0)), ((x, y1, za), (U16(za), 64 - y1)), ((x, y1, zb), (U16(zb), 64 - y1))])

    # the faces lean back as HeartGold's cliffs do (seen from above, a face standing straight up is a line): the foot
    # a third of a square out over the road, the top a third back; the deck between their tops
    LEAN = (0.35, 0.3)
    Zf = {1: lambda y: z1 + LEAN[0] - sum(LEAN) * (min(y, top) - road) / (top - road),
          -1: lambda y: z0 - LEAN[0] + sum(LEAN) * (min(y, top) - road) / (top - road)}
    zt0, zt1 = Zf[-1](top), Zf[1](top)
    x0, x1 = a - 0.67, b + 0.67
    poly('cv_deck', [((x0, top, zt1), (x0 * 16, zt1 * 16)), ((x1, top, zt1), (x1 * 16, zt1 * 16)), ((x1, top, zt0), (x1 * 16, zt0 * 16)), ((x0, top, zt0), (x0 * 16, zt0 * 16))])
    arch = lambda r_x, r_y, x: spring + r_y * max(0.0, 1 - ((x - cx) / r_x) ** 2) ** 0.5 if abs(x - cx) < r_x else spring
    N = 20
    xs = [sa + (sb - sa) * i / N for i in range(N + 1)]
    for out in (1, -1):
        Z = Zf[out]
        P = lambda x, y, d=0.0: (x, y, Z(y) + out * d)          # (a point on the face; d out from it)
        # brickwork: from the ring's back up to the string course
        for xa, xb in zip(xs, xs[1:]):
            ya, yb = arch(rx + ring / 16, rise + ring, xa), arch(rx + ring / 16, rise + ring, xb)
            both('sek_fe01', [(P(xa, ya), (xa * 16, 64 - ya)), (P(xb, yb), (xb * 16, 64 - yb)), (P(xb, course[0]), (xb * 16, 64 - course[0])), (P(xa, course[0]), (xa * 16, 64 - course[0]))])
        # the ring: eleven voussoirs, a slab of dressed stone each, the middle one the keystone (taller, further out),
        # each standing out of the brick with its outer edge showing
        V = 11
        for k in range(V):
            t0, t1 = math.pi * (1 - k / V), math.pi * (1 - (k + 1) / V)
            key = k == V // 2
            dd = ring + (3.0 if key else 0)
            d = 0.07 if key else 0.04
            pi = [(cx + rx * math.cos(t), spring + rise * math.sin(t)) for t in (t0, t1)]
            po = [(cx + (rx + dd / 16) * math.cos(t), spring + (rise + dd) * math.sin(t)) for t in (t0, t1)]
            sx = 16 * (k % 4)
            both('sek_fe02', [(P(*pi[0], d), (sx, 16)), (P(*pi[1], d), (sx + 16, 16)), (P(*po[1], d), (sx + 16, 0)), (P(*po[0], d), (sx, 0))])
            both('sek_fe02', [(P(*po[0], d), (sx, 0)), (P(*po[1], d), (sx + 16, 0)), (P(*po[1]), (sx + 16, 3)), (P(*po[0]), (sx, 3))])
        # the string course, standing out along the deck's edge
        za, zb = sorted((Z(top) - out * 0.02, Z(top) + out * 0.1))
        box('sek_fe02', x0, x1, course[0], course[1], za, zb)
        # the parapet: brick, a fifth of a square thick; its coping a slab wider; a post of dressed stone every square
        pz = sorted((Z(top), Z(top) - out * 0.22))
        box('sek_fe01', sa, sb, course[1], par, *pz)
        box('sek_fe02', sa, sb, par, cope, pz[0] - 0.05, pz[1] + 0.05)
        for k in range(1, int(b - a)):
            box('sek_fe02', a + k - 0.12, a + k + 0.12, par, cope + 2.5, pz[0] - 0.07, pz[1] + 0.07)
        # the steps' side walls, down to the gardens: brick, the parapet's height over the steps, a sloping coping
        for e, o in ((x0, -1), (x1, 1)):
            f = e + o * run                         # (the steps' foot, in the garden)
            for z in pz:
                both('sek_fe01', [((f, garden, z), (f * 16, 64 - garden)), ((e, garden, z), (e * 16, 64 - garden)), ((e, par, z), (e * 16, 64 - par)), ((f, garden + 8, z), (f * 16, 64 - garden - 8))])
            both('sek_fe02', [((f, garden + 8, pz[0] - 0.05), (0, 0)), ((e, par, pz[0] - 0.05), (16 * run, 0)), ((e, par + 2, pz[0] - 0.05), (16 * run, 2)), ((f, garden + 10, pz[0] - 0.05), (0, 2))])
            both('sek_fe02', [((f, garden + 10, pz[0] - 0.05), (0, 0)), ((e, par + 2, pz[0] - 0.05), (16 * run, 0)), ((e, par + 2, pz[1] + 0.05), (16 * run, 4)), ((f, garden + 10, pz[1] + 0.05), (0, 4))])
            both('sek_fe02', [((f, garden + 8, pz[1] + 0.05), (0, 0)), ((e, par, pz[1] + 0.05), (16 * run, 0)), ((e, par + 2, pz[1] + 0.05), (16 * run, 2)), ((f, garden + 10, pz[1] + 0.05), (0, 2))])
            both('sek_fe01', [((f, garden, pz[0]), (0, 8)), ((f, garden, pz[1]), (4, 8)), ((f, garden + 8, pz[1]), (4, 0)), ((f, garden + 8, pz[0]), (0, 0))])
    # the steps down to each garden: four risers of four units, the treads dressed stone
    for e, o in ((x0, -1), (x1, 1)):
        n = 4
        za, zb = zt0 + 0.22, zt1 - 0.22
        for k in range(n):
            h = top - 4 * (k + 1)                   # (the tread under the k-th riser)
            xa, xb = e + o * run * k / n, e + o * run * (k + 1) / n
            both('sek_fe02', [((xa, h + 4, za), (0, 0)), ((xa, h + 4, zb), (0, 16 * (zb - za))), ((xa, h, zb), (4, 16 * (zb - za))), ((xa, h, za), (4, 0))])
            if k < n - 1:
                both('sek_fe02', [((xa, h, zb), (U16(xa), U16(zb))), ((xb, h, zb), (U16(xb), U16(zb))), ((xb, h, za), (U16(xb), U16(za))), ((xa, h, za), (U16(xa), U16(za)))])
    # the arch's soffit, seen walking under it, and the piers' faces under the springing (the piers are blocks)
    for xa, xb in zip(xs, xs[1:]):
        ya, yb = arch(rx, rise, xa), arch(rx, rise, xb)
        poly('sek_fe01', [((xa, ya, Zf[-1](ya)), (xa * 16, z0 * 16)), ((xb, yb, Zf[-1](yb)), (xb * 16, z0 * 16)), ((xb, yb, Zf[1](yb)), (xb * 16, z1 * 16)), ((xa, ya, Zf[1](ya)), (xa * 16, z1 * 16))])
    # the piers, on the walls' line, the bridge's depth and a little more; capped; a lantern's globe on each end
    for px in (a, b):
        pa, pb = px - pw / 2, px + pw / 2
        za, zb = z0 - LEAN[0] - 0.1, z1 + LEAN[0] + 0.1
        box('sek_fe01', pa, pb, road, pier_top, za, zb)
        box('sek_fe02', pa - 0.07, pb + 0.07, spring - 2, spring, za - 0.05, zb + 0.05)       # (the impost the arch springs from)
        box('sek_fe02', pa - 0.07, pb + 0.07, pier_top, pier_top + 1.5, za - 0.07, zb + 0.07)
        box('sek_fe02', pa + 0.03, pb - 0.03, pier_top + 1.5, cap_top, za + 0.05, zb - 0.05)
        for gz in (zb - 0.1, za + 0.45):
            g0, g1, h = px - 0.4, px + 0.4, 15.0
            both('nib_stone', [((g0, cap_top - 0.5, gz + 0.1), (6, 29)), ((g1, cap_top - 0.5, gz + 0.1), (26, 29)), ((g1, cap_top + h, gz - 0.3), (26, 5)), ((g0, cap_top + h, gz - 0.3), (6, 5))])

bridge()

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
ACADEMY_MODEL = 343             # (academy_hall.py: appended after the houses)
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
TILT_ROW, TILT_BY = 55, 32.0
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
    h = Y(LOW - WATER_DROP - SEA_UN) + TILT_BY - 0.3
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
        own = slot in ('sea_un', 'sea_on', 'sea_line02')      # (the area's animation moves these three: HeartGold's sea)
        t_ = slot if own else 'sea_un'
        groups.append((slot, t_, pal_of(t_), ld.mesh[slot] if own else Mesh(), {'repeat': 3, 'flip': 0, 'size': TEXDIMS[t_]}))
    for m in MATS[3:]:
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
    src = []            # (the HeartGold model each of ours is a copy of: its animation and materials too)
    for hue, ks, kv, tag in ((0.6, 0.85, 0.95, b'b'), (0.3, 0.6, 0.78, b'g'), (0.77, 0.6, 0.85, b'p')):
        bm.append(recolor_model(bm[313], hue, ks, kv, tag)); src.append(313)
    import academy_hall         # (the Leader Academy's hall: Pewter's museum in brick with a blue roof, ACADEMY_MODEL)
    bm.append(academy_hall.make(bm[academy_hall.SRC])); src.append(academy_hall.SRC)
    assert len(bm) - 1 == ACADEMY_MODEL
    for path in (BM_FIELD, BM_FIELD_FS):
        open(path, 'wb').write(write_narc(bm, bm_btnf))
    an, an_btnf = read_narc(open(BM_ANIM, 'rb').read())
    an = an[:ORIG_BM_COUNT] + [an[m] for m in src]
    open(BM_ANIM, 'wb').write(write_narc(an, an_btnf))
    ms = open(BM_MATSHP, 'rb').read()
    n0, tot = struct.unpack_from('<HH', ms, 0)
    heads = [struct.unpack_from('<2H', ms, 4 + 4 * i) for i in range(n0)][:ORIG_BM_COUNT]
    ents = [ms[4 + 4 * n0 + 4 * i:4 + 4 * n0 + 4 * i + 4] for i in range(tot)]
    ents = ents[:max(s + c for c, s in heads if s != 0xFFFF)]
    for m in src:
        cnt, start = heads[m]
        if start == 0xFFFF: heads.append((cnt, start)); continue
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
