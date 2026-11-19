"""HeartGold's own pieces read out of its own lands (as they were: build_overworld.HG_REV), for building the GBA's
layouts from them (Nick: "verify with the HeartGold maps... make sure it matches"):

- a *kit*: the polygons of each square of one kind of thing in a HeartGold map (Route 12's boardwalk, Route 24's
  Nugget Bridge), each keyed by which of the 24 squares round it are that thing too; a square of ours takes the piece
  whose surroundings are most like its own (`pick`).
- a *stamp*: every polygon over a block of squares (Fuchsia's hedged pens), and the building models on it.

Heights are from the HeartGold map's ground (its most common grass height), as ours are. Kept in data/kit_*.json:
python3 tools/canvas/hg_kit.py writes them."""
import collections, json, os, re, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

RING = [(a, b) for b in range(-2, 3) for a in range(-2, 3) if (a, b) != (0, 0)]


def _hg():
    import build_overworld as BO, slots
    d = BO._git(os.path.join(slots.MATRIX_DIR, 'map_matrix_0000_EVERYWHERE.bin'))
    w, h, hh, ha, nl = d[:5]
    hdr = struct.unpack_from('<%dH' % (w * h), d, 5 + nl); ls = struct.unpack_from('<%dH' % (w * h), d, 5 + nl + 3 * w * h)
    ids = {}
    for l in open(os.path.join(slots.ROOT, 'include/constants/maps.h')):
        m = re.match(r'#define (MAP_\w+)\s+(\d+)', l)
        if m: ids[m.group(1)] = int(m.group(2))
    return w, hdr, ls, ids


def clip(P, x0, x1, z0, z1):
    """a polygon (x, y, z, s, t vertices) cut to x0..x1, z0..z1 (on the ground's plan), all else along the cut
    in proportion"""
    def cut(P, i, lim, keep):
        out = []
        for k in range(len(P)):
            a, b = P[k], P[(k + 1) % len(P)]
            ia, ib = keep(a[i], lim), keep(b[i], lim)
            if ia: out.append(a)
            if ia != ib and a[i] != b[i]:
                f = (lim - a[i]) / (b[i] - a[i])
                out.append(tuple(a[j] + (b[j] - a[j]) * f for j in range(5)))
        return out
    for i, lim, keep in ((0, x0, lambda v, l: v >= l - 1e-6), (0, x1, lambda v, l: v <= l + 1e-6),
                         (2, z0, lambda v, l: v >= l - 1e-6), (2, z1, lambda v, l: v <= l + 1e-6)):
        P = cut(P, i, lim, keep)
        if len(P) < 3: return []
    return P


