"""Canvas: build the GBA game's caves (Mt. Moon's three floors) as HeartGold caves.

HeartGold's Mt. Moon is one small floor; the GBA game's is three, with its trainers, the Rockets and the fossils.
Each floor is modelled from its GBA layout in HeartGold's cave look (the textures of HeartGold's Mt. Moon,
texture set 70), the way HeartGold builds its own caves (read off its Mt. Moon with bmdview.py):
  - the floor is `droad01` (a 32-texel texture over two blocks);
  - rock rises from the floor in tiers a block high, one per ring of blocked squares, up to two: faces of
    `dwall_n/e/s/w` (named for the side of the floor they stand on: dwall_n is the wall north of you, facing
    south), tier tops of `dcliff01`, and the dark `d_ro` above the second tier, as in HeartGold;
  - ladders are HeartGold's own models (69 up, 70 down, from its cave building set) on squares that take you
    up (0x3C) or down (0x3E); a way out is a cave mouth: 0x6E north (into the wall), 0x6F south, 0x6C/0x6D
    east/west, as HeartGold's caves have them; the floor carries HeartGold's cave-floor behaviour (0x08:
    wild Pokemon) and flags (0x0A00).
Floors bigger than a land (32x32) span a matrix of lands. Each floor is a map of our own (MAP_CANVAS_*), with
the header of HeartGold's Mt. Moon (its wild Pokemon, camera, music) and its own events from the GBA map.
HeartGold's own Mt. Moon (and Mt. Moon Square) stays as it was; the doors on Route 3 and Route 4 that led into
it lead into ours (see EXITS / DOORS).

Run after build_rooms.py (our lands follow the rooms'), and before the porter.
"""
import json, math, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from nitro import read_narc, write_narc
from g3d import Mesh, build_model
import gba_map
import slots
from slots import SLOTS, new_map, NO_SCRIPTS, header, set_header, new_events_file, events_file, gba_warps
from build_rooms import texdims

ROOT = slots.ROOT
LAND_NARC = os.path.join(ROOT, 'files/a/0/6/5')
CAVE_LAND_BASE = 720            # our cave lands (rooms are 690 on)
TEXSET = 70                     # HeartGold's Mt. Moon textures (area 70)
LADDER_UP, LADDER_DOWN = 69, 70
FLOOR = 0x0A08                  # walkable cave floor (behaviour 0x08), as HeartGold's Mt. Moon
TIER = 16                       # a tier of rock: a block high
# HeartGold's wall profile (read off its Mt. Moon): per tier, (how far back in blocks, height, texture row)
PROFILE = [[(0, 0, 15.75), (0.21, 1.6, 13), (0.67, 16, 4), (1.0, 16, 0.25)],
           [(1.0, 16, 15.75), (1.21, 17.6, 13), (1.67, 32, 4), (2.0, 32, 0.25)]]
WALL_TEX = {(0, -1): 'dwall_n', (0, 1): 'dwall_s', (1, 0): 'dwall_e', (-1, 0): 'dwall_w'}   # by where the rock is

CAVES = [   # GBA map, our map, how deep (ladders go up or down by it), the GBA's ways out -> (HeartGold map, warp)
    dict(gba='MtMoon_1F_Frlg', map='MAP_CANVAS_MT_MOON_1F', depth=0, exits={'MAP_ROUTE4': ('MAP_ROUTE_3', 0)}),
    dict(gba='MtMoon_B1F_Frlg', map='MAP_CANVAS_MT_MOON_B1F', depth=1, exits={'MAP_ROUTE4': ('MAP_ROUTE_4', 0)}),
    dict(gba='MtMoon_B2F_Frlg', map='MAP_CANVAS_MT_MOON_B2F', depth=2, exits={}),
]
TEMPLATE = 'MAP_MOUNT_MOON'
GBA_IDS = {'MtMoon_1F_Frlg': 'MAP_MT_MOON_1F', 'MtMoon_B1F_Frlg': 'MAP_MT_MOON_B1F', 'MtMoon_B2F_Frlg': 'MAP_MT_MOON_B2F'}
# HeartGold's doors into its Mt. Moon -> ours: (map, its warp index) -> (our map, GBA warp index there)
DOORS = {('MAP_ROUTE_3', 0): ('MAP_CANVAS_MT_MOON_1F', 3), ('MAP_ROUTE_4', 0): ('MAP_CANVAS_MT_MOON_B1F', 7)}


