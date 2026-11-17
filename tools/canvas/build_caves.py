"""Canvas: build the GBA game's caves (Mt. Moon's three floors) as HeartGold caves.

HeartGold's Mt. Moon is one small floor; the GBA game's is three, with its trainers, the Rockets and the fossils.
Each floor is modelled from its GBA layout in HeartGold's cave look (HeartGold's own textures for that cave: see AREAS), the way HeartGold builds its own caves (read off its Mt. Moon with bmdview.py):
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
# Each cave has the look HeartGold gives its own: the area (its texture set has the same number, and the same
# texture names in every one of them) of HeartGold's cave of that name. Mt. Moon and Victory Road share the grey
# one; Rock Tunnel's is its own grey, Diglett's Cave is brown earth, Cerulean Cave purple with crystals for rocks,
# the Seafoam Islands ice (HeartGold's lower floors; the GBA's are ice from the first).
AREAS = {'RockTunnel': 83, 'DiglettsCave': 82, 'CeruleanCave': 73, 'SeafoamIslands': 104}
area_of = lambda spec: next((a for k, a in AREAS.items() if spec['gba'].startswith(k)), 70)
LADDER_UP, LADDER_DOWN = 69, 70
FLOOR = 0x0A08                  # walkable cave floor (behaviour 0x08), as HeartGold's Mt. Moon
TIER = 16                       # a tier of rock: a block high
WATER_Y = -8                    # cave water lies half a block below the floor, as in HeartGold's Union Cave, with its bank round it (BANK)
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


STAIRS_MT = {0x284, 0x2B4}      # the GBA cave tileset's steps: they climb north
RINGS = 3                       # tiers of rock above the floor nearest it; then the rim, then the dark
DIRS4_ = ((1, 0), (-1, 0), (0, 1), (0, -1))
DIRS8_ = [(dx, dy) for dx in (-1, 0, 1) for dy in (-1, 0, 1) if dx or dy]
# HeartGold's bank round its cave water (read off Union Cave): across the water's edge, (how far onto the land,
# height from the floor, texture row); the water lies at WATER_Y
BANK = [(3.6, 2.0, 0.3), (0.2, 1.7, 3.3), (-1.8, -0.6, 5.6), (-2.6, -6.3, 12.1), (-4.7, -7.6, 15.6)]


def _reachable(gm, blocked, W, H):
    """closes what cannot be got to from a ladder, a mouth or where someone stands (the GBA leaves squares open in
    its borders)"""
    seen = {(e['x'], e['y']) for k in ('warp_events', 'object_events') for e in gm.get(k, []) if 0 <= e['x'] < W and 0 <= e['y'] < H and not blocked[e['y']][e['x']]}
    todo = list(seen)
    while todo:
        x, y = todo.pop()
        for dx, dy in DIRS4_:
            n = (x + dx, y + dy)
            if 0 <= n[0] < W and 0 <= n[1] < H and not blocked[n[1]][n[0]] and n not in seen: seen.add(n); todo.append(n)
    for y in range(H):
        for x in range(W):
            if (x, y) not in seen: blocked[y][x] = True


def cave_open(gm, lay):
    """-> blocked (a ladder or a mouth is walkable), boulders: little patches of rock out on the floor (the GBA
    game's rock piles), which stand on the floor as HeartGold's rock rather than being built out of walls"""
    W, H = lay.w, lay.h
    blocked = [[lay.collision(x, y) != 0 for x in range(W)] for y in range(H)]
    for w in gm.get('warp_events', []):
        blocked[w['y']][w['x']] = False
    _reachable(gm, blocked, W, H)
    boulders, seen = set(), set()
    for y in range(H):
        for x in range(W):
            if not blocked[y][x] or (x, y) in seen: continue
            comp, stack, edge = [], [(x, y)], False
            seen.add((x, y))
            while stack:
                c = stack.pop(); comp.append(c)
                if c[0] in (0, W - 1) or c[1] in (0, H - 1): edge = True
                for dx, dy in DIRS4_:
                    n = (c[0] + dx, c[1] + dy)
                    if 0 <= n[0] < W and 0 <= n[1] < H and blocked[n[1]][n[0]] and n not in seen:
                        seen.add(n); stack.append(n)
            if len(comp) <= 3 and not edge: boulders |= set(comp)
    return blocked, boulders


def cave_heights(gm, lay, blocked, boulders, plain=()):
    """How high the ground is, in tiers: -> ({square: height} for every square that is no rock or step, {a step's
    square: the height at its foot}). The GBA says it two ways: its elevation (3 the ground, 4 a tier up; you get
    onto water, 1, from 3), and steps drawn in a cliff with the same elevation both ends (Mt. Moon, Seafoam 1F),
    which climb a tier going north."""
    W, H = lay.w, lay.h
    open_ = lambda x, y: 0 <= x < W and 0 <= y < H and (not blocked[y][x] or (x, y) in boulders)
    stairs = {(x, y) for y in range(H) for x in range(W) if open_(x, y) and (x, y) not in boulders and (x, y) not in plain and lay.metatile(x, y) in STAIRS_MT}
    warps = {(w['x'], w['y']) for w in gm.get('warp_events', [])}

    def cls(x, y):
        e = lay.elevation(x, y)
        if (x, y) in plain and lay.metatile(x, y) in STAIRS_MT: return None     # (floor at a flight's head: as the ground north of it)
        return None if (x, y) in warps or (x, y) in boulders or e in (0, 2, 15) else 3 if e == 1 else e
    reg, regs = {}, []
    for y in range(H):
        for x in range(W):
            if not open_(x, y) or (x, y) in stairs or (x, y) in reg or cls(x, y) is None: continue
            reg[(x, y)] = len(regs); comp, stack = [], [(x, y)]
            while stack:
                c = stack.pop(); comp.append(c)
                for dx, dy in DIRS4_:
                    n = (c[0] + dx, c[1] + dy)
                    if open_(*n) and n not in stairs and n not in reg and cls(*n) == cls(*c): reg[n] = reg[c]; stack.append(n)
            regs.append(comp)
    rcls = [cls(*c[0]) for c in regs]
    edges = {}
    link = lambda a, b, d: (edges.setdefault(a, []).append((b, d)), edges.setdefault(b, []).append((a, -d)))
    # squares with no elevation of their own (ladders, mouths, rock piles) join the ground beside them, and tie
    # the grounds either side of them together
    grew = True
    while grew:
        grew = False
        for y in range(H):
            for x in range(W):
                if not open_(x, y) or (x, y) in stairs or (x, y) in reg: continue
                near = [reg[(x + dx, y + dy)] for dx, dy in DIRS4_ if (x + dx, y + dy) in reg]
                if not near: continue
                reg[(x, y)] = near[0]; regs[near[0]].append((x, y)); grew = True
                for r in near[1:]:
                    if r != near[0]: link(near[0], r, (rcls[r] or 3) - (rcls[near[0]] or 3))
    for y in range(H):
        for x in range(W):
            if open_(x, y) and (x, y) not in stairs and (x, y) not in reg:
                reg[(x, y)] = len(regs); regs.append([(x, y)]); rcls.append(3)
    for (x, y) in stairs:                  # a flight: its head is a tier (or as many as it has squares) above its foot
        if (x, y - 1) in stairs: continue
        e = y
        while (x, e + 1) in stairs: e += 1
        if (x, y - 1) in reg and (x, e + 1) in reg: link(reg[(x, e + 1)], reg[(x, y - 1)], e - y + 1)
    for (x, y), r in list(reg.items()):    # two elevations side by side
        for dx, dy in ((1, 0), (0, 1)):
            n = (x + dx, y + dy)
            if n in reg and reg[n] != r and cls(x, y) is not None and cls(*n) is not None and cls(*n) != cls(x, y):
                link(r, reg[n], cls(*n) - cls(x, y))
    hreg = {}
    for r0 in sorted(range(len(regs)), key=lambda r: -len(regs[r])):
        if r0 in hreg: continue
        hreg[r0] = (rcls[r0] or 3) - 3; todo = [r0]
        while todo:
            a_ = todo.pop()
            for b_, d in edges.get(a_, []):
                if b_ not in hreg: hreg[b_] = hreg[a_] + d; todo.append(b_)
    hts = {sq: hreg[r] for sq, r in reg.items()}
    foot = {}
    for (x, y) in stairs:
        e = y
        while (x, e + 1) in stairs: e += 1
        t = y
        while (x, t - 1) in stairs: t -= 1
        base = hts[(x, e + 1)] if (x, e + 1) in hts else hts.get((x, t - 1), e - t + 1) - (e - t + 1)
        foot[(x, y)] = base + (e - y)
    return hts, foot


_plans = {}


def cave_widen(gba):
    """Columns and rows to double, so that no wall is thinner than HeartGold's pieces need: a face is a square
    deep and a block high and is never squeezed, so a wall one square thick can only be a step up of one tier.
    Between two floors of the same height it takes two squares (a face each side); between floors n tiers apart,
    n. -> dict(cols=[(column, copies more)], rows=[...]) for build_rooms' widen"""
    if gba not in _plans:
        gm = gba_map.map_json(gba); lay = gba_map.Layout(gm['layout'])
        blocked, boulders = cave_open(gm, lay)
        hts, foot = cave_heights(gm, lay, blocked, boulders)
        cols, rows = {}, {}
        for axis, need, n_lines, n in ((0, cols, lay.h, lay.w), (1, rows, lay.w, lay.h)):
            for line in range(n_lines):
                sq = (lambda i: (i, line)) if axis == 0 else (lambda i: (line, i))
                i = 0
                while i < n:
                    if sq(i) in hts: i += 1; continue
                    j = i
                    while j < n and sq(j) not in hts: j += 1
                    if i > 0 and j < n and not any(sq(k) in foot for k in range(i, j)):
                        a, b = hts[sq(i - 1)], hts[sq(j)]
                        T = 2 if a == b else abs(a - b)
                        if j - i < T: need[i] = max(need.get(i, 0), T - (j - i))
                    i = j
                # (and two floors of different heights side by side with nothing between them: the GBA keeps you
                # from stepping across by elevation alone. The cliff needs squares to stand on: floor_plan closes
                # the new ones there)
                for i in range(1, n):
                    if sq(i - 1) in hts and sq(i) in hts and hts[sq(i - 1)] != hts[sq(i)]:
                        need[i] = max(need.get(i, 0), abs(hts[sq(i - 1)] - hts[sq(i)]))
        _plans[gba] = dict(cols=sorted(cols.items()), rows=sorted(rows.items()), boulders=boulders, hts=hts)
    return _plans[gba]


def cave_xy(gba):
    """where a square of the GBA map is in ours (for the porter)"""
    w = cave_widen(gba)
    return lambda x, y, kind='pos': (x + sum(n for c, n in w['cols'] if c <= x), y + sum(n for r, n in w['rows'] if r <= y))


def floor_plan(gba):
    """-> the GBA map widened (cave_widen), its layout, blocked, boulders, level (tiers up, for every square with
    a level: floor, steps (their head) and the rock within RINGS + 1 rings of them), D (rings of rock from the
    floor), the floors' heights and the steps' feet"""
    gm = gba_map.map_json(gba); lay = gba_map.Layout(gm['layout'])
    plan = cave_widen(gba)
    # (a rock pile stays where it stood: of a column or row doubled through it, the copy is floor)
    cmap = [x for x in range(lay.w) for _ in range(1 + dict(plan['cols']).get(x, 0))]
    rmap = [y for y in range(lay.h) for _ in range(1 + dict(plan['rows']).get(y, 0))]
    if plan['cols'] or plan['rows']:
        from build_rooms import widen
        gm = widen(gm, lay, cols=plan['cols'], rows=plan['rows'])
    W, H = lay.w, lay.h
    blocked = [[lay.collision(x, y) != 0 for x in range(W)] for y in range(H)]
    for w in gm.get('warp_events', []):
        blocked[w['y']][w['x']] = False
    _reachable(gm, blocked, W, H)
    last = lambda m, i: i == len(m) - 1 or m[i + 1] != m[i]
    boulders = set()
    for y in range(H):
        for x in range(W):
            if (cmap[x], rmap[y]) in plan['boulders']:
                if last(cmap, x) and last(rmap, y): boulders.add((x, y))
                else: blocked[y][x] = False
    h0 = plan['hts']
    step = lambda a, b: a in h0 and b in h0 and h0[a] != h0[b]
    for y in range(H):
        for x in range(W):
            sx, sy = cmap[x], rmap[y]
            if (not last(cmap, x) and step((sx - 1, sy), (sx, sy))) or (not last(rmap, y) and step((sx, sy - 1), (sx, sy))):
                blocked[y][x] = True           # (a new square between two heights: the cliff)
    # (of a row doubled through a flight of steps, the copy is floor at its head: the flight stays as long as it was)
    plain = {(x, y) for y in range(H) for x in range(W) if not last(rmap, y)}
    hts, foot = cave_heights(gm, lay, blocked, boulders, plain)
    fixed = dict(hts); fixed.update({s: f + 1 for s, f in foot.items()})
    M_ = RINGS + 2
    # rings of rock from the floor (8 ways round, so outside corners are round as HeartGold's are)
    dist, frontier = {s: 0 for s in fixed}, list(fixed)
    for d in range(1, RINGS + 2):
        nxt = []
        for (x, y) in frontier:
            for dx, dy in DIRS8_:
                n = (x + dx, y + dy)
                if -M_ <= n[0] < W + M_ and -M_ <= n[1] < H + M_ and n not in dist: dist[n] = d; nxt.append(n)
        frontier = nxt
    D = lambda x, y: dist.get((x, y), 99)
    rocks = [s for s, d in dist.items() if d > 0]
    L = {s: 99 for s in rocks}
    get = lambda s: fixed[s] if s in fixed else L.get(s)

    def settle():
        # rock rises a tier a ring from the floor, whichever floor is lowest from there: no step of more than one
        ch = True
        while ch:
            ch = False
            for s in rocks:
                m = min((v for v in (get((s[0] + dx, s[1] + dy)) for dx, dy in DIRS8_) if v is not None), default=None)
                if m is not None and L[s] > m + 1 and (L[s] != 99 or dist[s] <= RINGS): L[s] = m + 1; ch = True
    settle()
    for s in rocks:        # (the rim, a ring past the last tier, lies level with it)
        if dist[s] == RINGS + 1:
            L[s] = max((L[n] for n in ((s[0] + dx, s[1] + dy) for dx, dy in DIRS8_) if n in L and dist[n] <= RINGS and L[n] != 99), default=99)
    for s in [s for s in rocks if L[s] == 99]: del L[s]
    rocks = list(L)
    # a square higher than the squares on two opposite sides of it would need a face from each, squeezed: it is
    # the flat top between them instead (a wall three squares thick is a block with a flat top)
    left = 0
    while True:
        settle()
        ch = False
        for s in rocks:
            v = L[s]
            for a_, b_ in (((1, 0), (-1, 0)), ((0, 1), (0, -1))):
                la, lb = get((s[0] + a_[0], s[1] + a_[1])), get((s[0] + b_[0], s[1] + b_[1]))
                if la is not None and lb is not None and la < v and lb < v:
                    if any(hts.get((s[0] + dx, s[1] + dy), -99) > v - 1 for dx, dy in DIRS4_): left += 1; continue
                    L[s] = v - 1; ch = True; break
        if not ch: break
    if left: print('  (%s: %d squares of wall still too thin for whole faces)' % (gba, left))
    steps = sum(1 for (x, y), h in hts.items() for n in ((x + 1, y), (x, y + 1)) if n in hts and hts[n] != h)
    if steps: print('  (%s: %d places where floors of two heights still touch)' % (gba, steps))
    # rock that lies level with the floor beside it is floor (the row behind a cliff's lip where the wall was
    # doubled): the plateau runs to its edge
    ch = True
    while ch:
        ch = False
        for s in list(L):
            x, y = s
            if not (0 <= x < W and 0 <= y < H) or s in hts: continue
            if any(v is not None and v < L[s] for v in (get((x + dx, y + dy)) for dx, dy in DIRS8_)): continue
            if any(hts.get((x + dx, y + dy)) == L[s] for dx, dy in DIRS4_):
                hts[s] = fixed[s] = L[s]; blocked[y][x] = False; ch = True
    for s in hts:
        L.pop(s, None)
    level = dict(fixed); level.update(L)
    # rock piles: HeartGold's rocks at HeartGold's sizes, one to a pile's square (or its big rock over two side by
    # side), none on a square whose rock to the south leans over it. Nothing stands over anything else: a pile by a
    # ladder, a mouth or a person moves to open floor nearby (as one small rock), or goes if there is none.
    water = {q for q in hts if lay.behavior(lay.metatile(*q)) in WATER_MB and q not in boulders}
    warps = {(w['x'], w['y']) for w in gm.get('warp_events', [])}
    people = {(o['x'], o['y']) for o in gm.get('object_events', [])}
    keep = {(wx + dx, wy + dy) for wx, wy in warps for dx in (-1, 0, 1) for dy in (-2, -1, 0, 1)} | people | {(px, py + 1) for px, py in people}
    piles, seen = [], set()
    for q in sorted(boulders):
        if q in seen: continue
        comp, stack = [], [q]; seen.add(q)
        while stack:
            c = stack.pop(); comp.append(c)
            for dx, dy in DIRS4_:
                n = (c[0] + dx, c[1] + dy)
                if n in boulders and n not in seen: seen.add(n); stack.append(n)
        piles.append(comp)
    for comp in piles:
        if not any(q in keep for q in comp): continue
        for (x, y) in comp:
            boulders.discard((x, y)); blocked[y][x] = False
        del comp[1:]
        cx, cy = comp[0]
        free = lambda q: q in hts and hts[q] == hts[(cx, cy)] and q not in water and q not in foot and q not in boulders and q not in keep
        spot = min((q for q in hts if abs(q[0] - cx) + abs(q[1] - cy) <= 7 and free(q)
                    and all(free((q[0] + dx, q[1] + dy)) for dx, dy in DIRS8_)), key=lambda q: (abs(q[0] - cx) + abs(q[1] - cy), q), default=None)
        if spot is None: comp.clear(); continue
        comp[0] = spot; boulders.add(spot); blocked[spot[1]][spot[0]] = True
    cards = []
    for comp in piles:
        got = set()
        for (x, y) in sorted(comp, key=lambda q: (-q[1], q[0])):
            if (x, y) in got or (x, y + 1) in got: continue
            if (x + 1, y) in comp and (x + 1, y) not in got and (x + 1, y + 1) not in got and hts[(x + 1, y)] == hts[(x, y)]:
                cards.append(('big', x, y)); got |= {(x, y), (x + 1, y)}
            else: cards.append(('small', x, y)); got.add((x, y))
    return gm, lay, blocked, boulders, level, D, hts, foot, cards


def build_floor(spec, depth_of):
    gm, lay, blocked, boulders, level, D, hts, foot, cards = floor_plan(spec['gba'])
    W, H = lay.w, lay.h
    LV = lambda x, y: level.get((x, y))                    # (None: rock past the rim, in the dark)
    HT = lambda x, y: hts.get((x, y), 0) * TIER            # a floor square's height
    below = lambda p, lv: LV(*p) is not None and LV(*p) < lv
    # water (to surf: HeartGold's cave water, behaviour 0x15, drawn a little below the floor in its river texture)
    water = {(x, y) for y in range(H) for x in range(W) if not blocked[y][x] and (x, y) in hts and lay.behavior(lay.metatile(x, y)) in WATER_MB}
    nx, nz = math.ceil(W / 32), math.ceil(H / 32)
    dims, pals = texdims(area_of(spec))
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
    faces, vert_s, caps = [], {}, []
    for y in range(-RINGS - 2, H + RINGS + 2):
        for x in range(-RINGS - 2, W + RINGS + 2):
            lb = LV(x, y)
            for n in DIRS4:
                A = (x + n[0], y + n[1])
                la = LV(*A)
                if la is None or lb is None or la != lb + 1: continue
                if A in hts or A in foot: continue          # (the higher square is steps, which have their own slope)
                t = (1, 0) if n[0] == 0 else (0, 1)
                # (rock stepping down on both sides leans halfway from each)
                behind = LV(A[0] + n[0], A[1] + n[1])
                sc = 0.5 if behind is not None and behind < la else 1.0          # (floor_plan leaves none such, but a wall it could not widen)
                same = lambda p: LV(*p) is None or LV(*p) >= la
                ex, ey = x + (1 if n[0] > 0 else 0), y + (1 if n[1] > 0 else 0)
                ends = []
                for j, sgn in ((0, -1), (1, 1)):
                    side, diag = (x + sgn * t[0], y + sgn * t[1]), (A[0] + sgn * t[0], A[1] + sgn * t[1])
                    e = (ex + t[0] * j, ey + t[1] * j)
                    if same(side) and side not in hts and side not in foot: dr = (n[0] + sgn * t[0], n[1] + sgn * t[1])          # (an inside corner)
                    elif same(diag):
                        dr = n                                                           # (straight on)
                        # (the face stops against floor as high as its lip: the wall's side under that floor's edge)
                        if diag in hts: caps.append(dict(f=(x, y), e=e, n=n, base=lb))
                    else: dr = (n[0] - sgn * t[0], n[1] - sgn * t[1])                    # (an outside corner)
                    e = (ex + t[0] * j, ey + t[1] * j)
                    ends.append((e, dr))
                    vert_s[(e, lb)] = min(vert_s.get((e, lb), 1.0), sc)
                faces.append(dict(f=(x, y), n=n, base=lb, sc=sc, ends=ends))
    face_at = {(fc['f'], fc['n']): fc for fc in faces}
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
                    rockq = lv is not None and (x, y) not in hts and (x, y) not in foot
                    # flat pieces are gathered here and drawn in runs below (the DS draws 2048 polygons a frame,
                    # people included: a cave drawn square by square leaves none for them)
                    if (x, y) in hts and (x, y) not in water and not ((x, y) in ladders and ladders[(x, y)] == LADDER_DOWN):
                        # the floor's darker border, HeartGold's (`droad01_r`): along every edge of it - the foot of
                        # a wall, the lip of a cliff, the water's bank - and round a corner of rock that pokes into it
                        notfloor = lambda q: (q not in hts or q in water) and q not in foot
                        for n in DIRS4:
                            if notfloor((x + n[0], y + n[1])):
                                flats.setdefault(('droad01_r', lv * TIER + (0.2 if n[0] == 0 else 0.35), n), set()).add((x, y))
                        for dx in (-1, 1):
                            for dz in (-1, 1):
                                if notfloor((x + dx, y + dz)) and not notfloor((x + dx, y)) and not notfloor((x, y + dz)) \
                                        and (x + dx, y) not in foot and (x, y + dz) not in foot:
                                    cx_, cz_ = (x1 if dx > 0 else x0), (z1 if dz > 0 else z0)
                                    xa, xb, za, zb = min(cx_, cx_ - dx * 6.4), max(cx_, cx_ - dx * 6.4), min(cz_, cz_ - dz * 6.4), max(cz_, cz_ - dz * 6.4)
                                    uu = lambda v: 31.6 if v == cx_ else 25.4
                                    vv = lambda v: 31.6 if v == cz_ else 25.4
                                    hh_ = lv * TIER + 0.5
                                    M('droad01_r').quad([((xa, hh_, zb), (uu(xa), vv(zb))), ((xb, hh_, zb), (uu(xb), vv(zb))),
                                                         ((xb, hh_, za), (uu(xb), vv(za))), ((xa, hh_, za), (uu(xa), vv(za)))], up)
                    faced = rockq and any(below((x + dx, y + dy), lv) for dx in (-1, 0, 1) for dy in (-1, 0, 1))
                    faced4 = rockq and any(below((x + n[0], y + n[1]), lv) for n in DIRS4)
                    if rockq and faced:          # under the face, the ground it rises from (shows in any gap)
                        flats.setdefault(('dcliff01', (lv - 1) * TIER - 0.2, None), set()).add((x, y))
                    # (a square with only a diagonal lower - the inside of a corner - is covered by the two faces that
                    # meet across it, mitred from the corner: it has no top of its own)
                    if rockq and faced4:
                        # the square's top between the lips of the faces across it (a thin wall's flat top; anything
                        # the faces don't reach, instead of the dark showing through)
                        ins = {}
                        for n in DIRS4:
                            if below((x + n[0], y + n[1]), lv):
                                behind = LV(x - n[0], y - n[1])
                                k = 0.5 if behind is not None and behind < lv else 1.0
                                ins[n] = k
                        a0, a1 = x + ins.get((-1, 0), 0), x + 1 - ins.get((1, 0), 0)
                        b0, b1 = y + ins.get((0, -1), 0), y + 1 - ins.get((0, 1), 0)
                        ch = lv * TIER - 0.1
                        # one face across the square: the top runs from the face's lip to the far edge. The lip
                        # slants where the face leans less at one end than the other (beside a thin wall's), and
                        # at an inside corner it starts out past the square's side
                        fc = face_at.get(((x + next(iter(ins))[0], y + next(iter(ins))[1]), (-next(iter(ins))[0], -next(iter(ins))[1]))) if len(ins) == 1 else None
                        if fc:
                            nf = fc['n']
                            tf = (1, 0) if nf[0] == 0 else (0, 1)
                            pt = []          # the lip's ends: (how far along the square's side, how far across)
                            for j, (e, dr) in enumerate(fc['ends']):
                                k = min(fc['sc'], vert_s[(e, fc['base'])])
                                pt.append((j + (dr[0] * tf[0] + dr[1] * tf[1]) * k, k))
                            at = lambda u: max(0.0, min(1.0, pt[0][1] + (pt[1][1] - pt[0][1]) * (u - pt[0][0]) / (pt[1][0] - pt[0][0])))
                            (e0, _), (e1, _) = fc['ends']
                            poly = [(e0[0] + nf[0] * at(0), e0[1] + nf[1] * at(0)), (e1[0] + nf[0] * at(1), e1[1] + nf[1] * at(1)),
                                    (e1[0] + nf[0], e1[1] + nf[1]), (e0[0] + nf[0], e0[1] + nf[1])]
                            area = sum(poly[i][0] * poly[(i + 1) % 4][1] - poly[(i + 1) % 4][0] * poly[i][1] for i in range(4))
                            if area > 0: poly.reverse()
                            if abs(area) > 0.02:
                                M('dcliff01').quad([((U(px, ox), ch, U(pz, oz)), (px * 16, pz * 16)) for px, pz in poly], up)
                        elif a1 - a0 > 0.01 and b1 - b0 > 0.01: M('dcliff01').quad([((U(a0, ox), ch, U(b1, oz)), (a0 * 16, b1 * 16)), ((U(a1, ox), ch, U(b1, oz)), (a1 * 16, b1 * 16)),
                                            ((U(a1, ox), ch, U(b0, oz)), (a1 * 16, b0 * 16)), ((U(a0, ox), ch, U(b0, oz)), (a0 * 16, b0 * 16))], up)
                    if rockq and not faced and D(x, y) <= RINGS:      # a tier's rocky top
                        flats.setdefault(('dcliff01', lv * TIER - 0.3, None), set()).add((x, y))
                    elif rockq and not faced and D(x, y) == RINGS + 1:  # the rim past the last tier: light at its edge, dark beyond
                        lower = [n for n in DIRS4 if D(x + n[0], y + n[1]) < D(x, y)]
                        if lower:
                            flats.setdefault(('dcliff01_r', lv * TIER - 0.3, lower[0]), set()).add((x, y))
                        else:
                            dg = next(((dx, dy) for dx in (-1, 1) for dy in (-1, 1) if D(x + dx, y + dy) < D(x, y)), (0, 1))
                            flats.setdefault(('dcliff01_r', lv * TIER - 0.3, ('corner',) + dg), set()).add((x, y))
                    if (x, y) in ladders:
                        m = ladders[(x, y)]
                        perm[i] = 0x0A3C if m == LADDER_UP else 0x0A3E
                        props.append((m, U(x + 0.5, ox), HT(x, y), U(y + 0.5, oz)))
                    if (x, y) in mouths:
                        b = mouths[(x, y)]
                        perm[i] = 0x0A00 | b
                        if b == 0x6F and y + 1 < oz + 32: perm[i + 32] = 0x8065
                        if b == 0x6E:     # the mouth: a dark opening in the wall above
                            hb = HT(x, y)
                            M('d_ro').quad([((x0 + 2, hb, z0 - 0.5), (0, 8)), ((x1 - 2, hb, z0 - 0.5), (8, 8)),
                                            ((x1 - 2, hb + 28, z0 - 0.5), (8, 0)), ((x0 + 2, hb + 28, z0 - 0.5), (0, 0))], (0, 0, 1))
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
                        if tex == 'droad01_r':      # (the floor's border: only the strip with the border in it, so that two meet square at a corner)
                            si = 6.8
                            if n == (0, -1): z1 = z0 + 6.4
                            elif n == (0, 1): z0 = z1 - 6.4
                            elif n == (-1, 0): x1 = x0 + 6.4
                            else: x0 = x1 - 6.4
                        else: si = 15.6
                        corners = {(0, -1): [((x0, z0), 0.4, x * 16), ((x1, z0), 0.4, xe * 16), ((x1, z1), si, xe * 16), ((x0, z1), si, x * 16)],
                                   (0, 1): [((x0, z1), 0.4, x * 16), ((x1, z1), 0.4, xe * 16), ((x1, z0), si, xe * 16), ((x0, z0), si, x * 16)],
                                   (-1, 0): [((x0, z0), 0.4, y * 16), ((x0, z1), 0.4, ye * 16), ((x1, z1), si, ye * 16), ((x1, z0), si, y * 16)],
                                   (1, 0): [((x1, z0), 0.4, y * 16), ((x1, z1), 0.4, ye * 16), ((x0, z1), si, ye * 16), ((x0, z0), si, y * 16)]}[n]
                        M(tex).quad([((p[0], hh, p[1]), (sv, tv)) for p, sv, tv in corners], up)
            # the floor, in runs along each row at each height (a ladder down is a hole); boulders stand on it
            for y in range(oz, oz + 32):
                fl = lambda x: (x, y) in hts and not ((x, y) in ladders and ladders[(x, y)] == LADDER_DOWN) and (x, y) not in water
                for kind, tex, dy in ((fl, 'droad01', 0), (lambda x: (x, y) in water, 'driver', WATER_Y)):
                    x = ox
                    while x < ox + 32:
                        if not kind(x): x += 1; continue
                        e = x + 1
                        while e < ox + 32 and kind(e) and hts[(e, y)] == hts[(x, y)]: e += 1
                        x0, x1, z0, z1, hh = U(x, ox), U(e, ox), U(y, oz), U(y + 1, oz), HT(x, y) + dy
                        M(tex).quad([((x0, hh, z1), (x * 16, (y + 1) * 16)), ((x1, hh, z1), (e * 16, (y + 1) * 16)),
                                     ((x1, hh, z0), (e * 16, y * 16)), ((x0, hh, z0), (x * 16, y * 16))], up)
                        x = e
            # the pool's bank: HeartGold's (`dpond_line`, BANK), a lip on the land round every edge of the water and
            # down into it, in runs along each edge
            tw_, th_ = dims.get('dpond_line', (16, 16))
            for n in DIRS4:
                t = (1, 0) if n[0] == 0 else (0, 1)
                edge = {(x, y) for (x, y) in water if inland(x, y) and (x + n[0], y + n[1]) not in water}
                for (x, y) in sorted(edge, key=lambda c: (c[1], c[0]) if t[0] else (c[0], c[1])):
                    if (x - t[0], y - t[1]) in edge and inland(x - t[0], y - t[1]) and hts[(x - t[0], y - t[1])] == hts[(x, y)]: continue
                    k = 1
                    while (x + t[0] * k, y + t[1] * k) in edge and hts[(x + t[0] * k, y + t[1] * k)] == hts[(x, y)]: k += 1
                    # the edge's line, from a to b with the land on the left... as the banks' texture runs along it
                    ex, ey = x + (1 if n[0] > 0 else 0), y + (1 if n[1] > 0 else 0)
                    a_, b_ = (ex, ey), (ex + t[0] * k, ey + t[1] * k)
                    hb = HT(x, y)
                    P = lambda q, off, h: (U(q[0] + n[0] * off / 16.0, ox), hb + h, U(q[1] + n[1] * off / 16.0, oz))
                    for (o0, h0, v0), (o1, h1, v1) in zip(BANK, BANK[1:]):
                        quad = [(P(a_, o0, h0), (0, v0 * th_ / 16)), (P(b_, o0, h0), (k * tw_, v0 * th_ / 16)),
                                (P(b_, o1, h1), (k * tw_, v1 * th_ / 16)), (P(a_, o1, h1), (0, v1 * th_ / 16))]
                        if n in ((0, 1), (-1, 0)): quad.reverse()        # (facing up whichever side it is on)
                        M('dpond_line').quad(quad, (-n[0] * 0.5, 0.87, -n[1] * 0.5))
            # rock piles: HeartGold's rocks as HeartGold stands them (read off Union Cave): the small one (half of
            # `d_rock01s`) a square wide, the big one (`d_rock01`) two, leaning back
            for kind, x, y in cards:
                if not inland(x, y): continue
                hb = HT(x, y)
                if kind == 'big' and 'd_rock01' in dims:
                    zf = U(y + 1, oz) - 4.7
                    M('d_rock01').quad([((U(x, ox), hb + 0.7, zf), (0.6, 31.4)), ((U(x + 2, ox), hb + 0.7, zf), (31.4, 31.4)),
                                        ((U(x + 2, ox), hb + 23.3, zf - 22.6), (31.4, 0.4)), ((U(x, ox), hb + 23.3, zf - 22.6), (0.6, 0.4))], (0, 0.7, 0.7))
                    continue
                for i_ in range(2 if kind == 'big' else 1):
                    zf, u0 = U(y + 1, oz) + 1.7, 16.0 * ((x + i_ + y) % 2)
                    M('d_rock01s').quad([((U(x + i_, ox), hb + 2.5, zf), (u0 + 0.6, 31.5)), ((U(x + i_ + 1, ox), hb + 2.5, zf), (u0 + 15.5, 31.5)),
                                         ((U(x + i_ + 1, ox), hb + 23.6, zf - 22.5), (u0 + 15.5, 0.5)), ((U(x + i_, ox), hb + 23.6, zf - 22.5), (u0 + 0.6, 0.5))], (0, 0.7, 0.7))
            for c in caps:
                if not inland(*c['f']): continue
                (ex_, ey_), n, y0_ = c['e'], c['n'], c['base'] * TIER
                a_, b_ = (U(ex_, ox), U(ey_, oz)), (U(ex_ + n[0], ox), U(ey_ + n[1], oz))
                for p0, p1 in ((a_, b_), (b_, a_)):
                    M(WALL_TEX[n]).quad([((p0[0], y0_, p0[1]), (0 if p0 is a_ else 16, 15.75)), ((p1[0], y0_, p1[1]), (16 if p0 is a_ else 0, 15.75)),
                                         ((p1[0], y0_ + TIER, p1[1]), (16 if p0 is a_ else 0, 0.25)), ((p0[0], y0_ + TIER, p0[1]), (0 if p0 is a_ else 16, 0.25))], (0, 0, 1))
            # steps: HeartGold's (`dslope`), a tier in a square, climbing north; and the ends of the cliff's faces
            # either side of them, closed (the wall's section, as high as the higher of it and the steps)
            for (x, y), f in foot.items():
                if not inland(x, y): continue
                x0, x1, z0, z1, yl, yh = U(x, ox), U(x + 1, ox), U(y, oz), U(y + 1, oz), f * TIER, (f + 1) * TIER
                M('dslope').quad([((x0, yl, z1), (0, 23.2)), ((x1, yl, z1), (32, 23.2)), ((x1, yh, z0), (32, 0.8)), ((x0, yh, z0), (0, 0.8))], (0, 0.7, 0.7))
                for xs, nx_, tex in ((x0, -1, 'dwall_w'), (x1, 1, 'dwall_e')):
                    nb = (x + nx_, y)
                    if nb in foot: continue
                    # (how far up the square, how high: beside a cliff's face, the higher of it and the steps; beside
                    # floor, the side of the upper floor, or the wedge under the steps)
                    sec = [(0, 0), (0.325, 5.2), (0.67, 16), (1, 16)] if nb not in hts else [(0, 16), (1, 16)] if hts[nb] > f else [(0, 0), (1, 16)]
                    for (q0, h0), (q1, h1) in zip(sec, sec[1:]):
                        Q = lambda q, h: ((xs, yl + h, z1 - q * 16), (q * 16, 15.75 - h * 15.5 / 16))
                        for quad in ([Q(q0, 0), Q(q1, 0), Q(q1, h1), Q(q0, h0)], [Q(q0, h0), Q(q1, h1), Q(q1, 0), Q(q0, 0)]):
                            M(tex).quad(quad, (-nx_, 0, 0))
            if not meshes:      # (a land all rock, past the cave's edge: the dark, as in HeartGold)
                M('d_ro').quad([((-256, 32, 256), (0, 8)), ((256, 32, 256), (8, 8)), ((256, 32, -256), (8, 0)), ((-256, 32, -256), (0, 0))], up)
            groups = [(t, t, pal_of(t), mesh, {'repeat': 3, 'size': dims[t]}) for t, mesh in meshes.items()]
            model = build_model('cv_cave_%d' % (spec['depth'] * 10 + len(lands)), groups)     # (names: 16 at most)
            model += b'\0' * (-len(model) % 4)
            bld = b''.join(struct.pack('<I3i3i3i8x', m, int(px * 4096), int(py * 4096), int(pz * 4096), 0, 0, 0, 4096, 4096, 4096)
                           for m, px, py, pz in props)
            # heights walked on: the floor's, the water's, the steps' slope; a plate for every run of a row
            fx = lambda v: int(round(v * 4096))
            pts, nrm, cst, plates, strips, access = [], [], [], [], [], []
            idx = lambda lst, v: lst.index(v) if v in lst else (lst.append(v) or len(lst) - 1)
            hkey = lambda x, y: ('step', foot[(x, y)]) if (x, y) in foot else ('flat', HT(x, y) + (WATER_Y if (x, y) in water else 0)) if (x, y) in hts \
                else ('flat', (LV(x, y) or 0) * TIER)
            for y in range(oz, oz + 32):
                row, x = [], ox
                while x < ox + 32:
                    key, e = hkey(x, y), x + 1
                    while e < ox + 32 and hkey(e, y) == key: e += 1
                    z0, z1 = U(y, oz), U(y + 1, oz)
                    if key[0] == 'flat': nv, dv = (0, 4096, 0), -fx(key[1])
                    else:               # (down a tier from its north edge to its south)
                        yb, sl = (key[1] + 1) * TIER, -1.0
                        ln = (1 + sl * sl) ** 0.5
                        nv, dv = (0, fx(1 / ln), fx(-sl / ln)), fx(-(yb - sl * z0) / ln)
                    plates.append((idx(pts, (fx(U(x, ox)), fx(z0))), idx(pts, (fx(U(e, ox)), fx(z1))), idx(nrm, nv), idx(cst, dv)))
                    row.append(len(plates) - 1); x = e
                strips.append((fx(U(y + 1, oz)), len(row), len(access))); access += row
            bdhc = struct.pack('<4s6H', b'BDHC', len(pts), len(nrm), len(cst), len(plates), len(strips), len(access)) + \
                b''.join(struct.pack('<2i', *q) for q in pts) + b''.join(struct.pack('<3i', *q) for q in nrm) + b''.join(struct.pack('<i', q) for q in cst) + \
                b''.join(struct.pack('<4H', *q) for q in plates) + b''.join(struct.pack('<iHH', *q) for q in strips) + \
                b''.join(struct.pack('<H', q) for q in access)
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
        fields.update(matrixId=mat, eventsBank=evn, areaDataBank=str(area_of(spec)), **NO_SCRIPTS)     # (HeartGold's look for that cave)
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
