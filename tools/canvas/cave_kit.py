"""The pieces a cave is built from, a square at a time, as HeartGold builds its own (read off Union Cave).

Every square of rock that has lower ground beside it (in the 8 squares round it) is a wall piece, a tier (TIER)
high, from its foot at the lower ground up to its top:
  - a straight face: three bands across the square (PROFILE), leaning back from the lower side;
  - an outside corner (two sides next to each other lower) and an inside corner (only the square between them,
    cornerwise, lower): HeartGold's own pieces, with their own textures (dwall_wn, dwall_ne, dwall_es,
    dwall_sw), read out of Union Cave's lands at build time (corner_pieces);
  - anything else: the face laid by distance (`laid`): each point of the square is as far up the profile as it
    is from the nearest lower square (counting squares as boxes, so the distance runs square to the sides and
    mitres at corners).
All of them have the straight face's profile along every side of the square, so any piece meets any other: a
wall is pieces, never stretched or squeezed. Water's bank is laid the same way inside the water's squares.

Coordinates here are a square's own: u east, v south, 0..1; heights from the piece's foot."""
import os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
import bmdview
from nitro import read_narc

TIER = 16
# HeartGold's face, across a square from its foot: (how far across, how high, texture row)
PROFILE = [(0.0, 0.0, 15.75), (3.38 / 16, 1.58, 13.0), (10.72 / 16, 15.95, 4.0), (1.0, 16.0, 0.25)]
# its bank, inside the water's square from the edge: (how far in, height from the floor, texture row of 16)
BANK = [(0.0, 1.0, 3.3), (2.0 / 16, -0.6, 5.6), (2.8 / 16, -6.3, 12.1), (4.9 / 16, -7.6, 15.6)]
SIDES = {(0, -1): 'N', (0, 1): 'S', (-1, 0): 'W', (1, 0): 'E'}
# textures: a straight face by where the rock is from the lower ground; s runs along it as HeartGold's do
FACE = {(0, 1): ('dwall_n', 1, 'x'), (0, -1): ('dwall_s', -1, 'x'), (1, 0): ('dwall_w', -1, 'z'), (-1, 0): ('dwall_e', 1, 'z')}
# HeartGold's corner pieces: an outside corner by its two lower sides, an inside corner by its lower diagonal
OUTSIDE = {frozenset('SE'): 'dwall_wn', frozenset('NW'): 'dwall_es', frozenset('SW'): 'dwall_ne', frozenset('NE'): 'dwall_sw'}
INSIDE = {(1, 1): 'dwall_wn', (-1, -1): 'dwall_es', (-1, 1): 'dwall_ne', (1, -1): 'dwall_sw'}
# where they are in Union Cave's lands: (land, x, z)
SOURCES = {('outside', 'dwall_es'): (485, 16, 11), ('outside', 'dwall_ne'): (485, 16, 18), ('outside', 'dwall_sw'): (485, 20, 11),
           ('outside', 'dwall_wn'): (485, 20, 18), ('inside', 'dwall_es'): (479, 8, 5), ('inside', 'dwall_ne'): (479, 9, 23),
           ('inside', 'dwall_sw'): (479, 1, 27), ('inside', 'dwall_wn'): (479, 1, 23)}
_corners = {}


