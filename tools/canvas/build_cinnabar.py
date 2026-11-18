"""Canvas: Cinnabar Island as the GBA game has it, in place of HeartGold's (the ruin after the eruption, with only
its Pokemon Center).

The GBA town (24x20), widened to 32x26 (INS_COLS, INS_ROWS: HeartGold's buildings are bigger than the GBA's,
and its island was cramped), is drawn into HeartGold's Cinnabar land (205, matrix cell 32,15) at its east and north
edges, where the GBA's Route 20 and Route 21 meet it; the rest of the land is sea. The ground is grass in the middle
with a beach two squares wide all round it (in the south the GBA's own sand and grass), HeartGold's road edge in
the beach's colours between them (cv_sand_r, made by build_pallet.py); the sea HeartGold's (behaviour 0x15, surf),
the GBA's rocks in the sea HeartGold's sea rocks. The buildings are HeartGold models on the GBA's doors: its Pokemon Center and Mart, its Gym,
and Oak's lab model for the Pokemon Lab and the Mansion. Where a building's model stands is blocked (its box, to its door's row), the GBA's signs are HeartGold's
sign; door squares are HeartGold doors.
The town's warps become the GBA's, in its order (Mansion, Gym, Lab, Center, Mart), and HeartGold's Center leads
back to its own door.

Run after build_interiors.py (Cinnabar's rooms) and build_pallet.py (the sand's edge), and before the porter
(port_map.py places the town's people by to_world).
"""
import json, math, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nitro import read_narc, write_narc
from g3d import Mesh, build_model
import gba_map, slots, landedit
import cave_kit as K
import build_safari as BS
from build_rooms import texdims

LAND_NARC = os.path.join(slots.ROOT, 'files/a/0/6/5')
LAND = 205                        # HeartGold's Cinnabar
NORTH, EAST = 204, 206            # Routes 21 and 20 beside it
CELL = (32, 15)
TEXSET = 18
ANIM_SLOTS = ['pond_on', 'swave_p', 'pond_edge', 'sea_line02', 'sea_un', 'sea_on', 'river', 'river_r']   # (see build_pallet.py)
GROUND, SEA, BED = 16, 7, 7          # HeartGold's own levels, as the routes round the island have them
SURF = 8                          # (where someone surfing is: HeartGold's sea has a second, clear layer there)
WATER_MB = {16, 17, 18, 19, 20, 21, 24, 26, 44, 45}
# by the GBA door they stand on: HeartGold model, its door model, door offset from the model (units), door centre x
BUILDINGS = {
    'MAP_POKEMON_MANSION_1F': (314, 311, (10.0, 2.64, 19.52), -10.0),
    'MAP_CINNABAR_ISLAND_GYM': (318, 16, (0, 0, 22.48), 0),
    'MAP_CINNABAR_ISLAND_POKEMON_LAB_ENTRANCE': (314, 311, (10.0, 2.64, 19.52), -10.0),
    'MAP_CINNABAR_ISLAND_POKEMON_CENTER_1F': (40, 15, (0, 0, 25.73), 0),
    'MAP_CINNABAR_ISLAND_MART': (39, 15, (-8.93, 0, 12.11), 0),
}
SIGN_MODEL = 29
BOX = {314: (-54.0, 62.0, -34.0, 36.0), 318: (-55.7, 61.8, -41.4, 34.4), 40: (-42.0, 48.0, -32.0, 37.0),
       39: (-34.0, 58.1, -29.0, 22.0)}     # (the models' boxes, from their files: x, z extents from where they stand)