def floor_plan(gm, lay):
    W, H = lay.w, lay.h
    blocked = [[lay.collision(x, y) != 0 for x in range(W)] for y in range(H)]
    for w in gm.get('warp_events', []):            # (a ladder or a mouth is walkable)
        blocked[w['y']][w['x']] = False
    # tiers: how far each blocked square is from the floor (rings), up to two
    INF = 99
    dist = [[0 if not blocked[y][x] else INF for x in range(W)] for y in range(H)]
    for _ in range(3):
        for y in range(H):
            for x in range(W):
                if dist[y][x] == INF:
                    n = [dist[y + dy][x + dx] for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (1, -1), (-1, 1), (-1, -1))
                         if 0 <= x + dx < W and 0 <= y + dy < H]
                    if n and min(n) < INF: dist[y][x] = min(n) + 1
    tier = [[min(d, 3) for d in row] for row in dist]        # 0 floor, 1, 2, 3 (dark)
    return blocked, tier


def build_floor(spec, depth_of):
    gm = gba_map.map_json(spec['gba'])
    lay = gba_map.Layout(gm['layout'])
    W, H = lay.w, lay.h
    blocked, tier = floor_plan(gm, lay)
    nx, nz = math.ceil(W / 32), math.ceil(H / 32)
    dims, pals = texdims(TEXSET)
    pal_of = lambda t: next(p for p in (t + '_pl', t) if p in pals)
    # (rock stands two tiers tall wherever it is, its top in the dark, as HeartGold's caves are seen from above;
    # tier steps would make the GBA's thin rock walls into wide ledges)
    h_of = lambda x, y: 0 if 0 <= x < W and 0 <= y < H and not blocked[y][x] else 2 * TIER
    # ladders and mouths
    ladders, mouths = {}, {}
    for w in gm.get('warp_events', []):
        x, y = w['x'], w['y']
        dest = w['dest_map']
        if dest in depth_of:
            ladders[(x, y)] = LADDER_DOWN if depth_of[dest] > spec['depth'] else LADDER_UP
        else:
            b = lambda dx, dy: not (0 <= x + dx < W and 0 <= y + dy < H) or blocked[y + dy][x + dx]
            mouths[(x, y)] = 0x6E if b(0, -1) else 0x6F if b(0, 1) else 0x6C if b(1, 0) else 0x6D
    # every edge between a floor square and rock: (floor square, direction into the rock, how far it may lean)
    rock = lambda x, y: not (0 <= x < W and 0 <= y < H) or blocked[y][x]
    faces, corner_dir, vert_s = [], {}, {}
    for y in range(H):
        for x in range(W):
            if blocked[y][x]: continue
            for n in ((0, -1), (0, 1), (-1, 0), (1, 0)):
                if not rock(x + n[0], y + n[1]): continue
                k = 0                     # how thick the rock is there (it may lean at most halfway through)
                while k < 4 and rock(x + n[0] * (k + 1), y + n[1] * (k + 1)) and (0 <= x + n[0] * (k + 1) < W and 0 <= y + n[1] * (k + 1) < H):
                    k += 1
                thick = k if k < 4 and not rock(x + n[0] * (k + 1), y + n[1] * (k + 1)) else 99
                sc = min(1.0, thick / 2 / 2.0)
                faces.append(((x, y), n, sc))
                t = (1, 0) if n[0] == 0 else (0, 1)
                ex = x + (1 if n[0] > 0 else 0); ey = y + (1 if n[1] > 0 else 0)
                for j, sgn in ((0, -1), (1, 1)):          # each end: which way the rock goes on from there
                    side = (x + sgn * t[0], y + sgn * t[1]); diag = (side[0] + n[0], side[1] + n[1])
                    if rock(*side): n2 = (sgn * t[0], sgn * t[1])            # (an inside corner)
                    elif rock(*diag): n2 = None                              # (straight on)
                    else: n2 = (-sgn * t[0], -sgn * t[1])                    # (an outside corner)
                    corner_dir[((x, y), n, j)] = n if n2 is None else (n[0] + n2[0], n[1] + n2[1])
                    e = (ex + t[0] * j, ey + t[1] * j)
                    vert_s[e] = min(vert_s.get(e, 1.0), sc)
    # faces in a straight line join into one strip (fewer polygons: a land's model must stay small)
    fdict = {(f, n): sc for f, n, sc in faces}
    runs = []
    for (f, n), sc in sorted(fdict.items(), key=lambda kv: (kv[0][1], kv[0][0][1], kv[0][0][0]) if kv[0][1][0] == 0 else (kv[0][1], kv[0][0][0], kv[0][0][1])):
        t = (1, 0) if n[0] == 0 else (0, 1)
        prev = ((f[0] - t[0], f[1] - t[1]), n)
        e0 = (f[0] + (1 if n[0] > 0 else 0), f[1] + (1 if n[1] > 0 else 0))
        joint_ok = runs and runs[-1]['key'] == prev and corner_dir[(f, n, 0)] == n and runs[-1]['dir1'] == n \
            and (f[0] % 32 if n[0] == 0 else f[1] % 32) != 0 and runs[-1]['sc'] == sc and vert_s[e0] >= sc
        if joint_ok:
            r = runs[-1]
        else:
            r = dict(n=n, f=f, sc=sc, end0=e0, dir0=corner_dir[(f, n, 0)], s0=min(sc, vert_s[e0])); runs.append(r)
        e1 = (e0[0] + t[0], e0[1] + t[1])
        r.update(key=(f, n), end1=e1, dir1=corner_dir[(f, n, 1)], s1=min(sc, vert_s[e1]))
    lands = []
    for lz in range(nz):
        for lx in range(nx):
            meshes = {}
            M = lambda t: meshes.setdefault(t, Mesh())
            ox, oz = lx * 32, lz * 32
            U = lambda v, o: (v - o) * 16 - 256
            up = (0, 1, 0)
            perm = [0x8000] * 1024
            props = []
            for y in range(oz, oz + 32):
                for x in range(ox, ox + 32):
                    i = (y - oz) * 32 + (x - ox)
                    inside = x < W and y < H
                    h = h_of(x, y)
                    x0, x1, z0, z1 = U(x, ox), U(x + 1, ox), U(y, oz), U(y + 1, oz)
                    if inside and not blocked[y][x]:
                        perm[i] = FLOOR
                    # (the top of the square: drawn in runs along the row, below)
                    if (x, y) in ladders:
                        m = ladders[(x, y)]
                        perm[i] = 0x0A3C if m == LADDER_UP else 0x0A3E
                        props.append((m, U(x + 0.5, ox), 0, U(y + 0.5, oz)))
                    if (x, y) in mouths:
                        b = mouths[(x, y)]
                        perm[i] = 0x0A00 | b
                        if b == 0x6F and y + 1 < oz + 32: perm[i + 32] = 0x8065
                        if b == 0x6E:     # the mouth: a dark opening in the wall above
                            M('d_ro').quad([((x0 + 2, 0, z0 - 0.5), (0, 8)), ((x1 - 2, 0, z0 - 0.5), (8, 8)),
                                            ((x1 - 2, 28, z0 - 0.5), (8, 0)), ((x0 + 2, 28, z0 - 0.5), (0, 0))], (0, 0, 1))
            # rock faces: HeartGold's profile (each tier rises a block while leaning back two thirds of a block,
            # then a lip back to a whole block), joined at corners along the diagonal
            for r in runs:
                (fx, fy), (nx_, ny_) = r['f'], r['n']
                if not (ox <= fx < ox + 32 and oz <= fy < oz + 32): continue
                name = WALL_TEX[(nx_, ny_)]
                nrm = (-nx_ * 0.6, 0.8, -ny_ * 0.6)
                t = (1, 0) if nx_ == 0 else (0, 1)
                e0, e1, n = r['end0'], r['end1'], (nx_, ny_)
                # (an end that leans less than the run - beside thinner rock - changes over its last block only)
                pts = [(e0, r['dir0'], r['s0'])]
                if r['s0'] != r['sc'] and e0 != (e1[0] - t[0], e1[1] - t[1]): pts.append(((e0[0] + t[0], e0[1] + t[1]), n, r['sc']))
                if r['s1'] != r['sc'] and (e1[0] - t[0], e1[1] - t[1]) != pts[-1][0]: pts.append(((e1[0] - t[0], e1[1] - t[1]), n, r['sc']))
                pts.append((e1, r['dir1'], r['s1']))
                for (ea, da, sa), (eb, db, sb) in zip(pts, pts[1:]):
                    ends, dirs, ss = [ea, eb], [da, db], [sa, sb]
                    u = [(e[0] if nx_ == 0 else e[1]) * 16 for e in ends]
                    for strip in PROFILE:
                        for (d0, h0, v0), (d1, h1, v1) in zip(strip, strip[1:]):
                            P = lambda k, d, h: (U(ends[k][0] + dirs[k][0] * d * ss[k], ox), h, U(ends[k][1] + dirs[k][1] * d * ss[k], oz))
                            M(name).quad([(P(0, d0, h0), (u[0], v0)), (P(1, d0, h0), (u[1], v0)),
                                          (P(1, d1, h1), (u[1], v1)), (P(0, d1, h1), (u[0], v1))], nrm)
            # tops in runs: floor (droad01), tier tops in the light (dcliff01); the dark beyond is left undrawn
            # (a cave's background is black)
            def top_of(x, y):
                if (x, y) in ladders and ladders[(x, y)] == LADDER_DOWN: return None      # (the ladder's hole)
                h = h_of(x, y)
                if h == 0: return ('droad01', 0)
                inside = x < W and y < H
                lit = h < 2 * TIER or any(h_of(x + dx, y + dy) < h for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))
                return None
            for y in range(oz, oz + 32):
                x = ox
                while x < ox + 32:
                    k = top_of(x, y)
                    e = x + 1
                    while e < ox + 32 and top_of(e, y) == k: e += 1
                    if k:
                        t, h = k
                        x0, x1, z0, z1 = U(x, ox), U(e, ox), U(y, oz), U(y + 1, oz)
                        M(t).quad([((x0, h, z1), (x * 16, (y + 1) * 16)), ((x1, h, z1), (e * 16, (y + 1) * 16)),
                                   ((x1, h, z0), (e * 16, y * 16)), ((x0, h, z0), (x * 16, y * 16))], up)
                    x = e
            groups = [(t, t, pal_of(t), mesh, {'repeat': 3, 'size': dims[t]}) for t, mesh in meshes.items()]
            model = build_model('cv_cave_%d' % (spec['depth'] * 10 + len(lands)), groups)     # (names: 16 at most)
            model += b'\0' * (-len(model) % 4)
            bld = b''.join(struct.pack('<I3i3i3i8x', m, int(px * 4096), int(py * 4096), int(pz * 4096), 0, 0, 0, 4096, 4096, 4096)
                           for m, px, py, pz in props)
            bdhc = struct.pack('<4s6H', b'BDHC', 2, 1, 1, 1, 1, 1) + struct.pack('<2i2i', -256 * 4096, -256 * 4096, 256 * 4096, 256 * 4096) + \
                struct.pack('<3i', 0, 4096, 0) + struct.pack('<i', 0) + struct.pack('<4H', 0, 1, 0, 0) + struct.pack('<iHH', 256 * 4096, 1, 0) + struct.pack('<H', 0)
            p = struct.pack('<1024H', *perm)
            lands.append(struct.pack('<4I2H', len(p), len(bld), len(model), len(bdhc), 0x1234, 0) + p + bld + model + bdhc)
    return gm, (nx, nz), lands