def corner_pieces(land_narc):
    """-> {(kind, texture): [polygon: [(u, v, h, s, t)]]}, u and v 0..16 here (units), from HeartGold's lands"""
    if _corners: return _corners
    lands = read_narc(open(land_narc, 'rb').read())[0]
    for (kind, tex), (lid, sx, sz) in SOURCES.items():
        l = lands[lid]
        ps, bs, ms, hs, mg, ss = struct.unpack_from('<4I2H', l, 0)
        o = 0x14 + ss + ps + bs
        sc, sh = bmdview.model(l[o:o + ms])
        polys = []
        for m, t, p in sh:
            if t != tex: continue
            for prim, vs in p:
                V = [(v[0] * sc, v[1] * sc, v[2] * sc, v[3], v[4]) for v in vs]
                if prim == 0: polys += [V[i:i + 3] for i in range(0, len(V) - 2, 3)]
                elif prim == 1: polys += [V[i:i + 4] for i in range(0, len(V) - 3, 4)]
                elif prim == 2: polys += [[V[i], V[i + 1], V[i + 2]] for i in range(len(V) - 2)]
                elif prim == 3: polys += [[V[i], V[i + 1], V[i + 3], V[i + 2]] for i in range(0, len(V) - 3, 2)]
        x0, z0 = sx * 16 - 256, sz * 16 - 256
        mine = [q for q in polys if x0 <= sum(v[0] for v in q) / len(q) < x0 + 16 and z0 <= sum(v[2] for v in q) / len(q) < z0 + 16]
        y0 = min(v[1] for q in mine for v in q)
        _corners[(kind, tex)] = [[(v[0] - x0, v[2] - z0, v[1] - y0, v[3], v[4]) for v in q] for q in mine]
        assert len(mine) == 8, (kind, tex, len(mine))
    return _corners


# ---------------------------------------------------------------- laying by distance
def _gap(d, w):
    """distance (in squares) across one axis from a point at w (0..1) to the square d over: as (a, c) for a*w + c"""
    return None if d == 0 else (-1.0, 1.0) if d > 0 else (1.0, 0.0)


def distance_fns(lower):
    """the lower squares as distance functions: per square, its (one or two) linear parts (a_u, a_v, c, axis, sign)"""
    out = []
    for dx, dz in lower:
        parts = []
        g = _gap(dx, 0)
        if g: parts.append((g[0], 0.0, g[1], 'x', dx))
        g = _gap(dz, 0)
        if g: parts.append((0.0, g[0], g[1], 'z', dz))
        out.append(parts)
    return out


def distance(fns, u, v):
    """-> (d, the part that gives it): the distance to the nearest lower square (each square's own is the larger of
    its gaps across the two axes)"""
    best = None
    for parts in fns:
        p = max(parts, key=lambda q: q[0] * u + q[1] * v + q[2])
        val = p[0] * u + p[1] * v + p[2]
        if best is None or val < best[0] - 1e-9: best = (val, p)
    return best


JACK = [(0, 0), (0.5, 0), (1, 0), (1, 0.5), (1, 1), (0.5, 1), (0, 1), (0, 0.5)]


def _clip(poly, f, lo, hi):
    """the part of a polygon (points (u, v)) where lo <= f(u, v) <= hi, f linear"""
    for bound, keep in ((lo, lambda val: val >= lo - 1e-9), (hi, lambda val: val <= hi + 1e-9)):
        out = []
        for i, a in enumerate(poly):
            b = poly[(i + 1) % len(poly)]
            fa, fb = f(*a), f(*b)
            if keep(fa): out.append(a)
            if keep(fa) != keep(fb) and abs(fb - fa) > 1e-12:
                t = (bound - fa) / (fb - fa)
                out.append((a[0] + t * (b[0] - a[0]), a[1] + t * (b[1] - a[1])))
        poly = out
        if len(poly) < 3: return []
    return poly


def laid(lower, profile, top=None):
    """A square laid by its distance from `lower` (squares round it, as (dx, dz)): -> [(part, d range, polygon)]
    where part says which side the nearest lower square is on (axis, sign) and polygon is (u, v) points; with
    `top`, also the part past the profile's end ('top', polygon)."""
    fns = distance_fns(lower)
    out = []
    marks = [p[0] for p in profile]
    for k in range(8):
        tri = [(0.5, 0.5), JACK[k], JACK[(k + 1) % 8]]
        cu, cv = sum(p[0] for p in tri) / 3, sum(p[1] for p in tri) / 3
        _, part = distance(fns, cu, cv)
        f = lambda u, v, p=part: p[0] * u + p[1] * v + p[2]
        for lo, hi in zip(marks, marks[1:]):
            poly = _clip(tri, f, lo, hi)
            if poly: out.append(((part[3], part[4]), (lo, hi), f, poly))
        if top is not None:
            poly = _clip(tri, f, marks[-1], 99)
            if poly: out.append(('top', None, f, poly))
    return out