ROOMS = {   # GBA room -> our map (HeartGold's Center for the Center)
    'MAP_POKEMON_MANSION_1F': 'MAP_CANVAS_POKEMON_MANSION_1F', 'MAP_CINNABAR_ISLAND_GYM': 'MAP_CANVAS_CINNABAR_GYM',
    'MAP_CINNABAR_ISLAND_POKEMON_LAB_ENTRANCE': 'MAP_CANVAS_CINNABAR_LAB', 'MAP_CINNABAR_ISLAND_MART': 'MAP_CANVAS_CINNABAR_MART',
    'MAP_CINNABAR_ISLAND_POKEMON_CENTER_1F': 'MAP_CINNABAR_ISLAND_POKECENTER_1F',
}
# the GBA's island is small for HeartGold's buildings (they stood wall to wall): it is widened. Columns put in
# before the GBA's columns 5 (the west shore), 12 (between the Lab and the Center), 17 (between the Center and
# the Mart, and the Gym and the grass) and 23 (the east shore); rows on top (a sea row and a beach behind the
# Mansion and the Gym) and before its row 6 (the way between the Mansion and Gym and the Lab, Center and Mart).
# What is put in copies a GBA column (row) beside it, its buildings and signs as open ground
# (HeartGold's buildings are wider than the GBA's: its Gym reaches past the GBA's east shore, its Lab into its
# Center.) One of the GBA's three columns of sea west of the island is left out, for room
INS_COLS = {5: (2, 5), 12: (2, 12), 17: (1, 17), 23: (4, 22)}     # before column: (how many, copying column)
DROP_COLS = {3}
TOP, INS_ROWS = 3, {6: 3}
nx = lambda x: x - sum(1 for d in DROP_COLS if d < x) + sum(n for c, (n, _) in INS_COLS.items() if c <= x)
ny = lambda y: y + TOP + sum(n for r, n in INS_ROWS.items() if r <= y)
NW, NH = nx(23) + 1, ny(19) + 1
OX, OZ = 32 - NW, 0               # (the town at the land's east and north edges, where Routes 20 and 21 meet it)
SOUTH = ny(12)                    # (from here south the GBA's own sand and grass: its beach running into the grass)


def to_world(x, y):
    """a GBA square of the town -> our world square"""
    return CELL[0] * 32 + OX + nx(x), CELL[1] * 32 + OZ + ny(y)


