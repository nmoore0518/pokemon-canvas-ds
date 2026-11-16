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

CAVES = [   # GBA map, our map, how deep (ladders go up or down by it), the GBA's ways out -> (HeartGold map, warp),
    # the HeartGold cave whose header (wild Pokemon, music, camera) it takes. A way out is keyed by the GBA's
    # destination map, or (map, warp id) where two ways out go to one map.
    dict(gba='MtMoon_1F_Frlg', map='MAP_CANVAS_MT_MOON_1F', depth=0, exits={'MAP_ROUTE4': ('MAP_ROUTE_3', 0)}),
    dict(gba='MtMoon_B1F_Frlg', map='MAP_CANVAS_MT_MOON_B1F', depth=1, exits={'MAP_ROUTE4': ('MAP_ROUTE_4', 0)}),
    dict(gba='MtMoon_B2F_Frlg', map='MAP_CANVAS_MT_MOON_B2F', depth=2, exits={}),
    dict(gba='RockTunnel_1F_Frlg', map='MAP_CANVAS_ROCK_TUNNEL_1F', depth=0, template='MAP_ROCK_TUNNEL_1F',
         exits={('MAP_ROUTE10', '0'): ('MAP_ROUTE_10', 0), ('MAP_ROUTE10', '1'): ('MAP_ROUTE_10_SOUTH', 0)}),
    dict(gba='RockTunnel_B1F_Frlg', map='MAP_CANVAS_ROCK_TUNNEL_B1F', depth=1, template='MAP_ROCK_TUNNEL_B1F', exits={}),
    dict(gba='DiglettsCave_NorthEntrance_Frlg', map='MAP_CANVAS_DIGLETTS_CAVE_N', depth=0, template='MAP_DIGLETT_CAVE',
         exits={'MAP_ROUTE2': ('MAP_ROUTE_2_EAST', 4)}),
    dict(gba='DiglettsCave_B1F_Frlg', map='MAP_CANVAS_DIGLETTS_CAVE_B1F', depth=1, template='MAP_DIGLETT_CAVE', exits={}),
    dict(gba='DiglettsCave_SouthEntrance_Frlg', map='MAP_CANVAS_DIGLETTS_CAVE_S', depth=0, template='MAP_DIGLETT_CAVE',
         exits={'MAP_ROUTE11': ('MAP_ROUTE_11', 2)}),
    # (HeartGold has no Route 23: Victory Road runs from the League's reception gate to the Plateau)
    dict(gba='VictoryRoad_1F_Frlg', map='MAP_CANVAS_VICTORY_ROAD_1F', depth=0, template='MAP_VICTORY_ROAD_1F',
         exits={'MAP_ROUTE23': ('MAP_ROUTE_22_POKEMON_LEAGUE_RECEPTION_GATE', 1)}),
    dict(gba='VictoryRoad_2F_Frlg', map='MAP_CANVAS_VICTORY_ROAD_2F', depth=-1, template='MAP_VICTORY_ROAD_2F',
         exits={'MAP_ROUTE23': ('MAP_INDIGO_PLATEAU', 0)}),
    dict(gba='VictoryRoad_3F_Frlg', map='MAP_CANVAS_VICTORY_ROAD_3F', depth=-2, template='MAP_VICTORY_ROAD_3F', exits={}),
    dict(gba='CeruleanCave_1F_Frlg', map='MAP_CANVAS_CERULEAN_CAVE_1F', depth=0, template='MAP_CERULEAN_CAVE_1F',
         exits={'MAP_CERULEAN_CITY': ('MAP_CERULEAN', 7)}),
    dict(gba='CeruleanCave_2F_Frlg', map='MAP_CANVAS_CERULEAN_CAVE_2F', depth=-1, template='MAP_CERULEAN_CAVE_2F', exits={}),
    dict(gba='CeruleanCave_B1F_Frlg', map='MAP_CANVAS_CERULEAN_CAVE_B1F', depth=1, template='MAP_CERULEAN_CAVE_B1F', exits={}),
    dict(gba='SeafoamIslands_1F_Frlg', map='MAP_CANVAS_SEAFOAM_1F', depth=0, template='MAP_SEAFOAM_ISLANDS_1F',
         exits={('MAP_ROUTE20', '0'): ('MAP_ROUTE_20', 1), ('MAP_ROUTE20', '1'): ('MAP_ROUTE_20', 0)}),
    dict(gba='SeafoamIslands_B1F_Frlg', map='MAP_CANVAS_SEAFOAM_B1F', depth=1, template='MAP_SEAFOAM_ISLANDS_B1F', exits={}),
    dict(gba='SeafoamIslands_B2F_Frlg', map='MAP_CANVAS_SEAFOAM_B2F', depth=2, template='MAP_SEAFOAM_ISLANDS_B2F', exits={}),
    dict(gba='SeafoamIslands_B3F_Frlg', map='MAP_CANVAS_SEAFOAM_B3F', depth=3, template='MAP_SEAFOAM_ISLANDS_B3F', exits={}),
    dict(gba='SeafoamIslands_B4F_Frlg', map='MAP_CANVAS_SEAFOAM_B4F', depth=4, template='MAP_SEAFOAM_ISLANDS_B4F', exits={}),
]
TEMPLATE = 'MAP_MOUNT_MOON'
WATER_MB = {16, 17, 18, 19, 20, 21, 24, 26, 44, 45, 80, 81, 82, 83}   # GBA behaviours of water you surf (currents too)
GBA_IDS = {c['gba']: gba_map.map_json(c['gba'])['id'] for c in CAVES}
# HeartGold's doors into its caves -> ours: (map, its warp index) -> (our map, GBA warp index there)
DOORS = {('MAP_ROUTE_3', 0): ('MAP_CANVAS_MT_MOON_1F', 3), ('MAP_ROUTE_4', 0): ('MAP_CANVAS_MT_MOON_B1F', 7),
         ('MAP_ROUTE_10', 0): ('MAP_CANVAS_ROCK_TUNNEL_1F', 0), ('MAP_ROUTE_10_SOUTH', 0): ('MAP_CANVAS_ROCK_TUNNEL_1F', 5),
         ('MAP_ROUTE_2_EAST', 4): ('MAP_CANVAS_DIGLETTS_CAVE_N', 1), ('MAP_ROUTE_11', 2): ('MAP_CANVAS_DIGLETTS_CAVE_S', 0),
         ('MAP_ROUTE_22_POKEMON_LEAGUE_RECEPTION_GATE', 1): ('MAP_CANVAS_VICTORY_ROAD_1F', 1),
         ('MAP_INDIGO_PLATEAU', 0): ('MAP_CANVAS_VICTORY_ROAD_2F', 5),
         ('MAP_CERULEAN', 7): ('MAP_CANVAS_CERULEAN_CAVE_1F', 0),
         ('MAP_ROUTE_20', 0): ('MAP_CANVAS_SEAFOAM_1F', 4), ('MAP_ROUTE_20', 1): ('MAP_CANVAS_SEAFOAM_1F', 3)}


