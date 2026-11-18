"""HeartGold's pieces for the outdoors, read off its own Safari Zone (the Plains, land 652, texture set 75) at build
time, the way cave_kit reads Union Cave's. See CANVAS.md, "Build from a tile kit".

  - cliffs: a square of rock with lower ground beside it is one piece a tier high (`TIER`), chosen by which squares
    round it are lower (cave_kit.classify): a straight face (`PROFILE`: the foot, the face leaning back, then a lip
    on top - `wall01_g`), HeartGold's own outside corner (rounded) and inside corner (`wall01_d`), copied out of the
    Plains (`cliff_pieces`); anything else laid by distance (cave_kit.laid) with the same profile.
  - tall grass (`egrass`): the patch's own squares a little above the ground, and round it, in the half of each
    square next to it, HeartGold's bushy edge: `egrass_u` along a row (its top half above the patch, its bottom
    half below), `egrass_v` down a column, `egrass_ro` round an outside corner, `egrass_ri` in an inside one
    (`grass_edges`: a square's quarters, each by the three squares beside it).
  - sand (`road01`): its outer squares carry the edge (`road01_r`: its left half the straight piece, grass at s=0;
    the right half's top quadrant the inside corner, its bottom the outside corner), by the 8 squares round.
  - ponds: the bank (`pond_line`) inside the water's squares from the land, then the edge of the water
    (`pond_edge`), then the water (`pond_on`), each laid by distance from the land (`BANK`, `EDGE`).
  - cards: trees, bushes, rocks, fences, as HeartGold stands them (`CARDS`).
Coordinates of a square's own: u east, v south, 0..16 units; heights from the ground."""
import os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import bmdview
from nitro import read_narc
import cave_kit as K

SRC = 652                   # HeartGold's Safari Zone, the Plains: its ground at 16, its ledges a tier up
TIER = 16
# the cliff's face across its square from the foot (d=0, at the lower ground) to its far side: (d, height, t)
PROFILE = [(0.0, 0.0, 15.6), (0.21, 1.58, 12.6), (0.67, 15.95, 3.1), (1.0, 16.0, 0.5)]
# where the face's texture runs: s = 16 * (the square coordinate to the right, looking at the face) + 16
FACE_S = {(0, 1): (1, 'x'), (0, -1): (-1, 'x'), (1, 0): (-1, 'z'), (-1, 0): (1, 'z')}
# HeartGold's corners in the Plains: an outside corner by its two lower sides, an inside one by its lower corner
OUTSIDE = {frozenset('SE'): (3, 11), frozenset('NE'): (3, 20), frozenset('SW'): (20, 3), frozenset('NW'): (20, 28)}
INSIDE = {(1, 1): (3, 3), (-1, 1): (28, 3), (1, -1): (3, 28), (-1, -1): (28, 28)}
SIDE = {(0, -1): 'N', (0, 1): 'S', (-1, 0): 'W', (1, 0): 'E'}
# the pond: the bank inside the water's square from the land (d, height, t of pond_line), then the water's edge
# (d, height, t of pond_edge) at the water's height, then the water
WATER_Y = -8
BANK = [(0.0, 0.0, 3.3), (0.13, -0.6, 5.6), (0.18, -6.3, 12.1), (0.29, -7.6, 15.6)]
EDGE = [(0.0, WATER_Y, 1.0), (0.31, WATER_Y, 10.0), (0.62, WATER_Y, 15.0)]
GRASS_Y = 2                 # the tall grass over the ground

_pieces = {}


def _polys(lid, land_narc):
    l = read_narc(open(land_narc, 'rb').read())[0][lid]
    ps, bs, ms, hs, mg, ss = struct.unpack_from('<4I2H', l, 0)
    o = 0x14 + ss + ps + bs
    sc, sh = bmdview.model(l[o:o + ms])
    out = []
    for m, t, p in sh:
        for prim, vs in p:
            V = [(v[0] * sc, v[1] * sc, v[2] * sc, v[3], v[4]) for v in vs]
            if prim == 0: out += [(t, V[i:i + 3]) for i in range(0, len(V) - 2, 3)]
            elif prim == 1: out += [(t, V[i:i + 4]) for i in range(0, len(V) - 3, 4)]
            elif prim == 2: out += [(t, [V[i], V[i + 1], V[i + 2]]) for i in range(len(V) - 2)]
            elif prim == 3: out += [(t, [V[i], V[i + 1], V[i + 3], V[i + 2]]) for i in range(0, len(V) - 3, 2)]
    return out


