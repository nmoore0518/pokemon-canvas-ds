"""Canvas: Kanto's towns and routes on the GBA's layouts (Nick: every town and route as the GBA has it), laid from
HeartGold's own pieces the way the Safari Zone is (build_safari.py, route_kit.py: see CANVAS.md, "Build from a tile
kit").

The GBA's Kanto is one world: its maps meet one another by their connections (a map's `connections`: the map beside
it, which side, how far along). `world()` walks them from Pallet Town and gives every outdoor map its place, in
squares; the world is about 13 by 13 of HeartGold's 32-square lands.

Each square of each map is read as one kind of ground or thing (`kinds`): grass, tall grass, the town's paving,
sand, water, the woods, rock (a mountain, a tier up, HeartGold's cliff pieces round it), ledges, fences, hedges,
signs, flowers, stairs, buildings (the closed squares round a door: HeartGold's own building model stands there,
the one HeartGold's town has for that room, found by its warp: `hg_buildings`), anything else closed a stone.
Squares no map covers are woods. The lands are then laid a square at a time, ground first, as the Safari Zone's.
"""
import json, math, os, struct, sys
HERE = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, HERE)
from g3d import Mesh, build_model
import gba_map, slots, world as hgworld
import cave_kit as K
import route_kit as R
import build_safari as BS
from build_rooms import texdims

GBA_MAPS = '/home/claude/gym-trainer-hack/data/maps'
TEXSET = 18                 # Pallet's set (ours, with the Safari Zone's pieces in it): every land of the world
TALL_MB = {2}
WATER_MB = {16, 17, 18, 19, 20, 21, 22, 24, 26, 44, 45}
LEDGE_MB = {0x38: (1, 0), 0x39: (-1, 0), 0x3A: (0, -1), 0x3B: (0, 1)}     # GBA jump east/west/north/south -> the way down
SIGN_MT = {0x002, 0x003, 0x168}
FLOWER_MT = {0x004}
CUT_MT = {0x005}
HEDGE_MT = {0x0FA, 0x0FB, 0x13D, 0x13E, 0x13F, 0x146, 0x14D, 0x157}
FENCE_MT = set(range(0x0DE, 0x0FA)) | {0x0D6, 0x0D7, 0x0FC, 0x135, 0x136, 0x1F0, 0x227}
STAIR_MT = {0x089, 0x091}
ROCK_MT = (set(range(0x068, 0x0BC)) - STAIR_MT - {0x0A9}) | {0x10F, 0x11F, 0x1F1, 0x1F2, 0x1F3, 0x1F4, 0x217, 0x21E, 0x21F}
MARGIN = 2                  # (squares of woods round the whole world)


def gba_dirs():
    out = {}
    for d in os.listdir(GBA_MAPS):
        try: j = json.load(open(os.path.join(GBA_MAPS, d, 'map.json')))
        except Exception: continue
        out[j['id']] = d
    return out


# Where the world sits in HeartGold's overworld matrix (EVERYWHERE): its corner at cell ORIGIN, Pallet Town's corner
# at PALLET_AT in it - where our Pallet's lands already are (build_pallet.py: cells 31..33, 11..12, the GBA map 27
# squares in). Cinnabar is our own too (build_cinnabar.py: widened, in cell 32, 15): its GBA map is put where
# that land draws it (the sea round it gives a few squares)
ORIGIN = (30, 2)
CELLS = (14, 15)
PALLET_AT = (59, 288)
PLACED = {'CinnabarIsland_Frlg': (68, 419)}
CUSTOM = {(1, 9), (2, 9), (3, 9), (1, 10), (2, 10), (3, 10), (2, 13)}     # (world cells drawn by build_pallet/build_cinnabar)


def world():
    """-> {GBA map dir: (x, y, w, h)} in world squares (the world's corner 0, 0), and the world's size"""
    ids = gba_dirs()
    size = {}

    def sz(d):
        if d not in size:
            lay = gba_map.Layout(gba_map.map_json(d)['layout']); size[d] = (lay.w, lay.h)
        return size[d]
    pos, todo = {'PalletTown_Frlg': (0, 0)}, ['PalletTown_Frlg']
    while todo:
        d = todo.pop(0)        # (nearest first: the GBA's maps don't quite close their loops, so the far side of one gives)
        x, y = pos[d]; w, h = sz(d)
        for c in gba_map.map_json(d).get('connections') or []:
            n = ids.get(c['map'])
            if not n or n in pos: continue
            nw, nh = sz(n); o = c['offset']
            p = {'up': (x + o, y - nh), 'down': (x + o, y + h), 'left': (x - nw, y + o), 'right': (x + w, y + o)}.get(c['direction'])
            if p: pos[n] = p; todo.append(n)
    # (the routes meet SaffronCity_Connection, the GBA's Saffron as they see it; the town is bigger, its gatehouses
    # inside its edges, the routes' ends drawing the same gatehouses: it sits over them, its gates on theirs)
    if 'SaffronCity_Connection_Frlg' in pos:
        cx_, cy_ = pos.pop('SaffronCity_Connection_Frlg')
        pos['SaffronCity_Frlg'] = (cx_ - 10, cy_ - 7)
    pos['SaffronCity_Frlg'] = pos.pop('SaffronCity_Frlg')          # (last: drawn over the routes' ends)
    out = {d: (p[0] + PALLET_AT[0], p[1] + PALLET_AT[1]) + sz(d) for d, p in pos.items()}
    for d, at in PLACED.items(): out[d] = at + sz(d)
    W, H = CELLS[0] * 32, CELLS[1] * 32
    assert all(v[0] >= MARGIN and v[1] >= MARGIN and v[0] + v[2] <= W - MARGIN and v[1] + v[3] <= H - MARGIN for v in out.values()), \
        [(d, v) for d, v in out.items() if not (v[0] >= MARGIN and v[1] >= MARGIN and v[0] + v[2] <= W - MARGIN and v[1] + v[3] <= H - MARGIN)]
    return out, (W, H)


