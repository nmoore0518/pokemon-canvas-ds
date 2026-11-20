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
import hg_kit
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
# the GBA's wooden walkways, by its secondary tileset: Route 12 and 13's boardwalks (Lavender's set), Route 24's Nugget
# Bridge (Cerulean's), Vermilion's planks - each laid from HeartGold's own (hg_kit: Route 12's, Route 24's)
BRIDGE_MT = {'gTileset_LavenderTown': set(range(0x2F0, 0x2F6)) | set(range(0x2F8, 0x2FE)) | set(range(0x300, 0x306)) |
                                      set(range(0x310, 0x316)) | set(range(0x343, 0x34C)) | {0x34F},
             'gTileset_CeruleanCity': {0x2C6, 0x2CE, 0x2DD, 0x2DE, 0x2E5, 0x2E6},
             'gTileset_VermilionCity': {0x308, 0x309, 0x30A}}
BRIDGE_KIT = {'gTileset_CeruleanCity': 'nugget'}        # (the rest: 'boardwalk')
BRIDGE_CRATE = {0x2F0, 0x2F1, 0x2F2, 0x2F8, 0x2F9, 0x2FA, 0x300, 0x301, 0x302, 0x310, 0x311, 0x312}   # (its platforms)
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
SEA_ROUTES = {'Route19_Frlg', 'Route20_Frlg', 'Route21_North_Frlg', 'Route21_South_Frlg', 'CinnabarIsland_Frlg'}
ORIGIN = (30, 2)
CELLS = (14, 15)
PALLET_AT = (59, 288)
PLACED = {'CinnabarIsland_Frlg': (68, 419)}
CUSTOM = {(1, 9), (2, 9), (3, 9), (1, 10), (2, 10), (3, 10), (2, 13)}     # (world cells drawn by build_pallet/build_cinnabar)
OPEN_SEA = {(1, 13), (3, 13), (1, 14), (2, 14), (3, 14)}     # (round and below Cinnabar: open sea where no map is)


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
        # (nearest first: the GBA's maps don't quite close their loops, so the far side of one gives. The sea routes
        # go last: the loop south of Pallet (Route 21, Cinnabar, Routes 20 and 19 to Fuchsia) is some squares longer
        # than the land round the north, so Fuchsia's side is placed from Celadon, Vermilion and Lavender - whose roads
        # then meet theirs - and the gap is left in open sea, where it does no harm)
        land = [d_ for d_ in todo if d_ not in SEA_ROUTES]
        d = land[0] if land else todo[0]
        todo.remove(d)
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
    # (the GBA's pale short grass - Fuchsia's walks, Route 2's: HeartGold's grass02, its plazas' lighter grass)
    lawn = lambda m: (lambda c: c[0] > 140 and c[1] > 215 and c[1] > c[0] + 50)(col(m))
    bridge = BRIDGE_MT.get(gba_map.layouts()[gm['layout']]['secondary_tileset'], set())
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
            elif m in bridge: k = 'bridge'
            elif water(x, y): k = 'water'
            elif not shut(x, y):
                c = col(m)
                k = 'tall' if b in TALL_MB else 'flower' if m in FLOWER_MT else 'sand' if sandy(m) else 'pave' if paved(m) else 'lawn' if lawn(m) else 'grass'
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


