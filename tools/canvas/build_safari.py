"""The Safari Zone's four areas, from the GBA's layouts, built from HeartGold's own Safari Zone pieces (its texture
set 75 and the pieces route_kit reads off its Plains) a square at a time - see CANVAS.md, "Build from a tile kit".

What each GBA square is (`kinds`): grass; sand (HeartGold's road, its edge in the sand's outer squares); tall grass
(HeartGold's, with its bushy edge round the patch); a pond (bank, edge, water); a plateau's top (a tier up, sand)
and its cliff (the rock squares round it, HeartGold's ledge pieces) with the GBA's stairs as HeartGold's ramp; the
woods (HeartGold's trees, one to a 2x2 block); hedges (HeartGold's round bushes); fences and posts; signs (its sign
model); a boulder (its rock); a rest house (Fuchsia's house model, its door on the GBA's door square).

The GBA draws a plateau's north edge inside its top row: walking off it north is stopped by elevation alone. A
face needs a square of its own, so a row is added there (`plan`, widening the map as build_rooms.widen does; the
porter moves people with it)."""
import math, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from g3d import Mesh, build_model
import gba_map
import cave_kit as K
import route_kit as R
from build_rooms import texdims, widen

ROOT = os.path.dirname(os.path.dirname(HERE))
LAND_NARC = os.path.join(ROOT, 'files/a/0/6/5')
TEXSET = 75                 # HeartGold's Safari Zone's textures
AREA = 121                  # our own area: those textures with Fuchsia's buildings (build_interiors.OWN_AREAS)
TALL_GRASS_MB = {2}
WATER_MB = {16, 17, 18, 19, 20, 21, 24, 26, 44, 45}
WATER_MT = {0x117}          # (a pond's corner the GBA closes)
SIGN_MT = {0x002, 0x003}
FENCE_MT = {0x0E6, 0x308, 0x309, 0x30A, 0x332}
HEDGE_MT = {0x2F4, 0x29F}
STAIR_MT = {0x089, 0x091}
# the GBA's sand: its middle, its edges and its inside corners
SAND_MT = {0x102, 0x103, 0x104, 0x105, 0x0D3, 0x0D4, 0x0D5, 0x0D9, 0x0DB, 0x0DC, 0x0DD, 0x0E3, 0x0E4, 0x0E5, 0x1E6, 0x33A}
CLIFF_MT = {0x068, 0x06A, 0x070, 0x072, 0x073, 0x078, 0x079, 0x07A, 0x07B, 0x07C, 0x0B2, 0x0B3, 0x2EC, 0x2EF}   # (a boulder too, alone)
HOUSE = dict(model=297, at=(1.0, -1.12), door=307, door_at=(1.12, -0.12))      # Fuchsia's house and its door (in Fuchsia: the door 0.12 right of the house; its front on the door's row's south edge, not over the next row)
SIGN_MODEL = 29
# the area's texture animation scrolls a land's first eight materials by index: pond_on's and pond_edge's places
# are theirs, the rest held empty
ANIM = ['pond_on', 'swave_p', 'pond_edge', 'sea_line02', 'sea_un', 'sea_on', 'river', 'river_r']
GROUND, SAND, TOP = 'grass01gs', 'road01', 'road01'
# drawn before the ground they lie level with (the DS keeps the first of two things at one depth)
FIRST = ['tree01_un', 'road01_r']