def cliff_pieces(land_narc):
    """-> {('outside', frozenset of two sides) | ('inside', (dx, dz)): (source square, [(texture, [(u, v, h, s, t)])])}:
    HeartGold's corner pieces (the ground they leave open as texture 'ground')"""
    if _pieces: return _pieces
    P = _polys(SRC, land_narc)
    for kind, table in (('outside', OUTSIDE), ('inside', INSIDE)):
        for key, (sx, sz) in table.items():
            x0, z0 = sx * 16 - 256, sz * 16 - 256
            mine = []
            for t, q in P:
                cx = sum(v[0] for v in q) / len(q); cz = sum(v[2] for v in q) / len(q)
                if not (x0 <= cx < x0 + 16 and z0 <= cz < z0 + 16): continue
                small = max(v[0] for v in q) - min(v[0] for v in q) <= 16.01 and max(v[2] for v in q) - min(v[2] for v in q) <= 16.01
                if t.startswith('wall'): mine.append((t, q))
                elif t == 'grass01gs' and small: mine.append(('ground', q))
            _pieces[(kind, key)] = ((sx, sz), [(t, [(v[0] - x0, v[2] - z0, v[1] - 16, v[3], v[4]) for v in q]) for t, q in mine])
            assert mine, (kind, key)
    return _pieces


def face_s(lower, x, z):
    """the face's s at square coordinate (x, z) (corner of squares), for a face whose lower side is `lower`"""
    sign, axis = FACE_S[lower]
    return 16 * sign * (x if axis == 'x' else z) + 16


# the face's three bands, foot to lip, and the textures they take: the foot the ground's (grass: wall01_g's; sand:
# wall01_h's), the face wall01_g's, the lip on top wall01_h's (sand: our plateaus' tops are the GBA's sand)
BANDS = ('foot', 'face', 'lip')
LOOK = {'foot': 'wall01_g', 'face': 'wall01_g', 'lip': 'wall01_h'}


def band_of(t):
    """which band a texture row is in (HeartGold's corner pieces use the texture's second tier too)"""
    t = t % 16 if t > 16.5 else t
    return 'lip' if t <= 3.6 else 'foot' if t >= 12.5 else 'face'


def straight(lower, x, z, look=LOOK):
    """a straight face in square (x, z) (map squares) with lower ground on side `lower`: -> [(texture, [(u, v, h, s, t)])]
    (u, v the square's own, 0..16)"""
    out = []
    dx, dz = lower
    for band, ((d0, h0, t0), (d1, h1, t1)) in zip(BANDS, zip(PROFILE, PROFILE[1:])):
        def pt(d, a, h, t):
            # d across from the lower side, a along (0..1, west to east or north to south)
            if dz: u, v = a * 16, (1 - d) * 16 if dz > 0 else d * 16
            else: u, v = ((1 - d) * 16 if dx > 0 else d * 16), a * 16
            gx, gz = x + u / 16, z + v / 16
            return (u, v, h, face_s(lower, gx, gz), t)
        out.append((look[band], [pt(d0, 0, h0, t0), pt(d0, 1, h0, t0), pt(d1, 1, h1, t1), pt(d1, 0, h1, t1)]))
    return out


def corner(kind, key, x, z, land_narc, look=LOOK):
    """HeartGold's corner piece for square (x, z): its s moved on so it carries on from the face up or down the
    column beside it (the one along the row may be half a repeat out, as HeartGold's own are)"""
    (sx, sz), polys = cliff_pieces(land_narc)[(kind, key)]
    if kind == 'outside': ew = next(s for s in ('E', 'W') if s in key)
    else: ew = 'E' if key[0] > 0 else 'W'
    shift = (-16 if ew == 'E' else 16) * (z - sz)
    def tex(t, q):
        if t != 'wall01_g': return t
        return look['lip'] if max(v[4] for v in q) <= 3.6 else look['face']
    return [(tex(t, q), [(u, v, h, s + shift, tt) for u, v, h, s, tt in q]) for t, q in polys]