def along_profile(profile, d):
    """height and texture row at distance d (clamped to the profile)"""
    d = max(profile[0][0], min(profile[-1][0], d))
    for (d0, h0, r0), (d1, h1, r1) in zip(profile, profile[1:]):
        if d <= d1 + 1e-9:
            t = 0 if d1 == d0 else (d - d0) / (d1 - d0)
            return h0 + t * (h1 - h0), r0 + t * (r1 - r0)
    return profile[-1][1], profile[-1][2]


def classify(lower):
    """-> ('straight', side) | ('outside', texture) | ('inside', texture) | ('laid', None) for a wall square whose
    lower squares (dx, dz) are `lower`"""
    sides = [n for n in SIDES if n in lower]
    diag = [d for d in lower if d[0] and d[1]]
    if len(sides) == 1:
        n = sides[0]
        # (a lower square cornerwise beside the lower side changes nothing)
        if all((d[0] == n[0]) if n[0] else (d[1] == n[1]) for d in diag): return ('straight', n)
    if len(sides) == 2 and (sides[0][0] + sides[1][0], sides[0][1] + sides[1][1]) != (0, 0):
        opp = (-(sides[0][0] + sides[1][0]), -(sides[0][1] + sides[1][1]))
        if opp not in lower:
            return ('outside', OUTSIDE[frozenset(SIDES[sides[0]] + SIDES[sides[1]])])
    if not sides and len(diag) == 1:
        return ('inside', INSIDE[diag[0]])
    return ('laid', None)


def normal(pts):
    """a polygon's normal, from its first three points (x, y, z)"""
    (ax, ay, az), (bx, by, bz), (cx, cy, cz) = pts[0], pts[1], pts[2]
    ux, uy, uz, vx, vy, vz = bx - ax, by - ay, bz - az, cx - ax, cy - ay, cz - az
    n = (uy * vz - uz * vy, uz * vx - ux * vz, ux * vy - uy * vx)
    m = sum(c * c for c in n) ** 0.5 or 1
    n = tuple(c / m for c in n)
    return n if n[1] >= 0 else tuple(-c for c in n)


def facing_up(verts):
    """vertices ((x, y, z), uv) of a polygon put in the order that faces up (as the land's other flat pieces)"""
    ar = sum(verts[i][0][0] * verts[(i + 1) % len(verts)][0][2] - verts[(i + 1) % len(verts)][0][0] * verts[i][0][2] for i in range(len(verts)))
    return list(reversed(verts)) if ar > 0 else verts


def stripify(polys):
    """HeartGold's pieces are strips at heart (a band of quads round the foot, a run of triangles up to the top):
    -> [('q' | 't', vertices)] quad strips, triangle strips, and ('quad' | 'tri', vertices) for the rest"""
    key = lambda v: tuple(round(c, 2) for c in v)
    out, i = [], 0
    while i < len(polys):
        p = polys[i]
        if len(p) == 4:
            strip, j = [p[0], p[1], p[3], p[2]], i + 1
            while j < len(polys) and len(polys[j]) == 4 and key(polys[j][0]) == key(strip[-2]) and key(polys[j][1]) == key(strip[-1]):
                strip += [polys[j][3], polys[j][2]]; j += 1
            out.append(('q', strip) if j > i + 1 else ('quad', p))
        else:
            strip, j = list(p), i + 1
            while j < len(polys) and len(polys[j]) == 3 and key(polys[j][0]) == key(strip[-2]) and key(polys[j][1]) == key(strip[-1]):
                strip.append(polys[j][2]); j += 1
            out.append(('t', strip) if j > i + 1 else ('tri', p))
        i = j
    return out