def floor_plan(gm, lay):
    """-> blocked, boulders, level (0 floor; 1 or 2 tiers of rock), dist (rings of rock from the floor)"""
    W, H = lay.w, lay.h
    blocked = [[lay.collision(x, y) != 0 for x in range(W)] for y in range(H)]
    for w in gm.get('warp_events', []):            # (a ladder or a mouth is walkable)
        blocked[w['y']][w['x']] = False
    # boulders: little patches of rock out on the floor (the GBA game's rock piles) stand on the floor as
    # HeartGold's rock (d_rock01), rather than being built out of walls
    boulders, seen = set(), set()
    for y in range(H):
        for x in range(W):
            if not blocked[y][x] or (x, y) in seen: continue
            comp, stack, edge = [], [(x, y)], False
            seen.add((x, y))
            while stack:
                c = stack.pop(); comp.append(c)
                if c[0] in (0, W - 1) or c[1] in (0, H - 1): edge = True
                for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                    n = (c[0] + dx, c[1] + dy)
                    if 0 <= n[0] < W and 0 <= n[1] < H and blocked[n[1]][n[0]] and n not in seen:
                        seen.add(n); stack.append(n)
            if len(comp) <= 3 and not edge: boulders |= set(comp)
    rock = lambda x, y: not (0 <= x < W and 0 <= y < H) or (blocked[y][x] and (x, y) not in boulders)
    # rings of rock from the floor (8 ways round, so outside corners are round as HeartGold's are)
    INF = 99
    dist = {}
    frontier = [(x, y) for y in range(H) for x in range(W) if not rock(x, y)]
    for p in frontier: dist[p] = 0
    d = 0
    while frontier and d < 6:
        d += 1; nxt = []
        for (x, y) in frontier:
            for dx in (-1, 0, 1):
                for dy in (-1, 0, 1):
                    n = (x + dx, y + dy)
                    if -2 <= n[0] < W + 2 and -2 <= n[1] < H + 2 and n not in dist and rock(*n):
                        dist[n] = d; nxt.append(n)
        frontier = nxt
    D = lambda x, y: dist.get((x, y), INF)
    # a thin wall (floor on both sides within two squares) is one tier high; other rock rises two
    def thin(x, y):
        for dx, dy in ((1, 0), (0, 1)):
            a = 1
            while a <= 2 and rock(x - dx * a, y - dy * a) and 0 <= x - dx * a < W and 0 <= y - dy * a < H: a += 1
            b = 1
            while b <= 2 and rock(x + dx * b, y + dy * b) and 0 <= x + dx * b < W and 0 <= y + dy * b < H: b += 1
            if a + b - 1 <= 2 and not rock(x - dx * a, y - dy * a) and not rock(x + dx * b, y + dy * b): return True
        return False
    level = {}
    for y in range(-2, H + 2):
        for x in range(-2, W + 2):
            level[(x, y)] = 0 if not rock(x, y) else min(D(x, y), 1 if 0 <= x < W and 0 <= y < H and thin(x, y) else 2)
    return blocked, boulders, level, D