def matrix_file(tag, w, h, land_ids):
    d = slots.MATRIX_DIR
    existing = [f for f in os.listdir(d) if f.endswith('.bin')]
    mine = [f for f in existing if f.endswith('_CV_%s.bin' % tag)]
    name = mine[0] if mine else 'map_matrix_%04d_CV_%s.bin' % (max(int(f[11:15]) for f in existing if f[11:15].isdigit()) + 1, tag)
    nm = ('cv_' + tag.lower())[:16].encode()
    open(os.path.join(d, name), 'wb').write(bytes([w, h, 0, 0, len(nm)]) + nm + struct.pack('<%dH' % len(land_ids), *land_ids))
    slots._add_to_list(os.path.join(d, 'meson.build'), name)
    return 'NARC_map_matrix_' + name[:-4] + '_bin'


def main():
    for g, m in GBA_IDS.items():
        SLOTS[m] = next(c['map'] for c in CAVES if c['gba'] == g)
    depth_of = {GBA_IDS[c['gba']]: c['depth'] for c in CAVES}
    land, btnf = read_narc(open(LAND_NARC, 'rb').read())
    lid = CAVE_LAND_BASE
    tmpl = header(TEMPLATE)
    for spec in CAVES:
        gm, (nx, nz), lands = build_floor(spec, depth_of)
        ids = list(range(lid, lid + len(lands)))
        land += [b''] * max(0, ids[-1] + 1 - len(land))
        for i, d in zip(ids, lands): land[i] = d
        lid += len(lands)
        new_map(spec['map'])
        tag = spec['map'].replace('MAP_CANVAS_', '')
        mat = matrix_file(tag, nx, nz, ids)
        ev = json.load(open(os.path.join(slots.EVENT_DIR, events_file(TEMPLATE))))
        ev['warps'] = [{k: v for k, v in w.items() if not k.startswith('_')} for w in gba_warps(gm)]
        for w, gw in zip(ev['warps'], gm['warp_events']):
            if gw['dest_map'] in spec['exits']:
                w.update(x=gw['x'], z=gw['y'], y=0, header=spec['exits'][gw['dest_map']][0], anchor=spec['exits'][gw['dest_map']][1])
        ev['objects'], ev['bgs'], ev['coords'] = [], [], []
        evn = new_events_file(tag, ev)
        fields = {k: v for k, v in tmpl.items() if k not in ('matrixId', 'eventsBank')}
        fields.update(matrixId=mat, eventsBank=evn, **NO_SCRIPTS)
        set_header(spec['map'], fields)
        set_header(spec['map'], {'matrixId': mat, 'eventsBank': evn})
        print(spec['gba'], '->', spec['map'], '%dx%d lands' % (nx, nz), ids)
    land = [d if d else land[209] for d in land]
    open(LAND_NARC, 'wb').write(write_narc(land, btnf))
    # HeartGold's doors into its Mt. Moon lead into ours
    for (m, i), (to, anchor) in DOORS.items():
        path = os.path.join(slots.EVENT_DIR, events_file(m))
        ev = json.load(open(path))
        ev['warps'][i].update(header=to, anchor=anchor)
        json.dump(ev, open(path, 'w'), indent=4); open(path, 'a').write('\n')


if __name__ == '__main__':
    main()