def _colour_fn(lay):
    cache = {}

    def col(x, y):
        m = lay.metatile(x, y)
        if m not in cache:
            px = list(lay.render_metatile(m).convert('RGB').getdata())
            cache[m] = tuple(sum(c[i] for c in px) // len(px) for i in range(3))
        return cache[m]
    return col


def kinds(gm, lay, added=()):
    """-> {(x, y): kind} for every square of the (widened) map, and the doors. `added`: rows put in for a plateau's
    north face (their squares beside a plateau's top are its cliff)"""
    W, H = lay.w, lay.h
    col = _colour_fn(lay)
    inb = lambda x, y: 0 <= x < W and 0 <= y < H
    warps = {(w['x'], w['y']) for w in gm.get('warp_events', [])}
    mt = lambda x, y: lay.metatile(x, y)
    mb = lambda x, y: lay.behavior(lay.metatile(x, y))
    shut = lambda x, y: lay.collision(x, y) != 0 and (x, y) not in warps
    water = lambda x, y: mb(x, y) in WATER_MB or mt(x, y) in WATER_MT
    green = lambda x, y: (lambda c: c[1] > c[0] + 12 and c[1] > c[2] + 12)(col(x, y))
    sandy = lambda x, y: mt(x, y) in SAND_MT
    top = lambda x, y: inb(x, y) and not shut(x, y) and lay.elevation(x, y) == 4
    stairs = lambda x, y: inb(x, y) and mt(x, y) in STAIR_MT
    signs = {(b['x'], b['y']) for b in gm.get('bg_events', []) if b.get('type', 'sign') == 'sign'}
    doors = [s for s in warps if lay.collision(*s) != 0 and 0x2B7 <= mt(*s) <= 0x2E1]
    building, todo = set(), list(doors)
    while todo:
        x, y = todo.pop()
        for dx, dy in ((1, 0), (-1, 0), (0, -1), (0, 1)):
            n = (x + dx, y + dy)
            if n not in building and inb(*n) and shut(*n) and n not in warps and 0x2B7 <= mt(*n) <= 0x2E1:
                building.add(n); todo.append(n)
    near_top = lambda x, y: any(top(x + dx, y + dy) or stairs(x + dx, y + dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1))
    out = {}
    for y in range(H):
        for x in range(W):
            m = mt(x, y)
            if stairs(x, y): k = 'stairs'
            elif top(x, y): k = 'top'
            elif (y in added or shut(x, y)) and near_top(x, y): k = 'cliff'      # (a pond's closed corner by a plateau too)
            elif water(x, y): k = 'water'
            elif not shut(x, y):
                k = 'tall' if mb(x, y) in TALL_GRASS_MB else 'sand' if sandy(x, y) else 'grass'
            elif (x, y) in building: k = 'house'
            elif (x, y) in signs: k = 'sign'
            elif m in SIGN_MT: k = 'blank'          # (a sign's square copied into a row we added)
            elif m in FENCE_MT: k = 'fence'
            elif m in HEDGE_MT: k = 'hedge'
            elif m in CLIFF_MT: k = 'cliff' if near_top(x, y) else 'boulder'
            elif sandy(x, y) and not near_top(x, y): k = 'sand'       # (a way out's path, past its warp)
            elif green(x, y): k = 'woods'
            elif near_top(x, y): k = 'cliff'
            elif 0x2B7 <= m <= 0x2E1: k = 'gate'
            else: k = 'boulder'
            if y in added and k in ('fence', 'hedge', 'sign'): k = 'blank'     # (a fence copied into a row we added
            out[(x, y)] = k                                                  # would be a fence two deep: grass, closed)
    # the gate building's roof, below the way out at the bottom of the Center: HeartGold's ways out of an area are
    # a path between the trees, so the path carries on down from the way out and the rest of the roof is trees
    ways = {x for (x, y) in warps if (x, y) not in doors}
    for q, v in out.items():
        if v == 'gate': out[q] = 'sand' if q[0] in ways else 'woods'
    return out, doors


def plan(gba):
    """-> build_rooms.widen's rows: one more row wherever a plateau's top meets anything but its cliff to the north
    (a copy of the row north of it)"""
    gm = gba_map.map_json(gba); lay = gba_map.Layout(gm['layout'])
    k, _ = kinds(gm, lay)
    need = sorted({y for (x, y), v in k.items() if v == 'top' and y > 0 and k[(x, y - 1)] not in ('top', 'cliff', 'stairs')})
    return dict(rows=[(y, 1, y - 1) for y in need]) if need else {}


MOVED_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data', 'safari_moved.json')
MOVED = {}            # GBA map -> {"x,z": [x, z]}: signs moved off the square in front of a door (our squares)


def build_safari_floor(spec, depth_of):
    gm = gba_map.map_json(spec['gba'])
    lay = gba_map.Layout(gm['layout'])
    p = spec.get('widen') or {}
    added = set()
    if p:
        rows = p.get('rows', [])
        gm = widen(gm, lay, **p)
        for r, n, _ in rows:
            ny = r + sum(m for rr, m, _ in rows if rr <= r)
            added |= set(range(ny - n, ny))
    W, H = lay.w, lay.h
    kind, doors = kinds(gm, lay, added)
    K_ = lambda x, y: kind.get((x, y))
    dims, pals = texdims(TEXSET)
    pal_of = lambda t: next(q for q in (t + '_pl', t, t.replace('gs', ''), t.replace('gs', '') + '_pl') if q in pals)
    level = lambda x, y: 1 if K_(x, y) in ('top', 'cliff', 'stairs') else 0
    # the rest houses: Fuchsia's house over each one's squares, its door where the model has it (the GBA's is a
    # square to the left of the middle; the warp moves to the model's)
    houses = []
    for (x, y) in doors:
        sq, todo = {(x, y)}, [(x, y)]
        while todo:
            a, b = todo.pop()
            for n in ((a + 1, b), (a - 1, b), (a, b - 1), (a, b + 1)):
                if n not in sq and kind.get(n) == 'house': sq.add(n); todo.append(n)
        x0, x1 = min(q[0] for q in sq), max(q[0] for q in sq)
        ox_ = (x0 + x1 + 1) / 2 - 0.125
        dx_ = int(ox_ + HOUSE['door_at'][0] - HOUSE['at'][0])
        houses.append((ox_, y, dx_))
        for w in gm['warp_events']:
            if (w['x'], w['y']) == (x, y): w['x'] = dx_
        kind[(x, y)] = 'house'; kind[(dx_, y)] = 'door'
        # (the rest house's sign stands a square right of the GBA's door - in front of the model's: it goes in front
        # of the GBA's door instead, and its words with it (the porter reads MOVED))
        if dx_ != x and kind.get((dx_, y + 1)) == 'sign' and kind.get((x, y + 1)) not in OBJECTS:
            kind[(x, y + 1)], kind[(dx_, y + 1)] = 'sign', kind.get((x, y + 1))
            MOVED.setdefault(spec['gba'], {})['%d,%d' % (dx_, y + 1)] = [x, y + 1]
    doors = [(dx_, y) for _, y, dx_ in houses]
    # (HeartGold's house is taller than the GBA's: its roof reaches back over the row behind. A bush or a fence there
    # would stand in the roof, so it goes)
    for hx, y, _ in houses:
        for q, v in list(kind.items()):
            if v in ('hedge', 'fence') and hx - 2.4 < q[0] + 0.5 < hx + 2.6 and y - 3.7 < q[1] + 0.5 < y + 1: kind[q] = 'house'
    for (x, y), v in kind.items():
        if v == 'top':
            bad = [(x + dx, y + dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1) if K_(x + dx, y + dy) is not None and not level(x + dx, y + dy)]
            assert not bad, ('a plateau with no cliff between it and the ground', spec['gba'], (x, y), bad)
    tall = {q for q, v in kind.items() if v == 'tall'}
    # the ground first, then what stands on it: under a fence, a sign, a bush or a house the ground is the GBA's
    # (its metatile's bottom layer), so a path runs on under them and ends with its edge as it does elsewhere
    sand = {q for q, v in kind.items() if v == 'sand' or (v in OBJECTS and _sand_under(lay, lay.metatile(*q)))}
    water = {q for q, v in kind.items() if v == 'water'}
    # trees: HeartGold's, one to a 2x2 block of woods, the blocks never overlapping (HeartGold's trees stand two
    # squares apart; one to every block that fits stood them a square apart, a thicket)
    # (the edge of the woods first, so it is trees all along the open ground; a square the blocks leave over is
    # deep in the woods, or one of HeartGold's round bushes where it meets the open ground)
    full = lambda x, y: all(K_(x + a, y + b) == 'woods' for a in (0, 1) for b in (0, 1))
    walk = {q for q, v in kind.items() if v in ('grass', 'sand', 'tall', 'top', 'door', 'stairs', 'water')}
    dist, ring = {q: 0 for q in walk}, list(walk)
    while ring:
        nxt = []
        for (x, y) in ring:
            for n in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if n in kind and n not in dist: dist[n] = dist[(x, y)] + 1; nxt.append(n)
        ring = nxt
    blocks = sorted(((min(dist.get((x + a, y + b), 99) for a in (0, 1) for b in (0, 1)), y, x)
                     for (x, y) in kind if full(x, y)))
    trees, covered = [], set()
    for _, y, x in blocks:
        if not any((x + a, y + b) in covered for a in (0, 1) for b in (0, 1)):
            trees.append((x, y)); covered |= {(x + a, y + b) for a in (0, 1) for b in (0, 1)}
    loose = {q for q, v in kind.items() if v == 'woods' and q not in covered and dist.get(q, 99) <= 1}
    # warps: a way out at the foot of the trees (open north of it, closed south) is HeartGold's exit mat, any other
    # (the ways between the areas, the doors) a warp you step on
    shut = lambda x, y: K_(x, y) in (None, 'cliff', 'house', 'sign', 'fence', 'hedge', 'woods', 'boulder', 'blank')
    warp_beh = {}
    for w in gm.get('warp_events', []):
        x, y = w['x'], w['y']
        warp_beh[(x, y)] = 0x65 if shut(x, y + 1) and not shut(x, y - 1) and (x, y) not in doors else 0x3E
    nx, nz = math.ceil(W / 32), math.ceil(H / 32)
    lands = []
    up = (0, 1, 0)
    for lz in range(nz):
        for lx in range(nx):
            meshes = {}
            M = lambda t: meshes.setdefault(t, Mesh())
            ox, oz = lx * 32, lz * 32
            X0, X1, Z0, Z1 = ox, min(ox + 32, W), oz, min(oz + 32, H)
            mine = lambda x, y: X0 <= x < X1 and Z0 <= y < Z1
            U = lambda v, o: (v - o) * 16 - 256
            perm = [0x8000] * 1024
            props = []

            def poly(tex, pts):
                """a polygon of the land: pts [((x, y, z) map units from the map's corner, (s, t))]"""
                vs = [((x_ - ox * 16 - 256, y_, z_ - oz * 16 - 256), st) for (x_, y_, z_), st in pts]
                if len(vs) == 4: M(tex).quad(vs, up)
                elif len(vs) == 3: M(tex).tri(vs, up)
                else:
                    for i in range(1, len(vs) - 1): M(tex).tri([vs[0], vs[i], vs[i + 1]], up)

            def flat(tex, x0, z0, x1, z1, h, per=16):
                """a flat rectangle (squares), its texture laid across the map (per texels a square)"""
                poly(tex, [((x0 * 16, h, z1 * 16), (x0 * per, z1 * per)), ((x1 * 16, h, z1 * 16), (x1 * per, z1 * per)),
                           ((x1 * 16, h, z0 * 16), (x1 * per, z0 * per)), ((x0 * 16, h, z0 * 16), (x0 * per, z0 * per))])

            def piece(x, y, parts, base, ground):
                """a piece (route_kit: polygons of (u, v, h, s, t) in the square) laid in square (x, y)"""
                for tex, pts in parts:
                    if tex in ('ground', 'top'):
                        t_ = ground if tex == 'ground' else TOP
                        poly(t_, [((x * 16 + u, base + (h if tex == 'ground' else R.TIER), y * 16 + v), (x * 16 + u, y * 16 + v)) for u, v, h, s, t in pts])
                    else:
                        poly(tex, [((x * 16 + u, base + h, y * 16 + v), (s, t)) for u, v, h, s, t in pts])

            # ---- the ground, in runs along each row: grass under everything level with it, sand, the plateaus' tops
            for y in range(Z0, Z1):
                runs = []
                for x in range(X0, X1):
                    k = K_(x, y)
                    if k in ('water', 'cliff', 'stairs', 'gate'): tex = None
                    elif k == 'top': tex = (TOP, R.TIER)
                    elif (x, y) in sand: tex = (SAND, 0)
                    elif k in ON_GROUND and _sand_nb(sand, x, y): tex = None
                    else: tex = (GROUND, 0)
                    if runs and runs[-1][0] == tex and runs[-1][2] == x: runs[-1][2] = x + 1
                    else: runs.append([tex, x, x + 1])
                for tex, a, b in runs:
                    if tex: flat(tex[0], a, y, b, y + 1, tex[1])
                # tall grass a little above, in runs
                x = X0
                while x < X1:
                    if (x, y) not in tall: x += 1; continue
                    e = x
                    while e < X1 and (e, y) in tall: e += 1
                    flat('egrass', x, y, e, y + 1, R.GRASS_Y)
                    x = e
            # ---- squares one at a time
            bands_u, bands_v, pond_runs = {}, {}, {}
            for y in range(Z0, Z1):
                for x in range(X0, X1):
                    k = K_(x, y)
                    i = (y - oz) * 32 + (x - ox)
                    if k in ('grass', 'sand', 'tall', 'top'): perm[i] = 0x0002 if k == 'tall' else 0x0000
                    elif k == 'water': perm[i] = 0x0010
                    elif k == 'stairs': perm[i] = 0x0000
                    if (x, y) in warp_beh: perm[i] = warp_beh[(x, y)]
                    if k in ON_GROUND and (x, y) not in sand and _sand_nb(sand, x, y):
                        _sand_edge(poly, _sand_nb(sand, x, y), x, y)
                    elif k == 'water':
                        land = [(dx, dz) for dx in (-1, 0, 1) for dz in (-1, 0, 1) if (dx or dz) and (x + dx, y + dz) not in water]
                        kd = K.classify(land)
                        if land and kd[0] == 'straight':        # (land along one side: in runs, below)
                            n = kd[1]
                            pond_runs.setdefault((n, y if n[0] == 0 else x), set()).add(x if n[0] == 0 else y)
                        else: _pond(poly, flat, water, x, y)
                    elif k in ('cliff'):
                        lower = [(dx, dz) for dx in (-1, 0, 1) for dz in (-1, 0, 1) if (dx or dz) and K_(x + dx, y + dz) is not None and not level(x + dx, y + dz)]
                        if not lower:
                            flat(TOP, x, y, x + 1, y + 1, R.TIER)
                        else:
                            n0 = next((n for n in R.SIDE if n in lower), lower[0])
                            ground = SAND if (x + n0[0], y + n0[1]) in sand else GROUND
                            look = dict(R.LOOK, foot='wall01_h' if ground == SAND else 'wall01_g')
                            piece(x, y, R.rock_piece(lower, x, y, LAND_NARC, look), 0, ground)
                            # the face's end against stairs: its side, down to the ground
                            for sx_ in (-1, 1):
                                if K_(x + sx_, y) == 'stairs' and K.classify(lower)[0] == 'straight':
                                    _cap(poly, K.classify(lower)[1], x, y, sx_)
                    elif k == 'stairs':
                        _stairs(poly, K_, x, y)
                    if k not in ('tall', 'water', 'top', 'stairs') and mine(x, y):
                        for tex, u0, v0, (s0, t0) in R.grass_edges(tall, x, y):
                            if tex == 'egrass_u': bands_u.setdefault((y * 2 + v0 // 8, t0), set()).add(x * 2 + u0 // 8)
                            elif tex == 'egrass_v': bands_v.setdefault((x * 2 + u0 // 8, s0), set()).add(y * 2 + v0 // 8)
                            else:
                                xa, za = x * 16 + u0, y * 16 + v0
                                poly(tex, [((xa, R.GRASS_Y, za + 8), (s0, t0 + 8)), ((xa + 8, R.GRASS_Y, za + 8), (s0 + 8, t0 + 8)),
                                           ((xa + 8, R.GRASS_Y, za), (s0 + 8, t0)), ((xa, R.GRASS_Y, za), (s0, t0))])
                    if k == 'hedge' or (x, y) in loose: _card(poly, 'bush', x, y)
                    elif k == 'boulder':
                        if K_(x + 1, y) == 'boulder' and K_(x - 1, y) != 'boulder': _card(poly, 'rock', x, y)
                        elif K_(x - 1, y) != 'boulder': _card(poly, 'stone', x, y)
                    elif k == 'fence':
                        if K_(x - 1, y) == 'fence' or K_(x + 1, y) == 'fence': _card(poly, 'fence', x, y)
                        else: _card(poly, 'post', x, y)
                    elif k == 'sign':
                        props.append((SIGN_MODEL, U(x + 0.5, ox), 0, U(y + 0.35, oz)))
            # a pond's straight sides, in runs: the bank, the water's edge, the water
            for (n, line), along in pond_runs.items():
                for a, b in _runs(sorted(along)):
                    _pond_run(poly, n, line, a, b)
            # the tall grass's edge bands, merged along their rows and columns (half squares)
            for (zh, t0), xs in bands_u.items():
                for a, b in _runs(sorted(xs)):
                    xa, xb, za = a * 8, b * 8, zh * 8
                    poly('egrass_u', [((xa, R.GRASS_Y, za + 8), (xa, t0 + 8)), ((xb, R.GRASS_Y, za + 8), (xb, t0 + 8)),
                                      ((xb, R.GRASS_Y, za), (xb, t0)), ((xa, R.GRASS_Y, za), (xa, t0))])
            for (xh, s0), zs in bands_v.items():
                for a, b in _runs(sorted(zs)):
                    za, zb, xa = a * 8, b * 8, xh * 8
                    poly('egrass_v', [((xa, R.GRASS_Y, zb), (s0, zb)), ((xa + 8, R.GRASS_Y, zb), (s0 + 8, zb)),
                                      ((xa + 8, R.GRASS_Y, za), (s0 + 8, za)), ((xa, R.GRASS_Y, za), (s0, za))])
            # trees: HeartGold's card over each 2x2 block, its shadow on the ground
            for (bx, by) in trees:
                if not mine(bx, by): continue
                poly('tree01_un', [((bx * 16, 0, by * 16 + 32), (0, 32)), ((bx * 16 + 32, 0, by * 16 + 32), (32, 32)),
                                   ((bx * 16 + 32, 0, by * 16), (32, 0)), ((bx * 16, 0, by * 16), (0, 0))])
                _card(poly, 'tree', bx, by)
            for (hx, y, dx_) in houses:
                if not mine(dx_, y): continue
                props.append((HOUSE['model'], U(hx, ox), 0, U(y + HOUSE['at'][1], oz)))
                props.append((HOUSE['door'], U(hx + HOUSE['door_at'][0] - HOUSE['at'][0], ox), 0, U(y + HOUSE['door_at'][1], oz)))
            # ---- the model: the animated places first, then what lies level with the ground before it
            order = [t for t in FIRST if t in meshes] + [t for t in meshes if t not in FIRST and t not in ANIM]
            groups = [(t, t if t in meshes else 'pond_on', pal_of(t if t in meshes else 'pond_on'), meshes.get(t, Mesh()),
                       {'repeat': 3, 'size': dims[t if t in meshes else 'pond_on']}) for t in ANIM] + \
                     [(t, t, pal_of(t), meshes[t], {'repeat': 0 if t in ('tree01gs', 'etc_a', 'rock01', 'fence_b') else 3, 'size': dims[t]}) for t in order]
            model = build_model('cv_in_%d' % (len(lands) + 10 * (spec['depth'] + 20)), groups)
            model += b'\0' * (-len(model) % 4)
            f4 = lambda v: int(round(v * 4096))
            bld = b''.join(struct.pack('<I3i3i3i8x', m, f4(px), f4(py), f4(pz), 0, 0, 0, 4096, 4096, 4096) for m, px, py, pz in props)
            bdhc = _bdhc(K_, ox, oz, U)
            pm = struct.pack('<1024H', *perm)
            lands.append(struct.pack('<4I2H', len(pm), len(bld), len(model), len(bdhc), 0x1234, 0) + pm + bld + model + bdhc)
            assert len(model) < 61400, ('model too big for a land', spec['gba'], len(lands), len(model))
    return gm, (nx, nz), lands


def _runs(xs):
    out = []
    for x in xs:
        if out and out[-1][1] == x: out[-1][1] = x + 1
        else: out.append([x, x + 1])
    return out


OBJECTS = ('fence', 'sign', 'hedge', 'boulder', 'blank', 'woods', 'house', 'door')     # (things standing on the ground)
ON_GROUND = ('grass', 'tall') + OBJECTS
_under = {}


def _sand_under(lay, m):
    """is the ground under a GBA metatile's things sand (its bottom layer mostly sand)"""
    if m not in _under:
        px = [c for c in lay.render_metatile(m, layers=(0,)).convert('RGBA').getdata() if c[3]]
        _under[m] = bool(px) and sum(1 for c in px if c[0] > c[2] + 40 and c[0] >= c[1] - 10) >= len(px) / 2
    return _under[m]


def _sand_nb(sand, x, y):
    """the squares round a square that are sand"""
    return [(dx, dz) for dx in (-1, 0, 1) for dz in (-1, 0, 1) if (dx or dz) and (x + dx, y + dz) in sand]


SAND_PROFILE = [(0.0, 0.0, 15.6), (1.0, 0.0, 0.4)]       # (the edge's s across a square of grass from the sand)


def _sand_edge(poly, sand_nb, x, y):
    """the sand's edge, in a square of grass beside it (sand_nb: the squares round it that are sand): HeartGold's
    straight piece (road01_r's left half, grass at s=0) or its corners (the right half: its top quadrant grass in
    one corner - beside the sand's inside corner -, its bottom one sand in one corner - round its outside corner),
    or laid by distance from the sand"""
    kind, what = R.sand_piece(sand_nb, x, y)
    X, Z = x * 16, y * 16
    corners = ((0, 16), (16, 16), (16, 0), (0, 0))
    if kind == 'straight':
        gx, gz = what
        pts = []
        for u, v in corners:
            e = (u if gx < 0 else 16 - u) / 16 if gx else (v if gz < 0 else 16 - v) / 16      # (0 at the sand)
            pts.append(((X + u, 0, Z + v), (15.6 - 15.2 * e, (Z + v) if gx else (X + u))))
        poly('road01_r', pts)
    elif kind in ('outside', 'inside'):
        # (sand round two sides: the top quadrant, its grass corner away from them; sand only cornerwise: the
        # bottom quadrant, its sand corner towards it. Both drawn with the sand at the top left, turned about)
        gx, gz = what
        t_off = 0 if kind == 'outside' else 16
        pts = []
        for u, v in corners:
            uu, vv = (u if gx < 0 else 16 - u), (v if gz < 0 else 16 - v)
            pts.append(((X + u, 0, Z + v), (16.4 + uu * 15.2 / 16, t_off + 0.4 + vv * 15.2 / 16)))
        poly('road01_r', pts)
    else:
        for part, rng, f, pl in K.laid(sand_nb, SAND_PROFILE, top=True):
            if part == 'top':
                poly(GROUND, [((X + u * 16, 0, Z + v * 16), (X + u * 16, Z + v * 16)) for u, v in pl]); continue
            axis = part[0]
            poly('road01_r', [((X + u * 16, 0, Z + v * 16), (K.along_profile(SAND_PROFILE, f(u, v))[1], (Z + v * 16) if axis == 'x' else (X + u * 16))) for u, v in pl])


def _pond(poly, flat, water, x, y):
    """a square of the pond: HeartGold's bank from the land round it, the water's edge, the water"""
    land = [(dx, dz) for dx in (-1, 0, 1) for dz in (-1, 0, 1) if (dx or dz) and (x + dx, y + dz) not in water]
    X, Z = x * 16, y * 16
    if not land:
        flat('pond_on', x, y, x + 1, y + 1, R.WATER_Y); return
    along = lambda part, u, v: (Z + v * 16) if part[0] == 'x' else (X + u * 16)
    for part, rng, f, pl in K.laid(land, R.BANK):
        pts = []
        for u, v in pl:
            h, t = K.along_profile(R.BANK, f(u, v))
            pts.append(((X + u * 16, h, Z + v * 16), (along(part, u, v), t)))
        poly('pond_line', pts)
    for part, rng, f, pl in K.laid(land, R.EDGE, top=True):
        if part == 'top':
            poly('pond_on', [((X + u * 16, R.WATER_Y, Z + v * 16), (X + u * 16, Z + v * 16)) for u, v in pl]); continue
        poly('pond_edge', [((X + u * 16, R.WATER_Y, Z + v * 16), (along(part, u, v), K.along_profile(R.EDGE, f(u, v))[1])) for u, v in pl])


def _pond_run(poly, n, line, a, b):
    """a run of water squares a..b-1 along row (or column) `line` with land on side n: bands across it"""
    dx, dz = n

    def P(d, al, h):
        # a point d across from the land side, al along (in squares), at height h -> map units
        if dz: return (al * 16, h, line * 16 + (d * 16 if dz < 0 else 16 - d * 16))
        return (line * 16 + (d * 16 if dx < 0 else 16 - d * 16), h, al * 16)
    bands = [('pond_line', R.BANK), ('pond_edge', R.EDGE)]
    for tex, prof in bands:
        for (d0, h0, t0), (d1, h1, t1) in zip(prof, prof[1:]):
            poly(tex, [(P(d0, a, h0), (a * 16, t0)), (P(d0, b, h0), (b * 16, t0)), (P(d1, b, h1), (b * 16, t1)), (P(d1, a, h1), (a * 16, t1))])
    d0 = R.EDGE[-1][0]
    pts = [P(d0, a, R.WATER_Y), P(d0, b, R.WATER_Y), P(1, b, R.WATER_Y), P(1, a, R.WATER_Y)]
    poly('pond_on', [(q, (q[0], q[2])) for q in pts])


def _cap(poly, lower, x, y, side):
    """the side of a straight face where it stops against stairs (side -1 west, 1 east): the face's profile from
    its foot up and back, closed down to the ground"""
    X = x * 16 + (16 if side > 0 else 0)
    dx, dz = lower
    if dz == 0: return          # (stairs beside a face down a column: not in the Safari Zone)
    pts = []
    for d, h, t in R.PROFILE:
        z = y * 16 + ((1 - d) * 16 if dz > 0 else d * 16)
        pts.append(((X, h, z), (z, t)))
    zb = y * 16 + (0 if dz > 0 else 16)
    pts.append(((X, 0, zb), (zb, 15.6)))
    poly('wall01_g', pts)


def _stairs(poly, K_, x, y):
    """the GBA's stairs: HeartGold's striped ramp up a tier across the square, north the top; a low rail down each
    side of a flight (from the brown end of the ramp's texture), as Pallet's"""
    X, Z = x * 16, y * 16
    v = 24
    poly('slope', [((X, 0, Z + 16), (0, v)), ((X + 16, 0, Z + 16), (32, v)), ((X + 16, R.TIER, Z), (32, 0)), ((X, R.TIER, Z), (0, 0))])
    rail = [(2, 30), (10, 30), (10, 26), (2, 26)]
    for side in (-1, 1):
        if K_(x + side, y) == 'stairs': continue
        a = X + (-2.4 if side < 0 else 14.4)
        b = a + 4
        yb, yf, lb, lf = R.TIER + 6, 6, R.TIER - 2, -2
        poly('slope', [((a, yf, Z + 16), rail[0]), ((b, yf, Z + 16), rail[1]), ((b, yb, Z), rail[2]), ((a, yb, Z), rail[3])])
        poly('slope', [((a, lf, Z + 16), rail[0]), ((a, yf, Z + 16), rail[1]), ((a, yb, Z), rail[2]), ((a, lb, Z), rail[3])])
        poly('slope', [((b, lb, Z), rail[0]), ((b, yb, Z), rail[1]), ((b, yf, Z + 16), rail[2]), ((b, lf, Z + 16), rail[3])])
        poly('slope', [((a, lf, Z + 16), rail[0]), ((b, lf, Z + 16), rail[1]), ((b, yf, Z + 16), rail[2]), ((a, yf, Z + 16), rail[3])])


def _card(poly, what, x, y):
    """one of HeartGold's standing cards (route_kit.CARDS) at square (x, y) (a tree's: its 2x2 block's corner)"""
    tex, w, s0, s1, t0, t1, hf, zf, ht, zt = R.CARDS[what]
    if what == 'tree': cx = (x + 1) * 16
    elif what == 'rock': cx = (x + 1) * 16
    else: cx = (x + 0.5) * 16
    a, b = cx - w * 8, cx + w * 8
    poly(tex, [((a, hf, (y + zf) * 16), (s0, t1)), ((b, hf, (y + zf) * 16), (s1, t1)),
               ((b, ht, (y + zt) * 16), (s1, t0)), ((a, ht, (y + zt) * 16), (s0, t0))])


def _bdhc(K_, ox, oz, U, base=0):
    """the heights walked on: the ground, the plateaus a tier up, the stairs sloping up north; a plate a run"""
    fx = lambda v: int(round(v * 4096))
    pts, nrm, cst, plates, strips, access = [], [], [], [], [], []
    idx = lambda lst, v: lst.index(v) if v in lst else (lst.append(v) or len(lst) - 1)
    hkey = lambda x, y: ('step',) if K_(x, y) == 'stairs' else ('flat', R.TIER if K_(x, y) in ('top', 'cliff') else
                                                                   R.WATER_Y if K_(x, y) == 'water' else 0)
    for y in range(oz, oz + 32):
        row, x = [], ox
        while x < ox + 32:
            key, e = hkey(x, y), x + 1
            while e < ox + 32 and hkey(e, y) == key: e += 1
            z0, z1 = U(y, oz), U(y + 1, oz)
            if key[0] == 'flat': nv, dv = (0, 4096, 0), -fx(key[1] + base)
            else:
                yb, sl = R.TIER + base, -1.0
                ln = (1 + sl * sl) ** 0.5
                nv, dv = (0, fx(1 / ln), fx(-sl / ln)), fx(-(yb - sl * z0) / ln)
            plates.append((idx(pts, (fx(U(x, ox)), fx(z0))), idx(pts, (fx(U(e, ox)), fx(z1))), idx(nrm, nv), idx(cst, dv)))
            row.append(len(plates) - 1); x = e
        strips.append((fx(U(y + 1, oz)), len(row), len(access))); access += row
    return struct.pack('<4s6H', b'BDHC', len(pts), len(nrm), len(cst), len(plates), len(strips), len(access)) + \
        b''.join(struct.pack('<2i', *q) for q in pts) + b''.join(struct.pack('<3i', *q) for q in nrm) + b''.join(struct.pack('<i', q) for q in cst) + \
        b''.join(struct.pack('<4H', *q) for q in plates) + b''.join(struct.pack('<iHH', *q) for q in strips) + \
        b''.join(struct.pack('<H', q) for q in access)