SEA_FILL = set()             # (the squares no map covers that are the sea: world_kinds)


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
            if (gx, gz) not in kind:
                if W is None and (gx // 32, gz // 32) in OPEN_SEA: near[(gx, gz)] = True
                kind[(gx, gz)] = 'water' if near.get((gx, gz)) else 'woods'
                if near.get((gx, gz)): SEA_FILL.add((gx, gz))
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
SKIN = {'grass': GROUND, 'flower': GROUND, 'sand': 'road01', 'pave': 'road01', 'lawn': 'grass02', 'door': None}
EDGE = {'sand': 'road01_r', 'pave': 'road01_r', 'lawn': 'grass02_r'}     # (HeartGold's road and its edge in the grass beside it: its Kanto
                                                    # towns' streets are the same road as its routes')
# each town's own ground (HeartGold's own, its towns' own textures: what each lays most of): its pavement, its streets
# (Saffron, Celadon), the pavement's edge in the grass beside it (laid as the route's road01_r)
GROUND_STYLE = {
    'SaffronCity_Frlg': dict(side='ymb_fe02', street='ymb_fe01', edge='ymb_fe02_r', paved=True, curb='ymb_fe01_r', curb_s=(6, 0)),
    'CeladonCity_Frlg': dict(side='tama_yuka', street='tama_yuka2', edge='tama_fuch'),
    'LeaderAcademy_Campus': dict(side='tama_yuka', edge='tama_fuch'),
    'VermilionCity_Frlg': dict(side='kbc_rd02', street='kbc_rd01', edge='kbc_rd07', under=True, curb='kbc_rd03', quay='kbc_rd10'),
    'CeruleanCity_Frlg': dict(side='han_fe02', edge='han_fe02_r'),
    'PewterCity_Frlg': dict(side='han_fe02', edge='han_fe02_r'),
    'LavenderTown_Frlg': dict(side='sio_fe02', edge='sio_fe02_r', paved=True),
    # (Viridian: HeartGold's paving, with an edge in the grass made of it - build_interiors' cv_tok_r)
    'ViridianCity_Frlg': dict(side='tok_fe01', edge='cv_tok_r'),
    'Route14_Frlg': dict(side='road02', edge='road02_r'),        # (HeartGold's Route 14: its grey road)
}
EDGE_UNDER = {st['edge']: st['side'] for st in GROUND_STYLE.values() if st.get('under')}


# a town's square laid out anew, in its GBA map's squares (Nick: the Academy's front, "our flowers and Roserade
# statue... make it look pretty"): paved, with raised flower beds, HeartGold's street lamps and the GBA's statue in
# HeartGold's own Roserade (cv_roserade, build_pallet.py); a sign moved off the hall's porch (old: new)
PLAZAS = {
    'LeaderAcademy_Campus': dict(pave=(15, 13, 26, 19), bed=[(17, 14, 2, 1), (23, 14, 2, 1), (16, 16, 2, 2), (24, 16, 2, 2)],
                                 statue=[(20, 16, 2, 2)], lamp=[(16, 14), (25, 14)], signs={(19, 13): (19, 15)}),
}
LAMP_MODEL = 95             # (Goldenrod's street lamp)
SEA_EDGE = [(0.16, -1.5, 40.0), (0.22, -6.2, 47.6), (0.55, -9.6, 64.0)]     # (the sea's foam: build_pallet's)
RIVERS = {'Route24_Frlg', 'CeruleanCity_Frlg', 'Route10_Frlg'}     # (the GBA's rivers: HeartGold's own lays its river there)
# Fuchsia's pens (Nick: wrong size and shape as houses): the GBA's hedged pens, each HeartGold's own (its Fuchsia's,
# hg_kit's stamps, fitted to the GBA's): with a pond where the GBA's has water, else a raised flower bed or flowers
PENS = {'FuchsiaCity_Frlg': [(5, 7, 7, 4, 'pen_pond'), (12, 7, 7, 4, 'pen_flowers'), (31, 7, 6, 4, 'pen_bed'),
                             (37, 7, 7, 4, 'pen_flowers'), (33, 13, 9, 4, 'pen_bed'), (8, 18, 9, 5, 'pen_pond')]}
STATUES = {'LeaderAcademy_Campus': 'cv_roserade'}
ROCK_TOP = 'cliff01gs'
DOOR_MB = 0x69
CAVE_MB = 0x6E              # (HeartGold's cave mouths: walked into)
CAVE_MOUTH = json.load(open(os.path.join(HERE, 'data', 'cave_mouth.json')))     # (its arch, off Route 11's land)
SIGN_MODEL = 29


# GBA maps we don't build that only pass you on: a door to one leads into a room of ours, onto the room's ways out to
# it (the S.S. Anne's outside, at Vermilion's harbour: the ship's 1F corridor)
THROUGH = {'MAP_SSANNE_EXTERIOR': ('MAP_CANVAS_SSANNE_1F', 'MAP_SSANNE_1F_CORRIDOR')}


def gba_dest():
    """GBA room map id -> HeartGold room map (the porter's DEST)"""
    sys.path.insert(0, os.path.join(HERE, 'port'))
    import io, contextlib
    with contextlib.redirect_stdout(io.StringIO()):
        import port_map
    return port_map.DEST


TOWNISH = ('City', 'Town', 'Academy', 'Plateau', 'Island')
HOUSE, HOUSE_DOOR, HOUSE_SIZE = 297, 307, 4.75     # (Fuchsia's house, its door; 4.75 squares a side)


_BOX = {}


def model_box(mid):
    """a building model's box, in squares from its origin: (x0, z0, w, d)"""
    if mid not in _BOX:
        from nitro import read_narc
        if 'bm' not in _BOX: _BOX['bm'] = read_narc(open(os.path.join(slots.ROOT, 'files/a/0/4/0'), 'rb').read())[0]
        d = _BOX['bm'][mid]
        off = struct.unpack_from('<I', d, 0x10)[0]; dic = off + 8
        ent = dic + struct.unpack_from('<H', d, dic + 6)[0]
        m = off + struct.unpack_from('<I', d, ent + 4)[0]
        bx = [v / 4096 for v in struct.unpack_from('<6h', d, m + 0x2C)]; bs = struct.unpack_from('<i', d, m + 0x38)[0] / 4096
        _BOX[mid] = (bx[0] * bs / 16, bx[2] * bs / 16, bx[3] * bs / 16, bx[5] * bs / 16)
    return _BOX[mid]


# Each town's own HeartGold buildings (Nick: the right asset in the right place; HeartGold's towns' own ones): for a
# door whose room HeartGold has no building for, for a block of the GBA's buildings with no door, apartment blocks
# where a block is deep, the Academy's school and its market's stalls
STYLE = {
    'SaffronCity_Frlg': dict(houses=[251, 252, 253], tall=[254], tall_h=4, dm=259),
    'CeladonCity_Frlg': dict(houses=[236, 237], tall=[244, 238], tall_h=4, dm=15),
    'VermilionCity_Frlg': dict(houses=[215, 216], dm=221),
    'CeruleanCity_Frlg': dict(houses=[276, 277], dm=286),
    'PewterCity_Frlg': dict(houses=[292], dm=301),
    'LavenderTown_Frlg': dict(houses=[280], dm=288),
    'FuchsiaCity_Frlg': dict(houses=[297, 298, 299], dm=307),
    'ViridianCity_Frlg': dict(houses=[315, 316], dm=94),
    'LeaderAcademy_Campus': dict(houses=[58], dm=60, stalls=[173, 174, 175, 176], big=True),
}
STYLE_DEFAULT = dict(houses=[297, 298, 299], dm=307)
ROOM_LIKE = [('POKEMON_CENTER', 'MAP_VIRIDIAN_POKECENTER_1F'), ('POKECENTER', 'MAP_VIRIDIAN_POKECENTER_1F'), ('_MART', 'MAP_VIRIDIAN_POKEMART')]


def _fit(pool, w, h, k=0):
    """the model of a pool nearest a w x h footprint (squares), and how many of it across and down; models the same
    size taken in turn"""
    def err(m):
        _, _, mw, md = model_box(m)
        nx, nz = max(1, round(w / mw)), max(1, round(h / md))
        return abs(math.log(w / nx / mw)) + abs(math.log(h / nz / md)), nx, nz
    best = min(err(m)[0] for m in pool)
    same = [m for m in pool if err(m)[0] <= best + 0.3]      # (near enough: the town's houses in turn)
    m = same[k % len(same)]
    return m, err(m)[1], err(m)[2]


def style_door(gba_room, owner_map, hgb, w=0, h=0, k=0):
    """the building for a door whose room HeartGold has none for: a Center or Mart's own, else the town's house (or
    apartment block) nearest the GBA's building's size, with the town's door -> (an entry as hgb's, the most it may
    be scaled, whether it is the town's)"""
    for key, like in ROOM_LIKE:
        if key in (gba_room or ''): return hgb[like], 1.1, False
    st = STYLE.get(owner_map, STYLE_DEFAULT)
    pool = st['houses'] + st.get('tall', [])
    m = _fit(pool, w, h, k)[0] if w >= 3 and h >= 3 else st['houses'][k % len(st['houses'])]
    door = {v[0]: v for v in hgb.values()}
    if m in door: e = door[m]
    else:       # (a model HeartGold's towns have no door in: the town's door at its front's middle)
        bx0, bz0, mw, md = model_box(m)
        e = (m, (-(bx0 + mw / 2), 0.75 - (bz0 + md)), st["dm"], (0.0, -0.3), [bx0 * 16, 0, bz0 * 16, mw * 16, 0, md * 16])
    return e, (1.6 if st.get('big') else 1.2), True


def _houses(x0, z0, w, h, owner_map, hgb):
    """the town's own HeartGold buildings filling a block w x h squares at x0, z0: the ones nearest its size, as
    many as fit (apartments where the block is deep; the Academy's stalls where it is small)"""
    st = STYLE.get(owner_map, STYLE_DEFAULT)
    door = {v[0]: v for v in hgb.values()}
    stalls = st.get('stalls') and (w * h <= 12 or h <= 3)
    if stalls: pool = st['stalls']
    elif st.get('tall') and h >= st.get('tall_h', 5): pool = st['tall']
    else: pool = st['houses']
    k = x0 * 7 + z0 * 3
    out = []
    if stalls:      # (a market's tent over a cart's squares: as wide as the cart, a little taller than its scale)
        m_ = pool[k % len(pool)]
        bx0, bz0, mw, md = model_box(m_)
        sc = max(0.4, min(1.0, (w + 0.6) / mw))
        cx, cz = x0 + w / 2 - (bx0 + mw / 2) * sc, z0 + h - (bz0 + md) * sc
        return [(m_, cx, cz, 0, (sc, max(sc, 0.6), sc))]
    m0, nx, nz = _fit(pool, w, h, k)
    hi = 1.6 if st.get('big') else 1.25
    if st.get('big'):       # (the Academy's school: one, as big as the block, to half again its own size)
        nx, nz = max(1, math.ceil(w / (model_box(m0)[2] * hi))), max(1, math.ceil(h / (model_box(m0)[3] * hi)))
    cw, ch = w / nx, h / nz
    for i in range(nx):
        for j in range(nz):
            m_ = _fit(pool, cw, ch, k + i + j)[0]
            bx0, bz0, mw, md = model_box(m_)
            sx = max(0.85, min(hi, cw / mw)); sz = max(0.85, min(hi, ch / md)); sc = min(sx, sz)
            cx = x0 + i * cw + cw / 2 - (bx0 + mw / 2) * sx
            cz = z0 + j * ch + ch - (bz0 + md) * sz           # (its front on the block's front)
            out.append((m_, cx, cz, 0, (sx, sc, sz)))
            if m_ in door and door[m_][2] is not None:       # (its door, for the look: HeartGold's offsets from it)
                v = door[m_]
                out.append((v[2], cx + (v[3][0] - v[1][0]) * sx, cz + (v[3][1] - v[1][1]) * sz, 0, (sc, sc, sc)))
    return out


def prop_rect(p):
    """a building's box on the ground, in squares: (x0, z0, x1, z1); None for a door or a sign"""
    sc = p[4] if len(p) > 4 else (1, 1, 1)
    bx0, bz0, mw, md = model_box(p[0])
    if mw < 2.5: return None
    return (p[1] + bx0 * sc[0], p[2] + bz0 * sc[2], p[1] + (bx0 + mw) * sc[0], p[2] + (bz0 + md) * sc[2])


def room_between(x0, x1, z0, z1, mid, rects):
    """the room left, along a row, between the buildings up already beside a box x0..x1, z0..z1 (mid: a point it must
    keep): (left, right)"""
    L, R = -1e9, 1e9
    for r in rects:
        if r is None or min(z1, r[3]) - max(z0, r[1]) <= 0.3: continue
        if (r[0] + r[2]) / 2 < mid: L = max(L, r[2])
        else: R = min(R, r[0])
    return L, R


GATE_NS, GATE_EW = 246, 247     # HeartGold's gatehouses: doors on the north and south faces, or the west and east


def _gates(doors, dest, hgb, bldg, kind):
    """The gatehouses (a room HeartGold has a gatehouse for, or one the GBA's doors face each other into): HeartGold's
    gatehouse model, its doors on the GBA's - stretched or squeezed between them where the GBA has both (its two
    faces 8 squares apart north to south, 7 west to east). -> {room: (props, closed squares, door squares)}"""
    by_room = {}
    for gx, gz, d, w in doors:
        room = dest.get(w['dest_map'])
        if room and (hgb.get(room, (None,))[0] in (GATE_NS, GATE_EW) or ('GATE' in room and room not in hgb)):
            by_room.setdefault((room, w['dest_map']), []).append((gx, gz))
    out = {}
    mid = lambda c: (sum(q[0] for q in c) / len(c), sum(q[1] for q in c) / len(c))
    # (a gatehouse a GBA gatehouse: its faces' doors, near one another - two of the GBA's to one room of HeartGold's
    # are two gatehouses, Route 11's east one and Route 12's north one)
    groups = []
    for (room, _), ds in by_room.items():
        cl = []                                  # (the doors, two squares each: a cluster a face)
        for q in sorted(ds):
            c = next((c for c in cl if any(abs(q[0] - r[0]) + abs(q[1] - r[1]) <= 1 for r in c)), None)
            (c.append(q) if c else cl.append([q]))
        gs = []
        for c in cl:
            g = next((g for g in gs if any(math.dist(mid(c), mid(o)) <= 12 for o in g)), None)
            (g.append(c) if g else gs.append([c]))
        groups += [(room, g) for g in gs]
    for room, cl in groups:
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
        o = out.setdefault(room, ([], set(), set()))
        o[0].extend(ps); o[1].update(closed - dq); o[2].update(dq)
    return out


def plan_world(W=None, woods=False):
    """everything the lands need, worked out once: kinds, trees, buildings and their squares, warps"""
    SEA_FILL.clear()
    W_, (WW, WH), kind, owner, doors, ledges, bldg = world_kinds(W, woods)
    # (where a ledge down a column turns into one along a row going south, the GBA closes the square at the turn:
    # HeartGold's turn of the lip is painted there on the ground - ledge_corner - not a block of rock)
    for (x, y), v in list(kind.items()):
        if (x, y) not in ledges and v in ('rock', 'stone') and ledge_corner_key(ledges, x, y) in LEDGE_KIT['corners']:
            kind[(x, y)] = 'corner'
    moved = {}
    for d, spec in ([] if woods else PLAZAS.items()):       # (a town's square laid out anew: the Academy's front)
        if d not in W_: continue
        x0, y0 = W_[d][:2]
        X0, Z0, X1, Z1 = spec['pave']
        for x in range(X0, X1 + 1):
            for z in range(Z0, Z1 + 1): kind[(x0 + x, y0 + z)] = 'pave'
        for k_ in ('bed', 'statue'):
            for bx_, bz_, bw_, bh_ in spec[k_]:
                for x in range(bx_, bx_ + bw_):
                    for z in range(bz_, bz_ + bh_): kind[(x0 + x, y0 + z)] = k_
        for x, z in spec['lamp']: kind[(x0 + x, y0 + z)] = 'lamp'
        for (ax, az), (bx_, bz_) in spec['signs'].items():
            kind[(x0 + bx_, y0 + bz_)] = 'sign'
            moved[(x0 + ax, y0 + az)] = (x0 + bx_, y0 + bz_)
    # (the GBA's walkways widened to HeartGold's: Route 12's boardwalks are three squares across, the GBA's two - one
    # more over the water on the side with room; the Nugget Bridge takes in its railings, five across)
    bridge_closed = set()
    # (a sign standing on a walkway stands on its deck)
    on_bridge = {q for q, v in kind.items() if v == 'sign' and sum(kind.get(n) == 'bridge' for n in ((q[0] + 1, q[1]), (q[0] - 1, q[1]), (q[0], q[1] + 1), (q[0], q[1] - 1))) >= 2}
    lt = lambda q: gba_map.layouts()[gba_map.map_json(owner[q])['layout']]['secondary_tileset'] if q in owner else None
    B = lambda q: kind.get(q) == 'bridge' or q in on_bridge
    # (every walkway grown by one square the same way - east and south - so its crossings stay square: the GBA's two
    # across and its 2 x 2 crossings become HeartGold's three and its 3 x 3 platforms)
    bw = [q for q, v in kind.items() if (v == 'bridge' or q in on_bridge) and BRIDGE_KIT.get(lt(q), 'boardwalk') == 'boardwalk']
    bws = set(bw)
    brun = lambda q, dx, dz: next((k for k in range(1, 9) if (q[0] + dx * k, q[1] + dz * k) not in bws), 9) - 1
    crossings = {(q[0] + a, q[1] + b) for q in bw if brun(q, 1, 0) + brun(q, -1, 0) >= 2 and brun(q, 0, 1) + brun(q, 0, -1) >= 2
                 for a in (0, 1) for b in (0, 1)}
    for q in bw:
        for d in ((1, 0), (0, 1), (1, 1)):
            n = (q[0] + d[0], q[1] + d[1])
            if kind.get(n) == 'water': kind[n] = 'bridge'
    for q in [q for q, v in kind.items() if v == 'bridge' and BRIDGE_KIT.get(lt(q)) == 'nugget']:
        for a in (-1, 1):
            if kind.get((q[0] + a, q[1])) == 'stone': kind[(q[0] + a, q[1])] = 'bridge'; bridge_closed.add((q[0] + a, q[1]))
    # (and it spans water, as HeartGold's: a strip of grass between it and a fence or the water is the river)
    for q in sorted(bridge_closed):
        for a in (-1, 1):
            strip = []
            for k_ in range(1, 6):
                n = (q[0] + a * k_, q[1])
                if kind.get(n) in ('grass', 'fence', 'lawn', 'flower'): strip.append(n)
                else: break
            if strip and len(strip) <= 4 and kind.get((q[0] + a * (len(strip) + 1), q[1])) in ('water', 'rock', None):
                for n in strip: kind[n] = 'water'
    pens, pen_open = [], set()
    for d, lst in ([] if woods else PENS.items()):      # (Fuchsia's pens: HeartGold's own, hg_kit's stamps)
        if d not in W_: continue
        x0, y0 = W_[d][:2]
        for px, pz, pw, ph, st_ in lst:
            pens.append((x0 + px, y0 + pz, pw, ph, st_))
            for x in range(px, px + pw):
                for z in range(pz, pz + ph):
                    k_ = kind.get((x0 + x, y0 + z))
                    if k_ in ('sand', 'grass', 'pave', 'lawn', 'flower', 'tall'): pen_open.add((x0 + x, y0 + z))   # (inside: its Pokemon's)
                    if k_ not in ('sign', 'water'): kind[(x0 + x, y0 + z)] = 'pen'      # (its pond: the GBA's water)
    orig = dict(kind)
    # (the open sea: the water joined to the sea round the world's maps - HeartGold's sea, moving; ponds stay ponds)
    sea, todo, past = set(SEA_FILL), list(SEA_FILL), set()
    while todo:         # (under a walkway: the sea goes on)
        x, y = todo.pop()
        for n in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if n in sea or n in past: continue
            if kind.get(n) == 'water': sea.add(n); todo.append(n)
            elif kind.get(n) == 'bridge': past.add(n); todo.append(n)
    dest = gba_dest()
    hgb = hg_buildings()
    walkable = ('grass', 'sand', 'pave', 'tall', 'flower', 'door', 'stairs', 'lawn', 'bridge')
    # buildings: HeartGold's for the room each door leads to, its door on the GBA's door; the squares its box covers
    # (more than a third, to its door's row) closed. A door that leads nowhere HeartGold has a building for is a
    # warp on its square, the GBA's building squares left as stones
    props, stands, door_sq, warps, done, placed = [], set(), set(), {}, set(), {}
    fake_doors = []         # (the doors of houses that are only to look at)
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
    # (and a way in at the foot of a building in a town, on a square the GBA draws as open ground - the Academy's
    # halls: a door, the town's building over it)
    extra = {(gx, gz) for gx, gz, d, wp in all_warps if (gx, gz) not in is_door and not woods and any(t in d for t in TOWNISH)
             and orig.get((gx, gz - 1)) in ('house', 'stone') and orig.get((gx, gz)) in walkable and not hgb.get(dest.get(wp['dest_map']))}
    is_door |= extra
    doors = doors + [(gx, gz, d, wp['x'], wp['y']) for gx, gz, d, wp in all_warps if (gx, gz) in extra]
    # (HeartGold's own buildings first: a second door beside one - the Safari Zone's Exotic hall - is then its door)
    wdest = lambda d, x, y: next(w for w in gba_map.map_json(d)['warp_events'] if (w['x'], w['y']) == (x, y))['dest_map']
    doors = sorted(doors, key=lambda t: 0 if hgb.get(dest.get(wdest(t[2], t[3], t[4]))) else 1)
    for gx, gz, d, x, y in doors:
        gm = gba_map.map_json(d)
        w = next(w for w in gm['warp_events'] if (w['x'], w['y']) == (x, y))
        room = dest.get(w['dest_map'])
        b = hgb.get(room)
        warps[(gx, gz)] = (d, w)
        if room in gates: continue
        if (gx, gz) in extra and ((gx, gz - 1) in stands or any(r == w['dest_map'] for _, r in done)): continue
        # (HeartGold's building fitted to the GBA's: squeezed or stretched a little to the closed squares round the
        # door - up the door's column, along the row above it - its door kept on the GBA's)
        shut = lambda q: orig.get(q) not in walkable and orig.get(q) not in (None, 'water', 'woods', 'tall')
        top = gz
        while shut((gx, top - 1)) and gz - top < 16: top -= 1
        lx = rx = gx
        # (to halfway to the next building's door along the row: buildings side by side share their row)
        nb = [q[0] for q in is_door if abs(q[1] - gz) <= 1 and q[0] != gx and abs(q[0] - gx) > 1 and (warps.get(q, (0, {}))[1].get('dest_map') if q in warps else None) != w['dest_map']]
        lim_l = max([(q + gx) // 2 + 1 for q in nb if q < gx] + [gx - 16])
        lim_r = min([(q + gx + 1) // 2 - 1 for q in nb if q > gx] + [gx + 16])
        while shut((lx - 1, gz - 1)) and lx > lim_l: lx -= 1
        while shut((rx + 1, gz - 1)) and rx < lim_r: rx += 1
        gw, gh = rx - lx + 1, gz - top + 1
        hi, town = 1.1, False
        if not b:
            if (gx, gz) not in is_door or any((gx + a, gz) in door_sq for a in (-1, 1)): continue
            o = owner.get((gx, gz))
            if o not in STYLE:      # (a house on a route: the nearest town's)
                cen = lambda r: (r[0] + r[2] / 2, r[1] + r[3] / 2)
                o = min((t for t in STYLE if t in W_), key=lambda t: math.dist(cen(W_[t]), (gx, gz)))
            b, hi, town = style_door(w['dest_map'], o, hgb, gw, gh, gx + gz)
        mdl, (mdx, mdz), dmdl, dd, bx = b
        if dmdl is not None: props.append((dmdl, gx + 0.5 + dd[0], gz + 0.5 + dd[1], 0))
        door_sq.add((gx, gz))
        if (bldg.get((gx, gz)), room or w['dest_map']) in done: continue      # (up already: a gate's other door, to the same room)
        if room and any(abs(gx - q[0]) + abs(gz - q[1]) < 16 for q in placed.get(room, ())): continue     # (its back door)
        done.add((bldg.get((gx, gz)), room or w['dest_map']))
        if room: placed.setdefault(room, []).append((gx, gz))
        rects = [prop_rect(p) for p in props]
        if any(r and r[0] - 0.2 <= gx + 0.5 <= r[2] + 0.2 and r[1] <= gz + 0.5 <= r[3] + 1.5 for r in rects):
            continue        # (a second door of a building up already - the Safari Zone's, a museum's back door: its door)
        lo = 0.85 if town else 0.75
        sx = max(lo, min(hi, gw / (bx[3] / 16))) if gw >= 3 else 1.0
        sz = max(lo, min(hi, gh / (bx[5] / 16))) if gh >= 3 else 1.0
        cx, cz = gx + 0.5 + mdx * sx, gz + 0.5 + mdz * sz
        if (town or bx[3] / 16 < 5.5) and gw >= 3:        # (a house: over the GBA's building, its door on the GBA's door)
            cx = (lx + rx + 1) / 2 - (bx[0] + bx[3] / 2) / 16 * sx
            cx = min(max(cx, gx + 1 - (bx[0] + bx[3]) / 16 * sx + 0.3), gx - bx[0] / 16 * sx - 0.3)
        # (no building over another: one beside another up already kept to the room between them, its door kept)
        x0, x1 = cx + bx[0] / 16 * sx, cx + (bx[0] + bx[3]) / 16 * sx
        Lb, Rb = room_between(x0, x1, cz + bx[2] / 16 * sz, cz + (bx[2] + bx[5]) / 16 * sz, gx + 0.5, rects)
        if x0 < Lb or x1 > Rb:
            wd = min(x1 - x0, Rb - Lb)
            if wd >= 0.6 * bx[3] / 16 and Lb <= gx + 0.2 and Rb >= gx + 0.8:
                sx = wd / (bx[3] / 16)
                nx0 = min(max(x0, Lb), Rb - wd)
                nx0 = min(max(nx0, gx + 0.8 - wd), gx + 0.2)
                cx = nx0 - bx[0] / 16 * sx
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
        if kind.get(q) in ('house', 'stone', 'grass', 'sand', 'pave', 'lawn', 'flower', 'fence', 'hedge', 'rock') and q not in door_sq: kind[q] = 'house'
    # (the GBA's building squares HeartGold's building leaves are open ground, as the road or grass round them; a
    # building HeartGold has none for is a house of Fuchsia's over its squares, centred - as the Safari Zone's)
    # (a door no building of HeartGold's stands at - its room has none - gets a house of Fuchsia's, its door on the
    # GBA's; one for doors side by side)
    for gx, gz, d, x, y in doors:
        if (gx, gz) in door_sq or (gx, gz) not in is_door: continue
        if any((gx + a, gz) in door_sq for a in (-1, 1)): door_sq.add((gx, gz)); continue
        dx, dz = gx, gz
        ox, oz = dx + 1.0, dz - 1.0                     # (HeartGold's Fuchsia house's offsets from its door)
        props.append((HOUSE, ox, oz, 0)); props.append((HOUSE_DOOR, ox + 0.125, oz + 1.0, 0))
        st = {(qx, qz) for qx in range(math.floor(ox - 2.25 + 0.35), math.ceil(ox + 2.5 - 0.35)) for qz in range(math.floor(oz - 2.625 + 0.35), dz + 1)}
        st = {q for q in st if not (orig.get(q) in walkable and q != (dx, dz))}
        stands |= st
        door_sq.add((dx, dz))
        for q in st:
            if q != (dx, dz) and kind.get(q) in ('house', 'stone', 'grass', 'sand', 'pave', 'lawn', 'flower', 'fence', 'hedge', 'rock'): kind[q] = 'house'
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
            if any((c[0] + a, c[1] + b) in stands for c in comp for a, b in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                for c in comp: kind[c] = 'house'      # (what's left of a building another stands over: its ground)
                continue
            rects = [prop_rect(p) for p in props]
            hs = _houses(min(xs), min(ys), bw, bh, owner.get(q0), hgb)
            if any(min(a[2], r[2]) - max(a[0], r[0]) > 0.3 and min(a[3], r[3]) - max(a[1], r[1]) > 0.3
                   for a in map(prop_rect, hs) if a for r in rects if r):
                for c in comp: kind[c] = 'woods'       # (no room for a house of its own: trees)
                continue
            props += hs
            fake_doors += [p_ for p_ in hs if model_box(p_[0])[2] < 2.5]
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
    # (a town paved all over - Saffron: its grass is its pavement)
    for q, v in list(kind.items()):
        if v == 'grass' and GROUND_STYLE.get(owner.get(q), {}).get('paved'): kind[q] = 'pave'
    # (no strip of grass between two roads narrower than three squares: HeartGold's edge of the road takes a square
    # of grass, two back to back look stitched - the strip is road)
    roadk = ('sand', 'pave', 'lawn')
    while True:
        fill = {}
        for q, v in kind.items():
            if v != 'grass' or q in fill: continue
            for dx, dz in ((1, 0), (0, 1)):
                a_, b_ = q, q
                while kind.get((a_[0] - dx, a_[1] - dz)) == 'grass' and (q[0] - a_[0]) + (q[1] - a_[1]) < 2: a_ = (a_[0] - dx, a_[1] - dz)
                while kind.get((b_[0] + dx, b_[1] + dz)) == 'grass' and (b_[0] - a_[0]) + (b_[1] - a_[1]) < 2: b_ = (b_[0] + dx, b_[1] + dz)
                ra, rb = kind.get((a_[0] - dx, a_[1] - dz)), kind.get((b_[0] + dx, b_[1] + dz))
                if (b_[0] - a_[0]) + (b_[1] - a_[1]) < 2 and ra in roadk and rb in roadk:
                    n = a_
                    while True:
                        fill[n] = ra
                        if n == b_: break
                        n = (n[0] + dx, n[1] + dz)
        for q, v in kind.items():      # (and a square of grass no piece of the edge fits - road round it every which way)
            if v != 'grass' or q in fill: continue
            nb = [(a, b) for a in (-1, 0, 1) for b in (-1, 0, 1) if (a or b) and kind.get((q[0] + a, q[1] + b)) in roadk]
            if nb and R.sand_piece(nb, *q)[0] == 'laid':
                ks = [kind[(q[0] + a, q[1] + b)] for a, b in nb]
                fill[q] = max(roadk, key=ks.count)
        if not fill: break
        kind.update(fill)
    # (a patch of the pale grass against a road - a strip by a door - is the road: two edges can't meet there)
    seen_l = set()
    for q0 in [q for q, v in kind.items() if v == 'lawn']:
        if q0 in seen_l: continue
        comp, todo = {q0}, [q0]
        while todo:
            q = todo.pop()
            for n in ((q[0] + 1, q[1]), (q[0] - 1, q[1]), (q[0], q[1] + 1), (q[0], q[1] - 1)):
                if n not in comp and kind.get(n) == 'lawn': comp.add(n); todo.append(n)
        seen_l |= comp
        nb = [kind.get((q[0] + a, q[1] + b)) for q in comp for a, b in ((1, 0), (-1, 0), (0, 1), (0, -1))]
        rd = [k for k in nb if k in ('sand', 'pave')]
        if len(comp) < 8 and rd:
            for q in comp: kind[q] = max(('sand', 'pave'), key=rd.count)
    # (a city's streets: its road a square or more from anything but road, in blocks of 2x2 or more, the rest
    # its pavement - HeartGold's Saffron and Celadon)
    street = set()
    for q, v in kind.items():
        if v in ('sand', 'pave') and GROUND_STYLE.get(owner.get(q), {}).get('street') and \
                all(kind.get((q[0] + a, q[1] + b)) in roadk for a in (-1, 0, 1) for b in (-1, 0, 1)) and q not in door_sq and q not in warps:
            street.add(q)
    street = {q for q in street if any(all((q[0] + a + i, q[1] + b + j) in street for i in (0, 1) for j in (0, 1)) for a in (-1, 0) for b in (-1, 0))}
    for q0 in list(street):         # (a street is a street: no patches of it under a dozen squares)
        if q0 not in street: continue
        comp, todo = {q0}, [q0]
        while todo:
            q = todo.pop()
            for n in ((q[0] + 1, q[1]), (q[0] - 1, q[1]), (q[0], q[1] + 1), (q[0], q[1] - 1)):
                if n in street and n not in comp: comp.add(n); todo.append(n)
        if len(comp) < 12: street -= comp
    # (no sign in front of a door or under a building: moved to the nearest open square beside, its words with it)
    rects = [r for r in map(prop_rect, props) if r]
    inside = lambda q, m=0.0: any(r[0] + 0.4 - m < q[0] + 0.5 < r[2] - 0.4 + m and r[1] - m < q[1] + 0.5 < r[3] - 0.2 + m for r in rects)
    fake_sq = {(int(p_[1]), int(p_[2] + 0.5)) for p_ in fake_doors}
    front = lambda q: (q[0], q[1] - 1) in door_sq or (q[0], q[1] - 1) in warps or (q[0], q[1] - 1) in fake_sq
    openk = ('pave', 'sand', 'grass', 'lawn')
    people = {(W_[d][0] + e['x'], W_[d][1] + e['y']) for d in W_ for e in gba_map.map_json(d).get('object_events', [])}
    # (signs side by side - the GBA's bicycles outside Cerulean's bike shop are signs - under a building: one sign,
    # the front one; the rest closed squares the building stands over)
    seen_s = set()
    for q0 in sorted(q for q, v in kind.items() if v == 'sign'):
        if q0 in seen_s: continue
        comp, todo = {q0}, [q0]
        while todo:
            q = todo.pop()
            for n in ((q[0] + 1, q[1]), (q[0] - 1, q[1]), (q[0], q[1] - 1), (q[0], q[1] + 1)):
                if n not in comp and kind.get(n) == 'sign': comp.add(n); todo.append(n)
        seen_s |= comp
        keep = max(comp, key=lambda q: (q[1], -q[0]))
        for q in comp - {keep}:
            if inside(q, 0.6): kind[q] = 'house'
    for q in sorted(q for q, v in kind.items() if v == 'sign'):
        if owner.get(q) in ('PalletTown_Frlg', 'CinnabarIsland_Frlg') or q in moved.values(): continue
        if not (front(q) or inside(q)): continue
        cands = [(max(abs(a), abs(b)), abs(a) + abs(b), b < 0, (q[0] + a, q[1] + b)) for a in range(-3, 4) for b in range(-3, 4) if a or b]
        new_ = None
        for *_, n in sorted(cands):
            if kind.get(n) not in openk or n in door_sq or n in warps or n in people or front(n) or inside(n, 0.2): continue
            nb4 = [(n[0] + a, n[1] + b) for a, b in ((1, 0), (-1, 0), (0, 1), (0, -1))]
            if any(kind.get(m) == 'sign' for m in nb4) or sum(kind.get(m) in openk for m in nb4) < 3: continue
            new_ = n; break
        ks = [kind.get((q[0] + a, q[1] + b)) for a, b in ((1, 0), (-1, 0), (0, 1), (0, -1))]
        kind[q] = max(openk, key=ks.count) if not inside(q) else 'house'
        if new_: kind[new_] = 'sign'; moved[q] = new_
    # (a house only to look at shows no door where something stands in front of it)
    drop = {id(p_) for p_ in fake_doors if kind.get((int(p_[1]), int(p_[2] + 0.5) + 1)) not in openk + ('flower', 'tall')}
    props = [p_ for p_ in props if id(p_) not in drop]
    # (each walkway's kit, by its GBA map's tileset)
    bridge_kit, bridge_cls = {}, {}
    for q, v in kind.items():
        if not (v == 'bridge' or q in on_bridge) or q not in owner: continue
        lay = gba_map.Layout(gba_map.map_json(owner[q])['layout'])
        ts_ = gba_map.layouts()[lay.id]['secondary_tileset']
        bridge_kit[q] = BRIDGE_KIT.get(ts_, 'boardwalk')
        m_ = lay.metatile(q[0] - W_[owner[q]][0], q[1] - W_[owner[q]][1])
        bridge_cls[q] = 'crate' if bridge_kit[q] == 'boardwalk' and q in crossings and kind.get(q) == 'bridge' else 'plank'
    # (two crossings a square apart: one platform, no stub of planks between)
    for _ in range(2):
        for q, c in list(bridge_cls.items()):
            if c != 'crate' and any(bridge_cls.get((q[0] - dx, q[1] - dz)) == 'crate' and bridge_cls.get((q[0] + dx, q[1] + dz)) == 'crate'
                                    for dx, dz in ((1, 0), (0, 1))):
                bridge_cls[q] = 'crate'
    # (HeartGold's crossings are whole platforms: laid as its 3 x 3 - its corners, its sides, its middle - over each)
    bridge_pos, seen_c = {}, set()
    for q0 in sorted(q for q, c in bridge_cls.items() if c == 'crate'):
        if q0 in seen_c: continue
        comp, todo = {q0}, [q0]
        while todo:
            q = todo.pop()
            for n in ((q[0] + 1, q[1]), (q[0] - 1, q[1]), (q[0], q[1] + 1), (q[0], q[1] - 1)):
                if n not in comp and bridge_cls.get(n) == 'crate': comp.add(n); todo.append(n)
        seen_c |= comp
        cr = lambda q: bridge_cls.get(q) == 'crate'
        for b in comp:      # (by its own neighbours: an edge where the platform ends, a corner where two edges meet)
            bridge_pos[b] = (0 if not cr((b[0] - 1, b[1])) else 2 if not cr((b[0] + 1, b[1])) else 1) + \
                3 * (0 if not cr((b[0], b[1] - 1)) else 2 if not cr((b[0], b[1] + 1)) else 1)
    for q, c in bridge_cls.items():
        if c == 'crate' and q not in bridge_pos: bridge_cls[q] = 'plank'
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
    return dict(W=W_, size=(WW, WH), kind=kind, owner=owner, ledges=ledges, props=props, door_sq=door_sq, warps=warps, caves=caves, sea=sea,
                trees=trees, loose=loose, cell_map=cell_map, street=street, moved=moved, pens=pens, pen_open=pen_open, bridge_closed=bridge_closed, on_bridge=on_bridge, bridge_pos=bridge_pos, bridge_kit=bridge_kit, bridge_cls=bridge_cls, bldg=bldg)


_KITS = {}
LEDGE_KIT = json.load(open(os.path.join(HERE, 'data', 'kit_ledge.json')))


def ledge_piece(way, before, after):
    """HeartGold's ledge decal for a square whose way down is `way`, by whether the squares before and after it along
    the ledge (west to east, north to south) are ledge going the same way: [(texture, [(u, v, s, t)])]. HeartGold has
    no ledge you jump north off: those are its south ones turned round; a ledge a square long is its straight piece"""
    P = LEDGE_KIT['pieces']
    if way == (0, -1):
        return [(t, [(16 - u, 16 - v, s_, t_) for u, v, s_, t_ in q]) for t, q in ledge_piece((0, 1), after, before)]
    k = '%d,%d,%d,%d' % (way[0], way[1], before or not after, after or not before)
    return P.get(k) or P['%d,%d,1,1' % way]


def ledge_corner_key(ledges, x, y):
    """the turn of a ledge at (x, y): 'dx,side' (the ledge above going down east or west, the one going south on its
    side), or None"""
    up = ledges.get((x, y - 1))
    if up not in ((1, 0), (-1, 0)): return None
    side = next((s_ for s_ in (1, -1) if ledges.get((x + s_, y)) == (0, 1)), None)
    return None if side is None else '%d,%d' % (up[0], side)


def KIT(name):
    if name not in _KITS: _KITS[name] = hg_kit.load(name)
    return _KITS[name]


def build_land(P, cx, cz, base=None):
    """one land: the world's squares cx*32.., cz*32.."""
    if base is None: base = WORLD_BASE
    kind, ledges = P['kind'], P['ledges']
    K_ = lambda x, y: kind.get((x, y))
    dims, pals = texdims(TEXSET)
    pal_of = lambda t: {'sea_on': 'sea_f02_pl', 'allpeak_pgs': 'apeak', 'allpeakgs': 'apeak'}.get(t) or next(q for q in (t + '_pl', t, t.replace('gs', ''), t.replace('gs', '') + '_pl') if q in pals)
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
        vs = [((x_ - ox * 16 - 256, y_ + base, z_ - oz * 16 - 256), (st[0] - s0, st[1] - t0)) for (x_, y_, z_), st in pts]
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
    BED_H = 5

    def planter(x, y):
        """a square of a raised flower bed: HeartGold's grass and flowers on top, Fuchsia's brick round the sides
        that face out of the bed"""
        X, Z = x * 16, y * 16
        poly(GROUND, [((X, BED_H, Z + 16), (X, Z + 16)), ((X + 16, BED_H, Z + 16), (X + 16, Z + 16)), ((X + 16, BED_H, Z), (X + 16, Z)), ((X, BED_H, Z), (X, Z))])
        poly('flower01' if (x + y) % 2 else 'flower02', [((X, BED_H + 1, Z + 16), (0, 16)), ((X + 16, BED_H + 1, Z + 16), (16, 16)), ((X + 16, BED_H + 1, Z), (16, 0)), ((X, BED_H + 1, Z), (0, 0))])
        for dx, dz in ((0, 1), (1, 0), (-1, 0), (0, -1)):
            if K_(x + dx, y + dz) == 'bed': continue
            if dz: zz = Z + (16 if dz > 0 else 0); a, b = (X, zz), (X + 16, zz)
            else: xx = X + (16 if dx > 0 else 0); a, b = (xx, Z + 16), (xx, Z)
            if dx < 0 or dz < 0: a, b = b, a
            poly('sek_fe01', [((a[0], 0, a[1]), (0, BED_H)), ((b[0], 0, b[1]), (16, BED_H)), ((b[0], BED_H, b[1]), (16, 0)), ((a[0], BED_H, a[1]), (0, 0))])

    def statue(x, y, tex):
        """the GBA's statue on its 2x2 squares: the stone pedestal, and the Pokemon on it in HeartGold's own
        overworld sprite (cv_roserade: its front frame, 22 texels square at 5..27, 8..30), stood up facing the camera
        and leaning back as HeartGold's people do"""
        x0, x1, z0, z1 = x * 16 + 1.5, x * 16 + 30.5, y * 16 + 2.5, y * 16 + 29.5
        yb, yt = 0, 14
        poly(tex, [((x0, yb, z1), (3, 47)), ((x1, yb, z1), (29, 47)), ((x1, yt, z1), (29, 34)), ((x0, yt, z1), (3, 34))])
        poly(tex, [((x0, yt, z1), (5, 37)), ((x1, yt, z1), (26, 37)), ((x1, yt, z0), (26, 35)), ((x0, yt, z0), (5, 35))])
        side = [(7, 43), (12, 43), (12, 38), (7, 38)]
        for pts in ([(x0, z0), (x0, z1)], [(x1, z1), (x1, z0)], [(x1, z0), (x0, z0)]):
            (ax, az), (bx_, bz_) = pts
            poly(tex, [((ax, yb, az), side[0]), ((bx_, yb, bz_), side[1]), ((bx_, yt, bz_), side[2]), ((ax, yt, az), side[3])])
        SC = 1.8
        u0, u1, v0, v1 = 5, 27, 8, 30
        w_ = (u1 - u0) * SC
        xc, zc = x * 16 + 16, (z0 + z1) / 2 + 4
        hgt = (v1 - v0) * SC
        back = hgt * 0.6
        poly(tex, [((xc - w_ / 2, yt, zc), (u0, v1)), ((xc + w_ / 2, yt, zc), (u1, v1)), ((xc + w_ / 2, yt + hgt * 0.8, zc - back), (u1, v0)), ((xc - w_ / 2, yt + hgt * 0.8, zc - back), (u0, v0))])

    owner = P['owner']
    # the ground's skin under each square: the GBA's things stand on grass, or on the road beside them
    near = lambda q: abs(q[0] - (X0 + 16)) < 18 and abs(q[1] - (Z0 + 16)) < 18
    street = P.get('street', set())
    owner = P['owner']
    gst = lambda q: (lambda st: st if K_(*q) in st.get('kinds', (K_(*q),)) else {})(GROUND_STYLE.get(owner.get(q), {}))
    # (Vermilion's harbour: a row of HeartGold's stone blocks along the water)
    quay = lambda q: gst(q).get('quay') and any(K_(q[0] + a, q[1] + b) == 'water' for a, b in ((1, 0), (-1, 0), (0, 1), (0, -1)))
    skin_at = lambda q: SKIN['lawn'] if K_(*q) == 'lawn' else gst(q).get('street') if q in street else gst(q)['quay'] if quay(q) else gst(q).get('side', SKIN['pave'])
    edge_at = lambda q: EDGE['lawn'] if K_(*q) == 'lawn' else gst(q).get('edge', EDGE['pave'])
    # (the roads, by the edge each lays in the grass beside it)
    roads, rskin = {}, {}
    for q, v in kind.items():
        if v in EDGE and near(q):
            rskin[q] = skin_at(q)
            if edge_at(q): roads.setdefault(edge_at(q), set()).add(q)
    for y in range(Z0 - 1, Z1 + 1):
        for x in range(X0 - 1, X1 + 1):
            k = K_(x, y)
            if k in ('house', 'door', 'stone', 'sign', 'fence', 'hedge', 'bed', 'lamp', 'statue'):
                nb = [(x + a, y + b) for a, b in ((0, 1), (0, -1), (1, 0), (-1, 0))]
                r = [n for n in nb if n in rskin]
                if len(r) >= 2:
                    if edge_at(r[0]): roads.setdefault(edge_at(r[0]), set()).add((x, y))
                    rskin[(x, y)] = gst(r[0]).get('side', SKIN['pave'])
    road_of = lambda x, y: rskin.get((x, y))
    tall = {q for q, v in kind.items() if v == 'tall' and abs(q[0] - (X0 + 16)) < 18 and abs(q[1] - (Z0 + 16)) < 18}
    water = {q for q, v in kind.items() if v == 'water' and abs(q[0] - (X0 + 16)) < 18 and abs(q[1] - (Z0 + 16)) < 18}
    level = lambda x, y: 1 if K_(x, y) == 'rock' else 0
    perm = [0x8000] * 1024
    props = []
    edged = {}

    def ledge(x, y, way, top=None):
        """a ledge's square: HeartGold's own ledge (Nick: match HeartGold's - flat, a rock lip painted on the ground),
        its decal a unit over whatever ground is there, so the ground runs on under it: the straight piece
        (allpeak_pgs), or its end (allpeakgs) where the run stops - ledge_piece"""
        on = lambda q: ledges.get(q) == way or K_(*q) == 'corner'        # (the lip runs on: a ledge, or its turn)
        for tex, pts in ledge_piece(way, on((x - abs(way[1]), y - abs(way[0]))), on((x + abs(way[1]), y + abs(way[0])))):
            poly(tex, [((x * 16 + u, LEDGE_KIT['y'], y * 16 + v), (s_, t_)) for u, v, s_, t_ in pts])

    for y in range(Z0, Z1):
        runs = []
        for x in range(X0, X1):
            k = K_(x, y)
            r = road_of(x, y)
            if k in ('water', 'rock', 'bridge', 'pen') or (x, y) in P.get('on_bridge', ()): tex = None
            elif r: tex = r
            else:
                nb = {rr: BS._sand_nb(sq, x, y) for rr, sq in roads.items()}
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
            if (k in ('grass', 'sand', 'pave', 'flower', 'stairs', 'lawn', 'bridge') and (x, y) not in P.get('bridge_closed', ())) or (x, y) in P.get('pen_open', ()): perm[i] = 0x0000
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
                perm[i] = 0x65 if K_(x, y + 1) in (None, 'house', 'woods', 'rock', 'fence', 'stone') and K_(x, y - 1) in ('grass', 'sand', 'pave', 'lawn', 'bridge') else 0x3E
            if (x, y) in edged:
                rr, nb = edged[(x, y)]
                if rr in EDGE_UNDER:        # (an edge HeartGold lays over its pavement - Vermilion's: the pavement under it)
                    flat(EDGE_UNDER[rr], x, y, x + 1, y + 1, 0)
                    lift = lambda pts: [((p_[0], p_[1] + 0.3, p_[2]), st) for p_, st in pts]
                    BS._sand_edge(lambda tex, pts, rr=rr: poly(rr if tex == 'road01_r' else tex, lift(pts)), nb, x, y)
                else:
                    BS._sand_edge(lambda tex, pts, rr=rr: poly(rr if tex == 'road01_r' else tex, pts), nb, x, y)
            if gst((x, y)).get('border') and K_(x, y) in EDGE:
                # (paving that meets the grass at a curb: a strip of HeartGold's along each side it meets anything else)
                cb = gst((x, y))['border']; c0, c1 = gst((x, y))['border_s']
                for dx, dz in ((0, 1), (1, 0), (-1, 0), (0, -1)):
                    n_ = (x + dx, y + dz)
                    if K_(*n_) in EDGE or n_ in rskin or K_(*n_) in ('house', 'door', None): continue
                    X, Z, Wc = x * 16, y * 16, 4
                    if dz:
                        zo = Z + (16 if dz > 0 else 0); zi = zo - dz * Wc
                        poly(cb, [((X, 0.3, zi), (c0, X)), ((X + 16, 0.3, zi), (c0, X + 16)), ((X + 16, 0.3, zo), (c1, X + 16)), ((X, 0.3, zo), (c1, X))])
                    else:
                        xo = X + (16 if dx > 0 else 0); xi = xo - dx * Wc
                        poly(cb, [((xi, 0.3, Z + 16), (c0, Z + 16)), ((xo, 0.3, Z + 16), (c1, Z + 16)), ((xo, 0.3, Z), (c1, Z)), ((xi, 0.3, Z), (c0, Z))])
            if (x, y) in street and gst((x, y)).get('curb'):
                # (a street's curb: a strip of HeartGold's along each side it meets the pavement)
                cb = gst((x, y))['curb']
                c0, c1 = gst((x, y)).get('curb_s', (0, 16))
                for dx, dz in ((0, 1), (1, 0), (-1, 0), (0, -1)):
                    n_ = (x + dx, y + dz)
                    if n_ in street or K_(*n_) not in EDGE: continue
                    X, Z, Wc = x * 16, y * 16, 5
                    if dz:
                        zo = Z + (16 if dz > 0 else 0); zi = zo - dz * Wc
                        q4 = [((X, 0.3, zi), (c0, X)), ((X + 16, 0.3, zi), (c0, X + 16)), ((X + 16, 0.3, zo), (c1, X + 16)), ((X, 0.3, zo), (c1, X))]
                    else:
                        xo = X + (16 if dx > 0 else 0); xi = xo - dx * Wc
                        q4 = [((xi, 0.3, Z + 16), (c0, Z + 16)), ((xo, 0.3, Z + 16), (c1, Z + 16)), ((xo, 0.3, Z), (c1, Z)), ((xi, 0.3, Z), (c0, Z))]
                    poly(cb, q4)
            if k == 'water':
                # the water: its middle in runs; a bank down into it along each side it meets land (a strip of
                # HeartGold's bank a side: laid by distance a thin channel came to thousands of polygons a land)
                open_water.setdefault(y, []).append(x)
                for dx, dz in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                    if (x + dx, y + dz) in water or K_(x + dx, y + dz) in (None, 'bridge'): continue
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
                    ground = rr or GROUND
                    look = dict(R.LOOK, foot='wall01_h' if rr else 'wall01_g')
                    ck, what = K.classify(lower)
                    if ck == 'straight':        # (straight faces in runs along their row or column: a quad a band)
                        faces.setdefault((what, look['foot'], y if what[1] else x), []).append((x, y))
                    else:
                        piece(x, y, R.rock_piece(lower, x, y, BS.LAND_NARC, look), 0, ground)
            if (x, y) in ledges:          # (a ledge: HeartGold's lip painted on the ground - ledge())
                ledge(x, y, ledges[(x, y)])
            elif k == 'corner':           # (the turn of a ledge)
                for tex, pts in LEDGE_KIT['corners'][ledge_corner_key(ledges, x, y)]:
                    poly(tex, [((x * 16 + u, LEDGE_KIT['y'], y * 16 + v), (s_, t_)) for u, v, s_, t_ in pts])
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
            elif k == 'bed':
                planter(x, y)
            elif k == 'lamp':
                props.append((LAMP_MODEL, U(x + 0.5, ox), 0, U(y + 0.6, oz)))
            elif k == 'statue' and K_(x - 1, y) != 'statue' and K_(x, y - 1) != 'statue':
                statue(x, y, STATUES.get(owner.get((x, y)), 'cv_roserade'))
            if k == 'hedge' or (x, y) in P['loose']: BS._card(poly, 'bush', x, y)
            elif k == 'stone': BS._card(poly, 'stone', x, y)
            elif k == 'fence':
                if K_(x - 1, y) == 'fence' or K_(x + 1, y) == 'fence': BS._card(poly, 'fence', x, y)
                else: BS._card(poly, 'post', x, y)
            elif k == 'sign':
                props.append((SIGN_MODEL, U(x + 0.5, ox), 0, U(y + 0.35, oz)))
    for y, xs in open_water.items():         # (open water, in runs: the water as the pond's middle has it; the sea
        sea_xs = [x for x in xs if (x, y) in P.get('sea', ())]          # HeartGold's sea, its clear layer over it)
        riv = [x for x in xs if x not in sea_xs and owner.get((x, y)) in RIVERS]       # (HeartGold's rivers: its river)
        for a, b in BS._runs(sorted(set(xs) - set(sea_xs) - set(riv))): flat('pond_on', a, y, b, y + 1, R.WATER_Y)
        for a, b in BS._runs(sorted(riv)): flat('river', a, y, b, y + 1, R.WATER_Y)
        for a, b in BS._runs(sorted(sea_xs)):
            flat('sea_un', a, y, b, y + 1, R.WATER_Y - 1); flat('sea_on', a, y, b, y + 1, R.WATER_Y)
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
    BR = lambda x, y: K_(x, y) == 'bridge' or (x, y) in P.get('on_bridge', ())

    def boardwalk(x, y):
        """a square of a boardwalk's planks, laid as HeartGold lays Route 12's (read off its own: hg_kit's): across
        the walkway its trims (bridge_b, half a square each side), between them its deck (bridge_c, the planks' V across
        the whole width), along it the texture running on; a side over the water its face down to the water"""
        run = lambda dx, dz: next((k for k in range(1, 8) if not BR(x + dx * k, y + dz * k)), 8) - 1
        along_x = run(1, 0) + run(-1, 0) >= run(0, 1) + run(0, -1)
        if along_x: a_, b_ = run(0, -1), run(0, 1)       # (squares across, each side)
        else: a_, b_ = run(-1, 0), run(1, 0)
        Wu = (a_ + b_ + 1) * 16
        u0 = a_ * 16
        def P3(u, along, h):         # (u across from the walkway's -across edge, along in world units)
            if along_x: return (along, h, y * 16 - u0 + u)
            return (x * 16 - u0 + u, h, along)
        al0, al1 = (x * 16, x * 16 + 16) if along_x else (y * 16, y * 16 + 16)
        cuts = sorted({u0, u0 + 16} | {u for u in (8, Wu - 8) if u0 < u < u0 + 16})
        for ua, ub in zip(cuts, cuts[1:]):
            um = (ua + ub) / 2
            if um < 8 or um > Wu - 8:       # (a trim: bridge_b's planks, s from its outer edge in)
                sf = lambda u: 8.0 - 7.8 * (u / 8 if u < 8 else (Wu - u) / 8)
                tex, S, T = 'bridge_b', sf, lambda al: al / 2
            else:
                tex, S, T = 'bridge_c', (lambda u: -(u - 8) * 32 / max(16, Wu - 16)), (lambda al: al)
            poly(tex, [(P3(ua, al0, 2), (S(ua), T(al0))), (P3(ub, al0, 2), (S(ub), T(al0))), (P3(ub, al1, 2), (S(ub), T(al1))), (P3(ua, al1, 2), (S(ua), T(al1)))])
        sides(x, y)

    def sides(x, y):
        """a boardwalk square's sides and ends over the water: bridge_b's face, down to under the water's top"""
        for dx, dz in ((0, 1), (0, -1), (1, 0), (-1, 0)):
            if BR(x + dx, y + dz): continue
            if dz: zz = y * 16 + (16 if dz > 0 else 0); A, B = (x * 16, zz), (x * 16 + 16, zz)
            else: xx = x * 16 + (16 if dx > 0 else 0); A, B = (xx, y * 16), (xx, y * 16 + 16)
            ta, tb = (A[0] if dz else A[1]) / 2, (B[0] if dz else B[1]) / 2
            poly('bridge_b', [((A[0], 2, A[1]), (8.0, ta)), ((B[0], 2, B[1]), (8.0, tb)), ((B[0], R.WATER_Y - 1, B[1]), (15.7, tb)), ((A[0], R.WATER_Y - 1, A[1]), (15.7, ta))])
    BR_at = lambda x, y: (lambda a, b: BR(x + a, y + b))
    # the walkways: HeartGold's own, a piece to a square by the walkway round it (hg_kit), their decks just above
    # the ground, the water under them
    for y in range(Z0, Z1):
        for x in range(X0, X1):
            if not BR(x, y): continue
            kit = KIT(P['bridge_kit'].get((x, y), 'boardwalk'))
            if P['bridge_kit'].get((x, y), 'boardwalk') == 'boardwalk' and P['bridge_cls'].get((x, y)) != 'crate':
                boardwalk(x, y)
            else:
                dy = 2 - kit['top']
                for tex, pts in hg_kit.pick(kit, BR_at(x, y), P['bridge_cls'].get((x, y)), P['bridge_pos'].get((x, y))):
                    if P['bridge_cls'].get((x, y)) == 'crate' and not all(abs(p_[1] - 2) < 0.2 for p_ in pts): continue   # (its top)
                    poly(tex, [((x * 16 + px, max(R.WATER_Y - 6, py + dy), y * 16 + pz), (s_, t_)) for px, py, pz, s_, t_ in pts])
                if P['bridge_cls'].get((x, y)) == 'crate': sides(x, y)
            if any((x + a, y + b) in P.get('sea', ()) for a, b in ((1, 0), (-1, 0), (0, 1), (0, -1))): P['sea'].add((x, y))
            if any(K_(x + a, y + b) == 'water' for a, b in ((1, 0), (-1, 0), (0, 1), (0, -1))): open_water.setdefault(y, []).append(x)
            else: flat(GROUND, x, y, x + 1, y + 1, 0)      # (a walkway on land: the ground under it)
    foam = {}
    for y in range(Z0, Z1):         # (the water round them: the decks' overhang; the sea splashing against them, as at
        for x in range(X0, X1):     # Pallet's shore - HeartGold's foam - along each side in runs)
            if K_(x, y) != 'water': continue
            nb = [(x + a, y + b) for a in (-1, 0, 1) for b in (-1, 0, 1) if BR(x + a, y + b)]
            if not nb: continue
            kit = KIT(P['bridge_kit'].get(nb[0], 'boardwalk'))
            dy = 2 - kit['top']
            for tex, pts in ([] if P['bridge_kit'].get(nb[0], 'boardwalk') == 'boardwalk' else hg_kit.pick(kit, BR_at(x, y), 'edge')):
                if tex == 'sea_line02': continue      # (its foam: ours, in runs)
                poly(tex, [((x * 16 + px, max(R.WATER_Y - 6, py + dy), y * 16 + pz), (s_, t_)) for px, py, pz, s_, t_ in pts])
            if (x, y) not in P.get('sea', ()): continue
            for dx, dz in ((0, 1), (0, -1), (1, 0), (-1, 0)):
                if BR(x + dx, y + dz): foam.setdefault(((dx, dz), y if dz else x), set()).add(x if dz else y)
    for ((dx, dz), line), al in foam.items():
        for a, b in BS._runs(sorted(al)):
            def FP(d, at, h):
                if dz: return (at * 16, h, (line + (1 - d if dz > 0 else d)) * 16)
                return ((line + (1 - d if dx > 0 else d)) * 16, h, at * 16)
            for (d0, h0, t0), (d1, h1, t1) in zip(SEA_EDGE, SEA_EDGE[1:]):
                poly('sea_line02', [(FP(d0, a, h0), (a * 16, t0)), (FP(d0, b, h0), (b * 16, t0)), (FP(d1, b, h1), (b * 16, t1)), (FP(d1, a, h1), (a * 16, t1))])
    # Fuchsia's pens: HeartGold's, stretched to the GBA's
    for px, pz, pw, ph, st_ in P.get('pens', ()):
        if not (X0 - 8 <= px < X1 and Z0 - 6 <= pz < Z1): continue
        stamp = KIT(st_)
        fx, fz = pw / stamp['size'][0], ph / stamp['size'][1]
        for tex, pts in stamp['polys']:
            q = [((px * 16 + vx * fx, vy, pz * 16 + vz * fz), (s_, t_)) for vx, vy, vz, s_, t_ in pts]
            mx, mz = sum(p_[0][0] for p_ in q) / len(q) / 16, sum(p_[0][2] for p_ in q) / len(q) / 16
            if mine(int(mx), int(mz)): poly(tex, q)
    for (bx, by) in P['trees']:
        if not mine(bx, by): continue
        poly('tree01_un', [((bx * 16, 0, by * 16 + 32), (0, 32)), ((bx * 16 + 32, 0, by * 16 + 32), (32, 32)), ((bx * 16 + 32, 0, by * 16), (32, 0)), ((bx * 16, 0, by * 16), (0, 0))])
        BS._card(poly, 'tree', bx, by)
    for mdl, px, pz, py, *sc in P['props']:
        if mine(int(px), int(pz)): props.append((mdl, U(px, ox), py, U(pz, oz)) + tuple(sc))
    order = [t for t in BS.FIRST if t in meshes] + [t for t in meshes if t not in BS.FIRST and t not in BS.ANIM]
    groups = [(t, t if t in meshes else 'pond_on', pal_of(t if t in meshes else 'pond_on'), meshes.get(t, Mesh()),
               {'repeat': 3, 'size': dims[t if t in meshes else 'pond_on']}) for t in BS.ANIM] + \
             [(t, t, pal_of(t), meshes[t], {'repeat': 0 if t in ('tree01gs', 'etc_a', 'rock01', 'fence_b', 'cv_roserade') else 3, 'size': dims[t]}) for t in order]
    model = build_model('cv_kanto_%d_%d' % (cx, cz), groups)
    model += b'\0' * (-len(model) % 4)
    f4 = lambda v: int(round(v * 4096))
    bld = b''.join(struct.pack('<I3i3i3i8x', m, f4(px), f4(py + base), f4(pz), 0, 0, 0, *[f4(v) for v in (sc[0] if sc else (1, 1, 1))])
                   for m, px, py, pz, *sc in props)
    KS = lambda x, y: {'rock': 'cliff', 'water': 'water'}.get(K_(x, y), 'grass')
    bdhc = BS._bdhc(KS, ox, oz, U, base)
    pm = struct.pack('<1024H', *perm)
    npoly = sum(len(m.quads) + len(m.tris) for m in meshes.values())
    return struct.pack('<4I2H', len(pm), len(bld), len(model), len(bdhc), 0x1234, 0) + pm + bld + model + bdhc, npoly, len(model)


# ---------------------------------------------------------------- into the game
WORLD_LAND_BASE = 1000      # our world's lands (interiors are 800 on); lands drawn the same are one land
WORLD_ALT = 0               # (the matrix's altitude moves a land's model but not the heights people stand at: ours are
WORLD_BASE = 16             # built at HeartGold's ground, 16, as Pallet's and Cinnabar's are)
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
        room = THROUGH[w['dest_map']][0] if w['dest_map'] in THROUGH else dest.get(w['dest_map'])
        if room is None or room in world_maps:
            skipped.append((d, w['dest_map'])); continue
        X = hdr_of[cell]
        G = (ORIGIN[0] * 32 + wx, ORIGIN[1] * 32 + wz)
        per[X].append({'x': G[0], 'z': G[1], 'header': room, 'anchor': 0, 'y': 0})
        by_room.setdefault(room, []).append((X, len(per[X]) - 1, G, w))
    gba_built = set(slots.ROOM_SLOTS.values())
    gdirs = gba_dirs()
    import port_map
    path_of = lambda m: os.path.join(slots.EVENT_DIR, slots.events_file(m))
    for room, outs in by_room.items():
        ev = json.load(open(path_of(room)))
        Rw = ev['warps']
        if room in gba_built or room.startswith('MAP_CANVAS_'):
            via = outs[0][3]['dest_map'] if outs[0][3]['dest_map'] in THROUGH else None
            gd = gdirs.get(THROUGH[via][1] if via else outs[0][3]['dest_map'])
            gws = gba_map.map_json(gd)['warp_events'] if gd else []
            if via:         # (onto the room's ways out to the map we pass by, all of them leading back to this door)
                back = [k for k, gw in enumerate(gws) if gw['dest_map'] == via and k < len(Rw)]
                X, i = outs[0][0], outs[0][1]
                for X_, i_, G_, w_ in outs: per[X_][i_]['anchor'] = back[0]
                for k in back:
                    Rw[k].update(header=X, anchor=i)
                    if (Rw[k]['x'], Rw[k]['z']) == (0, 0): Rw[k]['x'], Rw[k]['z'] = port_map.room_xy(gd)(gws[k]['x'], gws[k]['y'])
                json.dump(ev, open(path_of(room), 'w'), indent=4); open(path_of(room), 'a').write('\n')
                continue
            for X, i, G, w in outs:
                j = int(w['dest_warp_id'])
                if j >= len(Rw): skipped.append((room, 'warp %d' % j)); continue
                per[X][i]['anchor'] = j
                Rw[j].update(header=X, anchor=i)
                if (Rw[j]['x'], Rw[j]['z']) == (0, 0) and gd:      # (a way out the room's builder left unplaced: the GBA's square)
                    Rw[j]['x'], Rw[j]['z'] = port_map.room_xy(gd)(gws[j]['x'], gws[j]['y'])
            # the rest of the doormat leads out too (the GBA's mat squares that no door of ours leads to), and you come
            # in on the middle of a mat three or five wide (the Academy hall's) rather than its first square
            linked = sorted({int(w['dest_warp_id']) for *_, w in outs if int(w['dest_warp_id']) < len(Rw)})
            if gws and linked:
                j0 = linked[0]
                mat = sorted((k for k, gw in enumerate(gws) if k < len(Rw) and gw['dest_map'] == gws[j0]['dest_map']
                              and gw['y'] == gws[j0]['y'] and abs(gw['x'] - gws[j0]['x']) <= len(gws)), key=lambda k: gws[k]['x'])
                for k in mat:
                    if k not in linked and (Rw[k]['x'], Rw[k]['z']) == (0, 0):
                        Rw[k].update(header=Rw[j0]['header'], anchor=Rw[j0]['anchor'])
                        Rw[k]['x'], Rw[k]['z'] = port_map.room_xy(gd)(gws[k]['x'], gws[k]['y'])
                if len(mat) >= 3 and len(mat) % 2 and len(outs) < len(mat) and all(int(o[3]['dest_warp_id']) in mat for o in outs):
                    for X, i, G, w in outs:
                        per[X][i]['anchor'] = mat[len(mat) // 2]
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
            if len(oc) > 1 and len(rc) > 1:
                # (a gatehouse: each door outside to the way out on its own side - west to west, east to east - by
                # where each lies from the middle of its doors. More doors outside than in (the GBA's Route 16 gate,
                # two storeys of doors each side) share a way in; the way out goes to the first of them)
                mid = lambda cs: (sum(p[0] for c in cs for _, p in c) / sum(len(c) for c in cs), sum(p[1] for c in cs for _, p in c) / sum(len(c) for c in cs))
                rm, om = mid(rc), mid(oc)
                rdir = lambda c: (mid([c])[0] - rm[0], mid([c])[1] - rm[1])
                odir = lambda c: (mid([c])[0] - om[0], mid([c])[1] - om[1])
                dot = lambda a, b: a[0] * b[0] + a[1] * b[1]
                for o in oc:
                    r = max(rc, key=lambda r_: dot(odir(o), rdir(r_)))
                    for (X, i), _ in o: per[X][i]['anchor'] = r[0][0]
                for r in rc:
                    o = max(oc, key=lambda o_: dot(odir(o_), rdir(r)))
                    (X0, i0) = o[0][0]
                    for j, _ in r: Rw[j].update(header=X0, anchor=i0)
            else:
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


SEEN = 14


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
    at = [(m, px, pz) for m, px, pz, py, *_ in P['props']] + [({'sign': SIGN_MODEL, 'lamp': LAMP_MODEL}[k], x + 0.5, y + 0.5) for (x, y), k in P['kind'].items() if k in ('sign', 'lamp')]
    maps = sorted(set(hdr_of.values()))
    area_of, report = {}, []
    for n, X in enumerate(maps):
        mine = [c for c, m in hdr_of.items() if m == X]
        # (the models in its lands and those in the lands round them near enough to be seen from it - SEEN squares:
        # one the set lacks the game draws as model 0, an empty box, so 0 is in every set)
        models = {0} | {m for m, px, pz in at if any(c[0] * 32 - SEEN <= px < c[0] * 32 + 32 + SEEN and c[1] * 32 - SEEN <= pz < c[1] * 32 + 32 + SEEN for c in mine)}
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
                data, n, sz = build_land(P, cx, cz, 0)
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
               'custom': ['%d,%d' % (ORIGIN[0] + c[0], ORIGIN[1] + c[1]) for c in CUSTOM], 'woods': woods,
               'moved': {'%d,%d' % (ORIGIN[0] * 32 + a[0], ORIGIN[1] * 32 + a[1]): [ORIGIN[0] * 32 + b[0], ORIGIN[1] * 32 + b[1]]
                         for a, b in P['moved'].items()}},
              open(WORLD_JSON, 'w'), indent=1, sort_keys=True)
    print('world: %d lands (%d drawn alike shared), biggest model %d bytes; building sets up to %d models, %d bytes of textures'
          % (len(seen), CELLS[0] * CELLS[1] - len(CUSTOM) - len(seen), big, max(r[2] for r in rep), max(r[3] for r in rep)))
    for r in sorted(rep, key=lambda r: -r[3])[:6]: print('  ', r)
    for s_ in sorted(set(skipped)): print('  no door:', s_)


if __name__ == '__main__':
    main()