def _colour(lay):
    cache = {}

    def col(m):
        if m not in cache:
            px = list(lay.render_metatile(m).convert('RGB').getdata())
            cache[m] = tuple(sum(c[i] for c in px) // len(px) for i in range(3))
        return cache[m]
    return col


def kinds(d):
    """-> ({(x, y): kind} for one GBA map, its doors [(x, y)], its ledges {(x, y): way down})"""
    gm = gba_map.map_json(d); lay = gba_map.Layout(gm['layout'])
    W, H = lay.w, lay.h
    col = _colour(lay)
    inb = lambda x, y: 0 <= x < W and 0 <= y < H
    warps = {(w['x'], w['y']) for w in gm.get('warp_events', [])}
    mt = lambda x, y: lay.metatile(x, y)
    mb = lambda x, y: lay.behavior(lay.metatile(x, y))
    shut = lambda x, y: lay.collision(x, y) != 0 and (x, y) not in warps
    green = lambda m: (lambda c: c[1] > c[0] + 10 and c[1] > c[2] + 10)(col(m))
    brown = lambda m: (lambda c: c[0] > c[1] + 8 and c[0] > c[2] + 20 and c[1] < 170)(col(m))
    sandy = lambda m: (lambda c: c[0] > 180 and c[1] > 160 and c[2] < 150 and c[0] > c[2] + 50)(col(m))
    paved = lambda m: (lambda c: max(c) - min(c) < 28 and sum(c) > 450)(col(m))
    signs = {(b['x'], b['y']) for b in gm.get('bg_events', []) if b.get('type', 'sign') == 'sign'}
    water = lambda x, y: mb(x, y) in WATER_MB
    # (the doors: warps on closed squares, or with a door's behaviour; the buildings round them are found over the
    # whole world - a gate's building stands in two maps - world_kinds)
    doors = [s for s in warps if lay.collision(*s) != 0 or mb(*s) in (0x69, 0x6A, 0x6E, 0x6D)]
    building = set()
    out, ledges = {}, {}
    for y in range(H):
        for x in range(W):
            m, b = mt(x, y), mb(x, y)
            if (x, y) in building and (x, y) not in doors: k = 'house'
            elif (x, y) in doors: k = 'door'
            elif b in LEDGE_MB: k = 'grass'; ledges[(x, y)] = LEDGE_MB[b]
            elif m in STAIR_MT: k = 'stairs'
            elif water(x, y): k = 'water'
            elif not shut(x, y):
                c = col(m)
                k = 'tall' if b in TALL_MB else 'flower' if m in FLOWER_MT else 'sand' if sandy(m) else 'pave' if paved(m) else 'grass'
            elif (x, y) in signs or m in SIGN_MT: k = 'sign'
            elif m in FENCE_MT: k = 'fence'
            elif m in HEDGE_MT or m in CUT_MT: k = 'hedge'
            elif m in ROCK_MT: k = 'rock'
            elif green(m) and m < 0x280: k = 'woods'         # (the trees are the General set's; a town's green is roofs)
            else: k = 'stone'
            out[(x, y)] = k
    # (a closed square joined to a mountain's rock is rock: its crags and shadows are other colours)
    todo = [q for q, v in out.items() if v == 'rock']
    while todo:
        x, y = todo.pop()
        for n in ((x + 1, y), (x - 1, y), (x, y - 1), (x, y + 1)):
            if out.get(n) == 'stone': out[n] = 'rock'; todo.append(n)
    return out, doors, ledges


def world_kinds(W=None, woods=False):
    """the whole world's squares: {(gx, gz): kind}, doors [(gx, gz, GBA map, x, y)], ledges, the map each square is"""
    W_, (WW, WH) = W or world()
    kind, owner, doors, ledges = {}, {}, [], {}
    for d, (x0, y0, w, h) in W_.items():
        k, dr, lg = kinds(d)
        if woods: k = {q: ('woods' if v == 'stone' else v) for q, v in k.items()}      # (a forest's trees are its own tiles)
        for (x, y), v in k.items():
            kind[(x0 + x, y0 + y)] = v; owner[(x0 + x, y0 + y)] = d
        doors += [(x0 + x, y0 + y, d, x, y) for x, y in dr]
        ledges.update({(x0 + x, y0 + y): v for (x, y), v in lg.items()})
    # (squares no map covers: the sea where the nearest square of a map is water - round Cinnabar - else woods)
    # (only open sea: water along a side of a map that is half water or more; a pond at a map's edge is no sea)
    sea = set()
    wetness = {d: sum(kind.get((x0 + i, y0 + j)) == 'water' for i in range(w) for j in range(h)) / (w * h) for d, (x0, y0, w, h) in W_.items()}
    for d, (x0, y0, w, h) in W_.items():
        for side in ([(x0 + i, y0) for i in range(w)], [(x0 + i, y0 + h - 1) for i in range(w)],
                     [(x0, y0 + j) for j in range(h)], [(x0 + w - 1, y0 + j) for j in range(h)]):
            wet = [q for q in side if kind.get(q) == 'water']
            if len(wet) * 2 >= len(side) or wetness[d] >= 0.4: sea |= set(wet)
    # (our Cinnabar is an island: the sea all round it)
    if 'CinnabarIsland_Frlg' in W_:
        x0, y0, w, h = W_['CinnabarIsland_Frlg']
        sea |= {(x0 + i, y0 + j) for i in range(w) for j in range(h)}
    ring = [q for q in kind]
    near = {q: q in sea for q in kind}
    while ring:
        nxt = []
        for (x, y) in ring:
            for n in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if 0 <= n[0] < WW and 0 <= n[1] < WH and n not in near: near[n] = near[(x, y)]; nxt.append(n)
        ring = nxt
    for gz in range(WH):
        for gx in range(WW):
            if (gx, gz) not in kind: kind[(gx, gz)] = 'water' if near.get((gx, gz)) else 'woods'
    # the buildings: the closed squares (none of the outdoors' things) joined to each door, over the whole world;
    # each building once (a gate has a door each side)
    bldg = {}
    for gx, gz, d, x, y in doors:
        if (gx, gz) in bldg: continue
        comp, todo = {(gx, gz)}, [(gx, gz)]
        while todo and len(comp) < 160:
            q = todo.pop()
            for n in ((q[0] + 1, q[1]), (q[0] - 1, q[1]), (q[0], q[1] - 1), (q[0], q[1] + 1)):
                if n not in comp and kind.get(n) in ('stone', 'house', 'door'): comp.add(n); todo.append(n)
        bid = len(set(bldg.values()))
        for q in comp:
            bldg.setdefault(q, bid)
            if kind[q] == 'stone': kind[q] = 'house'
    return W_, (WW, WH), kind, owner, doors, ledges, bldg


# ---------------------------------------------------------------- HeartGold's buildings for the GBA's doors
HGB_JSON = os.path.join(HERE, 'data', 'hg_buildings.json')
HG_REV = '7eef3ae8'        # (a commit with HeartGold's own Kanto in the matrix and its towns' warps: read once, kept)


def hg_buildings():
    """-> {HeartGold room map: (building model, (dx, dz) of the model from the door square's middle, door model or
    None, its (dx, dz), the model's box)} read off HeartGold's own towns (as they were: HG_REV), kept in
    data/hg_buildings.json"""
    if os.path.exists(HGB_JSON):
        return {k: (v[0], tuple(v[1]), v[2], tuple(v[3]) if v[3] else None, v[4]) for k, v in json.load(open(HGB_JSON)).items()}
    out = _hg_buildings()
    json.dump(out, open(HGB_JSON, 'w'), indent=0, sort_keys=True)
    return out


def _git(path):
    import subprocess
    return subprocess.run(['git', 'show', '%s:%s' % (HG_REV, os.path.relpath(path, slots.ROOT))], cwd=slots.ROOT,
                          capture_output=True, check=True).stdout


def _hg_buildings():
    import interior_kit as IK
    from nitro import read_narc
    bm = read_narc(open(os.path.join(slots.ROOT, 'files/a/0/4/0'), 'rb').read())[0]

    def box(mid):
        d = bm[mid]
        off = struct.unpack_from('<I', d, 0x10)[0]; dic = off + 8
        ent = dic + struct.unpack_from('<H', d, dic + 6)[0]
        m = off + struct.unpack_from('<I', d, ent + 4)[0]
        bx = [v / 4096 for v in struct.unpack_from('<6h', d, m + 0x2C)]; bs = struct.unpack_from('<i', d, m + 0x38)[0] / 4096
        return [v * bs for v in bx]
    d = _git(os.path.join(slots.MATRIX_DIR, 'map_matrix_0000_EVERYWHERE.bin'))
    w, h, hh, ha, nl = d[:5]
    hdr = struct.unpack_from('<%dH' % (w * h), d, 5 + nl); ls = struct.unpack_from('<%dH' % (w * h), d, 5 + nl + 3 * w * h)
    L = hgworld.lands()
    props = []
    for cz in range(h):
        for cx in range(w):
            lid = ls[cz * w + cx]
            if lid == 0xFFFF or not hdr[cz * w + cx] or lid >= len(L): continue
            d = L[lid]
            ps, bs, ms, hs, mg, ss = struct.unpack_from('<4I2H', d, 0)
            if mg != 0x1234: ss = 0
            for i in range(bs // 48):
                mdl, x, y, z = struct.unpack_from('<I3i', d, 0x14 + ss + ps + i * 48)
                props.append((mdl, cx * 32 + 16 + x / 4096 / 16, cz * 32 + 16 + z / 4096 / 16, y / 4096))
    out = {}
    import re
    names = {}
    for l in open(os.path.join(slots.ROOT, 'include/constants/maps.h')):
        m = re.match(r'#define (MAP_\w+)\s+(\d+)', l)
        if m: names[int(m.group(2))] = m.group(1)
    towns = {names[v] for v in set(hdr) if v and v in names}
    for town in towns:
        try: ev = json.loads(_git(os.path.join(slots.EVENT_DIR, slots.events_file(town))))
        except Exception: continue
        for wp in ev.get('warps', []):
            room = wp['header']
            if room in out: continue
            wx, wz = wp['x'] + 0.5, wp['z'] + 0.5
            near = [(abs(px - wx) + abs(pz - wz), mdl, px, pz, py) for mdl, px, pz, py in props if abs(px - wx) < 9 and -12 < pz - wz < 3]
            # (the building: a big model whose box spans the door's column, its front at the door)
            big = [n for n in near if (lambda b: b[3] > 40 and n[2] + b[0] / 16 - 0.3 <= wx <= n[2] + (b[0] + b[3]) / 16 + 0.3
                                       and n[3] + (b[2] + b[5]) / 16 > wz - 1.5)(box(n[1]))]
            small = [n for n in near if (lambda b: b[3] <= 40 and b[4] > 18)(box(n[1])) and n[0] < 1.6]
            if not big: continue
            b = min(big)
            dm = min(small) if small else None
            out[room] = (b[1], (b[2] - wx, b[3] - wz), dm[1] if dm else None, (dm[2] - wx, dm[3] - wz) if dm else None, box(b[1]))
    return out


# ---------------------------------------------------------------- laying the world's lands
GROUND = 'grass01gs'
SKIN = {'grass': GROUND, 'flower': GROUND, 'sand': 'road01', 'pave': 'road01', 'door': None}
EDGE = {'sand': 'road01_r', 'pave': 'road01_r'}     # (HeartGold's road and its edge in the grass beside it: its Kanto
                                                    # towns' streets are the same road as its routes')
ROCK_TOP = 'cliff01gs'
DOOR_MB = 0x69
CAVE_MB = 0x6E              # (HeartGold's cave mouths: walked into)
CAVE_MOUTH = json.load(open(os.path.join(HERE, 'data', 'cave_mouth.json')))     # (its arch, off Route 11's land)
SIGN_MODEL = 29


def gba_dest():
    """GBA room map id -> HeartGold room map (the porter's DEST)"""
    sys.path.insert(0, os.path.join(HERE, 'port'))
    import io, contextlib
    with contextlib.redirect_stdout(io.StringIO()):
        import port_map
    return port_map.DEST


TOWNISH = ('City', 'Town', 'Academy', 'Plateau', 'Island')
HOUSE, HOUSE_DOOR, HOUSE_SIZE = 297, 307, 4.75     # (Fuchsia's house, its door; 4.75 squares a side)


def _houses(x0, z0, w, h):
    """HeartGold houses filling a block w x h squares at x0, z0: as many as fit, each squeezed or stretched a little
    to share it out"""
    nx, nz = max(1, round(w / HOUSE_SIZE)), max(1, round(h / HOUSE_SIZE))
    sx, sz = w / nx / HOUSE_SIZE, h / nz / HOUSE_SIZE
    out = []
    for i in range(nx):
        for j in range(nz):
            # (the model's box: 2.25 west of it to 2.5 east, 2.625 north to 2.125 south; its door 1 south of it)
            cx, cz = x0 + i * w / nx + 2.25 * sx, z0 + (j + 1) * h / nz - 2.125 * sz
            sc = (sx, min(sx, sz), sz)
            out.append((HOUSE, cx, cz, 0, sc))
            out.append((HOUSE_DOOR, cx + 0.125 * sx, cz + 1.0 * sz, 0, sc))
    return out


GATE_NS, GATE_EW = 246, 247     # HeartGold's gatehouses: doors on the north and south faces, or the west and east


def _gates(doors, dest, hgb, bldg, kind):
    """The gatehouses (a room HeartGold has a gatehouse for, or one the GBA's doors face each other into): HeartGold's
    gatehouse model, its doors on the GBA's - stretched or squeezed between them where the GBA has both (its two
    faces 8 squares apart north to south, 7 west to east). -> {room: (props, closed squares, door squares)}"""
    by_room = {}
    for gx, gz, d, w in doors:
        room = dest.get(w['dest_map'])
        if room and (hgb.get(room, (None,))[0] in (GATE_NS, GATE_EW) or ('GATE' in room and room not in hgb)):
            by_room.setdefault(room, []).append((gx, gz))
    out = {}
    for room, ds in by_room.items():
        cl = []                                  # (the doors, two squares each: a cluster a face)
        for q in sorted(ds):
            c = next((c for c in cl if any(abs(q[0] - r[0]) + abs(q[1] - r[1]) <= 1 for r in c)), None)
            (c.append(q) if c else cl.append([q]))
        mid = lambda c: (sum(q[0] for q in c) / len(c), sum(q[1] for q in c) / len(c))
        if len(cl) >= 2:
            (ax, az), (bx_, bz) = mid(cl[0]), mid(cl[1])
            ns = abs(bz - az) >= abs(bx_ - ax)
        else:
            (ax, az) = mid(cl[0])
            # (which side of the door the gatehouse is: the side the GBA has closed)
            shut = lambda q: kind.get(q) in ('house', 'stone', 'door', 'fence', 'rock')
            side = {d: sum(shut((q[0] + d[0] * k, q[1] + d[1] * k)) for q in cl[0] for k in (1, 2, 3))
                    for d in ((0, -1), (0, 1), (-1, 0), (1, 0))}
            d = max(side, key=side.get)
            cx_, cz_ = ax + d[0] * 3, az + d[1] * 3
            ns = d[1] != 0
        ps, closed = [], set()
        if ns:
            if len(cl) >= 2:
                zn, zs = sorted([mid(c)[1] for c in cl[:2]])
                sc = max(0.6, min(1.3, (zs - zn) / 8)); cz = zn + 0.5 + 5.5 * sc
            else:
                sc = 1.0
                cz = az + 0.5 - 2.5 if cz_ < az else az + 0.5 + 5.5
            cx = (sum(mid(c)[0] for c in cl) / len(cl)) + 0.5
            ps.append((GATE_NS, cx, cz, 0, (1, 1, sc)))
            closed = {(x, z) for x in range(math.floor(cx - 3 + 0.35), math.ceil(cx + 3.25 - 0.35)) for z in range(math.floor(cz - 4.25 * sc + 0.35), math.ceil(cz + 3.5 * sc - 0.35))}
        else:
            if len(cl) >= 2:
                xw, xe = sorted([mid(c)[0] for c in cl[:2]])
                sc = max(0.6, min(1.3, (xe - xw) / 7)); cx = xw + 0.5 + 3.5 * sc
            else:
                sc = 1.0
                cx = ax + 0.5 + 3.5 if cx_ > ax else ax + 0.5 - 3.5
            cz = (sum(mid(c)[1] for c in cl) / len(cl)) + 0.5
            ps.append((GATE_EW, cx, cz, 0, (sc, 1, 1)))
            closed = {(x, z) for x in range(math.floor(cx - 3.75 * sc + 0.35), math.ceil(cx + 3.75 * sc - 0.35)) for z in range(math.floor(cz - 2.75 + 0.35), math.ceil(cz + 3.0 - 0.35))}
        dq = {q for c in cl for q in c}
        out[room] = (ps, closed - dq, dq)
    return out


def plan_world(W=None, woods=False):
    """everything the lands need, worked out once: kinds, trees, buildings and their squares, warps"""
    W_, (WW, WH), kind, owner, doors, ledges, bldg = world_kinds(W, woods)
    orig = dict(kind)
    dest = gba_dest()
    hgb = hg_buildings()
    walkable = ('grass', 'sand', 'pave', 'tall', 'flower', 'door', 'stairs')
    # buildings: HeartGold's for the room each door leads to, its door on the GBA's door; the squares its box covers
    # (more than a third, to its door's row) closed. A door that leads nowhere HeartGold has a building for is a
    # warp on its square, the GBA's building squares left as stones
    props, stands, door_sq, warps, done = [], set(), set(), {}, set()
    all_warps = [(x0 + wp['x'], y0 + wp['y'], d, wp) for d, (x0, y0, w, h) in W_.items() for wp in gba_map.map_json(d).get('warp_events', [])]
    gates = {} if woods else _gates(all_warps, dest, hgb, bldg, kind)      # (a forest's ways out are its edges)
    for room, (gprops, gstands, gdoors) in gates.items():
        props += gprops; stands |= gstands; door_sq |= gdoors
        done |= {(bldg.get(q), room) for q in gdoors}
    # (a way in the GBA draws in a rock face that HeartGold has a building for - the Pokemon Tower, the Power Plant -
    # is that building's door)
    is_door = {(gx, gz) for gx, gz, *_ in doors}
    doors = doors + [(gx, gz, d, wp['x'], wp['y']) for gx, gz, d, wp in all_warps if (gx, gz) not in is_door and not woods
                     and hgb.get(dest.get(wp['dest_map'])) and dest.get(wp['dest_map']) not in gates and 'VICTORY' not in dest.get(wp['dest_map'])]
    for gx, gz, d, x, y in doors:
        gm = gba_map.map_json(d)
        w = next(w for w in gm['warp_events'] if (w['x'], w['y']) == (x, y))
        room = dest.get(w['dest_map'])
        b = hgb.get(room)
        warps[(gx, gz)] = (d, w)
        if not b or room in gates:
            continue
        mdl, (mdx, mdz), dmdl, dd, bx = b
        if dmdl is not None: props.append((dmdl, gx + 0.5 + dd[0], gz + 0.5 + dd[1], 0))
        door_sq.add((gx, gz))
        if (bldg.get((gx, gz)), room) in done: continue      # (up already: a gate's other door, to the same room)
        done.add((bldg.get((gx, gz)), room))
        # (HeartGold's building fitted to the GBA's: squeezed or stretched a little to the closed squares round the
        # door - up the door's column, along the row above it - its door kept on the GBA's)
        shut = lambda q: orig.get(q) not in walkable and orig.get(q) not in (None, 'water', 'woods', 'tall')
        top = gz
        while shut((gx, top - 1)) and gz - top < 12: top -= 1
        lx = rx = gx
        while shut((lx - 1, gz - 1)) and gx - lx < 12: lx -= 1
        while shut((rx + 1, gz - 1)) and rx - gx < 12: rx += 1
        gw, gh = rx - lx + 1, gz - top + 1
        sx = max(0.75, min(1.1, gw / (bx[3] / 16))) if gw >= 3 else 1.0
        sz = max(0.75, min(1.1, gh / (bx[5] / 16))) if gh >= 3 else 1.0
        cx, cz = gx + 0.5 + mdx * sx, gz + 0.5 + mdz * sz
        props.append((mdl, cx, cz, 0, (sx, min(sx, sz), sz)))
        x0, x1 = cx + bx[0] / 16 * sx, cx + (bx[0] + bx[3]) / 16 * sx
        z0 = cz + bx[2] / 16 * sz
        st = {(qx, qz) for qx in range(math.floor(x0 + 0.35), math.ceil(x1 - 0.35)) for qz in range(math.floor(z0 + 0.35), gz + 1)}
        st = {q for q in st if not (orig.get(q) in walkable and q not in door_sq and q != (gx, gz))}    # (the GBA's open squares stay open)
        stands |= st
        door_sq.add((gx, gz))
        if (gx, gz) not in is_door:
            # (the rock the GBA drew it in - the Tower's walls - is ground round it, if it's no mountain: a small patch)
            comp = {q for q in st if kind.get(q) == 'rock'}
            todo = list(comp)
            while todo and len(comp) <= 160:
                q = todo.pop()
                for n in ((q[0] + 1, q[1]), (q[0] - 1, q[1]), (q[0], q[1] + 1), (q[0], q[1] - 1)):
                    if n not in comp and kind.get(n) == 'rock': comp.add(n); todo.append(n)
            if len(comp) <= 160:
                for q in comp - st: kind[q] = 'grass'
    for d, (x0, y0, w, h) in W_.items():
        for wp in gba_map.map_json(d).get('warp_events', []):
            warps.setdefault((x0 + wp['x'], y0 + wp['y']), (d, wp))
    for q in stands:
        if kind.get(q) in ('house', 'stone', 'grass', 'sand', 'pave', 'flower', 'fence', 'hedge', 'rock') and q not in door_sq: kind[q] = 'house'
    # (the GBA's building squares HeartGold's building leaves are open ground, as the road or grass round them; a
    # building HeartGold has none for is a house of Fuchsia's over its squares, centred - as the Safari Zone's)
    have = {b for b, _ in done}
    by_b = {}
    for q, b in bldg.items(): by_b.setdefault(b, []).append(q)
    for b, sq in by_b.items():
        if b in have: continue
        dr = [q for q in sq if q in warps]
        if not dr: continue
        dx, dz = dr[0]
        ox, oz = dx + 1.0, dz - 1.0                     # (its door on the GBA's: HeartGold's Fuchsia house's offsets)
        props.append((HOUSE, ox, oz, 0)); props.append((HOUSE_DOOR, ox + 0.125, oz + 1.0, 0))
        st = {(qx, qz) for qx in range(math.floor(ox - 2.25 + 0.35), math.ceil(ox + 2.5 - 0.35)) for qz in range(math.floor(oz - 2.625 + 0.35), dz + 1)}
        stands |= st
        door_sq.add((dx, dz))
        for q in st:
            if q != (dx, dz) and kind.get(q) in ('house', 'stone', 'grass', 'sand', 'pave', 'flower', 'fence', 'hedge'): kind[q] = 'house'
    # (a block of closed squares with no door: in a town a building - HeartGold's houses, as many as fit; on a route
    # a crag, its rock)
    # (and a building of the GBA's whose door leads to a room another building's door also reached - joined to it
    # by the walls between them - once that one is up: what's left of it, if it stands apart)
    seen = set()
    _fs = lambda q: q not in stands and q not in door_sq and kind.get(q) == 'stone' and q not in bldg
    # (only squares in a 2x2 of them: a wall along a block is a wall, not part of it)
    in2 = lambda f: lambda q: f(q) and any(all(f((q[0] + a + i, q[1] + b + j)) for i in (0, 1) for j in (0, 1)) for a in (-1, 0) for b in (-1, 0))
    free_stone = in2(_fs)
    free_house = in2(lambda q: q not in stands and q not in door_sq and kind.get(q) == 'house')
    for free, q0 in [(free_stone, q) for q in list(kind)] + [(free_house, q) for q in list(kind)]:
        if q0 in seen or not free(q0): continue
        comp, i = [q0], 0
        seen.add(q0)
        while i < len(comp):
            x, y = comp[i]; i += 1
            for n in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if n not in seen and free(n): seen.add(n); comp.append(n)
        xs, ys = [c[0] for c in comp], [c[1] for c in comp]
        bw, bh = max(xs) - min(xs) + 1, max(ys) - min(ys) + 1
        housey = any(kind[c] == 'house' for c in comp)
        if bw < 2 or bh < 2 or len(comp) < 0.6 * bw * bh: continue
        if housey and (bw < 3 or bh < 3 or len(comp) < 0.7 * bw * bh or
                       any((c[0] + a, c[1] + b) in stands for c in comp for a, b in ((1, 0), (-1, 0), (0, 1), (0, -1)))): continue
        if any(t in owner.get(q0, '') for t in TOWNISH):
            props += _houses(min(xs), min(ys), bw, bh)
            for c in comp: kind[c] = 'house'; stands.add(c)
        elif len(comp) >= 6 and not housey:
            for c in comp: kind[c] = 'rock'
    # (stones in a line - a town's wall - are a fence)
    snap = dict(kind)
    for (x, y), v in snap.items():
        if v == 'stone' and (x, y) not in bldg and any(snap.get(n) in ('stone', 'fence') for n in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1))):
            kind[(x, y)] = 'fence'
    for q, v in list(kind.items()):
        if v == 'house' and q not in stands:
            nb = [kind.get((q[0] + a, q[1] + b)) for a, b in ((0, 1), (0, -1), (1, 0), (-1, 0))]
            kind[q] = next((r for r in ('pave', 'sand') if nb.count(r) >= 1), 'grass')
    # trees: one to a 2x2 block of woods, the blocks never overlapping, the woods' edge first (build_safari)
    full = lambda x, y: all(kind.get((x + a, y + b)) == 'woods' for a in (0, 1) for b in (0, 1))
    walk = [q for q, v in kind.items() if v in walkable or v == 'water']
    dist, ring = {q: 0 for q in walk}, list(walk)
    while ring:
        nxt = []
        for (x, y) in ring:
            for n in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if n in kind and n not in dist and dist[(x, y)] < 6: dist[n] = dist[(x, y)] + 1; nxt.append(n)
        ring = nxt
    blocks = sorted(((min(dist.get((x + a, y + b), 99) for a in (0, 1) for b in (0, 1)), y, x) for (x, y) in kind if full(x, y)))
    trees, covered = [], set()
    for _, y, x in blocks:
        if not any((x + a, y + b) in covered for a in (0, 1) for b in (0, 1)):
            trees.append((x, y)); covered |= {(x + a, y + b) for a in (0, 1) for b in (0, 1)}
    loose = {q for q, v in kind.items() if v == 'woods' and q not in covered and dist.get(q, 99) <= 1}
    # the town each land belongs to (the GBA map with most of its squares)
    cell_map = {}
    for cz in range(WH // 32):
        for cx in range(WW // 32):
            c = {}
            for gz in range(cz * 32, cz * 32 + 32):
                for gx in range(cx * 32, cx * 32 + 32):
                    if (gx, gz) in owner: c[owner[(gx, gz)]] = c.get(owner[(gx, gz)], 0) + 1
            cell_map[(cx, cz)] = max(c, key=c.get) if c else None
    # (every door can be walked up to: the GBA's open squares beside it stay open, whatever building stands there)
    for q in set(door_sq) | set(warps):
        for n in ((q[0], q[1] + 1), (q[0], q[1] - 1), (q[0] + 1, q[1]), (q[0] - 1, q[1])):
            if orig.get(n) in walkable and kind.get(n) == 'house' and n not in door_sq: kind[n] = orig[n]
    # (a way in at the foot of a rock face: a cave's mouth, HeartGold's arch in the face)
    caves = {q for q in warps if q not in door_sq and kind.get((q[0], q[1] - 1)) == 'rock' and kind.get(q) != 'house'}
    return dict(W=W_, size=(WW, WH), kind=kind, owner=owner, ledges=ledges, props=props, door_sq=door_sq, warps=warps, caves=caves,
                trees=trees, loose=loose, cell_map=cell_map)


def build_land(P, cx, cz):
    """one land: the world's squares cx*32.., cz*32.."""
    kind, ledges = P['kind'], P['ledges']
    K_ = lambda x, y: kind.get((x, y))
    dims, pals = texdims(TEXSET)
    pal_of = lambda t: next(q for q in (t + '_pl', t, t.replace('gs', ''), t.replace('gs', '') + '_pl') if q in pals)
    ox, oz = cx * 32, cz * 32
    X0, X1, Z0, Z1 = ox, ox + 32, oz, oz + 32
    mine = lambda x, y: X0 <= x < X1 and Z0 <= y < Z1
    U = lambda v, o: (v - o) * 16 - 256
    meshes = {}
    M = lambda t: meshes.setdefault(t, Mesh())
    up = (0, 1, 0)

    def poly(tex, pts):
        # (texture coordinates brought near zero by whole textures: the world's are past what the DS can hold)
        tw, th = dims[tex]
        s0 = math.floor(min(st[0] for _, st in pts) / tw) * tw; t0 = math.floor(min(st[1] for _, st in pts) / th) * th
        vs = [((x_ - ox * 16 - 256, y_, z_ - oz * 16 - 256), (st[0] - s0, st[1] - t0)) for (x_, y_, z_), st in pts]
        if len(vs) == 4: M(tex).quad(vs, up)
        elif len(vs) == 3: M(tex).tri(vs, up)
        else:
            for i in range(1, len(vs) - 1): M(tex).tri([vs[0], vs[i], vs[i + 1]], up)

    def flat(tex, x0, z0, x1, z1, h, per=16):
        poly(tex, [((x0 * 16, h, z1 * 16), (x0 * per, z1 * per)), ((x1 * 16, h, z1 * 16), (x1 * per, z1 * per)),
                   ((x1 * 16, h, z0 * 16), (x1 * per, z0 * per)), ((x0 * 16, h, z0 * 16), (x0 * per, z0 * per))])

    def piece(x, y, parts, base, ground):
        for tex, pts in parts:
            if tex in ('ground', 'top'):
                t_ = ground if tex == 'ground' else ROCK_TOP
                poly(t_, [((x * 16 + u, base + (h if tex == 'ground' else R.TIER), y * 16 + v), (x * 16 + u, y * 16 + v)) for u, v, h, s, t in pts])
            else:
                poly(tex, [((x * 16 + u, base + h, y * 16 + v), (s, t)) for u, v, h, s, t in pts])
    # the ground's skin under each square: the GBA's things stand on grass, or on the road beside them
    skin_k = lambda x, y: K_(x, y) if K_(x, y) in SKIN else 'grass'
    roads = {k: {q for q, v in kind.items() if v == k and abs(q[0] - (X0 + 16)) < 18 and abs(q[1] - (Z0 + 16)) < 18} for k in EDGE}
    under = {}
    for y in range(Z0 - 1, Z1 + 1):
        for x in range(X0 - 1, X1 + 1):
            k = K_(x, y)
            if k in ('house', 'door', 'stone', 'sign', 'fence', 'hedge'):
                nb = [K_(x + a, y + b) for a, b in ((0, 1), (0, -1), (1, 0), (-1, 0))]
                r = next((v for v in ('pave', 'sand') if nb.count(v) >= 2), None)
                if r: roads[r].add((x, y)); under[(x, y)] = r
    road_of = lambda x, y: under.get((x, y)) or (K_(x, y) if K_(x, y) in EDGE else None)
    tall = {q for q, v in kind.items() if v == 'tall' and abs(q[0] - (X0 + 16)) < 18 and abs(q[1] - (Z0 + 16)) < 18}
    water = {q for q, v in kind.items() if v == 'water' and abs(q[0] - (X0 + 16)) < 18 and abs(q[1] - (Z0 + 16)) < 18}
    level = lambda x, y: 1 if K_(x, y) == 'rock' else 0
    perm = [0x8000] * 1024
    props = []
    edged = {}
    for y in range(Z0, Z1):
        runs = []
        for x in range(X0, X1):
            k = K_(x, y)
            r = road_of(x, y)
            if k in ('water', 'rock'): tex = None
            elif r: tex = SKIN[r]
            else:
                nb = {rr: BS._sand_nb(roads[rr], x, y) for rr in EDGE}
                e = next(((rr, v) for rr, v in nb.items() if v), None)
                if e: edged[(x, y)] = e; tex = None
                else: tex = GROUND
            if runs and runs[-1][0] == tex and runs[-1][2] == x: runs[-1][2] = x + 1
            else: runs.append([tex, x, x + 1])
        for tex, a, b in runs:
            if tex: flat(tex, a, y, b, y + 1, 0)
        x = X0
        while x < X1:
            if (x, y) not in tall: x += 1; continue
            e = x
            while e < X1 and (e, y) in tall: e += 1
            flat('egrass', x, y, e, y + 1, R.GRASS_Y)
            x = e
    bands_u, bands_v, pond_runs, rock_tops, open_water, faces = {}, {}, {}, {}, {}, {}
    for y in range(Z0, Z1):
        for x in range(X0, X1):
            k = K_(x, y)
            i = (y - oz) * 32 + (x - ox)
            if k in ('grass', 'sand', 'pave', 'flower', 'stairs'): perm[i] = 0x0000
            elif k == 'tall': perm[i] = 0x0002
            elif k == 'water': perm[i] = 0x0010
            if (x, y) in ledges:
                dx, dz = ledges[(x, y)]
                perm[i] = {(1, 0): 0x38, (-1, 0): 0x39, (0, -1): 0x3A, (0, 1): 0x3B}[(dx, dz)]
            if (x, y) in P['door_sq']: perm[i] = DOOR_MB | 0x8000
            elif (x, y) in P['caves']:
                perm[i] = CAVE_MB
                for tex, pts in CAVE_MOUTH:        # (HeartGold's arch: 29 high in its cliffs, ours are 16)
                    poly(tex, [((x * 16 + 16 * dx, y_ * 0.53, y * 16 + 16 * dz), (s_, t_)) for dx, y_, dz, s_, t_ in pts])
            elif (x, y) in P['warps'] and k not in ('house',):
                perm[i] = 0x65 if K_(x, y + 1) in (None, 'house', 'woods', 'rock', 'fence', 'stone') and K_(x, y - 1) in ('grass', 'sand', 'pave') else 0x3E
            if (x, y) in edged:
                rr, nb = edged[(x, y)]
                BS._sand_edge(lambda tex, pts, rr=rr: poly(EDGE[rr] if tex == 'road01_r' else tex, pts), nb, x, y)
            if k == 'water':
                # the water: its middle in runs; a bank down into it along each side it meets land (a strip of
                # HeartGold's bank a side: laid by distance a thin channel came to thousands of polygons a land)
                open_water.setdefault(y, []).append(x)
                for dx, dz in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                    if (x + dx, y + dz) in water or K_(x + dx, y + dz) is None: continue
                    X, Z = x * 16, y * 16
                    if dz: e = Z + (16 if dz > 0 else 0); a_, b_ = (X, e), (X + 16, e); inw = (0, -dz * 5)
                    else: e = X + (16 if dx > 0 else 0); a_, b_ = (e, Z + 16), (e, Z); inw = (-dx * 5, 0)
                    poly('pond_line', [((a_[0], 0, a_[1]), (0, 0)), ((b_[0], 0, b_[1]), (16, 0)), ((b_[0] + inw[0], R.WATER_Y, b_[1] + inw[1]), (16, 15.6)), ((a_[0] + inw[0], R.WATER_Y, a_[1] + inw[1]), (0, 15.6))])
            elif k == 'rock':
                lower = [(dx, dz) for dx in (-1, 0, 1) for dz in (-1, 0, 1) if (dx or dz) and K_(x + dx, y + dz) is not None and not level(x + dx, y + dz)]
                if not lower: rock_tops.setdefault(y, []).append(x)
                else:
                    n0 = next((n for n in R.SIDE if n in lower), lower[0])
                    rr = road_of(x + n0[0], y + n0[1])
                    ground = SKIN[rr] if rr else GROUND
                    look = dict(R.LOOK, foot='wall01_h' if rr else 'wall01_g')
                    ck, what = K.classify(lower)
                    if ck == 'straight':        # (straight faces in runs along their row or column: a quad a band)
                        faces.setdefault((what, look['foot'], y if what[1] else x), []).append((x, y))
                    else:
                        piece(x, y, R.rock_piece(lower, x, y, BS.LAND_NARC, look), 0, ground)
            if (x, y) in ledges:          # (a ledge: a lip of rock along its way down)
                dx, dz = ledges[(x, y)]
                X, Z = x * 16, y * 16
                if dz: zz = Z + (16 if dz > 0 else 0); a, b = (X, zz), (X + 16, zz)
                else: xx = X + (16 if dx > 0 else 0); a, b = (xx, Z), (xx, Z + 16)
                poly('wall01_h', [((a[0], -1, a[1]), (a[0] + a[1], 16)), ((b[0], -1, b[1]), (b[0] + b[1], 16)), ((b[0] - dx * 3, 5, b[1] - dz * 3), (b[0] + b[1], 4)), ((a[0] - dx * 3, 5, a[1] - dz * 3), (a[0] + a[1], 4))])
            if k not in ('tall', 'water', 'rock'):
                for tex, u0, v0, (s0, t0) in R.grass_edges(tall, x, y):
                    if tex == 'egrass_u': bands_u.setdefault((y * 2 + v0 // 8, t0), set()).add(x * 2 + u0 // 8)
                    elif tex == 'egrass_v': bands_v.setdefault((x * 2 + u0 // 8, s0), set()).add(y * 2 + v0 // 8)
                    else:
                        xa, za = x * 16 + u0, y * 16 + v0
                        poly(tex, [((xa, R.GRASS_Y, za + 8), (s0, t0 + 8)), ((xa + 8, R.GRASS_Y, za + 8), (s0 + 8, t0 + 8)),
                                   ((xa + 8, R.GRASS_Y, za), (s0 + 8, t0)), ((xa, R.GRASS_Y, za), (s0, t0))])
            if k == 'flower':
                poly('flower01' if (x + y) % 2 else 'flower02', [((x * 16, 1, y * 16 + 16), (0, 16)), ((x * 16 + 16, 1, y * 16 + 16), (16, 16)), ((x * 16 + 16, 1, y * 16), (16, 0)), ((x * 16, 1, y * 16), (0, 0))])
            if k == 'hedge' or (x, y) in P['loose']: BS._card(poly, 'bush', x, y)
            elif k == 'stone': BS._card(poly, 'stone', x, y)
            elif k == 'fence':
                if K_(x - 1, y) == 'fence' or K_(x + 1, y) == 'fence': BS._card(poly, 'fence', x, y)
                else: BS._card(poly, 'post', x, y)
            elif k == 'sign':
                props.append((SIGN_MODEL, U(x + 0.5, ox), 0, U(y + 0.35, oz)))
    for y, xs in open_water.items():         # (open water, in runs: the water as the pond's middle has it)
        for a, b in BS._runs(sorted(xs)): flat('pond_on', a, y, b, y + 1, R.WATER_Y)
    for y, xs in rock_tops.items():
        for a, b in BS._runs(sorted(xs)): flat(ROCK_TOP, a, y, b, y + 1, R.TIER)
    for (what, foot, line), sqs in faces.items():
        along = 0 if what[1] else 1
        pos = sorted(q[along] for q in sqs)
        look = dict(R.LOOK, foot=foot)
        for a, b in BS._runs(pos):
            qa = (a, line) if along == 0 else (line, a)
            qb = (b - 1, line) if along == 0 else (line, b - 1)
            A, B = R.straight(what, qa[0], qa[1], look), R.straight(what, qb[0], qb[1], look)
            for (tex, pa), (_, pb) in zip(A, B):
                w = lambda q, v: ((q[0] * 16 + v[0], v[2], q[1] * 16 + v[1]), (v[3], v[4]))
                poly(tex, [w(qa, pa[0]), w(qb, pb[1]), w(qb, pb[2]), w(qa, pa[3])])
    for (n, line), along in pond_runs.items():
        for a, b in BS._runs(sorted(along)):
            BS._pond_run(poly, n, line, a, b)
    for (zh, t0), xs in bands_u.items():
        for a, b in BS._runs(sorted(xs)):
            xa, xb, za = a * 8, b * 8, zh * 8
            poly('egrass_u', [((xa, R.GRASS_Y, za + 8), (xa, t0 + 8)), ((xb, R.GRASS_Y, za + 8), (xb, t0 + 8)), ((xb, R.GRASS_Y, za), (xb, t0)), ((xa, R.GRASS_Y, za), (xa, t0))])
    for (xh, s0), zs in bands_v.items():
        for a, b in BS._runs(sorted(zs)):
            za, zb, xa = a * 8, b * 8, xh * 8
            poly('egrass_v', [((xa, R.GRASS_Y, zb), (s0, zb)), ((xa + 8, R.GRASS_Y, zb), (s0 + 8, zb)), ((xa + 8, R.GRASS_Y, za), (s0 + 8, za)), ((xa, R.GRASS_Y, za), (s0, za))])
    for (bx, by) in P['trees']:
        if not mine(bx, by): continue
        poly('tree01_un', [((bx * 16, 0, by * 16 + 32), (0, 32)), ((bx * 16 + 32, 0, by * 16 + 32), (32, 32)), ((bx * 16 + 32, 0, by * 16), (32, 0)), ((bx * 16, 0, by * 16), (0, 0))])
        BS._card(poly, 'tree', bx, by)
    for mdl, px, pz, py, *sc in P['props']:
        if mine(int(px), int(pz)): props.append((mdl, U(px, ox), py, U(pz, oz)) + tuple(sc))
    order = [t for t in BS.FIRST if t in meshes] + [t for t in meshes if t not in BS.FIRST and t not in BS.ANIM]
    groups = [(t, t if t in meshes else 'pond_on', pal_of(t if t in meshes else 'pond_on'), meshes.get(t, Mesh()),
               {'repeat': 3, 'size': dims[t if t in meshes else 'pond_on']}) for t in BS.ANIM] + \
             [(t, t, pal_of(t), meshes[t], {'repeat': 0 if t in ('tree01gs', 'etc_a', 'rock01', 'fence_b') else 3, 'size': dims[t]}) for t in order]
    model = build_model('cv_kanto_%d_%d' % (cx, cz), groups)
    model += b'\0' * (-len(model) % 4)
    f4 = lambda v: int(round(v * 4096))
    bld = b''.join(struct.pack('<I3i3i3i8x', m, f4(px), f4(py), f4(pz), 0, 0, 0, *[f4(v) for v in (sc[0] if sc else (1, 1, 1))])
                   for m, px, py, pz, *sc in props)
    KS = lambda x, y: {'rock': 'cliff', 'water': 'water'}.get(K_(x, y), 'grass')
    bdhc = BS._bdhc(KS, ox, oz, U)
    pm = struct.pack('<1024H', *perm)
    npoly = sum(len(m.quads) + len(m.tris) for m in meshes.values())
    return struct.pack('<4I2H', len(pm), len(bld), len(model), len(bdhc), 0x1234, 0) + pm + bld + model + bdhc, npoly, len(model)


# ---------------------------------------------------------------- into the game
WORLD_LAND_BASE = 1000      # our world's lands (interiors are 800 on); lands drawn the same are one land
WORLD_ALT = 2               # (the matrix's altitude, 8 a step: our ground at 0 is HeartGold's at 16, as Pallet's)
AREA = '18'                 # Pallet's area: set 18's textures, building set 17 (every building the world uses added)
BUILD_SET = 17
NEW_MAPS = {'Route23_Frlg': ('MAP_CANVAS_ROUTE_23', 'MAP_ROUTE_22'),          # (GBA maps HeartGold has no map for:
            'LeaderAcademy_Campus': ('MAP_CANVAS_LEADER_ACADEMY', 'MAP_SAFFRON')}    # ours, from a template's header)
WORLD_JSON = os.path.join(HERE, 'data', 'kanto_world.json')


def hg_map_of():
    """GBA outdoor map -> the HeartGold map its squares are"""
    sys.path.insert(0, os.path.join(HERE, 'port'))
    import port_map
    out = {}
    for k, v in port_map.MAPS_HG.items():
        if '#' in k: continue
        for part in k.split('+'): out.setdefault(part, v[0])
    for k, (m, _) in NEW_MAPS.items(): out[k] = m
    return out


def cell_headers(P, hgm):
    """world cell -> HeartGold map: the map with most of its squares; a cell no map reaches, its nearest's"""
    W, H = CELLS
    out = {c: hgm[d] for c, d in P['cell_map'].items() if d}
    w0, h0, hdr, alt, ls = hgworld.matrix()
    names = _map_names()
    for c in CUSTOM:
        out[c] = names[hdr[(ORIGIN[1] + c[1]) * w0 + ORIGIN[0] + c[0]]]
    ring = list(out)
    while ring:
        nxt = []
        for (x, y) in ring:
            for n in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if 0 <= n[0] < W and 0 <= n[1] < H and n not in out: out[n] = out[(x, y)]; nxt.append(n)
        ring = nxt
    return out


def _map_names():
    import re
    names = {}
    for l in open(os.path.join(slots.ROOT, 'include/constants/maps.h')):
        m = re.match(r'#define (MAP_\w+)\s+(\d+)', l)
        if m: names[int(m.group(2))] = m.group(1)
    return names


def _map_ids():
    return {v: k for k, v in _map_names().items()}


def new_maps():
    for gba, (m, tmpl) in NEW_MAPS.items():
        if m in slots.canvas_maps():
            try:
                slots.header(m); continue          # (made already)
            except Exception:
                pass
        slots.new_map(m)
        ev = json.load(open(os.path.join(slots.EVENT_DIR, slots.events_file(tmpl))))
        ev.update(bgs=[], objects=[], warps=[], coords=[])
        evn = slots.new_events_file(m.replace('MAP_', ''), ev)
        t = slots.header(tmpl)
        slots.set_header(m, dict(t, eventsBank=evn, **slots.NO_SCRIPTS))


def wire(P, hdr_of, hgm):
    """the doors: each HeartGold map's warps are the GBA's doors in its lands; each room's way out leads back to the
    door it was come in by"""
    from nitro import read_narc
    dest = gba_dest()
    world_maps = {hgm[d] for d in P['W']}
    is_outdoor = lambda m: m in world_maps or 'EVERYWHERE' in slots.header(m)['matrixId']
    per, by_room, skipped = {m: [] for m in set(hdr_of.values())}, {}, []
    for (wx, wz), (d, w) in sorted(P['warps'].items(), key=lambda kv: (kv[0][1], kv[0][0])):
        cell = (wx // 32, wz // 32)
        if cell in CUSTOM: continue                 # (Pallet's and Cinnabar's builders lay their own)
        room = dest.get(w['dest_map'])
        if room is None or room in world_maps:
            skipped.append((d, w['dest_map'])); continue
        X = hdr_of[cell]
        G = (ORIGIN[0] * 32 + wx, ORIGIN[1] * 32 + wz)
        per[X].append({'x': G[0], 'z': G[1], 'header': room, 'anchor': 0, 'y': 0})
        by_room.setdefault(room, []).append((X, len(per[X]) - 1, G, w))
    gba_built = set(slots.ROOM_SLOTS.values())
    path_of = lambda m: os.path.join(slots.EVENT_DIR, slots.events_file(m))
    for room, outs in by_room.items():
        ev = json.load(open(path_of(room)))
        Rw = ev['warps']
        if room in gba_built or room.startswith('MAP_CANVAS_'):
            for X, i, G, w in outs:
                j = int(w['dest_warp_id'])
                if j >= len(Rw): skipped.append((room, 'warp %d' % j)); continue
                per[X][i]['anchor'] = j
                Rw[j].update(header=X, anchor=i)
        else:
            exits = [j for j, rw in enumerate(Rw) if is_outdoor(rw['header'])]
            if not exits: skipped.append((room, 'no way out')); continue
            rc = _clusters([(j, (Rw[j]['x'], Rw[j]['z'])) for j in exits])
            oc = _clusters([((X, i), G) for X, i, G, w in outs])
            xs = [p for c in oc for _, p in c]
            along = 1 if max(p[1] for p in xs) - min(p[1] for p in xs) >= max(p[0] for p in xs) - min(p[0] for p in xs) else 0
            key = lambda c: sum(p[along] for _, p in c) / len(c)
            rc.sort(key=key); oc.sort(key=key)
            if len(oc) == 1 and len(rc) > 1: rc = [max(rc, key=lambda c: sum(p[1] for _, p in c))]   # (the front door)
            for k, o in enumerate(oc):
                r = rc[min(k, len(rc) - 1)]
                (X0, i0) = o[0][0]
                for (X, i), _ in o: per[X][i]['anchor'] = r[0][0]
                for j, _ in r: Rw[j].update(header=X0, anchor=i0)
        json.dump(ev, open(path_of(room), 'w'), indent=4); open(path_of(room), 'a').write('\n')
    for X, ws in per.items():
        if X in ('MAP_PALLET', 'MAP_CINNABAR_ISLAND'): continue
        ev = json.load(open(path_of(X)))
        ev['warps'] = ws
        json.dump(ev, open(path_of(X), 'w'), indent=4); open(path_of(X), 'a').write('\n')
    return skipped


def _clusters(items):
    """[(key, (x, z))] -> lists of them standing side by side"""
    left, out = list(items), []
    while left:
        c = [left.pop(0)]
        grown = True
        while grown:
            grown = False
            for it in list(left):
                if any(abs(it[1][0] - q[1][0]) + abs(it[1][1] - q[1][1]) <= 1 for q in c): c.append(it); left.remove(it); grown = True
        out.append(c)
    return out


WORLD_AREA_BASE = 140       # each map's area: set 18's textures, a building set of the models in and around its lands


def building_sets(P, hdr_of):
    """Each map of the world gets an area of its own (WORLD_AREA_BASE on: Pallet's area with a building set of its
    own) whose building set lists the models stood up in its lands and the lands round them, its texture file their
    textures; Pallet's own set (17: Pallet and Cinnabar) gets those round them. (All of them in one set came to
    100 KB of textures: the game crashes)"""
    from nitro import read_narc, write_narc, read_tex0, tex0_of, write_btx0, u16
    import build_rooms as BR
    sets, sets_btnf = read_narc(open(BR.AREA_BUILD, 'rb').read())
    atex, atex_btnf = read_narc(open(BR.AREA_BUILD_TEX, 'rb').read())
    areas, areas_btnf = read_narc(open(BR.AREA_DATA, 'rb').read())
    bm, _ = read_narc(open(os.path.join(slots.ROOT, 'files/a/0/4/0'), 'rb').read())
    in_cell = {}
    for m, px, pz, py, *_ in P['props']: in_cell.setdefault((int(px) // 32, int(pz) // 32), set()).add(m)
    for (x, y), k in P['kind'].items():
        if k == 'sign': in_cell.setdefault((x // 32, y // 32), set()).add(SIGN_MODEL)
    maps = sorted(set(hdr_of.values()))
    area_of, report = {}, []
    for n, X in enumerate(maps):
        mine = [c for c, m in hdr_of.items() if m == X]
        near = {(c[0] + a, c[1] + b) for c in mine for a in (-1, 0, 1) for b in (-1, 0, 1)}
        models = set().union(*[in_cell.get(c, set()) for c in near])
        if X in ('MAP_PALLET', 'MAP_CINNABAR_ISLAND'):
            k = BUILD_SET
        else:
            k = WORLD_AREA_BASE + n
            for lst in (sets, atex, areas): lst += [lst[BUILD_SET if lst is not areas else int(AREA)]] * max(0, k + 1 - len(lst))
            areas[k] = struct.pack('<H', k) + areas[int(AREA)][2:]
            sets[k], atex[k] = struct.pack('<H', 0), atex[BUILD_SET]
            area_of[X] = k
        ids = list(struct.unpack_from('<%dH' % u16(sets[k], 0), sets[k], 2)) if k == BUILD_SET else []
        ids += sorted(models - set(ids))
        sets[k] = struct.pack('<H%dH' % len(ids), len(ids), *ids)
        texs, pals = (read_tex0(atex[k], tex0_of(atex[k])) if k == BUILD_SET else ([], []))
        have_t, have_p = {t[0] for t in texs}, {q[0] for q in pals}
        for mid in ids:
            t0 = tex0_of(bm[mid])
            if t0 is None: continue
            mt, mp = read_tex0(bm[mid], t0)
            texs += [t for t in mt if t[0] not in have_t]; have_t |= {t[0] for t in mt}
            pals += [q for q in mp if q[0] not in have_p]; have_p |= {q[0] for q in mp}
        atex[k] = write_btx0(texs, pals)
        report.append((X, k, len(ids), len(atex[k])))
    open(BR.AREA_BUILD, 'wb').write(write_narc(sets, sets_btnf))
    open(BR.AREA_BUILD_TEX, 'wb').write(write_narc(atex, atex_btnf))
    open(BR.AREA_DATA, 'wb').write(write_narc(areas, areas_btnf))
    return area_of, report


def write_matrix(cells):
    """the EVERYWHERE matrix: {(matrix cx, cz): (land, header id, altitude)}; Kanto's other cells (east of Johto's
    Route 26) emptied"""
    path = os.path.join(slots.MATRIX_DIR, 'map_matrix_0000_EVERYWHERE.bin')
    d = bytearray(open(path, 'rb').read())
    w, h, hh, ha, nl = d[:5]
    p_h = 5 + nl; p_a = p_h + 2 * w * h; p_l = p_a + w * h
    for cz in range(h):
        for cx in range(ORIGIN[0] - 1, w):
            i = cz * w + cx
            if (cx, cz) in cells: land, hid, alt = cells[(cx, cz)]
            elif cx >= ORIGIN[0] or (cx, cz) == (ORIGIN[0] - 1, 8): land, hid, alt = 0xFFFF, 0, 0     # (and HeartGold's Route 22's west end)
            else: continue
            struct.pack_into('<H', d, p_h + 2 * i, hid); d[p_a + i] = alt; struct.pack_into('<H', d, p_l + 2 * i, land)
    open(path, 'wb').write(bytes(d))


SPAWNS = os.path.join(slots.ROOT, 'asm', 'unk_0203BA5C.s')


def spawns(hdr_of):
    """the fly points and the places you come back to (sSpawnMaps, in the ARM9's data: changed in place): in front
    of each town's Pokemon Center door in our world"""
    import re
    door = {}
    for X in set(hdr_of.values()):
        if X in ('MAP_PALLET', 'MAP_CINNABAR_ISLAND'): continue
        for w in json.load(open(os.path.join(slots.EVENT_DIR, slots.events_file(X))))['warps']:
            door.setdefault(w['header'], (X, w['x'], w['z'] + 1))
    lines, n = open(SPAWNS).read().split('\n'), 0
    for i, l in enumerate(lines):
        m = re.match(r'(\tspawn \w+, \d, \d, )(MAP_\w+)(, \d+, \d+, )(MAP_\w+), (\w+), (\w+), (MAP_\w+), (\w+), (\w+)$', l)
        if not m or m.group(2) not in door: continue
        X, x, z = door[m.group(2)]
        lines[i] = '%s%s%s%s, 0x%04X, 0x%04X, %s, 0x%04X, 0x%04X' % (m.group(1), m.group(2), m.group(3), X, x, z, X, x, z)
        n += 1
    open(SPAWNS, 'w').write('\n'.join(lines))
    return n


# GBA maps of the outdoors kind that are rooms of their own (a matrix of their own): laid as the world is, the map
# in the middle of its lands. GBA map: (HeartGold map, its corner in our lands, the lands across and down)
WOODS = {'ViridianForest_Frlg': ('MAP_VIRIDIAN_FOREST', (5, 13), (2, 3))}
WOODS_AREA = 199


def build_woods(land):
    """Viridian Forest on the GBA's layout: its lands (appended to `land`), its matrix, an area with the buildings it
    stands up (the gatehouse at each end), its warps the GBA's, the gatehouses' ways in leading to them"""
    from nitro import read_narc, write_narc, read_tex0, tex0_of, write_btx0, u16
    import build_rooms as BR
    dest = gba_dest()
    out = {}
    for gba, (m, (ox, oz), (nx, nz)) in WOODS.items():
        lay = gba_map.Layout(gba_map.map_json(gba)['layout'])
        P = plan_world(({gba: (ox, oz, lay.w, lay.h)}, (nx * 32, nz * 32)), woods=True)
        lids = []
        for cz in range(nz):
            for cx in range(nx):
                data, n, sz = build_land(P, cx, cz)
                assert sz < 61400, (gba, cx, cz, sz)
                lids.append(len(land)); land.append(data)
        mpath = os.path.join(slots.MATRIX_DIR, slots.matrix_file(m))
        d = bytearray(open(mpath, 'rb').read())
        w, h, hh, ha, nl = d[:5]
        assert (w, h) == (nx, nz), (m, w, h)
        p = 5 + nl + (2 * w * h if hh else 0) + (w * h if ha else 0)
        struct.pack_into('<%dH' % (w * h), d, p, *lids)
        open(mpath, 'wb').write(bytes(d))
        # its area: Pallet's look, a building set of its own
        sets, sets_btnf = read_narc(open(BR.AREA_BUILD, 'rb').read())
        atex, atex_btnf = read_narc(open(BR.AREA_BUILD_TEX, 'rb').read())
        areas, areas_btnf = read_narc(open(BR.AREA_DATA, 'rb').read())
        bm, _ = read_narc(open(os.path.join(slots.ROOT, 'files/a/0/4/0'), 'rb').read())
        k = WOODS_AREA
        for lst in (sets, atex, areas): lst += [lst[BUILD_SET if lst is not areas else int(AREA)]] * max(0, k + 1 - len(lst))
        areas[k] = struct.pack('<H', k) + areas[int(AREA)][2:]
        ids = sorted({mm for mm, *_ in P['props']} | ({SIGN_MODEL} if any(v == 'sign' for v in P['kind'].values()) else set()))
        sets[k] = struct.pack('<H%dH' % len(ids), len(ids), *ids)
        texs, pals, ht, hp = [], [], set(), set()
        for mid in ids:
            t0 = tex0_of(bm[mid])
            if t0 is None: continue
            mt, mp = read_tex0(bm[mid], t0)
            texs += [t for t in mt if t[0] not in ht]; ht |= {t[0] for t in mt}
            pals += [q for q in mp if q[0] not in hp]; hp |= {q[0] for q in mp}
        atex[k] = write_btx0(texs, pals)
        open(BR.AREA_BUILD, 'wb').write(write_narc(sets, sets_btnf))
        open(BR.AREA_BUILD_TEX, 'wb').write(write_narc(atex, atex_btnf))
        open(BR.AREA_DATA, 'wb').write(write_narc(areas, areas_btnf))
        slots.set_header(m, {'areaDataBank': str(k)})
        # its warps: the GBA's, in order; each gatehouse's way in leads to the first of the doors facing it
        path_of = lambda mm: os.path.join(slots.EVENT_DIR, slots.events_file(mm))
        ev = json.load(open(path_of(m)))
        gws = gba_map.map_json(gba)['warp_events']
        ev['warps'] = [{'x': ox + w_['x'], 'z': oz + w_['y'], 'header': dest[w_['dest_map']], 'anchor': 0, 'y': 0} for w_ in gws]
        for room in {dest[w_['dest_map']] for w_ in gws}:
            mine = [i for i, w_ in enumerate(gws) if dest[w_['dest_map']] == room]
            rev = json.load(open(path_of(room)))
            back = [j for j, rw in enumerate(rev['warps']) if rw['header'] == m]
            for i in mine: ev['warps'][i]['anchor'] = back[0] if back else 0
            for j in back: rev['warps'][j]['anchor'] = mine[0]
            json.dump(rev, open(path_of(room), 'w'), indent=4); open(path_of(room), 'a').write('\n')
        json.dump(ev, open(path_of(m), 'w'), indent=4); open(path_of(m), 'a').write('\n')
        out[gba] = [m, ox, oz]
        print('%s: lands %s, %d buildings' % (gba, lids, len(P['props'])))
    return out


def main():
    from nitro import read_narc, write_narc
    new_maps()
    P = plan_world()
    hgm = hg_map_of()
    hdr_of = cell_headers(P, hgm)
    ids = _map_ids()
    # the lands
    land, land_btnf = read_narc(open(BS.LAND_NARC, 'rb').read())
    land = land[:WORLD_LAND_BASE] + [b''] * max(0, WORLD_LAND_BASE - len(land))
    w0, h0, mhdr, malt, mls = hgworld.matrix()
    cells, seen, big = {}, {}, 0
    for cz in range(CELLS[1]):
        for cx in range(CELLS[0]):
            mc = (ORIGIN[0] + cx, ORIGIN[1] + cz)
            if (cx, cz) in CUSTOM:
                i = mc[1] * w0 + mc[0]
                cells[mc] = (mls[i], mhdr[i], malt[i]); continue
            data, n, sz = build_land(P, cx, cz)
            big = max(big, sz)
            if data not in seen:
                seen[data] = len(land); land.append(data)
            cells[mc] = (seen[data], ids[hdr_of[(cx, cz)]], WORLD_ALT)
    woods = build_woods(land)
    land = [d if d else land[209] for d in land]
    open(BS.LAND_NARC, 'wb').write(write_narc(land, land_btnf))
    write_matrix(cells)
    # the maps: Pallet's area, the world's look
    area_of, rep = building_sets(P, hdr_of)
    for m, k in area_of.items():
        slots.set_header(m, {'areaDataBank': str(k)})
    skipped = wire(P, hdr_of, hgm)
    print('fly points moved:', spawns(hdr_of))
    # what the porter needs: each GBA map's corner in HeartGold's squares, the map each land is
    json.dump({'origin': ORIGIN, 'maps': {d: [ORIGIN[0] * 32 + v[0], ORIGIN[1] * 32 + v[1], v[2], v[3]] for d, v in P['W'].items()},
               'hg': {d: hgm[d] for d in P['W']},
               'cells': {'%d,%d' % (ORIGIN[0] + c[0], ORIGIN[1] + c[1]): m for c, m in hdr_of.items()},
               'custom': ['%d,%d' % (ORIGIN[0] + c[0], ORIGIN[1] + c[1]) for c in CUSTOM], 'woods': woods},
              open(WORLD_JSON, 'w'), indent=1, sort_keys=True)
    print('world: %d lands (%d drawn alike shared), biggest model %d bytes; building sets up to %d models, %d bytes of textures'
          % (len(seen), CELLS[0] * CELLS[1] - len(CUSTOM) - len(seen), big, max(r[2] for r in rep), max(r[3] for r in rep)))
    for r in sorted(rep, key=lambda r: -r[3])[:6]: print('  ', r)
    for s_ in sorted(set(skipped)): print('  no door:', s_)


if __name__ == '__main__':
    main()