def squares(hg_map, split=True):
    """-> {(gx, gz): [(tex, [(x, y, z, s, t) from the square's corner])]}, the ground's height, the props
    [(model, gx, gz, y)] - over the map's lands, in the matrix's squares; a polygon over several squares cut into
    each one's part, so that a square's polygons are its own"""
    import landview, world as hgworld, collections as C
    w, hdr, ls, ids = _hg()
    L = hgworld.lands()
    out, props, ground = C.defaultdict(list), [], C.Counter()
    for i, v in enumerate(hdr):
        if v != ids[hg_map]: continue
        cx, cz = i % w, i // w
        land = L[ls[i]]
        for tex, P in quads([(t, [tuple(p) for p in P]) for t, P in landview.tris(land, 0, 0)]):
            if tex == 'grass01gs': ground[round(P[0][1], 1)] += 1
            xs, zs = [p[0] + 256 for p in P], [p[2] + 256 for p in P]
            if not split:       # (a stamp: whole polygons, by their middles)
                sx, sz = int(sum(xs) / len(xs) // 16), int(sum(zs) / len(zs) // 16)
                out[(cx * 32 + sx, cz * 32 + sz)].append((tex, [(p[0] + 256 - sx * 16, p[1], p[2] + 256 - sz * 16, p[3], p[4]) for p in P]))
                continue
            for sx in range(int(min(xs) // 16), int(max(xs) // 16) + 1):
                for sz in range(int(min(zs) // 16), int(max(zs) // 16) + 1):
                    Q = clip([(p[0] + 256, p[1], p[2] + 256, p[3], p[4]) for p in P], sx * 16, sx * 16 + 16, sz * 16, sz * 16 + 16)
                    if not Q: continue
                    mx, mz = sum(p[0] for p in Q) / len(Q), sum(p[2] for p in Q) / len(Q)
                    if not (sx * 16 - 1e-6 <= mx <= sx * 16 + 16 + 1e-6 and sz * 16 - 1e-6 <= mz <= sz * 16 + 16 + 1e-6): continue   # (a face on a square's side: both squares')
                    out[(cx * 32 + sx, cz * 32 + sz)].append((tex, [(p[0] - sx * 16, p[1], p[2] - sz * 16, p[3], p[4]) for p in Q]))
        ps, bs, ms, hs, mg, ss = struct.unpack_from('<4I2H', land, 0)
        if mg != 0x1234: ss = 0
        for j in range(bs // 48):
            mdl, x, y, z = struct.unpack_from('<I3i', land, 0x14 + ss + ps + j * 48)
            props.append((mdl, cx * 32 + 16 + x / 4096 / 16, cz * 32 + 16 + z / 4096 / 16, y / 4096))
    return out, ground.most_common(1)[0][0], props


def quads(polys):
    """triangles back into the quads HeartGold drew (two in a row of one texture sharing an edge, flat together):
    half the polygons"""
    out, i = [], 0
    while i < len(polys):
        t, P = polys[i]
        if i + 1 < len(polys) and polys[i + 1][0] == t and len(P) == 3 and len(polys[i + 1][1]) == 3:
            Q = polys[i + 1][1]
            shared = [p for p in P if p in Q]
            if len(shared) == 2:
                a = next(p for p in P if p not in Q); d = next(p for p in Q if p not in P)
                i0 = P.index(a)
                b, c = P[(i0 + 1) % 3], P[(i0 + 2) % 3]        # (a, b, c) and the other's apex d opposite a
                v = lambda p, q: (q[0] - p[0], q[1] - p[1], q[2] - p[2])
                cr = lambda u, w: (u[1] * w[2] - u[2] * w[1], u[2] * w[0] - u[0] * w[2], u[0] * w[1] - u[1] * w[0])
                n = cr(v(a, b), v(a, c)); dot = sum(x * y for x, y in zip(n, v(a, d)))
                if abs(dot) < 1e-3 * (1 + sum(x * x for x in n)) ** 0.5:
                    out.append((t, [a, b, d, c])); i += 2; continue
        out.append((t, P)); i += 1
    return out


def make_kit(hg_map, member, top, keep):
    """the squares whose top (polygons of `member` textures at `top`) is the thing: their `keep` polygons, by the
    24 squares round them"""
    sq, g0, _ = squares(hg_map)
    def flat_area(P):
        return abs(sum(P[k][0] * P[(k + 1) % len(P)][2] - P[(k + 1) % len(P)][0] * P[k][2] for k in range(len(P)))) / 2
    # (the thing's squares: those its top covers most of)
    mem = {q for q, polys in sq.items() if sum(flat_area(P) for t, P in polys if t in member and all(abs(p[1] - top) < 0.6 for p in P)) > 160}
    crate = {q for q in mem if sum(flat_area(P) for t, P in sq[q] if t == 'sio_board' and all(abs(p[1] - top) < 0.6 for p in P)) > 160}
    pos = blocks(crate)
    kit = []
    for q in sorted(mem):
        mask = sum(1 << i for i, (a, b) in enumerate(RING) if (q[0] + a, q[1] + b) in mem)
        polys = [(t, [(round(x, 2), round(y - g0, 2), round(z, 2), round(s, 2), round(tt, 2)) for x, y, z, s, tt in P]) for t, P in sq[q] if t in keep]
        cls = 'crate' if q in pos else 'plank'
        kit.append({'mask': mask, 'cls': cls, 'pos': pos.get(q), 'polys': polys})
    # (and the water round it: the deck's overhang, the water splashing against it - HeartGold's foam - by the thing
    # round each such square)
    edge = []
    for q in sorted(sq):
        if q in mem or not any((q[0] + a, q[1] + b) in mem for a in (-1, 0, 1) for b in (-1, 0, 1)): continue
        if not any(t in ('sea_on', 'river', 'pond_on') for t, P in sq[q]): continue
        mask = sum(1 << i for i, (a, b) in enumerate(RING) if (q[0] + a, q[1] + b) in mem)
        polys = [(t, [(round(x, 2), round(y - g0, 2), round(z, 2), round(s, 2), round(tt, 2)) for x, y, z, s, tt in P]) for t, P in sq[q]
                 if t in keep or t in FOAM]
        edge.append({'mask': mask, 'polys': polys})
    return {'map': hg_map, 'ground': g0, 'top': top - g0, 'pieces': kit, 'edge': edge}


FOAM = {'sea_line02', 'pond_line'}


def make_stamp(hg_map, x0, z0, x1, z1, keep, models):
    """every `keep` polygon over squares x0..x1, z0..z1 of a HeartGold map (its matrix squares), and its `models`"""
    sq, g0, props = squares(hg_map, split=False)
    polys = []
    for (gx, gz), ps in sq.items():
        # (and the row behind: the hedges' tops lean back over it)
        if x0 <= gx <= x1 and z0 - 1 <= gz <= z1:
            polys += [(t, [(x + (gx - x0) * 16, round(y - g0, 2), z + (gz - z0) * 16, s, tt) for x, y, z, s, tt in P]) for t, P in ps
                      if t in keep and (gz >= z0 or t in ('sek_teien', 'sek_flower'))]
    pr = [(m, x - x0, z - z0, y - g0) for m, x, z, y in props if m in models and x0 <= x < x1 + 1 and z0 <= z < z1 + 1]
    return {'map': hg_map, 'size': (x1 - x0 + 1, z1 - z0 + 1), 'polys': [q for q in quads(polys) if seen(q[1])], 'props': pr}


def seen(P):
    """whether a polygon faces the camera at all (HeartGold's looks down from the south: nothing facing north or
    down is ever seen)"""
    a, b, c = P[0][:3], P[1][:3], P[2][:3]
    u = [b[i] - a[i] for i in range(3)]; v = [c[i] - a[i] for i in range(3)]
    n = (u[1] * v[2] - u[2] * v[1], u[2] * v[0] - u[0] * v[2], u[0] * v[1] - u[1] * v[0])
    L = sum(x * x for x in n) ** 0.5 or 1
    return n[2] / L > -0.15 and n[1] / L > -0.15 and (abs(n[0]) / L < 0.9 or n[1] / L > 0.35)     # (nor straight east or west)


def blocks(sqs):
    """squares tiled into whole 3 x 3 blocks, top left first: {square: its place in its block, 0..8}"""
    out = {}
    for q in sorted(sqs, key=lambda q: (q[1], q[0])):
        if q in out: continue
        blk = [(q[0] + i, q[1] + j) for j in range(3) for i in range(3)]
        if all(b in sqs and b not in out for b in blk):
            for k, b in enumerate(blk): out[b] = k
    return out


def pick(kit, have, cls=None, pos=None):
    """the kit's piece for a square of ours: `have(a, b)` whether the square (a, b) from it is the thing too. The
    eight round it count most, the ring outside them once each; of its class (a boardwalk's crossings, its planks)
    where it has one"""
    m = sum(1 << i for i, (a, b) in enumerate(RING) if have(a, b))
    wt = [4 if max(abs(a), abs(b)) == 1 else 1 for a, b in RING]
    pool = kit['edge'] if cls == 'edge' else [p for p in kit['pieces'] if p.get('cls') == cls and (pos is None or p.get('pos') == pos)] \
        or [p for p in kit['pieces'] if p.get('cls') == cls] or kit['pieces']
    best = min(pool, key=lambda p: sum(w for i, w in enumerate(wt) if ((p['mask'] ^ m) >> i) & 1))
    return best['polys']


KITS = {
    # Route 12's boardwalk (Silence Bridge): the decks (bridge_c, sio_board's crossings), their trims and posts
    'boardwalk': lambda: make_kit('MAP_ROUTE_12', {'bridge_c', 'sio_board', 'bridge_b', 'bridge_a'}, 18.0,
                                  {'bridge_a', 'bridge_b', 'bridge_c', 'sio_board'}),
    # Route 24's Nugget Bridge
    'nugget': lambda: make_kit('MAP_ROUTE_24', {'a12_gbb2', 'a12_gbb3'}, 50.0, {'a12_gbb1', 'a12_gbb2', 'a12_gbb3'}),
}
PEN_TEX = {'grass02', 'grass02_a', 'sek_teien', 'sek_flower', 'flower01', 'flower02', 'f_dodai', 'f_dodai_a',
           'flower_sp1', 'pond_un', 'pond_on', 'pond_edge', 'pond_line'}
STAMPS = {
    # Fuchsia's hedged pens (7 x 5 squares: hedges round three sides, white rails along the front): with a pond, with
    # a raised flower bed, with flowers
    'pen_pond': lambda: make_stamp('MAP_FUCHSIA', 1196, 406, 1202, 410, PEN_TEX - {'pond_un', 'pond_on', 'pond_edge', 'pond_line'}, {333}),
    'pen_bed': lambda: make_stamp('MAP_FUCHSIA', 1219, 406, 1225, 410, PEN_TEX, {333}),
    'pen_flowers': lambda: make_stamp('MAP_FUCHSIA', 1227, 406, 1233, 410, PEN_TEX, {333}),
}


def load(name):
    return json.load(open(os.path.join(HERE, 'data', 'kit_%s.json' % name)))


if __name__ == '__main__':
    for name, f in KITS.items():
        k = f()
        json.dump(k, open(os.path.join(HERE, 'data', 'kit_%s.json' % name), 'w'))
        print(name, len(k['pieces']), 'pieces, ground', k['ground'], 'top', k['top'])
    for name, f in STAMPS.items():
        k = f()
        json.dump(k, open(os.path.join(HERE, 'data', 'kit_%s.json' % name), 'w'))
        print(name, len(k['polys']), 'polygons', len(k['props']), 'models')