def build_floor(spec, depth_of):
    gm = gba_map.map_json(spec['gba'])
    lay = gba_map.Layout(gm['layout'])
    W, H = lay.w, lay.h
    blocked, boulders, level, D = floor_plan(gm, lay)
    LV = lambda x, y: level.get((x, y), 2)
    # water (to surf: HeartGold's cave water, behaviour 0x15, drawn a little below the floor in its river texture)
    water = {(x, y) for y in range(H) for x in range(W) if not blocked[y][x] and lay.behavior(lay.metatile(x, y)) in WATER_MB}
    nx, nz = math.ceil(W / 32), math.ceil(H / 32)
    dims, pals = texdims(TEXSET)
    pal_of = lambda t: next(p for p in (t + '_pl', t) if p in pals)
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
    # ---- faces: every edge where the ground steps up a tier, leaning back across the higher square
    DIRS4 = ((0, -1), (0, 1), (-1, 0), (1, 0))
    faces, vert_s = [], {}
    for y in range(-1, H + 1):
        for x in range(-1, W + 1):
            lb = LV(x, y)
            for n in DIRS4:
                A = (x + n[0], y + n[1])
                la = LV(*A)
                if la != lb + 1: continue
                if not (0 <= x < W and 0 <= y < H) and not (0 <= A[0] < W and 0 <= A[1] < H): continue
                t = (1, 0) if n[0] == 0 else (0, 1)
                # (rock stepping down on both sides leans halfway from each)
                behind = LV(A[0] + n[0], A[1] + n[1])
                sc = 0.5 if behind < la else 1.0          # (rock stepping down on both sides leans half from each)
                if la == 1 and behind <= 1: sc *= 0.5     # (a thin wall leans half as far: a flat top is left)
                same = lambda p: LV(*p) >= la
                ex, ey = x + (1 if n[0] > 0 else 0), y + (1 if n[1] > 0 else 0)
                ends = []
                for j, sgn in ((0, -1), (1, 1)):
                    side, diag = (x + sgn * t[0], y + sgn * t[1]), (A[0] + sgn * t[0], A[1] + sgn * t[1])
                    if same(side): dr = (n[0] + sgn * t[0], n[1] + sgn * t[1])          # (an inside corner)
                    elif same(diag): dr = n                                              # (straight on)
                    else: dr = (n[0] - sgn * t[0], n[1] - sgn * t[1])                    # (an outside corner)
                    e = (ex + t[0] * j, ey + t[1] * j)
                    ends.append((e, dr))
                    vert_s[(e, lb)] = min(vert_s.get((e, lb), 1.0), sc)
                faces.append(dict(f=(x, y), n=n, base=lb, sc=sc, ends=ends))
    # straight faces join into runs (fewer polygons: a land's model must stay small)
    key = lambda fc: (fc['n'], fc['base'], fc['f'][1], fc['f'][0]) if fc['n'][0] == 0 else (fc['n'], fc['base'], fc['f'][0], fc['f'][1])
    runs = []
    for fc in sorted(faces, key=key):
        n, (x, y) = fc['n'], fc['f']
        t = (1, 0) if n[0] == 0 else (0, 1)
        r = runs[-1] if runs else None
        joins = r and r['n'] == n and r['base'] == fc['base'] and r['sc'] == fc['sc'] and r['last'] == (x - t[0], y - t[1]) \
            and r['ends'][-1][1] == n and fc['ends'][0][1] == n and vert_s[(fc['ends'][0][0], fc['base'])] >= fc['sc'] \
            and (x % 32 if n[0] == 0 else y % 32) != 0
        if joins:
            r['ends'][-1] = fc['ends'][1]; r['last'] = (x, y)
        else:
            runs.append(dict(n=n, base=fc['base'], sc=fc['sc'], f=(x, y), last=(x, y), ends=[fc['ends'][0], fc['ends'][1]]))
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
            flats = {}
            inland = lambda x, y: ox <= x < ox + 32 and oz <= y < oz + 32
            for r in runs:
                if not inland(*r['f']): continue
                n, base = r['n'], r['base'] * TIER
                t = (1, 0) if n[0] == 0 else (0, 1)
                (e0, d0), (e1, d1) = r['ends']
                s0, s1 = min(r['sc'], vert_s[(e0, r['base'])]), min(r['sc'], vert_s[(e1, r['base'])])
                pts = [(e0, d0, s0)]
                if s0 != r['sc'] and (e0[0] + t[0], e0[1] + t[1]) != e1: pts.append(((e0[0] + t[0], e0[1] + t[1]), n, r['sc']))
                if s1 != r['sc'] and (e1[0] - t[0], e1[1] - t[1]) != pts[-1][0]: pts.append(((e1[0] - t[0], e1[1] - t[1]), n, r['sc']))
                pts.append((e1, d1, s1))
                name = WALL_TEX[n]
                nrm = (-n[0] * 0.6, 0.8, -n[1] * 0.6)
                for (ea, da, sa), (eb, db, sb) in zip(pts, pts[1:]):
                    ends, dirs, ss = [ea, eb], [da, db], [sa, sb]
                    u = [(e[0] if n[0] == 0 else e[1]) * 16 for e in ends]
                    for (q0, h0, v0), (q1, h1, v1) in zip(PROFILE[0], PROFILE[0][1:]):
                        P = lambda k, q, h: (U(ends[k][0] + dirs[k][0] * q * ss[k], ox), base + h, U(ends[k][1] + dirs[k][1] * q * ss[k], oz))
                        M(name).quad([(P(0, q0, h0), (u[0], v0)), (P(1, q0, h0), (u[1], v0)),
                                      (P(1, q1, h1), (u[1], v1)), (P(0, q1, h1), (u[0], v1))], nrm)
            for y in range(oz, oz + 32):
                for x in range(ox, ox + 32):
                    i = (y - oz) * 32 + (x - ox)
                    inside = x < W and y < H
                    x0, x1, z0, z1 = U(x, ox), U(x + 1, ox), U(y, oz), U(y + 1, oz)
                    if inside and not blocked[y][x]:
                        perm[i] = 0x0015 if (x, y) in water else FLOOR
                    lv = LV(x, y)
                    # flat pieces are gathered here and drawn in runs below (the DS draws 2048 polygons a frame,
                    # people included: a cave drawn square by square leaves none for them)
                    if lv == 0 and inside and not ((x, y) in ladders and ladders[(x, y)] == LADDER_DOWN):
                        for n in DIRS4:            # the floor's darker edge along the foot of a wall
                            if LV(x + n[0], y + n[1]) > 0: flats.setdefault(('droad01_r', 0.2, n), set()).add((x, y))
                    faced = any(LV(x + dx, y + dy) < lv for dx in (-1, 0, 1) for dy in (-1, 0, 1))
                    faced4 = any(LV(x + n[0], y + n[1]) < lv for n in DIRS4)
                    if lv >= 1 and faced:          # under the face, the ground it rises from (shows in any gap)
                        flats.setdefault(('dcliff01', (lv - 1) * TIER - 0.2, None), set()).add((x, y))
                    if lv >= 1 and faced and not faced4:
                        # (only a diagonal is lower: the faces round that corner reach in from its corner; the rest
                        # of the square is rock top, just below their lips)
                        flats.setdefault(('dcliff01', lv * TIER - 0.4, None), set()).add((x, y))
                    if lv >= 1 and faced4:
                        # the square's top between the lips of the faces across it (a thin wall's flat top; anything
                        # the faces don't reach, instead of the dark showing through)
                        ins = {}
                        for n in DIRS4:
                            if LV(x + n[0], y + n[1]) < lv:
                                behind = LV(x - n[0], y - n[1])
                                k = 0.5 if behind < lv else 1.0
                                if lv == 1 and behind <= 1: k *= 0.5
                                ins[n] = k
                        a0, a1 = x + ins.get((-1, 0), 0), x + 1 - ins.get((1, 0), 0)
                        b0, b1 = y + ins.get((0, -1), 0), y + 1 - ins.get((0, 1), 0)
                        ch = lv * TIER - 0.1
                        if a1 - a0 > 0.01 and b1 - b0 > 0.01: M('dcliff01').quad([((U(a0, ox), ch, U(b1, oz)), (a0 * 16, b1 * 16)), ((U(a1, ox), ch, U(b1, oz)), (a1 * 16, b1 * 16)),
                                            ((U(a1, ox), ch, U(b0, oz)), (a1 * 16, b0 * 16)), ((U(a0, ox), ch, U(b0, oz)), (a0 * 16, b0 * 16))], up)
                    if (lv == 1 or (lv == 2 and D(x, y) == 2)) and not faced:     # a tier's rocky top
                        flats.setdefault(('dcliff01', lv * TIER - 0.3, None), set()).add((x, y))
                    elif lv == 2 and D(x, y) == 3:  # the rim above the second tier: light at its edge, dark beyond
                        lower = [n for n in DIRS4 if D(x + n[0], y + n[1]) < D(x, y)]
                        if lower:
                            flats.setdefault(('dcliff01_r', 31.7, lower[0]), set()).add((x, y))
                        else:
                            dg = next(((dx, dy) for dx in (-1, 1) for dy in (-1, 1) if D(x + dx, y + dy) < D(x, y)), (0, 1))
                            flats.setdefault(('dcliff01_r', 31.7, ('corner',) + dg), set()).add((x, y))
                    if (x, y) in boulders:      # HeartGold's rock, stood up like its crystals
                        M('d_rock01').quad([((U(x - 0.1, ox), 0.5, U(y + 0.95, oz)), (0.5, 31.5)), ((U(x + 1.1, ox), 0.5, U(y + 0.95, oz)), (31.5, 31.5)),
                                            ((U(x + 1.1, ox), 21, U(y - 0.45, oz)), (31.5, 0.5)), ((U(x - 0.1, ox), 21, U(y - 0.45, oz)), (0.5, 0.5))], (0, 0.6, 0.8))
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
            # flat pieces in runs: along rows, or down columns for an edge running north-south
            for (tex, hh, orient), cells in flats.items():
                along_x = not (isinstance(orient, tuple) and len(orient) == 2 and orient[0] != 0)
                if isinstance(orient, tuple) and orient[0] == 'corner':
                    for (x, y) in cells:
                        dg = orient[1:]
                        x0, x1, z0, z1 = U(x, ox), U(x + 1, ox), U(y, oz), U(y + 1, oz)
                        cx_, cz_ = (x0 if dg[0] < 0 else x1), (z0 if dg[1] < 0 else z1)
                        fx_, fz_ = (x1 if dg[0] < 0 else x0), (z1 if dg[1] < 0 else z0)
                        M(tex).quad([((cx_, hh, cz_), (16.4, 0.4)), ((fx_, hh, cz_), (31.6, 0.4)),
                                     ((fx_, hh, fz_), (31.6, 15.6)), ((cx_, hh, fz_), (16.4, 15.6))], up)
                    continue
                left = set(cells)
                for (x, y) in sorted(cells, key=(lambda c: (c[1], c[0])) if along_x else (lambda c: (c[0], c[1]))):
                    if (x, y) not in left: continue
                    k = 1
                    step = (1, 0) if along_x else (0, 1)
                    while (x + step[0] * k, y + step[1] * k) in left: k += 1
                    for j in range(k): left.discard((x + step[0] * j, y + step[1] * j))
                    xe, ye = (x + k, y + 1) if along_x else (x + 1, y + k)
                    x0, x1, z0, z1 = U(x, ox), U(xe, ox), U(y, oz), U(ye, oz)
                    if orient is None:
                        M(tex).quad([((x0, hh, z1), (x * 16, ye * 16)), ((x1, hh, z1), (xe * 16, ye * 16)),
                                     ((x1, hh, z0), (xe * 16, y * 16)), ((x0, hh, z0), (x * 16, y * 16))], up)
                    else:
                        # an edge texture: its edge (s=0) on the orient side, running along the run (t)
                        n = orient
                        corners = {(0, -1): [((x0, z0), 0.4, x * 16), ((x1, z0), 0.4, xe * 16), ((x1, z1), 15.6, xe * 16), ((x0, z1), 15.6, x * 16)],
                                   (0, 1): [((x0, z1), 0.4, x * 16), ((x1, z1), 0.4, xe * 16), ((x1, z0), 15.6, xe * 16), ((x0, z0), 15.6, x * 16)],
                                   (-1, 0): [((x0, z0), 0.4, y * 16), ((x0, z1), 0.4, ye * 16), ((x1, z1), 15.6, ye * 16), ((x1, z0), 15.6, y * 16)],
                                   (1, 0): [((x1, z0), 0.4, y * 16), ((x1, z1), 0.4, ye * 16), ((x0, z1), 15.6, ye * 16), ((x0, z0), 15.6, y * 16)]}[n]
                        M(tex).quad([((p[0], hh, p[1]), (sv, tv)) for p, sv, tv in corners], up)
            # the floor, in runs along each row (a ladder down is a hole); boulders stand on it
            for y in range(oz, oz + 32):
                x = ox
                while x < ox + 32:
                    fl = lambda x: x < W and y < H and LV(x, y) == 0 and not ((x, y) in ladders and ladders[(x, y)] == LADDER_DOWN) \
                        and (x, y) not in water
                    if not fl(x): x += 1; continue
                    e = x + 1
                    while e < ox + 32 and fl(e): e += 1
                    x0, x1, z0, z1 = U(x, ox), U(e, ox), U(y, oz), U(y + 1, oz)
                    M('droad01').quad([((x0, 0, z1), (x * 16, (y + 1) * 16)), ((x1, 0, z1), (e * 16, (y + 1) * 16)),
                                       ((x1, 0, z0), (e * 16, y * 16)), ((x0, 0, z0), (x * 16, y * 16))], up)
                    x = e
                x = ox
                while x < ox + 32:            # water, in runs too
                    if (x, y) not in water: x += 1; continue
                    e = x + 1
                    while e < ox + 32 and (e, y) in water: e += 1
                    x0, x1, z0, z1 = U(x, ox), U(e, ox), U(y, oz), U(y + 1, oz)
                    M('driver').quad([((x0, -3, z1), (x * 16, (y + 1) * 16)), ((x1, -3, z1), (e * 16, (y + 1) * 16)),
                                      ((x1, -3, z0), (e * 16, y * 16)), ((x0, -3, z0), (x * 16, y * 16))], up)
                    x = e
            if not meshes:      # (a land all rock, past the cave's edge: the dark, as in HeartGold)
                M('d_ro').quad([((-256, 32, 256), (0, 8)), ((256, 32, 256), (8, 8)), ((256, 32, -256), (8, 0)), ((-256, 32, -256), (0, 0))], up)
            groups = [(t, t, pal_of(t), mesh, {'repeat': 3, 'size': dims[t]}) for t, mesh in meshes.items()]
            model = build_model('cv_cave_%d' % (spec['depth'] * 10 + len(lands)), groups)     # (names: 16 at most)
            model += b'\0' * (-len(model) % 4)
            bld = b''.join(struct.pack('<I3i3i3i8x', m, int(px * 4096), int(py * 4096), int(pz * 4096), 0, 0, 0, 4096, 4096, 4096)
                           for m, px, py, pz in props)
            bdhc = struct.pack('<4s6H', b'BDHC', 2, 1, 1, 1, 1, 1) + struct.pack('<2i2i', -256 * 4096, -256 * 4096, 256 * 4096, 256 * 4096) + \
                struct.pack('<3i', 0, 4096, 0) + struct.pack('<i', 0) + struct.pack('<4H', 0, 1, 0, 0) + struct.pack('<iHH', 256 * 4096, 1, 0) + struct.pack('<H', 0)
            p = struct.pack('<1024H', *perm)
            lands.append(struct.pack('<4I2H', len(p), len(bld), len(model), len(bdhc), 0x1234, 0) + p + bld + model + bdhc)
            assert len(model) < 60000, ('model too big for a land', spec['gba'], len(lands), len(model))
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
    for spec in CAVES:
        tmpl = header(spec.get('template', TEMPLATE))
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
            ex = spec['exits'].get((gw['dest_map'], str(gw['dest_warp_id'])), spec['exits'].get(gw['dest_map']))
            if ex:
                w.update(x=gw['x'], z=gw['y'], y=0, header=ex[0], anchor=ex[1])
        ev['objects'], ev['bgs'], ev['coords'] = [], [], []
        evn = new_events_file(tag, ev)
        fields = {k: v for k, v in tmpl.items() if k not in ('matrixId', 'eventsBank')}
        fields.update(matrixId=mat, eventsBank=evn, areaDataBank='70', **NO_SCRIPTS)     # (HeartGold's cave look, Mt. Moon's set)
        fields['weather'] = '11' if gm.get('requires_flash') else '0'      # (dark until Flash only where the GBA's is)
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