def main():
    gm = gba_map.map_json('CinnabarIsland_Frlg')
    lay = gba_map.Layout(gm['layout'])
    W, H = lay.w, lay.h
    dims, pals = texdims(TEXSET)
    pal_of = lambda t: {'sea_on': 'sea_f02_pl'}.get(t) or next(p for p in (t + '_pl', t, t.replace('gs', '')) if p in pals)
    doors = {(w['x'], w['y']): w for w in gm['warp_events']}

    def gba_at(x, y):
        """-> 'sea' | 'rock' | 'ground' | 'block' for a GBA square"""
        if not (0 <= x < W and 0 <= y < H): return 'sea'
        mb = lay.behavior(lay.metatile(x, y))
        if mb in WATER_MB: return 'rock' if lay.collision(x, y) and x < W - 1 else 'sea'   # (the two off its east shore
        # kept the GBA's ferry's berth clear; we have no ferry, and its shore is further out)
        if lay.collision(x, y) and (x, y) not in doors:
            # (the GBA's rocks out in the sea: blocked squares with sea round them)
            if all(lay.behavior(lay.metatile(x + dx, y + dy)) in WATER_MB for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))
                   if 0 <= x + dx < W and 0 <= y + dy < H):
                return 'rock'
            return 'block'
        return 'ground'

    # the widened town: each of its squares from the GBA's (put in: a copy, open)
    src_x = {nx(x): x for x in range(W) if x not in DROP_COLS}
    put_x = {nx(c) - n + i: cp for c, (n, cp) in INS_COLS.items() for i in range(n)}
    src_y = {ny(y): y for y in range(H)}
    grid, src = {}, {}
    for Y in range(NH):
        y = next(v for k, v in sorted(src_y.items(), reverse=True) if k <= Y) if Y >= TOP else 0
        for X in range(NW):
            x = src_x[X] if X in src_x else put_x[X]
            k = gba_at(x, y)
            if y == 0 and k == 'sea' and 5 <= x <= 22: k = 'ground'      # (the GBA's sea at its top edge, in the island)
            put = X not in src_x or (Y not in src_y)
            if Y < TOP:
                island = any(gba_at(x, yy) in ('ground', 'block') for yy in range(4))
                k = k if not island else ('sea' if Y == 0 else 'ground')
            elif put and k == 'block':
                k = 'ground'
            elif put and k == 'rock' and x > 4:
                k = 'sea'           # (the GBA's rocks east of the island stay as many as it has; its western chain runs on)
            grid[(X + OX, Y + OZ)] = k
            src[(X + OX, Y + OZ)] = (x, y)
    # (sea the widening shut in, away from the open sea: ground)
    seen, todo = set(), [(lx, lz) for lx in range(32) for lz in range(32) if (lx in (0, 31) or lz in (0, 31)) and grid.get((lx, lz), 'sea') == 'sea']
    while todo:
        q = todo.pop()
        if q in seen: continue
        seen.add(q)
        for dx, dz in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            n = (q[0] + dx, q[1] + dz)
            if 0 <= n[0] < 32 and 0 <= n[1] < 32 and grid.get(n, 'sea') in ('sea', 'rock') and n not in seen: todo.append(n)
    for q, k in grid.items():
        if k == 'sea' and q not in seen: grid[q] = 'ground'

    def at(lx, lz):
        """-> 'sea' | 'rock' | 'ground' | 'block' for a square of the land"""
        return grid.get((lx, lz), 'sea')

    U = lambda v: v * 16 - 256
    # buildings on the GBA's doors; door squares are HeartGold doors (blocked, behaviour 0x69: walk into them)
    # (where a building stands - its model's box - is blocked, and nothing else of the GBA's buildings: they were
    # the GBA's, and HeartGold's are other shapes)
    props, stands, door_sq = [], set(), set()
    f = lambda v: int(round(v * 4096))
    for (x, y), w in doors.items():
        if w['dest_map'] not in BUILDINGS: continue
        model, door, off, cx = BUILDINGS[w['dest_map']]
        lx, lz = nx(x) + OX, ny(y) + OZ
        ox, oz = (lx + 0.5) * 16 - off[0] - cx, (lz + 1) * 16 - off[2]
        props.append(struct.pack('<I3i3i3i8x', model, f(ox - 256), f(GROUND), f(oz - 256), 0, 0, 0, 4096, 4096, 4096))
        x0, x1, z0, z1 = BOX[model]
        # (squares it covers more than a third of, none past its door's row)
        stands |= {(qx, qz) for qx in range(math.floor((ox + x0) / 16 + 0.35), math.ceil((ox + x1) / 16 - 0.35))
                   for qz in range(math.floor((oz + z0) / 16 + 0.35), lz + 1)}
        door_sq.add((lx, lz))
        props.append(struct.pack('<I3i3i3i8x', door, f(ox + off[0] - 256), f(GROUND + off[1]), f(oz + off[2] - 256), 0, 0, 0, 4096, 4096, 4096))
    # the GBA's signs: HeartGold's sign (where no building stands)
    signs = set()
    for e in gm['bg_events']:
        q = (nx(e['x']) + OX, ny(e['y']) + OZ)
        signs.add(q)
        if q not in stands:
            props.append(struct.pack('<I3i3i3i8x', SIGN_MODEL, f(U(q[0] + 0.5)), f(GROUND), f(U(q[1] + 0.35)), 0, 0, 0, 4096, 4096, 4096))
    for q, k in grid.items():
        if k == 'block' and q not in stands and q not in signs: grid[q] = 'ground'
        elif k == 'ground' and q in stands: grid[q] = 'block'
    land = lambda lx, lz: 0 <= lx < 32 and 0 <= lz < 32 and at(lx, lz) in ('ground', 'block')
    # the ground: grass in the middle, a beach all round it (two squares of sand from the sea); in the south the
    # GBA's own, its beach running into the grass
    near_sea = lambda lx, lz: any(not land(lx + dx, lz + dz) for dx in range(-2, 3) for dz in range(-2, 3))

    def gba_grass(x, y):
        r, g, b = lay.render_metatile(lay.metatile(x, y)).convert('RGB').resize((1, 1)).getpixel((0, 0))
        return g > r + 10 and g > b

    sand = set()
    for (lx, lz), k in grid.items():
        if k not in ('ground', 'block'): continue
        grass = not near_sea(lx, lz) and (lz - OZ < SOUTH or gba_grass(*src[(lx, lz)]))
        if not grass: sand.add((lx, lz))
    ground_tex = lambda lx, lz: 'beach01' if (lx, lz) in sand else 'grass01gs'
    if os.environ.get('CN_DUMP'):
        dd = door_sq
        for lz in range(32):
            print('%2d ' % lz + ''.join('D' if (lx, lz) in dd else {'sea': '~', 'rock': 'r'}.get(at(lx, lz)) or
                                        ('#X' if at(lx, lz) == 'block' else '.,')[(lx, lz) not in sand] for lx in range(32)))
        return
    sand_nb = lambda lx, lz: [] if (lx, lz) in sand or not land(lx, lz) else BS._sand_nb(sand, lx, lz)

    meshes = {t: Mesh() for t in ANIM_SLOTS}
    M = lambda t: meshes.setdefault(t, Mesh())
    U = lambda v: v * 16 - 256
    up = (0, 1, 0)

    def _poly(tex, vs):
        if len(vs) == 4: M(tex).quad(vs, up)
        else:
            for i in range(1, len(vs) - 1): M(tex).tri([vs[0], vs[i], vs[i + 1]], up)
    perm = [0x8000] * 1024
    rows = {}
    for lz in range(32):
        for lx in range(32):
            k = at(lx, lz)
            i = lz * 32 + lx
            if k in ('sea', 'rock'):
                perm[i] = 0x0015 if k == 'sea' else 0x8000; tex, h = 'sea_un', SEA
                rows.setdefault(('sea_on', SURF, lz), []).append(lx)       # (HeartGold's clear layer over it)
            else:
                perm[i] = 0x8069 if (lx, lz) in door_sq else 0x0000 if k == 'ground' else 0x8000; tex, h = ground_tex(lx, lz), GROUND
                if sand_nb(lx, lz):
                    # (grass beside the sand: HeartGold's edge between them, road01_r in the sand's colours)
                    BS._sand_edge(lambda t, pts: _poly('cv_sand_r' if t == 'road01_r' else 'grass01gs',
                                                       [((U(X / 16), GROUND, U(Z / 16)), st) for (X, _, Z), st in pts]),
                                  sand_nb(lx, lz), lx, lz)
                    continue
            rows.setdefault((tex, h, lz), []).append(lx)
    for (tex, h, lz), xs in rows.items():
        xs.sort()
        tw, th = dims[tex]
        runs, start = [], xs[0]
        for a, b in zip(xs, xs[1:] + [None]):
            if b != a + 1:
                runs.append((start, a + 1)); start = b
        for x0, x1 in runs:
            M(tex).quad([((U(x0), h, U(lz + 1)), (x0 * 16, (lz + 1) * 16)), ((U(x1), h, U(lz + 1)), (x1 * 16, (lz + 1) * 16)),
                         ((U(x1), h, U(lz)), (x1 * 16, lz * 16)), ((U(x0), h, U(lz)), (x0 * 16, lz * 16))], up)
    # (a sheet of sea just under it all, out past the land's edges: where the corners of our squares fall along the
    # edge of a neighbour's bigger ones, or of each other's runs, single pixels would show through)
    e = 264
    M('sea_un').quad([((-e, SEA - 0.25, e), (-e + 256, e + 256)), ((e, SEA - 0.25, e), (e + 256, e + 256)),
                      ((e, SEA - 0.25, -e), (e + 256, -e + 256)), ((-e, SEA - 0.25, -e), (-e + 256, -e + 256))], up)
    # rocks in the sea: HeartGold's (its Route 21's): its big rock standing over a 2x2 block of rock squares, the
    # blocks never overlapping (HeartGold's stand two squares apart), its small one on a square left over
    rocky = {(lx, lz) for lz in range(32) for lx in range(32) if at(lx, lz) == 'rock'}
    big, covered = [], set()
    for lz in range(32):
        for lx in range(32):
            blk = {(lx + a_, lz + b_) for a_ in (0, 1) for b_ in (0, 1)}
            if blk <= rocky and not blk & covered: big.append((lx, lz)); covered |= blk
    for lx, lz in big:
        x0, x1, zf, zb = U(lx), U(lx + 2), U(lz + 1.71), U(lz + 0.29)
        M('sea_rock').quad([((x0, SEA + 1.7, zf), (0, 32)), ((x1, SEA + 1.7, zf), (32, 32)), ((x1, SEA + 24.3, zb), (32, 0)), ((x0, SEA + 24.3, zb), (0, 0))], up)
    for lx, lz in sorted(rocky - covered):
        x0, x1, zf, zb = U(lx), U(lx + 1), U(lz + 0.85), U(lz + 0.30)
        M('sea_rock_m').quad([((x0, SEA + 3.3, zf), (0, 16)), ((x1, SEA + 3.3, zf), (16, 16)), ((x1, SEA + 16.8, zb), (16, 0)), ((x0, SEA + 16.8, zb), (0, 0))], up)
    # the shore: HeartGold's beach (its Route 21's): the sand slopes from the ground's edge down under the sea across
    # the whole of the sea's square beside it (swave_un), its foam a unit over it (swave_p, which the area's animation
    # washes up and down); laid by distance from the land, straight sides in runs
    SLOPES = (('swave_un', [(0.0, GROUND, -15.6), (1.0, SEA, -0.4)]), ('swave_p', [(0.0, GROUND + 1, -31.6), (1.0, SURF, -14.4)]))
    runs_ = {}
    for lz in range(32):
        for lx in range(32):
            if land(lx, lz): continue
            nb = [(dx, dz) for dx in (-1, 0, 1) for dz in (-1, 0, 1) if (dx or dz) and land(lx + dx, lz + dz)]
            if not nb: continue
            kd = K.classify(nb)
            if kd[0] == 'straight':
                n = kd[1]
                runs_.setdefault((n, lz if n[0] == 0 else lx), set()).add(lx if n[0] == 0 else lz)
                continue
            for tex, prof in SLOPES:
                for part, rng, fd, pl in K.laid(nb, prof):
                    along = lambda u, v: ((lz + v) * 16) if part[0] == 'x' else ((lx + u) * 16)
                    vs = [((U(lx + u), K.along_profile(prof, fd(u, v))[0], U(lz + v)), (along(u, v), K.along_profile(prof, fd(u, v))[1])) for u, v in pl]
                    (M(tex).quad if len(vs) == 4 else M(tex).tri)(vs, up) if len(vs) in (3, 4) else \
                        [M(tex).tri([vs[0], vs[i], vs[i + 1]], up) for i in range(1, len(vs) - 1)]
    for (n, line), al in runs_.items():
        dx, dz = n
        for a_, b_ in BS._runs(sorted(al)):
            def P(d, at_, h):
                if dz: return (U(at_), h, U(line + (d if dz < 0 else 1 - d)))
                return (U(line + (d if dx < 0 else 1 - d)), h, U(at_))
            for tex, prof in SLOPES:
                (d0, h0, t0), (d1, h1, t1) = prof
                M(tex).quad([(P(d0, a_, h0), (a_ * 16, t0)), (P(d0, b_, h0), (b_ * 16, t0)), (P(d1, b_, h1), (b_ * 16, t1)), (P(d1, a_, h1), (a_ * 16, t1))], up)
    # (HeartGold animates this area's first eight materials by index: they hold their places, sea_un's is the sea)
    own = ('sea_un', 'sea_on', 'swave_p')
    groups = [(t, t if t in own else 'sea_un', pal_of(t if t in own else 'sea_un'), meshes[t] if t in own else Mesh(),
               {'repeat': 3, 'flip': 0, 'size': dims[t if t in own else 'sea_un']}) for t in ANIM_SLOTS] + \
             [(t, t, pal_of(t), m, {'repeat': 0 if t in ('sea_rock', 'sea_rock_m') else 3, 'size': dims[t]}) for t, m in meshes.items() if t not in ANIM_SLOTS]
    model = build_model('cv_cinnabar', groups)
    model += b'\0' * (-len(model) % 4)
    assert len(model) < 60000, len(model)
    bld = b''.join(props)
    # heights: the ground's and the sea's, a plate for every run of a row
    fx = lambda v: int(round(v * 4096))
    pts, cst, plates, strips, access = [], [], [], [], []
    idx = lambda lst, v: lst.index(v) if v in lst else (lst.append(v) or len(lst) - 1)
    for lz in range(32):
        row, lx = [], 0
        while lx < 32:
            hh = GROUND if land(lx, lz) else SURF
            end = lx + 1
            while end < 32 and (GROUND if land(end, lz) else SURF) == hh: end += 1
            plates.append((idx(pts, (fx(U(lx)), fx(U(lz)))), idx(pts, (fx(U(end)), fx(U(lz + 1)))), 0, idx(cst, -fx(hh))))
            row.append(len(plates) - 1); lx = end
        strips.append((fx(U(lz + 1)), len(row), len(access))); access += row
    bdhc = struct.pack('<4s6H', b'BDHC', len(pts), 1, len(cst), len(plates), len(strips), len(access)) + \
        b''.join(struct.pack('<2i', *q) for q in pts) + struct.pack('<3i', 0, 4096, 0) + b''.join(struct.pack('<i', c) for c in cst) + \
        b''.join(struct.pack('<4H', *q) for q in plates) + b''.join(struct.pack('<iHH', *q) for q in strips) + \
        b''.join(struct.pack('<H', q) for q in access)
    p = struct.pack('<1024H', *perm)
    land, btnf = read_narc(open(LAND_NARC, 'rb').read())
    # HeartGold's routes to the north and east still draw the foam along the shore its own Cinnabar had at their edge
    foam = lambda edge: lambda tex, vs: tex in ('pond_line', 'sea_line02') and all(edge(v) for v in vs)
    for lid, edge in ((NORTH, lambda v: v[2] >= 246), (EAST, lambda v: v[0] <= -239)):
        land[lid], n = landedit.strip(land[lid], foam(edge))
        if n: print('Cinnabar: %d faces of the old shore out of land %d' % (n, lid))
    land[LAND] = struct.pack('<4I2H', len(p), len(bld), len(model), len(bdhc), 0x1234, 0) + p + bld + model + bdhc
    open(LAND_NARC, 'wb').write(write_narc(land, btnf))
    # the town's warps: the GBA's, in its order
    path = os.path.join(slots.EVENT_DIR, slots.events_file('MAP_CINNABAR_ISLAND'))
    ev = json.load(open(path))
    ev['warps'] = []
    for w in gm['warp_events']:
        to = ROOMS[w['dest_map']]
        anchor = 0 if to == 'MAP_CINNABAR_ISLAND_POKECENTER_1F' else int(w['dest_warp_id'])
        wx, wz = to_world(w['x'], w['y'])
        ev['warps'].append({'x': wx, 'z': wz, 'header': to, 'anchor': anchor, 'y': 0})
    json.dump(ev, open(path, 'w'), indent=4); open(path, 'a').write('\n')
    # HeartGold's Center leads back to its door
    pc = next(i for i, w in enumerate(gm['warp_events']) if w['dest_map'] == 'MAP_CINNABAR_ISLAND_POKEMON_CENTER_1F')
    path = os.path.join(slots.EVENT_DIR, slots.events_file('MAP_CINNABAR_ISLAND_POKECENTER_1F'))
    ev = json.load(open(path))
    for w in ev['warps']:
        if w['header'] == 'MAP_CINNABAR_ISLAND': w['anchor'] = pc
    json.dump(ev, open(path, 'w'), indent=4); open(path, 'a').write('\n')
    print('Cinnabar: land %d, %d props, model %d bytes' % (LAND, len(props), len(model)))


if __name__ == '__main__':
    main()