def laid(lower, x, z, look=LOOK):
    """an odd square of rock (a nose of rock, a wall between two lower sides): laid by distance from its lower
    squares with the face's profile, flat on top past it -> [(texture, [(u, v, h, s, t)])]"""
    out = []
    for part, rng, f, poly in K.laid(lower, PROFILE, top=True):
        if part == 'top':
            out.append(('top', [(u * 16, v * 16, TIER, None, None) for u, v in poly]))
            continue
        axis, sign = part
        lw = (sign, 0) if axis == 'x' else (0, sign)
        pts = []
        for u, v in poly:
            h, t = K.along_profile(PROFILE, f(u, v))
            pts.append((u * 16, v * 16, h, face_s(lw, x + u, z + v), t))
        lo = rng[0]
        out.append((look['foot' if lo < PROFILE[1][0] - 1e-6 else 'lip' if lo >= PROFILE[2][0] - 1e-6 else 'face'], pts))
    return out


def rock_piece(lower, x, z, land_narc, look=LOOK):
    """the piece for a square of rock at (x, z) whose lower squares (dx, dz) are `lower`"""
    kind, what = K.classify(lower)
    sides = [n for n in SIDE if n in lower]
    if kind == 'straight': return straight(what, x, z, look)
    if kind == 'outside': return corner('outside', frozenset(SIDE[s] for s in sides), x, z, land_narc, look)
    if kind == 'inside': return corner('inside', next(d for d in lower if d[0] and d[1]), x, z, land_narc, look)
    return laid(lower, x, z, look)


# ---------------------------------------------------------------- tall grass
def grass_edges(tall, x, z):
    """HeartGold's bushy edge round a patch of tall grass, in the quarters of square (x, z) (not tall grass)
    next to it: -> [(texture, u0, v0, (s0, t0))] for 8x8 quarters (s, t of the quarter's top left corner)"""
    out = []
    for qx in (0, 1):
        for qz in (0, 1):
            ex, ez = (1 if qx else -1), (1 if qz else -1)       # the sides of the square this quarter is at
            side_x, side_z, diag = (x + ex, z) in tall, (x, z + ez) in tall, (x + ex, z + ez) in tall
            u0, v0 = qx * 8, qz * 8
            if side_x and side_z:       # an inside corner: the patch round two sides of it
                out.append(('egrass_ri', u0, v0, (qx * 8, qz * 8)))
            elif side_z:                # the patch above (ez < 0) or below: egrass_u's bottom or top half
                out.append(('egrass_u', u0, v0, (None, 8 if ez < 0 else 0)))
            elif side_x:                # the patch to the left or right: egrass_v's right or left half
                out.append(('egrass_v', u0, v0, (8 if ex < 0 else 0, None)))
            elif diag:                  # round an outside corner of the patch
                out.append(('egrass_ro', u0, v0, (8 if ex < 0 else 0, 8 if ez < 0 else 0)))
    return out


# ---------------------------------------------------------------- sand
def sand_piece(other, x, z):
    """the sand's edge in square (x, z) of sand, `other` the squares round it that are not sand (dx, dz): ->
    ('plain', None) | ('straight', side) | ('outside', (dx, dz) the corner the grass is round) |
    ('inside', (dx, dz) the corner grass is at) | ('laid', None)"""
    if not other: return ('plain', None)
    kind, what = K.classify(other)
    sides = [n for n in SIDE if n in other]
    if kind == 'straight': return ('straight', what)
    if kind == 'outside': return ('outside', (sum(s[0] for s in sides), sum(s[1] for s in sides)))
    if kind == 'inside': return ('inside', next(d for d in other if d[0] and d[1]))
    return ('laid', None)


# ---------------------------------------------------------------- cards (as HeartGold stands them, from the Plains,
# Route 47's fences and the Safari's rocks): (texture, width in squares, s0, s1, t0, t1, foot height, foot z,
# top height, top z) - z in squares from the square's (or block's) north edge
CARDS = {
    'tree': ('tree01gs', 4, 0, 64, 0, 64, 0.0, 1.62, 49.3, -0.92),       # over a 2x2 block, centred on it
    'bush': ('etc_a', 1, 16.6, 31.4, 0.6, 15.5, 2.3, 0.85, 16.0, 0.30),
    'rock': ('rock01', 2, 0, 32, 0, 32, 0.7, 0.95, 23.3, -0.47),        # over two squares side by side (HeartGold's
                                                                          # stands on a 2x2 block: this one row up)
    'stone': ('etc_a', 1, 0.6, 15.5, 16.5, 31.5, 2.3, 0.85, 16.0, 0.30),
    'fence': ('fence_b', 1, 0, 16, 0, 16, 0.3, 0.98, 11.7, 0.27),        # along a row (s on, 16 a square)
    'post': ('fence_b', 0.5, 16, 24, 0, 16, 0.3, 0.98, 11.7, 0.27),       # a post seen end on (a fence down a column)
}
